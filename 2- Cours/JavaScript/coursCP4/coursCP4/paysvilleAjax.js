document.addEventListener('DOMContentLoaded', ()=>{
    const countrySelect = document.getElementById('countrySelect');
    const postalCodeInput = document.getElementById('postalCodeInput');
    const citySelect = document.getElementById('citySelect');

    //Charger les pays au démarrage
    async function loadCountries(){
        try{
            const response = await fetch('https://restcountries.com/v3.1/all');
            if (!response.ok){
                throw new Error('Erreur lors du chargement des pays');
            }
            const countries = await response.json();
            // Fonction --> création de select à partir de la réponse (stockée dans countries)
            populateCountrySelect(countries);
        }catch (error) {
            console.log(error.message);
        }
    }

    function populateCountrySelect(countries){
        //Trie un tableau selon lordre alphabétique
        countries.sort((a,b)=> a.name.common.localeCompare(b.name.common));
        //console.log(countries);
        countries.forEach(country => {
            const option = document.createElement('option');
            option.value = country.cca2;
            option.textContent= country.name.common;
            countrySelect.appendChild(option);
        });
    }
    function resetCitySelect(message = "-- Selectionnez une ville --"){
        citySelect.innerHTML=`<option value="">${message}</option>`;
        citySelect.disabled = true;
    }

    async function  loadCitiesByPostalCode(postalCode){
        try {
            const country = countrySelect.value;
            if (!country){
                throw new Error('Veuillez selectionner un pays');
            }
            //Encodage des paramètres dynamiques
            const encodedCountry = encodeURIComponent(country);
            const encodedPostalCode = encodeURIComponent(postalCode);

            const response = await fetch(`https://api.zippopotam.us/${encodedCountry}/${encodedPostalCode}`);


        }catch (e) {
            console.log(e.message);
            resetCitySelect(e.message);
        }
    }

    //Ecouteur pour la saisie du code postal
    postalCodeInput.addEventListener('input', ()=>{
        const postalCode = postalCodeInput.value.trim();
        if (postalCode.length > 0){
            loadCitiesByPostalCode(postalCode);
        }else{
            resetCitySelect();
        }
    })

    loadCountries();
});