// ==================================================
// 1. Création et définition des tableaux
// ==================================================

// Tableau des employés avec des objets (déclaré avec accolades et clé:valeur) contenant leurs informations (déclaré souvent avec const)
const employes = [
    {id:1, nom: "Lotfi", poste: "Développeur", salaire:4000},
    {id:2, nom: "Maria", poste: "Desginer", salaire:5000},
    {id:3, nom: "Soriba", poste: "Manager", salaire:4500}
];

console.log(typeof employes);
console.log(employes.length); // Longueur du tableau
console.log(employes[1].nom); // Accès au nom de l'objet numéro 2

// ==================================================
// 2. Ajout d'éléments aux tableaux
// ==================================================

//Ajouter un nouvel employé à la fin du tableau
employes.push({id:4, nom: "Toihir", poste: "Directeur", salaire:5500}); //employes.push({},{},{}) --> ajout de plusieurs personnes
console.log("Après ajout d'un employé à la fin: ", employes);

//Ajouter un stagiaire au début de la tableau
employes.unshift({id:0, nom: "Yanis", poste: "Manager", salaire:5500});
console.log("Après ajout d'un employé au début: ", employes);

//Ajouter une clé-valeur à un objet
employes[0].prime=500; //.cle=valeur    pour l'appliquer à tout le monde --> forEach()
console.table(employes);

// ==================================================
// 3. Suppression d'éléments des tableaux
// ==================================================

//Supprimer le dernier employé
let dernierEmploye = employes.pop();
console.log("Employe supprimé :", dernierEmploye);
console.table(employes);

//Supprimer l'employé du début du tableau avec shift() --> mdn

// ==================================================
// 4. Modification avec splice() : array.splice(index, nombreElementASupprimer, elementAajouter au tableau)
// ==================================================

//Ajouter à l'index 1 un objet
employes.splice(1,0,dernierEmploye);
console.table(employes);

// ==================================================
// 5. Extraction avec slice() : array.slice(start, end) - l'indice end est exclu
// ==================================================
let topEmployes = employes.slice(0,2);
console.log("Emloyés du top 2: ", topEmployes);

// ==================================================
// 6. Lecture des donneés : for ou forEach
// ==================================================

console.log("Lecture des employés avec une boucle for :");
for (let i=0; i<employes.length; i++){
    console.log(`Employé : ${employes[i].nom} - Poste : ${employes[i].poste}`);
}

console.log("Lecture des employés avec une boucle forEach :");
employes.forEach((employe)=>{ //employe = argument de la fonction fléchée representant les valeurs du tab
    console.log(`Employé : ${employe.nom} - Poste : ${employe.poste}`);
});

// ==================================================
// 7. Utilisation des tableaux - AVANCEE
// ==================================================

// Trouver un employé par son ID avec find : retourne le premier élément du tableau qui satisfait la condition
// donnée dans la fonction de rappel (callback)
let employeRecherche = employes.find((employe)=> employe.id === 2);
console.log(employeRecherche);

//Filtrer les employés gagnant plus de 4500€ avec filter : retourne un nouveau tableau contenant les éléments
// qui satisfont la condition donnée dans la fct callback
let employesBinePayes = employes.filter((employe)=> employe.salaire > 4500);
console.log(employesBinePayes);

// Créer un tableau des noms des employés avec map : retourne un new tab en appliquant une fonction donnée
// à chaque élément
let nomsEmployes= employes.map((employe)=>employe.nom);
console.log(nomsEmployes);

// Trier les employés dans le tableau employes par salaire (du plus bas au plus haut) : sort()
// sort() trie les éléments du tableau --> modification du tableau d'origine
// fonction de comparaison compare deux employés a et b selon leur salaire.
// JS réalise la soustraction : a.salaire - b.salaire les résultats peuvent etre :
// Négatif : a est plus petit b (a sera placé avant b)
// positif : a est plus grand que b (a sera placé apres b)
// Zéro : a et b restent inchangé
let employesTries = employes.sort((a,b)=> a.salaire - b.salaire);
console.log(employesTries);