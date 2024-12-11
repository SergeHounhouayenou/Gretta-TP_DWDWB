
//
//Documentation officielle : Mdn

//le JS externe est le plus recommandé
console.log("le cours de 'bases de JS' avec le fichier externe") 

//1. Variables et constantes
let ageUtilisateur = 49;
console.log(ageUtilisateur);
//afficher le type d'une varible
let isLogging = true;
console.log(typeof isLogging)

//Constante avec const : convention UPPER_SNAKE_CASE ou camelCase
//Recommandation ES6 : utiliser « const » sauf si la valeur à vocation à changer. On utilise alors « let ».
const TAUX_TVA = 0.2;
const nomUtilisateur = "Serge"

//Les structures conditionnelles
const age = 20;
if (age < 20 ) 
    {
        console.log("Mineur") ;
    }
else if (age > 18 && age < 65) // Opérateur ET ( OU s'écrit "||")
    {
        console.log("Adulte") ;
    }
else 
    {
        console.log("senior"); // Pour chaque instruction on met un point virgule à la fin.
    }

// Opérateur Ternaire : Structure conditionnelle conscice
// écriture : condition ? expressionSiVaie : expressionSiFaux
const isMember = true;
const fraisAdhesion = isMember ? "10 euros" : "20" ;
console.log(fraisAdhesion);

//Chaîne litérale : ` ` --> elle permet d'associer des variables à une chaîne de caractère
console.log(`frais adhesion : ${fraisAdhesion}`) ;
//On peut aussi utiliser l'opérateur de concaténation
console.log("frais adhesion :" + fraisAdhesion) ; 

//Egalité stricte : "===" (3 caractère "=")--> vérifie la valeur et le type en condition "ET"
let a = 10 ;
let b = 20 ;
let resultat1 = (a === b) ? "Egale" : "Différent";
console.log(resultat1);

//Egalité NON stricte : "==" (2 caractère "=")--> vérifie la valeur et le type en condition "OU"
let c = "5" ;
let d = 5 ;
let resultat2 = (c == d) ? "Egale" : "Différent"
console.log(resultat2);

//Switch pour tester plusieurs cas : switch....case
const day = "lundi" ;
switch (day) 
    {
        case "lundi":
            console.log("Début de semaine !!") ;
        case "samedi" :
        case "dimanche" : 
            console.log("week end !!");
            break ;
        default: 
            console.log("Un jour normal") ;
    }

//Réassigner une valeur à une variable avec let
let  maVariable = 1 ;
maVariable = 2 ;
console.log(maVariable) ;

//Chapitre 2 
//Les structures Itératives
// Quand ? idéale pour parcourir un ensemble d'éléments (par exemple un tableau)
for (let i=0 ; i<5; i++)
        {
            console.log(`Itération ${i}`) ;
        }


let count = 0;
while (count < 3)
        {
        console.log(`Compte ${count}`) ;
        count++;
        }

//Exécution au moins une fois même si la condition est fausse
let num=5;
do 
        {
        console.log(`Nombre ${num}`) ;
        num--; //Décréentation de 1
        }
while (num>0) ;

//Demander à l'utilisateur d'écrire quelquechose : "prompt (input en python)"
let o = prompt("saisissez un nombre");

//Variable indéfinie 
let mot; 
console.log(mot);

//Boucle while : tant que le mot saisi n'est pas stop
while(mot?.toLowerCase() !="stop")
{
    mot = prompt("saisir un mot (stop pour arrêter)");
    //Vérifier si le mot saisi n'est pas stop
    if (mot?.toLowerCase() !="stop")
    {
        console.log(`Vous avez saisi : ${mot}`) ;
    }

}
console.log("Programme termininéjour")

//Mettre une variable en majuscule --> myVarible.toLowercase()
//!! .tolowercase ne peut pas s'appliquer à une vaariable de type indéfini.
// optional chaining

//Chapitre 3 : Regrouper en fonction de la tâche d'une fonction

//Déclaration de la fonction
function greet(name = "inconnu")
{
    console.log(`Bonjour ${name}`) ;
}
//Appel de la fonction
greet("Saman");
greet("Saman");
greet()

function greet2(name = "inconnu2")
{
    return `Bonjour ${name}`;
}
console.log(greet2("Saman2")) ;

let nomUtilisateur2 = greet2("serge");
console.log(nomUtilisateur2);
console.log(greet2("Nadjet2")) ;
console.log(greet2()) ;

// Les fonctions anonymes --> souvent utilisées comme arguments car sans nom
// Certaines fonctionnalités comme setTimeOut exigent pour syntaxe une fonction anonyme. Il faut récupérer la liste et l'apprendre par coeur.

setTimeout(function()
{
    console.log("ce message s'affiche après deux secondes !")
} , 2000);
const maFonctionAnonyme = function ()
{
    console.log("La Fonction anonyme que je veux stocker dans une variable");
}

// Les fonctions fléchées : "arrow function" syntaxe concise pour écrire des fonctions
//Syntaxe : (param1, param2 ...) =>expression
const add = (a,b) => a +b ; // lorsqu'il n'y a qu'une seule instruction dans la fonction fléchée, JavaSript inclu automatiquement le RETURN
console.log(add(2, 3)) ;// De plus, pour une seule instruction les acollades ne sont pas nécessaires mais on doit les metres quand à partir de deux instructions. 

const addition = (a, b) => 
{
    console.log("calcul en cours ....")
    return a + b ; 
}
console.log(addition( 2, 5 ))

// Les fonctions comme "données" : les fonctions passées en argument
const multiply = (a, b) => a*b ;
const division = (a, b) => a/b ;
//"op" est une fonction qui réalise une opération
function compute(op, x, y) 
{
    return op(x, y) ;
}
console.log(compute(multiply, 4, 5) );
console.log(compute(division, 4, 5));