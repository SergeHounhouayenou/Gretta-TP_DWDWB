-- les fonctions natives

-- Objectif : Evaluer des conditions ogiques 
-- Peuvent être utilisés dans les SELECT, UPDATE, ORDER BY, WHERE, GROUP BY, INSERT, HAVING.alter



-- if(expression, valeur si vrai, valeur si faux)


-- Exemple 1 : Catégoriser les films selon la durée
SELECT title, length, 
		CASE
			WHEN length < 60 THEN "Court-métrage"
            WHEN length BETWEEN 60 AND 120 THEN "Film Standard"
            WHEN lenght > 120 THEN "Long-métrange"
            ELSE "Non défini"
		END
        AS film_category
FROM film;

-- Exemple 2 : faire des calculs dynamiquement
SELECT title, rating,
		CASE 
			WHEN rating = "G" THEN 1
            WHEN rating = "PG" THEN 2
            WHEN rating = "R" THEN 3
            ELSE "Non défini"
		END
		AS rating_weight,
        rental_rate * CASE
							WHEN rating = "G" THEN 1
                            WHEN rating = "PG" THEN 2
                            WHEN rating = "R" THEN 3
                            ELSE 0
						END 
                        AS weighted_rental_rate
FROM film;











