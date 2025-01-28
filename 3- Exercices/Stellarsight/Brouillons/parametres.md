


<div>
  <label for="group-select">Choisir un groupe :</label>
  <select id="group-select">
    <option value="">-- Sélectionnez un groupe --</option>
  </select>
</div>

<div>
  <label for="camera-select">Choisir une caméra :</label>
  <select id="camera-select" disabled>
    <option value="">-- Sélectionnez une caméra --</option>
  </select>
</div>

<div id="photo-gallery">
  <!-- Les photos seront affichées ici -->
</div>


// Exemple de données simulées
const photos = [
  // Exemple : chaque objet représente une photo avec un groupe, une caméra et une URL
  { group: 1, camera: 'FHAZ', url: 'photo1.jpg' },
  { group: 1, camera: 'RHAZ', url: 'photo2.jpg' },
  { group: 1, camera: 'NAVCAM', url: 'photo3.jpg' },
  { group: 2, camera: 'FHAZ', url: 'photo4.jpg' },
  { group: 2, camera: 'RHAZ', url: 'photo5.jpg' },
  { group: 2, camera: 'MAST', url: 'photo6.jpg' },
];

// Récupérer les éléments HTML
const groupSelect = document.getElementById('group-select');
const cameraSelect = document.getElementById('camera-select');
const photoGallery = document.getElementById('photo-gallery');

// Organiser les photos par groupes
const groups = [...new Set(photos.map(photo => photo.group))]; // Trouver tous les groupes uniques
groups.forEach(group => {
  const option = document.createElement('option');
  option.value = group;
  option.textContent = `Groupe ${group}`;
  groupSelect.appendChild(option);
});

// Gérer le changement dans le premier select (groupes)
groupSelect.addEventListener('change', () => {
  const selectedGroup = parseInt(groupSelect.value);

  // Filtrer les photos du groupe sélectionné
  const filteredPhotos = photos.filter(photo => photo.group === selectedGroup);

  // Trouver toutes les caméras disponibles dans le groupe
  const cameras = [...new Set(filteredPhotos.map(photo => photo.camera))];

  // Mettre à jour le second select (caméras)
  cameraSelect.innerHTML = '<option value="">-- Sélectionnez une caméra --</option>';
  cameras.forEach(camera => {
    const option = document.createElement('option');
    option.value = camera;
    option.textContent = camera;
    cameraSelect.appendChild(option);
  });

  // Activer le menu déroulant des caméras
  cameraSelect.disabled = false;
});

// Gérer le changement dans le second select (caméras)
cameraSelect.addEventListener('change', () => {
  const selectedGroup = parseInt(groupSelect.value);
  const selectedCamera = cameraSelect.value;

  // Filtrer les photos par groupe et caméra
  const filteredPhotos = photos.filter(
    photo => photo.group === selectedGroup && photo.camera === selectedCamera
  );

  // Afficher les photos dans la galerie
  photoGallery.innerHTML = ''; // Vider la galerie existante
  filteredPhotos.forEach(photo => {
    const img = document.createElement('img');
    img.src = photo.url;
    img.alt = `Photo prise par ${photo.camera}`;
    img.style.maxWidth = '150px';
    img.style.margin = '10px';
    photoGallery.appendChild(img);
  });
});




Explication du Code
Génération du premier menu <select> :

Les groupes sont extraits de la liste des photos avec Set pour éviter les doublons.
Chaque groupe devient une option du menu.
Changement dans le premier menu :

Lorsque l'utilisateur sélectionne un groupe, on filtre les photos pour ne garder que celles appartenant à ce groupe.
Ensuite, on génère un deuxième menu avec les caméras disponibles uniquement dans ce groupe.
Changement dans le deuxième menu :

Lorsqu'une caméra est sélectionnée, on filtre les photos en fonction du groupe et de la caméra choisie.
Les photos filtrées sont affichées dans un conteneur (galerie).
Affichage des photos :

Chaque photo est représentée par une balise <img> insérée dynamiquement dans le DOM.



























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
const url0 = `https://api.nasa.gov/planetary/apod?api_key=${apiKey}`; 


// Fonction pour récupérer l'image du jour
fetch(url0)
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











