package sn.esmt.cartographie.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import sn.esmt.cartographie.model.auth.Role;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.model.projet.DomaineRecherche;
import sn.esmt.cartographie.repository.DomaineRechercheRepository;
import sn.esmt.cartographie.repository.RoleRepository;
import sn.esmt.cartographie.repository.UtilisateurRepository;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private DomaineRechercheRepository domaineRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Initialiser les rôles
        initRoles();
        
        // Initialiser les domaines
        initDomaines();
        
        // Créer un utilisateur admin par défaut
        initDefaultUsers();
    }

    private void initRoles() {
        if (roleRepository.count() == 0) {
            roleRepository.save(new Role("ADMIN"));
            roleRepository.save(new Role("GESTIONNAIRE"));
            roleRepository.save(new Role("CANDIDAT"));
            System.out.println("✓ Rôles initialisés");
        }
    }

    private void initDomaines() {
        if (domaineRepository.count() == 0) {
            DomaineRecherche ia = new DomaineRecherche();
            ia.setNomDomaine("Intelligence Artificielle");
            ia.setDescription("Projets de recherche en IA et Machine Learning");
            domaineRepository.save(ia);

            DomaineRecherche sante = new DomaineRecherche();
            sante.setNomDomaine("Santé");
            sante.setDescription("Projets de recherche en santé et biotechnologie");
            domaineRepository.save(sante);

            DomaineRecherche energie = new DomaineRecherche();
            energie.setNomDomaine("Énergie");
            energie.setDescription("Projets de recherche en énergies renouvelables");
            domaineRepository.save(energie);

            DomaineRecherche telecoms = new DomaineRecherche();
            telecoms.setNomDomaine("Télécommunications");
            telecoms.setDescription("Projets de recherche en télécommunications et réseaux");
            domaineRepository.save(telecoms);

            System.out.println("✓ Domaines de recherche initialisés");
        }
    }

    private void initDefaultUsers() {
        if (utilisateurRepository.count() == 0) {
            Role adminRole = roleRepository.findByLibelle("ADMIN")
                    .orElseThrow(() -> new RuntimeException("Role ADMIN not found"));

            Utilisateur admin = new Utilisateur();
            admin.setNom("Administrateur");
            admin.setEmail("admin@esmt.sn");
            admin.setMotDePasse(passwordEncoder.encode("admin123"));
            admin.setInstitution("ESMT");
            admin.setRole(adminRole);
            utilisateurRepository.save(admin);

            Role gestionnaireRole = roleRepository.findByLibelle("GESTIONNAIRE")
                    .orElseThrow(() -> new RuntimeException("Role GESTIONNAIRE not found"));

            Utilisateur gestionnaire = new Utilisateur();
            gestionnaire.setNom("Gestionnaire");
            gestionnaire.setEmail("manager@esmt.sn");
            gestionnaire.setMotDePasse(passwordEncoder.encode("manager123"));
            gestionnaire.setInstitution("ESMT");
            gestionnaire.setRole(gestionnaireRole);
            utilisateurRepository.save(gestionnaire);

            Role candidatRole = roleRepository.findByLibelle("CANDIDAT")
                    .orElseThrow(() -> new RuntimeException("Role CANDIDAT not found"));

            Utilisateur candidat = new Utilisateur();
            candidat.setNom("Candidat Test");
            candidat.setEmail("candidat@esmt.sn");
            candidat.setMotDePasse(passwordEncoder.encode("candidat123"));
            candidat.setInstitution("ESMT");
            candidat.setRole(candidatRole);
            utilisateurRepository.save(candidat);

            System.out.println("✓ Utilisateurs par défaut créés:");
            System.out.println("  - Admin: admin@esmt.sn / admin123");
            System.out.println("  - Manager: manager@esmt.sn / manager123");
            System.out.println("  - Candidat: candidat@esmt.sn / candidat123");
        }
    }
}
