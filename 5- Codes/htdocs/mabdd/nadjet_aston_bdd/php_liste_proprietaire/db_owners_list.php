<?php
session_start();
include_once '../serge_db_connect_inc.php';

// Vérification des signaux GET
$step = $_GET['step'] ?? '';
$id_owners_modified = $_SESSION['id_owners'] ?? 0;
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des propriétaires</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/main.css">
</head>
<body class="container">
    <h1>Liste des propriétaires</h1>
    <p><a class="btn btn-secondary btn-lg" href="db_owners_edit.php">Ajouter un propriétaire</a></p>

    <br>
    <?php
    try {
        // Requête SQL pour récupérer les propriétaires
        $sql = "SELECT id_owners, name, mail, phone, civility, dob, photo FROM owners ORDER BY id_owners ASC";
        $data = $pdo->query($sql);

        // Vérifier si des enregistrements existent
        if ($data->rowCount() > 0) {
            echo '<table class="table table-hover">';
            echo '<thead><tr><th>ID</th><th>Nom</th><th>Email</th><th>Téléphone</th><th>Civilité</th><th>Date de naissance</th><th>Photo</th><th>Actions</th></tr></thead>';
            echo '<tbody>';

            while ($row = $data->fetch(PDO::FETCH_ASSOC)) {
                echo '<tr id="owner_' . $row['id_owners'] . '">';
                echo '<td>' . htmlspecialchars($row['id_owners']) . '</td>';
                echo '<td>' . htmlspecialchars($row['name']) . '</td>';
                echo '<td>' . htmlspecialchars($row['mail']) . '</td>';
                echo '<td>' . htmlspecialchars($row['phone']) . '</td>';
                echo '<td>' . htmlspecialchars($row['civility']) . '</td>';
                echo '<td>' . htmlspecialchars($row['dob']) . '</td>';
                echo '<td><img src="' . htmlspecialchars($row['photo']) . '" width="50" onerror="this.src=\'../uploads/default.jpg\'"></td>';
                echo '
                    <td>
                        <a class="btn btn-warning" href="db_owners_edit.php?id_owners=' . urlencode($row['id_owners']) . '">Modifier</a>
                        <a class="btn btn-danger" href="db_owners_delete.php?id_owners=' . urlencode($row['id_owners']) . '">Supprimer</a>
                    </td>';
                echo '</tr>';
            }

            echo '</tbody>';
            echo '</table>';
        } else {
            echo '<p class="alert alert-info">Aucun propriétaire enregistré.</p>';
        }
    } catch (PDOException $err) {
        echo '<p class="alert alert-danger">Erreur : ' . $err->getMessage() . '</p>';
    }
    ?>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            let step = new URLSearchParams(window.location.search).get('step');

            if (step === '1') {
                setTimeout(() => {
                    let confirmAction = confirm("Vous avez demandé une modification. Voulez-vous la confirmer ?");
                    if (confirmAction) {
                        window.location.href = 'db_owners_action.php?confirm_update=1&id_owners=<?= $id_owners_modified ?>';
                    } else {
                        window.location.href = 'db_owners_list.php';
                    }
                }, 500);
            }

            if (step === '2') {
                setTimeout(() => {
                    let finalConfirm = confirm("Vérifiez bien : La modification est-elle conforme ?");
                    if (finalConfirm) {
                        window.location.href = 'db_owners_action.php?final_confirmation=1&id_owners=<?= $id_owners_modified ?>';
                    } else {
                        window.location.href = 'db_owners_list.php';
                    }
                }, 500);
            }

            if (step === 'modification_success') {
                setTimeout(() => {
                    alert("Modification réussie !");
                    window.location.href = 'db_owners_list.php';
                }, 500);
            }

            if (step === 'ajout_success') {
                setTimeout(() => {
                    alert("Ajout réussi !");
                    window.location.href = 'db_owners_list.php';
                }, 500);
            }

            if (step === 'no_change') {
                setTimeout(() => {
                    alert("Aucune modification détectée.");
                    window.location.href = 'db_owners_list.php';
                }, 500);
            }
        });
    </script>
</body>
</html>
