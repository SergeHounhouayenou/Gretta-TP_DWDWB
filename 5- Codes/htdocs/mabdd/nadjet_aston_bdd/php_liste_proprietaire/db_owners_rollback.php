<?php
// Imports
include_once '../serge_db_connect_inc.php';
session_start();

// Vérifier si un ID est passé
if (!isset($_GET['id_owners']) || empty($_GET['id_owners'])) {
    echo "<p class='alert alert-danger'>Erreur : Aucun propriétaire spécifié.</p>";
    exit();
}

$id_owners = (int) $_GET['id_owners'];

try {
    // Récupérer l'ancienne version en historique
    $sql = "SELECT old_data FROM owners_history WHERE id_owners = ? ORDER BY id DESC LIMIT 1";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners]);
    $history = $data->fetch(PDO::FETCH_ASSOC);

    if (!$history) {
        echo "<p class='alert alert-danger'>Erreur : Impossible de récupérer les anciennes données.</p>";
        exit();
    }

    $old_data = json_decode($history['old_data'], true);

    // Restaurer l'ancienne version
    $sql = "UPDATE owners SET name=?, mail=?, phone=?, civility=?, dob=?, photo=? WHERE id_owners=?";
    $data = $pdo->prepare($sql);
    $data->execute([$old_data["name"], $old_data["mail"], $old_data["phone"], $old_data["civility"], $old_data["dob"], $old_data["photo"], $id_owners]);

    // Enregistrer l'annulation dans l'historique
    $sql = "INSERT INTO owners_history (id_owners, action, old_data) VALUES (?, 'annulation', ?)";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners, json_encode($old_data)]);

    // Redirection avec un message de succès
    header("Location: db_owners_list.php?rollback_success=1&id_owners=$id_owners");
    exit();
} catch (PDOException $err) {
    echo "<p class='alert alert-danger'>Erreur : " . $err->getMessage() . "</p>";
}
?>
