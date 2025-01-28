

document.addEventListener ( 'DOMContentLoaded', function()
{
    //Je prépare mes constantes pour me rappeller de la façon dont je veut finir l'APPI plus taard.
    const screenWidht = window.innerWidth;
    const SpacePictureSelected = document.getElementById("welPictPlace11") ;
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

    // Je prépare la possibilité que l'utilisateur choisisse une date sur un calendrier
    //Je veux maintenir récupérer la date de l'input calendier accissible à l'utilisateur 
    // pour un autre url que les présentations par défaut
       
    const space  = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}&start_date=${startDate}&end_date=${endDate}`;
       
    // Fonction pour récupérer les images dans la plage de dates
    fetch(space)
    .then(response => {
      if (!response.ok) {
        throw new Error(`Erreur message: ${response.status}`);
      }
      return response.json();
    })  // Convertir la réponse en JSON
      .then(data => {
        // Filtrer les données pour ne garder que les images
        const images = data.filter(item => item.media_type === 'image');

        // Trier les images par date (les plus récentes en premier)
        images.sort((a, b) => new Date(b.date) - new Date(a.date));

        // Créer un élément HTML pour chaque image
        images.forEach(imageData => {
          // Créer un conteneur pour l'image et les informations
          const imageContainer = document.createElement('div');
          imageContainer.style.marginBottom = '20px';
          
          // Créer un titre pour l'image
          const titleElement = document.createElement('h2');
          titleElement.textContent = `${imageData.date} - ${imageData.title}`;
          imageContainer.appendChild(titleElement);
          console.log(titleElement) ;
         

          // Créer l'élément image
          const imageElement = document.createElement('img');
          imageElement.src = imageData.url;
          imageElement.alt = imageData.title;
          imageElement.style.maxWidth = '100%';
          imageContainer.appendChild(imageElement);
          
          // Créer la description de l'image
          const descriptionElement = document.createElement('p');
          descriptionElement.textContent = imageData.explanation;
          descriptionElement.style.marginLeft = '4rem';
          descriptionElement.style.marginRight = '4rem';
          descriptionElement.style.textAlign = 'justify';
          imageContainer.appendChild(descriptionElement);
          
          // Ajouter l'élément à la page web
          SpacePictureSelected.appendChild(imageContainer);

        });
      })
      .catch(error => {
        console.error('Erreur lors de la récupération des données:', error);
        
      });    
   } 
)
