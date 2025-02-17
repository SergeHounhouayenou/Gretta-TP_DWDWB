<?php
// Classe Commande
class Commande {
    public $prix = [
        "Americano" => 8, 
        "Buffalo" => 9
    ];
    public $client = [
        "nom" => "", 
        "commande" => [], 
        "prix_total" => 0
    ];
    
    public function ajouterCommande($selection) {
        if (array_key_exists($selection, $this->prix)) {
            $this->client["commande"][] = $selection;
            $this->client["prix_total"] += $this->prix[$selection];
        }
    }

    public function afficherCommande() {
        echo "<h2>Récapitulatif de votre commande</h2>";
        if (!empty($this->client["commande"])) {
            echo "<ul>";
            foreach ($this->client["commande"] as $item) {
                echo "<li>$item - {$this->prix[$item]}€</li>";
            }
            echo "</ul>";
            echo "<p><strong>Total :</strong> {$this->client["prix_total"]}€</p>";
        } else {
            echo "<p>Aucune commande passée.</p>";
        }
    }
}

// Instanciation de la classe Commande
$commande1 = new Commande();

// Vérification de la soumission du formulaire
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["kebab"])) {
    $commande1->ajouterCommande($_POST["kebab"]);
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Commande de Kebab</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        .container { max-width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        button { padding: 10px; margin: 5px; cursor: pointer; }
    </style>
</head>
<body>

<div class="container">
    <h1>Commandez votre Kebab</h1>
    <form id="commandeForm" method="post">
        <button type="button" onclick="ajouterKebab('Americano')">Ajouter Americano (8€)</button>
        <button type="button" onclick="ajouterKebab('Buffalo')">Ajouter Buffalo (9€)</button>
        <input type="hidden" name="kebab" id="kebabInput">
        <br><br>
        <button type="submit">Valider la commande</button>
    </form>
</div>

<div class="container">
    <?php $commande1->afficherCommande(); ?>
</div>

<script>
    function ajouterKebab(nomKebab) {
        document.getElementById("kebabInput").value = nomKebab;
        document.getElementById("commandeForm").submit();
    }
</script>

</body>
</html>
