
-- 1. Obtenir les titres des films et les prénoms des acteurs ayant joué dans ces films

SELECT f.title AS film_title, 
		a.last_name AS actor_last_name
FROM film f
INNER JOIN actor a ON a.actor_id = f.film_id ;

--  Lister les films et leurs langues_id de langue. Même si aucune langue n'est définie. 

SELECT f.title AS film_titre, 
		l.name AS langues_id
FROM film f
INNER JOIN language l ON l.language_id = f.film_id ;

--  3

SELECT p.NOM_PRODUIT AS Nom_Produit, 
		f.SOCIETE AS Raison_Social_Fournisseur, 
        c.categories AS Nom_categorie,
        p.QUANTITE AS quantite
FROM produits p
INNER JOIN fournisseur f ON p.NOM_PRODUIT_id = f.SOCIETE_id
INNER JOIN categories c ON p.NOM_PRODUIT_id = c.categories_id 
INNER JOIN produit p ON p.NOM_PRODUIT_id = c.categories_id
WHERE p.CODE_CATYEGORIE != (1, 3, 5, 7) ; 

--  4
SELECT p.NOM_PRODUIT AS Nom_Produit, 
		f.SOCIETE AS Raison_Social_Fournisseur, 
        c.categories AS Nom_categorie,
        p.QUANTITE AS quantite
FROM produits p
INNER JOIN fournisseur f ON p.NOM_PRODUIT_id = f.SOCIETE_id
INNER JOIN categories c ON p.NOM_PRODUIT_id = c.categories_id 
INNER JOIN produit p ON p.NOM_PRODUIT_id = c.categories_id
WHERE (p.CODE_CATYEGORIE BETWEEN 1 AND 3) 
OR (NO_FOURNISSEUR  BETWEEN 1 AND 3) 
OR p.QUANTITE = " boites(s)" OR " carton(s)"; 

--  5
SELECT e.NOM
FROM commande c
INNER JOIN employes e ON e.NO_EMPLOYE = c.NO_EMPLOYE 
INNER JOIN clients cl ON cl.NO_Commande = c.NO_Commande
WHERE cl.VILLE = "PARIS" 
AND c.NO_COMMANDE !=0 ;

