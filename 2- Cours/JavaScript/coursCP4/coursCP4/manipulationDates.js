// ==================================================
// 1. Création et définition des tableaux
// ==================================================

// Tableau des employés avec des objets (déclaré avec accolades et clé:valeur) contenant leurs informations (déclaré souvent avec const)
const employes = [
    {id:1, nom: "Lotfi", poste: "Développeur", salaire:4000,
        dateEmbauche: new Date(2018,11,15)},
    {id:2, nom: "Maria", poste: "Desginer", salaire:5000,
        dateEmbauche: new Date(2019,5,10)},
    {id:3, nom: "Soriba", poste: "Manager", salaire:4500,
        dateEmbauche: new Date(2021,0,5)}
];

// ==================================================
// 2. Ajout d'une date d'embauche à chaque employé
// ==================================================
employes.forEach((employe, index)=>{
    // new Date permet d'instancier un objet de type Date(year, month, day)
    //Attention les mois commencent à zéro
    //employe.dateEmbauche = new Date(2020, index, 1);
    //employe.dateEmbauche = new Date(); //date du jour iso complete
});
console.log(employes);

// ==================================================
// 3. Filtrer  les employés selon anciennete
// ==================================================
let employesAnciens = employes.filter((employe)=>{
    let dateActuelle = new Date();
    //Différence en millisec
    let diffTemps = dateActuelle - employe.dateEmbauche;
    //Conversion des millisecondes en années
    let diffAnnees = diffTemps / (1000 * 60 * 60 * 24 * 365.25);
    return diffAnnees > 4; //Employes avec plus de 4 ans

});
console.log(employesAnciens);

// ==================================================
// 4. Afficher les dates sous un format lisible
// ==================================================

employes.forEach((employe)=>{
    //toLocaleDateString renvoie la date seulement (personnalisable)
    //toLocaleString renvoie la date et lheure
    //toDateString renvoie date seulement (non personnalisable)
    console.log(`Nom: ${employe.nom}, Date embauche: ${employe.dateEmbauche.toLocaleDateString()}`);
});

// ==================================================
// 5. Les autres méthodes
// ==================================================
let now = new Date();
console.log(now.getFullYear());
console.log(now.getMonth());
console.log(now.getDate());// 0 = dimanche
console.log(now.getDay());


