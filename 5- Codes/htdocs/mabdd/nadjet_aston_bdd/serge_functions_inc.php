<?php

function get_password($len = 8, $custom_dico = ''): string {
    $default_dico = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_&@$*';
    $dico = !empty($custom_dico) ? $custom_dico : $default_dico;
    $dico_length = strlen($dico);
    
    if ($dico_length < 2) {
        throw new Exception("Le dictionnaire de caractères est trop court.");
    }

    $pass = '';
    for ($i = 0; $i < $len; $i++) {
        $pass .= $dico[random_int(0, $dico_length - 1)];
    }

    return $pass;
}

function create_select(array $array, string $id='', string $val=''): string {
    if (empty($array)) {
        return '<select class="form-control" id="'.htmlspecialchars($id).'" name="'.htmlspecialchars($id).'">
                    <option value="">Aucune donnée disponible</option>
                </select>';
    }

    $html = '<select class="form-control" id="'.htmlspecialchars($id).'" name="'.htmlspecialchars($id).'">';
    $html .= '<option value="">--- choisir une valeur ---</option>'; 

    foreach ($array as $row) {
        $value = htmlspecialchars($row[0]);
        $text = htmlspecialchars($row[1]);
        $selected = ($row[0] == $val) ? 'selected' : '';
        $html .= "<option value=\"$value\" $selected>$text</option>";
    }

    $html .= '</select>';
    return $html;
}


/* OLD VERSION ------- STRART-------------



 // Génère un mot de passe aléatoire basé sur un dico de caractères
 // @param {int} $len - taille en caractères du mot de passe
 // @return {string} mot de passe généré
 

function get_password($len = 8): string
{
    $dico = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_&@$*';
    $pass = str_shuffle($dico);
    $pass = substr($pass, 0, $len);
    return $pass;
}

 // Renvoie un SELECT et ses OPTIONS via le tableau passé en paramètre
 // @param {array} $array - Tableau de valeurs à transformer en SELECT
 // @param {string} $id - ID et NAME du SELECT
 // @return {string} code HTML du SELECT



function create_select ($array, $id='', $val='') : string {
    $html = '<select class="form-control" value="'.$val.'" id="'.$id.'" name="'.$id.'">';
    $html.='<option value="">--- choisir une valeur ---</option>'; 
    foreach ($array as $row ) {
    $html .= '<option value="'.$row[0].'" '.($row[0]==$val?'selected':'').'>'.$row[1].'</option>';
    }
    $html .= '</select>';
    return $html;
}

OLD VERSION ------- STRART-------------

*/  

?>
