<?php
// récupérer un résultat composite de valeurs dans une variable 
// en convertissant certains éléments pour homogénéiser les types ;
$nombre1 = 1.5 ;    // type float
$nombre2 = 12 ;     // type int
$chaine1 = "10" ;   // type string
$chaine2 = 'salut'; // type string
// $total = string
$total = ($nombre1 + $nombre2 + intval($chaine1) ) . ' ' . $chaine2 ;
echo "$total <br><br>" ; 

// Même procédé en sans variable de récupération intermédiaire 
$nom = "Hounhouayenou" ;
$prenom = "Serge" ;
$age = 50 ;
$ville = "Asnières" ;
echo "bonjour, je m'appelle {$nom} {$prenom}, j'ai {$age} ans et j'habite à {$ville}";

// Les opérateurs de comparaison
// $a <=> $b Return "0" si les deux valeurs sont égales ; "-1" si le côté gauche est inférieur ; "1" si le côté gauche est supérieur
$test = 0 ;
$test1 = 4 ;
$test3 = 2 ;
$test = $test1 <=> $test3 ;
echo "<br><br>$test, $test1, $test3 <br><br>"; 
var_dump ("<br><br>$test, $test1, $test3");


// Forme simplifiée du switch case
$sexe = "";
switch ($sexe) {
    case "M":
        echo "Monsieurs";
        break;
    case "F":
        echo "madamme";
        break;
    case "":
        echo "<br><br>N'oubliez pas de renseigner votre sexe <br><br>";
        break;
} 

$budget = 1234.56 ;
$achat = 1357.99 ; 
switch ($achat) {
    case $budget >= $achat :
        echo "on peut acheter<br><br>";
        break;
    case $budget < $achat :
        echo "on ne peut pas acheter<br><br>";
        break;
} 

$heure = $heure = (integer) date ('G');
switch ($heure) {
    case $heure >= 12 :
        echo "c'est l'après-midi<br><br>";
        break;
    case $heure <= 19 :
        echo "c'est l'après-midi<br><br>";
        break;
    case $heure > 19 :
        echo "c'est le matin<br><br>";
        break;
} 
var_dump($heure);


// Enumérer un code postal
$stock = [];
$stock1 = [];
$codePostal = (integer)[];
$i = 7000;
while ($i<80000)
{
echo $codePostal = $i.""; $i++;  
}


// Ma table de multiplication par 5
echo "<br><br>";
$table5 = (integer)[];
for ($i = 0; $i <= 10; $i++)
{
echo ($i * 5)." ";
}
echo "<br><br>";

// Ma pyramide à 5 niveaux
// --> les boucles imbriquées créent pour l'opération sujette une indexation itérative comparable à celle des tableaux multidimentionnels.
function exo3(){
    for ($i = 1; $i <= 5; $i++) {
        for ($j = 1; $j <= $i; $j++) {
        echo $i;
        }
        echo "<br>"; 
      }   
}
exo3();
echo "<br><br>";


// Parcourir mes tableaux
$personnes = array('Ryan'=>16, 'Lulu'=>19, 'Sacha'=>66);
var_dump($personnes["Lulu"]);
echo "<br><br>";

$cocktails = array('Mojito', 'Long Island Iced tea', 'Gin Fizz', 'Moscow mule');
var_dump($cocktails[1]) ;
echo "<br><br>";
var_dump(count($cocktails));
echo "<br><br>";
// Déclarer mes tableaux à partir d'une fonction
function Cocktails($monIdex) 
{
    $tab = array('Mojito', 'Long Island Iced tea', 'Gin Fizz', 'Moscow mule');
    return $tab[$monIdex] ;
}
$Cocktail = [];
$Cocktails = Cocktails(0);

var_dump($Cocktails) ;
echo "<br><br>";
array_push($Cocktail, $Cocktails);
echo "un composant, une responsabilité" ;
var_dump($Cocktail) ;
// Ajouter un élément à la fin d'un tableau
array_push($cocktails, "un ajout", "un second ajout"); print_r($cocktails) ;


// extraire la dernière info d'un tableau
// array_pop


// placer un plusieurs éléments au début d'un tableau
//array_unshift


// extraire la première valeur d'un tableau et la retourner
//array shift



// sort :--> trier un tableau dans l'ordre ascendant numérique ou alphabétique par défaut

// rsort :--> trier un tableau dans l'ordre décroissant 

// asort :--> trie un tableau dans l'ordre ascendant et conserve l'association des index

// arsort :--> trie un tableau dans l'ordre descendant et conserve l'association des indexe

// ksort :--> trie un tableau dans l'ordre ascendant suivant les clés

// krsort :--> trie un tableau dans l'ordre descendant suivant les clés



//// Les FUSIONS /////

