package com.finances.backend.data.sevices;

import com.finances.backend.data.conection.ConnectionFactory;
import com.finances.backend.data.entity.Entity;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class SqlEntityService {

    private String namesDefault[] = {"Continente", "Farmacia", "Levantamento ATM", "Transferência", "Outro"};

    public Entity getEntityFromResultSet(ResultSet res) {
        Entity entity = new Entity();
        try{
            entity.setId(res.getLong("id_entity"));
            entity.setName(res.getString("name_entity"));
        }catch (SQLException e){
            return null;
        }
        return entity;
    }

    public boolean createDefaultEntities(Connection connection, Long id_user) {
        String query = "Select id_entity from  entities where name_entity = ? ";
        String query2 = "INSERT INTO user_entity(id_user, id_entity) value (?,?)";
        PreparedStatement stm = null;
        ResultSet res;
        long idCategory;
        List<String> notInserts = new ArrayList<>();
        try {
            for (String s : namesDefault) {
                stm = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
                stm.setString(1, s);
                stm.execute();
                res = stm.getResultSet();
                if(res.next()){
                    idCategory = res.getLong(1);
                    stm = connection.prepareStatement(query2);
                    stm.setLong(1, id_user);
                    stm.setLong(2, idCategory);
                    stm.execute();
                }else {
                    notInserts.add(s);
                }

            }
        }catch (SQLException e){
            return false;
        }finally {
            assert stm != null;
            ConnectionFactory.closeStatement(stm);
        }
        if(notInserts.size() > 0){
            insertDefaultEntities(connection, notInserts);
            return false;
        }
        return true;
    }

    private void insertDefaultEntities(Connection connection, List<String> notInserts) {
        String query = "insert into entities(name_entity) values (?)";
        PreparedStatement stm = null;

        try {
            for (String s : notInserts) {
                stm = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
                stm.setString(1, s);
                stm.execute();
            }

        }catch (SQLException ignored){
        }finally {
            assert stm != null;
            ConnectionFactory.closeStatement(stm);
        }

    }

    public Entity getEntityByNameAndUserID(Connection connection, long userId, String entity) {

        String query = "select *  from entities, user_entity where user_entity.id_user = ? and user_entity.id_entity = entities.id_entity" +
                " and upper( entities.name_entity) = ?";
        PreparedStatement stm = null;
        try {
            stm = connection.prepareStatement(query);
            stm.setLong(1, userId);
            stm.setString(2, entity.toUpperCase());
            stm.execute();
            ResultSet res = stm.getResultSet();
            if (res.next()){
                return getEntityFromResultSet(res);
            }

        }catch (SQLException e){
            return null;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }
        return null;
    }


    public List<Entity> getEntitiesByUserId(Long idUser, Connection connection) {
        String query = "select *  from entities, user_entity where user_entity.id_user = ? and user_entity.id_entity = entities.id_entity";
        PreparedStatement stm = null;
        List<Entity> entities = new ArrayList<>();
        try {
            stm = connection.prepareStatement(query);
            stm.setLong(1, idUser);
            stm.execute();
            ResultSet res = stm.getResultSet();
            while (res.next()){
                 entities.add(getEntityFromResultSet(res));
            }

        }catch (SQLException e){
            return null;
        }finally {
            if(stm != null)
                ConnectionFactory.closeStatement(stm);
        }
        return entities;
    }
}
