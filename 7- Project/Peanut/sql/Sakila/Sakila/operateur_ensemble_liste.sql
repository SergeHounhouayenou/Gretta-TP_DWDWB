-- ---------------------------------------------
-- Les opérateurs ensemble liste ---------------
-- ---------------------------------------------
-- UNION ; INTERSECT ; EXEPT / MINUS -----------
-- !! ATTENYION : INTERSECT ET EXCEPT / MINUS ne sont pas implémentés sur MySQL
-- Il faudra nécessairement utiliser les "JOIN"

-- LEs opérateurs ensemblreliste pservent à combiner les résultats de plisieurs requeêtes SQL mais sans relier les tables entre elles. 

-- QuaND les utiliser ? On veut fusionner des ensembles de données similaires

-- Règles : 
-- Les requêtes qui sont fusionnnées doivent retourner le même nombre de colonnes.  (MYSQL ne sait pas faire autrement)
-- Les colonnes doivent avoir des types compatibles. 
-- L'ordre des colonnes dans les requetes est important car Mysql ne sait pas faire identifier par les nom. Il identifie par la position dans les requêtes et les instruction et attribue des labels à ses potions. 

-- Exemple 1 : UNION : il fusionne les ensembles en supprimant les doublons
SELECT first_name, "Staff" FROM staff 
UNION 
SELECT first_name, "Customer" FROM customer; 

-- Selectionne les prénoms firstname de la table staff
-- Selectionne les prénoms de la table customer
-- Union Suprimme les doublons , donc si un employé et un client portent 
-- le même prénom il n'apparait qu'une fois. 
-- Pour garder les doublons on doit ajouter UNION ALL
-- UNION sera donc plus performant que UNION ALL

-- Exemple 2
SELECT first_name, email
FROM customer
UNION
SELECT first_name
FROM staff;
-- ça ne marche pas car le nombre de colloones n'est pas identique.  
SELECT first_name, email
FROM customer
UNION
SELECT first_name, email
FROM staff;
-- Cette version fonctionne

-- Exemple 3
SELECT first_name, create_date -- create_date est un datetime
FROM customer
UNION
SELECT first_name, rental_id -- rental_id est un int
FROM rental;
-- Cette version génère une erreur car les colonnes ne sont pas du même type

SELECT first_name, CAST(create_date AS CHAR)
FROM customer
UNION
SELECT first_name, CAST(rental_id AS CHAR)
FROM rental;


-- Les autres opérateurs : INTERSECT
-- Renvoyer uniquement les lignes qui eistent dans les deux ensembles
-- Disponible pour POSTGRSQL, ORACLE
-- Solution en MySQL : simuler INTERSECT avec INNER JOIN 

 -- Les autres opérateurs : EXCEPT / MINUS
 -- Trouve les valeurs présents dans le premier ensemble mais absentes du second. 
 -- Il exclcut les valeurs qui apparaissent dans la seconde requête
 -- Disponible : POSTGRSQL, SQL Server , ORACLE
 -- Solution en Mysql : simulation avec LEFT JOIN + WHERRE 
 

-- Exercices
-- 1. Affichez le nom des sociétés, adresses et villes de résidence 
-- pour tous les tiers de l’entreprise (clients et fournisseurs) 

SELECT c.SOCIETE, c.VILLE, c.ADRESSE
FROM clients c
UNION
SELECT f.SOCIETE, f.VILLE, f.ADRESSE
FROM fournisseurs f; 

-- 2. On souhaite identifier les commandes qui contiennent 
-- au moins un produit de la catégorie 1 fourni par le fournisseur 1 
-- et un produit de la catégorie 2 fourni par le fournisseur 2.


SELECT p.CODE_CATEGORIE, f.NO_FOURNISSEUR, dc.NO_COMMANDE 
FROM produits p
iNNER JOIN details_commandes dc ON p.REF_PRODUIT = dc.REF_PRODUIT  
INNER JOIN fournisseurs f ON p.NO_FOURNISSEUR = f.NO_FOURNISSEUR ;
-- GROUP BY p.CODE_CATEGORIE AND f.NO_FOURNISSEUR = 1, 2 ;

-- UNION 
SELECT dc.NO_COMMANDE, p.CODE_CATEGORIE
FROM details_commandes dc
INNER JOIN  produits p	ON p.REF_PRODUIT = dc.REF_PRODUIT 
WHERE (p.NO_FOURNISSEUR AND p.CODE_CATEGORIE = 1) OR (p.NO_FOURNISSEUR AND p.CODE_CATEGORIE = 2);

-- Correction exercice 2
SELECT dc.NO.COMMANDE
FROM details_commandes dc
JOIN produits p ON dc.REF_PRODUIT = p.REF_PRODuIT
WHERE (p.cODE_CATEGORIE = 1 AND p.NO_FOURNISSEUR = 1)
OR (p.CODE_CATEGORIE = 2 AND p.NO_FOURNISSEUR = 2)
-- On ne garde que les produits des catégories 1 et2 fournis respectivement par les fournisseurs 1 et 2
GROUP BY dc. NO_COMMANDE 
-- On ne garde que les résultatspar commande (NO_COMMANDE) -142 commandes
-- contenant produits 1 et/ou 2
HAVING COUNT(DISTINCT p.CODE_CATEGORIE) = 2 ;
-- Cela permet de compter les catégories distinctes présente dans chaque commande
-- Si une commande contient uniquement des produists de catégorie 1 
-- Attention ! Si la requête devient complexe en terme de quantité de variables le contrôle risque de devenir difficile
-- et la perte d'information devient un risque réel. Ne pas hésiter à mettre une étape intermédiaire. 


