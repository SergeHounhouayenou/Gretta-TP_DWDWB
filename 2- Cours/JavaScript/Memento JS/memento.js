

document.addEventListener('DOMContentLoaded', () =>
    
        { 
            function createPlayZone(gameTitle)
                {
                const playZone = document.createElement ('article') ;
                      playZone.className = "gameField"
                      playZone.appendChild( sectionLeft, sectionCenter, sectionRight ) ;
                      

                const sectionLeft = document.createElement ('section') ; 
                      sectionLeft.appendChild( l1div, l2div, l3div ) ;

                const sectionCenter = document.createElement ('section') ; 
                      sectionCenter.appendChild( c1div, c2div, c3div ) ;

                const sectionRight = document.createElement ('section') ; console.log(createPlayZone) ;
                      sectionRight.appendChild( r1div, r2div, r3div ) ;

                const title = document.createElement ('h4') ;
                      title.textContent = 'The Mystery Word' ;

                const logo = document.createElement ('img') ;
                      logo.className = "logo" ;
                      logo.src = 'pictures/cor/big-logo-corpulence3.png' ;
                      logo.alt = "image du logo du site 'corpulence'" ;

                const writeZone = document.createElement ('form') ;   

                const deleteButton = document.createElement ('button') ;
                      deleteButton.textContent = "fermer"
                      deleteButton.addEventListener ('quitter le jeu ?', () => 
                                                        {
                                                        playZone.remove() ;
                                                        }
                                                    )

                const submitButton = document.createElement ('button') ;
                      submitButton.textContent = "valider"
                      submitButton.addEventListener ('valider ce choix ?', () => 
                                                        {
                                                        writeZone.submit() ;
                                                        }
                                                    )

                const l1div = document.createElement ('div') ;
                const l2div = document.createElement ('div') ;
                const l3div = document.createElement ('div') ;

                const c1div = document.createElement ('div') ;
                const c2div = document.createElement ('div') ;
                const c3div = document.createElement ('div') ;

                const r1div = document.createElement ('div') ;
                const r2div = document.createElement ('div') ;
                const r3div = document.createElement ('div') ;

                return playZone ;
                  
                } ;
            console.log() ;

            // Ouvrir la zone de jeu
            openGamefields[0].addEventListener('nouvelle partie', () => 
            {
                const gameTitle = prompt ("saissisez votre code jeu") ;
                if (gameTitle)
                {
                    const newGame = createPlayZone(gameTitle) ;
                    container.appendChild(newGame) ;
                }
                else
                {
                    alert ('demander un code jeu valide') ;
                }
                
            }
                ) ;
        } 
    ) ;






// la fonction fléchée avec forEAch
/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:1, numero:5}] ;

longueur.forEach( (newNumber) => {newNumber.numero=24 ;} );

console.log(longueur) ;
*/
//Fonction normale avec for
/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id:1, numero:8}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:9}] ;

for (let i=0; i<longueur.length; i++){
    console.log(`clé : ${longueur[i].id} - valeur : ${longueur[i].numero}`);
}
*/
/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:1, numero:5}] ;

suppression = longueur.splice(4, 1, "MOI") ;
console.log(longueur) ;
*/
/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:1, numero:5}] ;

longueur.splice(4, 0, "Moi") ;
console.log(longueur) ;
*/

/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:1, numero:5}] ;
let whatYouSearch = longueur.find( (represent) => represent.id === 2 );   console.log (whatYouSearch); 
// Attention !!! find() ne renvoie que la première solution qui satisfait la demane. 
// Sa syntaxe ne tolère donc qu'une seule instruction DE POINTAGE.
// Hors, les fonctions fléchées ne prennent pas d'accolades pour l'instructions 
// du call back de la fonction représentatée quand i n'y a qu'une seule instruction.  
*/

/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:5}] ;
let whatYouSearch = longueur.filter( (represent) => represent.id > 2 );   console.log (whatYouSearch); 
*/

/*

const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:5}] ;
let whatYouSearch = longueur.map( (represent) =>  represent.id  > 2 ? represent.id +2 : represent.id  * 2 );   console.log (whatYouSearch); 

*/

/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:5}] ;
let whatYouSearch = longueur.sort( (representA, representB) =>  representA.id  - representB.id );   console.log (whatYouSearch); 

*/

/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:5}] ;
let whatYouSearch = longueur.filter( (represent) =>  {represent.includes("bonjour") } ) ; console.log (whatYouSearch);//  A refaire

*/

/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:5}] ;
let whatYouSearch = longueur.filter( (represent) => { represent.numero.startsWith(5) } ) ; //  A refaire

*/
/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:5}] ;
let newObject = {nom: "serge" , role: "admin"} ; console.log(newObject) ;
longueur.splice(3, 0, newObject) ; console.log(longueur) ;

let newObject1 = {nom: "   sergeï   " , role: "admin"} ; console.log(newObject1) ;
longueur.splice(4, 0, newObject1) ; console.log(longueur) ;

let newObject2 = {nom: "    Serge Hounhouayenou" , role: "admin"} ; console.log(newObject2) ;
longueur.splice(5, 0, newObject2) ; console.log(longueur) ;

longueur[4].nom = longueur[4].nom.trim() ; console.log(longueur) ;
longueur[5].nom = longueur[5].nom.trim() ; console.log(longueur) ;

/*
longueur.forEach((represent) => represent.nom.replace("serge", "SergeH") ) ; console.log(longueur) ; // Pas clair. A reclarifier
*/
/*
let sentence = "Boire l'eau des Orisha"
let firstLetter = sentence.split("") ; console.log(firstLetter) ;
let firstLetter1 = longueur[5].nom.split("") ; console.log(firstLetter1) ;  
let initial = [] ;
initial = [ [firstLetter1[0], firstLetter1[6]].join(".") ]; console.log(initial) ; console.log( typeof initial) ; 

let backupDateCatching = new Date ; console.log(backupDateCatching)

longueur.forEach( (represente) => represente.backupDate = "Sun Dec 15 2024 16:05:16 GMT+0100 (heure normale d’Europe centrale)" ) ; console.log(longueur)
*/
/*
let referenceDate = new Date ; console.log(referenceDate.getMinutes()) ; temps1 = referenceDate; console.log(temps1) 
*/

/*
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

************************************************************************************************************

///////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


