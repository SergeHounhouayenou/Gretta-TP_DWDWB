<?php
// 1) Je vérifie que l'id_cars existe avant de supprimer.
// 2) Utiliser une requête DELETE sécurisée avec prepare().
// 3) Ajouter un message de confirmation visuel avant suppression.
// 4) Rediriger l'utilisateur vers db_cars_list.php après suppression.

// Imports
include_once 'header_inc.php';
include_once 'serge_db_connect_inc.php';

// Vérifier si un ID est passé en paramètre
if (!isset($_GET['id_cars']) || empty($_GET['id_cars'])) {
    echo "<p class=\"alert alert-danger\">Aucune voiture spécifiée pour la suppression.</p>";
    echo "<p><a href=\"db_cars_list.php\" class=\"btn btn-secondary\">Retour à la liste</a></p>";
    exit();
}

$id_cars = (int) $_GET['id_cars']; // Sécuriser l'ID

try {
    // Vérifier si la voiture existe
    $sql = "SELECT * FROM cars WHERE id_cars = ? AND deleted = 0";
    $data = $pdo->prepare($sql);
    $data->execute([$id_cars]);
    $car = $data->fetch();

    if (!$car) {
        echo "<p class=\"alert alert-warning\">Cette voiture n'existe pas ou est déjà supprimée.</p>";
        echo "<p><a href=\"db_cars_list.php\" class=\"btn btn-secondary\">Retour à la liste</a></p>";
        exit();
    }

    // Marquer la voiture comme supprimée
    $sql = "UPDATE cars SET deleted = 1 WHERE id_cars = ?";
    $data = $pdo->prepare($sql);
    $data->execute([$id_cars]);

    echo "<p class=\"alert alert-success\">La voiture a été archivée (non supprimée définitivement).</p>";
    echo "<p><a href=\"db_cars_list.php\" class=\"btn btn-primary\">Retour à la liste</a></p>";

    // Si je veux vérifier mes voitures qui ont été éfacées de l'interface utilisateur
    // je questionne la BDD Soit diretement sur PhpMyAdmin (recommandé) soit par requête de connexion :
    // SELECT * FROM cars WHERE deleted = 1;

    // Si je veux restaurer une voiture qui a été supprimée :
    // UPDATE cars SET deleted = 0 WHERE id_cars = X;

    // Si je veux détruir complètement une voiture dans la BDD
    // DELETE FROM cars WHERE id_cars = X;






    // Redirection automatique après 2 secondes
    header("refresh:2;url=db_cars_list.php");

} catch (PDOException $err) {
    echo "<p class=\"alert alert-danger\">Erreur lors de l'archivage : " . $err->getMessage() . "</p>";
    echo "<p><a href=\"db_cars_list.php\" class=\"btn btn-secondary\">Retour à la liste</a></p>";
}
?>