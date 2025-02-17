
<?php
include_once '../serge_db_connect_inc.php';
session_start();

// 🔹 Définition du mode (ajout ou modification)
$form_mode = $_POST['form_mode'] ?? $_SESSION['form_mode'] ?? 'ajout';

// 🔹 Gestion de l'ID propriétaire (sans `AUTO_INCREMENT`)
if ($form_mode === "modification") {
    $id_owners = $_POST['id_owners'] ?? $_SESSION['id_owners'] ?? $_GET['id_owners'] ?? null;
} else {
    // Mode ajout → Générer un ID manuel
    $sql = "SELECT MAX(id_owners) AS max_id FROM owners";
    $data = $pdo->query($sql);
    $row = $data->fetch(PDO::FETCH_ASSOC);
    $id_owners = ($row['max_id'] ?? 0) + 1; // 🔹 Incrémentation manuelle
}

// 📌 Vérification que l'ID est bien défini en modification
if (!$id_owners && $form_mode === "modification") {
    echo "<p class='alert alert-danger'>Erreur critique : ID propriétaire non défini.</p>";
    exit();
}

// 📌 Stockage de l'ID en session
$_SESSION['id_owners'] = $id_owners;

// 🔹 Récupération des valeurs POST pour l'ajout/modification
$name = trim($_POST['name'] ?? '');
$mail = trim($_POST['mail'] ?? '');
$phone = trim($_POST['phone'] ?? '');
$civility = trim($_POST['civility'] ?? '');
$dob = trim($_POST['dob'] ?? '');
$photo_path = $_SESSION['form_snapshot']['photo'] ?? null;

// 📌 Vérification des champs obligatoires
if (empty($name) || empty($mail)) {
    echo "<p class='alert alert-danger'>Erreur : Le nom et l'email sont obligatoires.</p>";
    exit();
}

// 📌 Vérification si on est bien en mode MODIFICATION
if ($form_mode === "modification") {
    // 🔹 Récupération des anciennes données
    $sql = "SELECT * FROM owners WHERE id_owners = ?";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners]);
    $old_owner = $data->fetch(PDO::FETCH_ASSOC);

    if (!$old_owner) {
        echo "<p class='alert alert-danger'>Erreur : Ce propriétaire n'existe pas.</p>";
        exit();
    }

    // 🔹 Comparaison des valeurs avant modification
    $new_data = [
        "name" => $name ?: $old_owner['name'],
        "mail" => $mail ?: $old_owner['mail'],
        "phone" => $phone ?: $old_owner['phone'],
        "civility" => $civility ?: $old_owner['civility'],
        "dob" => $dob ?: $old_owner['dob'],
        "photo" => $photo_path ?: $old_owner['photo']
    ];
    $diff = array_diff_assoc($new_data, $old_owner);

    // 📌 Si aucune modification n'a été faite
    if (empty($diff)) {
        $_SESSION['no_changes'] = true;
        header("Location: db_owners_list.php?step=no_change");
        exit();
    }

    // 🔹 Étape 1 : **Première confirmation**
    if (!isset($_GET['confirm_update'])) {
        $_SESSION['modification_data'] = $new_data;
        $_SESSION['confirm_update'] = true;
        // **🟢 Ne pas rediriger immédiatement, on affiche la première popup**
        echo "<script>
            if (confirm('Vous avez demandé une modification. Voulez-vous la confirmer ?')) {
                window.location.href = 'db_owners_action.php?id_owners={$id_owners}&confirm_update=1';
            } else {
                window.location.href = 'db_owners_list.php';
            }
        </script>";
        exit();
    }

    // 🔹 Étape 2 : **Deuxième confirmation**
    if (!isset($_GET['final_confirmation'])) {
        $_SESSION['final_confirmation'] = true;
        echo "<script>
            if (confirm('Vérifiez bien : La modification est-elle conforme ?')) {
                window.location.href = 'db_owners_action.php?id_owners={$id_owners}&final_confirmation=1';
            } else {
                window.location.href = 'db_owners_list.php';
            }
        </script>";
        exit();
    }

    // 🔹 Mise à jour de la base de données
    $sql = "UPDATE owners SET name=?, mail=?, phone=?, civility=?, dob=?, photo=? WHERE id_owners=?";
    $data = $pdo->prepare($sql);
    $data->execute([$name, $mail, $phone, $civility, $dob, $photo_path, $id_owners]);

    // 🔹 Nettoyage des sessions et redirection finale
    unset($_SESSION['modification_data'], $_SESSION['confirm_update'], $_SESSION['final_confirmation']);
    $_SESSION['update_success'] = true;

    // ✅ **Affichage du bon message après modification**
    header("Location: db_owners_list.php?step=modification_success");
    exit();
}

