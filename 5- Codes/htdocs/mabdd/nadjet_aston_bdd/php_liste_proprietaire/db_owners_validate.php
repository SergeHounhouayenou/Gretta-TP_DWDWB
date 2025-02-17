<?php
// Imports et activation des sessions
include_once '../serge_db_connect_inc.php';
session_start();

// Vérifier si une modification est en attente
if (!isset($_SESSION['modification_pending'])) {
    echo "<script>window.location.href = 'db_owners_list.php';</script>";
    exit();
}

// Récupérer les données de session
$modification_data = $_SESSION['modification_pending'];
$id_owners = $modification_data['id_owners'];
$new_data = $modification_data['new_data'];
$old_data = $modification_data['old_data'];

// Vérification finale AVANT modification
if ($new_data == $old_data) {
    echo "<script>window.location.href = 'db_owners_list.php';</script>";
    exit();
}

// Mise à jour effective en base
try {
    $sql = "UPDATE owners SET name=?, mail=?, phone=?, civility=?, dob=?, photo=? WHERE id_owners=?";
    $data = $pdo->prepare($sql);
    $data->execute([$new_data["name"], $new_data["mail"], $new_data["phone"], $new_data["civility"], $new_data["dob"], $new_data["photo"], $id_owners]);

    // Suppression des données de session
    unset($_SESSION['modification_pending']);

    // 🚀 On ne met PAS d'alerte ici, on redirige directement avec un signal GET
    header("Location: db_owners_list.php?modification_confirmed=1&id_owners=$id_owners");
    exit();
} catch (PDOException $err) {
    echo "<script>window.location.href = 'db_owners_list.php?modification_failed=1';</script>";
}
?>
