document.addEventListener("DOMContentLoaded",()=>{
    const titre = document.getElementById('movie-title');
    const movieForm = document.getElementById('movie-form');

    //Fonction de validation des données du formulaire
    function validateFormData(movie){
        if (!movie.title.trim()){ //valide si le champs title n'est ni vide ni composé uniquement d'espace
            alert('Le titre est requis');
            return false;
        }
        if (!movie.description.trim()){
            alert('La description est requise');
            return false;
        }
        if (!movie.date){ //si il n'y a pas de date
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
        //Récupérer les films (si présent) du localStorage
        const storedData = localStorage.getItem('movies');
        const movies = storedData ? JSON.parse(storedData) : [];
        console.log(movies);
        movies.push(movie);

        //on est ds une sauvegarde, on veut ajouter a ce qui est déja présent
        localStorage.setItem('movies', JSON.stringify(movies));
    }

    //Gestionnaire de soumission du formulaire(Quand le formulaire est soumis => récupérer les infos)
    movieForm.addEventListener('submit',(event)=>{
        event.preventDefault();//Empeche le rechargement de la page
    
        //Recupérer les valeurs des champs du formulaire
        const title = document.getElementById('movie-title').value;
        let img = document.getElementById('movie-img').value;
        img = img.split('\\')[2]; //indique de couper les caractère au niveau des anti-slash
        const description = document.getElementById('movie-description').value;
        const date = document.getElementById('movie-date').value;
        const color = document.getElementById('movie-color').value;

        const movie = {img, title, description, date, color}; //syntaxe abrégé  //la syntaxe complete que fait JS est : movie = {img : img,...}



        //Valider les données

        if (validateFormData(movie)){
            //Stockage ds le localStorage
            storeMovieInLocalStorage(movie)

            //Redirection vers l'index.html (grâce à l'objet window)
            window.location.href="index.html";
        }
    });
    

});