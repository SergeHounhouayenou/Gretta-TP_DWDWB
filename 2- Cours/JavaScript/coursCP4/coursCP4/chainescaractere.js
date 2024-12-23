// ==================================================
// 1. Création et définition des tableaux
// ==================================================

// Tableau des employés avec des objets (déclaré avec accolades et clé:valeur) contenant leurs informations (déclaré souvent avec const)
const employes = [
    {id:1, nom: "Lotfi", poste: "Développeur", salaire:4000},
    {id:2, nom: "Maria Teresa", poste: "Desginer", salaire:5000},
    {id:3, nom: "Soriba", poste: "Manager", salaire:4500}
];

// ==================================================
// 2. Conversion  les noms en majuscules
// ==================================================

let nomsEnMajuscules = employes.map((employe)=>employe.nom.toUpperCase());
console.log(nomsEnMajuscules);

// ==================================================
// 3. Recherche et filtrage sur les chaines
// ==================================================

let managers = employes.filter((employe)=>employe.poste.includes("Manager"));
let nomsCommencentParM = employes.filter((employe)=>employe.nom.startsWith("M"));

// ==================================================
// 4. Nettoyage et mise en forme des chaines de caractères
// ==================================================

employes[0].nom="            Lotfi      ";
console.log(employes);
employes[0].nom= employes[0].nom.trim();

employes.forEach((employe)=>{
    employe.poste=employe.poste.replace("Manager", "Responsable");
});
console.log(employes);

// ==================================================
// 5. Créer des données formatées
// ==================================================

//Initiales des employes
let initiales = employes.map((employe)=>{
    //console.log(employe.nom.split(" "))
    return employe.nom.split(" ").map((mot)=>mot[0]).join("");
});
console.log(initiales);