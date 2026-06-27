package com.smartstock.erp.model;

import jakarta.persistence.*;
import java.io.Serializable;

/**
 * Entité représentant un rôle utilisateur dans le système RBAC.
 * Les rôles définissent les permissions d'accès aux différentes fonctionnalités de l'ERP.
 */
@Entity
@Table(name = "SS_ROLES")
public class Role implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "role_seq")
    @SequenceGenerator(name = "role_seq", sequenceName = "SS_ROLES_SEQ", allocationSize = 1)
    private Long id;

    /**
     * Nom du rôle (ex: ADMIN, MANAGER, OPERATOR).
     * Doit être unique dans la base de données.
     */
    @Column(name = "role_name", nullable = false, unique = true, length = 50)
    private String name;

    @Column(name = "description", length = 255)
    private String description;

    public Role() {}

    public Role(String name, String description) {
        this.name = name;
        this.description = description;
    }

    // -------------------------------------------------------------------------
    // Getters et Setters
    // -------------------------------------------------------------------------

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() {
        return "Role{id=" + id + ", name='" + name + "'}";
    }
}
