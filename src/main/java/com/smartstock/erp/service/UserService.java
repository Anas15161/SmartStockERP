package com.smartstock.erp.service;

import com.smartstock.erp.exception.ApplicationException;
import com.smartstock.erp.model.Role;
import com.smartstock.erp.model.User;
import com.smartstock.erp.repository.RoleRepository;
import com.smartstock.erp.repository.UserRepository;
import com.smartstock.erp.util.PasswordUtil;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service métier pour la gestion des utilisateurs et l'authentification.
 *
 * <p>Ce service centralise toute la logique de sécurité : authentification,
 * hachage des mots de passe, gestion des comptes utilisateurs et des rôles.</p>
 */
@RequestScoped
public class UserService {

    @Inject
    private UserRepository userRepository;

    @Inject
    private RoleRepository roleRepository;

    // -------------------------------------------------------------------------
    // Authentification
    // -------------------------------------------------------------------------

    /**
     * Authentifie un utilisateur en vérifiant son e-mail et son mot de passe.
     *
     * <p>Le mot de passe fourni est comparé au hash BCrypt stocké en base de données.
     * En cas de succès, la date de dernière connexion est mise à jour.</p>
     *
     * @param email    l'adresse e-mail de l'utilisateur
     * @param password le mot de passe en clair saisi dans le formulaire
     * @return l'utilisateur authentifié
     * @throws ApplicationException si les identifiants sont invalides ou le compte inactif
     */
    public User authenticate(String email, String password) {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            throw new ApplicationException("Veuillez saisir votre e-mail et votre mot de passe.");
        }

        Optional<User> userOpt = userRepository.findByEmail(email);

        if (userOpt.isEmpty()) {
            // Message générique pour éviter l'énumération des comptes
            throw new ApplicationException("Identifiants invalides. Veuillez réessayer.");
        }

        User user = userOpt.get();

        if (!user.isActive()) {
            throw new ApplicationException("Ce compte est désactivé. Contactez l'administrateur.");
        }

        if (!PasswordUtil.verify(password, user.getPasswordHash())) {
            throw new ApplicationException("Identifiants invalides. Veuillez réessayer.");
        }

        // Mise à jour de la date de dernière connexion
        user.setLastLogin(LocalDateTime.now());
        userRepository.update(user);

        return user;
    }

    // -------------------------------------------------------------------------
    // Gestion des utilisateurs
    // -------------------------------------------------------------------------

    /**
     * Crée un nouvel utilisateur avec le mot de passe haché.
     *
     * @param fullName     nom complet de l'utilisateur
     * @param email        adresse e-mail (identifiant unique)
     * @param plainPassword mot de passe en clair (sera haché avant stockage)
     * @param roleName     nom du rôle à attribuer (ex: "ADMIN", "MANAGER", "OPERATOR")
     * @return l'utilisateur créé
     * @throws ApplicationException si l'e-mail est déjà utilisé ou le rôle inexistant
     */
    public User createUser(String fullName, String email, String plainPassword, String roleName) {
        if (userRepository.existsByEmail(email, null)) {
            throw new ApplicationException("Un utilisateur avec l'e-mail '" + email + "' existe déjà.");
        }

        Role role = roleRepository.findByName(roleName)
                .orElseThrow(() -> new ApplicationException("Rôle introuvable : " + roleName));

        String passwordHash = PasswordUtil.hash(plainPassword);
        User user = new User(fullName, email, passwordHash, role);
        return userRepository.create(user);
    }

    /**
     * Met à jour le mot de passe d'un utilisateur après vérification de l'ancien.
     *
     * @param userId          identifiant de l'utilisateur
     * @param currentPassword ancien mot de passe en clair
     * @param newPassword     nouveau mot de passe en clair
     * @throws ApplicationException si l'ancien mot de passe est incorrect
     */
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findById(userId);
        if (user == null) {
            throw new ApplicationException("Utilisateur introuvable.");
        }
        if (!PasswordUtil.verify(currentPassword, user.getPasswordHash())) {
            throw new ApplicationException("Le mot de passe actuel est incorrect.");
        }
        if (newPassword == null || newPassword.length() < 8) {
            throw new ApplicationException("Le nouveau mot de passe doit contenir au moins 8 caractères.");
        }
        user.setPasswordHash(PasswordUtil.hash(newPassword));
        userRepository.update(user);
    }

    /**
     * Récupère tous les utilisateurs actifs.
     */
    public List<User> getAllActiveUsers() {
        return userRepository.findAllActive();
    }

    /**
     * Active ou désactive un compte utilisateur.
     *
     * @param userId identifiant de l'utilisateur
     * @param active true pour activer, false pour désactiver
     */
    public void setUserActive(Long userId, boolean active) {
        User user = userRepository.findById(userId);
        if (user == null) {
            throw new ApplicationException("Utilisateur introuvable.");
        }
        user.setActive(active);
        userRepository.update(user);
    }
}
