

document.addEventListener ( 'DOMContentLoaded', function()
    {
    const screenWidht = window.innerWidth;
    const WelcomeSpace = document.getElementById("welPictPlace1") ;
    const WelcomeHearth = document.getElementById("welPictPlace2") ;
    const WelcomeNeo = document.getElementById("welPictPlace3") ;
    const WelcomeMarch = document.getElementById("welPictPlace4")  ;

    const SpacePictureSelected = document.getElementById("welPictPlace11") ;
    const hearthPictureSelected = document.getElementById("welPictPlace21") ;
    const nearObjectsPictureSelected = document.getElementById("welPictPlace31") ;
    const marchPictureSelected = document.getElementById("welPictPlace41")  ;
    
    const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
    

    // Je veux me préparer à l'éventualité d'utiliser la sortie de getdat() au bon format pour mon url
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
    
    //Je veux maintenir récupérer la date de l'input calendier accissible à l'utilisateur 
    // et convertir cette date au bon format pour mon url
    // userDateSelection
    //     chosenDate

      
      
      document.addEventListener('click', function()
      {
       let moi = document.getElementById('userDateSelection').value
      {
        console.log(document.getElementById('hearthDateSelectedByUser').value) ;
      }
      
      })




      





     
       
   
    

            
          
      
    
    
      
    

    
  



// Je prépare ma liste de Rover et caméra associées pour être en mesure de rpondre 
// à d'éventuels problèmes d'accébilité opauqes qui serait liés à ces entités. 
// L'utilité est aussi de pouvoir alléger des requettes en ne concervant que le strct minimum
    const camera = 'FHAZ';
   
   
    const rover = 'curiosity';
    const roverCamera1 = 'MAST';
    const roverCamera2 = 'CHEMCAM';
    const roverCamera3 = 'MAHLI';
    const roverCamera4 = 'MARDI';
    const roverCamera5 = 'FHAZ';
    const roverCamera6 = 'RHAZ';
    const roverCamera7 = 'NAVCAM';

    const rover1 = 'opportunity'; 
    const rove1Camera1 = 'PANCAM';
    const rover1Camera2 = 'MINITES';
    const rover1Camera3 = 'FHAZ';
    const rover1Camera4 = 'RHAZ';
    const rover1Camera5 = 'NAVCAM';

    const rover2 = 'spirit'; 
    const rover2Camera1 = 'PANCAM';
    const rover2Camera2 = 'MINITES';
    const rover2Camera3 = 'FHAZ';
    const rover2Camera4 = 'RHAZ';
    const rover2Camera5 = 'NAVCAM';


    const rover3 = 'perseverance'; 
    const rover3Camera1 = 'FHAZ';
    const rover3Camera2 = 'RHAZ';
    const rover3Camera3 = 'NAVCAM';
    const rover3Camera4 = 'MAST';
    const rover3Camera5 = 'SuperCam';
    const rover3Camera6 = 'PIXL';
    const rover3Camera7 = 'SHERLOC';
    const rover3Camera8 = 'MEDA';
//https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?sol=1000&camera=FHAZ&api_key=DEMO_KEY

    
    
    
    
    const spaceInHomePage = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}`; 
    const space  = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}&start_date=${startDate}&end_date=${endDate}`;
    const hearth = `https://api.nasa.gov/EPIC/api/natural?api_key=${apiKey}`;
    const nearObjects = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${startDate}&end_date=${endDate}&api_key=${apiKey}`;
    const march = `https://api.nasa.gov/mars-photos/api/v1/rovers/${rover}/photos?earth_date=${earthDate}&camera=${camera}&api_key=${apiKey}`;

    
    

// Ma fonction a pour obectif d'afficher l'image du jour 
// proposée par la NASA pour l'observation de l'espace

// Je fais une requête pour récupérer mon image
fetch(spaceInHomePage)
.then(response => { // une fois la promesse reçue...
  if (!response.ok) { // si la promesse est "false" ...
    throw new Error(`Erreur HTTP : ${response.status}`);
  }
  return response.json();
})  //Je veux convertir ma réponse en JSON
  .then(data => { 
    // Je fais un contrôle des données réçues en les affichant dans ma console
    console.log("Titre:", data.title);
    console.log("Description:", data.explanation);
    console.log("URL de l'image:", data.url);
    
    // Je veux créer un contenaire pour afficher mon image
    const imageElement = document.createElement('img');
    imageElement.src = data.url;  
    imageElement.alt = data.title;  
    imageElement.style.width = '90%';
    imageElement.style.height = '25rem';
    
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
    WelcomeSpace.appendChild(descriptionElement).style.margin = 'auto'
    WelcomeSpace.appendChild(descriptionElement).style.textAlign = 'justify'

  })
  // Je veux exercer un contrôle sur les possibles ereurs afin de contrainde 
  // le comprtement du navigateur et ainsi éviter les bugs et latences anormales
  .catch(error => {
    console.error('Erreur lors de la récupération des données:', error);
  });

    

    
    // Fonction pour récupérer les images dans la plage de dates
    fetch(space)
    .then(response => {
      if (!response.ok) {
        throw new Error(`Erreur HTTP : ${response.status}`);
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
          imageContainer.appendChild(descriptionElement);
          
          // Ajouter l'élément à la page web
          SpacePictureSelected.appendChild(imageContainer);

        });
      })
      .catch(error => {
        console.error('Erreur lors de la récupération des données:', error);
        
      });    


