<?php
session_start();
$total = 0;

$produits = [
    "Americano" => 8,
    "Buffalo" => 9
];

// Vérifier si le panier est défini et non vide
if (!empty($_SESSION["panier"])) {
    foreach ($_SESSION["panier"] as $produit => $quantite) {
        if (isset($produits[$produit])) { // Vérification si le produit existe bien
            $total += $produits[$produit] * $quantite;
        }
    }
}

// Affichage formaté du total
echo number_format($total, 2, ',', ' ') . " €";
exit();
