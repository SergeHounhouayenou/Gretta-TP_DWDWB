-- option DISTINCT suprime les doublons
-- ALL retourne par défaut toutes les occurennces avec les doublons

-- La syntaxe générale est : 
-- SELECT [DISTINCT | ALL] colonnes
-- FROM table ;
-- REMARQUE par défaut, la valeur est à ALL
-- Exemple, Récuppérer les ann"es de sortie uniques des films
SELECT release_year
FROM film ;

SELECT DISTINCT release_year
FROM film ;

select rental_rate
FROM film ;

SELECT distinct rental_rate 
from film ;