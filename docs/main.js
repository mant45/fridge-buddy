//# Form
function checkForm(){
    let term = document.getElementById("ingredient_entry").value;
    
    if(term===""){
        alert("Please Enter in term to search for.");
    }
    else{
        document.getElementById('submit').disabled = true;
        document.getElementById("results_heading").innerHTML = ("Results for: " + term);
        document.getElementById("results").classList.remove("fadeOut");
        document.getElementById("results").classList.add("fadeIn");
    }
}

//When our submit button is clicked
document.getElementById('submit').addEventListener("click", function(){
    checkForm();
});

document.getElementById('result_close').addEventListener("click", function(){
    document.getElementById('submit').disabled = false;
    document.getElementById("results").classList.remove("fadeIn");
    document.getElementById("results").classList.add("fadeOut");
});