//Documentation officielle : Mdn

//Exercice 5 page 202
//Demandez à l’utilisateur de saisir un mot. 
//Tant que le mot n’est pas stop, répétez la question et 
//affichez « Vous avez saisi : [mot] ».


// Exercice 4 page 202

//MOI 
//Exercice  
//Créer un programme qui demande à l’utilisateur de saisir un nombre « n » 
//et afficher les nombres de 1 à n en utilisant une boucle for.
//Bonus ; Afficher « Fizz » pour les multiples de 3, « Buzz » pour les multiples 
//de 5 et « FizzBuzz pour les multiples de 3 et 5.
//rapel de l'écriture des multiples de 3: --> n%3==0

let n ;
validUserNumber =false;

function m() 
    {
        while (validUserNumber =false) ; 
            { 
            n =  prompt("saisissez un nombre inférieur à 30") ;
            }           
              if (n > 0 && n <=30) 
                    { 
                        validUserNumber = true ; 
                        for (let i=1; i <= n; i++)
                        {
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
                        };
                    } 
                else 
                    {
                        if ( n > 30 ) 
                            {
                            console.log ("votre nombre est trop grand. Recomancez");
                            validUserNumber = false ; 
                           
                            }
                        else if ( n < 1)
                            {
                            console.log ("votre nombre est trop petit. Recomancez");
                            validUserNumber = false ; 
                           
                            } 
                        } ;
                }  ;
while (validUserNumber == false) {m()} ;
    



//Exercice 5 page 202
//Demandez à l’utilisateur de saisir un mot. Tant que le mot n’est pas stop, répétez la question et affichez « « Vous avez saisi : [mot] ».
//Boucle while : tant que le mot saisi n'est pas stop
while(mot?.toLowerCase() !="stop")
    {
        mot = prompt("saisir un mot (stop pour arrêter");
        //Vérifier si le mot saisi n'est pas stop
        if (mot?.toLowerCase() !="stop")
        {
            console.log(`Vous avez saisi : ${mot}`)
        }
    
    }
    console.log("Programme termininéjour")
    
    //Mettre une variable en majuscule --> myVarible.toLowercase()
    //!! .tolowercase ne peut pas s'appliquer à une vaariable de type indéfini.
    // optional chaining

    //Exercice 2
    // Créer une fonction anaonyme assignée à une variable appelée multiplier 
    //qui prend deux arguments et retourne leur produit si positif 
    //(sinon afficher "produit négatif"). Appeler la fonction et affichez le résultat.

    const multiplier = function (a, b)
        {
            let produit = a*b ;

            if (produit >=0)
                {
                    return multiplier ;
                }
            else 
                {
                    console.log ("produit négatif") ;
                }
        } ;
    
    let resultat1 = multiplier(3, 4) ;
    console.log(resultat1) ;

    let resultat2 = multiplier(-3, 4)
    console.log(resultat2) ;

    //Exercice 3 : Calcul du périmètre d'un rectangel
    // Créer une fonction littérale appelée "calculerPerimetre" qui prend deux arguments, 
    //longueur et largeur, et retourne le périmètre du rectangle 
    //Utiliser cette fonction pour calculer le périmètre d'un rectangle avec des valeurs données et afficher le résultat dans la console. 
    //Formaule du périmettre ; P=2x(longueur+largeur) 

    function calculerPerimetre (longueur, largeur)
    {
        return 2* (longueur + largeur) ;
    }

    let longeur = 10;
    let largeur = 5 ;
    let perimetre = calculerPerimetre(longueur, largeur) ;
    console.log(`Le périmètre du rectangle est : ${perimetre}`) ; //Afficher le résultat.
    
// CORRECTION
    // Fonction littérale
function calculerPerimetre(longueur, largeur) {
    return 2 * (longueur + largeur);
}

// Utilisation de la fonction
let longueur = 10;
let largeur1 = 5;

let perimetre1 = calculerPerimetre(longueur, largeur);
console.log(`Le périmètre du rectangle est : ${perimetre}`); // Affiche : Le périmètre du rectangle est : 30
