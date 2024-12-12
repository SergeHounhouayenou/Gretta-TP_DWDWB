

// Rappel : Pour forcer le navigateur à lire le scripte JAvascript 

// chapitre 1 : Méthodes de recherche

const container = document.getElementById("container")
console.log(container) ;

// après la fin du téléchargement de la page on ajoute l'attribut "defer" 
// après le nom du fichier JS dans le head du HTML

// On peut aussi utiliser le gestionnaire d'évènements : "addEventListener(nomEvent, fonction)"
//exemples d'évènements : onclick, onmouseover (sanson dans add)
// La fonction entrée en paramètre peut être soit classique,soit fléchée, soit anonyme. 

//attendre que le DOM soit chargé avant d'éxécuter le script
document.addEventListener('DOMContentLoaded', () => 
                                                {
                                                    const container = document.getElementById ("container") ;
                                                    console.log(container) ;
                                                }) ;