document.addEventListener('DOMContentLoaded', ()=>{
    const apiKey='e7ea9a70f1ad3360494ebf15782b267c';

    //fonction pour récupérer les genres des films
    async function fetchGenres(){
        try{
            const response = await fetch(`https://api.themoviedb.org/3/genre/movie/list?api_key=${apiKey}&language=fr-FR`);
            if (!response.ok) {
                throw new Error("Erreur lors du chargement");
            }
            const data= await response.json();
            return data.genres;
        }catch (e) {
            console.error(e.message);
            alert('Une erreur sest produite lors du chargement des genres');
            return [];
        }
    }

    //Fonction pour récuperer les films populaires et compter les occurrences
    // des genres
    async function fetchMoviesAndCountGenres(){
        try{
            const response = await fetch(`https://api.themoviedb.org/3/movie/popular?api_key=${apiKey}&language=fr-FR&page=1`);
            if (!response.ok){
                throw new Error("Erreur de la récupération des films populaires");
            }
            const data = await response.json();
            const movies = data.results;

            const genres = await fetchGenres();
            const genreCounts={};

            console.log(genres);
            console.log(movies);

            genres.forEach(genre => genreCounts[genre.name]=0);
            movies.forEach(movie=>{ //Pour chaque film
                movie.genre_ids.forEach(genreId=>{ //Chaque genre du film
                    const genre = genres.find(g => g.id === genreId);
                    if (genre){
                        genreCounts[genre.name]++;
                    }
                });
            });
            return genreCounts;

        }catch (e) {
            alert('une erreur sest produite lors du chargement des films');
            return {};
        }
    }

    //Fonction pour créer le graphique
    async function createChart(){
        const genreCounts = await fetchMoviesAndCountGenres();

        //Préparation du contexte pour le graphique en 2D
        const ctx = document.getElementById('genreChart').getContext('2d');

        //Création du graphique avec new Chart
        new Chart(ctx,{
            type: 'bar',
            data:{
                labels: Object.keys(genreCounts),
                datasets:[{
                    label: "Nombre de films",
                    data: Object.values(genreCounts),
                    backgroundColor: 'rgba(75,192,192,0.2)',
                    borderColor: 'rgba(75,192,192,1)',
                    borderWidth:1
                }]
            },
            options:{
                responsive:true,
                plugins:{
                    legend:{
                        display:true,
                        position:'top'
                    },
                    title:{
                        display:true,
                        text:"Distribution des genres des films populaires"
                    }
                },
                scales:{
                    y:{
                        beginAtZero:true
                    }
                }
            }
        });
    }
    createChart();
})