package com.smartstock.erp.repository;

import com.smartstock.erp.model.Product;
import jakarta.enterprise.context.RequestScoped;

@RequestScoped
public class ProductRepository extends GenericRepository<Product, Long> {

    public ProductRepository() {
        super(Product.class);
    }
}
