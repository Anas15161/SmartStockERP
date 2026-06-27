package com.smartstock.erp.repository;

import com.smartstock.erp.model.Role;
import jakarta.enterprise.context.RequestScoped;
import jakarta.persistence.NoResultException;
import java.util.Optional;

/**
 * Repository pour la gestion des rôles utilisateurs.
 */
@RequestScoped
public class RoleRepository extends GenericRepository<Role, Long> {

    public RoleRepository() {
        super(Role.class);
    }

    /**
     * Recherche un rôle par son nom (insensible à la casse).
     *
     * @param name le nom du rôle (ex: "ADMIN", "MANAGER")
     * @return un Optional contenant le rôle s'il existe
     */
    public Optional<Role> findByName(String name) {
        try {
            Role role = em.createQuery(
                            "SELECT r FROM Role r WHERE UPPER(r.name) = UPPER(:name)",
                            Role.class)
                    .setParameter("name", name.trim())
                    .getSingleResult();
            return Optional.of(role);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }
}
