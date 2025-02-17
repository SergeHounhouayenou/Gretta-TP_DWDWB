<?php 
include_once 'header_inc.php'; 
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" 
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="css/main.css">
</head>

<body class="container">
    <h1>Liste des voitures</h1>
    <p><button class = "carsListButton" id = "carsListButton" type = "button" name = "" value = "">Ajouter</button></p>
    <nav>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.php">Home</a></li>
            <li class="breadcrumb-item active">Liste des voitures</li>
        </ol>
    </nav>

    <?php
    // Import
    include_once 'serge_constants_inc.php';
    include_once 'serge_db_connect_inc.php'; // Connexion à PDO

    try {
        // Connexion à BDD
        $dsn = 'mysql:host=' . HOST . ';dbname=' . BASE . ';charset=utf8';
        $opt = array(
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        );
        $pdo = new PDO($dsn, USER, PASS, $opt);

        // Exécution requête SQL
        $sql = "SELECT id_cars, name, model, dob, photo FROM cars";

        // Si le paramètre cars est passé dans l'URL alors on filtre
        if (isset($_GET['cars']) && !empty($_GET['cars'])) {
            $sql .= " WHERE cars='" . $_GET['cars'] . "'";
        }

        $data = $pdo->query($sql);
    ?>
        <table class="table table-hover table-dark">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Modèle</th>
                    <th>Mise en circulation</th>
                    <th>Photo</th>
                </tr>
            </thead>
            <tbody>
            <?php
            foreach ($data as $row) {
                echo '<tr>';
                foreach ($row as $col) {
                    echo '<td>' . $col . '</td>';
                }
                echo '</tr>';
            }
        } catch (PDOException $err) {
            echo '<div class="alert alert-danger">' . $err->getMessage() . '</div>';
        }
            ?>
            </tbody>
        </table>
</body>

</html>