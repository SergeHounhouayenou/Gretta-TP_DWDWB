-- ------------------------------------
-- Procédures stockées
-- ------------------------------------

-- Ensemble de d'instructions SQL ordoné et enregistrées sous un nom spécifique 
-- pour une exécution à la demande.
-- Elle ne peut pas être insérée dans un sélect (contrairement à la vue)
-- Elle peut retourner plusieurs jeux de résultats ou modifier des tables
-- Elle concrétise les automatisations : --> Compression Algorythmique
-- ..> traitements basics --> traitemens compexes --> fonctions --> procédures --> Triger --> fonctionalités
-- TRIGGER : morceau de code qui s'éxécute automatiquement quand une action est réalisée sur une table (INSERT, UPDATE, DELETE, SELECT)

-- Exemple : 
DELIMITER $$ 
CREATE PROCEDURE get_films_by_actor(IN actor_name CHAR(50))
BEGIN
	SELECT f.film_id, f.title
    FROM film f
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
	INNER JOIN actor a ON a.actor_id = fa.film_id
    WHERE a.first_name = actor_name OR a.last_name = actor_name;
END $$ 
 DELIMITER ;
 
 CALL get_films_by_actor('PITT');
 
 -- Suppression d'une procédure 
DROP PROCEDURE IF EXISTS get_films_by_actor;
 