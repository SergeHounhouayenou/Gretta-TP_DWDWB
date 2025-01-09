

document.addEventListener ( 'DOMContentLoaded', function()
    {
    const WelcomeHearth = document.getElementById("welPictPlace1")  
    const myAppiKey = "a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo" ;
    
    const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
    const startDate = '2024-01-01';
    const endDate = '2024-01-05';
    const rover = 'curiosity'; // Vous pouvez aussi essayer 'opportunity' ou 'perseverance'
    const camera = 'FHAZ'; // Vous pouvez changer cela selon les caméras disponibles
    const earthDate = '2024-01-01'; // Exemple de date
    const url = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}&start_date=${startDate}&end_date=${endDate}`;
    const url1 = `https://api.nasa.gov/EPIC/api/natural?api_key=${apiKey}`;
    const url2 = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${startDate}&end_date=${endDate}&api_key=${apiKey}`;
    const url3 = `https://api.nasa.gov/mars-photos/api/v1/rovers/${rover}/photos?earth_date=${earthDate}&camera=${camera}&api_key=${apiKey}`;

    
    
    

    
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
          console.log(titleElement) ;
          console.log("TEST############################################################################") ;

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
          WelcomeHearth.appendChild(imageContainer);

        });
      })
      .catch(error => {
        console.error('Erreur lors de la récupération des données:', error);
        
      });    




fetch(url1)
  .then(response => response.json())
  
  .then(data => {
    // Trier les images par date
    data.sort((a, b) => new Date(b.date) - new Date(a.date));
console.log("3############################################################################") ;

    // Afficher les images
    data.forEach(imageData => {
    console.log(`Date: ${imageData.date}`);
    console.log(`URL de l'image: https://epic.gsfc.nasa.gov/archive/natural/${imageData.date.substring(0, 4)}/${imageData.date.substring(5, 7)}/${imageData.date.substring(8, 10)}/jpg/${imageData.image}.jpg`);

    });
  })
  .catch(error => console.error('Erreur:', error));


  
  
  
  fetch(url2)
    .then(response => response.json())
    .then(data => {
      const nearEarthObjects = data.near_earth_objects;

      // Créer un tableau avec tous les objets et les trier par date
      let allObjects = [];
      for (let date in nearEarthObjects) {
        allObjects = allObjects.concat(nearEarthObjects[date]);
      }
          console.log("############################################################################")

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



fetch(url3)
  .then(response => response.json())
  .then(data => {
    const photos = data.photos;

    // Trier les photos par date (dans ce cas, toutes les photos sont de la même date)
    photos.sort((a, b) => new Date(b.earth_date) - new Date(a.earth_date));

    // Afficher les photos
    console.log("############################################################################")  

    photos.forEach(photo => {
      console.log(`Nom de la caméra: ${photo.camera.full_name}`);
      console.log(`Date: ${photo.earth_date}`);
      console.log(`URL de la photo: ${photo.img_src}`);
    });
  })
  .catch(error => console.error('Erreur:', error));
  


       
       
       
       
       /*
       
        const myAppiKey = "a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo" ;
        const WelcomeHearth = document.getElementById("welPictPlace1") ;
        
            //Fonction pour récupérer les images depuis la base de donnée de la Nasa
            async function getData() 
            {
                console.log("test de contrôle du fichier Js") ;
                WelcomeHearth.textContent = " Un test de contrôle du fichier Js"
                try
                    {
                        const response = await fetch(`https://api.nasa.gov/planetary/apod?api_key=${myAppiKey}&date=2025-01-01`);
                        if (!response.ok)
                        {
                            throw new Error('Erreur lors du chargement de l\'image') ;
                        }
                        const data = await response.json();
                        if (data.results.length === 0)
                        {
                            WelcomeHearth.innerHTML = `<p class="" id=""> l'image de l'Espace d'aujourd'hui n'a pas été trouvée </p>` ;
                        }
                        else
                        {
                            WelcomeHearth.innerHTML = `<div class="" id=""> data.results </div>` ;
                        }
                        console.log("Titre:", data.title);
                        console.log("Description:", data.explanation);
                        console.log("URL de l'image:", data.url);
                    } 
                    

                catch (error)
                    {
                        WelcomeHearth.innerHTML = `<p class="" id="">${error.message}</p>` ;
            
                    }
                }
            getData() ;
      */
   } 
)