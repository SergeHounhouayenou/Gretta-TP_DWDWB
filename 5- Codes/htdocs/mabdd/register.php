<?php

?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>formulaire d'inscription</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
          rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" 
          crossorigin="anonymous">

    <link rel="stylesheet" href="register.css">
</head>

<body>

    <h2>Formulaire d'inscription</h2>

    <form class = "subscribFormLayout" id = "subscribForm" action="subscribtion.php" method="post" name = "subscribtion">
        <div class ="" id = ""><label class = "" id = "" for ="subscribtion" name="">Prénom </label></div>
        <input class= "" id = "" type = "text"> </input>

        <div class ="" id = ""><label class = "" id = "" for ="" name="">Couriel </label></div>
        <input class= "" id = "" type = "text"> </input>

        <div class ="" id = ""><label class = "" id = "" for ="" name="">Date de naissance </label></div>
        <input class= "" id = "userAge" type = "date"> </input>

        <div class ="" id = ""><label class = "" id = "" for ="" name="">Genre </label></div>
        <select class= "" id = "" type = "text" >
        <option class = "" id = ""> Faites votre choix</option> 
            <option class = "" id = ""> Masculin</option> 
            <option class = "" id = ""> Féminin</option> 
        </select>

        <div>
        <p class ="" id = ""><input class= "" id = "" type = "radio" name = "genderSelect"> </input><label class = "" id = "" for ="" name="">Je veux recevoir la newsletter </label></p>
        <p class ="" id = ""><input class= "" id = "" type = "radio" name = "genderSelect"> </input><label class = "" id = "" for ="" name="">Ca ne m'interresse pas </label></p>   
        <button class = "" id = ""> s'inscrire</button>
        </div>
    </form>

    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
            crossorigin="anonymous"></script>

    <script src="script.js"></script>
   
</body>
<!--
// Sécurisation des valeurs affichées : Utilisation de htmlspecialchars() pour éviter les injections XSS.
// Vérification de l'existence d'un produit avant son affichage : Empêche une erreur PHP si un article non défini est dans le panier.
// Ajout de data-article sur les éléments de la liste : Facilite la suppression dynamique avec JavaScript.
// Affichage conditionnel de la pop-up : Elle ne s'affiche que si le panier contient des articles.
-->
</html>


