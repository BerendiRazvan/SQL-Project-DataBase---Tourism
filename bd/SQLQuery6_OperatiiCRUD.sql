USE Turism
GO


--Tabele: Clienti, Sejururi, ClintiSejururi



--Validari Date


go
create or alter function dbo.ValidVarchar(@var varchar(150))
returns int
as
begin
	--verificam varcharul sa nu fie null (Clineti: Nume,Prenume; Sejururi:Transport)
	
	declare @rez int

	if len(@var) > 0 and len(@var) < 50 
		set @rez = 1
	else
		set @rez = 0

	return @rez

end
go


go
create or alter function dbo.ValidMail(@var varchar(150))
returns int
as
begin
	--verificam ca mailul sa contina @ (Clienti: Mail)
	
	declare @rez int

	if len(@var) > 0 and len(@var) < 150 AND @var like '%@%'
		set @rez = 1
	else		
		set @rez = 0

	return @rez

end
go



go
create or alter function dbo.ValidTelefon(@var varchar(100))
returns int
as
begin
	--verificam ca nr telefon sa aiba 07.... (Clienti: Telefon)

	declare @rez int

	if len(@var) > 0 and len(@var) < 14 and ISNUMERIC(@var) = 1
		set @rez = 1
	else
		set @rez = 0

	return @rez

end
go


go
create or alter function dbo.ValidPret(@var int)
returns int
as
begin
	--validam pretul sa fie mai mare decat 0 (Sejururi: Pret)
		
	declare @rez int

	if @var > 0 
		set @rez = 1
	else
		set @rez = 0

	return @rez

end
go


go
create or alter function dbo.ValidDate(@varD1 date, @varD2 date)
returns int
as
begin
	--validam data inceput si final (Clienti: DataNastere; Sejururi: DataInceput,DataSfarsit)
		
	declare @rez int

	if DATEDIFF(DAY,@varD1,@varD2) > 0
		set @rez = 1
	else
		set @rez = 0

	return @rez

end
go


go
create or alter function dbo.ValidareIdAgentie(@var int)
returns int
as
begin
	--validam daca exista id-ul (Sejururi: IdAgentie)

	declare @rez int

	if exists(select IDAgentie from Agentii where IDAgentie = @var)
		set @rez = 1
	else
		set @rez = 0

	return @rez

end
go


go
create or alter function dbo.ValidareIdClient(@var int)
returns int
as
begin
	--validam daca exista id-ul (ClientiSejururi: IdClient)
	
	declare @rez int

	if exists(select IDClient from Clienti where IDClient = @var)
		set @rez = 1
	else
		set @rez = 0

	return @rez

end
go


go
create or alter function dbo.ValidareIdSejur(@var int)
returns int
as
begin
	--validam daca exista id-ul (ClientiSejururi: IdSejur)
	
	declare @rez int

	if exists(select IDSejur from Sejururi where IDSejur = @var)
		set @rez = 1
	else
		set @rez = 0

	return @rez

end
go


go
create or alter function dbo.ValidCombClientSejur(@varID1 int, @varID2 int)
returns int
as
begin
	--validam daca exista id-ul perechea  client-sejur
	
	declare @rez int

	if exists(select * from ClientiSejururi where IDClient = @varID1 and IDSejur = @varID2)
		set @rez = 0
	else
		set @rez = 1

	return @rez

end
go



--CRUD Clienti

go
create or alter procedure ClientiCRUD
@Nume varchar(50),
@Prenume varchar(50),
@DataNastere date,
@Telefon varchar(15),
@Email varchar(150)
as
begin
	declare @ok int
	set @ok = 1

	if (dbo.ValidVarchar(@Nume) = 0)
	begin
		set @ok = 0
		print 'Nume invalid'
	end

	if (dbo.ValidVarchar(@Prenume) = 0)
	begin
		set @ok = 0
		print 'Prenume invalid'
	end

	if (dbo.ValidDate(@DataNastere,GETDATE()) = 0)
	begin
		set @ok = 0
		print 'DataNastere invalida'
	end

	if (dbo.ValidTelefon(@Telefon) = 0)
	begin
		set @ok = 0
		print 'Telefon invalid'
	end

	if (dbo.ValidMail(@Email) = 0)
	begin
		set @ok = 0
		print 'Email invalid'
	end

	if (@ok = 1)
	begin

		print 'START CRUD'
		set nocount on;
		
		--Create
		insert into Clienti(Nume, Prenume, DataNastere, Telefon, Email) values (@Nume, @Prenume, @DataNastere, @Telefon, @Email);
		declare @id int;
		set @id = @@identity;

		--Read
		select * from Clienti;

		--Update
		update Clienti set Email = @Nume + @Prenume + '@gmail.com' where Nume = @Nume and @Prenume = Prenume;

		--Delete 
		delete from Clienti where IDClient = @id

		print 'FINISH CRUD'

	end
	else
	begin
		print 'ERROR CRUD';
	end
