
/*
function test()
                {
                    let bonbon = 10 ;
                    return bonbon ;
                }
                let resultat = test() ;
// l'utilisation de "ALT + 7" s'appelle "Template Gabarit".

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
console.log(add(2, 3)) ;// De plus, pour une seule instruction les acollades ne sont pas nécessaires mais on doit les metres à partir de deux instructions. 

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

*/
//Chapitre 3 ... La création et la définition des tableaux  
///!!! Souvent déclaré avec "const" si le tableau n'est pas sujet au changement !!!

//Création du tableau
const employes = [
            {id:1, nom: "lotfi", poste: "développeur", salaire:4000, dateEmbauche: new Date( 2018, 11, 15) },
            {id:2, nom: "Maria", poste: "designer", salaire:5000, dateEmbauche: new Date( 2019, 10, 14)  },
            {id:3, nom: "Soriba", poste: "manager", salaire:4500,dateEmbauche: new Date( 2020, 12, 16)  },
                 ];

console.log (typeof employes);
console.log (employes.length); //longueur du tableau
console.log (employes[1].nom); // accès au contenu de la valeur "nom" pour l'objet N°2 car les indexes commencent à "0" dans les tableaux

// Ajout d'ééments dans le tableau
employes.push({id:4, nom: "Tohir", poste: "Directeur", salaire:5500}); // Push ajoute les éléments à la fin du tableau
console.log("Après ajout d'un employé:", employes)

// Ajouter des éléments au début
employes.unshift({id:0, nom: "Yanis", poste:"Manager", salaire:5500});
console.log("Après ajout d'un employé au début du tableau: ", employes);

// Ajouter des éléments au milieu du tableau avec "array.splice()" syntaxe : 
// --> maArray.splice(index, nombreElementASupprimer, elementAAjouter)
// exemple : ajouter à l'index N1 un objet
let dernierEmploye ;
employes.splice(1, 0, dernierEmploye);



// Pour un visuel plus facile à lire on peut utiliser "console.table(employes)"
console.table(employes);

// Ajouter une clé-valeur à un objet
employes[0].prime=500; // on ajoute une entrée de valeur à l'indexe "0" du tableau
console.table(employes);

//Supression d'éléments des tableaux

//supprimer le dernier employé
dernierEmploye = employes.pop();
console.log("Employe suprimmé :", dernierEmploye) ;

//Supprimer l'employer du début du tableau avec "shift()" --> voir sur MDN




// Modification avec splice() : array.splice(index, nombreElementASupprimer, elementAajouter au tableau)
//Ajouter à l'index 1 un objet
employes.splice(1,0,dernierEmploye);
console.table(employes);

dernierEmploye = employes.pop();
console.log("Employe suprimmé :", dernierEmploye) ;


employes[2] = {id:5, nom: "Serge", poste: "N/A", salaire:"N/A" } ;
console.log("Nouvel employé: ", employes[2]);
console.table(employes);

//Extraire une range d'employés --> slice() --> array.slice(start, end)
let topEmployes = employes.slice(0,2) ;
console.log("Employés du top 2:", topEmployes);



//Lire les données --> "for" ou "forEach"
console.log("Lecture des employés avec une boucle for :") ;
for (let i = 0; i< employes.length ; i++)
{
    console.log(`Employé : ${employes[i].nom} - Poste : ${employes[i].poste}`);
} 

console.log("Lecture des données avec une boucle forEach :") ; // On appelle cela une fonction Call back : 
                                                            // une fonction à l'intérieur d'une autre, 
                                                            //suceptible d'être appelée par une fonction.
employes.forEach( 
                (employe) => // employé est utilisé comme argument de la fonction fléchée qui représente les valeurs du tableau
                    {
                        console.log(`Employé : ${employe.nom} - Poste : ${employe.poste}`) ;
                    } 
                );

             



// Utilisation plus avancée des tableaux

