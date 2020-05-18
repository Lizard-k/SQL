--deklaracja zmiennych
declare 
@liczba numeric (5),
@tekst varchar(20)
begin
--set @liczba=10
select @tekst='ABC', @liczba=10
print @tekst+' ' +cast(@liczba as varchar(5))

end
-- instrucje warunkowe
declare 
@liczba as numeric(5)
begin
set @liczba=100
if @liczba<100
begin 
print 'mniej niz 100'
end 
else if @liczba<200 print 'miej niz 200'
else print '200 i wiecej'
end 
go
--petle
begin 
declare 
@i as numeric(5)
select @i=1
while @i<10
begin 
print @i
select @i+=1 --rownowazne @i=@i+1
end
end 
go

--wykonywanie skladni sql w bloku anonimowym
create table Produkt
(idproduktu int identity(1,1) primary key,
nazwaproduktu varchar(20))
insert into Produkt values
('Chleb'), 
('maslo')
select * from produkt
begin
declare @zapytanie as varchar(200)
set @zapytanie='select count(*) as liczba_wystapien from Produkt' 
exec (@zapytanie)

end
go


--1. Zadeklarowa� dwie zmienne tekstowe: imie i nazwisko oraz jedn� zmienn� liczbow� o nazwie numer porz�dkowy. Przypisa� warto�ci zmiennym:
--Jan, Kowalski, 100
--i wy�wietli� je.
declare 
@imie varchar (15),
@nazwisko varchar(20),
@numerporzadkowy numeric(5)
begin
select @imie='Jan', @nazwisko='Kowalski', @numerporzadkowy=100
print @imie+' ' +@nazwisko+ ' ' +cast(@numerporzadkowy as varchar(5))
end




--2. Napisa� program, kt�ry z wykorzystaniem instrukcji EXEC policzy liczb� wierszy w dowolnej tabeli, a nast�pnie utworzy
--tabel� o nazwie Raport3 wstawiaj�c liczb� wcze�niej wyliczonych wierszy. Zapytania musz� by� przechowywane w zmiennych tekstowych.
declare 
@zapytanie as varchar(200)
begin 
set @zapytanie='select count(*) as liczbawierszy into Raport3 from Produkt' 
exec (@zapytanie)
end
go
select * from Raport3
--3. Napisa� program, kt�ry wy�wietli wszystkie parzyste liczby z zakresu od 1 do 10. Dodatkowo po wykonaniu kodu nale�y 
--wstrzyma� program na 2 sekundy przed wy�wietleniem danych.
begin 
declare 
@i as numeric(5)
select @i=1 --@i=2
while @i<=10
	begin 
		if @i % 2 =0 
		print @i
		select @i+=1 --rownowazne @i+=2
	end
end 
waitfor delay  '00:00:02'
go


--4. Napisa� program, kt�ry wy�wietli wszystkie liczby z zakresu od 1 do 10. Je�eli liczba jest podzielna przez 3 to 
--wypisze stosown� informacj�.
begin 
declare 
@i as numeric(5)
select @i=1 
while @i<=10
	begin 
		select @i=1
		if @i % 3 =0 print 'liczba'+ ' ' +cast(@i as varchar(5))+ ' '+ 'jest podzielna przez 3'
		else print @i
	end
end 
go

--5. Wygenerowa� tabel� o nazwie Dane, kt�ra b�dzie zawiera�a dwie kolumny: opis oraz warto��. W tabeli powinny by� 
--zamieszczone opisy: A, B, C, D i E oraz przyporz�dkowane im liczby z zakresu od 1 do 100. Nale�y wype�ni� 2000 wierszy tablicy.
--Je�eli kolejny dodawany wiersz jest podzielny przez 5 to powinien otrzyma� opis E, przez 4: D, przez 3: C, przez 2: B 
--oraz przez 1: A. Podpowied�: funkcja RAND() s�u�y do generowania liczby losowej zmiennoprzecinkowej z zakresu od 0 do 1.
 select count(*) as dane from dane
 select top 5 * from dane
--6. Wy�wietli� utworzon� wcze�niej tabel� wypisuj�c w trzech kolumnach nast�puj�ce warto�ci:
--Klasa wielko�ci
--Opis 
--��czna warto��  
--gdzie:
--- klasa wielko�ci ma reprezentowa� przedzia�y:
--ma�e: 1 do 30
--�rednie: 31 do 70
--du�e: 71 do 100
--- ��czna warto�� to funkcja agreguj�ca SUM
--Wyniki maj� by� koniecznie pogrupowane wed�ug klas wielko�ci i opisu.
select 
case 
when wartosc between 1 and 30 then 'male'
when wartosc between 31 and 70 then 'srednie'
else 'duze'
end as klasa_wartosci, opis, wartosc
from dane