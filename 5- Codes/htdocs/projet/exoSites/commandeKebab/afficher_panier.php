<?php
session_start();
$produits = [
    "Americano" => 8,
    "Buffalo" => 9
];

if (!isset($_SESSION["panier"]) || empty($_SESSION["panier"])) {
    echo "<p>Le panier est vide.</p>";
} else {
    echo "<ul>";
    foreach ($_SESSION["panier"] as $produit => $quantite) {
        echo "<li>$produit x $quantite - " . ($produits[$produit] * $quantite) . " € 
        <button class='delete-item' data-produit='$produit'>X</button></li>";
    }
    echo "</ul>";
}
?>
