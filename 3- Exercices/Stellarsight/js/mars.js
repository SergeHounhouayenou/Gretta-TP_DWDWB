const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';

document.addEventListener('DOMContentLoaded', function () {
    async function getMarsPhotos() {
        try {
            const response = await fetch(`https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=${apiKey}&sol=1000`);
            if (!response.ok) throw new Error('Erreur lors du chargement des photos.');

            const data = await response.json();
            const photos = data.photos;

            if (photos.length === 0) {
                document.getElementById('marchPictureSelected').innerHTML = '<p>Aucune image trouvée.</p>';
                return;
            }

            initializeSelectMenus(photos);
        } catch (error) {
            console.error('Erreur détectée :', error.message);
        }
    }

    function displayPictures(photos, limit = 3) {
        const marchPictureSelected = document.getElementById('marchPictureSelected');
        if (!marchPictureSelected) return;

        marchPictureSelected.innerHTML = ''; // Réinitialiser les photos affichées

        photos.slice(0, limit).forEach(photo => {
            const img = document.createElement('img');
            img.src = photo.img_src;
            img.alt = `Photo prise par ${photo.rover.name} avec ${photo.camera.full_name}`;
            img.style.maxWidth = '200px';
            img.style.margin = '10px';
            marchPictureSelected.appendChild(img);
        });
    }

    function initializeSelectMenus(photos) {
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

    // Charger les photos
    getMarsPhotos();
});