// implode(",",$myTable) --> je précise mon caractère de séparation pour les éléments puis je renseigne la table 
// Convertir un tableau en chaîne de caractère 

// explode(" ", $myVariable) ; je renseigne le caractère à partir duquel faire la séparation puis renseigner la variable
                                // dans cet exemple je mets un espace vide entre guillemets pour préciser 
                                // que c'est l'espace entre les valeurs qui est le caratère de séparation  
// découper une chaîne de caractère en tableau



$myrandTable = [];
$table1 = [];
$table2 = [];
for ($i=1 ; $i <=10 ; $i++)
    { 
      array_push($myrandTable, rand(0, 100) );  
      
    }
echo "<br><br>";
var_dump($myrandTable) ;

/*
foreach ($myrandTable as $val => $table1) 
{
    if($val < 50)
    {array_push($table1, $myrandTable);} ;
}
var_dump("<br><br> voici ma table 1 :", $table1) ;


Toihir — Remplir un tableau avec des données hasardeuses
$random = [];
$array_inf = [];
$array_sup = [];

for($i= 0; $i < 10; $i++){
  array_push($random,rand(0, 100));
  if ($random[$i] < 50){
    array_push($array_inf, $random[$i]);
  }else{
    array_push($array_sup, $random[$i]);
  }
}
var_dump($array_inf);
var_dump($array_sup);

*/


function calcTva($prixHt, $tva)
{
$tauxTva = $tva / 100; 
$montantTva = $prixHt * $tauxTva;
$prixTtc = $prixHt + $montantTva;
echo "<br><br>exercice de calcul de la TVA avec une fonction<br><br>";
return $prixTtc;
}

(float)$tva = 20;
(float)$prixHt = 12;
var_dump(calcTva($prixHt, $tva));
echo "<br><br>";


/*

$x = [];
$y = [];
$result = [];
$z = [ [$x], [$y] ];
function multiplicationTable($nbr)
{
$x[0] = []; $y[0] = 1; $z = [] ;
for ($i=1; $i <= $nbr ; $i++)
    {
    $x[];
    for ($i=1; $i <= $nbr ; $i++)
        {
       
        }
    }

}
$nbr = 10 ;
var_dump(multiplicationTable($nbr)) ;


*/

// Ruslan — Aujourd’hui à 10:28
// Ex 2
function tab($nb) {
    $tab=[] ;
    for ($i=1;$i<=$nb; $i++) 
    {
        $ligne=[] ;
        for ($j=1;$j<=$nb; $j++) {
            array_push($ligne, $i*$j) ;
        }
        array_push($tab, $ligne) ;
    }
    foreach ($tab as $l) {
        echo implode(" ", $l) . PHP_EOL; 
    }
}
tab(10); 


/*
function aff2($nb = 10){
    $multipli = [];
    for ($i=1; $i <= $nb ; $i++) { 
        $multipli[] = $i;
    }
    var_dump($multipli);
    foreach ($multipli as $multi) {
        for ($i = 1; $i <= $nb; $i++){
            $result = $multi * $i;
            echo "$result ";

        }
        echo "\n";
    }
}

aff2();
aff2(25);
*/


/*
//Boucle de construction et de remise à zéro
for ($i = 0; $i < 6;$i++)
{
for ($g = 0; $g < 7;$g++)
{
$tableau[$i][$g] = "Vide";
}
}
//Boucle d'affichage
for ($i = 0; $i < 6;$i++)
{
for ($g = 0; $g < 7;$g++)
{
echo $tableau[$i][$g];
}
}
*/


/*
function average(array|float ...$num): float
{
    $sum = 0;
    $nb = 0;
    $args = func_get_args();
    foreach ($args as $arg) {
        if (is_array($arg)) {
            $sum += array_sum($arg); // $sum = $sum + array_sum($arg);
            $nb += count($arg);
        } else {
            $sum += $arg;
            $nb++;
        }
    }
    return $sum / $nb;
}

// echo average(1, 2.5, 3, 4.123, 5, 6.528, "3.14159", 'Milou');
echo average(1, 2, 3, 6) . "\n";
echo average(1, 2.5, 3, 4.123, 5, 6.528, "3.14159") . "\n";
echo average(array(1, 2, 3, 6), 3, 10, 45, 127, array(12, 10, 14)) . "\n";
*/

$list = [12, 25, 26];
function AvarageDivider($list)
{
   $avrDivValue = func_num_args() ;
   echo "<br><br>";
   var_dump($avrDivValue) ;
   return  $avrDivValue ;
}
$divider = AvarageDivider($a, $b, $c);
var_dump($divider); 
$result = array_sum($list) / $divider;
var_dump($result); 


$list1 = [42, 25, 26];




// phpinfo();
?>

