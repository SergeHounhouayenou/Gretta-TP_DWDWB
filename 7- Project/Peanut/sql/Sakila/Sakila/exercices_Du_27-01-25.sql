-- Exercices du 27-01-25

-- QUESTION 1 : Affichez les employés avec leur salaire journalier 
-- (salaire/20) arrondi à l’entier supérieur. Ajoutez une colonne indiquant, 
-- avec un CASE, si leur salaire journalier est faible (<= 100), moyen (> 100 et <= 200), ou élevé (> 200).

SELECT NOM AS "Nom_Employés", CEIL(SALAIRE * 0.2) AS "Salaire Moyen",
	CASE 
		WHEN SALAIRE <= 100 THEN "faible"
		WHEN SALAIRE > 100 AND SALAIRE <=200 THEN "moyen"
		WHEN SALAIRE > 200 THEN "élevé"
		ELSE " " 
    END
    AS "remarque"
FROM employes ;



-- QUESTION 2 : Affichez les employés -- avec leur revenu annuel (salaire*12 + commission) arrondi à la centaine près, 
-- et une colonne supplémentaire indiquant, avec un CASE, si leur commission est supérieure à 10% de leur salaire annuel.

SELECT NOM, SALAIRE, COMMISSION
FROM employes ;

SELECT NOM AS "Nom_Employés", (COMMISSION + ROUND(SALAIRE * 12, 2) ) AS "Salaire Annuel",
	CASE 
        WHEN SALAIRE > (COMMISSION + ROUND(SALAIRE * 12, 2)) * 0.1 THEN "salaire_supérieur_commission"
		ELSE "salaire_inférieur_commission," 
    END
    AS "Salair/Commission"
FROM employes ;


-- QUESTION 3 : Affichez les produits commercialisés, 
-- leur valeur de stock (unités en stock fois prix unitaire 
-- arrondie à la dizaine inférieure) et indiquez, avec un CASE, 
-- si le produit a une valeur de stock faible (< 500), modérée 
-- (entre 500 et 1000), ou élevée (> 1000). Incluez également le nom de la catégorie du produit.

SELECT NOM_PRODUIT AS "Produit_comercialises", ROUND((UNITES_STOCK * PRIX_UNITAIRE), 1) AS "Valeur en stock",
	CASE 
        WHEN "Valeur en stock" <= 500 THEN "faible"
		WHEN "Valeur en stock" > 500 AND "Valeur en stock" <=1000 THEN "modéré"
		WHEN "Valeur en stock" > 1000 THEN "élevé"
		ELSE " " 
    END
    AS "remarque"
FROM produits ;



-- QUESTION 4 : Affichez le nom des employés, la date de fin de leur période d’essai (3 mois), 
-- leur ancienneté en mois (avec TIMESTAMPDIFF) et indiquez, avec un CASE, s’ils sont nouveaux (< 6 mois), 
-- expérimentés (6 à 24 mois), ou vétérans (> 24 mois) avec TIMESTAMPDIFF.

SELECT 	NOM, 
		DATE_EMBAUCHE,
		ADDDATE(DATE_EMBAUCHE, INTERVAL 3 MONTH) AS date_fin_essai,
        TIMESTAMPDIFF(NOW() - DATE_EMBAUCHE) AS anciennete,
        CASE 
        WHEN "" <= 500 THEN ""
		WHEN "" > 500 AND " " THEN ""
		WHEN  THEN ""
		ELSE " " 
    END
    AS ""

FROM employes ;


-- QUESTION 5 : Affichez le nom des employés et le jour de leur première paie 
-- (dernier jour du mois de leur embauche). Ajoutez une colonne qui indique si leur 
-- première paie a eu lieu en semaine (Lundi à Vendredi) 
-- ou pendant le week-end (Samedi ou Dimanche). Les fonctions qui peuvent 
-- vous êtres utiles : DAYOFWEEK (1 et 7 représente le WEEK-END), LAST_DAY d'une date.



