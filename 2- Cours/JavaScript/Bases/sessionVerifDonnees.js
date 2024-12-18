

document.addEventListener("DOMContentLoaded", () => 
{
    const username = document.getElementById('username') ;
    console.log(username) ;

    const welcomeMessage = document.createElement ('p') ;
    console.log(welcomeMessage) ;

    welcomeMessage.style.textAlign = 'center' ;
    welcomeMessage.style.color = 'rgb(22, 167, 180)' ;

   
    if (sessionStorage.getItem('visited'))
        {
            welcomeMessage.textContent = "Bon retour sur notre formulaire !" ;
            // Insert "welcome" comme le premier élément visible dans le body
            document.body.insertBefore(welcomeMessage, document.body.firstChild) ;
        }
    else
        {
            welcomeMessage.textContent = "Bienvenu sur notre formulaire !" ;
             // Insert "welcome" comme le premier élément visible dans le body
             document.body.insertBefore(welcomeMessage, document.body.firstChild) ;
            sessionStorage.setItem('visited', true)
        }

   

    const passwordInput = document.getElementById('password') ;
    const strengthBar = document.getElementById('password-strength').firstElementChild ;
    const criteriaLength = document.getElementById('criteria-length') ;
    const criteriaUppercase = document.getElementById('criteria-uppercase') ;
    const criteriaNumber = document.getElementById('criteria-number') ;

    passwordInput.addEventListener('input', () =>
                                                {
                                                    const password = passwordInput.value ;
                                                    console.log(password);
                                               

// Vérifier les critères
    const hasLength = password.length >= 8 ;
    const hasUppercase = /[A-Z]/.test(password) ; // 'test' est une fonction JS native pour vérifier  ('match' en Python) 
    const hasNumber = /[0-9]/.test(password) ;// 'test' utilise des expressions régulières pour idéntifier les caractères à tester.

    //Ajoute ou supprime une class css en fonction d'une condition
    criteriaLength.classList.toggle('valid', hasLength) ; //
    criteriaUppercase.classList.toggle('valid', hasUppercase) ; //
    criteriaNumber.classList.toggle('valid', hasNumber) ; //


    //Calcule de la force du mot de passe
    const strength = hasLength + hasUppercase +hasNumber ;
    console.log(strength) ;
    const strengthPercent = (strength/3) * 100 ;

    //Mettre à jour la barre de force visuellement 
    strengthBar.style.width = `${strengthPercent}%` ;
    strengthBar.style.backgroundColor = strengthPercent === 100 ? '#4caf50' : strengthPercent >= 66 ? '#ffc107' : '#e50914' ;

} ) ;

document.getElementById('register-form').addEventListener('submit', ( e ) => 
                                                                            {
                                                                                e.preventDefault();
                                                                                //Réinitialiser des messages d'erreur
                                                                                const errors = document.querySelectorAll('.error-message') ;
                                                                                errors.forEach(error => error.textContent= '') ;

                                                                                const username = document.getElementById('username') ;
                                                                                const email = document.getElementById ('email') ;
                                                                                const confirmPassword = document.getElementById('confirm-password') ;

                                                                                let valid = true ;

                                                                                if (username.value.trim().length < 2)
                                                                                {
                                                                                    valid = false ;
                                                                                    document.getElementById('username-error').textContent = "le nom de l'utilisateur doit contenir au moins 2 caractères" ; 
                                                                                }

                                                                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                                                                if (!emailRegex.test(email.value.trim()))
                                                                                {
                                                                                    valid = false ; 
                                                                                    document.getElementById('email-error').textContent = "saisir une adresse mail valid" ;
                                                                                }
                                                                                const password = document.getElementById('password') ;
                                                                                if(password.value !== confirmPassword.value)
                                                                                {
                                                                                    valid = false ; 
                                                                                    document.getElementById('confirm-password-error').textContent = "Les mots de passe ne correspondent pas" ;
                                                                                }

                                                                                if (valid)
                                                                                            {
                                                                                                alert('inscription réussie') ;

                                                                                                //Implémenter API Notification
                                                                                                if ('Notification' in window) // Mettre "N" Majuscule à Notification
                                                                                                {
                                                                                                    Notification.requestPermission().then(permission => 
                                                                                                    {
                                                                                                        if (permission === 'granted') // Envoyer une notification
                                                                                                            { 
                                                                                                                const notification = new Notification('Inscription réussie' , 
                                                                                                                    {
                                                                                                                        body:'Merci pour votre inscription, Bienvenue !',
                                                                                                                        icon:'pictures/cor/big-logo-corpulence3.png'
                                                                                                                    }
                                                                                                                );
                                                                                                            }
                                                                                                        else 
                                                                                                            { 
                                                                                                                console.warm('Notifications refusées')
                                                                                                            }
                                                                                                    } )

                                                                                                    //Gérer les notifications
                                                                                                    notification.onclick = () =>
                                                                                                        {
                                                                                                            window.focus();
                                                                                                            window.location.href="index.html";
                                                                                                        }
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    console.error('API Notification pas supporté') ;
                                                                                                }
                                                                                            }

                                                                            })

}
)