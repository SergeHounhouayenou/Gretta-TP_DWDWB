<?php
// Import
include_once 'serge_db_connect_inc.php';
// include_once 'register_action.php';

// Récupération des valeurs du formulaire : 2nde itération
foreach ($_POST as $key => $val) {
    if (isset($_POST[$key]) && !empty($_POST[$key])) {
        $params[':' . $key] = htmlspecialchars($val);
    } else {
        $params[':' . $key] = null;
    }
}

// Récupération du fichier à téléverser
if (isset($_FILES['photo']) && $_FILES['photo']['error'] !== UPLOAD_ERR_NO_FILE) {
    // *******************************************************
    // Variables 
    // *******************************************************
    // var_dump($_FILES);
    $file_name = $_FILES['photo']['name'];

    // Extrait l'extension du nom de fichier
    
    $file_ext = strtolower(substr($file_name, strrpos($file_name, '.') + 1));

    // Taille du fichier en octets
    $file_size = $_FILES['photo']['size'];

    // Type du fichier (Ex.: application/pdf OU text/css OU image/png)
    $file_type = $_FILES['photo']['type'];

    // Adresse du fichier temporaire avant upload
    $file_temp = $_FILES['photo']['tmp_name'];

    // Extensions autorisées
    $allowed_ext = array('bmp', 'gif', 'jpg', 'jpeg', 'png');

    // *******************************************************
    // Gestion des erreurs 
    // *******************************************************
    $errors = array();
    // Si extension incorrecte
    if (!in_array($file_ext, $allowed_ext)) {
        $errors[] = '<p>Extension ' . $file_ext . ' non autorisée : ' . implode(',', $allowed_ext);
    }
    if ($file_size > (int) $_POST['MAX_FILE_SIZE']) {
        $errors[] = '<p>Fichier trop lourd : ' . $_POST['MAX_FILE_SIZE'] . ' octets maximum';
    }

    // *******************************************************
    // Traitement du fichier 
    // *******************************************************
    if (empty($errors)) {
        // 1. Conversion de l'image en base64 et insertion 
        // dans le tableau de paramètres
        $bin = file_get_contents($file_temp);
        $base64 = 'data:' . $file_type . ';base64,' . base64_encode($bin); // Prête à afficher dans SRC
        unset($params[':MAX_FILE_SIZE']); // Supprime l'entrée du tableau de paramètres
        $params[':photo'] = $base64; // Ajoute l'entrée au tableau de paramètres
        // echo $base64;
        // 2. Téléverse le fichier dans le dossier UPLOAD
        if (!move_uploaded_file($file_temp, 'uploads/' . $file_name)) {
            echo '<p>Erreur dans le téléversement du fichier : ' . $file_name;
            echo '<p><a href="index.php">Retour page d\'accueil</a>';
            exit(); // die()
        }
    } else {
        // Affiche les erreurs du tableau
        foreach ($errors as $error) {
            echo $error;
            echo '<p><a href="index.php">Retour page d\'accueil</a>';
            exit();
        }
    }
} else {
    // Si pas de photo choisie
    unset($params[':MAX_FILE_SIZE']);
    $params[':photo'] = null;
}

// Préparation et exécution requête
try {
    //var_dump($_POST);
    //var_dump($params);
    if (isset($_GET['id_cars']) && empty($_GET['id_cars'])) {
        // Si id est vide alors INSERT
        $sql = 'INSERT INTO cars(name, model, dob, photo, id_generics) VALUES(:name, :model, :dob, :photo, :id_generics)';
    } else {
        // Si id n'est pas vide alors UPDATE
        $sql = 'UPDATE cars SET name=:name, model=:model, dob=:dob, photo=:photo, id_generics=:id_generics WHERE id_cars='.$_GET['id_cars'];
    }

    $data = $pdo->prepare($sql);
    $data->execute($params);
    header('location:db_cars_list.php');
} catch (PDOException $err) {
    echo $err->getMessage();
}