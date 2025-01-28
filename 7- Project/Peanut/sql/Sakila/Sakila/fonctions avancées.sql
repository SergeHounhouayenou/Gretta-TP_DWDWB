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