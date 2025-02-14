-- -------------------------------------------------------
-- Les index en mysql
-- -------------------------------------------------------

-- Un index en SQL est une structure de donnéesqui sert à améliorer la vitesse d'exécution 
-- des requêtes en facilitant la recherche des enregistrements (cf. indexe de ivre)

-- Voir les index
SHOW index FROM produit ;
SHOW index FROM film ;
-- Non_uniqque définit si l'indexe est unique ou non. 
-- Key_name ets le nom de l'index
-- seq_in_index est la position de la colonne dans l'index
-- column : _name donne le nom de la colonne qui est indexée
-- Collation précise le tri ascendant ou descandant
-- cardinality donne le nombre de valeurs dans l'index
-- sub_part : Null précise que toute la colonne est indexéexecute
-- Packed : NULL informme que l'index n'est pas compressé
-- expression précise si l'indexe est basé sur une expression. NULL informe qu'il est directement basé sur une colonne.
-- index_type : BTREE, FULTEXT, ...

-- L'indexation est automatique pour les contrainte suivantes : PRIMARY KEY, FOREIGN KEY, UNIQUE

-- Création d'un indexe
SHOW INDEX FROM customer ;
CREATE INDEX idx_last_name ON customer(last_name);
CREATE UNIQUE INDEX idx_unique_email ON customer(email);
CREATE FULLTEXT INDEX idx_description ON film(description); 
SHOW INDEX FROM film ;
-- Le résultat est une création de structure de donnéees nommée idx_last_name 
-- qui contient les références de la colonne last_name

-- Fonctionnement des index - BTREE (balanced tree = arbre équilibré) 
-- --> arborescence par interval jusqu'à trouver la valeur voulue 
-- l'index organise les données en arbre équilibré pour une recherche 
-- via des opérations de recherche en temps logarythmique (O(log n)) --> catégorie 
-- de complexité appliquée. Il y en a d'autre, c'elle ci est performante en termes de temps

-- Mesure de la performance avec EXPLAIN 
EXPLAIN SELECT * FROM customer WHERE last_name = "Smith" ;
EXPLAIN SELECT * FROM film WHERE title = "Inception" ;
-- Il faut regarder les valeurs de le colonne "type" :
-- ALL :--> scan complet de de la table (à éviter)
-- INDEX :--> plus interressant que ALL
-- REF ou RANGE :--> utilisation partielle de l'index (très bien)
-- CONST :--> Une seule ligne à lire (excellent)

SHOW INDEX FROM customer ;
DROP INDEX idx_unque_email ON customer;

-- Compatibilité avec les requetes SQL 
-- Sont compatible : 
-- WHERE colonne = valeur ; 
-- ORDER BY 
-- JOIN
-- LIKE 'abc%'
-- BETWEEN
-- etc. 