-- ---------------------------------------------------------
-- Les requettes imbriquées
-- ---------------------------------------------------------

-- Syntaxe :
-- SELECT colonne_A 
-- FROM table_A
-- WHERE colonne_A = (SELECT colonne_B FROM autre_table_B WHERE cdt); --> fonction d'équivalence entre les deux tables

-- Les sous requetes peuvent être utilisées dans différents contextes 
-- Dans la clause Where (filtrage)
-- Dans la clause SELECT (calcul d'agrégats) 
-- Dans la clause FROM (Vue temporaire) 
-- Autres : HAVING, ORDER BY, INSERT INTO, UPDATE, DELETE 

-- Exemple 1 : Sous requête dans WHERE
-- Filtrer les résultats en fonction des valeurs moyenne sur la durée des films :
-- On veut donc trouver tous les films dont la duréee est supérieur à la moyenne des films

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film) ;
-- Explication : 
-- Sous requete retourne la durée moyenne des films
-- La requete principale sélectionne tous les films ayant une durée
-- supérieur à cette moyenne
-- Rôle ; Filtrer

-- Exemple 2 : Sous requete dans la clause SELECT
-- Rôle Permet de calculer une valeur pour chaque ligne retournéexecute
-- Afficher le titre du film et le nombre tota de locations (rental)
-- pour chaque film 

SELECT title, 
			(
            SELECT COUNT(*)
            FROM rental r
            INNER JOIN inventory i ON r.inventory_id = i.inventory_id
            WHERE i.film_id = f.film_id
            ) AS total_rental  
FROM filmm f;

-- Explication de la structure de la requête
-- La requete principale sélectionne tous les films
-- La sous requette compte le nombre de fois que chaque film a été louéalter
-- L'élément clé est la clause where : relie la sous requête à la requete prinicpale

-- Etape 1 : 
-- La requete principale parcourt chaque ligne de la table film.
-- Elle prend un film f.film_id
-- Elle exécute ensuite la sous-requete pour CE FILM PRECIS

-- Etape 2 : Exécution de la sous requête
-- La table inventory relie les film (film_id) aux copies dispos e stock (inventory_id)
-- LA table rental contient les locations effectuées, associées aux inventory_id
-- La sous requete cherche toutes les locations (rental) qui correspondent au film actuel (film_id)

-- Etape 3 : Que fait le WHERE ? 
-- f.film_id provient de la requete prinicipale (chaque film)
-- i.film_id est la colonne dans dans la table inventory qui stocke ID du film
-- WHERE i.film_id = f.film_id signifie compte uniquement les locations des copies de CE FILM PRECIS

-- Exemple concret : 
-- Table film
-- 1 <-----------> Inception
-- 2 <-----------> Titanic
-- 3 <-----------> Matrix

-- Table inventory (copies films)
-- inventory_id 	<-----------> film_id
-- 101				<----------->
-- 102              <----------->
-- 103              <----------->
-- 104              <----------->

-- Table rental (location des copies)
-- inventory_id 	<-----------> inventory_id
-- 1001				<-----------> 101
-- 1002             <-----------> 101
-- 1003             <-----------> 102
-- 1004             <-----------> 103

-- La requete principale prend Inception (film_id = 1)
-- La sous requete est exécutée avec WHERE i.film_id = 1 donc elle trouve :
-- inventory_id = 101 (loué 2 fois)
-- inventory_id = 102 (loué 1 fois)
-- Total locations = 3

-- Le terme académique est "requete corélée" (Subquery corrélée) : 
-- Ici la sous requete dépend des valeurs de la requete principale

-- Conclusion :
-- Sous requête ici = execution répétée = inéfficace
-- Une jointure fait la même chose plus rapidement
-- La sous requête n'est utile que si on cherche une valeur spécifique non-atteignable par JOIN.    

-- Chercher dans la documentation l'usage de ALL, ANY SOME ... IN
-- ANY et SOME font la même chose : La condition est vrai si au moins une valeur de la sous requête la satisfait. 
-- WHERE salary > ANY (SELECT salary FROM staff WHERE store = 2)

-- ALL : La condition est vrai si toutes les valeur de la sous requête la satisfont. 


-- Exercice :
-- Afficher tous les produits pour lesquels la quantité en stock est 
-- inférieure à la moyenne des quantités en stock

SELECT *
FROM produits 
WHERE UNITES_STOCK < (SELECT AVG(UNITES_STOCK) FROM produits) ;


-- 2. Afficher toutes les commandes pour lesquelles les frais 
-- de port dépassent la moyenne des frais de port pour ce client
SELECT *
FROM commandes 
WHERE PORT > (SELECT AVG(PORT) FROM commandes)
GROUP BY CODE_CLIENT ;


-- 3. Afficher les produits pour lesquels la quantité en stock 
-- est supérieure à la quantité en stock de chaque produit 
-- de la catégorie 3 (pensez à utiliser ALL cf documentation)

SELECT *
FROM produits
WHERE UNITES_STOCK > ( SELECT p.UNITES_STOCK FROM produits p WHERE CODE_CATEGORIE = 3 ) ;

(SELECT p.UNITES_STOCK
FROM produits p
WHERE CODE_CATEGORIE = 3) ;


  