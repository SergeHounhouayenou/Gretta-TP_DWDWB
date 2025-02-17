<?php

function averageNote($list)
{
    $divider = count($list);
    $dividend = array_sum($list) ;
    $result = $dividend / $divider ;
    return $result ;
}

$multitabMathieu = [];
$tabMathieu = array("Nom"=> "Mathieu", "Age"=> "30", "Sexe"=> "1");
$tabMathieuNote = array("Note 1"=> 2, "Note 2"=> 5, "Note 3"=> 15, "Note 4"=> 10,);
$averageNoteMathieu = "La moyenne est de : ".averageNote($tabMathieuNote);
array_push($multitabMathieu, $tabMathieu, $tabMathieuNote, $averageNoteMathieu);

$multitabMarie = [];
$tabMarie = array("Nom"=> "Marie", "Age"=> "32", "Sexe"=> "");
$tabMarieNote = array("Note 1"=> "10", "Note 2"=> "12", "Note 3"=> "11", "Note 4"=> "11");
$averageNoteMarie = "La moyenne est de : ".averageNote($tabMarieNote);
array_push($multitabMarie, $tabMarie, $tabMarieNote, $averageNoteMarie);

$multitabMarc = [];
$tabMarc = array("Nom"=> "Marc", "Age"=> "25", "Sexe"=> "1");
$tabMarcNote = array("Note 1"=> "15", "Note 2"=> "5", "Note 3"=> "20", "Note 4"=> "15");
$averageNoteMarc = "La moyenne est de : ".averageNote($tabMarcNote);
array_push($multitabMarc, $tabMarc, $tabMarcNote, $averageNoteMarc);

$multitabMathilde = [];
$tabMathilde = array("Nom"=> "Mathilde", "Age"=> "21", "Sexe"=> "");
$tabMathildeNote = array("Note 1"=> "3", "Note 2"=> "6", "Note 3"=> "9", "Note 4"=> "12",);
$averageNoteMathilde = "La moyenne est de : ".averageNote($tabMathildeNote);
array_push($multitabMathilde, $tabMathilde, $tabMathildeNote, $averageNoteMathilde);

function printTable($name, $note, $moyenne)
{
    echo "<br>"; echo "Nom : "    .$name["Nom"];
    echo "<br>"; echo "Age : "    .$name["Age"];
    echo "<br>"; echo "Sexe : "   .$name["Sexe"];
    echo "<br>"; echo "Note 1 : " .$note["Note 1"];
    echo "<br>"; echo "Note 2 : " .$note["Note 2"];
    echo "<br>"; echo "Note 3 : " .$note["Note 3"];
    echo "<br>"; echo "Note 4 : " .$note["Note 4"];
    echo "<br>"; echo $moyenne;    echo "<br>";
}

printTable($tabMathieu, $tabMathieuNote, $averageNoteMathieu);
echo "..............................";
printTable($tabMarie, $tabMarieNote, $averageNoteMarie);
echo "..............................";
printTable($tabMarc, $tabMarcNote, $averageNoteMarc);
echo "..............................";
printTable($tabMathilde, $tabMathildeNote, $averageNoteMathilde);
echo "<br>";


?>


