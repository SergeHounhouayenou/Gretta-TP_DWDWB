<?php

// Je veux être capable de sélectionner des données préidentifiées dans mes historiques
// et de les utiliser comme étant l'instraction à mettre à jour
$sql = "SELECT old_data FROM owners_history WHERE id_history = ?";
$data = $pdo->prepare($sql);
$data->execute([$id_history]);
$history = json_decode($data->fetchColumn(), true);

$sql = "UPDATE owners SET name=?, mail=?, phone=?, civility=?, dob=? WHERE id_owners=?";
$data = $pdo->prepare($sql);
$data->execute([$history['name'], $history['mail'], $history['phone'], $history['civility'], $history['dob'], $history['id_owners']]);


?>