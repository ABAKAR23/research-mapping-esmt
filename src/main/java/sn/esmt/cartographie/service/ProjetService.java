package sn.esmt.cartographie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sn.esmt.cartographie.dto.ProjetDTO;
import sn.esmt.cartographie.exception.ResourceNotFoundException;
import sn.esmt.cartographie.exception.UnauthorizedException;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.model.projet.DomaineRecherche;
import sn.esmt.cartographie.model.projet.Projet;
import sn.esmt.cartographie.model.projet.StatutProjet;
import sn.esmt.cartographie.repository.DomaineRechercheRepository;
import sn.esmt.cartographie.repository.ProjetRepository;
import sn.esmt.cartographie.repository.UtilisateurRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class ProjetService {

    @Autowired
    private ProjetRepository projetRepository;

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private DomaineRechercheRepository domaineRepository;

    public List<ProjetDTO> getAllProjets() {
        return projetRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<ProjetDTO> getMyProjects(String email) {
        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé"));

        // Si Admin ou Gestionnaire, ils voient tout ? Le cahier des charges dit
        // "Gestionnaire voit tout". Candidat voit ses projets.
        if (user.getRole().getLibelle().equals("ADMIN") || user.getRole().getLibelle().equals("GESTIONNAIRE")) {
            return getAllProjets();
        }

        return projetRepository.findByResponsableOrParticipant(user.getId()).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public ProjetDTO getProjetById(Long id) {
        Projet projet = projetRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Projet non trouvé avec l'id: " + id));
        return convertToDTO(projet);
    }

    public ProjetDTO createProjet(ProjetDTO projetDTO, String managerEmail) {
        Utilisateur manager = utilisateurRepository.findByEmail(managerEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé"));

        Projet projet = convertToEntity(projetDTO);
        projet.setResponsable_projet(manager); // L'utilisateur connecté est le responsable

        Projet savedProjet = projetRepository.save(projet);
        return convertToDTO(savedProjet);
    }

    public ProjetDTO updateProjet(Long id, ProjetDTO projetDTO, String email) {
        Projet projet = projetRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Projet non trouvé avec l'id: " + id));

        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé"));

        // Vérifier les permissions
        boolean isAdminOrManager = user.getRole().getLibelle().equals("ADMIN")
                || user.getRole().getLibelle().equals("GESTIONNAIRE");
        boolean isOwner = projet.getResponsable_projet().getId().equals(user.getId());

        if (!isAdminOrManager && !isOwner) {
            throw new UnauthorizedException("Vous n'êtes pas autorisé à modifier ce projet");
        }

        updateEntityFromDTO(projet, projetDTO);
        Projet updatedProjet = projetRepository.save(projet);
        return convertToDTO(updatedProjet);
    }

    public void deleteProjet(Long id, String email) {
        Projet projet = projetRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Projet non trouvé avec l'id: " + id));

        Utilisateur user = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Utilisateur non trouvé"));

        boolean isAdminOrManager = user.getRole().getLibelle().equals("ADMIN")
                || user.getRole().getLibelle().equals("GESTIONNAIRE");

        // Seul ADMIN et GESTIONNAIRE peuvent supprimer selon le code précédent, mais un
        // candidat devrait peut-être pouvoir supprimer SON projet ?
        // Le cahier des charges dit "Candidat ne peut PAS modifier les projets des
        // autres".
        // On va assumer que Candidat peut supprimer ses propres projets s'il est
        // responsable, sinon non.

        // MAIS le code précédent disait: "Seul ADMIN et GESTIONNAIRE peuvent
        // supprimer".
        // Je vais permettre au responsable aussi.
        boolean isOwner = projet.getResponsable_projet().getId().equals(user.getId());

        if (!isAdminOrManager && !isOwner) {
            throw new UnauthorizedException("Vous n'êtes pas autorisé à supprimer ce projet");
        }

        projetRepository.delete(projet);
    }

    public List<ProjetDTO> getProjetsByDomaine(Long domaineId) {
        return projetRepository.findByDomaineRechercheId(domaineId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<ProjetDTO> getProjetsByStatut(String statut) {
        StatutProjet statutProjet = StatutProjet.valueOf(statut.toUpperCase());
        return projetRepository.findByStatutProjet(statutProjet).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private ProjetDTO convertToDTO(Projet projet) {
        ProjetDTO dto = new ProjetDTO();
        dto.setProjectId(projet.getProject_id());
        dto.setTitreProjet(projet.getTitre_projet());
        dto.setDescription(projet.getDescription());
        dto.setDateDebut(projet.getDate_debut());
        dto.setDateFin(projet.getDate_fin());
        dto.setStatutProjet(projet.getStatut_projet() != null ? projet.getStatut_projet().name() : null);
        dto.setBudgetEstime(projet.getBudget_estime());
        dto.setInstitution(projet.getInstitution());
        dto.setNiveauAvancement(projet.getNiveau_avancement());

        if (projet.getDomaine_recherche() != null) {
            dto.setDomaineId(projet.getDomaine_recherche().getId());
            dto.setDomaineNom(projet.getDomaine_recherche().getNomDomaine());
        }

        if (projet.getResponsable_projet() != null) {
            dto.setResponsableId(projet.getResponsable_projet().getId());
            dto.setResponsableNom(projet.getResponsable_projet().getNom());
        }

        if (projet.getListe_participants() != null) {
            dto.setParticipantIds(projet.getListe_participants().stream()
                    .map(Utilisateur::getId)
                    .collect(Collectors.toList()));
            dto.setParticipantNames(projet.getListe_participants().stream()
                    .map(Utilisateur::getNom)
                    .collect(Collectors.toList()));
        }

        return dto;
    }

    private Projet convertToEntity(ProjetDTO dto) {
        Projet projet = new Projet();
        updateEntityFromDTO(projet, dto);
        return projet;
    }

    private void updateEntityFromDTO(Projet projet, ProjetDTO dto) {
        projet.setTitre_projet(dto.getTitreProjet());
        projet.setDescription(dto.getDescription());
        projet.setDate_debut(dto.getDateDebut());
        projet.setDate_fin(dto.getDateFin());

        if (dto.getStatutProjet() != null) {
            projet.setStatut_projet(StatutProjet.valueOf(dto.getStatutProjet().toUpperCase()));
        }

        projet.setBudget_estime(dto.getBudgetEstime());
        projet.setInstitution(dto.getInstitution());
        projet.setNiveau_avancement(dto.getNiveauAvancement());

        if (dto.getDomaineId() != null) {
            DomaineRecherche domaine = domaineRepository.findById(dto.getDomaineId())
                    .orElseThrow(() -> new ResourceNotFoundException("Domaine non trouvé"));
            projet.setDomaine_recherche(domaine);
        }

        // Responsable is handled separately in create/update logic usually, but we can
        // set it if provided and admin

        if (dto.getParticipantIds() != null && !dto.getParticipantIds().isEmpty()) {
            List<Utilisateur> participants = utilisateurRepository.findAllById(dto.getParticipantIds());
            projet.setListe_participants(participants);
        }
    }
}
