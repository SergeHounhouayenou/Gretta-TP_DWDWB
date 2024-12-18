

//MOI 
//Exercice  

/*
let n ;
let validUserNumber = false;

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
    
*/


//Exercice 5 page 202
//Demandez à l’utilisateur de saisir un mot. Tant que le mot n’est pas stop, répétez la question et affichez « « Vous avez saisi : [mot] ».
//Boucle while : tant que le mot saisi n'est pas stop

const mysteryWord = "programmer" ;
const indices = ["p", "r", "o", "g", "r", "a", "m", "m", "e", "r"] ;
const myclues = [] ;
let remainingTries = 10 ;
let tries = "essais" ;
let wonClues ;
let winnerI ;
let playerName ;

function runningGame()
{
    do 
        { playerWord = prompt (`Devinez le mot mystérieux à 10 lettres. il vous reste ${remainingTries} ${tries}. ${wonClues}`)
                            
            
            if (playerWord.toLowerCase() == mysteryWord)
                {
                    playerName = prompt ("Féllicitation ! Vous avez trouvé le mot mystérieux. Saississez votre nom et votre prénom ou bien votre pseudo pour voir votre classement.") ;
                    winnerI = playerName ;
                    alert (`${winnerI}, vous faites partie des vaincqueurs mais le classement n'est pas encore prêt`) ;
                     ;
                } 
                            
            else
                {
                    if (playerWord.toLowerCase() !== mysteryWord)
                        {
                            remainingTries -- ;
                        } ;

                    if (remainingTries > 1)
                        {
                            tries = "essais" ;
                            console.log("Encore un petit effort")
                        }
                    if (remainingTries === 1)
                        {
                            tries = "essai" ;
                            console.log("cest votre dernière chance... Réfléchissez bien !")
                        }
                    if (remainingTries === 0)
                        {
                            tries = "essai" ;
                            alert ("Vous avez perdu une bataille mais pas la guerre. Faire une nouvelle partie ?")
                        }
                    if (remainingTries < 0 )
                        {
                            tries = 0 ;
                        }

                    {
                    collectIndice = playerWord.toLowerCase() ;
                    console.log (playerWord) ;
                    }

                    console.log(`vérification de collectIndice : ${collectIndice}`) ;
                                        
                    for ( let k = 0 ; k < collectIndice.length; k ++)
                        {

                            if (collectIndice.at(k) == indices.at(k)) 
                                    { 
                                        myclues.push( indices.at(k)) ;

                                    }   
                            console.log(`vérification de myclues ${myclues}`) ;
                        }
                    
                    wonClues = `Vos indices sont : ${myclues}`;
                    console.log(wonClues) ;
                    myclues.length = 0 ;
                    let checkmyCluesInit ;
                    if (myclues.length === 0) {checkmyCluesInit = "oui" ;} else {checkmyCluesInit = "non" ;}
                    console.log(`la variable "myClues" est-elle bien réinitialisée ? : ${checkmyCluesInit} `) ;
                } ;
        } 
    while (remainingTries > 0) ;
} 
    runningGame() ;

/*
    if (myclues.length < 1) { wonClues = "Vous n'avez pas encore trouvé d'indice"; }
*/




  