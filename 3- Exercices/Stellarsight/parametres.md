
### APOD Parametres

'concept_tags',
'date',
 'hd',
 'count',
 'start_date',
 'end_date',
 'thumbs'


### Archive APOD

       // Remplacez 'YOUR_API_KEY' par votre propre clé API obtenue sur le site de la NASA
const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
const url = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}`; 


// Fonction pour récupérer l'image du jour
fetch(url)
  .then(response => response.json())  // Convertir la réponse en JSON
  .then(data => {
    // Afficher les informations dans la console
    console.log("Titre:", data.title);
    console.log("Description:", data.explanation);
    console.log("URL de l'image:", data.url);
    
    // Créer un élément pour afficher l'image
    const imageElement = document.createElement('img');
    imageElement.src = data.url;  // Assigner l'URL de l'image à l'élément img
    imageElement.alt = data.title;  // Ajouter un texte alternatif pour l'image
    
    // Ajouter l'image à la page web
    document.getElementById("welPictPlace1").appendChild(imageElement);
    
    // Afficher le titre et la description
    const titleElement = document.createElement('h1');
    titleElement.textContent = data.title;
    document.body.appendChild(titleElement);
    
    const descriptionElement = document.createElement('p');
    descriptionElement.textContent = data.explanation;
    document.body.appendChild(descriptionElement);
  })
  .catch(error => {
    console.error('Erreur lors de la récupération des données:', error);
  });





### APO BIS avec range date

  // Remplacez 'YOUR_API_KEY' par votre propre clé API
const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';

// Définir une plage de dates (par exemple, du 1er janvier 2024 au 5 janvier 2024)
const startDate = '2024-01-07';
const endDate = '2024-01-08';

// Créer l'URL avec la plage de dates
const url = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}&start_date=${startDate}&end_date=${endDate}`;

// Fonction pour récupérer les images dans la plage de dates
fetch(url)
  .then(response => response.json())  // Convertir la réponse en JSON
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
      
      // Créer l'élément image
      const imageElement = document.createElement('img');
      imageElement.src = imageData.url;
      imageElement.alt = imageData.title;
      imageElement.style.maxWidth = '100%';
      imageContainer.appendChild(imageElement);
      
      // Créer la description de l'image
      const descriptionElement = document.createElement('p');
      descriptionElement.textContent = imageData.explanation;
      imageContainer.appendChild(descriptionElement);
      
      // Ajouter l'élément à la page web
      document.body.appendChild(imageContainer);
    });
  })
  .catch(error => {
    console.error('Erreur lors de la récupération des données:', error);
  });








### Archive EPIC

https://api.nasa.gov/EPIC/api/natural

https://api.nasa.gov/EPIC/api/natural?api_key=YOUR_API_KEY&date=YYYY-MM-DD


const apiKey = 'YOUR_API_KEY';
const url = `https://api.nasa.gov/EPIC/api/natural?api_key=${apiKey}`;

fetch(url)
  .then(response => response.json())
  .then(data => {
    // Trier les images par date
    data.sort((a, b) => new Date(b.date) - new Date(a.date));

    // Afficher les images
    data.forEach(imageData => {
      console.log(`Date: ${imageData.date}`);
      console.log(`URL de l'image: https://epic.gsfc.nasa.gov/archive/natural/${imageData.date.substring(0, 4)}/${imageData.date.substring(5, 7)}/${imageData.date.substring(8, 10)}/jpg/${imageData.image}.jpg`);
    });
  })
  .catch(error => console.error('Erreur:', error));

Filtrage par date : Les images sont disponibles par date, et vous pouvez filtrer ou trier les résultats en fonction de cette date.
Images spécifiques : Les images sont accessibles via une URL construite avec des informations sur la date et l'image.


### Archive NEOWS

https://api.nasa.gov/neo/rest/v1/feed

https://api.nasa.gov/neo/rest/v1/feed?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD&api_key=YOUR_API_KEY

const apiKey = 'YOUR_API_KEY';
const startDate = '2024-01-01';
const endDate = '2024-01-05';
const url = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${startDate}&end_date=${endDate}&api_key=${apiKey}`;

fetch(url)
  .then(response => response.json())
  .then(data => {
    const nearEarthObjects = data.near_earth_objects;

    // Créer un tableau avec tous les objets et les trier par date
    let allObjects = [];
    for (let date in nearEarthObjects) {
      allObjects = allObjects.concat(nearEarthObjects[date]);
    }

    // Trier les objets par nom (ou par d'autres critères)
    allObjects.sort((a, b) => a.name.localeCompare(b.name));

    // Afficher les objets
    allObjects.forEach(obj => {
      console.log(`Nom: ${obj.name}`);
      console.log(`Date: ${obj.close_approach_data[0].close_approach_date}`);
      console.log(`Taille estimée: ${obj.estimated_diameter.kilometers.estimated_diameter_max} km`);
    });
  })
  .catch(error => console.error('Erreur:', error));

Filtrage par date : Les objets peuvent être récupérés en fonction d'une plage de dates, et vous pouvez trier les résultats par leur nom ou par la date de leur approche.
Objets proches : Vous pouvez aussi récupérer des informations détaillées sur chaque objet comme sa taille et son approche proche.



### Archive Mars Rover

https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos


https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=YYYY-MM-DD&camera=FHAZ&api_key=YOUR_API_KEY


const apiKey = 'YOUR_API_KEY';
const rover = 'curiosity'; // Vous pouvez aussi essayer 'opportunity' ou 'perseverance'
const camera = 'FHAZ'; // Vous pouvez changer cela selon les caméras disponibles
const earthDate = '2024-01-01'; // Exemple de date

const url = `https://api.nasa.gov/mars-photos/api/v1/rovers/${rover}/photos?earth_date=${earthDate}&camera=${camera}&api_key=${apiKey}`;

fetch(url)
  .then(response => response.json())
  .then(data => {
    const photos = data.photos;

    // Trier les photos par date (dans ce cas, toutes les photos sont de la même date)
    photos.sort((a, b) => new Date(b.earth_date) - new Date(a.earth_date));

    // Afficher les photos
    photos.forEach(photo => {
      console.log(`Nom de la caméra: ${photo.camera.full_name}`);
      console.log(`Date: ${photo.earth_date}`);
      console.log(`URL de la photo: ${photo.img_src}`);
    });
  })
  .catch(error => console.error('Erreur:', error));

Filtrage par caméra : Vous pouvez filtrer les résultats par caméra (par exemple, FHAZ, RHAZ, etc.).
Filtrage par date : Vous pouvez récupérer des photos prises à une date spécifique sur Mars.
Résumé et conseils :
Earth Polychromatic Imaging Camera (EPIC) : Vous pouvez récupérer les images en fonction de la date et les trier par date.
NeoWs API : Vous pouvez récupérer des objets proches de la Terre pour une plage de dates spécifique et les trier par date ou par nom.
Mars Rover Photos API : Vous pouvez récupérer les photos des rovers martiens en fonction de la date et de la caméra, et les trier selon vos critères.
Toutes ces API offrent des filtres pour spécifier des critères de date, de caméra et d'autres informations. Vous pouvez trier les résultats sur ces bases en utilisant des méthodes de tri dans JavaScript comme sort().





