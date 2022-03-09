USE Turism
GO


--Testare BAZA DATE
EXEC TestDB


--Date testare
INSERT INTO Tests(Name) VALUES ('Test Clienti')
INSERT INTO Tests(Name) VALUES ('Test Sejururi')
INSERT INTO Tests(Name) VALUES ('Test ClientiSejururi')

INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (1,1,10000,1)
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (2,1,10000,3)
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (2,2,10000,2)
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (2,3,10000,1)
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (3,1,10000,3)
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (3,2,10000,2)
INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES (3,3,10000,1)

DELETE FROM TestTables


INSERT INTO TestViews(TestID,ViewID) VALUES (1,1)
INSERT INTO TestViews(TestID,ViewID) VALUES (2,2)
INSERT INTO TestViews(TestID,ViewID) VALUES (3,3)


--Adaugare tabele care urmeaza sa fie testate
INSERT INTO Tables(Name) 
VALUES ('Clienti'),('Sejururi'),('ClientiSejururi');


--Creare si adaugare views
CREATE or ALTER VIEW View1 AS
SELECT * 
FROM Clienti
GO

CREATE or ALTER VIEW View2 AS
SELECT c.IDClient, c.Nume, c.Prenume, s.IDSejur, s.Transport
FROM Clienti c INNER JOIN ClientiSejururi cs on c.IDClient = cs.IDClient 
INNER JOIN Sejururi s on s.IDSejur = cs.IDSejur
GO

CREATE or ALTER VIEW View3 AS
SELECT c.IDClient, c.Nume, c.Prenume, COUNT(s.IDSejur) AS NrVacante
FROM Clienti c INNER JOIN ClientiSejururi cs on c.IDClient = cs.IDClient 
INNER JOIN Sejururi s on s.IDSejur = cs.IDSejur
GROUP BY c.IDClient, c.Nume, c.Prenume
GO

INSERT INTO Views(Name) VALUES ('View1'),('View2'),('View3');


--PROCEDURI:

--Procedura inserare Clienti
CREATE OR ALTER PROCEDURE InsertClienti
@Rows INT
AS
BEGIN
	DECLARE @i int = 0;
	DECLARE @numePers varchar(50);
	DECLARE @prenumePers varchar(50);
	DECLARE @dataNastere date;
	DECLARE @nrTelefon varchar(15);
	DECLARE @email varchar(150);

	WHILE @i < @Rows
	BEGIN
		SET @numePers = 'Nume' + CONVERT(varchar(10),@i);
		SET @prenumePers = 'Prenume' + CONVERT(varchar(10),@i);
		SET @dataNastere = GETDATE();
		SET @nrTelefon = '07' + CONVERT(varchar(10),@i);
		SET @email = @numePers + @prenumePers + '@gmail.com';
		INSERT INTO Clienti(Nume,Prenume,DataNastere,Telefon,Email) VALUES (@numePers,@prenumePers,@dataNastere,@nrTelefon,@email);
		SET @i = @i + 1;
	END
END
GO

EXEC InsertClienti 100
SELECT * FROM Clienti

DELETE FROM Clienti
DBCC CHECKIDENT ('Clienti', RESEED, 0);


--Procedura inserare Sejururi
CREATE OR ALTER PROCEDURE InsertSejururi
@Rows INT
AS
BEGIN
	DECLARE @i int = 0;
	DECLARE @pret int = 1;
	DECLARE @dataInceput date;
	DECLARE @dataFinal date;
	DECLARE @transport varchar(30);
	DECLARE @IDAgentie int;

	SELECT @IDAgentie = COUNT(*) FROM Agentii
	IF @IDAgentie = 0
	BEGIN
		PRINT 'TABELA Agentii TREBUIE SA AIBA MINIM O AGENTIE'
		RETURN
	END

	SELECT TOP 1 @IDAgentie = IDAgentie  FROM Agentii

	WHILE @i < @Rows
	BEGIN
		SET @pret = @i + 100;
		SET @dataInceput = GETDATE();
		SET @dataFinal = GETDATE();
		SET @transport = 'Transport' + CONVERT(varchar(10),@i);
		INSERT INTO Sejururi(Pret,DataInceput,DataSfarsit,Transport,IDAgentie) VALUES (@pret,@dataInceput,@dataFinal,@transport,@IDAgentie)
		SET @i = @i + 1;
	END
END
GO

EXEC InsertSejururi 100
SELECT * FROM Sejururi

DELETE FROM Sejururi
DBCC CHECKIDENT ('Sejururi', RESEED, 0);