const neoPicturesContainer = document.getElementById('neoPicturesContainer') ;
const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
const startDate = '2020-01-01';
const endDate = '2025-01-08';
const url = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${startDate}&end_date=${endDate}&api_key=${apiKey}`;

document.addEventListener('DOMContentLoaded', function () {
    async function getNeoPhotos() {
        try {
            const response = await fetch(url); 
            console.log(response) ;
            if (!response.ok) throw new Error('Erreur lors du chargement des photos.');

            const data = await response.json();
            const observations = data.near_earth_objects;

            if (photos.length === 0) {
                document.getElementById('neoPicturesContainer').innerHTML = '<p>Aucune image trouvée.</p>';
                return;
            }

            initializeSelectMenus(photos);
        } catch (error) {
            console.error('Erreur détectée :', error.message);
        }
    }

    function displayPictures(photos, limit = 3) 
    {
        if (!neoPicturesContainer) return;

        neoPicturesContainer.innerHTML = ''; // Réinitialiser les photos affichées

        photos.slice(0, limit).forEach(photo => {
            const img = document.createElement('img');
            img.src = photo.img_src;
            img.alt = `Photo prise par ${photo.camera.full_name}`;
            img.style.maxWidth = '200px';
            img.style.margin = '10px';
            neoPicturesContainer.appendChild(img);
        });
    }
/*     function initializeSelectMenus(photos) {
        const cameraSelect = document.getElementById('cameraSelect');
        const roverSelect = document.getElementById('roverSelect');
        const dateSelect = document.getElementById('dateSelect');
        const groupSelect = document.getElementById('groupSelect');

        // Récupérer les caméras uniques
        const cameras = [...new Set(photos.map(photo => photo.camera.full_name))];
        cameraSelect.innerHTML = cameras.map(camera => `<option value="${camera}">${camera}</option>`).join('');

        // Écouteur pour les changements de caméra
        cameraSelect.addEventListener('change', () => {
            const selectedCamera = cameraSelect.value;

            // Filtrer les photos par caméra
            const photosByCamera = photos.filter(photo => photo.camera.full_name === selectedCamera);

            // Remplir le sélecteur des rovers
            const rovers = [...new Set(photosByCamera.map(photo => photo.rover.name))];
            roverSelect.innerHTML = `<option value="">Tous les rovers</option>`;
            rovers.forEach(rover => {
                const option = document.createElement('option');
                option.value = rover;
                option.textContent = rover;
                roverSelect.appendChild(option);
            });

            // Afficher les photos pour la première caméra
            displayPictures(photosByCamera);

            // Réinitialiser les autres sélections
            roverSelect.value = '';
            dateSelect.innerHTML = '<option value="">Toutes les dates</option>';
            groupSelect.innerHTML = '<option value="">Tous les groupes</option>';
        });

        // Écouteur pour les changements de rover
        roverSelect.addEventListener('change', () => {
            const selectedCamera = cameraSelect.value;
            const selectedRover = roverSelect.value;

            // Filtrer les photos par caméra et rover
            const photosByRover = photos.filter(photo =>
                photo.camera.full_name === selectedCamera &&
                (selectedRover === '' || photo.rover.name === selectedRover)
            );

            // Remplir le sélecteur des dates
            const dates = [...new Set(photosByRover.map(photo => photo.earth_date))];
            dateSelect.innerHTML = `<option value="">Toutes les dates</option>`;
            dates.forEach(date => {
                const option = document.createElement('option');
                option.value = date;
                option.textContent = date;
                dateSelect.appendChild(option);
            });

            // Afficher les photos
            displayPictures(photosByRover);

            // Réinitialiser les groupes
            groupSelect.innerHTML = '<option value="">Tous les groupes</option>';
        });

        // Écouteur pour les changements de date
        dateSelect.addEventListener('change', () => {
            const selectedCamera = cameraSelect.value;
            const selectedRover = roverSelect.value;
            const selectedDate = dateSelect.value;

            // Filtrer les photos par caméra, rover et date
            const photosByDate = photos.filter(photo =>
                photo.camera.full_name === selectedCamera &&
                (selectedRover === '' || photo.rover.name === selectedRover) &&
                (selectedDate === '' || photo.earth_date === selectedDate)
            );

            // Diviser les photos en groupes de 100
            const groups = [];
            for (let i = 0; i < photosByDate.length; i += 100) {
                groups.push(photosByDate.slice(i, i + 100));
            }

            // Remplir le sélecteur des groupes
            groupSelect.innerHTML = `<option value="">Tous les groupes</option>`;
            groups.forEach((group, index) => {
                const option = document.createElement('option');
                option.value = index;
                option.textContent = `Groupe ${index + 1}`;
                groupSelect.appendChild(option);
            });

            // Afficher les photos du premier groupe
            if (groups.length > 0) {
                displayPictures(groups[0]);
            }
        });

        // Écouteur pour les changements de groupe
        groupSelect.addEventListener('change', () => {
            const selectedCamera = cameraSelect.value;
            const selectedRover = roverSelect.value;
            const selectedDate = dateSelect.value;
            const selectedGroupIndex = parseInt(groupSelect.value, 10);

            // Filtrer les photos par caméra, rover, date et groupe
            const photosByFilters = photos.filter(photo =>
                photo.camera.full_name === selectedCamera &&
                (selectedRover === '' || photo.rover.name === selectedRover) &&
                (selectedDate === '' || photo.earth_date === selectedDate)
            );

            const groups = [];
            for (let i = 0; i < photosByFilters.length; i += 100) {
                groups.push(photosByFilters.slice(i, i + 100));
            }

            if (groups[selectedGroupIndex]) {
                displayPictures(groups[selectedGroupIndex]);
            }
        });

        // Initialiser avec la première caméra
        if (cameras.length > 0) {
            cameraSelect.value = cameras[0];
            cameraSelect.dispatchEvent(new Event('change'));
        }
    }

    // neoPicturesContainer 
    // Charger les photos getNeoPhotos();*/
});













NEO OK

document.addEventListener('DOMContentLoaded', function () {
    const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
    const startDate = new Date('2020-01-01');
    const endDate = new Date('2020-01-08');
    const maxDays = 7;
    let dataCache = {};

    const dateSelect = document.getElementById('dateSelect');
    const proximitySelect = document.getElementById('proximitySelect');
    const diameterSelect = document.getElementById('diameterSelect');
    const speedSelect = document.getElementById('speedSelect');
    const resultsContainer = document.getElementById('results');

    async function fetchData() {
        let currentDate = new Date(startDate);
        while (currentDate <= endDate) {
            const start = formatDate(currentDate);
            const end = formatDate(addDays(currentDate, maxDays - 1));
            const url = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${start}&end_date=${end}&api_key=${apiKey}`;

            try {
                const response = await fetch(url);
                if (!response.ok) throw new Error('Erreur lors du chargement des données.');
                const data = await response.json();
                Object.assign(dataCache, data.near_earth_objects);
            } catch (error) {
                console.error(error.message);
            }

            currentDate = addDays(currentDate, maxDays);
        }
        populateDateSelect();
    }

    function populateDateSelect() {
        for (const date in dataCache) {
            const option = document.createElement('option');
            option.value = date;
            option.textContent = date;
            dateSelect.appendChild(option);
        }
    }

    function handleDateChange() {
        const selectedDate = dateSelect.value;
        if (!selectedDate) return;

        const objects = dataCache[selectedDate];
        const groups = groupByProximity(objects);

        populateSelect(proximitySelect, groups);
        proximitySelect.disabled = false;
    }

    function groupByProximity(objects) {
        return {
            'Moins de 1M km': objects.filter(o => o.close_approach_data[0].miss_distance.kilometers < 1_000_000),
            'Entre 1M et 5M km': objects.filter(o => {
                const dist = o.close_approach_data[0].miss_distance.kilometers;
                return dist >= 1_000_000 && dist <= 5_000_000;
            }),
            'Plus de 5M km': objects.filter(o => o.close_approach_data[0].miss_distance.kilometers > 5_000_000),
        };
    }

    function populateSelect(selectElement, groups) {
        selectElement.innerHTML = '<option value="">--Choisissez une option--</option>';
        for (const [label, objects] of Object.entries(groups)) {
            const option = document.createElement('option');
            option.value = label;
            option.textContent = `${label} (${objects.length} objets)`;
            selectElement.appendChild(option);
        }
    }

    dateSelect.addEventListener('change', handleDateChange);

    fetchData();
});





