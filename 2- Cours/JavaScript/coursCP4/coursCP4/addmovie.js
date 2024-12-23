document.addEventListener("DOMContentLoaded",()=>{

    const movieForm = document.getElementById('movie-form');

    //Fonction de validation des données du formulaire
    function validateFormData(movie){
        //Valider que le champ title n'est ni vide ni composé uniquement d'espaces
        //Si title est vide ou contient uniqueemnt des espaces
        if (!movie.title.trim()){
            alert('Le titre est requis');
            return false;
        }
        if (!movie.description.trim()){
            alert('La description est requise');
            return false;
        }
        if (!movie.date){
            alert('La date est requise');
            return false;
        }
        if (!movie.color){
            alert('Veuillez choisir une couleur pour la bordure');
            return false;
        }
        return true;
    }

    function storeMovieInLocalStorage(movie){
        //Récupérer les films (si présent) du localStorage sinon tableau vide
        const storedData = localStorage.getItem('movies');
        const movies = storedData ? JSON.parse(storedData) : [];
        movies.push(movie);

        //Sauvegarde dans le localStorage
        localStorage.setItem('movies', JSON.stringify(movies));
    }


    //Gestionnaire de soumission du formulaire
    movieForm.addEventListener('submit', (event)=>{
        event.preventDefault(); // Empeche le rechargement de la page

        //Récupérer les valeurs des champs du formulaire
        const title = document.getElementById('movie-title').value;
        let img = document.getElementById('movie-img').value;
        img = img.split("\\")[2]; // split('\')
        const description = document.getElementById('movie-description').value;
        const date = document.getElementById('movie-date').value;
        const color = document.getElementById('movie-color').value;

        // movie = {img : img, description: description, date: date, color: color}
        const movie = {img, title, description, date, color};

        //Valider les données
        if (validateFormData(movie)){
            //Stockage dans le localStorage
            storeMovieInLocalStorage(movie);

            //Redirection vers l'index.html
            window.location.href="index.html";
        }


    });
});