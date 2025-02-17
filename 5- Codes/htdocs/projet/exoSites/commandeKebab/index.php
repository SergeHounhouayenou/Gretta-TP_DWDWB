<?php
session_start();

// Liste des produits avec prix
$produits = [
    "Americano" => 8,
    "Buffalo" => 9
];

// Initialisation du panier
if (!isset($_SESSION["panier"])) {
    $_SESSION["panier"] = [];
}

// Fonction pour calculer le total
function calculerTotal($panier, $produits) {
    $total = 0;
    foreach ($panier as $article => $quantite) {
        if (isset($produits[$article])) { // Vérification de l'existence de l'article
            $total += $produits[$article] * $quantite;
        }
    }
    return $total;
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Commande de Kébab</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <h2>Choisissez votre Kébab</h2>

    <form action="process.php" method="post">
        <?php foreach ($produits as $nom => $prix): ?>
            <button type="submit" name="produit" value="<?= htmlspecialchars($nom); ?>">
                Ajouter <?= htmlspecialchars($nom); ?> (<?= $prix; ?>€)
            </button>
        <?php endforeach; ?>
    </form>

    <h3>🛒 Récapitulatif de votre commande</h3>

    <?php if (!empty($_SESSION["panier"])): ?>
        <ul id="recapCommande">
            <?php foreach ($_SESSION["panier"] as $article => $quantite): ?>
                <?php if (isset($produits[$article])): ?>
                    <li data-article="<?= htmlspecialchars($article); ?>">
                        <?= $quantite; ?> x <?= htmlspecialchars($article); ?> 
                        (<?= $produits[$article] * $quantite; ?>€)
                    </li>
                <?php endif; ?>
            <?php endforeach; ?>
        </ul>

        <p id="totalCommande"><strong>Total : <?= calculerTotal($_SESSION["panier"], $produits); ?> €</strong></p>
        <button id="modifierCommande">Modifier</button>
        <button id="viderPanier">Vider le panier</button>
        <div id="message-suppression"></div>

    <?php else: ?>
        <p>Votre panier est vide.</p>
    <?php endif; ?>

    <!-- Pop-up de modification (affichée seulement si panier non vide) -->
    <?php if (!empty($_SESSION["panier"])): ?>
    <div id="popupModifier" class="popup">
        <div class="popup-content">
            <h3>Modifier votre commande</h3>
            <ul id="liste-modification">
                <?php foreach ($_SESSION["panier"] as $article => $quantite): ?>
                    <?php if (isset($produits[$article])): ?>
                        <li data-article="<?= htmlspecialchars($article); ?>">
                            <?= $quantite; ?> x <?= htmlspecialchars($article); ?>
                            <button class="supprimer" data-article="<?= htmlspecialchars($article); ?>">❌</button>
                        </li>
                    <?php endif; ?>
                <?php endforeach; ?>
            </ul>
            <button id="fermerPopup">Fermer</button>
        </div>
    </div>
    <?php endif; ?>

    <script src="script.js"></script>
   
</body>
<!--
// Sécurisation des valeurs affichées : Utilisation de htmlspecialchars() pour éviter les injections XSS.
// Vérification de l'existence d'un produit avant son affichage : Empêche une erreur PHP si un article non défini est dans le panier.
// Ajout de data-article sur les éléments de la liste : Facilite la suppression dynamique avec JavaScript.
// Affichage conditionnel de la pop-up : Elle ne s'affiche que si le panier contient des articles.
-->
</html>


