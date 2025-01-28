/*
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
            initializeControls();
        } catch (error) {
            console.error('Erreur détectée :', error.message);
        }
    }

    function displayPictures(photos, startIndex = 0, limit = 3) {
        const marchPictureSelected = document.getElementById('marchPictureSelected');
        if (!marchPictureSelected) return;

        marchPictureSelected.innerHTML = ''; // Réinitialiser les photos affichées

        photos.slice(startIndex, startIndex + limit).forEach(photo => {
            const img = document.createElement('img');
            img.src = photo.img_src;
            img.alt = `Photo prise par ${photo.rover.name} avec ${photo.camera.full_name}`;
            img.style.maxWidth = '200px';
            img.style.margin = '10px';
            img.className = 'mars-image';
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

        // Écouteurs supplémentaires pour rover, date, groupe (similaires aux anciennes versions)
        // Ajout d'écouteurs ici si nécessaire
    }

    function initializeControls() {
        // Slider (Précédent/Suivant)
        let currentIndex = 0;
        document.getElementById('prevButton').addEventListener('click', () => {
            if (currentIndex > 0) {
                currentIndex -= 3;
                displayPictures(filteredPhotos, currentIndex);
            }
        });

        document.getElementById('nextButton').addEventListener('click', () => {
            if (currentIndex + 3 < filteredPhotos.length) {
                currentIndex += 3;
                displayPictures(filteredPhotos, currentIndex);
            }
        });

        // Modes d'affichage
        document.getElementById('normalView').addEventListener('click', () => {
            document.getElementById('marchPictureSelected').className = 'normal-view';
        });

        document.getElementById('semiView').addEventListener('click', () => {
            document.getElementById('marchPictureSelected').className = 'semi-view';
        });

        document.getElementById('fullscreenView').addEventListener('click', () => {
            document.getElementById('marchPictureSelected').className = 'fullscreen-view';
        });

        // Diaporama
        let slideshowInterval;
        document.getElementById('playSlideshow').addEventListener('click', () => {
            const speed = parseInt(document.getElementById('slideshowSpeed').value, 10) || 3000;
            slideshowInterval = setInterval(() => {
                if (currentIndex + 3 < filteredPhotos.length) {
                    currentIndex += 3;
                    displayPictures(filteredPhotos, currentIndex);
                } else {
                    clearInterval(slideshowInterval);
                }
            }, speed);
        });

        document.getElementById('pauseSlideshow').addEventListener('click', () => {
            clearInterval(slideshowInterval);
        });

        document.getElementById('stopSlideshow').addEventListener('click', () => {
            clearInterval(slideshowInterval);
            currentIndex = 0;
            displayPictures(filteredPhotos, currentIndex);
        });

        // Popup musique
        const musicPopup = document.getElementById('musicPopup');
        const playMusicButton = document.getElementById('playMusic');
        const closeMusicButton = document.getElementById('closeMusic');

        playMusicButton.addEventListener('click', () => {
            const audio = new Audio('path/to/music/file.mp3'); // Remplacer par un chemin réel
            audio.play();
            musicPopup.style.display = 'none';
        });

        closeMusicButton.addEventListener('click', () => {
            musicPopup.style.display = 'none';
        });
    }

    // Charger les photos
    getMarsPhotos();
});













*/