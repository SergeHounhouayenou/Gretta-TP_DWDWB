

document.addEventListener ( 'DOMContentLoaded', function()
{
    //Je prépare mes constantes pour me rappeller de la façon dont je veut finir l'APPI plus taard.
    const screenWidht = window.innerWidth;
    const WelcomeHearth = document.getElementById("welPictPlace2") ;
    const hearthPictureSelected = document.getElementById("hearthPictureSelected") ;
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
    const hearthDate = 'neededDateFormat'; 
    const startDate = '2024-01-01';
    const endDate = '2024-01-05';
    const hearth = `https://api.nasa.gov/EPIC/api/natural?api_key=${apiKey}&date=${hearthDate}`;
  
  
//API HEARTH
// const hearth = `https://api.nasa.gov/EPIC/api/natural?api_key=${apiKey}`;

// Le procédé est identique à celui de l'espace. Les comentaires sont dessus.
      fetch(hearth)
      .then(response => {
        if (!response.ok) {
          throw new Error(`Erreur HTTP: ${response.status}`);
        }
        return response.json();
      }) 
    .then(data => {
    
    const images = data.sort((a, b) => new Date(b.date) - new Date(a.date));
    
    images.forEach(imageData => {
     
      const imageContainer = document.createElement('div');
      imageContainer.style.marginBottom = '20px';
      
      const titleElement = document.createElement('h2');
      titleElement.textContent = `${imageData.date} - ${imageData.title}`;
      imageContainer.appendChild(titleElement);

      const imageElement = document.createElement('img');
      
      // Insérer l'URL dans src de l'image
      imageElement.src = `https://epic.gsfc.nasa.gov/archive/natural/${imageData.date.substring(0, 4)}/${imageData.date.substring(5, 7)}/${imageData.date.substring(8, 10)}/jpg/${imageData.image}.jpg`;
      imageElement.alt = imageData.title;
      imageElement.style.maxWidth = '100%';
      imageContainer.appendChild(imageElement);
      
      // Créer la description de l'image
      const descriptionElement = document.createElement('p');
      descriptionElement.textContent = imageData.explanation;
      imageContainer.appendChild(descriptionElement);
      
      // Ajouter l'élément à la page web
      hearthPictureSelected.appendChild(imageContainer);
    });
  })
  .catch(error => {
    console.error('Erreur lors de la récupération des données :', error);
  });
  
   } 
)
