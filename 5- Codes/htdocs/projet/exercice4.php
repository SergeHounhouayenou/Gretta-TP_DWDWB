<?php

function table1($nombre)
{
    $numberStock = rand(1, 100);
    $Table1 = [];
    for ($i=1; $i <= $nombre ; $i++) 
    { 
        $Table1[] = $i * $numberStock;
    }
    foreach ($Table1 as $Table2) 
    {
        $result = $Table2 * 8;
        echo "<br>";
        echo "$result";
    }
        echo "<br>";
}
table1(20);

?>