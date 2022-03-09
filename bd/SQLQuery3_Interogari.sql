USE Turism
GO

-- INTEROGARI BAZA DATE


-- 1. Cat are de platit fiecare client, care merge cu avionul, pentru sejururile dorite, ordonati dupa cat au de platit descrescator
SELECT Nume, Prenume, SUM(s.Pret) as TotalDePlata
FROM Clienti c INNER JOIN ClientiSejururi cs on c.IDClient = cs.IDClient 
INNER JOIN Sejururi s on s.IDSejur = cs.IDSejur
WHERE Transport LIKE 'Avion'
GROUP BY Nume, Prenume
ORDER BY TotalDePlata DESC


-- 2. Clientii care nu au ales inca un sejur, deoarece dorim sa ii contactam
SELECT Prenume, Telefon, Email
FROM Clienti c LEFT OUTER JOIN ClientiSejururi cs on c.IDClient = cs.IDClient 
WHERE cs.IDClient IS NULL OR cs.IDSejur IS NULL


-- 3. Cate camere exista pentru fiecare locatie in care pot sta minim 4 persoane, iar hotelurile au minim 2 stele
SELECT Oras, COUNT(IDCamera) AS NumarCamere
FROM Locatii l INNER JOIN Cazari cz on l.IDLocatie = cz.IDLocatie 
INNER JOIN Camere cm on cz.IDCazare = cm.IDCazare
WHERE Stele >= 2
GROUP BY Oras
HAVING SUM(Capacitate) >= 4 


-- 4. Varsta si salariul mediu pentru fiecare companie, pentru pozitia de ghid turistic 
SELECT ag.Denumire, AVG(DATEDIFF(YEAR,an.DataNastere,GETDATE())) VarstaMedie, AVG(an.Salariu) AS SalariulMediu
FROM Agentii ag INNER JOIN Angajati an ON ag.IDAgentie = an.IDAgentie
WHERE Functie LIKE 'Ghid%'
GROUP BY ag.Denumire


-- 5. Cate orase diferite poti gasi pe site-ul agentiei, avand pretul minim la sejur 250, iar cel maxim 500 
SELECT a.SiteWeb, COUNT(l.Oras) AS NrOrase
FROM Agentii a INNER JOIN Sejururi s on s.IDAgentie = a.IDAgentie
INNER JOIN SejururiLocatii sl on s.IDSejur = sl.IDSejur
INNER JOIN Locatii l on l.IDLocatie = sl.IDLocatie
GROUP BY a.SiteWeb
HAVING MAX(s.Pret) <= 500 AND MIN(s.Pret) >=250


-- 6. Locatiile in care exista resorturi si plaje 
SELECT Tara, Oras
FROM Locatii l INNER JOIN Atractii a on l.IDLocatie = a.IDLocatie 
INNER JOIN Cazari c on l.IDLocatie=c.IDLocatie
WHERE c.Tip LIKE 'Resort' AND a.Tip LIKE 'Plaja'
GROUP BY Tara, Oras

--sau cu INTERSECT
SELECT Tara, Oras
FROM Locatii l INNER JOIN Atractii a on l.IDLocatie = a.IDLocatie 
WHERE  a.Tip LIKE 'Plaja'
INTERSECT
SELECT Tara, Oras
FROM Locatii l INNER JOIN Cazari c on l.IDLocatie=c.IDLocatie
WHERE c.Tip LIKE 'Resort'


-- 7. Cate zile sta in vacanta fiecare client in total, ordonati in functie de cat de mult stau 
SELECT Nume, Prenume, SUM(DATEDIFF(DAY,s.DataInceput,s.DataSfarsit)) as ZileInVacanta
FROM Clienti c INNER JOIN ClientiSejururi cs on c.IDClient = cs.IDClient 
INNER JOIN Sejururi s on s.IDSejur = cs.IDSejur
GROUP BY Nume, Prenume
ORDER BY ZileInVacanta DESC


-- 8. Sejururile in care se gasesc cazari(DISTINCTE) de 4-5 stele 
SELECT DISTINCT s.IDSejur, s.DataInceput, s.DataSfarsit, s.Pret
FROM Sejururi s INNER JOIN SejururiLocatii sl on s.IDSejur = sl.IDSejur
INNER JOIN Locatii l on l.IDLocatie = sl.IDLocatie
INNER JOIN Cazari c on l.IDLocatie = c.IDLocatie
WHERE Stele BETWEEN 4 AND 5


-- 9. Care sunt sejururile cu atractii gratis si cate sunt atractii de acest se gasesc
SELECT s.IDSejur, COUNT(a.IDAtractie) AS NumarAtractii
FROM Sejururi s INNER JOIN SejururiLocatii sl on s.IDSejur = sl.IDSejur
INNER JOIN Locatii l on l.IDLocatie = sl.IDLocatie
INNER JOIN Atractii a on l.IDLocatie = a.IDLocatie
WHERE PretBilet = 0
GROUP BY s.IDSejur


-- 10. Clientii care pot merge la biserica in timpul sejurului (atractie de tip Religios in acea locatie + sejur de minim 7 zile) 
SELECT DISTINCT Nume,Prenume
FROM Clienti c INNER JOIN ClientiSejururi cs on c.IDClient = cs.IDClient 
INNER JOIN Sejururi s on s.IDSejur = cs.IDSejur
INNER JOIN SejururiLocatii sl on s.IDSejur = sl.IDSejur
INNER JOIN Locatii l on l.IDLocatie = sl.IDLocatie
INNER JOIN Atractii a on l.IDLocatie = a.IDLocatie
WHERE a.Tip LIKE 'Religios' AND DATEDIFF(DAY,s.DataInceput,s.DataSfarsit) >= 7
