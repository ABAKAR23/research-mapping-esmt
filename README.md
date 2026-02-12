# Research Mapping ESMT - API Documentation

## Overview
Application de cartographie des projets de recherche de l'ESMT basée sur Spring Boot 3.x avec authentification OAuth 2.0 et JWT.

## Technologies
- Spring Boot 3.2.0
- Spring Security avec OAuth 2.0
- Spring Data JPA / Hibernate
- MySQL / H2 (dev)
- JWT pour l'authentification
- Swagger/OpenAPI pour la documentation
- Maven

## Architecture

### Packages
- `config/` - Configuration Spring & Security
- `entities/` - Entités JPA (Projet, Utilisateur, Role, DomaineRecherche)
- `services/` - Logique métier
- `rest/` - Contrôleurs REST
- `repository/` - Interfaces JPA
- `dto/` - Data Transfer Objects
- `exception/` - Exceptions personnalisées
- `utils/` - Utilitaires (JWT)

## Démarrage

### Prérequis
- Java 17+
- Maven 3.6+
- MySQL 8+ (ou utiliser H2 en mode dev)

### Configuration

#### Mode Production (MySQL)
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/cartographie_db
spring.datasource.username=root
spring.datasource.password=yourpassword
```

#### Mode Développement (H2)
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### Build et Exécution

```bash
# Compiler
mvn clean compile

# Lancer les tests
mvn test

# Packager l'application
mvn package

# Exécuter l'application
java -jar target/research-mapping-esmt.jar

# Ou avec Maven
mvn spring-boot:run
```

## API Endpoints

### Authentification

#### POST /auth/login
Connexion avec email/mot de passe
```json
{
  "email": "admin@esmt.sn",
  "password": "admin123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "type": "Bearer",
  "userId": 1,
  "email": "admin@esmt.sn",
  "role": "ADMIN"
}
```

#### GET /auth/validate
Valider un token JWT (Authorization: Bearer {token})

### Projets

#### GET /projects
Liste tous les projets (avec filtrage par rôle)
- **CANDIDAT**: Seulement ses projets
- **GESTIONNAIRE/ADMIN**: Tous les projets

#### GET /projects/{id}
Obtenir un projet par ID

#### POST /projects
Créer un nouveau projet (ADMIN/GESTIONNAIRE)
```json
{
  "titreProjet": "IA pour la Santé",
  "description": "Diagnostic automatisé",
  "dateDebut": "2024-01-01",
  "dateFin": "2024-12-31",
  "statutProjet": "EN_COURS",
  "budgetEstime": 5000000,
  "institution": "ESMT",
  "niveauAvancement": 45,
  "domaineId": 1,
  "responsableId": 1
}
```

#### PUT /projects/{id}
Mettre à jour un projet

#### DELETE /projects/{id}
Supprimer un projet (ADMIN/GESTIONNAIRE)

#### GET /projects/domaine/{domaineId}
Projets par domaine

#### GET /projects/statut/{statut}
Projets par statut (EN_COURS, TERMINE, SUSPENDU)

### Utilisateurs

#### GET /users
Liste tous les utilisateurs (ADMIN/GESTIONNAIRE)

#### GET /users/{id}
Obtenir un utilisateur par ID

#### POST /users
Créer un utilisateur (ADMIN)
```json
{
  "nom": "John Doe",
  "email": "john@esmt.sn",
  "institution": "ESMT",
  "roleId": 2
}
```

#### PUT /users/{id}
Mettre à jour un utilisateur (ADMIN)

#### DELETE /users/{id}
Supprimer un utilisateur (ADMIN)

### Statistiques

#### GET /statistics
Obtenir toutes les statistiques (ADMIN/GESTIONNAIRE)

**Response:**
```json
{
  "totalProjets": 10,
  "projetsParDomaine": {
    "IA": 3,
    "Santé": 4,
    "Énergie": 2,
    "Télécoms": 1
  },
  "projetsParStatut": {
    "EN_COURS": 6,
    "TERMINE": 3,
    "SUSPENDU": 1
  },
  "budgetTotal": 50000000,
  "tauxMoyenAvancement": 45.5
}
```

#### GET /statistics/budget-total
Obtenir le budget total

#### GET /statistics/projets-par-statut
Nombre de projets par statut

### Domaines

#### GET /domains
Liste tous les domaines

#### GET /domains/{id}
Obtenir un domaine par ID

#### POST /domains
Créer un domaine (ADMIN)

#### PUT /domains/{id}
Mettre à jour un domaine (ADMIN)

#### DELETE /domains/{id}
Supprimer un domaine (ADMIN)

### Health Check

#### GET /health
Vérifier l'état de l'application

## Profils d'Accès

### CANDIDAT
- Voir/modifier ses propres projets uniquement
- Voir les domaines de recherche

### GESTIONNAIRE
- Voir tous les projets
- Créer/modifier/supprimer des projets
- Affecter des participants
- Voir les statistiques
- Gérer les domaines

### ADMIN
- Accès complet
- Gérer les utilisateurs et rôles
- Toutes les permissions GESTIONNAIRE

## Utilisateurs par Défaut

Lors du premier démarrage, l'application crée automatiquement:

| Email | Mot de passe | Rôle |
|-------|--------------|------|
| admin@esmt.sn | admin123 | ADMIN |
| manager@esmt.sn | manager123 | GESTIONNAIRE |
| candidat@esmt.sn | candidat123 | CANDIDAT |

## Documentation Swagger

Une fois l'application démarrée, accédez à:
- **Swagger UI**: http://localhost:8080/api/swagger-ui.html
- **API Docs (JSON)**: http://localhost:8080/api/api-docs

## Tests

```bash
# Lancer tous les tests
mvn test

# Lancer les tests avec coverage
mvn test jacoco:report

# Lancer un test spécifique
mvn test -Dtest=StatistiqueServiceTest
```

Les tests utilisent H2 en mémoire et une configuration de sécurité simplifiée.

## OAuth 2.0 Configuration

Pour activer OAuth 2.0 avec Google:

1. Créer un projet dans Google Cloud Console
2. Activer Google+ API
3. Créer des credentials OAuth 2.0
4. Configurer les URLs de redirection autorisées:
   - http://localhost:8080/api/login/oauth2/code/google

5. Ajouter les credentials dans `application.properties`:
```properties
spring.security.oauth2.client.registration.google.client-id=YOUR_CLIENT_ID
spring.security.oauth2.client.registration.google.client-secret=YOUR_CLIENT_SECRET
```

## Import CSV

L'application supporte l'import de projets depuis un fichier CSV avec le format:
```csv
titre,description,date_debut,date_fin,statut,budget,institution,avancement
IA pour la Sante,Diagnostic automatisé,01/01/2024,31/12/2024,EN_COURS,5000000,ESMT,45
```

## Sécurité

- Authentification JWT avec expiration configurable
- Hash des mots de passe avec BCrypt
- Protection CSRF désactivée (API REST stateless)
- CORS configuré pour les origines autorisées
- Role-based access control (RBAC)

## Structure de la Base de Données

### Tables Principales
- `utilisateurs` - Informations des utilisateurs
- `roles` - Rôles système (ADMIN, GESTIONNAIRE, CANDIDAT)
- `projets` - Projets de recherche
- `domaines_recherche` - Domaines de recherche
- `projet_participants` - Table de jointure many-to-many

## Contribution

1. Fork le repository
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changes (`git commit -m 'Add some AmazingFeature'`)
4. Push la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## License

Apache 2.0
