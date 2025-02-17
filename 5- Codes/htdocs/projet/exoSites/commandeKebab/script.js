document.addEventListener("DOMContentLoaded", function () {
    const popup = document.getElementById("popupModifier");
    const boutonModifier = document.getElementById("modifierCommande");
    const boutonFermer = document.getElementById("fermerPopup");
    const listeModification = document.getElementById("liste-modification");
    const recapCommande = document.getElementById("recapCommande");
    const totalCommande = document.getElementById("totalCommande");
    const boutonVider = document.getElementById("viderPanier");

    // Pop-up de confirmation de suppression
    const popupConfirmation = document.createElement("div");
    popupConfirmation.id = "popupConfirmation";
    popupConfirmation.style.display = "none";
    popupConfirmation.innerHTML = `
        <div class="popup-content">
            <p>Voulez-vous vraiment supprimer cet article ?</p>
            <button id="confirmerSuppression">Confirmer</button>
            <button id="annulerSuppression">Annuler</button>
        </div>
    `;
    document.body.appendChild(popupConfirmation);

    let articleASupprimer = null;

    function ouvrirPopupConfirmation(article) {
        articleASupprimer = article;
        popupConfirmation.style.display = "block";
    }

    function fermerPopupConfirmation() {
        popupConfirmation.style.display = "none";
        articleASupprimer = null;
    }

    document.getElementById("annulerSuppression").addEventListener("click", fermerPopupConfirmation);

    // Ouvrir et fermer la pop-up de modification
    if (boutonModifier && popup) {
        boutonModifier.addEventListener("click", () => {
            popup.style.display = "block";
        });
    }

    if (boutonFermer) {
        boutonFermer.addEventListener("click", () => {
            popup.style.display = "none";
            setTimeout(() => {
                location.reload();
            }, 300);
        });
    }

    // Fonction pour mettre à jour le total du panier
    function mettreAJourTotal() {
        fetch("/projet/exoSites/commandeKebab/total_panier.php")
            .then(response => response.text())
            .then(total => {
                if (totalCommande) {
                    console.log("Nouveau total mis à jour :", total);
                    totalCommande.textContent = total;
                }
            })
            .catch(error => console.error("Erreur mise à jour total :", error));
    }

    // Fonction pour mettre à jour l'affichage après suppression ou modification
    function mettreAJourAffichage(html) {
        const parser = new DOMParser();
        const newDocument = parser.parseFromString(html, "text/html");

        // Sélectionner uniquement la nouvelle liste d'articles mise à jour
        const nouvelleListe = newDocument.getElementById("liste-modification");
        const nouveauRecap = newDocument.getElementById("recapCommande");

        if (listeModification && nouvelleListe) {
            listeModification.innerHTML = nouvelleListe.innerHTML; // Remplace uniquement les articles
        }
        if (recapCommande && nouveauRecap) {
            recapCommande.innerHTML = nouveauRecap.innerHTML; // Met à jour le récap
        }

        // Afficher un message temporaire
        const messageSuppression = document.getElementById("message-suppression");
        if (messageSuppression) {
            messageSuppression.innerHTML = "<p>Article supprimé !</p>";
            setTimeout(() => {
                messageSuppression.innerHTML = "";
            }, 3000);
        }

        mettreAJourTotal(); // Mettre à jour le total du panier
        reattacherEvenements(); // Réattacher les événements après modification
    }

    // Fonction pour rattacher les événements après mise à jour du DOM
    function reattacherEvenements() {
        document.querySelectorAll(".supprimer").forEach(button => {
            button.removeEventListener("click", ouvrirPopupConfirmation);
            button.addEventListener("click", function () {
                ouvrirPopupConfirmation(this.getAttribute("data-article"));
            });
        });
    }

    // Suppression d'un article avec confirmation
    document.getElementById("confirmerSuppression").addEventListener("click", function () {
        if (!articleASupprimer) return;

        fetch("supprimer.php", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "article=" + encodeURIComponent(articleASupprimer)
        })
        .then(response => response.json()) // Convertit directement en JSON
        .then(data => {
            console.log("Données reçues après suppression :", data);
            if (data.success) {
                mettreAJourAffichage(data.html);
            }
            fermerPopupConfirmation();
        })
        .catch(error => console.error("Erreur AJAX:", error));
    });

    // Attacher les événements de suppression au chargement
    document.querySelectorAll(".supprimer").forEach(button => {
        button.addEventListener("click", function () {
            ouvrirPopupConfirmation(this.getAttribute("data-article"));
        });
    });

    // Vider tout le panier
    if (boutonVider) {
        boutonVider.addEventListener("click", function () {
            if (!confirm("Voulez-vous vraiment vider votre panier ?")) {
                return;
            }

            fetch("vider.php", { method: "POST" })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        mettreAJourAffichage("<p>Votre panier est vide.</p>");
                    }
                })
                .catch(error => console.error("Erreur AJAX:", error));
        });
    }
});








