

document.addEventListener ( 'DOMContentLoaded', function()
{
    //Je prépare mes constantes pour me rappeller de la façon dont je veut finir l'APPI plus taard.
    const screenWidht = window.innerWidth;
    const WelcomeSpace = document.getElementById("WelcomeSpace") ;
    const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
    

    // Je veux me préparer à l'éventualité d'utiliser la sortie de getdat() au bon format 
    // pour mon url de secours. On peut envisager un Switch Case avec un scénarion de gestion des disfonctionnements et erreurs 
    const currentDate = new Date();
    let mounth = currentDate.getMonth() ; 
    let goodmouthFormat = mounth + 1 ;
    if  (goodmouthFormat < 10) { goodmouthFormat =`0${goodmouthFormat}`};
    let myday = currentDate.getDay() ; if  (myday < 10) { myday =`0${myday}`};
    let neededDateFormat = `${currentDate.getFullYear()}-${goodmouthFormat}-${myday}` ;
    const actualEarthDate = neededDateFormat ;
    console.log(neededDateFormat) ;
    const earthDate = 'neededDateFormat'; 
    const startDate = '2024-01-01';
    const endDate = '2024-01-05';
    const spaceInHomePage = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}`; 
   
    
 
// Ma fonction a pour obectif d'afficher l'image du jour (par défaut la date d'aujourd'hui)
// proposée par la NASA grace au projet d'observation de l'espace
// Je fais une requête pour récupérer mon image
    fetch(spaceInHomePage)
    .then(response => 
    { // une fois la promesse reçue...
        if (!response.ok) 
            { // si la promesse est "false" ...
                throw new Error(`Erreur message : ${response.status}`);
            }
        return response.json(); //Je veux convertir ma réponse en JSON
    })  
    .then(data => 
    { 
        // Je fais un contrôle des données réçues en les affichant dans ma console
        console.log("Titre:", data.title);
        console.log("Description:", data.explanation);
        console.log("URL de l'image:", data.url);
        
        // Je veux créer un contenaire pour afficher mon image
        const imageElement = document.createElement('img');
        imageElement.src = data.url;  
        imageElement.alt = data.title;  
        imageElement.style.width = '100%';
        imageElement.style.justifyItems = 'center'
        imageElement.style.height = '100%';
        
        // Ajouter l'image à la page web
        WelcomeSpace.appendChild(imageElement);
        
        // Je recommance les opérations de coteneurisation et d'affichage pour 
        // le titre et la decription de l'image
        const titleElement = document.createElement('h2');
        titleElement.textContent = data.title;
        WelcomeSpace.appendChild(titleElement);
        
        const descriptionElement = document.createElement('p');
        descriptionElement.textContent = data.explanation;
        WelcomeSpace.appendChild(descriptionElement);
        WelcomeSpace.appendChild(descriptionElement).style.width = '90%';
        WelcomeSpace.appendChild(descriptionElement).style.margin = 'auto';
        WelcomeSpace.appendChild(descriptionElement).style.textAlign = 'justify';

    })



   } 
)
