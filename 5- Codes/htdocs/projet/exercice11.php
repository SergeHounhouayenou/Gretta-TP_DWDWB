<?php

$multitabMathieu[0] = array("Nom"=> "Mathieu", "Age"=> "30", "Sexe"=> "1");
$tabMathieu = $multitabMathieu[0];

$multitabMarie[0] = array("Nom"=> "Marie", "Age"=> "32", "Sexe"=> "");
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

$multitabMarc[0] = array("Nom"=> "Marc", "Age"=> "25", "Sexe"=> "1");
$tabMarc = $multitabMarc[0];

$multitabMathilde[0] = array("Nom"=> "Mathilde", "Age"=> "21", "Sexe"=> "");
$tabMathilde = $multitabMathilde[0];

printTable($tabMathieu);
echo "..............................";
printTable($tabMarie);
echo "..............................";
printTable($tabMarc);
echo "..............................";
printTable($tabMathilde);
echo "..............................";

?>


