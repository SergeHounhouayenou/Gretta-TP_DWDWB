document.addEventListener('DOMContentLoaded', ()=>{
    const countrySelect = document.getElementById('countrySelect');
    const postalCodeInput = document.getElementById('postalCodeInput');
    const citySelect = document.getElementById('citySelect');

    //Va chercher les pays + trie par ordre alphabétique
    async function loadCountries() {
        try {
            const response = await fetch('https://restcountries.com/v3.1/all');
            if(!response.ok){
                throw new Error("Erreur lors du chargement des pays");
            }
            const countries = await response.json(); //nous permet d'exploiter la réponser
            // Fonction ---> création de select à partir de la réponse (stockée dans countries)
            populateCountrySelect(countries);
        }catch (error) {
            console.log(error.message);
            
        }
    }

    function populateCountrySelect(countries) {
        // Trie un tableau selon l'ordre alphabétique
        countries.sort((a,b)=> a.name.common.localeCompare(b.name.common)); //pour trier les pays par ordre alphabétique
        //console.log(countries);
        countries.forEach(country => { //bouche qui créer une option 
            const option = document.createElement('option');
            option.value = country.cca2; //à chaque value ou l'on ajoute les initiales des pays (utiliser pour le serveur = <option value="AF"><option>)
            option.textContent = country.name.common; //à chaque option on met dans option le nom des pays = <option value="AF">Afghanistan<option>)
            countrySelect.appendChild(option);
        });

    }
    
    function resetCitySelect(message = "--Selectionnez une ville --") {
        citySelect.innerHTML= `<option value="">${message}</option>`; //définie l'option ds le cas ou on ne définirait pas un code postale
        citySelect.disabled = true; //permet d'empécher le choix, si on a pas sélectionner au préalable un code postale
    }





    //Va chercher les villes en fonction des pays et du code postale = API (Zippopotam)
    async function loadCitiesByPostalCode(postalCode) {
        try {
            const country = countrySelect.value;
            if(!country){
                throw new Error("Veuillez sélectionner un pays");
            }
            //Encodage des paramètres dynamiques
            const encodedCountry = encodeURIComponent(country);
            const encodedPostalCode = encodeURIComponent(postalCode);
            const response = await fetch(`https://api.zippopotam.us/${encodedCountry}/${encodedPostalCode}`);
            const cities = await response.json();
            console.log(cities);
            populateCitiesSelect(cities);
            


        }catch (error) {
            console.log(error.message)
            resetCitySelect(error.message);
        }
    }


    function populateCitiesSelect(data) {
        citySelect.disabled = false;
        data.places.forEach(datas => { //for each ne récupère que les tableaux et non pas les chaines de caractère
            const option = document.createElement('option');
            option.textContent = datas['place name'];
            citySelect.appendChild(option);
        });

    };    





    //Ecouteurs pour saisie du code postal
    postalCodeInput.addEventListener('input',()=>{
        const postalCode = postalCodeInput.value.trim();
        if(postalCode.length > 0){
            loadCitiesByPostalCode(postalCode);
        }else{
            resetCitySelect;
        }

    });

    loadCountries();


});