document.addEventListener('DOMContentLoaded', 
function() 
{
 
    const cityInput = document.getElementById('cityInput') ;
    const fetchWeatherBtn = document.getElementById('fetchWeather') ;
    const weatherResult = document.getElementById('weatherResult') ;
   
    /* 
    MOI
    const meteoSearchBar = document.getElementsByClassName('container') ;
    const askMeteoOfaPlace = document.getElementById('cityInput') ;
    const sendButton = document.getElementById('fetchWeather') ;
    const weatherResult = document.getElementById('weatherResult') ;
    */



async function fetchWeather (city)
{
    try
    {
        const url = `https://wttr.in/${encodeURIComponent(city)}?format=%C+%t+%w` ;
        const response = await fetch(url);
        if (!response.ok)
            {
                throw new Error ("Erreur de récupération des données météo !") ;
            }

    console.log(response) ; 
    //récupérer la réponse de l'en-tête
    console.log(response.headers.get('Content-Type')) ;
    const weatherData = await response.text();
    displayWeather(city, weatherData) ;

    }

    catch (e)
    {
        weatherResult.innerHTML = `<div class="alert-danger">${e.message}</div>`;
    }

}

function displayWeather(city, weatherData)
{
    weatherResult.innerHTML = "" ;
    weatherResult.innerHTML = 
    `<div class = "card mx-auto shadow-lg">
        <div class="card-body">
            <h3 class = "card-title">${city}</h3>
            <p class = "card-text">${weatherData}</p>
        </div>
     </div>
    `;
}

fetchWeatherBtn.addEventListener('click', ()=> 
    {
        const city = cityInput.value.trim();
        if (city)
        {
            fetchWeather(city)
        }
        else
        {
            weatherResult.innerHTML =`<div class="alert alert-warning"> Saisir une ville</div>` ;
        }
    }
    )



/*    
MOI
//Fonction pour récupérer les données météorologiques depuis l'API
    async function fetchMeteo (city)
    {
    try 
        { // Avis : Manque : ajuster la méthode en post pour récupérer directement les bon champs pour faire la redirection
        const promise = await fetch(`https://wttr.in/${encodeURIComponent(city)}?format=%C+%t+%w`); console.log(promise);

        if (!promise.ok)
            {
                throw new error('Erreur lors du chargement API météo') ;
            }
            
        const data = promise.text; console.log(data) ;
        if (data.length === 0 )
            {
            weatherResult.innerHTML = `<p class="col-12 text-center>lieu inconnu. veuillez saisir une nouvelle ville</p>` ;
            }
            else
            {
            showResult(data) ;
            }
        console.log(data); 
            }

        
    catch (error)
        {
            weatherResult.innerHTML = `<p class= "col12 text-center">${error.message} </p>` ;
        }
    
    //Fonction pour afficher les résultats
    function showResult(meteo)
    {
        console.log(meteo);
        weatherResult.innerHTML = 
            `<h4 class="text-center">Résultat de la météo pour votre choix :</h4>` ;
             `<p class="text-center">${showResult}</p> `;
        // Join va convertir le retour du MAP en chaîne de caractère
    } // Supprimer "map" pour une sortie simple dans la "weatherResult" si le ontenu est assez simple 

    } 

     // J'écoute l'input pour transmettre sa valeur et vérifier "( if (data.results.length === 0 ))""
     askMeteoOfaPlace.addEventListener('input', () => 
        {
            const city = askMeteoOfaPlace.value.trim();
            if (city.length>0)
            {
                fetchMeteo(city.url);
            }
            else
            {
                //Réinitialiser les résultats
                weatherResult.innerHtml = '' ;
            }
        }    
        )
*/
}
)

