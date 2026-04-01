package com.smartstock.erp.repository;

import com.smartstock.erp.model.Product;
import jakarta.enterprise.context.RequestScoped;
import java.util.List;

@RequestScoped
public class ProductRepository extends GenericRepository<Product, Long> {

    public ProductRepository() {
        super(Product.class);
    }

    public List<Product> findLowStockProducts() {
        return em.createQuery("select p from Product p where p.stockQuantity <= p.alertThreshold", Product.class)
                .getResultList();
    }
}
