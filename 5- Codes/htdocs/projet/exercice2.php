<?php

function table1($nombre = 10){
    $Table1 = [];
    for ($i=1; $i <= $nombre ; $i++) { 
        $Table1[] = $i;
    }
    foreach ($Table1 as $Table2) {
        for ($i = 1; $i <= $nombre; $i++){
            $result = $Table2 * $i;
            echo "$result ";
        }
        echo "<br>";
    }
}
table1();


?>