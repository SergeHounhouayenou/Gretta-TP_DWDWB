document.addEventListener('DOMContentLoaded', ()=>
{
    const countrySelect = document.getElementById('countrySelect');
    const postalCodeInput = document.getElementById('postalCodeInput');
    const citySelect = document.getElementById('citySelect');

    //Charger les pays au démarrage
    async function loadCountries()
        {
            try
                {
                    const response = await fetch('https://restcountries.com/v3.1/all') ;  //REST countries.com
                    console.log(response); 
                    if (!response.ok)
                        {
                            throw new Error ('Erreur lors du chargement des pays') ;
                        }
                        const countries = await response.json();
                        console.log(countries) ;
                        // Fonction pour créer un select à partir de la réponse (stockée dans countries)
                        populateCountrySelect(countries); 
                } 
            catch (error) 
                    {
                        console.log(error.message) ;
                    } 
        function populateCountrySelect(countries)
                    {
                        //Trie un tableau selon l'ordre alphabétique
                        countries.sort( (a, b) => a.name.common.localeCompare(b.name.common)) ;
                        console.log(countries);
                        countries.forEach(country => 
                            {
                                const option = document.createElement('option');
                                option.value = country.cca2 ;
                                option.textContent = country.name.common;
                                countrySelect.appendChild(option);
                                console.log(option) ;
                            }
                        ) ;
                    }
                    
                    function resetCitySelect(message  = "-- Sélectionnez une ville --")
                            {
                                citySelect.innerHTML = `<option value = ""> ${message}</option> `;
                                citySelect.disabled = true;
                            }

                        async function loadCitiesByPostalCode(postalCode)
                            {
                                try
                                    {
                                        const responseCity = await fetch (`https://api.zippopotam.us/${encodedCountry}/${encodedPostalCode}`) ;// Zippopotam
                                        console.log(responseCity) ;
                                        
                                        const country = countrySelect.value ;
                                        if (!country)
                                        {
                                            throw new Error ("Veuillez sélectionner un pays") ;
                                        }
                                        //Encode des paramètres dynamiques
                                        const encodedCountry = encodedURIComponent (country);
                                        const encodedPostalCode = encodedURIComponent(postalCode);

                                        

                                    }
                                    catch (er)
                                        {
                                            console.log(er.message) ;
                                            resetCitySelect(er.message) ;
                                        }
                            }
        }

        //Ecouteur pour la saisie du code postal
        postalCodeInput.addEventListener('input', () => 
                                                    {
                                                        const postalCode = postalCodeInput.value.trim() ;
                                                        if (postalCode.length > 0)
                                                            {
                                                                loadCitiesByPostalCode(postalCode) ;
                                                            }
                                                        else
                                                            {
                                                                resetCitySelect() ;
                                                            }
                                                    } )
        


        loadCountries();    
}
    ) ;