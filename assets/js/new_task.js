import "tom-select";
import { handleDateInputChange , handleEstimationInput} from "./showing_task"

import TomSelect from "tom-select";
export function loadForm(){
    let contributorSelect = document.getElementById("contributorSelect");
    console.log(contributorSelect);
    let tom = new TomSelect(contributorSelect,{
        persist: false,
        createOnBlur: true,
        plugins: ['remove_button']
    });
    console.log(tom);
    var startDateInput = document.getElementById('start_date');
    var dueDateInput = document.getElementById('due_date');
    var estimationInput = document.getElementById("estimation_val");
    var titleInput = document.getElementById("title_i");
    var descriInput = document.getElementById("description");
    //evenement sur l'estimation
    estimationInput.addEventListener("input", handleEstimationInput);
    // Ajouter un écouteur d'événements pour surveiller les modifications dans le champ de date de début
    startDateInput.addEventListener('change', handleDateInputChange);
    // Ajouter un écouteur d'événements pour surveiller les modifications dans le champ de date d'échéance
    dueDateInput.addEventListener('change', handleDateInputChange);
    //ajouter un ecouteur sur l'input title
    titleInput.addEventListener('input', validateTitle);
    //ajouter une ecouteur sur l'input description
    descriInput.addEventListener('input', validateDescription);

    




}

function validateTitle() {
    let titleInput = document.getElementById("title_i");
    let errorLabel = document.getElementById("title_error");
    let titleVal = titleInput.value;
    if (isFieldEmpty(titleVal)) {
        errorLabel.textContent = "Cette champs ne peut pas etre vide!";
        errorLabel.style.visibility="";
        return false;
    }
    if (!isLengthValid(titleVal, 255)) {
        errorLabel.textContent = "valeur trop long";
        errorLabel.style.visibility="";
        return false;
    }
    else {
        errorLabel.textContent = "";
        errorLabel.style.visibility = "hidden";
        return true;
    }
        
    
        
}

function validateDescription() {
    let descriInput = document.getElementById("description");
    let errorLabel = document.getElementById("description_error");
    let descriVal = descriInput.value;
    if (isFieldEmpty(descriVal)) {
        errorLabel.textContent = "Cette champs ne peut pas etre vide!";
        errorLabel.style.visibility="";
        return false;
    }
    if (!isLengthValid(descriVal, 300)) {
        errorLabel.textContent = "valeur trop long";
        errorLabel.style.visibility="";
        return false;
    }
    return true;
}

function isFieldEmpty(value) {
    return value.trim() === '';
}

function isLengthValid(value , maxLength) {
    return value.length <= maxLength;
}