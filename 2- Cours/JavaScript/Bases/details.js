document.addEventListener('DOMContentLoaded', () =>
{
    const apiKey = "d9797a92cd99a3a89d9fdc08d3fdd8fe";
    const movieDetail = document.getElementById('movieDetail') ;
    // Exploration de l'URL
    const urlParams = new URLSearchParams(window.location.search)
    const movieId = urlParams.get('id') ;
    console.log(movieId) ;
    console.log(window.location.search) ;
    const recommandationsContainer = document.getElementById('movieRecommandations') ;


async function fetchMovieDetails(id)
    {
        try
            {
                const response = await fetch (`https://api.themoviedb.org/3/movie/${id}?api_key=${apiKey}`);
                if (!response.ok)
                {
                    throw new Error ('Erreur lors du la chargement du film');
                }
                const movie = await response.json();
                displayMovieDetails(movie);
            }
            catch (error)
            {
                movieResults.innerHTML = `<div class="col-12 text-center"> 
                                          <p class="text-danger">${error.message}</p></div>
                                          ` ;
            } 
    }

    function displayMovieDetails(movie)
    {
        movieDetail.innerHTML = `
                                    <div class="col-md-4 text-center ">
                                        <img class="movie-poster" alt="${movie.title}"
                                        src="${movie.poster_path ? 'https://image.tmdb.org/t/p/w500' + movie.poster_path : 'https://via.placeholder.com/150'}">
                                    </div>
                                    <div class="col-md-8 movie-details">
                                        <h2 class="movie-title">${movie.title}</h2>
                                        <p class="movie-info">
                                            <strong> Date de sortie : </strong>
                                            ${movie.release_date || 'N/A'}
                                        </p>
                                        <p class="movie-info">
                                            <strong> Date de sortie : </strong>
                                            ${movie.overview || 'N/A'}
                                        </p>
                                        <p class="movie-info">
                                            <strong> Note moyenne : </strong>
                                            ${movie.vote_average || 'N/A'}
                                        </p>
                                        <p class="movie-info">
                                            <strong> Durée : </strong>
                                            ${movie.runtime? movie.runtime + "min" : 'N/A'}
                                        </p>
                                        <a href = "movieloader.html" class="btn btn-light"> Retour </a>
                                    </div>
                                `
    }

    //Fonction pour récupérer les films similaires
    async function fetchMovieRecommmandation(id)
    {
        try
        {
            const response = await
            fetch (`https://api.themoviedb.org/3/movie/${id}/similar?api_key=${apiKey}`);
            if (!response.ok)
            {
                throw new Error("Erreur lors de la récupération des recommandations")
            }
            const data = await response.json();
            displayMovieRecommandations(data.results);
            console.log(data) ;
        }
        catch (error)
            {
                recommandationsContainer.innerHTML = 
                                        `
                                        <div class="col-12 text-center"> 
                                         <p class="text-danger">${error.message}
                                         </p>
                                         </div>
                                         ` ;
            } 

    }
    let isShowingAll = false ;
    function displayMovieRecommandations(movies)
    {
        
        const limitedMovies = isShowingAll ? movies : movies.slice(0,4) ;

        if (limitedMovies.length===0)
        {
            recommandationsContainer.innerHTML = `<div class="col-12 text-center"><p class="text-danger">Aucune recommendation disponibles</p></div>`; 
        }
            recommandationsContainer.innerHTML = limitedMovies.map
            (movie => 
                `<div class="col-12 col-md-3">
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
           
            // Bouton voir plus
            
            if (movies.length > 4 && !isShowingAll)
                {
                recommandationsContainer.innerHTML +=
                    `
                    <div class="col-12 text-center">
                        <button class="btn btn-light" id="showMoreBtn">Voir plus </button>
                    </div>
                    `;
                    document.getElementById('showMoreBtn').addEventListener('click',
                        ()=> 
                        {
                            isShowingAll = true;
                            displayMovieRecommandations(movies) ;
                        }
                        ) ;
                }

        
       // recommandationsContainer.innerHTML = movies.map().join('');
    }


    if (movieId)
    {
        fetchMovieDetails(movieId) ;
        fetchMovieRecommmandation(movieId) ;
    }
    else
    {
        movieDetail.innerHtml = `<div class="col-12 text-center">
                                 <p class="text-danger"> Aucun film sélectionné </p> </div> ;
                                `
    }
}

)