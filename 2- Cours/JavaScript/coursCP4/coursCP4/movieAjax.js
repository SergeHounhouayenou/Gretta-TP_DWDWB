document.addEventListener('DOMContentLoaded', function(){
    const movieSearch = document.getElementById('movieSearch');
    const movieResults = document.getElementById('movieResults');
    const apiKey='e7ea9a70f1ad3360494ebf15782b267c';
    const voiceSearchBtn = document.getElementById('voiceSearchBtn');
    const loadChartBtn = document.getElementById('loadChart');

    loadChartBtn.addEventListener('click', ()=>{
        window.location.href='chart.html';
    });

    function initializeVoiceSearch(){
        //Vérifiez si le navigateur prend en charge API Web Speech
        if (!('webkitSpeechRecognition' in window)){
            alert('La recherche vocale nest pas prise en charge par votre navigateur');
            return;
        }

        const recognition = new webkitSpeechRecognition();
        recognition.lang='fr-FR';
        recognition.interimResults=false;
        recognition.maxAlternatives=1;

        //Commence l'ecoute lorsque le bouton est cliqué
        voiceSearchBtn.addEventListener('click', ()=>{
            recognition.start();
            updateVoiceButtonState("listening");
        });

        //gère la fin de l'écoute
        recognition.addEventListener('end', ()=>{
            updateVoiceButtonState("idle");
        })

        //Récupère le résultat de la reconnaissance vocale
        recognition.addEventListener('result', (event)=>{
            const speechResult = event.results[0][0].transcript;
            movieSearch.value = speechResult; //remplir la barre de recherche
            fetchMovies(speechResult); //Recherche avec texte transcrit
        });

        //Gère les erreurs
        recognition.addEventListener('error', (event)=>{
            console.log('Erreur de reconnaissance vocale', event.error);
            updateVoiceButtonState("idle");
            alert("Erreur de la reconnaissance vocale, veuillez réessayer");
        })

    }

    function updateVoiceButtonState(state){
        if (state === "listening"){
            voiceSearchBtn.disabled = true;
            voiceSearchBtn.textContent= "🎙️ En écoute...";
        }else{
            voiceSearchBtn.disabled = false;
            voiceSearchBtn.textContent="🎤";
        }
    }

    //Fonction pour récupérer les films depuis API
    async function fetchMovies(query){
        try{
            const response = await fetch(`https://api.themoviedb.org/3/search/movie?api_key=${apiKey}&query=${encodeURIComponent(query)}`);
            if (!response.ok){
                throw new Error('Erreur lors du chargement de API TMDb');
            }
            const data = await response.json();
            if (data.results.length ===0){
                movieResults.innerHTML = `<div class="col-12 text-center"><p class="text-danger">Aucun film trouvé</p></div>`;
            }else {
                displayMovies(data.results);
            }

        }catch (error) {
            movieResults.innerHTML = `<div class="col-12 text-center"><p class="text-danger">${error.message}</p></div>`;
        }
    }

    async function fetchTrendingMovies() {
        try {
            const response = await fetch(`https://api.themoviedb.org/3/trending/movie/day?api_key=${apiKey}`);
            if (!response.ok) {
                throw new Error('Erreur lors du chargement de API TMDb');
            }
            const data = await response.json();
            if (data.results.length === 0) {
                movieResults.innerHTML = `<div class="col-12 text-center"><p class="text-danger">Aucun film trouvé</p></div>`;
            } else {
                displayMovies(data.results);
            }
        }catch (e){
            movieResults.innerHTML = `<div class="col-12 text-center"><p class="text-danger">${error.message}</p></div>`;
        }
    }
    fetchTrendingMovies();

    //Fonction pour afficher les films
    function displayMovies(movies){
        console.log(movies);
        movieResults.innerHTML = movies.map(movie =>
            `<div class="col-12 col-md-4">
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
    }

    //Ecouteur d'evenement pour la recherche
    movieSearch.addEventListener('input', ()=>{
        const query = movieSearch.value.trim();
        if (query.length>1){
            fetchMovies(query);
        }else{
            //Réinitialiser les résultats
            movieResults.innerHTML = '';
            fetchTrendingMovies();
        }

    })

    //Initialisation de la recherche vocale
    initializeVoiceSearch();

})