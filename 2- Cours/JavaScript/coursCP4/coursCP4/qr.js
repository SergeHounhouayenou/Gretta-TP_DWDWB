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

