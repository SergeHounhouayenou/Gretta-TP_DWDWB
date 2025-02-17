<?php
// Imports
// include_once 'header_inc.php';
include_once 'serge_db_connect_inc.php';
include_once 'serge_functions_inc.php';
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
    <?php
    /*
    1. Créer la table "cars" dans la BDD "aston_bdd" avec les colonnes suivantes (cars.sql) :
    - id_cars / entier / auto incrément + clé primaire
    - name / texte 50 car. / obligatoire
    - model / texte 50 car. / obligatoire
    - rating / réel / * entre 0 et 5 avec une décimale (Exemple : 2.3, 4.2 ou 3)
    - photo / réel avec deux décimales (Exemple : 235.45, 123, 1234.65)
    - photo / LONGBLOB

    2. Générer le formulaire qui permettra d'ajouter une nouvelle voiture à la table créée

    3. Ecrire le script "db_cars_action.php" pour ajouter le contenu du formulaire
       dans la table "cars" de la BDD

    4. Tester si on est en ajout ou en modification (?id_cars=xxx)
    - donner à chaque input sauf PHOTO les valeurs pour la voiture correspondant à l'id
    - gérer le bouton enregistrer (INSERT ou UPDATE)
    */

    // Si on est en mode mise à jour (dans l'URL)
    if (isset($_GET['id_cars']) && !empty($_GET['id_cars'])) {
        $sql = 'SELECT * FROM cars WHERE id_cars = ?';
        $params = array($_GET['id_cars']);
        $data = $pdo->prepare($sql);
        $data->execute($params);
        $row = $data->fetch();
        $update = true;
    } else {
        $row = array(
            'id_cars' => '',
            'name' => '',
            'model' => '',
            'photo' => '',
            'id_generics'=>''
        );
        $update = false;
    }
    ?>

   <h1>Gestion des voitures</h1>

    <nav>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="db_cars_list.php">Home</a></li>
            <li class="breadcrumb-item"><a href="db_cars_list.php">Liste des voitures</a></li>
            <li class="breadcrumb-item active">Ajout-Modification d'une voiture</li>
        </ol>
    </nav>

    <form action="db_cars_action.php?id_cars=<?php echo ($update ? $_GET['id_cars'] : ''); ?>" method="post" enctype="multipart/form-data">
        <div class="group-control">
            <label for="name">Nom :</label>
            <input type="text" class="form-control" value="<?php echo $row['name']; ?>" id="name" name="name" maxlength="50" required>
        </div>
        <div class="group-control">
            <label for="model">Modèle :</label>
            <input type="text" class="form-control" value="<?php echo $row['model']; ?>" id="model" name="model" required>
        </div>
        <div class="group-control">
            <label for="dob">Date de mise en circulation :</label>
            <input  type="date" class="form-control" 
                    value="<?php echo (!empty($row['dob']) ? date('Y-m-d', strtotime($row['dob'])) : ''); ?>" 
                    id="dob" name="dob">
                 <!--   !empty($row['dob']) → Vérifie que la date existe.
                    Si elle existe, elle est convertie au format YYYY-MM-DD.
                    Sinon, elle reste vide (""), évitant ainsi les erreurs d'affichage. -->



        </div>
        <div class="group-control">
            <label for="photo">Photo de la voiture :</label>
            <input type="hidden" name="MAX_FILE_SIZE" value="104857690">
            <input type="file" class="form-control" id="photo" name="photo">
        </div>
        <div class="group-control">
        <label for="id_generics">Générique :</label>
            <?php
            //SELECT * FROM `generics`
            $sql='select id_generics, name from generics';
            $result=$pdo->query($sql);
            $array=$result->fetchAll(PDO::FETCH_NUM);
            echo create_select($array, 'id_generics',$row['id_generics']);
            ?>
        </div>
        <div class="group-control mt-3">
            <input type="submit" class="btn btn-secondary btn-lg" value="<?php echo ($update ? 'Mettre à jour' : 'Ajouter'); ?>">
        </div>

    </form>
</body>

</html> 