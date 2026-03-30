package com.smartstock.erp.repository;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.io.Serializable;
import java.util.List;
import java.util.function.Consumer;

public abstract class GenericRepository<T, ID extends Serializable> {

    @Inject
    protected EntityManager em;

    private final Class<T> entityClass;

    protected GenericRepository(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    public T create(T entity) {
        executeInTransaction(em -> em.persist(entity));
        return entity;
    }

    public T update(T entity) {
        executeInTransaction(em -> em.merge(entity));
        return entity;
    }

    public void delete(ID id) {
        executeInTransaction(em -> {
            T entity = findById(id);
            if (entity != null) {
                em.remove(entity);
            }
        });
    }

    public T findById(ID id) {
        return em.find(entityClass, id);
    }

    public List<T> findAll() {
        return em.createQuery("from " + entityClass.getName(), entityClass).getResultList();
    }

    protected void executeInTransaction(Consumer<EntityManager> action) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            action.accept(em);
            tx.commit();
        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        }
    }
}
