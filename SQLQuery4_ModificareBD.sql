USE Turism
GO

--modifica tipul unei coloana
CREATE PROCEDURE do_pr1
AS
	ALTER TABLE Clienti
	ALTER COLUMN Prenume VARCHAR(50)
	PRINT 'Lungimea Prenume=50'
GO

CREATE PROCEDURE undo_pr1
AS
	ALTER TABLE Clienti
	ALTER COLUMN Prenume VARCHAR(100)
	PRINT 'Lungimea Prenume=100'
GO


--adauga/şterg o costrângere de “valoare implicită” pentru un câmp
CREATE PROCEDURE do_pr2
AS
	ALTER TABLE Agentii
	ADD CONSTRAINT default_site DEFAULT 'www.CompanyName.com' FOR SiteWeb
	PRINT 'Am adaugat constrangere pentru site web'
GO

CREATE PROCEDURE undo_pr2
AS
	ALTER TABLE Agentii
	DROP CONSTRAINT default_site
	PRINT 'Am sters constrangerea pentru site web'
GO


--creea/şterge o tabelă
CREATE PROCEDURE do_pr3
AS
	CREATE TABLE Recenzii (IDRecenzie INT PRIMARY KEY, Nume VARCHAR(30) DEFAULT 'Anonim', Stele INT NOT NULL)
	PRINT 'Am creat tabela Recenzii'
GO

CREATE PROCEDURE undo_pr3
AS
	DROP TABLE Recenzii
	PRINT 'Am sters tabela Recenzii'
GO


--adăuga/şterge un câmp nou
CREATE PROCEDURE do_pr4
AS
	ALTER TABLE Recenzii
	ADD IDCazare INT
	PRINT 'Am adaugat coloana IDCazare in tabela Recenzii'
GO

CREATE PROCEDURE undo_pr4
AS
	ALTER TABLE Recenzii
	DROP COLUMN IDCazare
	PRINT 'Am sters coloana IDCazare in tabela Recenzii'
GO


--creea/şterge o constrângere de cheie străină
CREATE PROCEDURE do_pr5
AS
	ALTER TABLE Recenzii
	ADD CONSTRAINT key_cazare_recenzie FOREIGN KEY (IDCazare) REFERENCES Cazari(IDCazare)
	PRINT 'Am adaugat constrangere pentru cheia IDCazare in tabela Recenzii'
GO

CREATE PROCEDURE undo_pr5
AS
	ALTER TABLE Recenzii
	DROP CONSTRAINT key_cazare_recenzie
	PRINT 'Am sters constrangerea pentru cheia IDCazare in tabela Recenzii'
GO


--Tabel Versiuni
CREATE TABLE Versiuni(Versiune INT DEFAULT 0)


--Procedura Main
create procedure Main
@vers varchar(10) = null
as
begin
	
	if @vers is null or isnumeric(@vers) != 1
	begin
		print 'Argument invalid'
		return
	end

	declare @versiune int
	set @versiune = convert(varchar(5), @vers)

	if @versiune not between 0 and 5
	begin
		print 'Versiune trebuie sa fie intre 0 si 5'
		return
	end

	declare @curent int 
	select @curent = Versiune from Versiuni
	if @curent = @versiune
	begin
		print 'Sunteti in aceasta versiune'
		return
	end

	print 'Incep modificarile:'
	--do
	while @curent < @versiune
	begin
		print convert(varchar(3), @curent) + '->' + convert(varchar(3), @curent + 1)
		set @curent = @curent + 1
		declare @do_procedura varchar(10)
		set @do_procedura = 'do_pr' + convert(varchar(3), @curent)
		exec @do_procedura
		update Versiuni set Versiune = @curent
	end

	--undo
	while @curent > @versiune
	begin
		print convert(varchar(3), @curent) + '->' + convert(varchar(3), @curent - 1)
		declare @undo_procedura varchar(10)
		set @undo_procedura = 'undo_pr' + convert(varchar(3), @curent)
		exec @undo_procedura
		set @curent = @curent - 1
		update Versiuni set Versiune = @curent
	end

	print 'Baza de date modificata :)'
end


--Utilizare proceduri
EXEC Main 0


--Drop proceduri
DROP PROCEDURE Main

DROP PROCEDURE do_pr1
DROP PROCEDURE do_pr2
DROP PROCEDURE do_pr3
DROP PROCEDURE do_pr4
DROP PROCEDURE do_pr5

DROP PROCEDURE undo_pr1
DROP PROCEDURE undo_pr2
DROP PROCEDURE undo_pr3
DROP PROCEDURE undo_pr4
DROP PROCEDURE undo_pr5
