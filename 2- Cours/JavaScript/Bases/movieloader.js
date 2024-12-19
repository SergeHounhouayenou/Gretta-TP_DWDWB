document.addEventListener('DOMContentLoaded', function() 
{
const movieSearch= document.getElementById('movieSearch');
const movieResults = document.getElementById('movieResults');
const apiKey = "d9797a92cd99a3a89d9fdc08d3fdd8fe";
const voiceSearchBtn = document.getElementById('voiceSearchBtn');

function initializeVoiceSearch()
    {
        //Vérifier si le avigateur prend en charge API Web Speach
        if (!('webkitSpeechRecognition' in window))
        {
            alert('La reconnaissance vocale n\'est pas prise en charge par votre navigateur') ;
            return;
        }
    }
    const recognition = new webkitSpeechRecognition() ;
    recognition.lang = 'fr-FR' ;
    recognition.interimResults = false ;
    recognition.maxAlternatives = 1 ;

//Fonction pour récupérer les films depuis API
async function fetchMovies(query) 
    {
        try
            {
                const response = await fetch(`https://api.themoviedb.org/3/search/movie?api_key=${apiKey}&query=${encodeURIComponent(query)}`);
                if (!response.ok)
                {
                    throw new Error('Erreur lors du chargement de API TMDB') ;
                }
                const data = await response.json();
                if (data.results.length === 0)
                {
                    movieResults.innerHTML = `<div class="col-12 text-center"><p class="text-danger">Aucun film trouvé</p></div>` ;
                }
                else
                {
                    displayMovies(data.results) ;
                }
                console.log(data);
            } 
            

        catch (error)
            {
                movieResults.innerHTML = `<div class="col-12 text-center"> <p class="text-danger">${error.message}</p></div>` ;
            } 
    
    // Fonction pour affiche les films
    function displayMovies(movies)
    {
        console.log(movies);
        movieResults.innerHTML = movies.map(movie => 
            `<div class="col-12 col-md-4">
                <a href="details.html?id=${movie.id}" class= "text-decoration-none">
                <div class="card h-100 shadow">
                    <img class="card-img-top movie-poster" alt="${movie.tite}" 
                    src="${movie.poster_path ? 'https://image.tmdb.org/t/p/w500' + movie.poster_path : 'https://via.placeholder.com/150'}">
                    
                    <div class="card-body">
                        <h5 class="card-title">${movie.title}</h5>
                        <p class="card-text">Date de sortie : ${moveBy.release_date || 'Non renseigné'}</p>
                        <p class="card-text">${movie.overview ? movie.overview.substring(0,50)+'...' : 'pas de description'}</p>
                    </div>
                </div>
                </a>
                
            </div>`
        ).join(''); // Join va convertir le retour du MAP en chaîne de caractère
    }
            
    }
    //Ecouteur d'évènement pour la recherche
    movieSearch.addEventListener('input', () => 
        {
            const query = movieSearch.value.trim();
            if (query.length>1)
            {
                fetchMovies(query);
            }
            else
            {
                //Réinitialiser les résultats
                movieResults.innerHtml = '' ;
            }
        }    
        )

})