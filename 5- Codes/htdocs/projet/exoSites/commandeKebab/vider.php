
<?php
session_start();
$_SESSION["panier"] = []; // Vider le panier

echo json_encode([
    "success" => true,
    "html" => "<p>Votre panier est vide.</p>", // Nouveau HTML à afficher
    "total" => "0 €"
]);
exit();


