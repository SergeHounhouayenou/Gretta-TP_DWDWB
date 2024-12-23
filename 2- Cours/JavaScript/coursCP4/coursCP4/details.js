document.addEventListener('DOMContentLoaded', ()=>{

    const apiKey='e7ea9a70f1ad3360494ebf15782b267c';
    const movieDetail = document.getElementById('movieDetail');
    //Exploitation de URL
    const urlParams = new URLSearchParams(window.location.search);
    const movieId = urlParams.get('id');
    const recommendationsContainer = document.getElementById('movieRecommendations');

    async function fetchMovieDetails(id){
        try{
            const response = await
                fetch(`https://api.themoviedb.org/3/movie/${id}?api_key=${apiKey}`);
            if (!response.ok){
                throw new Error('Erreur de lors de la récupération des détails du film');
            }
            const movie = await response.json();
            displayMovieDetails(movie);
        }catch (e) {
            movieDetail.innerHTML = `<div class="col-12 text-center"><p class="text-danger">${error.message}</p></div>`;
        }
    }

    function displayMovieDetails(movie){
        movieDetail.innerHTML=`
            <div class="col-md-4 text-center">
                 <img class="movie-poster" alt="${movie.title}" 
                      src="${movie.poster_path ? 'https://image.tmdb.org/t/p/w500'+ movie.poster_path : 'https://via.placeholder.com/150'}">
            </div>
            <div class="col-md-8 movie-details">
                <h2 class="movie-title">${movie.title}</h2>
                <p class="movie-info">
                    <strong>Date de sortie: </strong>
                    ${movie.release_date || 'N/A'}
                </p>
                <p class="movie-info">
                    <strong>Description: </strong>
                    ${movie.overview || 'N/A'}
                </p>
                <p class="movie-info">
                    <strong>Note moyenne: </strong>
                    ${movie.vote_average || 'N/A'}
                </p>
                <p class="movie-info">
                    <strong>Langue originale: </strong>
                    ${movie.original_language || 'N/A'}
                </p>
                <p class="movie-info">
                    <strong>Durée: </strong>
                    ${movie.runtime? movie.runtime+" min" : 'N/A'}
                </p>
                <a href="movieAjax.html" class="btn btn-light">Retour</a>
            </div>
        `;
    }

    //Fonction pour récupérer les films similaires
    async function fetchMovieRecommendations(id){
        try{
            const response = await
                fetch(`https://api.themoviedb.org/3/movie/${id}/similar?api_key=${apiKey}`);
            if (!response.ok){
                throw new Error("Erreur lors de la récupération des recommandations");
            }
            const data = await response.json();
            displayMovieRecommendations(data.results);
        }catch (e) {
            recommendationsContainer.innerHTML = `<div class="col-12 text-center"><p class="text-danger">${error.message}</p></div>`;

        }
    }

    let isShowingAll = false;
    function displayMovieRecommendations(movies){

        const limitedMovies =  isShowingAll ? movies : movies.slice(0,4);
        if (limitedMovies.length===0){
            recommendationsContainer.innerHTML =
                `<div class="col-12 text-center">
                    <p class="text-danger">Aucune recommendation disponible</p></div>`;
        }
        recommendationsContainer.innerHTML= limitedMovies.map(
            movie =>
                `<div class="col-12 col-md-3">
                <a href="details.html?id=${movie.id}" class="text-decoration-none">
                    <div class="card h-100 shadow">
                        <img class="card-img-top movie-poster" alt="${movie.title}" 
                        src="${movie.poster_path ? 'https://image.tmdb.org/t/p/w500'+ movie.poster_path : 'https://via.placeholder.com/150'}">
                        <div class="card-body">
                            <h5 class="card-title">${movie.title}</h5>
                            <p class="card-text">Date de sortie : ${movie.release_date || 'Non renseigné'}</p>
                            <p class="card-text">${movie.overview ? movie.overview.substring(0,50)+'...' : 'Pas de description'}</p>
                        </div>
                    </div>
                </a>
            </div>`
        ).join('');
        //Bouton voir plus
        if (movies.length > 4 && !isShowingAll){
            recommendationsContainer.innerHTML += `
                    <div class="col-12 text-center">
                        <button class="btn btn-light" id="showMoreBtn">Voir plus</button>
                    </div>
            `;
            document.getElementById('showMoreBtn').addEventListener('click',
                ()=>{
                    isShowingAll=true;
                    displayMovieRecommendations(movies);
                }
                );
        }
    }

    if (movieId){
        fetchMovieDetails(movieId);
        fetchMovieRecommendations(movieId);
    }else{
        movieDetail.innerHTML = `<div class="col-12 text-center">
            <p class="text-danger">Aucun film selectionné</p></div>`;
    }



})