// Le procédé est identique.
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



  fetch(nearObjects)
  .then(response => {
    if (!response.ok) {
      throw new Error(`Erreur HTTP : ${response.status}`);
    }
    return response.json();
  })
  .then(data => {
    const nearEarthObjects = data.near_earth_objects;

    if (!obj) {
      console.error('Objet non défini');
      return;
    }
    

    if (!obj.close_approach_data || obj.close_approach_data.length === 0) {
      console.warn(`Données manquantes pour l'objet ${obj.name}`);
      return;
    }
    


    // Créer un tableau avec tous les objets
    let allObjects = [];
    for (let date in nearEarthObjects) {
      allObjects = allObjects.concat(nearEarthObjects[date]);
    }

    // Trier les objets par nom (ou par d'autres critères)
    allObjects.sort((a, b) => a.name.localeCompare(b.name));
    document.getElementById.textContent =allObjects.forEach(obj => {
    if (obj.close_approach_data && obj.estimated_diameter) {
        console.log(`Nom: ${obj.name}`);
        console.log(`Date: ${obj.close_approach_data[0]?.close_approach_date}`);
        console.log(`Taille estimée: ${obj.estimated_diameter.kilometers?.estimated_diameter_max} km`);
    }
});


    // Sélectionner un conteneur HTML pour afficher les objets
    const container = document.getElementsByClassName('pictureContainer') ;
        // Afficher les objets
      allObjects.forEach(obj => {
      // Créer un conteneur pour chaque objet
      const objectContainer = document.createElement('div');
      objectContainer.style.border = '1px solid #ccc';
      objectContainer.style.marginBottom = '10px';
      objectContainer.style.padding = '10px';

      // Ajouter le nom de l'objet
      const nameElement = document.createElement('h3');
      nameElement.textContent = `Nom : ${obj.name}`;
      objectContainer.appendChild(nameElement);

      // Ajouter la date de passage rapproché
      const dateElement = document.createElement('p');
      dateElement.textContent = `Date de passage : ${obj.close_approach_data[0].close_approach_date}`;
      objectContainer.appendChild(dateElement);

      // Ajouter la taille estimée
      const sizeElement = document.createElement('p');
      sizeElement.textContent = `Taille estimée : ${obj.estimated_diameter.kilometers.estimated_diameter_max.toFixed(2)} km`;
      objectContainer.appendChild(sizeElement);

      // Ajouter une information supplémentaire (optionnel, exemple : vitesse)
      

      const velocityElement = document.createElement('p');
      const velocity = parseFloat(obj.close_approach_data[0].relative_velocity.kilometers_per_hour);
      if (!isNaN(velocity)) {
        const velocityText = velocity.toFixed(2);
        // Ajouter au DOM
      } else {
        console.warn('Vitesse invalide pour', obj.name);
      }

      velocityElement.textContent = `Vitesse : ${obj.close_approach_data[0].relative_velocity.kilometers_per_hour.toFixed(2)} km/h`;
      objectContainer.appendChild(velocityElement);

      // Ajouter cet objet au conteneur principal
      container.appendChild(objectContainer);
    });
  })
  .catch(error => console.error('Erreur :', error));

    



fetch(march)
 .then(response => {
    if (!response.ok) {
      throw new Error(`Erreur HTTP : ${response.status}`);
    }
    return response.json();
  })
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
     
       
    
   } 
)
