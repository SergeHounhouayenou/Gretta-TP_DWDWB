<?php

// Moyenne de Marc
$moyenneMarc = (12 + 15 + 13 + 7 + 18) / 5 ;


// Moyenne de Mathieu
$moyenneMathieu = (11 + 14 + 10 + 4 + 20 + 8 + 2) / 7 ;


// Moyenne de Pierre
$moyennePierre = (5 + 13 + 9 + 3 ) / 4 ;


// Moyenne de Paul
$moyennePaul = (6 + 11 + 15 + 2) / 4 ;




// Tableau des moyennes
$tabMoyennes = array('Marc'=> $moyenneMarc, 'Mathieu'=> $moyenneMathieu, 'Pierre'=>$moyennePierre, 'Paul'=>$moyennePaul);
echo "La moyenne de l'élève 1 est de ".$tabMoyennes['Marc'];
echo "<br><br>";
echo "La moyenne de l'élève 2 est de ".$tabMoyennes['Mathieu'];
echo "<br><br>";
echo "La moyenne de l'élève 3 est de ".$tabMoyennes['Pierre'];
echo "<br><br>";
echo "La moyenne de l'élève 4 est de ".$tabMoyennes['Paul'];
?>
