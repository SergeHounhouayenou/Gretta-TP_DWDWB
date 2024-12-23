//JS externe --> RECOMMANDER
console.log("Le cours JS avec du JS Externe");

//1. Variables et constantes

// Variable avec let : convention camelCase
let ageUtilisateur = 22;
console.log(ageUtilisateur);
let isLogging = true;
console.log(typeof isLogging);

// Constantes avec const : convention UPPER_SNAKE_CASE ou camelCase
const TAUX_TVA = 0.2;
const nomUtilisateur = "Saman";
//const nomUtilisateur = "Samn";

// Différence : la constante ne peut pas etre réassigné à la même reference
// Conclusion : Utilisez const par défaut et let uniquement si la valeur change (ES6)

// Les structures conditionnelles
const age = 20;
if (age < 20){
    console.log("Mineur");
}else if (age >= 18 && age<65){ //Operateur ET : && et OU : ||
    console.log("Adulte");
}else{
    console.log("Sénior"); // 1 instruction --> 1 ; à la fin
}

// Opérateur ternaire : structure conditionnelle concise
// condition ? expressionsiVrai : expressionSiFaux;
const isMember = true;
const fraisAdhesion = isMember ? "10€" : "20€";
console.log(fraisAdhesion);
//Chaines litterales : chaine avec des variables - inclure variable dans texte
console.log(`Frais adhesion : ${fraisAdhesion}`);
//Opérateur de concaténation - inclure variable dans texte
console.log("Frais adhesion :"+fraisAdhesion);

// Egalité stricte === : check sur la valeur et le type (différent de ==)
let a = 10;
let b = 20;
let resultat = (a === b) ? "Egal" : "Différent";
console.log(resultat);

//Switch pour tester plusieurs cas : switch...case
const day = "lundi";
switch (day) {
    case "lundi":
        console.log("Début de semaine !!");
        break; //break evite la lecture des autres case
    case "samedi":
    case "dimanche":
        console.log("Week end !!");
        break;
    default:
        console.log("Un jour normal");
}
//Réassigner une valeur à une variablea avec let
let maVariable = 1;
maVariable = 2;
console.log(maVariable);

// 2. Les structures itératives (boucles) : répétition

// Quand ? idéale pour parcourir un ensemble d'éléments (par ex : tableau)
for (let i=0; i<5; i++){ //i++ : incrémentation de i=i+1
    console.log(`Itération ${i}`);
}
// Execution tant que la condition est vraie
let count = 0;
while (count < 3){
    console.log(`Compte ${count}`);
    count++;
}

//Execution au moins une fois même si la condition est fausse

let num=5;
do {
    console.log(`Nombre ${num}`);
    num--; //Décrémentation de 1
}while (num>0);

// Demande à l'utilisateur : prompt (input en python)
//let n = prompt("Saisissez un nombre");

// 3. Les fonctions :  regroupe en fonction de la tâche de la fonction

// Syntaxe fonction classique
//Déclaration de la fonction
function greet(name="inconnu"){
    console.log(`Bonjour ${name}`);
}
//Appel de la fonction
greet("Saman");
greet("Nadjet");
greet();

function greet2(name="inconnu2"){
    return `Bonjour ${name}`; // return arrete l'execution de la fonction
}
// return affiché directement via console
console.log(greet2("Saman2"));
// return recuperer directement dans une variable
let nomUtilisateur2 = greet2("Sam");
console.log(nomUtilisateur2);
console.log(greet2("Nadjet2"));
console.log(greet2());

// Les fonctions anonymes : sans nom, souvent utilisées comme arguments
setTimeout(function (){
    console.log("Ce message s'affiche apres 2 secondes !")
}, 2000);
const maFonctionAnonyme= function (){
    console.log("Fonction anonyme stockée dans une variable");
}

//Les fonctions fléchées (arrow function) : syntaxe concise pour écrire des fonctions
//Syntaxe : (param1, param2..) => expression
const add = (a,b) => a + b; //1 instruction dans fct fléchée --> return auto
console.log(add(2,3));
const addition = (a,b) => {
    console.log("Calcul en  cours .....");
    return a+b;
}
console.log(addition(2,5));

//Les fonctions comme données : Les fct passées en argument
const multiply = (a,b)=>a*b;
const division = (a,b)=>a/b;
// op est une fonction réalisant une opération
function compute(op, x, y){
    return op(x,y);
}
console.log(compute(multiply, 4, 5));
console.log(compute(division, 4, 5));


function test(){
    let bonbon=10;
    return bonbon;
}
let resultat = test();