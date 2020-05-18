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


--1. Zadeklarowaæ dwie zmienne tekstowe: imie i nazwisko oraz jedn¹ zmienn¹ liczbow¹ o nazwie numer porz¹dkowy. Przypisaæ wartoœci zmiennym:
--Jan, Kowalski, 100
--i wyœwietliæ je.
declare 
@imie varchar (15),
@nazwisko varchar(20),
@numerporzadkowy numeric(5)
begin
select @imie='Jan', @nazwisko='Kowalski', @numerporzadkowy=100
print @imie+' ' +@nazwisko+ ' ' +cast(@numerporzadkowy as varchar(5))
end




--2. Napisaæ program, który z wykorzystaniem instrukcji EXEC policzy liczbê wierszy w dowolnej tabeli, a nastêpnie utworzy
--tabelê o nazwie Raport3 wstawiaj¹c liczbê wczeœniej wyliczonych wierszy. Zapytania musz¹ byæ przechowywane w zmiennych tekstowych.
declare 
@zapytanie as varchar(200)
begin 
set @zapytanie='select count(*) as liczbawierszy into Raport3 from Produkt' 
exec (@zapytanie)
end
go
select * from Raport3
--3. Napisaæ program, który wyœwietli wszystkie parzyste liczby z zakresu od 1 do 10. Dodatkowo po wykonaniu kodu nale¿y 
--wstrzymaæ program na 2 sekundy przed wyœwietleniem danych.
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


--4. Napisaæ program, który wyœwietli wszystkie liczby z zakresu od 1 do 10. Je¿eli liczba jest podzielna przez 3 to 
--wypisze stosown¹ informacjê.
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

--5. Wygenerowaæ tabelê o nazwie Dane, która bêdzie zawiera³a dwie kolumny: opis oraz wartoœæ. W tabeli powinny byæ 
--zamieszczone opisy: A, B, C, D i E oraz przyporz¹dkowane im liczby z zakresu od 1 do 100. Nale¿y wype³niæ 2000 wierszy tablicy.
--Je¿eli kolejny dodawany wiersz jest podzielny przez 5 to powinien otrzymaæ opis E, przez 4: D, przez 3: C, przez 2: B 
--oraz przez 1: A. PodpowiedŸ: funkcja RAND() s³u¿y do generowania liczby losowej zmiennoprzecinkowej z zakresu od 0 do 1.
 select count(*) as dane from dane
 select top 5 * from dane
--6. Wyœwietliæ utworzon¹ wczeœniej tabelê wypisuj¹c w trzech kolumnach nastêpuj¹ce wartoœci:
--Klasa wielkoœci
--Opis 
--£¹czna wartoœæ  
--gdzie:
--- klasa wielkoœci ma reprezentowaæ przedzia³y:
--ma³e: 1 do 30
--œrednie: 31 do 70
--du¿e: 71 do 100
--- ³¹czna wartoœæ to funkcja agreguj¹ca SUM
--Wyniki maj¹ byæ koniecznie pogrupowane wed³ug klas wielkoœci i opisu.
select 
case 
when wartosc between 1 and 30 then 'male'
when wartosc between 31 and 70 then 'srednie'
else 'duze'
end as klasa_wartosci, opis, wartosc
from dane