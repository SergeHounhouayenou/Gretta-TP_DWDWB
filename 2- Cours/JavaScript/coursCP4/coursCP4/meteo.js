document.addEventListener('DOMContentLoaded', ()=>{
    const fetchWeatherBtn = document.getElementById('fetchWeather');
    const cityInput = document.getElementById('cityInput');
    const weatherResult = document.getElementById('weatherResult');

    async function fetchWeather(city){
        try{
            const url = `https://wttr.in/${encodeURIComponent(city)}?format=%C+%t+%w`;
            const response = await fetch(url);
            if (!response.ok){
                throw new Error("Erreur de récupération des données météo !");
            }
            // Reponse l'en tête
            console.log(response.headers.get('Content-Type'));
            const weatherData = await response.text();
            displayWeather(city, weatherData);
        }catch (e) {
            weatherResult.innerHTML=`<div class="alert alert-danger">${e.message}</div>`;
        }
    }

    function displayWeather(city, weatherData){
        weatherResult.innerHTML="";
        weatherResult.innerHTML= `
                <div class="card mx-auto shadow-lg">
                    <div class="card-body">
                        <h3 class="card-title">${city}</h3>
                        <p class="card-text">${weatherData}</p>
                    </div>
                </div>
        `;
    }


    fetchWeatherBtn.addEventListener('click', ()=>{
        const city = cityInput.value.trim();
        if (city){
            fetchWeather(city)
        }else{
            weatherResult.innerHTML=`<div class="alert alert-warning">Saisir une ville</div>`;
        }
    })


})