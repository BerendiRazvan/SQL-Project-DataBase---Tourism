USE Turism
GO


-- INSERARE DATE IN TABELE


-- ADAUGARE IN CLIENTI
INSERT INTO Clienti(Nume,Prenume,DataNastere,Telefon,Email)
VALUES ('Berendi','Razvan-Alexandru','2001-07-28','0751578787','berendi.razvan28@gmail.com'),
('Marina','Rares','2001-04-16','0734573287','marinarares@yahoo.com'),
('Rotar','Andreea-Maria','2000-01-14','0740578435','@gmail.com'),
('Pop','Ana','1997-03-03','0754554787','pair2873@scs.ubbcluj.ro'),
('Suciu','Mihaela','1990-05-12','0755578123','suciu_miha90@samsung.outlook.com'),
('Muntean','Ioan','2002-02-25','0750070081','muntean02ioan02@outlook.com'),
('Pop','Darius-Andrei','2000-11-28','0264558753','pop_drsadr@yahoo.com'),
('Muntean','Iulia','1970-05-20','0751328137','mt_iuly_70@gmail.com'),
('Groza','Ioana','1963-08-22','0751123482','grozaxioana@gmail.com'),
('Popa','Darius','1988-06-10','0754128744','popadarius123821@yahoo.ro')

SELECT * FROM Clienti


-- ADAUGARE IN AGENTII
INSERT INTO Agentii(Denumire,DataInfiintare,SiteWeb)
VALUES ('Expedia','1996-10-22','www.expedia.com'),
('Travelling','2010-03-17','www.travelling.com'),
('Christian Tour','2006-09-20','www.christiantour.ro')

SELECT * FROM Agentii

-- ADAUGARE IN AGENTII
INSERT INTO Angajati(Nume,Prenume,DataNastere,Salariu,Functie,IDAgentie)
VALUES ('Pop','Andrei','2000-01-23',2500,'Ghid turistic',1),
('Muntean','Maria','2001-07-10',2300,'Agent',1),
('Pop','Iulian','1993-12-11',2840,'Secretar',1),
('Crisan','Giulia','1997-03-15',2400,'Ghid turisti',1),
('Pojar','Marius','2002-01-02',2000,'Ghid turisti',1),
('Muntean','Cristian','2000-05-19',1900,'Agent',2),
('Florescu','Tudor','1994-07-18',1870,'Ghid turisti',2),
('Ionescu','Horea','1979-04-12',1700,'Agent',2),
('Popaescu','Diana','1983-09-18',2000,'Secretar',2),
('Pop','Ioana','1995-08-20',2050,'Ghid turisti',3),
('Popa','Eugen','1999-11-17',2300,'Agent',3)

SELECT * FROM Angajati


-- ADAUGARE IN LOCATII
INSERT INTO Locatii(Continent,Tara,Oras)
VALUES ('Europa','Suedia','Stockholm'),
('Europa','Olanda','Amsterdam'),
('Europa','Spania','Barcelona'),
('Europa','Franta','Paris'),
('Europa','Germania','Berlin'),
('Europa','Germania','Dortmund'),
('Asia','Japonia','Tokyo'),
('Asia','Singapore','Singapore'),
('Asia','Hong Kong','Hong Kong'),
('Asia','Indonezia','Bali'),
('America de sud','Brazilia','Rio de Janeiro'),
('America de sud','Peru','Cusco'),
('America de nord','Canada','Vancuver'),
('Africa','Kenya','Nairobi'),
('Africa','Seychelles','Victoria')

SELECT * FROM Locatii


