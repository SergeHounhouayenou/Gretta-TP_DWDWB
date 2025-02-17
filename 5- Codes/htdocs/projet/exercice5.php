<?php

  $month = rand(1, 12);
  switch($month)
    {
    case $month < 2 :
        echo "le mois 1 en chiffre correspond au mois Janvier en lettre"."<br>";
        break;
    case $month < 3 :
        echo "le mois 2 en chiffre correspond au mois Février en lettre"."<br>";
        break;
    case $month < 4 :
        echo "le mois 3 en chiffre correspond au mois Mars en lettre"."<br>";
        break;
    case $month < 5 :
        echo "le mois 4 en chiffre correspond au mois Avril en lettre"."<br>";
        break;
    case $month < 6 :
        echo "le mois 5 en chiffre correspond au mois Mai en lettre"."<br>";
        break;
    case $month < 7 :
        echo "le mois 6 en chiffre correspond au mois Juin en lettre"."<br>";
        break;
    case $month < 8 :
        echo "le mois 7 en chiffre correspond au mois Juillet en lettre"."<br>";
        break;
    case $month < 9 :
        echo "le mois 8 en chiffre correspond au mois Aôut en lettre"."<br>";
        break;
    case $month < 10 :
        echo "le mois 9 en chiffre correspond au mois Septembre en lettre"."<br>";
        break;
    case $month < 11 :
        echo "le mois 10 en chiffre correspond au mois Octobre en lettre"."<br>";
        break;
    case $month < 12 :
        echo "le mois 11 en chiffre correspond au mois Novembre en lettre"."<br>";
        break;
    case $month = 12 :
        echo "le mois 12 en chiffre correspond au mois Décembre en lettre"."<br>";
        break;    
    }
var_dump($month);
  
?>