/*

document.addEventListener("DOMContentLoaded", function () {
    const popup = document.getElementById("popupModifier");
    const boutonModifier = document.getElementById("modifierCommande");
    const boutonFermer = document.getElementById("fermerPopup");
    const listeModification = document.getElementById("liste-modification");
    const recapCommande = document.getElementById("recapCommande");
    const totalCommande = document.getElementById("totalCommande");
    const boutonVider = document.getElementById("viderPanier");

    // Pop-up de confirmation de suppression
    const popupConfirmation = document.createElement("div");
    popupConfirmation.id = "popupConfirmation";
    popupConfirmation.style.display = "none";
    popupConfirmation.innerHTML = `
        <div class="popup-content">
            <p>Voulez-vous vraiment supprimer cet article ?</p>
            <button id="confirmerSuppression">Confirmer</button>
            <button id="annulerSuppression">Annuler</button>
        </div>
    `;
    document.body.appendChild(popupConfirmation);

    let articleASupprimer = null;

    function ouvrirPopupConfirmation(article) {
        articleASupprimer = article;
        popupConfirmation.style.display = "block";
    }

    function fermerPopupConfirmation() {
        popupConfirmation.style.display = "none";
        articleASupprimer = null;
    }

    document.getElementById("annulerSuppression").addEventListener("click", fermerPopupConfirmation);

    // Ouvrir et fermer la pop-up de modification
    if (boutonModifier && popup) {
        boutonModifier.addEventListener("click", () => {
        popup.style.display = "block";
        });
    }

    if (boutonFermer) {
        boutonFermer.addEventListener("click", () => {
            popup.style.display = "none";
            setTimeout(() => {
                location.reload();
            }, 300);
        });
    }

    // Fonction pour mettre à jour le total du panier
    function mettreAJourTotal() {
        fetch("/projet/exoSites/commandeKebab/total_panier.php")
            .then(response => response.text())
            .then(total => {
                if (totalCommande) {
                    console.log("Nouveau total mis à jour :", total);
                    totalCommande.textContent = total;
                }
            })
            console.log("URL de requête AJAX :", window.location.origin + "/projet/exoSites/commandeKebab/total_panier.php");
            fetch(window.location.origin + "/projet/exoSites/commandeKebab/total_panier.php")

            .catch(error => console.error("Erreur mise à jour total :", error));
    }

    // Fonction pour mettre à jour l'affichage après suppression ou modification
    function mettreAJourAffichage(html) {
        const parser = new DOMParser();
        const newDocument = parser.parseFromString(html, "text/html");
    
        // Sélectionner uniquement la nouvelle liste d'articles mise à jour
        const nouvelleListe = newDocument.getElementById("liste-modification");
        const nouveauRecap = newDocument.getElementById("recapCommande");
    
        if (listeModification && nouvelleListe) {
            listeModification.innerHTML = nouvelleListe.innerHTML; // Remplace uniquement les articles
        }
        if (recapCommande && nouveauRecap) {
            recapCommande.innerHTML = nouveauRecap.innerHTML; // Met à jour le récap
        }
    
        // Afficher un message temporaire
        const messageSuppression = document.getElementById("message-suppression");
        if (messageSuppression) {
            messageSuppression.innerHTML = "<p>Article supprimé !</p>";
            setTimeout(() => {
                messageSuppression.innerHTML = "";
            }, 3000);
        }
    
        mettreAJourTotal(); // Mettre à jour le total du panier
        reattacherEvenements(); // Réattacher les événements après modification
    }
    
    

    // Fonction pour rattacher les événements après mise à jour du DOM
    function reattacherEvenements() {
        document.querySelectorAll(".supprimer").forEach(button => {
            button.removeEventListener("click", supprimerArticle);
            button.addEventListener("click", function () {
                ouvrirPopupConfirmation(this.getAttribute("data-article"));
            });
        });
    }

    // Suppression d'un article avec confirmation
    document.getElementById("confirmerSuppression").addEventListener("click", function () {
        if (!articleASupprimer) return;

        fetch("supprimer.php", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "article=" + encodeURIComponent(articleASupprimer)
        })
        .then(response => response.json()) // Convertit directement en JSON
        .then(data => {
            console.log("Données reçues après suppression :", data);
            if (data.success) {
                mettreAJourAffichage(data.html);
            }
            fermerPopupConfirmation();
        })
        .catch(error => console.error("Erreur AJAX:", error));
    });

    // Attacher les événements de suppression au chargement
    document.querySelectorAll(".supprimer").forEach(button => {
        button.addEventListener("click", function () {
            ouvrirPopupConfirmation(this.getAttribute("data-article"));
        });
    });

    // Vider tout le panier
    if (boutonVider) {
        boutonVider.addEventListener("click", function () {
            if (!confirm("Voulez-vous vraiment vider votre panier ?")) {
                return;
            }

            fetch("vider.php", { method: "POST" })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        mettreAJourAffichage("<p>Votre panier est vide.</p>");
                    }
                })
                .catch(error => console.error("Erreur AJAX:", error));
        });
    }
});






*/
