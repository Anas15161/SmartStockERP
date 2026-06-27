package com.smartstock.erp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

@Entity
@Table(name = "GLOBAL_SETTINGS")
public class GlobalSetting implements Serializable {

    @Id
    @Column(name = "setting_key", length = 50)
    private String key;

    @NotNull
    @Size(max = 255)
    @Column(name = "setting_value", nullable = false)
    private String value;

    @Column(name = "description")
    private String description;

    public GlobalSetting() {
    }

    public GlobalSetting(String key, String value, String description) {
        this.key = key;
        this.value = value;
        this.description = description;
    }

    // Getters and Setters
    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
