<?php

function averageAge($list)
{
    foreach ($list as $tab)
    {
       foreach ($tab as $tab1 => $value1)
       {
        echo "<br>"; 
        echo $tab1." :"." ".$value1 ; 
       }
       echo "<br>"; 
       echo "...................................";
       
    } 
    echo "<br>"; 
    echo "<br>"; 
   
   // $result = $dividend / $divider ;
   
}

$multitabAnimauxCol1 = [];
$multitabAnimauxCol2 = [];
$multitabAnimauxCol3 = [];
$tabMina = array("Nom"=> "Mina", "Age"=> "2", "Type"=> "chien");
$tabTya = array("Nom"=> "Tya", "Age"=> "7", "Type"=> "chat");
$tabMilo = array("Nom"=> "Milo", "Age"=> "4", "Type"=> "chat");
$tabHocket = array("Nom"=> "Hocket", "Age"=> "6", "Type"=> "chien");
array_push($multitabAnimauxCol1, $tabMina, $tabTya, $tabMilo, $tabHocket);
array_push($multitabAnimauxCol2, $tabMina, $tabHocket);
array_push($multitabAnimauxCol3, $tabTya, $tabMilo);
$prinTableAnimauxCol1 = averageAge($multitabAnimauxCol1);
$prinTableAnimauxCol2 = averageAge($multitabAnimauxCol2);
$prinTableAnimauxCol3 = averageAge($multitabAnimauxCol3);
// $averageAgeAnimaux = "La moyenne d'âge des animaux est de : ".averageAge($multitabAnimaux);

echo "<br>"; echo "Nom : "    .$multitabAnimauxCol1[0]["Nom"];echo "<br>"; 

    foreach ($multitabAnimauxCol1 as $tableau => $value)
    {
        $age = [];
        $age = $value["Age"];
        echo "<br>";
        echo(" ");
        echo(" Je récupère la valeur âge de chaque enregistrement : ");
        echo $age ;
        echo(" ");
        $age = $value["Age"];
        $newtableAge = [];
        array_push($newtableAge, $age);
        echo "<br>";
        print_r($newtableAge);
    }
    echo "<br>"; echo "<br>";
    print_r(array_sum($newtableAge)) ;
    
   

?>


