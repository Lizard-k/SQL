use [s12-31]
go


--wprowadznie
create table t (id int, k1 varchar(10))
insert into t values
(1, 'Styczen'),
(2, 'Luty')


--zmiana nazwy kolumny tabeli
sp_rename 't.k1', 'k2', 'column';
select * from t

-- zmiana nazwy tabeli
sp_rename 't', 'tab'
select * from tab

--tworzenie kopii tabeli
select * into kopia from tab
select * from kopia

--zmiana typu danych
alter table kopia alter column k2 char(100)

--dodawanie nowej kolumny
alter table kopia add k3 numeric(2)
select * from kopia

--ussuwanie kolumny
alter table kopia drop column k2
select * from kopia

--dodawanie indeksu do kolumn
create index t_index on tab(k2) 

--usuwanie indeksu
drop index t_indeks on tab

--usuwanie tabel
drop table tab
drop table kopia

--zad 1
create table Pracownicy
(idpracownika numeric(2) identity(1,1) primary key,
imie varchar(20),
nazwisko varchar(20),
wiek numeric(3),
dzial char(3))

insert into Pracownicy values
('Jan', 'Nowak', 27, 'INF'),
('Adam', 'Kowalski',26,'MAN'),
('Anna','Nowak',24,'MGT'),
('Ewa','Kowalska',23,'ACC')
select * from Pracownicy

--zad 2
select idpracownika as iduzytkownika, imie, nazwisko, wiek 
 into Uzytkownicy
from Pracownicy

select * from uzytkownicy

--zad 3 Na podstawie tabeli o nazwie Pracownicy, utworzyæ jej dok³adn¹ kopiê o nazwie Studenci, kopiuj¹c definicjê oraz zawartoœæ tej tabeli dla osób maj¹cych mniej ni¿ 25 lat, jednoczeœnie zmieniaj¹c nazwê kolumny idpracownika na idstudenta. Wyœwietliæ zawartoœæ tabeli Studenci.
select idpracownika as idstudenta, imie, nazwisko, wiek, dzial
into Studenci
from Pracownicy
where wiek<25
select * from Studenci

--zad 4 W tabeli Uzytkownicy usun¹æ wiersze dla osób, które maj¹ mniej ni¿ 25 lat i nazwisko rozpoczynaj¹ce siê od litery K. Zweryfikowaæ poprawnoœæ.
delete from Uzytkownicy where wiek<25 and nazwisko like 'K%'
select * from Uzytkownicy

--zad 5
drop table Uzytkownicy
drop table Studenci

--zad 6
create table region
(idregiony numeric(2) primary key,
nazwa varchar(20),
idpracownika numeric (2) foreign key (idpracownika)
references Pracownicy(idpracownika))

insert into region values
(1, 'pomorskie', 4),
(2, 'zachodniopomorskie',2),
(3, 'warminsko-mazurskie',3)
--weryfikacja
select * from Pracownicy p, region r
where p.idpracownika=r.idpracownika
--zdaanie 7
create table osoba
(id numeric(2) primary key,
imie varchar(20),
nazwisko varchar(20),
pesel varchar(11) unique,
data_urodzenia date)

 select * from osoba

 sp_rename 'Osoba', 'Pracownik'
 select * from osoba 
 select * from pracownik

 --9 zadanie
 alter table pracownik add dzial varchar(20), wyksztalcenia varchar(20)

 select * from Pracownik 

 update pracownik set dzial='Organizacyjny'
 update pracownik set wyksztalcenia='Wyzsze' where id<3

 --10 zad
 select *into pracownik_kopia from pracownik
 select * from pracownik_kopia

 -- 11
 alter table pracownik_kopia drop column pesel

 select * from pracownik_kopia

 --12 
 alter table pracownik_kopia alter column nazwisko varchar (40)
 --13
 sp_rename 'pracownik_kopia.id', 'id_pracownika', 'column'

 --14
 create index pracownik_imie_nazwisko on pracownik(imie,nazwisko)
  
 select * from Pracownik where nazwisko like '%ska'

 --15
 drop index pracownik_imie_nazwisko on pracownik