--Procedura inserare ClientiSejururi
CREATE OR ALTER PROCEDURE InsertClientiSejururi
@Rows INT
AS
BEGIN
	DECLARE @i int = 1;
	DECLARE @j int = 1;
	DECLARE @r int = 1;

	DECLARE @nr int
	SELECT @nr=COUNT(*) FROM Clienti
	IF @nr < @Rows or @nr = 0
	BEGIN
		PRINT 'ATENTIE! NU SUNT SUFICIENTEDATE IN TABELA Clienti!'
		RETURN
	END
	SELECT @nr=COUNT(*) FROM Sejururi
	IF @nr < @Rows or @nr = 0
	BEGIN
		PRINT 'ATENTIE! NU SUNT SUFICIENTEDATE IN TABELA Sejururi!'
		RETURN
	END

	
	WHILE @r <= @Rows
	BEGIN
		
		SELECT @i = IDClient FROM Clienti Where IDClient = @r
		SELECT @j = IDSejur FROM Sejururi Where IDSejur = @r

		DECLARE @OK int = 0;
		SELECT @OK = IDClient FROM Clienti Where IDClient = @i
		SELECT @OK = IDSejur FROM Sejururi Where IDSejur = @j
		IF @OK = 0
		BEGIN
			PRINT 'ATENTIE! DATELE DIN TABELELE Clienti SAU Sejururi NU SUNT CORECTE!'
			RETURN
		END
		INSERT INTO ClientiSejururi(IDClient,IDSejur) VALUES (@i,@j);
		
		SET @r = @r + 1;

	END
END
GO

EXEC InsertClienti 100
EXEC InsertSejururi 100
EXEC InsertClientiSejururi 100
SELECT * FROM ClientiSejururi

DELETE FROM Clienti
DELETE FROM Sejururi
DELETE FROM ClientiSejururi
DBCC CHECKIDENT ('Clienti', RESEED, 0);
DBCC CHECKIDENT ('Sejururi', RESEED, 0);


--Date din tabele
SELECT * FROM Tables
SELECT * FROM Views
SELECT * FROM Tests
SELECT * FROM TestTables
SELECT * FROM TestViews


--Procedura principala de testare
CREATE OR ALTER PROCEDURE TestDB
AS
BEGIN
	DECLARE @idTest INT, @idView INT, @noOfRows INT, @idTabel INT, @testRunId INT;
	DECLARE @numeTest NVARCHAR(2000), @numeTabel NVARCHAR(60), @numeView NVARCHAR(100);

	--RESETARE REZULTATE
	DELETE FROM TestRuns
	DBCC CHECKIDENT ('TestRuns', RESEED, 0);

	DECLARE cursorTeste CURSOR FOR
	SELECT TestId, Name FROM Tests

	OPEN cursorTeste;
	FETCH NEXT FROM cursorTeste INTO @idTest, @numeTest;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		INSERT INTO TestRuns (Description, StartAt, EndAt) VALUES (@numeTest, GETDATE(), null);

		SET @testRunId = @@IDENTITY;
		
		DECLARE cursortabele CURSOR SCROLL FOR
		SELECT Name, T.TableID, NoOfRows 
		FROM TestTables TT INNER JOIN Tables T
		ON TT.TableID = T.TableID
		WHERE TT.TestID = @idTest
		ORDER BY Position

		OPEN cursorTabele;
		FETCH NEXT FROM cursortabele INTO @numeTabel, @idTabel, @noOfRows;

		--DELETE
		WHILE @@FETCH_STATUS = 0
		BEGIN

			EXEC ('DELETE FROM ' + @numeTabel);
			if @numeTabel = 'Clienti' or @numeTabel = 'Sejururi' begin
				DBCC CHECKIDENT (@numeTabel, RESEED, 0);
			end

			FETCH NEXT FROM cursorTabele INTO @numeTabel, @idTabel, @noOfRows;

		END

		--INSERT
		FETCH PRIOR FROM cursorTabele INTO @numeTabel, @idTabel, @noOfRows;
		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE @startInsert DATETIME;
			SET @startInsert = GETDATE();

			EXEC('Insert'+@numeTabel);
			
			INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt) VALUES (@testRunId, @idTabel, @startInsert, GETDATE())

			FETCH PRIOR FROM cursorTabele INTO @numeTabel, @idTabel, @noOfRows;

		END

		CLOSE cursorTabele;
		DEALLOCATE cursorTabele;

		--VIEW
		DECLARE cursorViews CURSOR FOR
		SELECT TV.ViewID, NAME
		FROM TestViews TV INNER JOIN Views V
		ON TV.ViewID = V.ViewID
		WHERE TV.TestID = @idTest

		OPEN cursorViews;
		FETCH NEXT FROM cursorViews INTO @idView, @numeView;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @startView DATETIME;
			SET @startView = GETDATE();

			EXEC('SELECT * FROM ' + @numeView)

			INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunId, @idView, @startView, GETDATE());

			FETCH NEXT FROM cursorViews INTO @idView, @numeView;

		END

		CLOSE cursorViews;
		DEALLOCATE cursorViews;

		UPDATE TestRuns
		SET EndAt = GETDATE()
		WHERE TestRunID = @testRunId;

		FETCH NEXT FROM cursorTeste INTO @idTest, @numeTest;

	END

	CLOSE cursorTeste;
	DEALLOCATE cursorTeste;

	--REZULTATE
	SELECT * FROM TestRuns
	SELECT * FROM TestRunTables
	SELECT * FROM TestRunViews

END
GO
