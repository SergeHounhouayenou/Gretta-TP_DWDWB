document.addEventListener('DOMContentLoaded', ()=>{

    const welcomeMessage = document.createElement('p');
    welcomeMessage.style.textAlign="center";
    welcomeMessage.style.color="green";

    if (sessionStorage.getItem('visited')){
        welcomeMessage.textContent= " Bienvenue de retour sur notre formulaire !";
        //Insère welcome comme le premier élément visible dans le body
        document.body.insertBefore(welcomeMessage, document.body.firstChild);
    }else{
        sessionStorage.setItem('visited', true);
    }


    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('password-strength').firstElementChild;
    const criteriaLength = document.getElementById('criteria-length');
    const criteriaUppercase = document.getElementById('criteria-uppercase');
    const criteriaNumber = document.getElementById('criteria-number');

    passwordInput.addEventListener('input', ()=>{
        const password = passwordInput.value;

        //Vérifier les critères
        const hasLength = password.length >= 8;
        const hasUpperCase = /[A-Z]/.test(password);
        const hasNumber = /[0-9]/.test(password);

        //Ajoute ou supprime une classe CSS en fonction d'une condition
        criteriaLength.classList.toggle('valid', hasLength);
        criteriaUppercase.classList.toggle('valid', hasUpperCase);
        criteriaNumber.classList.toggle('valid', hasNumber);

        //Calcule de la force du mot de passe
        const strength = hasLength + hasUpperCase + hasNumber;
        console.log(strength);
        const strengthPercent = (strength/3)*100;

        //Mettre à jour la barre de force visuellement
        strengthBar.style.width=`${strengthPercent}%`;
        strengthBar.style.backgroundColor=
            strengthPercent===100 ? '#4caf50' : strengthPercent >= 66 ?
                '#ffc107' : '#e50914';
    });

    document.getElementById('register-form').addEventListener(
        'submit', (e)=>{
            e.preventDefault();

            //Réinitialisation des messages d'erreur
            const errors = document.querySelectorAll('.error-message');
            errors.forEach(error => error.textContent= '');

            const username = document.getElementById('username');
            const email = document.getElementById('email');
            const confirmPassword = document.getElementById('confirm-password');

            let valid = true;

            if (username.value.trim().length < 2){
                valid = false;
                document.getElementById('username-error').textContent=
                    "Le nom de l'utilsateur doit contenir au moins 2 caractères";
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email.value.trim())){
                valid = false;
                document.getElementById('email-error').textContent=
                    "Saisir une adresse mail valide ";
            }
            const password = document.getElementById('password');
            if(password.value !== confirmPassword.value){
                valid = false;
                document.getElementById('confirm-password-error').textContent=
                    "Les mots de passe ne correspondent pas !";
            }
            if(valid){
                alert('Inscription réussie');

                //Implémenter API Notification
                if ('Notification' in window){
                    Notification.requestPermission().then(permission=>{
                        if (permission === 'granted'){
                            //Envoyer une notification locale
                            const notification = new Notification(
                                'Inscription réussie'
                                ,
                                {
                                    body:'Merci pour votre inscription, Bienvenue !',
                                    //icon: '/path/to/icon.png'
                                });

                                //Gérer un clic sur la notification
                                notification.onclick = () =>{
                                    window.focus();
                                    window.location.href="index.html";
                                }

                        }else{
                            console.warn('Notifications refusées')
                        }
                    })

                }else{
                    console.error('API Notification pas supporté');
                }
            }

        }
    )
})