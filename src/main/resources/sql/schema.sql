-- ================================================================
-- Database Schema for Research Mapping ESMT Application
-- Java EE Version with English Table Names
-- ================================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS esmt_research;
USE esmt_research;

-- ================================================================
-- Table: roles
-- ================================================================
CREATE TABLE IF NOT EXISTS roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT chk_role_libelle CHECK (libelle IN ('ADMIN', 'GESTIONNAIRE', 'CANDIDAT'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Table: users
-- ================================================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    password_hash VARCHAR(255),
    profile_picture_url VARCHAR(500),
    role_id BIGINT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE SET NULL,
    INDEX idx_users_email (email),
    INDEX idx_users_username (username),
    INDEX idx_users_role (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Table: research_domains
-- ================================================================
CREATE TABLE IF NOT EXISTS research_domains (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    color VARCHAR(7),
    icon VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_domain_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Table: research_projects
-- ================================================================
CREATE TABLE IF NOT EXISTS research_projects (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    domain_id BIGINT NOT NULL,
    responsible_user_id BIGINT NOT NULL,
    institution VARCHAR(255),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50) DEFAULT 'EN_COURS',
    budget_estimated DECIMAL(15, 2),
    advancement_level INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (domain_id) REFERENCES research_domains(id) ON DELETE RESTRICT,
    FOREIGN KEY (responsible_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_project_status CHECK (status IN ('EN_COURS', 'TERMINE', 'SUSPENDU')),
    CONSTRAINT chk_advancement CHECK (advancement_level BETWEEN 0 AND 100),
    INDEX idx_project_domain (domain_id),
    INDEX idx_project_responsible (responsible_user_id),
    INDEX idx_project_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Table: participation
-- ================================================================
CREATE TABLE IF NOT EXISTS participation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    project_id BIGINT NOT NULL,
    role VARCHAR(100),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES research_projects(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_project (user_id, project_id),
    INDEX idx_participation_user (user_id),
    INDEX idx_participation_project (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- Initial Data: Roles
-- ================================================================
INSERT INTO roles (libelle) VALUES ('ADMIN'), ('GESTIONNAIRE'), ('CANDIDAT')
ON DUPLICATE KEY UPDATE libelle=VALUES(libelle);

-- ================================================================
-- Initial Data: Research Domains
-- ================================================================
INSERT INTO research_domains (name, description, color, icon) VALUES
    ('Intelligence Artificielle', 'Recherche en IA, Machine Learning, Deep Learning', '#3498db', 'fa-brain'),
    ('Santé', 'Sciences de la santé, médecine, biotechnologie', '#e74c3c', 'fa-heartbeat'),
    ('Énergie', 'Énergies renouvelables, efficacité énergétique', '#f39c12', 'fa-bolt'),
    ('Télécommunications', 'Réseaux, 5G, IoT, cybersécurité', '#9b59b6', 'fa-signal'),
    ('Environnement', 'Changement climatique, écologie, développement durable', '#27ae60', 'fa-leaf')
ON DUPLICATE KEY UPDATE 
    description=VALUES(description), 
    color=VALUES(color), 
    icon=VALUES(icon);

-- ================================================================
-- Sample Admin User (password: admin123)
-- Note: This is a hashed password - change in production!
-- ================================================================
-- The password hash below is for demonstration only
-- In production, use AuthService.hashPassword() method
INSERT INTO users (username, email, first_name, last_name, password_hash, role_id, is_active)
SELECT 'admin', 'admin@esmt.sn', 'Admin', 'ESMT', 
    'dGVzdF9oYXNoX2NoYW5nZV9pbl9wcm9kdWN0aW9u', -- This is a placeholder, use proper hash
    (SELECT id FROM roles WHERE libelle = 'ADMIN'),
    TRUE
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');

-- ================================================================
-- End of Schema
-- ================================================================
