<?php
//MOI

class Commande
{
    private $prix = 
    [
        "Americano" => 8,
        "Buffalo" => 9
    ];

    private $client = 
    [
        "Name" => "",
        "commande" => [],
        "Prix Total" => 0
    ];

    private $listKebabs = 
    [
        "Americano", "Buffalo"
    ];

    // Définir le nom du client
    public function setClientName($name)
    {
        $this->client["Name"] = $name;
    }

    // Ajouter un kébab à la commande
    public function addKebab($selection)
    {
        if (in_array($selection, $this->listKebabs)) 
        {
            $this->client["commande"][] = $selection;
            $this->client["Prix Total"] += $this->prix[$selection];
        } 
        else 
        {
            echo "Erreur : Ce kébab n'existe pas.\n";
        }
    }

    // Afficher la commande finale
    public function afficherCommande()
    {
        echo "Client : " . $this->client["Name"] . "\n";
        echo "Commande : " . implode(", ", $this->client["commande"]) . "\n";
        echo "Prix Total : " . $this->client["Prix Total"] . "€\n";
    }
}

// === TEST === //
$commande1 = new Commande(); // les parenthèses servent à appeller automatiquement un éventuel constructeur. Elles sont facultatives si il n'y a pas de constructeur dans la classe.
$commande1->setClientName("Serge Hounhouayenou");
$commande1->addKebab("Americano");
$commande1->addKebab("Buffalo");
$commande1->afficherCommande();


/*

// Explication des parenthèses après la déclaration de la classe
// Exemple sans constructeur 
class Commande
{
    public $client;
}

$commande1 = new Commande(); // Instanciation
$commande1->client = "Jean Dupont"; 
echo $commande1->client; // Affiche "Jean Dupont"


// Exemple avec constructeur
class Commande
{
    public $client;

    public function __construct($name)
    {
        $this->client = $name;
    }
}

$commande1 = new Commande("Jean Dupont"); // Appelle automatiquement __construct()
echo $commande1->client; // Affiche "Jean Dupont"


*/











/*
class commande
{
    public $prix = array("Americano" => 8, "Buffalo" => 9 );

    public $client = array("Name" => "", "commande" => $customerChoice, "Prix Total" => "" );
    
    public $listKebabs = array("Americano", "Buffalo");

    public function isChoosing($client, $selection)
        {
        $Choice = [];   
        if ($selection != 0)
            {
            array_push($customerChoice, $selection);
            return $Choice;
            }
        public function addKebab() 
            {
            echo 
            "
            <form id=\"selectionKebab\" action=\"exoSuperGlobal1.php\" method=\"post\" class=\"\">
            <div>
            <label for=\"client\"> Choississez votre Kébab : </label>
            <button class=\"selectionKebab1\" type=\"button\">Add 'Americano'</button>
            <button class=\"selectionKebab2\" type=\"button\">Add 'Buffalo'</button>
            </div>
            </form>
            ";
            
            } 
        
        public function removeKebab() 
            {
            ;
            } 
    
        public function calculerPrix() 
            {
            ;
            } 
    
        public function afficherCommande() 
            {
            ;
            } 

        }
    
    public function CustomerOrder($client, $customerChoice)
        {
        $client = $this-> array["Name"];
        isChoosing();
        $customerList = []; 
        $customerChoice = isChoosing();
        array_push($customerList, $customerChoice);
        return $customerList;
        }

    public function accueil() 
        {
        echo "Bonjour, qu'est-ce qu'on peut vous servir ? ";
        } 

}

echo get_class($commande);

*/



/* Corection Najet

prixAmericain: Prix du kebab américain
prixBuffalo: Prix du kebab buffalo
nomClient: Nom du client
listeKebabs: Liste des kebabs commandés

Méthodes:

addKebab(): Ajoute un kebab à la commande.
removeKebab(): Supprime un kebab de la commande.
calculerPrix(): Calcule le prix total de la commande.
afficherCommande(): Affiche les détails de la commande.

*/

/*
class Kebab {
    public $type;
    public $price;

    public function construct($type, $price) {
        $this->type = $type;
        $this->price = $price;
    }
}

class Commande {
    public $nomClient;
    public $listeKebabs = [];

    public function construct($nomClient) {
        $this->nomClient = $nomClient;
    }

    public function addKebab(Kebab $kebab) {
        $this->listeKebabs[] = $kebab;
    }

    public function removeKebab($index) {
        if (isset($this->listeKebabs[$index])) {
            unset($this->listeKebabs[$index]);
        }
    }

    public function calculerPrix() {
        $total = 0;
        foreach ($this->listeKebabs as $kebab) {
            $total += $kebab->price;
        }
        return $total;
    }

    public function afficherCommande() {
        echo "Commande pour {$this->nomClient}:\n";
        foreach ($this->listeKebabs as $kebab) {
            echo "- {$kebab->type} ({$kebab->price}€)\n";
        }
        echo "Total: {$this->calculerPrix()}€\n";
    }
}

// Création des types de kebab
$kebabAmericain = new Kebab("Américain", 5.5);
$kebabBuffalo = new Kebab("Buffalo", 6.0);

// Création d'une commande
$commande1 = new Commande("John Doe");

// Ajout de kebabs à la commande
$commande1->addKebab($kebabAmericain);
$commande1->addKebab($kebabBuffalo);
$commande1->addKebab($kebabAmericain);

// Affichage de la commande
$commande1->afficherCommande();

*/

?>