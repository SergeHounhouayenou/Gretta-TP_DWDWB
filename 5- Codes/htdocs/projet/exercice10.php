<?php

$multitabMathieu[0] = array("Nom"=> "Mathieu", "Age"=> "30", "Sexe"=> "1");
$tabMathieu = $multitabMathieu[0];

$multitabMarie[0] = array("Nom"=> "Marie", "Age"=> "30", "Sexe"=> "");
$tabMarie = $multitabMarie[0];


function printTable($name)
{
    echo "<br>";
    echo "Nom : ".$name["Nom"];
    echo "<br>";
    echo "Age : ".$name["Age"];
    echo "<br>";
    echo "Sexe : ".$name["Sexe"];
    echo "<br>";
}
printTable($tabMathieu);
echo "..............................";
printTable($tabMarie);


?>


