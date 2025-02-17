<?php

/**
 * Génère un mot de passe aléatoire basé sur un dico de caractères
 * @param {int} $len - taille en caractères du mot de passe
 * @return {string} mot de passe généré
 */

function get_password($len = 8): string
{
    $dico = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_&@$*';
    $pass = str_shuffle($dico);
    $pass = substr($pass, 0, $len);
    return $pass;
}
/**
 * Renvoie un SELECT et ses OPTIONS via le tableau passé en paramètre
 * @param {array} $array - Tableau de valeurs à transformer en SELECT
 * @param {string} $id - ID et NAME du SELECT
 * @return {string} code HTML du SELECT

 */

function create_select ($array, $id='', $val='') : string {
    $html = '<select class="form-control" value="'.$val.'" id="'.$id.'" name="'.$id.'">';
    $html.='<option value="">--- choisir une valeur ---</option>'; 
    foreach ($array as $row ) {
    $html .= '<option value="'.$row[0].'" '.($row[0]==$val?'selected':'').'>'.$row[1].'</option>';
    }
    $html .= '</select>';
    return $html;
}
?>
