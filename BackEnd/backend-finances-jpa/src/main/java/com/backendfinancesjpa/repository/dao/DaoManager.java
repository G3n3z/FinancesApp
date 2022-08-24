package com.backendfinancesjpa.repository.dao;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class DaoManager<E> implements DAO<E>{

    private static EntityManagerFactory emf;
    private EntityManager em;
    private Class<E> classe;
    static {
        emf = Persistence.createEntityManagerFactory("default");
    }

    public DaoManager(Class<E> classe){
        em = emf.createEntityManager();
        this.classe = classe;
    }

    public DaoManager(){
        em = emf.createEntityManager();
        this.classe = null;
    }

    @Override
    public DAO<E> openTransaction() {
        em.getTransaction().begin();
        return this;
    }

    @Override
    public DAO<E> commit() {
        em.getTransaction().commit();
        return this;
    }
    @Override
    public DAO<E> rollback() {
        em.getTransaction().rollback();
        return this;
    }

    @Override
    public DAO<E> persistAtomic(E entity) {
        openTransaction().persist(entity).commit();
        return this;
    }

    @Override
    public DAO<E> persist(Object entity) {
        em.persist(entity);
        return this;
    }
}