// Trouver un empoyé par son ID avec la fonction find qui nous retourne 
// le premier éément d'un tableau qui satisfait la condition donnée dans le tableau.
let employeRecherche = employes.find(
                                        (employe) => employe.id === 2
                                    ) ;
                                    console.log(employeRecherche) ;





//Filtrer les employés gangnat plus de 4500 euros avec "filter"
//Filter retourne un tableau contenant tous les éléments qui vont satisfaire les conditions délarées dans la fonction callback. 
let employesBienPayes = employes.filter(
                                            (employe) => employe.salaire > 4500
                                        ) ;
                                    console.log(employesBienPayes) ;



// Créer un tableau avec les noms des emplyés avec "map" qui 
//retourne un nouveau tableau en appliquent une fonction donnée à chaque élément
let nomsEmployes = employes.map(
                                    (employe) => employe.nom
                                );
                                console.log(nomsEmployes) ;

// Trier les employés dans le tableau employés en rangeant par salaire du plus bas au plus haut.
// On utilise "sort()" --> !!!!! modification du tabeau d'origine
//La fonction qui suit va comparer deux employés "a" et "b" selon leur salaires.
//JS réalise la soustraction "a.salaire" - "b.salaire". Les résiltats pouvant être :
// Négatif : a est plus petit que b : a sera pacé avant b
//positif : a est plus grand que b : a sera placé après b
// Zéro : a et b restent inchangés
let employesTries = employes.sort(
                        (a , b) => a.salaire - b.salaire
                    ) ;
                    console.log(employesTries) ;


const produits = 
                [
                    {id:1, nom: "Chaise", prix: 25},
                    {id: 2, nom: "Table", prix: 100},
                    {id: 3, nom: "Lampe", prix: 45}
                ] ;
produits.forEach ( (produit) =>
                    {
                        produit.enStock = true ;
                    }
                );

for (let i=0 ; i<produits.length ; i++) 
        {
            produits[i].enstock = true ;
        }
console.log(produits) ;

// Manipulation des chaînes de caractère

//Mettre les nom en majuscule 
let nomsEnMajuscules = employes.map( 
                                    (employe) => employe.nom.toUpperCase()
                                 ) ;
                                 console.log(nomsEnMajuscules) ;


// Rechercher et filtrer sur les chînes de caractères
let managers = employes.filter( (employe) => { employe.poste.includes("Manager") } ) ;

// Autre exemple
let nomsCommencantParM = employes.filter ( (employe) =>employe.nom.startsWith("M") ) ;

//Nettoyage et mise en formae des chaîne de caractère
employes[0].nom = "         Serge          " ;
console.log(employes) ;
employes[0].nom = employes[0].nom.trim() ;   

employes.forEach (( employe ) => 
                                {
                                    employe.poste=employe.poste.replace("Manager", "Responsable") ;
                                }) ;
                                console.log(employes) ;

//Créer des données formatées
// Créer un tableau avec les initilaes des amployés

//Récupérer les initiales des emploes 
let initiales = employes.map( 
                            (employe) => 
                                { 
                                    console.log(employe.nom.split( " " ))
                                    return employe.nom.split( " " ).map( (mot) => [0]).join("") ; 
                                } 
                            )  ;
                            console.log(initiales) ;

/*

// Exercice 16 page 228
let userPhrase = []
const userWords = [] ;

let newPhrase = prompt( "saisissez votre phrase") 
                { 
                   userPhrase = newPhrase.split(" ") ;
                }
                console.table(`Vérification de la variable : ${userPhrase}`) ;
                for (i=0 ; i<userPhrase.lenght ; i ++) 
                    { 
                        if (userPhrase.at(i) != " " )
                            {
                                userWords.at(i) = ` mot : ${userPhrase.at(i) };
                            }
                        
                    }

/*
let userPhrase = []
const userWords = [] ;

let newPhrase = prompt( "saisissez votre phrase") 
userPhrase = newPhrase.split(" ") ;
console.table(`Vérification de la variable : ${userPhrase}`) ;
              
                     userPhrase.forEach ( ( Phrase ) =>
                        {  
                            userWords[i] = ` mot : ${userPhrase.at(i) }`;
                            console.table(`${userWords}`) ;
                        })
                                
*/