// 📌 Mode AJOUT
if ($form_mode === "ajout") {
    // 🔹 Vérification que l'ID n'existe pas déjà en base
    $sql = "SELECT id_owners FROM owners WHERE id_owners = ?";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners]);
    if ($data->fetch()) {
        echo "<p class='alert alert-danger'>Erreur : L'ID du propriétaire existe déjà.</p>";
        exit();
    }

    // 🔹 Insertion dans la base de données avec ID manuel
    $sql = "INSERT INTO owners (id_owners, name, mail, phone, civility, dob, photo) VALUES (?, ?, ?, ?, ?, ?, ?)";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners, $name, $mail, $phone, $civility, $dob, $photo_path]);

    // 🔹 Stocker le nouvel ID en session après insertion
    $_SESSION['id_owners'] = $id_owners;
    $_SESSION['add_success'] = true;

    // ✅ **Affichage du bon message après ajout**
    header("Location: db_owners_list.php?step=ajout_success");
    exit();
}

// 🚨 Mode inconnu
echo "<p class='alert alert-danger'>Erreur : Mode d'action inconnu.</p>";
exit();







/*
include_once '../serge_db_connect_inc.php';
session_start();

// 🔹 Définition du mode (ajout ou modification)
$form_mode = $_POST['form_mode'] ?? $_SESSION['form_mode'] ?? 'ajout';

// 🔹 Gestion de l'ID propriétaire (sans `AUTO_INCREMENT`)
if ($form_mode === "modification") {
    $id_owners = $_POST['id_owners'] ?? $_SESSION['id_owners'] ?? $_GET['id_owners'] ?? null;
} else {
    // Mode ajout → Générer un ID manuel
    $sql = "SELECT MAX(id_owners) AS max_id FROM owners";
    $data = $pdo->query($sql);
    $row = $data->fetch(PDO::FETCH_ASSOC);
    $id_owners = ($row['max_id'] ?? 0) + 1; // 🔹 Incrémentation manuelle
}

// 📌 Vérification que l'ID est bien défini en modification
if (!$id_owners && $form_mode === "modification") {
    echo "<p class='alert alert-danger'>Erreur critique : ID propriétaire non défini.</p>";
    exit();
}

// 📌 Stockage de l'ID en session
$_SESSION['id_owners'] = $id_owners;

// 🔹 Récupération des valeurs POST pour l'ajout/modification
$name = trim($_POST['name'] ?? $_SESSION['modification_data']['name'] ?? '');
$mail = trim($_POST['mail'] ?? $_SESSION['modification_data']['mail'] ?? '');
$phone = trim($_POST['phone'] ?? $_SESSION['modification_data']['phone'] ?? '');
$civility = trim($_POST['civility'] ?? $_SESSION['modification_data']['civility'] ?? '');
$dob = trim($_POST['dob'] ?? $_SESSION['modification_data']['dob'] ?? '');
$photo_path = $_SESSION['form_snapshot']['photo'] ?? null;

// 📌 Vérification des champs obligatoires
if (empty($name) || empty($mail)) {
    echo "<p class='alert alert-danger'>Erreur : Le nom et l'email sont obligatoires.</p>";
    exit();
}

// 📌 Gestion des actions
if ($form_mode === "ajout") {
    // 🔹 Vérification que l'ID n'existe pas déjà en base
    $sql = "SELECT id_owners FROM owners WHERE id_owners = ?";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners]);
    if ($data->fetch()) {
        echo "<p class='alert alert-danger'>Erreur : L'ID du propriétaire existe déjà.</p>";
        exit();
    }

    // 🔹 Insertion dans la base de données avec ID manuel
    $sql = "INSERT INTO owners (id_owners, name, mail, phone, civility, dob, photo) VALUES (?, ?, ?, ?, ?, ?, ?)";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners, $name, $mail, $phone, $civility, $dob, $photo_path]);

    // 🔹 Stocker le nouvel ID en session après insertion
    $_SESSION['id_owners'] = $id_owners;
    $_SESSION['add_success'] = true;

    // ✅ **Affichage du bon message après ajout**
    header("Location: db_owners_list.php?step=ajout_success");
    exit();
}

// 🔹 Mode MODIFICATION
if ($form_mode === "modification") {
    // 🔹 Récupération des anciennes données
    $sql = "SELECT * FROM owners WHERE id_owners = ?";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners]);
    $old_owner = $data->fetch(PDO::FETCH_ASSOC);

    if (!$old_owner) {
        echo "<p class='alert alert-danger'>Erreur : Ce propriétaire n'existe pas.</p>";
        exit();
    }

    // 🔹 Comparaison des valeurs avant modification
    $new_data = [
        "name" => $name ?: $old_owner['name'],
        "mail" => $mail ?: $old_owner['mail'],
        "phone" => $phone ?: $old_owner['phone'],
        "civility" => $civility ?: $old_owner['civility'],
        "dob" => $dob ?: $old_owner['dob'],
        "photo" => $photo_path ?: $old_owner['photo']
    ];
    $diff = array_diff_assoc($new_data, $old_owner);

    // 📌 Si aucune modification n'a été faite
    if (empty($diff)) {
        $_SESSION['no_changes'] = true;
        header("Location: db_owners_list.php?step=no_change");
        exit();
    }

    // 🔹 Étape 1 : Première confirmation
    if (!isset($_GET['confirm_update'])) {
        $_SESSION['modification_data'] = $new_data;
        $_SESSION['confirm_update'] = true;
        header("Location: db_owners_list.php?step=1");
        exit();
    }

    // 🔹 Étape 2 : Deuxième confirmation
    if (!isset($_GET['final_confirmation'])) {
        $_SESSION['final_confirmation'] = true;
        header("Location: db_owners_list.php?step=2");
        exit();
    }

    // 🔹 Mise à jour de l'historique
    $sql = "INSERT INTO owners_history (id_owners, action, old_data) VALUES (?, 'modification', ?)";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners, json_encode($old_owner)]);

    // 🔹 Mise à jour de la base de données
    $sql = "UPDATE owners SET name=?, mail=?, phone=?, civility=?, dob=?, photo=? WHERE id_owners=?";
    $data = $pdo->prepare($sql);
    $data->execute([$name, $mail, $phone, $civility, $dob, $photo_path, $id_owners]);

    // 🔹 Nettoyage des sessions et redirection finale
    unset($_SESSION['modification_data'], $_SESSION['confirm_update'], $_SESSION['final_confirmation']);
    $_SESSION['update_success'] = true;

    // ✅ **Affichage du bon message après modification**
    header("Location: db_owners_list.php?step=modification_success");
    exit();
}

// 🚨 Mode inconnu
echo "<p class='alert alert-danger'>Erreur : Mode d'action inconnu.</p>";
exit();

*/






