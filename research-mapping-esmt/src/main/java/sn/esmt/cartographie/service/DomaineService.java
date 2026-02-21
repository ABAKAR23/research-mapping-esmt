package sn.esmt.cartographie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sn.esmt.cartographie.exception.ResourceNotFoundException;
import sn.esmt.cartographie.model.projet.DomaineRecherche;
import sn.esmt.cartographie.repository.DomaineRechercheRepository;

import java.util.List;

@Service
@Transactional
public class DomaineService {

    @Autowired
    private DomaineRechercheRepository domaineRepository;

    public List<DomaineRecherche> getAllDomaines() {
        return domaineRepository.findAll();
    }

    public DomaineRecherche getDomaineById(Long id) {
        return domaineRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Domaine non trouvé avec l'id: " + id));
    }

    public DomaineRecherche createDomaine(DomaineRecherche domaine) {
        return domaineRepository.save(domaine);
    }

    public DomaineRecherche updateDomaine(Long id, DomaineRecherche domaineDetails) {
        DomaineRecherche domaine = getDomaineById(id);
        domaine.setNomDomaine(domaineDetails.getNomDomaine());
        domaine.setDescription(domaineDetails.getDescription());
        return domaineRepository.save(domaine);
    }

    public void deleteDomaine(Long id) {
        if (!domaineRepository.existsById(id)) {
            throw new ResourceNotFoundException("Domaine non trouvé avec l'id: " + id);
        }
        domaineRepository.deleteById(id);
    }
}
