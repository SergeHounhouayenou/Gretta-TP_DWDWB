
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE `cars` (
  `id_cars` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `model` varchar(150) NOT NULL,
  `dob` date NOT NULL,
  `photo` longblob,
  `id_generics` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `customers` (
  `id_customers` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `mail` varchar(100) NOT NULL,
  `gender` enum('F','M','N') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `pass` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE `generics` (
  `id_generics` int(11) NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



INSERT INTO `generics` (`id_generics`, `name`) VALUES
(1, 'Vintage'),
(2, 'Luxe'),
(3, 'Non commercialisé'),
(4, 'Série limitée');



CREATE TABLE `owners` (
  `id_owners` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `mail` varchar(100) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `civility` enum('Sir','Mr') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `photo` longblob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `owners`
--

INSERT INTO `owners` (`id_owners`, `name`, `mail`, `phone`, `civility`, `dob`) 
VALUES (7, 'Sean Connery', 'seanconneray@gmail.com', '+44 6214354465', 'Sir', '1930-08-25');

INSERT INTO `owners` (`id_owners`, `name`, `mail`, `phone`, `civility`, `dob`) 
VALUES (8, 'George Lazenby ', 'georgelazenby@gmail.com', '+44 6 214354', 'Mr', '1939-09-05');

INSERT INTO `owners` (`id_owners`, `name`, `mail`, `phone`, `civility`, `dob`) 
VALUES (9, 'Timothy Dalton', 'timothydalton@gmail.com', '+44 6 21657687', 'Mr', '1946-03-21');

INSERT INTO `owners` (`id_owners`, `name`, `mail`, `phone`, `civility`, `dob`) 
VALUES (10, 'Pierce Brosnan', 'piercebrosnan@gmail.com', '+44 621432354', 'Mr', '1953-05-16');

INSERT INTO `owners` (`id_owners`, `name`, `mail`, `phone`, `civility`, `dob`) 
VALUES (11, 'Daniel Craig', 'danielcraig@gmail.com', '+44 621987654', 'Mr', '1968-03-02');


CREATE TABLE `own_cars` (
  `id_owners` int(11) NOT NULL,
  `id_cars` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE `rent_cars` (
  `id_customers` int(11) NOT NULL,
  `id_cars` int(11) NOT NULL,
  `rent_date` datetime NOT NULL,
  `duration` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `rent_cars` (`id_customers`, `id_cars`, `rent_date`, `duration`) VALUES
(3, 1, '2025-02-13 00:00:00', 4),
(8, 6, '2025-02-15 00:00:00', 4),
(13, 5, '2025-02-19 00:00:00', 3);



CREATE TABLE `users` (
  `id_users` int(11) NOT NULL,
  `login` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `role` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `cars`
  ADD PRIMARY KEY (`id_cars`),
  ADD KEY `fk_cars_generics_idx` (`id_generics`);


ALTER TABLE `customers`
  ADD PRIMARY KEY (`id_customers`);


ALTER TABLE `generics`
  ADD PRIMARY KEY (`id_generics`);


ALTER TABLE `owners`
  ADD PRIMARY KEY (`id_owners`);

--
-- Index pour la table `own_cars`
--
ALTER TABLE `own_cars`
  ADD PRIMARY KEY (`id_owners`,`id_cars`),
  ADD KEY `fk_owners_has_cars_cars1_idx` (`id_cars`),
  ADD KEY `fk_owners_has_cars_owners1_idx` (`id_owners`);

--
-- Index pour la table `rent_cars`
--
ALTER TABLE `rent_cars`
  ADD PRIMARY KEY (`id_customers`,`id_cars`,`rent_date`),
  ADD KEY `fk_customers_has_cars_cars1_idx` (`id_cars`),
  ADD KEY `fk_customers_has_cars_customers1_idx` (`id_customers`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_users`),
  ADD UNIQUE KEY `login_UNIQUE` (`login`),
  ADD UNIQUE KEY `role_UNIQUE` (`role`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `cars`
--
ALTER TABLE `cars`
  MODIFY `id_cars` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `customers`
--
ALTER TABLE `customers`
  MODIFY `id_customers` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `generics`
--
ALTER TABLE `generics`
  MODIFY `id_generics` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `owners`
--
ALTER TABLE `owners`
  MODIFY `id_owners` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id_users` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `cars`
--
ALTER TABLE `cars`
  ADD CONSTRAINT `fk_cars_generics` FOREIGN KEY (`id_generics`) REFERENCES `generics` (`id_generics`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `own_cars`
--
ALTER TABLE `own_cars`
  ADD CONSTRAINT `fk_owners_has_cars_cars1` FOREIGN KEY (`id_cars`) REFERENCES `cars` (`id_cars`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_owners_has_cars_owners1` FOREIGN KEY (`id_owners`) REFERENCES `owners` (`id_owners`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `rent_cars`
--
ALTER TABLE `rent_cars`
  ADD CONSTRAINT `fk_customers_has_cars_cars1` FOREIGN KEY (`id_cars`) REFERENCES `cars` (`id_cars`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_customers_has_cars_customers1` FOREIGN KEY (`id_customers`) REFERENCES `customers` (`id_customers`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