end
go

--Valid exec:
exec ClientiCRUD 'Pop','Alex','2005-12-20','0740233549','pop_alex77@yahoo.com' 

--Invalid exec:
exec ClientiCRUD '','','2005-12-20','','pop_alex77@yahoo.com'

SELECT * FROM Clienti


--CRUD Sejururi

go
create or alter procedure SejururiCRUD
@Pret int,
@DataInceput date,
@DataSfarsit date,
@Transport varchar(30),
@IdAgentie int
as
begin
	declare @ok int
	set @ok = 1

	if (dbo.ValidPret(@Pret) = 0)
	begin
		set @ok = 0
		print 'Pret invalid'
	end

	if (dbo.ValidDate(@DataInceput,@DataSfarsit) = 0)
	begin
		set @ok = 0
		print 'Perioada sejur invalida'
	end

	if (dbo.ValidVarchar(@Transport) = 0)
	begin
		set @ok = 0
		print 'Transport invalid'
	end

	if (dbo.ValidareIdAgentie(@IdAgentie) = 0)
	begin
		set @ok = 0
		print 'ID Agentie invalid'
	end

	if (@ok = 1)
	begin

		print 'START CRUD'
		set nocount on;
		
		--Create
		insert into Sejururi(Pret, DataInceput, DataSfarsit, Transport, IDAgentie) values (@Pret, @DataInceput, @DataSfarsit, @Transport, @IdAgentie);
		declare @id int;
		set @id = @@identity;

		--Read
		select * from Sejururi;

		--Update
		update Sejururi set Pret = 200  where IDSejur = @id;

		--Delete 
		delete from Sejururi where IDSejur = @id

		print 'FINISH CRUD'

	end
	else
	begin
		print 'ERROR CRUD';
	end
end
go

--Valid exec:
exec SejururiCRUD 199,'2020-11-20','2020-11-25','Avon',1

--Invalid exec:
exec SejururiCRUD -2,'2020-11-20','2020-10-25','',100
exec SejururiCRUD 199,'2020-11-20','2020-10-25','Avon',1

SELECT * FROM Clienti


--CRUD ClintiSejururi

go
create or alter procedure ClientiSejururiCRUD
@IdClient int,
@IdSejur int
as
begin
	declare @ok int
	set @ok = 1

	if (dbo.ValidareIdClient(@IdClient) = 0)
	begin
		set @ok = 0
		print 'Id Sejur invalid'
	end

	if (dbo.ValidareIdSejur(@IdSejur) = 0)
	begin
		set @ok = 0
		print 'Id Sejur invalid'
	end

	if (dbo.ValidCombClientSejur(@IdClient,@IdSejur) = 0)
	begin
		set @ok = 0
		print 'Perechea (Id Client - Id Sejur) exista deja'
	end

	if (@ok = 1)
	begin

		print 'START CRUD'
		set nocount on;
		
		--Create
		insert into ClientiSejururi(IDClient,IDSejur) values (@IdClient,@IdSejur);

		--Read
		select * from ClientiSejururi;
		
		--Update
		update ClientiSejururi set Obs = 'Observatie'  where IDClient = @IdClient and IDSejur = @IdSejur;
		
		--Delete 
		delete from ClientiSejururi where IDClient = @IdClient and IDSejur = @IdSejur;

		print 'FINISH CRUD'

	end
	else
	begin
		print 'ERROR CRUD';
	end
end
go

--Valid exec:
exec ClientiSejururiCRUD 1,2

--Invalid exec:
exec ClientiSejururiCRUD 1,1
exec ClientiSejururiCRUD 10230,12312

SELECT * FROM ClientiSejururi



--INDEXARE + View1 si View2


IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='index_Clienti')
DROP INDEX  index_Clienti on Clienti
CREATE NONCLUSTERED INDEX index_Clienti on Clienti(Nume)

--Cat are de platit fiecare client
go
create or alter view View1_Clienti
as
	SELECT c.Nume, SUM(s.Pret) As TotalDePlata
	FROM Clienti c INNER JOIN ClientiSejururi cs on c.IDClient = cs.IDClient 
	INNER JOIN Sejururi s on s.IDSejur = cs.IDSejur
	Group By c.Nume
go

select * from View1_Clienti




IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='index_Sejururi')
DROP INDEX index_Sejururi on Sejururi
CREATE NONCLUSTERED INDEX index_Sejururi on Sejururi(Transport)

--Cati calatori sunt pentru fiecare tip de transport
GO
CREATE OR ALTER VIEW View2_Sejururi
AS
	SELECT s.Transport, count(c.IDClient) as Calatori
	FROM Sejururi s INNER JOIN ClientiSejururi cs on s.IDSejur = cs.IDSejur
	INNER JOIN Clienti c on c.IDClient = cs.IDClient
	Group By s.Transport
GO

select * from View2_Sejururi