document.addEventListener('DOMContentLoaded', function () {
    const apiKey = 'a2LefMM2JPogooIp7NRW5c23XJU3otcDqmWodvAo';
    const startDate = new Date('2020-01-01');
    const endDate = new Date('2020-01-08');
    const maxDays = 7;
    let dataCache = {};
    let resultsTable = []; // Tableau pour conserver les résultats filtrés

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
                console.log(dataCache) ; // Je vérrifie que les données dans le cache sont bien formatées
                console.log(data.near_earth_objects) ; // Je vérrifie que les données data.near_earth_objects

            } catch (error) {
                console.error(error.message);
            }

            currentDate = addDays(currentDate, maxDays);
        }
        populateDateSelect();
    }   console.log(resultsTable); //Je veux récupérer les données tant qu'elles sont chargées pour un éventuel dévelloppement de l'expérience utilisateur

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
        resultsTable = []; // Réinitialiser le tableau de résultats
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

        resultsTable = objects; // Enregistrer les résultats finaux dans le tableau
        displayObjects(objects);
        console.log(resultsTable); // Je vérifie le comportement de mon tableau de données
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
        if (objects.length === 0) {
            resultsContainer.innerHTML = '<p>Aucun objet trouvé.</p>';
            return;
        }

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
   

    /**
     Je devrait maintenant être en mesure d'exploiter mon Tableau de résultat sans remonter au formatde la requête
     */
});
