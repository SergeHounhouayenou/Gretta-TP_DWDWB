
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
let whatYouSearch = longueur.filter( (represent) => { represent.includes(8) } ) ; //  A refaire

*/

/*
const longueur = [10, 23, 65, 'bonjour', "demain", [{id: 1, numero:58}] ,  {id:4, numero:5}, {id:2, numero:4}, {id:3, numero:5}] ;
let whatYouSearch = longueur.filter( (represent) => { represent.numero.startsWith(5) } ) ; //  A refaire

*/


