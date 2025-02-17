<?php
session_start();
error_log("Données POST : " . print_r($_POST, true));
ini_set('display_errors', 1);
error_reporting(E_ALL);
header('Content-Type:application/json');

$response = ["success" => false];

if (!isset($_POST["article"]) || empty($_POST["article"])) {
    echo json_encode($response);
    exit();
}

$article = htmlspecialchars($_POST["article"]);

if (isset($_SESSION["panier"][$article])) {
    // Décrémenter la quantité ou supprimer si c'est le dernier
    if ($_SESSION["panier"][$article] > 1) {
        $_SESSION["panier"][$article]--;
    } else {
        unset($_SESSION["panier"][$article]);
    }

    $response["success"] = true;

    // Je vérifie que le panier contient bien des articles
    error_log(print_r($_SESSION["panier"], true));


    // Recalcul du total du panier

    // Je récupère d'abord les prix 
    function obtenirPrix($article) {
        // Exemple : récupérer le prix depuis la base de données
        $prix = [
            "Americano" => 8,
            "Buffalo" => 9
        ];
        return $prix[$article] ?? 0; // Retourne 0 si l'article n'est pas trouvé
    }
    // Puis je calcule
    $total = 0;
    foreach ($_SESSION["panier"] as $article => $quantite) {
        $prix = obtenirPrix($article); // Fonction qui récupère le prix
        $total += $prix * $quantite;
    }

    // Je vérifie le total avant l'envoi
    error_log("Total calculé : " . $total);

    $response["total"] = number_format($total, 2, '.', '') . " €"; // Affichage correct du total


    // Générer le HTML mis à jour
    ob_start();
    if (!empty($_SESSION["panier"])) {
        echo "<ul>";
        foreach ($_SESSION["panier"] as $article => $quantite) {
            echo "<li>$quantite x $article <button class='supprimer' data-article='" . htmlspecialchars($article) . "'>❌</button></li>";
        }
        echo "</ul>";
    } else {
        echo "<p>Votre panier est vide.</p>";
    }
    $response["html"] = ob_get_clean();
}
// vérification du nouveau total
error_log("Total final envoyé : " . $total);



// Réponse JSON
header('Content-Type: application/json'); // Déclare la réponse comme JSON
echo json_encode([
    "success" => true,
    "html" => "<p>Article supprimé avec succès.</p>",
    "total" => obtenirPrix($article) // Exemple de mise à jour du total
    
    //"success" => true,
   // "html" => "<p>Article supprimé avec succès.</p>",
   // "total" => obtenirPrix($article) // Exemple de mise à jour du total
]);   
exit;
