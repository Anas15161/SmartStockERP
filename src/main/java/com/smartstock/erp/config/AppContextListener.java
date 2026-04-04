package com.smartstock.erp.config;

import com.smartstock.erp.repository.GlobalSettingRepository;
import jakarta.inject.Inject;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.Map;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Inject
    private GlobalSettingRepository settingRepository;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // We can't easily use @Inject in a Listener in all containers without extra config,
        // but since we are in a Jakarta EE environment with CDI, it should work.
        // If not, we can load it lazily in a Filter.
        refreshSettings(sce);
    }

    public void refreshSettings(ServletContextEvent sce) {
        try {
            Map<String, String> settings = settingRepository.getAllAsMap();
            sce.getServletContext().setAttribute("appSettings", settings);
            System.out.println("Global Settings loaded into ServletContext");
        } catch (Exception e) {
            System.err.println("Could not load settings on startup: " + e.getMessage());
        }
    }
}
