--1. Sprawdziæ swoje uprawnienia na serwerze SQL.
select * from sys.fn_my_permissions(default, 'SERVER')
--2. Sprawdziæ swoje uprawnienia w bazie danych SQL.
select * from sys.fn_my_permissions(default, 'DATABASE')
--3. Utworzyæ tabelê o nazwie Towar, zawieraj¹ca cztery kolumny:
-- identyfikator, liczba, autoinkrementacja, klucz g³ówny
-- - nazwa towaru, tekst, 20 znaków
-- - cena, waluta
-- - data dodania, data
create table Towar 
(id int identity(1,1) primary key,
nazwa varchar(20),
cena money,
data_dodania date default getdate()) 

--4. Wykorzystuj¹c autoinkrementacjê dodaæ do tablicy Towar trzy wiersze:
--O³ówek; 1,29 z³
--Kredka; 0,52 z³
--D³ugopis; 1,32 z³
insert into towar (nazwa,cena) values
('Olowek', 1,29),
('Kredka', 0,52),
('Dlugopis', 1,32)
--5. Zmieniæ uprawnienia na tabeli usuwaj¹c innemu u¿ytkownikowi mo¿liwoœæ przegl¹dania zawartoœci tabeli.
use master 
go
create login s1231 with password='student'
go
use [s12-31]
go
create user s1231 for login s1231go exec sp_addrolemember @membername='s1231',@rolename ='db_datareader'
go 
deny select on towar to s1231
--6. Sprawdziæ swoje uprawnienia na obiekcie innego u¿ytkownika.
exec sp_helprotect null, 's1231'

--7. Cofn¹æ przyznane zablokowane wczeœniej uprawnienie do obiektu. Sprawdziæ dzia³anie.
revoke select on towar to s1231
exec sp_helprotect null, 's1231'
--8. Zablokowaæ uprawnienia aktualizacji, dodawania wierszy oraz zmian w tablicy Towar dla innego u¿ytkownika.
deny insert, alter, update on towar to s1231
--9. Nadaæ mo¿liwoœæ dodawania wierszy w tablicy Towar dla innych u¿ytkowników. Sprawdziæ dzia³anie i efektywne uprawnienia 
--na tabeli Towar.
grant insert on towar to s1231
exec sp_helprotect null, 's1231' 
--10. Spróbowaæ zablokowaæ wszystkie uprawnienia na obiekcie Towar dla innego u¿ytkownika.
deny all on towar to s1231 --nie stosowaæ 'all', nie blokuje wszystko
exec sp_helprotect null, 's1231' 
--11. Sprawdziæ jaki bêdzie dzieñ za 100 dni.
select DATEADD(dd, 100, getdate())
--12. Wyœwietliæ zawartoœæ tabeli Towar, wypisuj¹c w czwartej kolumnie dzieñ tygodnia w jakim towar zosta³ dodany.
select id, nazwa, cena, datename (dw, data_dodania) as 'Dzien tygodnia' from towar 

--13. Wyœwietliæ w osobnych kolumnach: nazwê towaru, cenê, dzieñ dodania, miesi¹c dodania s³ownie, rok.
select  nazwa, cena, datename(dw, data_dodania) as 'Dzien tygodnia', datename(mm,data_dodania) as 'Miesiac'
datename(year,data_dodania) as 'rok' from towar --year(data_dodania) as rok from towar
--14. Sprawdziæ ile dni dzieli bie¿¹c¹ datê od 1 paŸdziernika bie¿¹cego roku.
select datediff(dd, getdate(), '2020-10-01')
--15. Dodaæ dwa kolejne wiersze do tabeli o nastêpuj¹cych wartoœciach:
--Mazak czerwony; NULL
--Mazak zielony; NULL
insert into towar (nazwa,cena) values 
('Mazak czerwony', null),
('Mazak zielony', null)
--16. Wyœwietliæ zawartoœæ tabeli Towar, je¿eli cena ma wartoœæ NULL to powinna wyœwietliæ siê 9,99 z³.
select nazwa, data_dodania. isnull(cena,9.99) as 'Cena' from towar 
--17. Utworzyæ typ tablicowy o nazwie T_Czas, który bêdzie przechowywaæ liczby i odpowiadaj¹ce im wartoœci miesiêcy.
create type t_czos as table (id int, nazwa varchar(20))
create table t1(id int, b t_czos)
--18. Utworzyæ procedurê o nazwie WyswietlTowary, która przy pomocy typu tablicowego T_Czas bêdzie wyœwietla³a poszczególne nazwy 
--towarów i s³ownie miesiêcy, w których zosta³y dodane.
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
--19. Zablokowaæ uprawnienia wykonania procedury dla innych u¿ytkowników i przetestowaæ dzia³ania.
deny execute on WyswietlTowary to s1231
exec sp_helprotect null, s1231
--20. Utworzyæ rolê o nazwie Rola_Towar i przypisaæ jej pe³ne uprawnienia do tabeli Towar.
create role rola_towar 
go
grant all on towar to rola_towar
go
sp_helprole 
--21. Do roli Rola_Towar przypisaæ uprawnienia wykonywania procedury o nazwie WyswietlTowary.
grant execute on wyswietltowary to rola_towar
exec sp_helprotect
--22. Przypisaæ rolê Rola_Towar w³asnemu u¿ytkownikowi. Sprawdziæ u¿ytkowników przypisanych do roli.
exec sp_addrolemember @rolename='rola_towar', @membername='s1231'
exec sp_helprolemember