<?php

// Imports
include_once 'serge_constants_inc.php';
include_once 'serge_db_connect_inc.php'; // Connexion à PDO
?>
<!DOCTYPE html>
<html lang="fr">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>ASTON MARTIN</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" 
  integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
  <link rel="stylesheet" href="css/main.css">

</head>

<body class="container">

  <nav class="navbar navbar-dark bg-dark">
    <!-- Navbar content -->
  </nav>
 
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">Accueil</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
      <div class="navbar-nav">
        <a class="nav-item nav-link" href="db_cars_list.php" style="display:<?php echo ($connected ? '' : 'none') ?>">Liste des voitures</a>
        <a class="nav-item nav-link" href="php_liste_proprietaire/db_owners_list.php" style="display:<?php echo ($connected ? '' : 'none') ?>">Liste des propriétaires</a>
        <a class="nav-item nav-link" href="db_resa.php" style="display:<?php echo ($connected ? 'none' : '') ?>">Réservation</a>
        <a class="nav-item nav-link" href="fullcalendar.php" style="display:<?php echo ($connected ? 'none' : '') ?>">Agenda</a>
      </div>
    </div>
  </nav>
  <div class="jumbotron mt-4 cover">
    <h1 class="display-4">Aston Martin mythiques des James Bond</h1>

    <p class="lead">Accédez à votre part de rêve au volant d'une voiture de prestige…</p>
    <hr class="my-4">
    <a href="login.php" class="btn btn-info ml-3" style="display:<?php echo ($connected ? 'none' : '') ?>">Se connecter</a>
    <a href="register.php" class="btn btn-light" style="display:<?php echo ($connected ? 'none' : '') ?>">S'inscrire</a>
    <a href="logout.php" class="btn btn-success" style="display:<?php echo ($connected ? '' : 'none') ?>">Se déconnecter</a>
  </div>

  <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators">
      <li data-target="" data-slide-to="0" class="active"></li>
      <li data-target="" data-slide-to="1"></li>
      <li data-target="" data-slide-to="2"></li>
      <li data-target="" data-slide-to="3"></li>
      <li data-target="" data-slide-to="4"></li>
      <li data-target="" data-slide-to="5"></li>
    </ol>

    <div class="carousel-inner">
      <div class="carousel-item active">
        <img src="pics/db5.jpg" class="d-block w-100" alt="db5">
      </div>
      <div class="carousel-item">
        <img src="pics/dbs.jpg" class="d-block w-100" alt="dbs">
      </div>
      <div class="carousel-item">
        <img src="pics/v8vantage.jpg" class="d-block w-100" alt="V8nvantage">
      </div>
      <div class="carousel-item">
        <img src="pics/v12vanquish.jpg" class="d-block w-100" alt="V12nvanquish">
      </div>
      <div class="carousel-item">
        <img src="pics/db9.jpg" class="d-block w-100" alt="Db9">
      </div>
      <div class="carousel-item">
        <img src="pics/db10.jpg" class="d-block w-100" alt="Db10">
      </div>
    </div>
    <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="sr-only">Next</span>
    </a>
  </div>
  <br>
  <br>
  <br>
  <h1>Liste des voitures</h1>
  <p>
    <?php
    // Exécute la requête
    $sql = 'SELECT *  FROM cars';
    $data = $pdo->query($sql);
    $html = '<div class="row">';
    foreach ($data as $row) {
      $html .= '<div class="card m-3" style="width: 20rem;">
      <img style="height: 12rem;" src="'.$row['photo'].'" class="card-img-top" alt="photo">
      <div class="card-body">
        <h5 class="card-title"> '.$row['model'].' </h5>
        <p class="card-text"> '.$row['name'].'</p>
        <p class="card-text"> '.$row['dob'].'</p>
      </div>
    </div>';
       
    }
    $html.= '</div>';
    echo $html;
    ?>
  </p>
  <br>
  <br>
  <h2>Liste des propriétaires</h2>
  <br>
  <p>
    <?php
    // Exécute la requête
    $sql = 'SELECT *  FROM owners';
    $data = $pdo->query($sql);
    $html = '<div class="row">';
    foreach ($data as $row) {
      $html .= '<div class="card m-3" style="width: 20rem;">
      <img style="height: 12rem;" src="'.$row['photo'].'" class="card-img-top" alt="photo">
      <div class="card-body">
        <h5 class="card-title"> '.$row['name'].' </h5>
        <p class="card-text"> '.$row['mail'].'</p>
        <p class="card-text"> '.$row['phone'].'</p>
      </div>
    </div>';
       
    }
    $html.= '</div>';
    echo $html;
    ?>
  </p>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</body>
<br>
<br>
<!-- Footer -->
<footer class="page-footer font-small blue">

  <!-- Copyright -->
  <div class="footer-copyright text-center py-3">© 2025 Copyright: FAIT A L'ARRACHE POUR MES PIU PIU LGC
  </div>
  <!-- Copyright -->

</footer>
<!-- Footer -->

</html>