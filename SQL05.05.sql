--1. Sprawdzi� swoje uprawnienia na serwerze SQL.
select * from sys.fn_my_permissions(default, 'SERVER')
--2. Sprawdzi� swoje uprawnienia w bazie danych SQL.
select * from sys.fn_my_permissions(default, 'DATABASE')
--3. Utworzy� tabel� o nazwie Towar, zawieraj�ca cztery kolumny:
-- identyfikator, liczba, autoinkrementacja, klucz g��wny
-- - nazwa towaru, tekst, 20 znak�w
-- - cena, waluta
-- - data dodania, data
create table Towar 
(id int identity(1,1) primary key,
nazwa varchar(20),
cena money,
data_dodania date default getdate()) 

--4. Wykorzystuj�c autoinkrementacj� doda� do tablicy Towar trzy wiersze:
--O��wek; 1,29 z�
--Kredka; 0,52 z�
--D�ugopis; 1,32 z�
insert into towar (nazwa,cena) values
('Olowek', 1,29),
('Kredka', 0,52),
('Dlugopis', 1,32)
--5. Zmieni� uprawnienia na tabeli usuwaj�c innemu u�ytkownikowi mo�liwo�� przegl�dania zawarto�ci tabeli.
use master 
go
create login s1231 with password='student'
go
use [s12-31]
go
create user s1231 for login s1231go exec sp_addrolemember @membername='s1231',@rolename ='db_datareader'
go 
deny select on towar to s1231
--6. Sprawdzi� swoje uprawnienia na obiekcie innego u�ytkownika.
exec sp_helprotect null, 's1231'

--7. Cofn�� przyznane zablokowane wcze�niej uprawnienie do obiektu. Sprawdzi� dzia�anie.
revoke select on towar to s1231
exec sp_helprotect null, 's1231'
--8. Zablokowa� uprawnienia aktualizacji, dodawania wierszy oraz zmian w tablicy Towar dla innego u�ytkownika.
deny insert, alter, update on towar to s1231
--9. Nada� mo�liwo�� dodawania wierszy w tablicy Towar dla innych u�ytkownik�w. Sprawdzi� dzia�anie i efektywne uprawnienia 
--na tabeli Towar.
grant insert on towar to s1231
exec sp_helprotect null, 's1231' 
--10. Spr�bowa� zablokowa� wszystkie uprawnienia na obiekcie Towar dla innego u�ytkownika.
deny all on towar to s1231 --nie stosowa� 'all', nie blokuje wszystko
exec sp_helprotect null, 's1231' 
--11. Sprawdzi� jaki b�dzie dzie� za 100 dni.
select DATEADD(dd, 100, getdate())
--12. Wy�wietli� zawarto�� tabeli Towar, wypisuj�c w czwartej kolumnie dzie� tygodnia w jakim towar zosta� dodany.
select id, nazwa, cena, datename (dw, data_dodania) as 'Dzien tygodnia' from towar 

--13. Wy�wietli� w osobnych kolumnach: nazw� towaru, cen�, dzie� dodania, miesi�c dodania s�ownie, rok.
select  nazwa, cena, datename(dw, data_dodania) as 'Dzien tygodnia', datename(mm,data_dodania) as 'Miesiac'
datename(year,data_dodania) as 'rok' from towar --year(data_dodania) as rok from towar
--14. Sprawdzi� ile dni dzieli bie��c� dat� od 1 pa�dziernika bie��cego roku.
select datediff(dd, getdate(), '2020-10-01')
--15. Doda� dwa kolejne wiersze do tabeli o nast�puj�cych warto�ciach:
--Mazak czerwony; NULL
--Mazak zielony; NULL
insert into towar (nazwa,cena) values 
('Mazak czerwony', null),
('Mazak zielony', null)
--16. Wy�wietli� zawarto�� tabeli Towar, je�eli cena ma warto�� NULL to powinna wy�wietli� si� 9,99 z�.
select nazwa, data_dodania. isnull(cena,9.99) as 'Cena' from towar 
--17. Utworzy� typ tablicowy o nazwie T_Czas, kt�ry b�dzie przechowywa� liczby i odpowiadaj�ce im warto�ci miesi�cy.
create type t_czos as table (id int, nazwa varchar(20))
create table t1(id int, b t_czos)
--18. Utworzy� procedur� o nazwie WyswietlTowary, kt�ra przy pomocy typu tablicowego T_Czas b�dzie wy�wietla�a poszczeg�lne nazwy 
--towar�w i s�ownie miesi�cy, w kt�rych zosta�y dodane.
go
create procedure WyswietlTowary
as
begin
	declare @tc t_czos
	insert into @tc values (1, 'styczen'), (3, 'marzec'), (5,'Maj')
	--select * from @tc
	declare @miesiac varchar(20), @towar varchar(30), @licznik int
	set @licznik=1
	while @licznik<5
	begin
		select @towar=t.nazwa, @miesiac=c.nazwa from towar t, @tc c
			where c.id=month(data_dodania) and t.id=@licznik
		print @towar + space(1) +@miesiac 
		set @licznik+=1
	end
end
--19. Zablokowa� uprawnienia wykonania procedury dla innych u�ytkownik�w i przetestowa� dzia�ania.
deny execute on WyswietlTowary to s1231
exec sp_helprotect null, s1231
--20. Utworzy� rol� o nazwie Rola_Towar i przypisa� jej pe�ne uprawnienia do tabeli Towar.
create role rola_towar 
go
grant all on towar to rola_towar
go
sp_helprole 
--21. Do roli Rola_Towar przypisa� uprawnienia wykonywania procedury o nazwie WyswietlTowary.
grant execute on wyswietltowary to rola_towar
exec sp_helprotect
--22. Przypisa� rol� Rola_Towar w�asnemu u�ytkownikowi. Sprawdzi� u�ytkownik�w przypisanych do roli.
exec sp_addrolemember @rolename='rola_towar', @membername='s1231'
exec sp_helprolemember