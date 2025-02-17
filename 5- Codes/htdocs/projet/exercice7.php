<?php
 
function essai()
{
   (int) $Essais = 1 ;
    (int) $Essai = $Essais;
   $nombre = rand(1, 20);
   switch($nombre)
    {
    case $nombre < 15 :
        echo "Essai ".$Essai. " : ".$nombre." est trop petit (<15)"."<br>";
        $Essais++;
        essai(); return $Essais;
        break;
    
    case $nombre >= 15 :
        echo "Le chiffre choisi est : ".$nombre."<br>";
        break;
    }   
}
essai();
?>


    