/*
// Imports
include_once '../serge_db_connect_inc.php';
session_start(); // Activation de la session pour suivre les modifications

// Vérification du mode (ajout ou modification)
$form_mode = isset($_POST['form_mode']) ? $_POST['form_mode'] : 'ajout';
$id_owners = isset($_GET['id_owners']) ? (int) $_GET['id_owners'] : null;
$modif_id = isset($_POST['modif_id']) ? $_POST['modif_id'] : null;
$confirm_update = isset($_POST['confirm_update']) ? true : false;
$final_confirmation = isset($_POST['final_confirmation']) ? true : false; // 2e confirmation

// Récupération des données envoyées depuis le formulaire
$name = !empty($_POST['name']) ? htmlspecialchars($_POST['name']) : null;
$mail = !empty($_POST['mail']) ? htmlspecialchars($_POST['mail']) : null;
$phone = !empty($_POST['phone']) ? htmlspecialchars($_POST['phone']) : null;
$civility = !empty($_POST['civility']) ? htmlspecialchars($_POST['civility']) : null;
$dob = !empty($_POST['dob']) ? $_POST['dob'] : null;

// 📌 Vérification que `form_mode` existe bien
if (!isset($_POST['form_mode'])) {
    echo "<p class='alert alert-danger'>Erreur : Formulaire invalide (mode d'action manquant).</p>";
    exit();
}

// 🔄 Gestion des actions avec `switch case`
switch ($form_mode) {
    case "modification":
        // 1️⃣ Vérifier si l'ID existe en base
        $sql = "SELECT * FROM owners WHERE id_owners = ?";
        $data = $pdo->prepare($sql);
        $data->execute([$id_owners]);
        $old_owner = $data->fetch(PDO::FETCH_ASSOC);

        if (!$old_owner) {
            echo "<p class='alert alert-danger'>Erreur : Ce propriétaire n'existe pas.</p>";
            exit();
        }

        // 2️⃣ Comparaison des valeurs
        $new_data = [
            "name" => $name ?? $old_owner['name'],
            "mail" => $mail ?? $old_owner['mail'],
            "phone" => $phone ?? $old_owner['phone'],
            "civility" => $civility ?? $old_owner['civility'],
            "dob" => $dob ?? $old_owner['dob']
        ];

        $diff = array_diff_assoc($new_data, $old_owner);

        // 3️⃣ Première demande de confirmation
        if (!empty($diff) && !$confirm_update) {
            $_SESSION['modification_data'] = $new_data; // Sauvegarde temporaire en session
            echo "<p class='alert alert-warning'>Attention : Les valeurs modifiées ne correspondent pas à la saisie !</p>";
            echo "<p>Différences détectées :</p>";
            echo "<pre>" . print_r($diff, true) . "</pre>";
            echo "<p>Confirmez-vous ces modifications ?</p>";
            echo "<form action='db_owners_action.php?id_owners=" . $id_owners . "' method='post'>";
            echo "<input type='hidden' name='form_mode' value='modification'>";
            echo "<input type='hidden' name='modif_id' value='$modif_id'>";
            echo "<input type='hidden' name='confirm_update' value='1'>";
            echo "<input type='hidden' name='name' value='$name'>";
            echo "<input type='hidden' name='mail' value='$mail'>";
            echo "<input type='hidden' name='phone' value='$phone'>";
            echo "<input type='hidden' name='civility' value='$civility'>";
            echo "<input type='hidden' name='dob' value='$dob'>";
            echo "<input type='submit' class='btn btn-primary' value='Confirmer'>";
            echo "<a href='db_owners_list.php' class='btn btn-danger'>Annuler</a>";
            echo "</form>";
            exit();
        }

        // 4️⃣ Deuxième popup pour validation finale AVANT la mise à jour
        if (!$final_confirmation) {
            echo "<script>
                    if (confirm('Vérifiez bien : La modification est-elle conforme ?')) {
                        document.location.href='db_owners_action.php?id_owners=" . $id_owners . "&final_confirmation=1';
                    } else {
                        document.location.href='db_owners_list.php';
                    }
                  </script>";
            exit();
        }

        // 5️⃣ Exécution de la mise à jour
        $sql = "UPDATE owners SET name=?, mail=?, phone=?, civility=?, dob=? WHERE id_owners=?";
        $data = $pdo->prepare($sql);
        $data->execute([$name, $mail, $phone, $civility, $dob, $id_owners]);

        echo "<script>alert('Modification réussie !');</script>";
        break;

    case "ajout":
        // ✅ Vérification des champs obligatoires
        if (empty($name) || empty($mail)) {
            echo "<p class='alert alert-danger'>Erreur : Le nom et l'email sont obligatoires.</p>";
            exit();
        }

        // ✅ Récupérer l'ID max et l'incrémenter
        $sql = "SELECT MAX(id_owners) AS max_id FROM owners";
        $data = $pdo->query($sql);
        $row = $data->fetch(PDO::FETCH_ASSOC);
        $id_owners = $row['max_id'] + 1;

        // ✅ Ajout d'un nouveau propriétaire
        $sql = "INSERT INTO owners (id_owners, name, mail, phone, civility, dob) VALUES (?, ?, ?, ?, ?, ?)";
        $data = $pdo->prepare($sql);
        $data->execute([$id_owners, $name, $mail, $phone, $civility, $dob]);

        echo "<script>alert('Ajout réussi !');</script>";
        break;

    default:
        echo "<p class='alert alert-danger'>Erreur : Mode d'action inconnu.</p>";
        exit();
}

// ✅ Redirection après modification ou ajout
header('Location: db_owners_list.php');
exit();


*/


