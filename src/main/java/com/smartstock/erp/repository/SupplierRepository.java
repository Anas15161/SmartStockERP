package com.smartstock.erp.repository;

import com.smartstock.erp.model.Supplier;
import jakarta.enterprise.context.RequestScoped;

@RequestScoped
public class SupplierRepository extends GenericRepository<Supplier, Long> {

    public SupplierRepository() {
        super(Supplier.class);
    }
}
