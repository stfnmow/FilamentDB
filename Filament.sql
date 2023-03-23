CREATE TABLE `Haendler` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `Name` varchar(255),
  `url` varchar(255)
);

CREATE TABLE `Sorte` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `Haendler_id` int,
  `Name` varchar(255),
  `Material` ENUM ('PLA', 'PETG', 'TPU'),
  `Farbe` varchar(255),
  `Dicke` float
);

CREATE TABLE `Rolle` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `Sorte_id` int,
  `Gewicht` int,
  `spool` bool,
  `Kaufdatum` date,
  `Oeffnungsdatum` date,
  `RestgewichtCura` int,
  `RestgewichtWage` int
);

CREATE TABLE `printjob` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `modell_id` int,
  `Druckdatum` date,
  `Rolle_id` int,
  `Dauer` time,
  `GewichtCura` int,
  `GewichtWage` int
);

CREATE TABLE `Modell` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `version` int,
  `Beschreibung` text
);

ALTER TABLE `Sorte` ADD FOREIGN KEY (`Haendler_id`) REFERENCES `Haendler` (`id`);

ALTER TABLE `Rolle` ADD FOREIGN KEY (`Sorte_id`) REFERENCES `Sorte` (`id`);

ALTER TABLE `printjob` ADD FOREIGN KEY (`modell_id`) REFERENCES `Modell` (`id`);

ALTER TABLE `printjob` ADD FOREIGN KEY (`Rolle_id`) REFERENCES `Rolle` (`id`);