/*
// Imports
include_once '../serge_db_connect_inc.php';
session_start(); // Activation de la session pour suivre les modifications

// Vérification du mode (ajout ou modification)
$form_mode = isset($_POST['form_mode']) ? $_POST['form_mode'] : 'ajout';
$id_owners = isset($_GET['id_owners']) ? (int) $_GET['id_owners'] : null;
$modif_id = isset($_POST['modif_id']) ? $_POST['modif_id'] : null;

// Vérification des données
$name = isset($_POST['name']) ? htmlspecialchars($_POST['name']) : null;
$mail = isset($_POST['mail']) ? htmlspecialchars($_POST['mail']) : null;
$phone = isset($_POST['phone']) ? htmlspecialchars($_POST['phone']) : null;
$civility = isset($_POST['civility']) ? htmlspecialchars($_POST['civility']) : null;
$dob = isset($_POST['dob']) ? $_POST['dob'] : null;

// Vérification des champs obligatoires
if (empty($name) || empty($mail)) {
    echo "<p class='alert alert-danger'>Erreur : Le nom et l'email sont obligatoires.</p>";
    exit();
}

// Récupération de l'état AVANT modification
if ($form_mode === "modification") {
    $sql = "SELECT * FROM owners WHERE id_owners = ?";
    $data = $pdo->prepare($sql);
    $data->execute([$id_owners]);
    $old_owner = $data->fetch(PDO::FETCH_ASSOC);

    if (!$old_owner) {
        echo "<p class='alert alert-danger'>Erreur : Ce propriétaire n'existe pas.</p>";
        exit();
    }

    // Vérification que le `modif_id` est bien unique
    if ($_SESSION['modif_id'] === $modif_id) {
        echo "<p class='alert alert-warning'>Tentative de modification en double détectée.</p>";
        exit();
    }

    // Stocker `modif_id` en session pour empêcher les attaques
    $_SESSION['modif_id'] = $modif_id;

    // Comparaison AVANT / APRÈS modification
    $diff = array_diff_assoc(
        array_filter([
            "name" => $name,
            "mail" => $mail,
            "phone" => $phone,
            "civility" => $civility,
            "dob" => $dob
        ]),
        $old_owner
    );

    // Demande de confirmation à l'utilisateur
    if (!empty($diff)) {
        echo "<p class='alert alert-warning'>Attention : Les valeurs modifiées ne correspondent pas à la saisie !</p>";
        echo "<p>Différences détectées :</p>";
        echo "<pre>" . print_r($diff, true) . "</pre>";
        echo "<p>Confirmez-vous ces modifications ?</p>";
        echo "<form action='db_owners_action.php?id_owners=" . $id_owners . "' method='post'>";
        echo "<input type='hidden' name='modif_id' value='$modif_id'>";
        echo "<input type='hidden' name='confirm_update' value='1'>";
        echo "<input type='submit' class='btn btn-primary' value='Confirmer'>";
        echo "<a href='db_owners_list.php' class='btn btn-danger'>Annuler</a>";
        echo "</form>";
        exit();
    }
}

// Exécution de la modification en base de données
try {
    if ($form_mode === "modification") {
        // Mise à jour
        $sql = "UPDATE owners SET name=?, mail=?, phone=?, civility=?, dob=? WHERE id_owners=?";
        $data = $pdo->prepare($sql);
        $data->execute([$name, $mail, $phone, $civility, $dob, $id_owners]);

        echo "<script>alert('Modification réussie !');</script>";
    } else {
        // Ajout d'un nouveau propriétaire
        $sql = "INSERT INTO owners (name, mail, phone, civility, dob) VALUES (?, ?, ?, ?, ?)";
        $data = $pdo->prepare($sql);
        $data->execute([$name, $mail, $phone, $civility, $dob]);

        echo "<script>alert('Ajout réussi !');</script>";
    }

    // Redirection finale
    header('Location: db_owners_list.php');
    exit();
} catch (PDOException $err) {
    echo "<p class='alert alert-danger'>Erreur : " . $err->getMessage() . "</p>";
}
?>
*/



