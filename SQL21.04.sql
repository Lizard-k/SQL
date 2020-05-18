create table osoba(id numeric(6) primary key identity(100000,10),
imie varchar(30),
nazwisko varchar(50),
wiek numeric(3,0),
data_dodania date default getdate());



insert into osoba(imie,nazwisko,wiek)
values
('Jan','Kowalski',35),
('Anna','Nowak',30),
('Ewa','Zieli�ska',38),
('Adam','Wo�niak',31);

 --wprowadzenie
 create table t(id int)
 GO
 create trigger t1
 on t
 for insert
 as
 begin	
	declare @liczba as integer
	select @liczba=id from t
	print 'Wstawiono liczbe '+cast(@liczba as varchar(10))
	end 
go
insert into t values (10)
go 
create trigger t2
on t
for insert --before
as 
begin
	print 'Trigger t2'
end 
go
insert into t values (20)
go
create trigger t3
on t
after insert, update, delete
as
begin
	print 'Trigger t3'
end
go 
insert into  t values (30)
go
 
 --3. Utworzy� wyzwalacz o nazwie DodanoOsobe na tabeli o nazwie Osoba, kt�ry b�dzie informowa� u�ytkownika, �e wiersz 
 --zosta� dodany. Doda� jeden wiersz do tabeli.
 create trigger DodanoOsobe
 on Osoba
 for insert 
as 
begin
	print 'Wiersz zostal dodany'
end 
go
insert into osoba (imie,nazwisko,wiek) values ('Adam','Adamski',20)
--3a
go
 create trigger WiekOsoby
 on Osoba
 for insert 
as 
begin
	declare @wiek as integer
	select @wiek=wiek from osoba
	print 'Dodane osobe w wieku' +cast(@wiek as varchar(10))
end 
go
insert into osoba (imie, nazwisko, wiek) values ('Ewa', 'Adamowska', 21)


--4. Usun�� wyzwalacz o nazwie DodanoOsobe.
drop trigger DodanoOsobe
drop trigger WiekOsoby

--5. Utworzy� wyzwalacz o nazwie ModyfikujOsobe, kt�ry zablokuje mo�liwo�� modyfikacji wierszy w tabeli o nazwie Osoba.
--Wywo�ywanie instrukcji INSERT na tabeli osoba ma dodatkowo generowa� wyj�tek.
go
create trigger ModyfikujOsobe
on Osoba
 for insert, update, delete
as 
begin
	rollback transaction 
	raiserror ('Osoby nie mozna modyfikowac', 1,1)
end 
go 
insert into osoba (imie,nazwisko,wiek) values ('Adam', 'Nowacki',22)

select * from osoba 


--6. Usun�� wyzwalacz o nazwie ModyfikujOsobe.
drop trigger modyfikujosobe

--7. Utworzy� wyzwalacz o nazwie DodanoOsoby na tabeli o nazwie Osoba, kt�ry b�dzie wy�wietla� imi� i nazwisko nowo 
--dodawanej osoby (warto�ci). Przetestowa� dzia�anie.
go
create trigger DodanoOsobe1 
on osoba
 for insert 
as 
declare @imie as varchar (20), 
@nazwisko as varchar (20)
Begin
select @imie=imie from osoba
select @nazwisko=nazwisko from osoba
	print 'Dodano osobe o imieniu '+@imie+' nazwisku ' +@nazwisko
end 
go
insert into osoba (imie,nazwisko,wiek) values ('Adam', 'Nowacki',22)

--8. Usun�� wyzwalacz o nazwie DodanoOsoby.
drop trigger Dodanoosobe1

--9. Utworzy� wyzwalacz o nazwie SprawdzWiek, kt�ry zablokuje mo�liwo�� wprowadzenia osoby w wieku innymi ni� w przedziale 
--0-120 lat.
go
create trigger SprawdzWiek
on osoba
for insert, update 
as 
begin
declare @wiek as int
select @wiek=wiek 
from osoba
if @wiek not between 0 and 120
begin
rollback transaction
raiserror ('Niepoprawny wiek',1,1)
end
end
go
insert into osoba (imie,nazwisko,wiek) values ('Anna', 'Nowacka', 122)
select * from osoba

--10. Doda� now� osob� w wieku 130 lat. Sprawdzi� zawarto�� tabeli.
insert into osoba (imie,nazwisko,wiek) values ('Anna', 'Nowacka', 130)
--11. Usun�� wyzwalacz o nazwie SprawdzWiek.
-- opcjonalne
drop trigger sprawdzwiek

--12. Zmieni� wiek wszystkich os�b dodaj�c im 90 lat. Sprawdzi� zawarto�� tabeli.
update osoba set wiek+=90
select * from osoba

--13. Zmieni� wiek o 90 lat osobom, kt�rych wiek po zmianie nie przekroczy 120 lat. Sprawdzi� zawarto�� tabeli.
update osoba set wiek-=90
--
update osoba set wiek+=90
where wiek+90 <= 120
select * from osoba

--14. Utworzy� wyzwalacz DodajDane, kt�ry w momencie dodawania danych b�dzie wy�wietla� zawarto�� tabeli, zgodn� z wiekiem 
--wprowadzanych os�b.
-- je�eli b�dziemy dodawali osob� w wieku 23 lat, to ma 
-- wy�wietli� wszystkie osoby w tym wieku, kt�re s� w tabeli
go
create trigger DodajDane
on osoba
for insert
as 
begin
	declare @wiek as int, @zapytanie as varchar(200) 
	select @wiek = wiek from osoba
	set @zapytanie='select * from osoba where wiek = ' +cast(@wiek as varchar(3))
	exec (@zapytanie)
end
go
--2
--go
--create trigger DodajDane
--on osoba
--for insert
--as 
--begin
--	declare @wiek as int
--	select @wiek = wiek from osoba
--	select * from osoba where wiek = @wiek
--end
--go

--Przetestowa� dzia�anie i usun�� trigger.
drop trigger DodajDane

--15
go
create trigger g1
on osoba 
after insert,update,delete
as
begin
select *from osoba
end 
go
insert into osoba (imie,nazwisko,wiek) values('Ewa','Kowalska',33)
update osoba set wiek+=1
delete from osoba where imie='Ewa' and nazwisko='Kowalska'
drop trigger g1
--16. Utworzy� now� tabel� o nazwie grupa, kt�ra b�dzie przechowywa�a informacj� o numerach grup i numerach student�w.
--Po dodaniu nowego wiersza powinna si� wy�wietla� informacja jaki student (z tabeli osoba) zosta� przypisany do grupy,
--poprzez wyzwalacz GrupaStudencka.
--Przetestowa� dzia�anie i usun�� trigger.
--Przetestowa� dzia�anie i usun�� trigger.
create table grupa (numer varchar (10), id numeric(6))

insert into grupa values ('S1231',100020)
go
create trigger wyswietl
on grupa
for insert 
as 
begin
    declare @id as numeric(6), @numer as varchar(10),
    @imie varchar(20), @nazwisko varchar(30)
    select @id=id from grupa
    select @numer=numer from grupa
    select @imie=imie, @nazwisko=nazwisko FROM osoba where id=@id
    print 'Dodano u�ytkownika '+cast(@id as varchar(6)) + space(1)+ @imie+space(1)+@nazwisko+' do grupy '+ @numer
end
go
insert into grupa values ('S1231',100010)
go
