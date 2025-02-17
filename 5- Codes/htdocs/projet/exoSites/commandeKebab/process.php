<?php
session_start();

// Liste des produits
$produits = [
    "Americano" => 8,
    "Buffalo" => 9
];

// Vérification de la requête POST
if ($_SERVER["REQUEST_METHOD"] !== "POST" || !isset($_POST["produit"])) {
    header("Location: index.php");
    exit();
}

// Nettoyage et validation de l'entrée
$produit = filter_input(INPUT_POST, 'produit', FILTER_SANITIZE_STRING);

// Vérification de l'existence du produit
if ($produit && array_key_exists($produit, $produits)) {
    // Initialisation du panier si non existant
    if (!isset($_SESSION["panier"][$produit])) {
        $_SESSION["panier"][$produit] = 1;
    } else {
        // Stock max optionnel
        $stock_max = 10;
        if ($_SESSION["panier"][$produit] < $stock_max) {
            $_SESSION["panier"][$produit]++;
        }
    }
}

// Redirection vers l'accueil
header("Location: index.php");
exit();