/*

// Imports et activation des sessions
include_once '../serge_db_connect_inc.php';
session_start();

// Initialisation des variables
$photo_path = null;
$id_owners = null;
$form_mode = $_POST['form_mode'] ?? 'ajout';

// Vérification de l'ID en mode modification
if (isset($_GET['id_owners']) && is_numeric($_GET['id_owners']) && $_GET['id_owners'] > 0) {
    $id_owners = (int) $_GET['id_owners'];
}

// Récupération et sécurisation des données du formulaire
$input_data = [
    "name" => $_POST['name'] ?? null,
    "mail" => $_POST['mail'] ?? null,
    "phone" => $_POST['phone'] ?? null,
    "civility" => $_POST['civility'] ?? null,
    "dob" => $_POST['dob'] ?? null,
];

// Gestion de l'upload de la photo
if (!empty($_FILES['photo']['name'])) {
    $uploads_dir = '../uploads/';
    $file_name = basename($_FILES['photo']['name']);
    $photo_path = $uploads_dir . $file_name;

    if (!move_uploaded_file($_FILES['photo']['tmp_name'], $photo_path)) {
        echo "<script>alert('Erreur lors de l'upload de la photo.'); window.history.back();</script>";
        exit();
    }
}

// SWITCH CASE pour séparer les actions
switch ($form_mode) {
    case "modification":
        // Récupération des anciennes données
        $sql = "SELECT * FROM owners WHERE id_owners = ?";
        $data = $pdo->prepare($sql);
        $data->execute([$id_owners]);
        $old_owner = $data->fetch(PDO::FETCH_ASSOC);

        if (!$old_owner) {
            echo "<script>alert('Erreur : Ce propriétaire n\'existe pas.'); window.location.href = 'db_owners_list.php';</script>";
            exit();
        }

        // Sauvegarde en session AVANT modification
        $_SESSION['modification_pending'] = [
            "id_owners" => $id_owners,
            "new_data" => array_merge($old_owner, array_filter($input_data)),
            "old_data" => $old_owner
        ];

        // Demander confirmation AVANT modification effective
        echo "<script>
            if (confirm('Une modification a été détectée. Confirmez-vous cette modification ?')) {
                window.location.href = 'db_owners_validate.php';
            } else {
                window.location.href = 'db_owners_list.php';
            }
        </script>";
        exit();

    case "ajout":
        // Récupérer l'ID max et l'incrémenter
        $sql = "SELECT MAX(id_owners) AS max_id FROM owners";
        $data = $pdo->query($sql);
        $row = $data->fetch(PDO::FETCH_ASSOC);
        $id_owners = $row['max_id'] + 1;

        // Insérer un nouvel enregistrement
        $sql = "INSERT INTO owners (id_owners, name, mail, phone, civility, dob, photo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $data = $pdo->prepare($sql);
        $data->execute([$id_owners, $input_data["name"], $input_data["mail"], $input_data["phone"], $input_data["civility"], $input_data["dob"], $photo_path]);

        echo "<script>alert('Propriétaire ajouté avec succès !'); window.location.href = 'db_owners_list.php';</script>";
        exit();

    default:
        echo "<script>alert('Erreur : Mode d\'action inconnu.'); window.location.href = 'db_owners_list.php';</script>";
        exit();
}

*/
?>
