package sn.esmt.cartographie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import sn.esmt.cartographie.model.auth.Role;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    
    Optional<Role> findByLibelle(String libelle);
    
    boolean existsByLibelle(String libelle);
}