document.addEventListener('DOMContentLoaded', function () {
    const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
    const startDate = new Date('2020-01-01');
    const endDate = new Date('2020-01-08');
    const maxDays = 7;
    let dataCache = {};

    const dateSelect = document.getElementById('dateSelect');
    const proximitySelect = document.getElementById('proximitySelect');
    const diameterSelect = document.getElementById('diameterSelect');
    const speedSelect = document.getElementById('speedSelect');
    const resultsContainer = document.getElementById('results');

    // Fonction pour formater une date au format "YYYY-MM-DD"
    function formatDate(date) {
        return date.toISOString().split('T')[0];
    }

    // Fonction pour ajouter des jours à une date
    function addDays(date, days) {
        const result = new Date(date);
        result.setDate(result.getDate() + days);
        return result;
    }

    async function fetchData() {
        let currentDate = new Date(startDate);
        while (currentDate <= endDate) {
            const start = formatDate(currentDate);
            const end = formatDate(addDays(currentDate, maxDays - 1));
            const url = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${start}&end_date=${end}&api_key=${apiKey}`;

            try {
                const response = await fetch(url);
                if (!response.ok) throw new Error('Erreur lors du chargement des données.');
                const data = await response.json();
                Object.assign(dataCache, data.near_earth_objects);
            } catch (error) {
                console.error(error.message);
            }

            currentDate = addDays(currentDate, maxDays);
        }
        populateDateSelect();
    }

    function populateDateSelect() {
        for (const date in dataCache) {
            const option = document.createElement('option');
            option.value = date;
            option.textContent = date;
            dateSelect.appendChild(option);
        }
    }

    function handleDateChange() {
        const selectedDate = dateSelect.value;
        if (!selectedDate) return;

        const objects = dataCache[selectedDate];
        const groups = groupByProximity(objects);

        populateSelect(proximitySelect, groups);
        proximitySelect.disabled = false;
    }

    function groupByProximity(objects) {
        return {
            'Moins de 1M km': objects.filter(o => o.close_approach_data[0].miss_distance.kilometers < 1_000_000),
            'Entre 1M et 5M km': objects.filter(o => {
                const dist = o.close_approach_data[0].miss_distance.kilometers;
                return dist >= 1_000_000 && dist <= 5_000_000;
            }),
            'Plus de 5M km': objects.filter(o => o.close_approach_data[0].miss_distance.kilometers > 5_000_000),
        };
    }

    function populateSelect(selectElement, groups) {
        selectElement.innerHTML = '<option value="">--Choisissez une option--</option>';
        for (const [label, objects] of Object.entries(groups)) {
            const option = document.createElement('option');
            option.value = label;
            option.textContent = `${label} (${objects.length} objets)`;
            selectElement.appendChild(option);
        }
    }

    dateSelect.addEventListener('change', handleDateChange);

    fetchData();
});






document.addEventListener('DOMContentLoaded', function () {
    const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
    const startDate = new Date('2020-01-01');
    const endDate = new Date('2020-01-08');
    const maxDays = 7;
    let dataCache = {};

    const dateSelect = document.getElementById('dateSelect');
    const proximitySelect = document.getElementById('proximitySelect');
    const diameterSelect = document.getElementById('diameterSelect');
    const speedSelect = document.getElementById('speedSelect');
    const resultsContainer = document.getElementById('results');

    function formatDate(date) {
        return date.toISOString().split('T')[0];
    }

    function addDays(date, days) {
        const result = new Date(date);
        result.setDate(result.getDate() + days);
        return result;
    }

    async function fetchData() {
        let currentDate = new Date(startDate);
        while (currentDate <= endDate) {
            const start = formatDate(currentDate);
            const end = formatDate(addDays(currentDate, maxDays - 1));
            const url = `https://api.nasa.gov/neo/rest/v1/feed?start_date=${start}&end_date=${end}&api_key=${apiKey}`;

            try {
                const response = await fetch(url);
                if (!response.ok) throw new Error('Erreur lors du chargement des données.');
                const data = await response.json();
                Object.assign(dataCache, data.near_earth_objects);
            } catch (error) {
                console.error(error.message);
            }

            currentDate = addDays(currentDate, maxDays);
        }
        populateDateSelect();
    }

    function populateDateSelect() {
        for (const date in dataCache) {
            const option = document.createElement('option');
            option.value = date;
            option.textContent = date;
            dateSelect.appendChild(option);
        }
    }

    function handleDateChange() {
        const selectedDate = dateSelect.value;
        if (!selectedDate) return;

        const objects = dataCache[selectedDate];
        const groups = groupByProximity(objects);

        populateSelect(proximitySelect, groups);
        proximitySelect.disabled = false;

        // Réinitialiser les sélecteurs suivants
        diameterSelect.innerHTML = '<option value="">--Sélectionnez une proximité d\'abord--</option>';
        diameterSelect.disabled = true;
        speedSelect.innerHTML = '<option value="">--Sélectionnez un diamètre d\'abord--</option>';
        speedSelect.disabled = true;
        resultsContainer.innerHTML = '';
    }

    function handleProximityChange() {
        const selectedDate = dateSelect.value;
        const proximityGroup = proximitySelect.value;
        if (!selectedDate || !proximityGroup) return;

        const objects = groupByProximity(dataCache[selectedDate])[proximityGroup];
        const groups = groupByDiameter(objects);

        populateSelect(diameterSelect, groups);
        diameterSelect.disabled = false;

        // Réinitialiser le dernier sélecteur
        speedSelect.innerHTML = '<option value="">--Sélectionnez un diamètre d\'abord--</option>';
        speedSelect.disabled = true;
        resultsContainer.innerHTML = '';
    }

    function handleDiameterChange() {
        const selectedDate = dateSelect.value;
        const proximityGroup = proximitySelect.value;
        const diameterGroup = diameterSelect.value;
        if (!selectedDate || !proximityGroup || !diameterGroup) return;

        const objects = groupByDiameter(groupByProximity(dataCache[selectedDate])[proximityGroup])[diameterGroup];
        const groups = groupBySpeed(objects);

        populateSelect(speedSelect, groups);
        speedSelect.disabled = false;

        resultsContainer.innerHTML = '';
    }

    function handleSpeedChange() {
        const selectedDate = dateSelect.value;
        const proximityGroup = proximitySelect.value;
        const diameterGroup = diameterSelect.value;
        const speedGroup = speedSelect.value;
        if (!selectedDate || !proximityGroup || !diameterGroup || !speedGroup) return;

        const objects = groupBySpeed(
            groupByDiameter(groupByProximity(dataCache[selectedDate])[proximityGroup])[diameterGroup]
        )[speedGroup];

        displayObjects(objects);
    }

    function groupByProximity(objects) {
        return {
            'Moins de 1M km': objects.filter(o => o.close_approach_data[0].miss_distance.kilometers < 1_000_000),
            'Entre 1M et 5M km': objects.filter(o => {
                const dist = o.close_approach_data[0].miss_distance.kilometers;
                return dist >= 1_000_000 && dist <= 5_000_000;
            }),
            'Plus de 5M km': objects.filter(o => o.close_approach_data[0].miss_distance.kilometers > 5_000_000),
        };
    }

    function groupByDiameter(objects) {
        return {
            'Moins de 100m': objects.filter(o => o.estimated_diameter.meters.estimated_diameter_max < 100),
            'Entre 100m et 1km': objects.filter(o => {
                const dia = o.estimated_diameter.meters.estimated_diameter_max;
                return dia >= 100 && dia <= 1000;
            }),
            'Plus de 1km': objects.filter(o => o.estimated_diameter.meters.estimated_diameter_max > 1000),
        };
    }

    function groupBySpeed(objects) {
        return {
            'Moins de 10km/s': objects.filter(o => o.close_approach_data[0].relative_velocity.kilometers_per_second < 10),
            'Entre 10km/s et 30km/s': objects.filter(o => {
                const speed = o.close_approach_data[0].relative_velocity.kilometers_per_second;
                return speed >= 10 && speed <= 30;
            }),
            'Plus de 30km/s': objects.filter(o => o.close_approach_data[0].relative_velocity.kilometers_per_second > 30),
        };
    }

    function populateSelect(selectElement, groups) {
        selectElement.innerHTML = '<option value="">--Choisissez une option--</option>';
        for (const [label, objects] of Object.entries(groups)) {
            const option = document.createElement('option');
            option.value = label;
            option.textContent = `${label} (${objects.length} objets)`;
            selectElement.appendChild(option);
        }
    }

    function displayObjects(objects) {
        resultsContainer.innerHTML = '';
        objects.forEach(obj => {
            const item = document.createElement('div');
            item.innerHTML = `
                <h4>${obj.name}</h4>
                <p>Diamètre estimé : ${Math.round(obj.estimated_diameter.meters.estimated_diameter_max)} m</p>
                <p>Proximité : ${Math.round(obj.close_approach_data[0].miss_distance.kilometers)} km</p>
                <p>Vitesse : ${Math.round(obj.close_approach_data[0].relative_velocity.kilometers_per_hour)} km/h</p>
            `;
            resultsContainer.appendChild(item);
        });
    }

    dateSelect.addEventListener('change', handleDateChange);
    proximitySelect.addEventListener('change', handleProximityChange);
    diameterSelect.addEventListener('change', handleDiameterChange);
    speedSelect.addEventListener('change', handleSpeedChange);

    fetchData();
});
