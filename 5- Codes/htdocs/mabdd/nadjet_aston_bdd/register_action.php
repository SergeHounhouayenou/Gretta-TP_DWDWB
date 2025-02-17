<?php
// Imports
// Se connecter à la BDD
include_once 'serge_db_connect_inc.php';
include_once 'serge_functions_inc.php';

// Verifier que l'adresse mail est nouvelle (pas de doublon)
$sql = 'SELECT COUNT(*) AS Nb FROM customers WHERE mail = ?';
$params = array($_POST['mail']);
$data = $pdo->prepare($sql);
$data->execute($params);
$row = $data->fetch();

if((int) $row['Nb'] === 0){
	// Insérer les données dans la table customers
	$sql = 'INSERT INTO customers(name, mail, dob, gender, pass) VALUES(:name, :mail, :dob, :gender, :pass)';
	//Préparer la requête 
	$data =$pdo->prepare($sql);
	// Solution 2 avec ARRAY
	$pass = get_password(); //'basique'; 
	$pass= 'secret'; // a commenter quand les mails fonctionneront
	$hash = sha1(md5($pass).sha1($_POST['mail']));
	$params = array(
		':name' => htmlspecialchars($_POST['name']),
		':mail' => htmlspecialchars($_POST['mail']),
		':dob' => htmlspecialchars($_POST['dob']),
		':gender' => htmlspecialchars($_POST['gender']),
		':pass' => $hash
	);
	$data->execute($params);
	
	
	// Envoyer un mail de confirmation d'inscription

	$html = '<p>Bienvenue ' .$_POST['name'].',';
	$html .= '<p>Nous vous confirmons votre inscription, vous pouvez désormais vous connecter en tant que membre';
	$html .= '<ul>';
	$html .= '<li> Identifiant:' .$_POST['mail'];
	$html .= '<li> Mot de passe:' .$pass;
	$html .= '</ul>';
	$html .= '<p> A très vite!';

	//Header du mail: TRES IMPORTANT

	$header = "MIME-Version: 1.0 \n"; // Version MIME
	$header .= "Content-type: text/html, charset=utf8 \n"; // Format du mail
	$header .= "From: mllereina92@gmail.com \n"; //Expéditeur
	$header .= "Reply to: nanou9808@gmail.com \n";
	$header .= "Disposition-Notification-To: jamesbond@samajeste.com \n"; // Accusé de reception
	$header .= "X-Priority: 1\n";
	$header .= "X-MSMailPriority: High \n";

	// Envoi du mail
	mail($_POST['mail'], 'Confirmation inscription', $html, $header);

	// Renvoie vers INDEX
	header('location: index.php');

}else{
	echo 'L\'adresse mail existe déjà dans la base de données !';
}
?>
