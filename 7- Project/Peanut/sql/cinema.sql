drop database if exists cinema;

create database if not exists cinema;
use cinema;
create table realisateur(
	realisateur_id int(6) not null auto_increment,
    nom varchar(25) not null,
    prenom varchar(25) not null,
    primary key(realisateur_id),
    index nom_ix_realisateur (nom)
) engine innodb;
create table film(
	film_id int(6) not null auto_increment,
    nom varchar(80) not null,
    annee int(4) null,
    realisateur_id int(6) not null,
    primary key(film_id),
    foreign key(realisateur_id) references realisateur(realisateur_id),
    index nom_ix_film (nom)
) engine innodb;
create table acteur(
	acteur_id int(6) not null auto_increment,
    nom varchar(25) not null,
    prenom varchar(25) not null,
    primary key(acteur_id),
    index nom_ix_acteur (nom)
) engine innodb;
create table film_acteur(
	film_id int(6) not null,
	acteur_id int(6) not null,
    primary key(film_id, acteur_id),
    foreign key(film_id) references film(film_id),
    foreign key(acteur_id) references acteur(acteur_id)
) engine innodb;
--------------
insert into realisateur(realisateur_id, nom, prenom) 
values (1, "Eastwood", "Clint");
insert into acteur(acteur_id, nom, prenom) 
values (1, "Swank", "Hilary"),
		(2, "Eastwood", "Clint"),
		(3, "Vang", "Bee");
insert into film(film_id, nom, annee, realisateur_id) 
values (1, "Million Dollar Baby", null, 1),
		(2, "Gran Torino", 2008, 1);
insert into film_acteur 
values (1, 1),
		(1, 2),
        (2, 3),
        (2, 1);