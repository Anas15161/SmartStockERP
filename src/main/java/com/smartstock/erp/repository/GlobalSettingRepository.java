package com.smartstock.erp.repository;

import com.smartstock.erp.model.GlobalSetting;
import jakarta.enterprise.context.ApplicationScoped;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ApplicationScoped
public class GlobalSettingRepository extends GenericRepository<GlobalSetting, String> {

    public GlobalSettingRepository() {
        super(GlobalSetting.class);
    }

    public Map<String, String> getAllAsMap() {
        List<GlobalSetting> settings = findAll();
        Map<String, String> map = new HashMap<>();
        for (GlobalSetting setting : settings) {
            map.put(setting.getKey(), setting.getValue());
        }
        return map;
    }

    public String getValue(String key, String defaultValue) {
        GlobalSetting setting = findById(key);
        return setting != null ? setting.getValue() : defaultValue;
    }

    public void save(String key, String value, String description) {
        GlobalSetting setting = findById(key);
        if (setting == null) {
            create(new GlobalSetting(key, value, description));
        } else {
            setting.setValue(value);
            if (description != null) {
                setting.setDescription(description);
            }
            update(setting);
        }
    }
}
