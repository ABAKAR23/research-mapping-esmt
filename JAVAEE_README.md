# Java EE Implementation - Research Mapping ESMT

## Overview
This is a complete Java EE implementation for the Research Mapping ESMT application, using traditional Java EE technologies:
- **JPA/Hibernate** for ORM
- **JAX-RS (Jersey)** for REST API
- **Servlet API** for web configuration
- **MySQL** for database

This implementation coexists with the Spring Boot version in the same project.

## Architecture

### Package Structure
```
sn.esmt/
├── model/              # JPA entities (User, Role, ResearchProject, ResearchDomain, Participation)
├── dao/                # Data Access Objects with EntityManager
├── service/            # Business logic services
└── rest/               # JAX-RS REST resources
```

### Entities (sn.esmt.model)
- **User** - Maps to `users` table
- **Role** - Maps to `roles` table
- **ResearchDomain** - Maps to `research_domains` table
- **ResearchProject** - Maps to `research_projects` table
- **Participation** - Maps to `participation` table

### DAOs (sn.esmt.dao)
All DAOs use `EntityManager` for database operations:
- **UserDAO** - CRUD operations for users
- **RoleDAO** - Role management
- **ResearchProjectDAO** - Project management with queries
- **ResearchDomainDAO** - Domain management
- **ParticipationDAO** - Participation management

### Services (sn.esmt.service)
Business logic layer:
- **AuthService** - Authentication, password hashing, user registration
- **UserService** - User management operations
- **ProjectService** - Project CRUD with authorization checks
- **StatisticsService** - Analytics and statistics

### REST API (sn.esmt.rest)
JAX-RS resources accessible at `/api/javaee/*`:
- **AuthResource** - `/api/javaee/auth/*`
- **UserResource** - `/api/javaee/users/*`
- **ProjectResource** - `/api/javaee/projects/*`
- **StatisticsResource** - `/api/javaee/statistics/*`

## Configuration

### persistence.xml
Location: `src/main/resources/META-INF/persistence.xml`

Persistence unit: `research-pu`
```xml
<persistence-unit name="research-pu" transaction-type="RESOURCE_LOCAL">
    <!-- Configured with MySQL connection -->
</persistence-unit>
```

### web.xml
Location: `src/main/webapp/WEB-INF/web.xml`

Jersey servlet configured at `/api/javaee/*`

### Database Schema
Location: `src/main/resources/sql/schema.sql`

The schema creates the following tables:
- `roles` - User roles (ADMIN, GESTIONNAIRE, CANDIDAT)
- `users` - User accounts
- `research_domains` - Research domains
- `research_projects` - Research projects
- `participation` - Project participation records

## API Endpoints

### Authentication (`/api/javaee/auth`)

#### POST `/api/javaee/auth/login`
Login with username/email and password
```json
{
  "usernameOrEmail": "admin",
  "password": "admin123"
}
```

#### POST `/api/javaee/auth/register`
Register a new user
```json
{
  "username": "newuser",
  "email": "user@esmt.sn",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe"
}
```

#### POST `/api/javaee/auth/change-password`
Change user password
```json
{
  "userId": 1,
  "oldPassword": "old123",
  "newPassword": "new123"
}
```

### Users (`/api/javaee/users`)

- `GET /api/javaee/users` - Get all users
- `GET /api/javaee/users/{id}` - Get user by ID
- `GET /api/javaee/users/role/{roleLibelle}` - Get users by role
- `POST /api/javaee/users` - Create new user
- `PUT /api/javaee/users/{id}` - Update user
- `DELETE /api/javaee/users/{id}` - Delete user

### Projects (`/api/javaee/projects`)

- `GET /api/javaee/projects` - Get all projects
- `GET /api/javaee/projects/{id}` - Get project by ID
- `GET /api/javaee/projects/user/{userId}` - Get projects by user
- `GET /api/javaee/projects/domain/{domainId}` - Get projects by domain
- `GET /api/javaee/projects/status/{status}` - Get projects by status
- `POST /api/javaee/projects?userId={userId}` - Create project
- `PUT /api/javaee/projects/{id}?userId={userId}` - Update project
- `DELETE /api/javaee/projects/{id}?userId={userId}` - Delete project

