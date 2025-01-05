
document.addEventListener('DOMContentLoaded', function()
{
    const userVoiceTranscription = document.getElementById('microButton'); 
    
    let microBackgroundColor = 'blue';
    console.log(microBackgroundColor);

    document.getElementById("userStatistics1").textContent = "Vos précdentes réponses sont :" ;
    const NewUserSaidDataBase= [] ;
   
    document.getElementById("microButton").style.backgroundColor = 'lightblue';


    userVoiceTranscription.addEventListener("mouseenter", function( event ) 
        {   
        event.target.style.color = "rgba(245, 16, 9, 0.5)";
        },
        false);

    userVoiceTranscription.addEventListener("mouseleave", function( event ) 
        {   
        event.target.style.color = "lightblue";
        }
        , 
        false);

    const userSaidDataBase = [] ;
    let computerSaid = "bonjour madame, comment alez vous ?" ;
    let inputTexte ;
    let inputTexteIsfree = false ;
    if (inputTexteIsfree == true) 
        {
            inputTexte = computerSaid 
        }
    else 
        {
            inputTexte = "" 
        }

    document.getElementById("userTryEntry").value = inputTexte ;
    console.log(inputTexte) ;
    

    //déclarer les fonctions nécéssaires à la recherche vocale
    function initializeVoiceSearch()
    {
        //Vérifier si le navigateur prend en charge API Web Speach
        if (!('webkitSpeechRecognition' in window))
            {
                alert('La reconnaissance vocale n\'est pas prise en charge par votre navigateur') ;
                return;
            }
        
            const recognition = new webkitSpeechRecognition() ;
            recognition.lang = 'fr-FR' ;
            recognition.interimResults = false ;
            recognition.maxAlternatives = 1 ;

            //Commencer l'écoute quand le bouton est cliqué
            userVoiceTranscription.addEventListener('click', () => 
            {
                recognition.start();
                updateVoiceButtonState("listening") ;
                inputTexteIsfree = true ;
                document.getElementById("userTryEntry").value = computerSaid
                console.log(inputTexte);
                return;

            } );

             //gère la fin de l'écoute
            recognition.addEventListener("end", () =>
            {
                updateVoiceButtonState("idle") ;
                inputTexteIsfree = false ;
               // document.getElementById("userTryEntry").value = "Quelle sera votre prochaine réponse ?"
                console.log(inputTexte);
            }) ;

            //Récupère le résultat de la reconnaissance vocale
            recognition.addEventListener('result', (recorded)=>
                {
                    const speechResult = recorded.results[0][0].transcript; // remplir la barre de recherche
                    document.getElementById("userTryEntry").value = speechResult ;
                    userSaidDataBase.push(speechResult) ; // récupérer Speachresult dans une variable
                    
                    console.log(userSaidDataBase) ;            // fetch pour rechercher
                     return (userSaidDataBase) ;                // retrouver la fonction pour empêcher le rafraichissement de la page
                }) ; 

            //Gère les erreurs
            recognition.addEventListener('error', (recorded)=>
                    {
                        console.log('Erreur de reconnaissance vocale', recorded.error);
                        updateVoiceButtonState("idle"); 
                        alert("Erreur de la reconnaissance vocale, veuillez rééssayer");
                    })
    }
    
   
    function updateVoiceButtonState(state)
    {
        if (state === "listenning")
        {
            userVoiceTranscription.disabled = true;
            document.getElementById("microButton").value = "🎧 en écoute..." ;
        }
        else
        {
            userVoiceTranscription.disabled = false ;
           // voiceTranscriptionBtn.textContent = "🎤"
        }
    }


    //appeler la recherche vocale
    initializeVoiceSearch() ; 
    NewUserSaidDataBase.push(userSaidDataBase)  ;
    console.log("Vos précdentes réponses sont :", NewUserSaidDataBase) ;
    document.getElementById("userStatistics2").textContent = NewUserSaidDataBase;
}); 
