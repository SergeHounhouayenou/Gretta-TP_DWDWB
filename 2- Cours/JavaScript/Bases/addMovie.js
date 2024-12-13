document.addEventListener ("DOMContentLoaded", ()=> 
    {
        const titre = document.getElementById('movie-title') ;
        console.log(titre);
        const movieForm = document.getElementById ('movie-form') ;


        //Fonction de validation des données du formulaire
        function validateFormData(movie)
                                        {
                                            //Valider que le champ title n'est ni vide ni composé uniquement d'espace
                                            //Si title est vide ou contient uniquement des espaces
                                            if (!movie.title.trim() )  // Booleen inversé
                                                {
                                                    alert('Le titre est requis') ;
                                                    return false ;
                                                }

                                            if (!movie.description.trim()) 
                                                {
                                                    alert('La description est requise') ;
                                                    return false ;
                                                }

                                            if (!movie.date)
                                                {
                                                    alerte ('La date est requise') ;
                                                    return false ;
                                                }

                                            if (!movie.color)
                                                {
                                                    alert('Veuillez choisir une couleur pour la bordure')
                                                    return false ;
                                                }
                                            
                                            return true ;
                                        }

        function storeMovieInLocalStorage(movie)
                                                {
                                                    // Récupérer les films (si présent) du localstorage
                                                    const storeData = localStorage.getItem('movies') ;
                                                    const movies = storeData ? JSON.parse(storeData) : [] ;// Structure conditionnelle hyper concise Si c'est vide (si la valeur n'existe pas) alors tu mets un tableau vide 
                                                    movies.push(movie) ;


                                                    //Sauegarde dans le local storage
                                                    localStorage.setItem('movies', JSON.stringify(movie)) ;
                                                }




        //Gestionnaire de soumission du formulaire
        movieForm.addEventListener('submit', (event)=>
                                                {
                                                    event.preventDefault(); // Empeche le rechargement de la page
                                                    console.log('testFormulaire-film')
                                               
                                                //Récupérer les valeurs des champs du formulaire
                                                const title = document.getElementById('movie-title').value ; 
                                                let img = document.getElementById('movie-img').value ;
                                                img = img.split("\\") [2] ; //split('\')
                                                    
                                                
                                                const description = document.getElementById('movie-description').value ;
                                                const date = document .getElementById('movie-date').value ;
                                                const color = document.getElementById('movie-color').value;

                                                // movie = {img : img, description : description, date : date, color ; color}
                                                const movie = { title, img, description, date, color }
                                                console.log(movie) ;

                                                //Valider les données
                                                if (validateFormData(movie)) 
                                                                            {
                                                                            // Stockage dans le local storage : limite = environ 5 Mo par 
                                                                            // navigateur / non crypté
                                                                             storeMovieInLocalStorage(movie) ; 

                                                                            //Redirection vers l'index.html
                                                                            window.location.href="index.html" ;
                                                                            }

                                                }) ;

}) ;

