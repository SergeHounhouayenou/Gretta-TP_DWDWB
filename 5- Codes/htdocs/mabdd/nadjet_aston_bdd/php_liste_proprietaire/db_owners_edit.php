<!DOCTYPE html>
<!-- Je vaux être capable de me mettre automatiquement en mode "Ajouter un propriétaire si aucun id n'existe encore.
        // Si id_owners est dans l’URL, on charge les données du propriétaire.
        // Sinon, on affiche un formulaire vide pour ajouter un nouveau propriétaire.
// Je veux être par défaut en mode "modification" si id existe déjà.
// Je veux créer le formulaire d'interaction (l'interface d'action) avec tous les champs nécessaires
        // Ce formulaire est envoyé à db_owners_action.php
        // Si id_owners est présent, alors c’est une modification.
        // Sinon, c'est un nouvel ajout.
// Je veux gérer l'upload d'une photo pour le propriétaire -->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un propriétaire</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/main.css">
</head>

<body class="container">
    
    <?php
    // Imports
    include_once '../serge_db_connect_inc.php';

    // Vérifier si un ID est passé pour être en mode modification
    $edit_mode = isset($_GET['id_owners']) && is_numeric($_GET['id_owners']) && $_GET['id_owners'] > 0;
    $id_owners = $edit_mode ? (int) $_GET['id_owners'] : null;

    if ($edit_mode) {
        // Récupérer les données du propriétaire
        $sql = "SELECT * FROM owners WHERE id_owners = ?";
        $data = $pdo->prepare($sql);
        $data->execute([$id_owners]);
        $owner = $data->fetch(PDO::FETCH_ASSOC);

        if (!$owner) {
            echo "<p class='alert alert-danger'>Erreur : Propriétaire introuvable.</p>";
            exit();
        }
    } else {
        // Mode ajout : initialiser les valeurs vides
        $owner = [
            'id_owners' => '',
            'name' => '',
            'mail' => '',
            'phone' => '',
            'civility' => '',
            'dob' => '',
            'photo' => ''
        ];
    }
    ?>

    <h1><?php echo $edit_mode ? 'Modifier un propriétaire' : 'Ajouter un propriétaire'; ?></h1>

    <form action="db_owners_action.php?id_owners=<?php echo $id_owners; ?>" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="id_owners">ID (non modifiable) :</label>
            <input type="text" class="form-control" name="id_owners" id="id_owners" value="<?php echo htmlspecialchars($owner['id_owners']); ?>" readonly>
        </div>

        <div class="form-group">
            <label for="name">Nom :</label>
            <input type="text" class="form-control" name="name" id="name" value="<?php echo htmlspecialchars($owner['name']); ?>" required>
        </div>

        <div class="form-group">
            <label for="mail">Email :</label>
            <input type="email" class="form-control" name="mail" id="mail" value="<?php echo htmlspecialchars($owner['mail']); ?>" required>
        </div>

        <div class="form-group">
            <label for="phone">Téléphone :</label>
            <input type="text" class="form-control" name="phone" id="phone" value="<?php echo htmlspecialchars($owner['phone']); ?>">
        </div>

        <div class="form-group">
            <label for="civility">Civilité :</label>
            <select name="civility" id="civility" class="form-control">
                <option value="Sir" <?php echo ($owner['civility'] == 'Sir') ? 'selected' : ''; ?>>Sir</option>
                <option value="Mr" <?php echo ($owner['civility'] == 'Mr') ? 'selected' : ''; ?>>Mr</option>
            </select>
        </div>

        <div class="form-group">
            <label for="dob">Date de naissance :</label>
            <input type="date" class="form-control" name="dob" id="dob" value="<?php echo htmlspecialchars($owner['dob']); ?>">
        </div>

        <div class="form-group">
            <label for="photo">Photo :</label>
            <input type="file" class="form-control" name="photo" id="photo">
            <?php if (!empty($owner['photo'])) { ?>
                <img src="<?php echo htmlspecialchars($owner['photo']); ?>" width="100">
            <?php } ?>
        </div>

        <div class="form-group">
            <input type="submit" id="submit_button" class="btn btn-primary" value="">
            <a href="db_owners_list.php" class="btn btn-secondary">Annuler</a>
        </div>
        <input type="hidden" name="modif_id" value="<?php echo bin2hex(random_bytes(16)); ?>">
        <input type="hidden" name="form_mode" id="form_mode" value="<?php echo $edit_mode ? 'modification' : 'ajout'; ?>">   
    </form>
    

    <script>
        window.addEventListener('load', function() 
        {
            let formMode = document.getElementById("form_mode").value;
            let submitButton = document.getElementById("submit_button");

            if (formMode === "modification") {
                submitButton.value = "Modifier";
            } else {
                submitButton.value = "Ajouter";
            }
        }
        );
    </script>


</body>
</html>
