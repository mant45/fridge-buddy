//# Form
function checkForm(){
    let term = document.getElementById("ingredient_entry").value;
    
    if(term===""){
        alert("Please Enter in term to search for.");
    }
    else{
        document.getElementById('submit').disabled = true;
        document.getElementById("results_heading").innerHTML = ("Results for: " + term);
        document.getElementById("results").classList.add("fadeIn");
    }
}

//When our submit button is clicked
document.getElementById('submit').addEventListener("click", function(){
    checkForm();
});