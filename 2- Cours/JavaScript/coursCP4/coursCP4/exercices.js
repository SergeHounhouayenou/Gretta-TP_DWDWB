// Correction exercice 4

//Demande à l'utilisateur de saisir un nombre
// Fonctions de conversion de type : parseInt, parseFloat,
// Number
let n = Number(prompt("Saisir  un nombre"));
console.log(typeof n);
//Verifier que la saisie est valide
if (isNaN(n) || n<=0){
    console.log("Erreur: veuillez entrer un nombre entier positif");
}else{
    //Boucle for pour afficher les nombres de 1 à n
    for (let i=1; i <= n; i++){
        // Vérifier des multiples
        if (i%3==0 && i%5==0){
            console.log("FizzBuzz");
        }else if (i%3==0){
            console.log("Fizz");
        }else if (i%5==0){
            console.log("Buzz");
        }else{
            console.log(i)
        }
    }
}


// Exercice 5
let mot; //undefined
console.log(mot);

//Boucle while : tant que le mot saisi n'est pas stop
while(mot?.toLowerCase() != "stop"){
    mot = prompt("Saisir un mot (stop pour arreter)");
    //Vérifier si le mot saisi n'est pas stop
    if (mot?.toLowerCase() != "stop"){
        console.log(`Vous avez saisi : ${mot}`);
    }
}
console.log("Programme terminé");

// Fonction anonyme assignée à une variable
const multiplier = function(a, b) {
    let produit = a * b;
    if (produit > 0) {
        return produit;
    } else {
        return "Produit négatif";
    }
};

// Appeler la fonction et afficher le résultat
let resultat1 = multiplier(3, 4); // Produit positif
console.log(resultat1); // Affiche : 12

let resultat2 = multiplier(-3, 4); // Produit négatif
console.log(resultat2); // Affiche : undefined, car la fonction ne retourne rien dans ce cas




// Fonction littérale
function calculerPerimetre(longueur, largeur) {
    return 2 * (longueur + largeur);
}

// Utilisation de la fonction
let longueur = 10;
let largeur = 5;

let perimetre = calculerPerimetre(longueur, largeur);
console.log(`Le périmètre du rectangle est : ${perimetre}`); // Affiche : Le périmètre du rectangle est : 30