-- ADAUGARE IN ATRACTII
INSERT INTO Atractii(Denumire,PretBilet,Tip,IDLocatie)
VALUES ('Muzeul Vasa',50,'Cultural',1),
('Muzeul Van Gogh',25,'Cultural',2),
('Vondelpark',0,'Parc',2),
('Sagrada Familia',32,'Religios',3),
('Camp Nou',70,'Sportiv',3),
('Notre-Dame',70,'Religios',4),
('Turnul Eiffel',250,'Istoric',4),
('Zidul Berlinului',0,'Istoric',5),
('Poarta Brandenburg',0,'Istoric',5),
('Signal Iduna Park',100,'Sportiv',6),
('Gardens by the Bay',150,'Botanic',8),
('Chinatown',0,'Cultural',8),
('Tegallalang și terasele de orez Jatiluwih',0,'Botanic',10),
('Templul Lempuyang',20,'Religios',10),
('Statuie Cristos',100,'Religios',11),
('Favelele',0,'Cultural',11),
('Maciupiciu',200,'Istoric',12),
('Mahe',0,'Plaja',15),
('Praslin',0,'Plaja',15),
('Sursa d Argent',0,'Plaja',15)

SELECT * FROM Atractii


-- ADAUGARE IN ATRACTII
INSERT INTO Cazari(Denumire,Stele,Tip,CheckIn,CheckOut,IDLocatie)
VALUES ('Marina Bay Sands',5,'Hotel','14:00:00','12:00:00',8),
('IBIS',3,'Hotel','14:00:00','13:00:00',2),
('Royal Ramblas',4,'Hotel','12:00:00','10:30:00',3),
('Le Parisis',4,'Hotel','12:00:00','11:30:00',4),
('Mercure',3,'Hotel','12:00:00','10:00:00',7),
('IBIS',2,'Hotel','14:00:00','13:00:00',7),
('IBIS',2,'Hotel','14:00:00','13:00:00',8),
('Grand Hyatt',5,'Resort','16:00:00','12:00:00',10),
('Hilton Resort&Spa',1,'Resort','14:30:00','12:00:00',15),
('Generator',3,'Hostel','16:30:00','13:00:00',1),
('Che Lagarto',3,'Hostel','15:00:00','10:30:00',11),
('Puka Packers',1,'Hostel','12:00:00','10:00:00',12),
('My cozy place',2,'Aparatament','12:00:00','10:00:00',13),
('Yo-Shi House',1,'Aparatament','13:00:00','11:00:00',9)

SELECT * FROM Cazari


-- ADAUGARE IN CAMERE
INSERT INTO Camere(Capacitate,Disponibilitate,PretNoapte,IDCazare)
VALUES (4,1,550,1),
(2,1,300,1),
(4,1,150,2),
(3,0,120,3),
(2,1,350,4),
(4,0,110,5),
(3,1,150,6),
(3,0,150,7),
(2,1,2500,8),
(2,1,3000,9),
(1,1,25,10),
(1,0,15,11),
(1,1,10,12),
(6,0,150,13),
(6,1,250,14)

SELECT * FROM Camere


-- ADAUGARE IN SEJURURI
INSERT INTO Sejururi(Pret,DataInceput,DataSfarsit,Transport,IDAgentie)
VALUES (300,'2022-08-03','2022-08-15','Avion',1),
(250,'2022-04-20','2022-04-27','Avion',1),
(275,'2022-04-02','2022-04-07','Autocar',1),
(1500,'2022-07-10','2022-07-30','Avion',2),
(150,'2022-07-22','2022-07-26','Tren',3),
(370,'2022-12-21','2023-01-04','Autocar',3),
(299,'2021-12-03','2021-12-15','Tren',1)

SELECT * FROM Sejururi


-- ADAUGARE IN SEJURURI-LOCATII
INSERT INTO SejururiLocatii(IDSejur,IDLocatie)
VALUES (1,1),
(2,2),
(2,4),
(2,5),
(3,6),
(3,11),
(4,15),
(4,8),
(5,8),
(5,9),
(5,7),
(6,12),
(6,13),
(5,5),
(7,5)

SELECT * FROM SejururiLocatii


-- ADAUGARE IN SEJURURI-LOCATII
INSERT INTO ClientiSejururi(IDClient,IDSejur)
VALUES (6,1),
(6,2),
(6,3),
(7,4),
(9,1),
(9,2),
(10,6),
(12,3),
(14,2),
(15,4),
(15,1)

SELECT * FROM ClientiSejururi