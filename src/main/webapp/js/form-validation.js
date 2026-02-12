// form-validation.js

// Validate Project Form
function validateProjectForm(form) {
    let isValid = true;
    clearErrors(form);

    // Validate project name
    if (!form.projectName.value) {
        showError(form.projectName, 'Project name is required.');
        isValid = false;
    }

    // Add more validations as necessary

    return isValid;
}

// Show Validation Error
function showError(input, message) {
    const errorElement = document.createElement('div');
    errorElement.classList.add('error');
    errorElement.innerText = message;
    input.parentNode.insertBefore(errorElement, input.nextSibling);
}

// Clear Validation Errors
function clearErrors(form) {
    const errorElements = form.querySelectorAll('.error');
    errorElements.forEach(error => error.remove());
}