// Ajout d'une date d'embauche à chaque employé
employes.forEach( (employe, index ) => {employe.dateEmbauche = new Date(2020, index, 1) ; }) 
// new Date permet d'instancier un nouvel objet de type date au format iso : year, month, day
// Attention, en JavaScript les mois commencent à Zéro. Janvier estr "0".
// si les heures, minutes et secondes ne sont pas déclarées, il les mettra à zéro.
console.log(employes) ;

// Pour avoir juste la date du jour
employes.dateEmbauche = new Date() ; // iso complète automatiquemnent. 

// Filtrer les employés selon leur ancienneté
let employesAnciens =employes.filter( (employe) => 
                                                {
                                                    let dateActuelle = new Date()
                                                    let diffTemps = dateActuelle - employe.dateEmbauche ; //résultat donné en milliseconde
                                                    let diffAnnees = diffTemps / (1000 * 60 * 60 *24 * 365.25)
                                                    return diffAnnees > 4 ; // employesavec plus de 4 ans
                                                }); 

//Afficher les dates sous un format lisible qui renvoie seulement la date sans les heures.
employes.forEach( (employe) => {console.log(`Nom: ${employe.nom}, Date embauche: ${employe.dateEmbauche.toLocaleDateString()}`)} );
// toLocalstring --> renvoie la date et l'heure
// toDateString renvoie seulement la date mais est personnalisable
// il y en a d'autres

//Les autres méthodes
let now = new Date() ;
console.log(now.getFullYear()) ;
console.log(now.getMonth()) ;
console.log(now.getDate()) ;
console.log(now.getDay()) ;


/* 
//Exercice // Ne pas oublier 
const myDate = new Date() ;
 
//console.log(myDate.getFullYear()) ;
//console.log(myDate.getMonth()) ;
//console.log(myDate.getDate()) ;
//console.log(myDate.getDay()) ;
//console.log(myDate.getHours()) ;
//console.log(myDate.getMinutes()) ;
//console.log(myDate.getSeconds()) ;

// Opérateur ternair
myDate = myDate < 10 ? "0"+myDate:myDate ; 
console.log(`${myDate.getDay()}/${myDate.getMonth()}/${myDate.getFullYear()}/ ${myDate.getHours()}:${myDate.getMinutes()}:${myDate.getSeconds()}`) ;
// à reprendre avec la correction


*/

 // Étape 1 : Créer un objet Date représentant la date et l'heure actuelles
 const dateActuelle = new Date();

 // Étape 2 : Obtenir les composants (jour, mois, année, heures, minutes, secondes)
 let jour = dateActuelle.getDate();
 let mois = dateActuelle.getMonth();
 let année = dateActuelle.getFullYear();
 let heures = dateActuelle.getHours();
 let minutes = dateActuelle.getMinutes();
 let secondes = dateActuelle.getSeconds()
 
 // Étape 3 : Formater les composants pour avoir toujours deux chiffres
 jour = jour < 10 ? "0"+jour:jour;
 mois = mois < 10 ? "0"+mois:mois;
 heures = heures < 10 ? "0"+heures:heures;
 minutes = minutes < 10 ? "0"+minutes:minutes;
 secondes = secondes < 10 ? "0"+secondes:secondes;
 
 // Étape 4 : Construire la chaîne au format DD/MM/YYYY HH:MM:SS
 let dateFormatée = `${jour}/${mois+1}/${année} ${heures}:${minutes}:${secondes}`;
 
 // Étape 5 : Afficher la date et l'heure formatées
 console.log(dateFormatée);