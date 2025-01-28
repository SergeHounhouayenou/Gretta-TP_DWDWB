-- les jointures (JOIN)
-- Jointure : opération qui sert à combiner des données provenant 
-- de plusieurs tables en se basant sur une condituin commune, souvent 
-- une clé partagée entre les tables (clé primaire et clé étrangère)

-- Les types de jointures abordées :

-- 1. la jointure interne (INNER JOIN)
-- 2. Jointures externes (LEFT, RIGHT, FULL OUTER JOIN)
-- 3. Jointure croisée (CROSS JOIN)
-- 4. Jointure naturelle (NATURAL JOIN) 


-- Prtie 1. la jointure interne (INNER JOIN)

-- Une jointure interne retourne les lignes où il y a correspondance entre les deux tables

-- Exemple 1
SELECT c.forst_name, c.last_name, a.address
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id;   
-- Explication de la requette (ligne par ligne)
-- SELECT : cette clause spécifie les colonnes que l'on veut afficher dans les résultats :
-- c.firstname : le nom de la peersonne  = client (dans la table customer)
-- a.adress : l'adresse associée du client (colonne de la table address) 
-- FROM customer c : cette clause désigne la table principale 'customer)
-- Le préfixe c est un alias pour simplifier les références à cetta table
-- Ce préfixe permet : customer.first_name --> c.first_name

-- INNER JOIN : cette clause connecte la table customer à une autre table : address le préfixe a

-- ON : clause qui définit la condition de jointure
-- Elle relie les enregistrements des 2 tables lorsque les valeurs des deux colonnes correspondent.

-- Exemple 2 : 
SELECT f.title, l.name
FROM film f
INNER JOIN language l ON f.language_id = l.language_id ;


-- Exemple 3 : 
-- Trouvver les films dispo dans un magasin spécifique et trier par titre
SELECT f.title AS film_tile, i.inventory_id AS id_inventory, i.store_id AS store
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1
ORDER BY f.title ; 

-- Exemple 4 : 
SELECT f.title AS film_title, 
		a.first_name AS actor_first_name, 
        a.last_name AS actor_last_name
FROM film_actor fa
INNER JOIN actor a ON a.actor_id = fa.actor_id
INNER JOIN film f ON f.film_id = fa.film_id; 


-- Partie 2 : Jointure externes 
-- LEs jointures externes retournes aussi les lignes sans correspondance
-- Elles sont de plusieurs types : LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN
-- FULL OUTER JOIN est implémenté dans MySQL avec opérateurs ensemble liste

-- LEFT JOIN : Retourne toutes les lignes de la table de gauche (même sans correspondance)
-- Exemple pour la table Northwind à réintégrer
SELECT c.SOCIETE AS Nom_Client,
c.VILLE AS Ville,
co.NO_COMMANDE AS Commande
FROM clients c
LEFT JOIN commandes co ON c.CODE_CLIENT = co.CODE_CLIENT
ORDER BY c.SOCIETE ;

-- Toutes les lignes sont retournées et si un client n'a pas de commande 


-- Partie 3 : Jointures croisées (CROSS JOIN)

-- Une jointure croisée retourne le produit cartésien de deux tables
-- Combiner chaque acteur avec chaque catégories : 

SELECT a.first_name, a.last_name, c.name
FROM actor a
CROSS JOIN category c ;

-- Attention aux performances : car produit cartésienn génère un grand nombre de lignes
-- Contexte exemple : affiche toutes les combinaisons possibles de plats et boissons pour offrir un menu. Chaque plat être associé avec chauqe boisson  --> génèse automatique des combinaisons. 

-- Partie 4 : Jointure naturelle (Natural JOIN°
-- Une jointure naturelle associe les tables en utilisant toutes les colonnes ayant le même nom. 
SELECT f.title, fc.category_id
FROM film forNATURAL JOIN film_category fc;
-- NATURAL JOIN utilise automatiquement la colonne commune 
-- Syntaxe simple mais rarement utilisée car manque de contrôle 



