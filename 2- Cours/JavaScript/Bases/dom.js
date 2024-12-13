

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
                                                    const container = document.getElementById ("movie-container") ;
                                                    const addMovieButton = document.getElementsByClassName("add-movie-button") ;
                                                    //const addMovieButton = document.getElementsByTagName ("button") ;
                                                  //  const addMovieButton = document.querySelector (".add-movie-button") ;
                                                    //const addMovieButton = document.querySelectorAll (".add-movie-button") ;
                                                   // console.log(addMovieButton) ;
                                               

// Fonction pour créer une nouvelle carte de film
function createMovieCard(movieTitle)
        {
            //Créer les éléments nécessaires
            const card = document.createElement ('div') ;// créer un élement HTML dans le JS en précisant le nom de la balise
            const img = document.createElement ('img') ;
            const title = document.createElement ('h4') ;
            const deleteButton = document.createElement ('button') ;

            // Ajouter des classes et du contenu aux éléments
            card.className = "movie-card" ;
            img.src = 'https://via.placeholder.com/100x150' ;
            img.alt = `Image du film ${movieTitle}` ;
            title.textContent = movieTitle; // <h4>Mufasa</h4> équivalent à innerHTML
            //title.innerHTML = '<p>Mon paragraphe dans mon h4 via inner </p>' ;
            deleteButton.textContent = "Supprimer";
            deleteButton.className = "delete-button";


// Ajouter un écouteur event au bouton suppression
deleteButton.addEventListener ('click', () => 
                            {
                                card.remove(); 
                            } 
                            
                            )



            //Ajouter des éléments enfants à la carte 
            card.appendChild(img) ;
            card.appendChild(title) ;
            card.appendChild(deleteButton) ;

            return card ;
        
            
        }

        //    console.log(card, img, title, deleteButton, ) ;

            console.log("") ;
        
        createMovieCard ("tt") ;

            // Gestionnaire de clic pour ajouter un nouveau film
            addMovieButton[0].addEventListener('click', ()=> 
                                                {
                                                    const movieTitle = prompt ("Entrez le titre du film") ;
                                                    if (movieTitle) 
                                                    {
                                                        const newCard = createMovieCard(movieTitle);
                                                        container.appendChild(newCard) ;
                                                    }
                                                    else
                                                        {
                                                            alert ('Le titre ne peut pas être vide') ;
                                                        }


                                                  
                                                } 
                                               ) ;

}) ;