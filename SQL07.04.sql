--1. Nale¿y utworzyæ tablicê o nazwie TabLiczba, zawieraj¹c¹ kolumny:
-- identyfikator (autonumeracja),
-- liczba typu liczbowego ca³kowitego (co najmniej z zakresu 0 do 1000),
-- slownie typu tekstowego.
--Dodaæ do tabeli trzy wiersze (liczba, slownie):
--1 jeden
--2 dwa
--3 trzy

CREATE TABLE TabLiczba(id int identity(1,1), liczba numeric(4,0), slownie varchar(100));
INSERT INTO TabLiczba(liczba, slownie) VALUES (1,'jeden');
INSERT INTO TabLiczba(liczba, slownie) VALUES (2,'dwa');
INSERT INTO TabLiczba(liczba, slownie) VALUES (3,'trzy');

--2. Utworzyæ procedurê o nazwie wyswietlDane, która wyœwietli wszystkie wiersze z tabeli o nazwie Liczba. 
--Zweryfikowaæ dzia³anie procedury.
create procedure wyswietlDane
as
begin
	select * from TabLiczba
end

execute wyswietlDane
exec wyswietlDane
wyswietlDane

--3. Utworzyæ procedurê o nazwie dodajLiczbe, która przyjmuje dwa argumenty - liczbê oraz jej reprezentacjê s³own¹ i dodaje
--te argumenty jako kolejny wiersz tabeli TabLiczba.

alter procedure dodajLiczbe
@numer numeric(4),
@sl varchar (100)
AS
BEGIN
	INSERT INTO TabLiczba (liczba, slownie) values (@numer, @sl)
END
--4. Dodaæ liczby od 4 do 10 wykorzystuj¹c procedurê dodajLiczbe.

--PodpowiedŸ:

exec dodajLiczbe @Numer=4, @Sl='cztery';
exec dodajLiczbe @Numer=5, @Sl='piêæ';
exec dodajLiczbe @Numer=6, @Sl='szeœæ';
exec dodajLiczbe @Numer=7, @Sl='siedem';
exec dodajLiczbe @Numer=8, @Sl='osiem';
exec dodajLiczbe @Numer=9, @Sl='dziewiêæ';
exec dodajLiczbe @Numer=10, @Sl='dziesiêæ';
go

--5. Utworzyæ procedurê o nazwie procLiczbaSlownie, która za argument przyjmuje wartoœæ liczbow¹ i wyœwietla 
--reprezentacjê s³own¹ tej liczby na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowaæ dzia³anie procedury.
create proc ProcLiczbaSlownie
@argument numeric(4)
AS 
BEGIN
	select slownie from tabliczba where liczba=@argument
END
exec ProcLiczbaSlownie @argument=5
exec procliczbaslownie 5 

--6. Utworzyæ funkcjê o nazwie funkcjaLiczbaSlownie, która za argument przyjmuje wartoœæ liczbow¹ i zwraca reprezentacjê s³own¹ tej liczby w postaci tabeli, na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowaæ dzia³anie.

create function fukcjaLiczbaSlownie
(@liczba numeric(4))
returns table
as RETURN
(select slownie from tabliczba where liczba=@liczba)
go

select * from funkcjaLiczbaSlownie(4)
create table tabela1(id int, numer int)
go
insert into tabela1 values (1,5)
insert into tabela1 values (2,8)
insert into tabela1 values (3,3)
GO
select *, funkcjaliczbaSlownieSkalar(numer) from tabela1

go 
create function fukcjaLiczbaSlownieSkalar
(@liczba numeric(4))
returns varchar(100)
as 
begin
	declare @slownie as varchar(100)
	select @slownie=slownie from tabliczba where liczba=@liczba
	return @slownie
end
go 
--7. Napisaæ funkcjê o nazwie LiczbaWierszy, która zwróci liczbê wierszy zapisanych w tabeli o nazwie TabLiczba.
create function LiczbaWierszy()
returns numeric(3)
AS
BEGIN
	declare @ilewierszy as numeric(3) 
	select @ilewierszy=count(*) from TabLiczba
	return @ilewierszy
END
go
select dbo.liczbaWierszy()
--8. Utworzyæ procedurê o nazwie dodajTylkoLiczbe, która za argument przyjmuje wartoœæ liczbow¹. Przed dodaniem liczby ma 
--zostaæ sprawdzona, czy wartoœæ argumentu jest z zakresu 20 do 99. Je¿eli warunek ten zostanie spe³niony powinna zostaæ 
--dodana liczba wraz ze s³own¹ reprezentacj¹ np. dwadzieœcia trzy. Czêœæ opisu powinna byæ pobierana z opisu liczb od 1 do 9. Dodaæ kilka liczb z zakresu od 20 do 99.
go
alter procedure dodajTylkoLiczbe 
@wartosc numeric(5)
AS
BEGIN
	declare @slownie varchar(100)
	if @wartosc between 20 and 99
	begin
		if @wartosc between 20 and 29 set @slownie='Dwadziscia'
		else if @wartosc between 30 and 39 set @slownie='Trzydziesci'
		else if @wartosc between 40 and 49 set @slownie='Czterdziesci'
		else if @wartosc between 50 and 59 set @slownie='Piecdziesiat'
		else if @wartosc between 60 and 69 set @slownie='Szescdziesiat'
		else if @wartosc between 70 and 79 set @slownie='Siedemdziesiat'
		else if @wartosc between 80 and 89 set @slownie='Osiemdziesiat'
		else if @wartosc between 90 and 99 set @slownie='Dziewiecdziesiat'
		select @slownie+=space(1)+slownie from Tabliczba where @wartosc%10=liczba
		print @slownie
		insert into TabLiczba values (@wartosc, @slownie)
	END
end
exec dodajTylkoLiczbe 73
select dbo.liczbaWierszy()
--9. Napisaæ procedurê o nazwie DodajLiczby, która doda wszystkie liczby z okreœlonego zakresu u¿ywaj¹c w tym celu procedury
--o nazwie dodajTylkoLiczbe. Wywo³aæ procedurê dla zakresu od 20 do 99.
create procedure dodajliczby
@liczba1 numeric(4),
@liczba2 numeric(4)
as
begin
	while(@liczba1<=@liczba2)
	begin
		exec dodajtylkoliczbe @liczba1
		set @liczba1+=1
	end
end
exec dodajliczby 20,99
exec wyswietlDane
--10. Napisaæ funkcjê o nazwie WyswietlDuplikatyLiczb, która w postaci tabeli z kolumnami liczba oraz liczba_wystapien, 
--zwróci listê wszystkich duplikatów liczb, jakie wystêpuj¹ w tabeli. Przetestowaæ dzia³anie.
go
create function wyswietlDuplikatyLiczb()
returns table
as RETURN 
(
	select liczba, count(*) as liczba_wystapien
	from Tabliczba
	group by liczba
	having count(*)>1
)
go
select* from wyswietlDuplikatyLIczb()
--11. Napisaæ procedurê UsunLiczbe, usuwaj¹c¹ liczbê podan¹ jako argument wywo³ania procedury. Przetestowaæ dzia³anie.
go
create proc usunliczbe
@liczba numeric(4)
AS
BEGIN
	delete from tabliczba where liczba=@liczba
END
select * from wyswietlDuplikatyLiczb()
exec usunliczbe 73
exec dodajTylkoLiczbe 73

select liczba, slownie from tabliczba order by liczba 