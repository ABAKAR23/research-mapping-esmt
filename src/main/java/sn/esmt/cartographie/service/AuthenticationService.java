package sn.esmt.cartographie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import sn.esmt.cartographie.dto.LoginRequest;
import sn.esmt.cartographie.dto.TokenResponse;
import sn.esmt.cartographie.exception.UnauthorizedException;
import sn.esmt.cartographie.model.auth.Utilisateur;
import sn.esmt.cartographie.repository.UtilisateurRepository;
import sn.esmt.cartographie.utils.JwtUtil;

@Service
public class AuthenticationService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    public TokenResponse login(LoginRequest loginRequest) {
        Utilisateur utilisateur = utilisateurRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Email ou mot de passe invalide"));

        if (!passwordEncoder.matches(loginRequest.getPassword(), utilisateur.getMotDePasse())) {
            throw new UnauthorizedException("Email ou mot de passe invalide");
        }

        String token = jwtUtil.generateToken(utilisateur);
        String role = utilisateur.getRole() != null ? utilisateur.getRole().getLibelle() : "USER";

        return new TokenResponse(token, utilisateur.getId(), utilisateur.getEmail(), role);
    }

    public Utilisateur validateToken(String token) {
        String email = jwtUtil.extractEmail(token);
        return utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new UnauthorizedException("Token invalide"));
    }
}
