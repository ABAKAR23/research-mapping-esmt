/**
 * Form Validation Module for ESMT Research Mapping Platform
 * Comprehensive client-side validation for all forms
 */

/**
 * Validate Project Form
 */
function validateProjectForm(form) {
    let isValid = true;
    clearErrors(form);
    
    // Validate title (5-200 characters)
    const titre = form.titre || form.querySelector('[name="titre"]');
    if (titre) {
        if (!titre.value || titre.value.trim().length === 0) {
            showError(titre, 'Le titre est obligatoire');
            isValid = false;
        } else if (titre.value.trim().length < 5) {
            showError(titre, 'Le titre doit contenir au moins 5 caractères');
            isValid = false;
        } else if (titre.value.trim().length > 200) {
            showError(titre, 'Le titre ne doit pas dépasser 200 caractères');
            isValid = false;
        } else {
            showSuccess(titre);
        }
    }
    
    // Validate description (20-1000 characters)
    const description = form.description || form.querySelector('[name="description"]');
    if (description) {
        if (!description.value || description.value.trim().length === 0) {
            showError(description, 'La description est obligatoire');
            isValid = false;
        } else if (description.value.trim().length < 20) {
            showError(description, 'La description doit contenir au moins 20 caractères');
            isValid = false;
        } else if (description.value.trim().length > 1000) {
            showError(description, 'La description ne doit pas dépasser 1000 caractères');
            isValid = false;
        } else {
            showSuccess(description);
        }
    }
    
    // Validate domain
    const domaine = form.domaineId || form.querySelector('[name="domaineId"]');
    if (domaine) {
        if (!domaine.value || domaine.value === '') {
            showError(domaine, 'Le domaine de recherche est obligatoire');
            isValid = false;
        } else {
            showSuccess(domaine);
        }
    }
    
    // Validate dates
    const dateDebut = form.dateDebut || form.querySelector('[name="dateDebut"]');
    const dateFin = form.dateFin || form.querySelector('[name="dateFin"]');
    
    if (dateDebut && dateFin) {
        if (!dateDebut.value) {
            showError(dateDebut, 'La date de début est obligatoire');
            isValid = false;
        } else if (!dateFin.value) {
            showError(dateFin, 'La date de fin est obligatoire');
            isValid = false;
        } else {
            const debut = new Date(dateDebut.value);
            const fin = new Date(dateFin.value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            // Check if dates are valid
            if (isNaN(debut.getTime())) {
                showError(dateDebut, 'Date de début invalide');
                isValid = false;
            } else if (isNaN(fin.getTime())) {
                showError(dateFin, 'Date de fin invalide');
                isValid = false;
            } else if (debut > fin) {
                showError(dateFin, 'La date de fin doit être postérieure à la date de début');
                isValid = false;
            } else if (debut < new Date('2000-01-01')) {
                showError(dateDebut, 'La date de début ne peut pas être avant l\'an 2000');
                isValid = false;
            } else {
                showSuccess(dateDebut);
                showSuccess(dateFin);
            }
        }
    }
    
    // Validate status
    const statut = form.statut || form.querySelector('[name="statut"]');
    if (statut) {
        if (!statut.value || statut.value === '') {
            showError(statut, 'Le statut est obligatoire');
            isValid = false;
        } else {
            showSuccess(statut);
        }
    }
    
    // Validate budget (positive number)
    const budget = form.budgetEstime || form.querySelector('[name="budgetEstime"]');
    if (budget) {
        if (!budget.value || budget.value.trim() === '') {
            showError(budget, 'Le budget estimé est obligatoire');
            isValid = false;
        } else {
            const budgetValue = parseFloat(budget.value);
            if (isNaN(budgetValue) || budgetValue < 0) {
                showError(budget, 'Le budget doit être un nombre positif');
                isValid = false;
            } else if (budgetValue === 0) {
                showError(budget, 'Le budget doit être supérieur à 0');
                isValid = false;
            } else {
                showSuccess(budget);
            }
        }
    }
    
    // Validate institution
    const institution = form.institution || form.querySelector('[name="institution"]');
    if (institution) {
        if (!institution.value || institution.value.trim().length === 0) {
            showError(institution, 'L\'institution est obligatoire');
            isValid = false;
        } else if (institution.value.trim().length < 3) {
            showError(institution, 'L\'institution doit contenir au moins 3 caractères');
            isValid = false;
        } else {
            showSuccess(institution);
        }
    }
    
    // Validate advancement level (0-100)
    const avancement = form.niveauAvancement || form.querySelector('[name="niveauAvancement"]');
    if (avancement) {
        if (!avancement.value || avancement.value.trim() === '') {
            showError(avancement, 'Le niveau d\'avancement est obligatoire');
            isValid = false;
        } else {
            const avancementValue = parseInt(avancement.value);
            if (isNaN(avancementValue) || avancementValue < 0 || avancementValue > 100) {
                showError(avancement, 'Le niveau d\'avancement doit être entre 0 et 100');
                isValid = false;
            } else {
                showSuccess(avancement);
            }
        }
    }
    
    // Validate responsable email
    const responsableEmail = form.responsableEmail || form.querySelector('[name="responsableEmail"]');
    if (responsableEmail) {
        if (!responsableEmail.value || responsableEmail.value.trim().length === 0) {
            showError(responsableEmail, 'L\'email du responsable est obligatoire');
            isValid = false;
        } else if (!isValidEmail(responsableEmail.value)) {
            showError(responsableEmail, 'Format d\'email invalide');
            isValid = false;
        } else {
            showSuccess(responsableEmail);
        }
    }
    
    // Validate participants emails (optional, but if provided must be valid)
    const participants = form.participantsEmails || form.querySelector('[name="participantsEmails"]');
    if (participants && participants.value.trim().length > 0) {
        const emails = participants.value.split(';').map(e => e.trim()).filter(e => e.length > 0);
        const invalidEmails = emails.filter(e => !isValidEmail(e));
        
        if (invalidEmails.length > 0) {
            showError(participants, `Emails invalides: ${invalidEmails.join(', ')}`);
            isValid = false;
        } else {
            showSuccess(participants);
        }
    }
    
    return isValid;
}

/**
 * Validate User Form
 */
function validateUserForm(form) {
    let isValid = true;
    clearErrors(form);
    
    // Validate full name
    const nom = form.nom || form.querySelector('[name="nom"]');
    if (nom) {
        if (!nom.value || nom.value.trim().length === 0) {
            showError(nom, 'Le nom complet est obligatoire');
            isValid = false;
        } else if (nom.value.trim().length < 3) {
            showError(nom, 'Le nom doit contenir au moins 3 caractères');
            isValid = false;
        } else {
            showSuccess(nom);
        }
    }
    
    // Validate email
    const email = form.email || form.querySelector('[name="email"]');
    if (email) {
        if (!email.value || email.value.trim().length === 0) {
            showError(email, 'L\'email est obligatoire');
            isValid = false;
        } else if (!isValidEmail(email.value)) {
            showError(email, 'Format d\'email invalide');
            isValid = false;
        } else {
            showSuccess(email);
        }
    }
    
    // Validate role
    const role = form.role || form.querySelector('[name="role"]');
    if (role) {
        if (!role.value || role.value === '') {
            showError(role, 'Le rôle est obligatoire');
            isValid = false;
        } else {
            showSuccess(role);
        }
    }
    
    // Validate institution
    const institution = form.institution || form.querySelector('[name="institution"]');
    if (institution) {
        if (!institution.value || institution.value.trim().length === 0) {
            showError(institution, 'L\'institution est obligatoire');
            isValid = false;
        } else {
            showSuccess(institution);
        }
    }
    
    return isValid;
}

/**
 * Validate email format
 */
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Show validation error
 */
function showError(input, message) {
    const formGroup = input.closest('.form-group') || input.parentElement;
    
    // Add error class to input
    input.classList.add('error');
    input.classList.remove('success');
    
    // Add error class to form group
    if (formGroup) {
        formGroup.classList.add('has-error');
        formGroup.classList.remove('has-success');
    }
    
    // Create or update error message
    let errorElement = formGroup?.querySelector('.error-message');
    if (!errorElement) {
        errorElement = document.createElement('div');
        errorElement.classList.add('error-message');
        if (formGroup) {
            formGroup.appendChild(errorElement);
        } else {
            input.parentNode.insertBefore(errorElement, input.nextSibling);
        }
    }
    errorElement.textContent = message;
    errorElement.style.display = 'block';
}

/**
 * Show validation success
 */
function showSuccess(input) {
    const formGroup = input.closest('.form-group') || input.parentElement;
    
    // Add success class to input
    input.classList.add('success');
    input.classList.remove('error');
    
    // Add success class to form group
    if (formGroup) {
        formGroup.classList.add('has-success');
        formGroup.classList.remove('has-error');
    }
    
    // Remove error message
    const errorElement = formGroup?.querySelector('.error-message');
    if (errorElement) {
        errorElement.style.display = 'none';
    }
}

/**
 * Clear all validation errors
 */
function clearErrors(form) {
    // Remove error classes from inputs
    const inputs = form.querySelectorAll('input, textarea, select');
    inputs.forEach(input => {
        input.classList.remove('error', 'success');
    });
    
    // Remove error classes from form groups
    const formGroups = form.querySelectorAll('.form-group');
    formGroups.forEach(group => {
        group.classList.remove('has-error', 'has-success');
    });
    
    // Remove all error messages
    const errorElements = form.querySelectorAll('.error-message');
    errorElements.forEach(error => {
        error.style.display = 'none';
    });
}

/**
 * Real-time validation setup
 */
function setupRealTimeValidation(form) {
    const inputs = form.querySelectorAll('input, textarea, select');
    
    inputs.forEach(input => {
        // Validate on blur
        input.addEventListener('blur', function() {
            if (this.value) {
                // Validate single field based on form type
                if (form.id === 'project-form') {
                    validateProjectField(this);
                } else if (form.id === 'user-form') {
                    validateUserField(this);
                }
            }
        });
        
        // Clear error on input
        input.addEventListener('input', function() {
            if (this.classList.contains('error')) {
                const formGroup = this.closest('.form-group') || this.parentElement;
                this.classList.remove('error');
                if (formGroup) {
                    formGroup.classList.remove('has-error');
                    const errorElement = formGroup.querySelector('.error-message');
                    if (errorElement) {
                        errorElement.style.display = 'none';
                    }
                }
            }
        });
    });
}

/**
 * Validate individual project field
 */
function validateProjectField(field) {
    const name = field.name;
    
    switch(name) {
        case 'titre':
            if (field.value.length < 5) {
                showError(field, 'Le titre doit contenir au moins 5 caractères');
            } else {
                showSuccess(field);
            }
            break;
        case 'description':
            if (field.value.length < 20) {
                showError(field, 'La description doit contenir au moins 20 caractères');
            } else {
                showSuccess(field);
            }
            break;
        case 'responsableEmail':
        case 'email':
            if (!isValidEmail(field.value)) {
                showError(field, 'Format d\'email invalide');
            } else {
                showSuccess(field);
            }
            break;
        case 'budgetEstime':
            if (parseFloat(field.value) <= 0) {
                showError(field, 'Le budget doit être supérieur à 0');
            } else {
                showSuccess(field);
            }
            break;
        case 'niveauAvancement':
            const val = parseInt(field.value);
            if (val < 0 || val > 100) {
                showError(field, 'Le niveau d\'avancement doit être entre 0 et 100');
            } else {
                showSuccess(field);
            }
            break;
    }
}

/**
 * Validate individual user field
 */
function validateUserField(field) {
    const name = field.name;
    
    switch(name) {
        case 'nom':
            if (field.value.length < 3) {
                showError(field, 'Le nom doit contenir au moins 3 caractères');
            } else {
                showSuccess(field);
            }
            break;
        case 'email':
            if (!isValidEmail(field.value)) {
                showError(field, 'Format d\'email invalide');
            } else {
                showSuccess(field);
            }
            break;
    }
}

/**
 * Disable submit button during submission
 */
function disableSubmitButton(form) {
    const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.dataset.originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Envoi en cours...';
    }
}

/**
 * Enable submit button after submission
 */
function enableSubmitButton(form) {
    const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
    if (submitBtn) {
        submitBtn.disabled = false;
        if (submitBtn.dataset.originalText) {
            submitBtn.innerHTML = submitBtn.dataset.originalText;
        }
    }
}

// Setup validation on page load
document.addEventListener('DOMContentLoaded', function() {
    // Setup project form validation
    const projectForm = document.getElementById('project-form');
    if (projectForm) {
        setupRealTimeValidation(projectForm);
        
        projectForm.addEventListener('submit', function(e) {
            if (!validateProjectForm(this)) {
                e.preventDefault();
                return false;
            }
        });
    }
    
    // Setup user form validation
    const userForm = document.getElementById('user-form');
    if (userForm) {
        setupRealTimeValidation(userForm);
        
        userForm.addEventListener('submit', function(e) {
            if (!validateUserForm(this)) {
                e.preventDefault();
                return false;
            }
        });
    }
});