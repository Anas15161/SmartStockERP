package com.smartstock.erp.repository;

import com.smartstock.erp.model.User;
import jakarta.enterprise.context.RequestScoped;
import jakarta.persistence.NoResultException;
import java.util.Optional;

/**
 * Repository pour la gestion des utilisateurs en base de données.
 * Fournit des méthodes d'accès aux données spécifiques à l'entité {@link User}.
 */
@RequestScoped
public class UserRepository extends GenericRepository<User, Long> {

    public UserRepository() {
        super(User.class);
    }

    /**
     * Recherche un utilisateur par son adresse e-mail (insensible à la casse).
     *
     * @param email l'adresse e-mail à rechercher
     * @return un Optional contenant l'utilisateur s'il existe, vide sinon
     */
    public Optional<User> findByEmail(String email) {
        try {
            User user = em.createQuery(
                            "SELECT u FROM User u JOIN FETCH u.role WHERE LOWER(u.email) = LOWER(:email)",
                            User.class)
                    .setParameter("email", email.trim())
                    .getSingleResult();
            return Optional.of(user);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    /**
     * Vérifie si un e-mail est déjà utilisé par un autre utilisateur.
     *
     * @param email l'adresse e-mail à vérifier
     * @param excludeId l'identifiant de l'utilisateur à exclure (utile lors d'une mise à jour)
     * @return true si l'e-mail est déjà utilisé, false sinon
     */
    public boolean existsByEmail(String email, Long excludeId) {
        Long count = em.createQuery(
                        "SELECT COUNT(u) FROM User u WHERE LOWER(u.email) = LOWER(:email) AND u.id <> :excludeId",
                        Long.class)
                .setParameter("email", email.trim())
                .setParameter("excludeId", excludeId != null ? excludeId : -1L)
                .getSingleResult();
        return count > 0;
    }

    /**
     * Récupère tous les utilisateurs actifs.
     */
    public java.util.List<User> findAllActive() {
        return em.createQuery(
                        "SELECT u FROM User u JOIN FETCH u.role WHERE u.active = true ORDER BY u.fullName",
                        User.class)
                .getResultList();
    }
}
