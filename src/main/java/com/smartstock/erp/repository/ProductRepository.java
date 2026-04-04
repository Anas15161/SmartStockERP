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
        return em.createQuery("select p from Product p where p.stockQuantity > 0 and p.stockQuantity <= p.alertThreshold", Product.class)
                .getResultList();
    }

    public List<Product> findFilteredPaginated(int page, int size, String label, Double minPrice, Double maxPrice, String status, Long supplierId, String supplierName) {
        StringBuilder hql = new StringBuilder("select p from Product p where 1=1");
        appendFilters(hql, label, minPrice, maxPrice, status, supplierId, supplierName);
        hql.append(" order by p.lastUpdated desc");

        jakarta.persistence.TypedQuery<Product> query = em.createQuery(hql.toString(), Product.class);
        setParameters(query, label, minPrice, maxPrice, status, supplierId, supplierName);

        return query.setFirstResult((page - 1) * size)
                .setMaxResults(size)
                .getResultList();
    }

    public long countFiltered(String label, Double minPrice, Double maxPrice, String status, Long supplierId, String supplierName) {
        StringBuilder hql = new StringBuilder("select count(p) from Product p where 1=1");
        appendFilters(hql, label, minPrice, maxPrice, status, supplierId, supplierName);

        jakarta.persistence.TypedQuery<Long> query = em.createQuery(hql.toString(), Long.class);
        setParameters(query, label, minPrice, maxPrice, status, supplierId, supplierName);

        return query.getSingleResult();
    }

    private void appendFilters(StringBuilder hql, String label, Double minPrice, Double maxPrice, String status, Long supplierId, String supplierName) {
        if (label != null && !label.trim().isEmpty()) {
            hql.append(" and lower(p.label) like :label");
        }
        if (minPrice != null) {
            hql.append(" and p.unitPrice >= :minPrice");
        }
        if (maxPrice != null) {
            hql.append(" and p.unitPrice <= :maxPrice");
        }
        if (supplierId != null && supplierId > 0) {
            hql.append(" and p.supplier.id = :supplierId");
        } else if (supplierName != null && !supplierName.trim().isEmpty() && !"all suppliers".equalsIgnoreCase(supplierName.trim())) {
            hql.append(" and lower(p.supplier.name) like :supplierName");
        }
        
        if ("out".equalsIgnoreCase(status)) {
            hql.append(" and p.stockQuantity <= 0");
        } else if ("low".equalsIgnoreCase(status)) {
            hql.append(" and p.stockQuantity > 0 and p.stockQuantity <= p.alertThreshold");
        } else if ("healthy".equalsIgnoreCase(status)) {
            hql.append(" and p.stockQuantity > p.alertThreshold");
        }
    }

    private void setParameters(jakarta.persistence.Query query, String label, Double minPrice, Double maxPrice, String status, Long supplierId, String supplierName) {
        if (label != null && !label.trim().isEmpty()) {
            query.setParameter("label", "%" + label.trim().toLowerCase() + "%");
        }
        if (minPrice != null) {
            query.setParameter("minPrice", java.math.BigDecimal.valueOf(minPrice));
        }
        if (maxPrice != null) {
            query.setParameter("maxPrice", java.math.BigDecimal.valueOf(maxPrice));
        }
        if (supplierId != null && supplierId > 0) {
            query.setParameter("supplierId", supplierId);
        } else if (supplierName != null && !supplierName.trim().isEmpty() && !"all suppliers".equalsIgnoreCase(supplierName.trim())) {
            query.setParameter("supplierName", "%" + supplierName.trim().toLowerCase() + "%");
        }
    }
}
