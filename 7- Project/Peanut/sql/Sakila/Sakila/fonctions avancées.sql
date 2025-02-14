-- Group BY

-- Objectif : Comprendre comment regrouper les données en SQL avec la clause GROUP BY

-- ORDRE de Lecture  : FROM WHERE GROUP BY HAVING SELECT

-- Les fonctions d'agrégation courantes : COUNT(), SUM, AVG, MIN, MAX

-- Partie 1 : Utilisation basic de GROUPE BY

-- Exemple 1 : Compter le nombre de film par catégorie
SELECT c.name AS category, COUNT(f.film_id) AS tolal_films
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON f.film_id = fc.film_id
GROUP BY c.name ;  

-- Explication : 
-- 1. Les films seront regroupés par catégorie (c.name dans le groupe by)
-- 2. COUNT (f.film_id) compte le nombre de films dans chaque catégorie
-- remarque : f.film_id pourrait être remplacé par f.title mais recommandé ++ de count
-- sur les id pour éviter les valeurs particulières (NULL..)
-- Rappel : count(*) compte les valeurs null alors que count (colonne) compte les valeurs non null


-- Rassemblement des notions dans une même requête
-- Obtenir les 3 catégories de films
SELECT c.name, COUNT(f.film_id) AS total_films
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
-- WHERE
GROUP BY c.name
ORDER BY total_films DESC
LIMIT 3

-- Ordre des CLAUSES
-- FROM --> JOIN --> WHERE --> GROUP BY --> HAVING --> SELECT --> ORDER BY --> LIMIT

-- --------------------------------------------
-- Partie 2 - Fonctions avancées 
-- --------------------------------------------

-- Objectif : la clause having permet de filtrer les résultats d'un regroupement par group by

-- Intervient après nécessairement après le 'group by'
-- S'utilise souvent avec des fonctions d'agrégation mais aussi LIKE, IN, BETWEEN, etc.

SELECT c.name, COUNT(f.film_id) AS total_films
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film ON fc.film_id = f.film_id
GROUP BY c.name
HAVING COUNT(f.film_id) > 50 ;

-- Explication :
-- 1. Les données sont regroupées par catégories (GROUP BY)
-- 2. COUNT (f.film_id) calcule le nombre de films dans chaque catégoriies 
-- 3. Having filtre les catéfories ayant plus de 50 films. 

-- Exemple 2 : Trouver les catégories ayant plus de 30 films sorties après 2005
SELECT c.name AS category, COUNT(f.film_id) AS total_films
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
WHERE f.release_year > 2005
GROUP BY c.name
HAVING COUNT(f.film_id) > 60; 
 -- Différence entre HAVING et WHERE : WHERE filtre avant group by 
-- Privilégier le WHERE chaque fois que la restriction initiale peut suffir. 
-- Le HAVING n'utilise pas les indexes. LE WHERE peut exploiter les indexes.

-- Q1 : Écrivez la requête qui permet d’afficher la masse salariale des employés par fonction
SELECT e.FONCTION, SUM(e.SALAIRE) AS massa_salariale
FROM employes e
GROUP BY FONCTION;

-- Q2 : -- Nouvelle question : Affichez la somme des salaires et des 
-- commissions par fonction et incluez une colonne qui indique si la 
-- somme dépasse 15 000 ("High"), est entre 8 000 et 15 000 ("Medium"), 
-- sinon c'est ("Low"). Trier les résultats par la somme décroissante. 
 
SELECT SUM(e.SALAIRE + e.COMMISSION) AS "massa_salariale", 
CASE
	WHEN "massa_salariale" > 15000 THEN "high"
    WHEN "massa_salariale" < 15000 AND "massa_salariale" > 8000 THEN "medium"
    WHEN "massa_salariale" < 8000 THEN "low"
    END
AS remarque 
FROM employes e
GROUP BY FONCTION 
ORDER BY "massa_salariale" DESC ;

-- Q3 : Écrivez une requête SQL qui affiche des statistiques 
-- sur les employés en fonction de leur fonction (FONCTION).
-- Les résultats doivent inclure les informations suivantes :
-- La fonction (FONCTION) de l'employé.
-- Le salaire le plus élevé parmi les employés ayant cette fonction (highest_salary).
-- La commission la plus basse pour cette fonction (lowest_commission).
-- Le nombre total d'employés occupant cette fonction (total_employees).
-- Seules les fonctions ayant plus de 1 employés doivent être affichées.
-- Les résultats doivent être triés du plus haut au plus bas salaire maximum. 

SELECT e.FONCTION AS FONCTION, "total_employe",
	CASE
	WHEN MAX(e.SALAIRE) THEN MAX(e.SALAIRE) 
    END
AS highest_salaire,
CASE
	WHEN MIN(e.COMMISSION) THEN MIN(e.COMMISSION)
    END
AS lowest_commission
FROM employes e
WHERE e.SALAR > 1
GROUP BY e.FONCTION 
HAVING "total_employe" = COUNT(FONCTION)
ORDER BY e.SALAIRE DESC ;




-- Q4 : La requête doit afficher :
-- Le pays (PAYS).
-- Le nombre d'entreprises distinctes (distinct_companies) dans chaque pays.
-- Une colonne indiquant si le pays a plus de 10 entreprises distinctes ("Diverse") ou non ("Limited").
-- Seuls les pays où au moins une entreprise est enregistrée doivent être affichés.
-- Les résultats doivent être triés du plus grand au plus petit nombre d’entreprises distinctes. 
-- on veut ignorer les pays ayant moins de 5 entreprises différentes

SELECT c.PAYS, COUNT(DISTINCT c.SOCIETE) As distinct_companies,
	CASE 
		WHEN COUNT(DISTINCT c.SOCIETE) > 10 THEN "Diverse"
        ELSE "Limited"
        END
	AS diversity_level

FROM clients c
-- INNER JOIN fournisseurs f ON f.SOCIETE = c.SOCIETE
-- INNER JOIN employes e ON e.FONCTION = f.FONCTION
-- WHERE e.SALAIRE > 0
GROUP BY c.PAYS 
ORDER BY distinct_companies DESC ;



-- Q5 : Affichez le montant de chaque commande, 
-- en ne conservant que les commandes qui comportent 
-- plus de 5 références de produit


-- Q6 : Afficher la valeur des produits en stock 
-- et la valeur des produits commandés par fournisseur, 
-- pour les fournisseurs qui ont un numéro compris entre 3 et 6

