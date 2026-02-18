package sn.esmt.cartographie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sn.esmt.cartographie.dto.UtilisateurDTO;
import sn.esmt.cartographie.exception.BadRequestException;
import sn.esmt.cartographie.exception.ResourceNotFoundException;
import sn.esmt.cartographie.model.auth.Role;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.repository.RoleRepository;
import sn.esmt.cartographie.repository.UtilisateurRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class UtilisateurService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<UtilisateurDTO> getAllUtilisateurs() {
        return utilisateurRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public UtilisateurDTO getUtilisateurById(Long id) {
        Utilisateur utilisateur = utilisateurRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé avec l'id: " + id));
        return convertToDTO(utilisateur);
    }

    public UtilisateurDTO createUtilisateur(UtilisateurDTO utilisateurDTO, String password) {
        if (utilisateurRepository.existsByEmail(utilisateurDTO.getEmail())) {
            throw new BadRequestException("Un utilisateur avec cet email existe déjà");
        }

        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setNom(utilisateurDTO.getNom());
        utilisateur.setEmail(utilisateurDTO.getEmail());
        utilisateur.setMotDePasse(passwordEncoder.encode(password));
        utilisateur.setInstitution(utilisateurDTO.getInstitution());

        if (utilisateurDTO.getRoleId() != null) {
            Role role = roleRepository.findById(utilisateurDTO.getRoleId())
                    .orElseThrow(() -> new ResourceNotFoundException("Rôle non trouvé"));
            utilisateur.setRole(role);
        } else {
            // Par défaut, attribuer le rôle CANDIDAT
            Role candidatRole = roleRepository.findByLibelle("CANDIDAT")
                    .orElseThrow(() -> new ResourceNotFoundException("Rôle CANDIDAT non trouvé"));
            utilisateur.setRole(candidatRole);
        }

        Utilisateur savedUtilisateur = utilisateurRepository.save(utilisateur);
        return convertToDTO(savedUtilisateur);
    }

    public UtilisateurDTO updateUtilisateur(Long id, UtilisateurDTO utilisateurDTO) {
        Utilisateur utilisateur = utilisateurRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé avec l'id: " + id));

        utilisateur.setNom(utilisateurDTO.getNom());
        utilisateur.setInstitution(utilisateurDTO.getInstitution());

        if (utilisateurDTO.getRoleId() != null) {
            Role role = roleRepository.findById(utilisateurDTO.getRoleId())
                    .orElseThrow(() -> new ResourceNotFoundException("Rôle non trouvé"));
            utilisateur.setRole(role);
        }

        Utilisateur updatedUtilisateur = utilisateurRepository.save(utilisateur);
        return convertToDTO(updatedUtilisateur);
    }

    public UtilisateurDTO getUtilisateurByEmail(String email) {
        Utilisateur utilisateur = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé avec l'email: " + email));
        return convertToDTO(utilisateur);
    }

    public UtilisateurDTO updateMyProfile(String email, UtilisateurDTO utilisateurDTO) {
        Utilisateur utilisateur = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé"));

        // Le candidat ne peut modifier que son nom et institution, pas son rôle
        if (utilisateurDTO.getNom() != null && !utilisateurDTO.getNom().isEmpty()) {
            utilisateur.setNom(utilisateurDTO.getNom());
        }
        if (utilisateurDTO.getInstitution() != null) {
            utilisateur.setInstitution(utilisateurDTO.getInstitution());
        }

        Utilisateur updatedUtilisateur = utilisateurRepository.save(utilisateur);
        return convertToDTO(updatedUtilisateur);
    }

    public void deleteUtilisateur(Long id) {
        if (!utilisateurRepository.existsById(id)) {
            throw new ResourceNotFoundException("Utilisateur non trouvé avec l'id: " + id);
        }
        utilisateurRepository.deleteById(id);
    }

    private UtilisateurDTO convertToDTO(Utilisateur utilisateur) {
        UtilisateurDTO dto = new UtilisateurDTO();
        dto.setId(utilisateur.getId());
        dto.setNom(utilisateur.getNom());
        dto.setEmail(utilisateur.getEmail());
        dto.setInstitution(utilisateur.getInstitution());

        if (utilisateur.getRole() != null) {
            dto.setRoleId(utilisateur.getRole().getId());
            dto.setRoleLibelle(utilisateur.getRole().getLibelle());
        }

        return dto;
    }
}
