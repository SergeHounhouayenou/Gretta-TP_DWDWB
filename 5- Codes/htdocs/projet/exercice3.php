<?php

  $numberStock = rand(1, 20);
  switch($numberStock)
 {
    case $numberStock <= 5 :
        echo "Il est compris entre 1 et 5";
        break;
    case $numberStock >5 && $numberStock <= 10 :
        echo "Il est compris entre 6 et 10";
        break;
    case $numberStock >10 && $numberStock <= 15 :
        echo "Il est compris entre 11 et 15";
        break;
    case $numberStock >15 :
        echo "Il est compris entre 16 et 20";
        break;
} 
var_dump($numberStock);
  
?>