-- Ne sont as compatibles : 
-- LIKE'%abc' (la solution est d'utiliser du FULLTEXT);
-- OR (SOLTION : il faut indexer les deux colonnes à indexer);  
-- NOT IN, <> (la solution est d'utiliser BETWEEN);
-- FUNCTION(colonne) dans le WHERE : la solution est qu'il n'y ait pas de fonction sur les colonnes indexées 
-- Les champs où les valeurs sont peu distictes (par exemple le genre : M/F) --> L'indexation est souvent inutile
-- LIMITE

-- --------------------------------------------------
-- Dans qules cas utiliser un indexe ? 
-- --------------------------------------------------

-- Une colonne est souvent utilisée dans un where
-- Une colonne est souvent utlisée dans un order by
-- une colonne est souvent utiliséedans une jointure

-- --------------------------------------------------
-- Dans qules cas ne faut-il utiliser un indexe ? 
-- --------------------------------------------------
-- La table est petite
-- Il y a peu de valeurs distinctes
-- Trop d'index peuvent ralentir les ISERT, UPDATE, DELETE 
	-- car il s'agit d'un point de mise à jour suplémentaire
    
-- < 1000 l'index n'a pas d'apport    
-- > 1 000 < 10 000 l'index est utile si les requêtes sont fréquentes 
-- > 10 000 l'index est recommandé 
-- > 1 000 000 l'index est obligatoire    


-- Exercices
-- 1. Vérifier les indexes sur la table customer, créer un index sur la colonne city de la table customers
-- Utiliser explain pour vérifier si l'index est utilisée lors de la selection ds customer de londres
SHOW INDEX FROM customer ;
ALTER TABLE customer ADD COLUMN city VARCHAR(50) NOT NULL AFTER address_id;
CREATE INDEX idx_city ON customer(city);
EXPLAIN SELECT * FROM customer WHERE city = "londres" ;

-- 2. Créer un index composite sur OrderDate et CustomerID dans la table orders
-- Utiliser explain pour vérifier l'efficacité de cet index lors de la selection des commandes
-- d'un client spécififique en 2025 (entre 2 dates précises)


-- ----------------------------------------------------------
-- La notion de fonction
-- ----------------------------------------------------------
-- Définition : bloc de code réutilisabe qui retourne une valeur unique.alter
-- Elle sert à simplifier certaines opérations complexes en encapsulant la logique d'un bloc
-- On peut l'utiliser dans un select

-- Syntaxe
DELIMITER $$
-- CREATE FUNCTION nom-function (paramètre TYPE, ...)
-- RETURNS type_de_retour
-- DETERMINISTIC
-- BEGIN
-- Je mets mon Bloc d'insertion SQL
-- RETURN valeur
-- END $$
-- DELIMITER ;

-- Fonction pour avoir l'âge d'un acteur
DELIMITER $$
CREATE FUNCTION get_actor_age(birth_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE age INT; -- déclaration d'une variable avec son type
    SET age = TIMESTAMPDIFF(YEAR, birth_date, CURDATE()); 
	RETURN age;
END $$
DELIMITER ;

-- APPEL DE LA FONCTION
SELECT get_actor_age('1985-07-20') AS age ;

-- Exemple 2 : fonction pour récupérer le nombre de films d'un acteur
DELIMITER $$
CREATE FUNCTION count_actor_movies(actor_id INT)
RETURNS INT
DETERMINISTIC 
-- Pour mysql pour stocker le résultat de la fonction afinde a restituer directement la prochaine fois.
BEGIN
	DECLARE total INT; 
    SELECT COUNT(*) INTO total FROM film_actor WHERE actor_id = actor_id;
    RETURN total;
END $$
DELIMITER ;
-- APPEL de la fonction
SELECT count_actor_movie(5) AS total_movies;
 
-- Suppression de la fonction
 DROP FUNCTION IF EXISTS count_actor_movies;
 
 -- Lister les fonctions existantes
 SHOW FUNCTION STATUS WHERE Db = 'sakila' ;
 
-- ---------------------------------------
-- Exercices -----------------------------
-- ---------------------------------------

-- 1. NORTHWIND
-- créer une fonction get_customer_orders qui retourne 
-- le nombre de commandes passées par un client (customerID)
-- Appel : SELECT get _customer_order ('ALFKI') AS total_order ; (parmètre de type CHAR)

DELIMITER $$
DROP FUNCTION IF EXISTS get_customer_orders;
CREATE FUNCTION get_customer_orders(CODE_CLIENT CHAR)
RETURNS CHAR
DETERMINISTIC 
BEGIN
	DECLARE total_customer_order INT; 
    SELECT COUNT(*) INTO total_customer_order FROM commandes WHERE  NO_COMMANDE = NO_COMMANDE;
    RETURN total_customer_order;
END $$
DELIMITER ;
-- Appel
SELECT get_customer_orders('ALFKI') AS total_order ; 

-- Q2 : 
-- Créer une fonction calculate_total_revenu qui retourne le chiffre d'affaires total généré 
-- par un employé (employé ID)
-- Appel : SELECT calculate_total_revenues(5) AS total_sales; 

DELIMITER $$
DROP FUNCTION IF EXISTS calculate_total_revenues;
CREATE FUNCTION calculate_total_revenues(NO_EMPLOYE INT)
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE total_gain INT; 
    SELECT SUM(SALAIRE + COMMISSION) INTO total_gain FROM employes WHERE (NO_EMPLOYE = NO_EMPLOYE) GROUP BY NO_EMPLOYE;
    RETURN total_gain;
END $$
DELIMITER ;
-- Appel
SELECT calculate_total_revenues(2) AS total_sales; 
 
  -- 
  
  
-- -----------------------------------------------
-- les vues
-- ------------------------------------------------
-- Syntaxe
-- CREATE VIEW ma_vieaw AS --
-- colonne1, colonne2
-- FROM table
-- WHERE conditions

-- utilisation de la vue
-- SELECT * FROM ma_view;
-- DROP VIEW IF EXISTS my_view; 

   