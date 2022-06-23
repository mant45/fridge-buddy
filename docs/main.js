//# Form
function checkForm(){
    let term = document.getElementById("ingredient_entry").value;
    
    if(term===""){
        alert("Please Enter in term to search for.");
    }
    else{
        const base_url = 'https://87l15auac6.execute-api.eu-west-1.amazonaws.com/getrecipe?ingredient=';
        term = encodeURIComponent(term)
        var fetch_url = base_url + term;
        console.log(fetch_url)
        
        fetch(fetch_url)
          .then(response => response.json())
          .then(data => display_results(data))
        
        document.getElementById('submit').disabled = true;
        document.getElementById("results_heading").innerHTML = ("Results for: " + term);
        document.getElementById("results").classList.remove("fadeOut");
        document.getElementById("results").classList.add("fadeIn");
    }
}

function display_results(data){
  data.forEach(recipe =>{
    //Create our Button that will be used to expand the element.
    var item_button = document.createElement("BUTTON");
    item_button.classList.add('collapsible'); 
    item_button.textContent = recipe['recipe_heading'];
    item_button.addEventListener("click", button_click);
    document.getElementById("results_card").appendChild(item_button);

    // Create our Div to store our information
    var item_div = document.createElement('div');
    item_div.classList.add('content');

    // Create the contents of the div
    // Ingredients:
    item_heading_ingredients = document.createElement('h3');
    item_heading_ingredients.textContent = 'Ingredients:';
    item_div.appendChild(item_heading_ingredients);

    var item_ingredients_list = document.createElement('ul');
    for(i = 0; i < recipe['ingredients_main'].length; i++){
      var item_list_item = document.createElement('li');
      item_list_item.innerHTML = recipe['ingredients_main'][i];
      item_ingredients_list.appendChild(item_list_item);
    }
    item_div.appendChild(item_ingredients_list);

    // Ingredients Misc:
    item_heading_ingredients_misc = document.createElement('h3');
    item_heading_ingredients_misc.textContent = 'Ingredients Misc:';
    item_div.appendChild(item_heading_ingredients_misc);

    var item_ingredients_list_misc = document.createElement('ul');
    for(i = 0; i < recipe['ingredients_misc'].length; i++){
      var item_list_item_misc = document.createElement('li');
      item_list_item_misc.innerHTML = recipe['ingredients_misc'][i];
      item_ingredients_list_misc.appendChild(item_list_item_misc);
    }
    item_div.appendChild(item_ingredients_list_misc);

    //Instructions

    item_heading_instructions = document.createElement('h3');
    item_heading_instructions.textContent = 'Instructions:';
    item_div.appendChild(item_heading_instructions);

    var item_instructions_list= document.createElement('ul');
    for(i = 0; i < recipe['recipe_instructions'].length; i++){
      console.log(recipe['recipe_instructions'][i])
      var item_list_instructions = document.createElement('li');
      item_list_instructions.innerHTML = recipe['recipe_instructions'][i];
      item_instructions_list.appendChild(item_list_instructions);
    }
    item_div.appendChild(item_instructions_list);


    document.getElementById("results_card").appendChild(item_div);
  })
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
function button_click(){
  this.classList.toggle("active");
    var content = this.nextElementSibling;
    if (content.style.maxHeight){
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    } 
}