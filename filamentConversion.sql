-- DROP schema filamentdb;
create schema fila;

----------------------------------------------------------
-- reformat Date to new column 'PrintDate' with Data type 'date', delete old column 'Datum'
----------------------------------------------------------
-- SELECT * FROM fila.filament;
-- WHERE Gewicht_wage != '';

-- SELECT str_to_date(Datum, "%d.%m.%y") AS PrintDate
-- FROM fila.filament;

ALTER TABLE fila.filament
ADD COLUMN PrintDate date;

UPDATE fila.filament
SET PrintDate = str_to_date(Datum, "%d.%m.%y")
where Datum != '';

ALTER TABLE fila.filament
DROP COLUMN Datum;

----------------------------------------------------------
-- Change other data types to more usable ones
----------------------------------------------------------

-- describe filament;

alter table fila.filament
modify column Name varchar(255),
modify column Rolle varchar(255);

update fila.filament
set Gewicht_cura = NULL
where Gewicht_cura = '';

update fila.filament
set Gewicht_wage = NULL
where Gewicht_wage = '';

alter table fila.filament
modify column Gewicht_cura int,
modify column Gewicht_wage int;

----------------------------------------------------------
-- !! create tables by executing sql file created by dbdiagram.io
----------------------------------------------------------

----------------------------------------------------------
-- cleanup/reformat data in table RollenAlt (from Rollen.csv)
----------------------------------------------------------
-- select * from rollenalt;
-- select distinct Sorte_id from rollenalt;
-- describe rollenalt;

-- add missing values to table rollenalt:
update rollenalt
set spool = true
where spool = '';

update rollenalt
set Kaufdatum = "25.04.22"
where Gewicht = 200;

-- convert Kaufdatum to datatype date:
ALTER TABLE rollenalt
ADD COLUMN BuyDate date;

UPDATE rollenalt
SET BuyDate = str_to_date(Kaufdatum, "%d.%m.%y");

ALTER TABLE rollenalt
DROP COLUMN Kaufdatum;

-- convert Kaufpreis to datatype float:
UPDATE rollenalt SET Kaufpreis = REPLACE(Kaufpreis, ',', '.');

alter table rollenalt
modify column Kaufpreis DECIMAL(6,2);

-- convert spool to datatype float:
UPDATE rollenalt
SET spool = true
where spool = "true";

UPDATE rollenalt
SET spool = false
where spool = "false";

-- select distinct spool from rollenalt;

alter table rollenalt
modify column spool bool;

select * from rollenalt;
describe rollenalt;
----------------------------------------------------------
-- sort data from tables "filament" and "rollenalt" to appropriate fields/columns in the new tables
----------------------------------------------------------

INSERT INTO haendler (Name, url)
VALUES
 ("dasfilament", "www.dasfilament.de"),
 ("creality", "https://www.creality.com/"); 

INSERT INTO sorte (Haendler_id, Name, Material, Farbe, Dicke)
Select id , "PLA Filament - 1,75 mm - Weiß", "PLA", "weiß", 1.75
from fila.haendler
where Name = "dasfilament"
limit 1;


---------------

insert into sorte (name)
select distinct Sorte_id from rollenalt;

UPDATE sorte
SET haendler_id = 1
WHERE Name != 'Creality Ender 5 Sample PLA'; 

UPDATE sorte
SET haendler_id = (select id from haendler where Name = 'creality')
WHERE Name = 'Creality Ender 5 Sample PLA'; 

-----

update sorte
set Material = 'PLA', Dicke = 1.75;

update sorte
set Material = 'PETG'
WHERE Name LIKE 'PETG%';

update sorte
set Material = 'TPU'
WHERE Name LIKE '%TPU%';

UPDATE sorte
SET Farbe = 'Natur'
WHERE Name LIKE '%natur%';

UPDATE sorte
SET Farbe = 'Schwarz'
WHERE Name LIKE '%schwarz%';

delete from sorte where id=7;

-- so lassen wir die tabelle "sorte" erstmal

-----

alter table rolle
add Rollenname varchar(255);

alter table rolle
add Kaufpreis decimal(6,2);

INSERT INTO rolle (Rollenname, Gewicht, spool, Kaufdatum, Kaufpreis)
SELECT Sorte_id, Gewicht, spool, BuyDate, Kaufpreis
from rollenalt;

drop table rollenalt;

-----

select * from rolle ORDER BY Kaufdatum ASC;

-- Sorte_id in rolle bestimmen aus sorte where rolle.Rollenname = sorte.Name