### Statistics (`/api/javaee/statistics`)

- `GET /api/javaee/statistics` - Get all statistics
- `GET /api/javaee/statistics/total` - Get total projects count
- `GET /api/javaee/statistics/by-domain` - Get projects grouped by domain
- `GET /api/javaee/statistics/by-status` - Get projects grouped by status
- `GET /api/javaee/statistics/total-budget` - Get total budget
- `GET /api/javaee/statistics/average-advancement` - Get average advancement

## Setup Instructions

### 1. Database Setup
```bash
# Create database and tables
mysql -u root -p < src/main/resources/sql/schema.sql
```

Or manually:
```sql
CREATE DATABASE esmt_research;
-- Then run the schema.sql script
```

### 2. Configure Database Connection
Edit `src/main/resources/META-INF/persistence.xml`:
```xml
<property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/esmt_research"/>
<property name="javax.persistence.jdbc.user" value="root"/>
<property name="javax.persistence.jdbc.password" value="your_password"/>
```

### 3. Build the Application
```bash
mvn clean package
```

This creates `target/research-mapping-esmt.war`

### 4. Deploy to Tomcat
Copy the WAR file to Tomcat's `webapps` directory:
```bash
cp target/research-mapping-esmt.war /path/to/tomcat/webapps/
```

### 5. Access the API
Once deployed, the API is available at:
```
http://localhost:8080/research-mapping-esmt/api/javaee/
```

## Testing the API

### Using cURL

#### Login
```bash
curl -X POST http://localhost:8080/research-mapping-esmt/api/javaee/auth/login \
  -H "Content-Type: application/json" \
  -d '{"usernameOrEmail":"admin","password":"admin123"}'
```

#### Get All Projects
```bash
curl http://localhost:8080/research-mapping-esmt/api/javaee/projects
```

#### Get Statistics
```bash
curl http://localhost:8080/research-mapping-esmt/api/javaee/statistics
```

### Using Postman or Browser
Simply navigate to the endpoints in your browser or use Postman for POST/PUT/DELETE operations.

## Key Features

### Authentication
- Simple password hashing with SHA-256 and salt
- Login with username or email
- User registration with automatic role assignment
- Password change functionality

### Authorization
- Role-based access control (ADMIN, GESTIONNAIRE, CANDIDAT)
- Project ownership verification
- Permission checks for update/delete operations

### Data Management
- Full CRUD operations for all entities
- Query by various criteria (domain, status, user)
- Participation management
- Transaction management with JPA

### Statistics
- Project counts by domain and status
- Total budget calculation
- Average advancement level
- Comprehensive analytics

## Differences from Spring Boot Version

| Feature | Spring Boot | Java EE |
|---------|-------------|---------|
| DI Container | Spring | Manual instantiation |
| Data Access | Spring Data JPA | Manual DAO with EntityManager |
| REST Framework | Spring MVC | JAX-RS (Jersey) |
| Transaction | @Transactional | Manual transaction management |
| Configuration | application.properties | persistence.xml + web.xml |
| Security | Spring Security | Custom authentication |
| API Base Path | `/api/*` | `/api/javaee/*` |

## Notes

- Both implementations can coexist in the same project
- The Java EE version uses different entity classes in `sn.esmt.model` package
- Database tables are shared but with English names for Java EE version
- For production, consider using BCrypt for password hashing instead of SHA-256
- EntityManagerFactory instances should be properly closed when the application shuts down

## Troubleshooting

### Connection Issues
- Verify MySQL is running
- Check database credentials in persistence.xml
- Ensure database `esmt_research` exists

### Jersey Not Found
- Verify Jersey dependencies in pom.xml
- Check web.xml servlet configuration
- Ensure Jersey packages are scanned: `sn.esmt.rest`

### Hibernate Errors
- Check entity annotations
- Verify table names match database
- Enable `hibernate.show_sql` for debugging

## License
Apache 2.0
