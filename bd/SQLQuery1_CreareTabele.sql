create database Turism
go
use Turism
go

create table Clienti(
IDClient int primary key identity,
Nume varchar(50) not null,
Prenume varchar(100) not null,
DataNastere date,
Telefon varchar(15) not null,
Email varchar(150)
)

create table Agentii(
IDAgentie int primary key identity,
Denumire varchar(50) not null,
DataInfiintare date,
SiteWeb varchar(55)
)

create table Angajati(
IDAngajat int primary key identity,
Nume varchar(50) not null,
Prenume varchar(100) not null,
DataNastere date,
Salariu int check(Salariu>=1500) not null,
Functie varchar(30),
IDAgentie int foreign key references Agentii(IDAgentie)
)

create table Sejururi(
IDSejur int primary key identity,
Pret int,
DataInceput date,
DataSfarsit date,
Transport varchar(30),
IDAgentie int foreign key references Agentii(IDAgentie)
)

create table ClientiSejururi(
IDClient int foreign key references Clienti(IDClient),
IDSejur int foreign key references Sejururi(IDSejur),
constraint pk_ClientiSejururi primary key (IDClient,IDSejur)
)

create table Locatii(
IDLocatie int primary key identity,
Continent varchar(50),
Tara varchar(50) not null,
Oras varchar(50) not null
)

create table SejururiLocatii(
IDSejur int foreign key references Sejururi(IDSejur),
IDLocatie int foreign key references Locatii(IDLocatie),
constraint pk_SejururiLocatii primary key (IDSejur,IDLocatie)
)

create table Atractii(
IDAtractie int primary key identity,
Denumire varchar(50) not null,
PretBilet int default 0,
Tip varchar(30),
IDLocatie int foreign key references Locatii(IDLocatie)
)

create table Cazari(
IDCazare int primary key identity,
Denumire varchar(50) not null,
Stele int check(Stele>=0 AND Stele<=5) not null,
Tip varchar(30) default 'hotel',
CheckIn time default '14:00:00',
CheckOut time default '12:00:00',
IDLocatie int foreign key references Locatii(IDLocatie)
)

create table Camere(
IDCamera int primary key identity,
Capacitate int check(Capacitate>0) not null,
Disponibilitate bit default 0,
PretNoapte int,
IDCazare int foreign key references Cazari(IDCazare)
)
