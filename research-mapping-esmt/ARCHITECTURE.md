# Java EE Implementation - Architecture Diagram

## Project Structure

```
research-mapping-esmt/
│
├── src/main/java/sn/esmt/
│   │
│   ├── model/                    # JPA Entities (5 files)
│   │   ├── User.java             → users table
│   │   ├── Role.java             → roles table
│   │   ├── ResearchDomain.java   → research_domains table
│   │   ├── ResearchProject.java  → research_projects table
│   │   └── Participation.java    → participation table
│   │
│   ├── dao/                      # Data Access Objects (5 files)
│   │   ├── UserDAO.java
│   │   ├── RoleDAO.java
│   │   ├── ResearchDomainDAO.java
│   │   ├── ResearchProjectDAO.java
│   │   └── ParticipationDAO.java
│   │
│   ├── service/                  # Business Logic (4 files)
│   │   ├── AuthService.java
│   │   ├── UserService.java
│   │   ├── ProjectService.java
│   │   └── StatisticsService.java
│   │
│   ├── rest/                     # REST API Resources (4 files)
│   │   ├── AuthResource.java
│   │   ├── UserResource.java
│   │   ├── ProjectResource.java
│   │   └── StatisticsResource.java
│   │
│   ├── util/                     # Utilities (1 file)
│   │   └── JPAUtil.java          (Singleton EntityManagerFactory)
│   │
│   └── cartographie/             # Spring Boot Implementation (existing)
│       └── [Spring Boot files]
│
├── src/main/resources/
│   ├── META-INF/
│   │   └── persistence.xml       # JPA Configuration
│   ├── sql/
│   │   └── schema.sql            # Database Schema
│   └── application.properties    # Spring Boot Config (existing)
│
├── src/main/webapp/
│   └── WEB-INF/
│       └── web.xml               # Servlet Configuration
│
├── pom.xml                       # Maven Dependencies
├── JAVAEE_README.md              # Setup & API Documentation
└── IMPLEMENTATION_SUMMARY.md     # Complete Implementation Guide
```

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                      REST API Layer                         │
│  (JAX-RS/Jersey) - /api/javaee/*                           │
│                                                             │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │ AuthResource │ │ UserResource │ │ProjectResource│       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
│  ┌──────────────────────┐                                  │
│  │ StatisticsResource   │                                  │
│  └──────────────────────┘                                  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     Service Layer                           │
│  (Business Logic)                                           │
│                                                             │
│  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐         │
│  │ AuthService │ │ UserService │ │ProjectService│         │
│  └─────────────┘ └─────────────┘ └──────────────┘         │
│  ┌───────────────────┐                                     │
│  │ StatisticsService │                                     │
│  └───────────────────┘                                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      DAO Layer                              │
│  (Data Access with EntityManager)                          │
│                                                             │
│  ┌─────────┐ ┌─────────┐ ┌──────────────────┐             │
│  │ UserDAO │ │ RoleDAO │ │ResearchProjectDAO│             │
│  └─────────┘ └─────────┘ └──────────────────┘             │
│  ┌──────────────────┐ ┌──────────────────┐                │
│  │ResearchDomainDAO │ │ParticipationDAO  │                │
│  └──────────────────┘ └──────────────────┘                │
│                                                             │
│  ┌─────────────────────────────────────┐                   │
│  │ JPAUtil (Singleton EMF Manager)     │                   │
│  └─────────────────────────────────────┘                   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     Entity Layer                            │
│  (JPA Entities)                                             │
│                                                             │
│  ┌──────┐ ┌──────┐ ┌────────────────┐ ┌──────────────┐    │
│  │ User │ │ Role │ │ResearchProject │ │ResearchDomain│    │
│  └──────┘ └──────┘ └────────────────┘ └──────────────┘    │
│  ┌──────────────┐                                          │
│  │Participation │                                          │
│  └──────────────┘                                          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Database Layer                           │
│  (MySQL - esmt_research)                                    │
│                                                             │
│  Tables:                                                    │
│  • users                                                    │
│  • roles                                                    │
│  • research_projects                                        │
│  • research_domains                                         │
│  • participation                                            │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow Example

### Example: Create a Research Project

```
1. HTTP Request
   POST /api/javaee/projects?userId=1
   Body: { "title": "AI Research", "description": "...", ... }
   │
   ▼
2. REST Layer (ProjectResource)
   - Validates request
   - Extracts userId from query params
   - Calls service layer
   │
   ▼
3. Service Layer (ProjectService)
   - Validates user exists (via UserDAO)
   - Validates domain exists (via ResearchDomainDAO)
   - Checks authorization
   - Creates project entity
   - Calls DAO layer
   │
   ▼
4. DAO Layer (ResearchProjectDAO)
   - Gets EntityManager from JPAUtil
   - Begins transaction
   - Persists entity
   - Commits transaction
   - Returns saved entity
   │
   ▼
5. Database Layer
   - INSERT INTO research_projects (...)
   - Returns generated ID
   │
   ▼
6. Response
   HTTP 201 Created
   Body: { "id": 123, "title": "AI Research", ... }
```

## API Endpoint Mapping

```
/api/javaee/
│
├── auth/
│   ├── POST /login              → AuthService.login()
│   ├── POST /register           → AuthService.register()
│   └── POST /change-password    → AuthService.changePassword()
│
├── users/
│   ├── GET    /                 → UserService.getAllUsers()
│   ├── GET    /{id}             → UserService.getUserById()
│   ├── GET    /role/{role}      → UserService.getUsersByRole()
│   ├── POST   /                 → UserService.createUser()
│   ├── PUT    /{id}             → UserService.updateUser()
│   └── DELETE /{id}             → UserService.deleteUser()
│
├── projects/
│   ├── GET    /                 → ProjectService.getAllProjects()
│   ├── GET    /{id}             → ProjectService.getProjectById()
│   ├── GET    /user/{userId}    → ProjectService.getProjectsByUser()
│   ├── GET    /domain/{id}      → ProjectService.getProjectsByDomain()
│   ├── GET    /status/{status}  → ProjectService.getProjectsByStatus()
│   ├── POST   /?userId={id}     → ProjectService.createProject()
│   ├── PUT    /{id}?userId={id} → ProjectService.updateProject()
│   └── DELETE /{id}?userId={id} → ProjectService.deleteProject()
│
└── statistics/
    ├── GET /                    → StatisticsService.getAllStatistics()
    ├── GET /total               → StatisticsService.getTotalProjects()
    ├── GET /by-domain           → StatisticsService.getProjectsByDomain()
    ├── GET /by-status           → StatisticsService.getProjectsByStatus()
    ├── GET /total-budget        → StatisticsService.getTotalBudget()
    └── GET /average-advancement → StatisticsService.getAverageAdvancement()
```

## Database Schema

```sql
┌──────────────┐
│    roles     │
├──────────────┤
│ id (PK)      │
│ libelle      │
└──────────────┘
       │
       │ 1:N
       │
       ▼
┌──────────────────────┐         ┌─────────────────────┐
│       users          │ 1:N     │ research_projects   │
├──────────────────────┤────────▶├─────────────────────┤
│ id (PK)              │         │ id (PK)             │
│ username             │         │ title               │
│ email                │         │ description         │
│ first_name           │         │ domain_id (FK)      │
│ last_name            │         │ responsible_user_id │
│ password_hash        │         │ institution         │
│ profile_picture_url  │         │ start_date          │
│ role_id (FK)         │         │ end_date            │
│ is_active            │         │ status              │
│ created_at           │         │ budget_estimated    │
│ updated_at           │         │ advancement_level   │
└──────────────────────┘         │ created_at          │
       │                         └─────────────────────┘
       │                                  │        ▲
       │ N:1                              │        │
       │                                  │ N:1    │ 1:N
       │                                  │        │
       │                         ┌────────▼────────┴────┐
       │                         │ research_domains     │
       │                         ├──────────────────────┤
       │                         │ id (PK)              │
       │                         │ name                 │
       │                         │ description          │
       │                         │ color                │
       │                         │ icon                 │
       │                         │ created_at           │
       │                         └──────────────────────┘
       │
       │
       │ N:M (via participation)
       │
       ▼
┌──────────────────────┐
│   participation      │
├──────────────────────┤
│ id (PK)              │
│ user_id (FK)         │
│ project_id (FK)      │
│ role                 │
│ joined_at            │
└──────────────────────┘
```

## Technology Stack

```
┌─────────────────────────────────────┐
│        Presentation Layer           │
│  REST API (JAX-RS/Jersey 3.1.3)    │
│  JSON (Jackson)                     │
└─────────────────────────────────────┘
                 │
┌─────────────────────────────────────┐
│         Application Layer           │
│  Servlet Container (Tomcat)        │
│  Web.xml Configuration              │
└─────────────────────────────────────┘
                 │
┌─────────────────────────────────────┐
│         Business Layer              │
│  Service Classes (Pure Java)       │
│  Transaction Management (Manual)   │
└─────────────────────────────────────┘
                 │
┌─────────────────────────────────────┐
│         Persistence Layer           │
│  JPA 2.2 / Hibernate 5.6+          │
│  EntityManager (Manual)             │
│  JPAUtil (Singleton EMF)           │
└─────────────────────────────────────┘
                 │
┌─────────────────────────────────────┐
│           Data Layer                │
│  MySQL 8+ Database                 │
│  JDBC Driver (MySQL Connector)     │
└─────────────────────────────────────┘
```

## File Counts

- **Entities**: 5 files
- **DAOs**: 5 files
- **Services**: 4 files
- **REST Resources**: 4 files
- **Utilities**: 1 file
- **Configuration**: 3 files (persistence.xml, web.xml, schema.sql)
- **Documentation**: 3 files (README, SUMMARY, ARCHITECTURE)

**Total**: 25 new Java EE files + configuration and documentation

## Key Features

✅ **Separation of Concerns**
- Clear layer separation (REST → Service → DAO → Entity)
- Each layer has a specific responsibility

✅ **Singleton Pattern**
- JPAUtil manages single EntityManagerFactory instance
- Optimal resource usage

✅ **Transaction Management**
- Manual transaction control in DAO layer
- Proper commit/rollback handling

✅ **RESTful Design**
- Standard HTTP methods (GET, POST, PUT, DELETE)
- Proper status codes (200, 201, 400, 401, 403, 404, 500)
- JSON request/response bodies

✅ **Security**
- Parameterized queries (SQL injection safe)
- Password hashing (SHA-256 with salt)
- Input validation

✅ **Error Handling**
- Try-catch blocks in all layers
- Proper exception messages
- HTTP status code mapping
