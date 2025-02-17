<?php
// Imports
// include_once 'header_inc.php';
include_once 'serge_db_connect_inc.php';
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>James Bond et les Aston Martin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" 
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="css/main.css">
</head>

<body class="container">

    <nav>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.php">Accueil</a></li>
            <li class="breadcrumb-item">Liste des voitures</li>
        </ol>
    </nav>

    <h1>Liste des voitures</h1>
    <br>
    <p> 
        <a class="alert btn-secondary btn-lg" href="db_cars_edit.php?id_cars="> Ajouter 
        </a>
    </p>

    <br>
    <?php
    try {
        // Préparation et exécution requête

        $sql = "SELECT c.id_cars, c.name, c.model, c.dob, c.photo, g.name AS generique 
        FROM cars c 
        JOIN generics g ON c.id_generics = g.id_generics 
        WHERE c.deleted = 0";

        $data = $pdo->prepare($sql);
        $data->execute(); // Renvoie dataset avec colonnes et lignes

        // Crée le tableau/en-tête
        $html = '<table class="table table-hover">'; 
        $html .= '<thead><tr>';
        for ($i = 0; $i < $data->columnCount(); $i++) {
            // Affiche le nom des colonnes extraits du dataset
            // $html .= '<th>Colonne ' . ($i + 1) . '</th>';
            $meta = $data->getColumnMeta($i);
            $html .= '<th>' . $meta['name'] . '</th>';
            // Stocke dans un tableau le nom de la colonne associé 
            // à son type de données
            $types[$meta['name']] = $meta['native_type'];
        }
        $html .= '</tr></thead>';

        // Crée le tableau/corps
        $html .= '<tbody>';
        while ($row = $data->fetch()) { // Pour chaque ligne du dataset
            $html .= '<tr>';
            foreach ($row as $col => $val) { // Pour chaque colonne de la ligne
                // Teste le type de la colonne
                switch ($types[$col]) {
                    case 'FLOAT':
                    case 'INT':
                    case 'INTEGER':
                    case 'NEWDECIMAL':
                        $align = 'align="right"';
                        break;
                    case 'DATE':
                    case 'DATETIME':
                        $align = 'align="center"';
                        break;
                    default:
                        $align = 'align="left"';
                }
                // Ajoute la donnée dans sa cellule ou dans une image
                if ($types[$col] === 'BLOB' && $val !== null) {
                    $html .= '<td><img src="'.$val . '" style="width:8em;height:4.5em"></td>';
                } else {
                    $html .= '<td ' . $align . '>' . $val . '</td>';
                }
            }
            // Ajoute boutons MAJ et SUPPR
            $html .= '<td><a class="btn btn-warning" href="db_cars_edit.php?id_cars=' . $row['id_cars'] . '">Modif</a></td>';
            $html .= '<td><a class="btn btn-danger" href="db_cars_delete.php?id_cars=' . $row['id_cars'] . '">Suppr</a></td>';
            $html .= '</tr>';
        }
        $html .= '</tbody>';
        $html .= '</table>';
        echo $html;
        unset($pdo); // Déconnexion
    } catch (PDOException $err) {
        echo '<p class="alert alert-danger">' . $err->getMessage() . '</p>';
    }
    ?>

    <script>
        // Branche écouteur sur l'événement WINDOW->ONLOAD
        window.addEventListener(
            'load',
            function() {
                // Branche écouteur sur les A.BTN-DANGER->ONCLICK
                let buttons = document.querySelectorAll('a.btn-danger');
                for (let i = 0; i < buttons.length; i++) {
                    buttons[i].addEventListener(
                        'click',
                        function(evt){
                            evt.preventDefault(); 
                            let answer = confirm('Voulez-vous vraiment supprimer cette ligne ?');
                            if (answer) {
                                location.href = evt.target.href;
                            }
                        },
                        false
                    );
                }
            },
            false
        );
    </script>
</body>

</html>