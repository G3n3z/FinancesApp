package com.backendfinancesjpa.repository.dao;

public interface DAO<E> {

    DAO<E> openTransaction();
    DAO<E> commit();
    DAO<E> rollback();
    DAO<E> persist(E entity);

    DAO<E>persistAtomic(E entity);

}
