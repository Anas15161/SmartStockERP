package com.smartstock.erp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entité représentant un utilisateur du système SmartStockERP.
 * Le mot de passe est stocké sous forme hachée (BCrypt) et ne doit jamais
 * être exposé en clair dans les vues ou les logs.
 */
@Entity
@Table(name = "SS_USERS", indexes = {
        @Index(name = "IDX_USERS_EMAIL", columnList = "email", unique = true)
})
public class User implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_seq")
    @SequenceGenerator(name = "user_seq", sequenceName = "SS_USERS_SEQ", allocationSize = 1)
    private Long id;

    @NotNull
    @Size(min = 2, max = 100, message = "Le nom complet doit contenir entre 2 et 100 caractères")
    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @NotNull
    @Email(message = "L'adresse e-mail n'est pas valide")
    @Column(name = "email", nullable = false, unique = true, length = 150)
    private String email;

    /**
     * Mot de passe haché avec BCrypt. Ne jamais stocker en clair.
     */
    @NotNull
    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    /**
     * Indique si le compte est actif. Un compte désactivé ne peut pas se connecter.
     */
    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Rôle de l'utilisateur (relation Many-To-One : plusieurs utilisateurs peuvent avoir le même rôle).
     */
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    // -------------------------------------------------------------------------
    // Hooks JPA pour la gestion automatique des dates
    // -------------------------------------------------------------------------

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // -------------------------------------------------------------------------
    // Constructeurs
    // -------------------------------------------------------------------------

    public User() {}

    public User(String fullName, String email, String passwordHash, Role role) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.active = true;
    }

    // -------------------------------------------------------------------------
    // Getters et Setters
    // -------------------------------------------------------------------------

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    @Override
    public String toString() {
        return "User{id=" + id + ", email='" + email + "', role=" + (role != null ? role.getName() : "null") + "}";
    }
}
