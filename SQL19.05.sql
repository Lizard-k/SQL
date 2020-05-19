--zadanie 1
begin
declare @i int
select @i=50
while @i<=100
	begin
		print @i
		if @i%5=0 print 'Podzielna przez 5'
		set @i+=1
	end
end
go

--zad 2

create function liczbyPodzielnePrzez 
(@liczba1 numeric(4), @liczba2 numeric(4))
returns varchar(100)
as
begin 
	declare @odp as varchar(100)
	if @liczba1%@liczba2=0 
		begin
			set @odp = 'Liczba1 podzielna przez Liczba2'
		end
	else
		set @odp = 'Liczba1 nie podzielna przez Liczba2'
	return @odp
end 
go

select dbo.liczbyPodzielnePrzez(2,3)

--zadanie 3
create table Adres (ulica varchar(50))

insert into Adres values
('Al. Grunwaldzka 23/32'),
('BITWY POD P£OWCAMI 140'),
('Al. Marii Curie-sk³adowskiej 121/2'),
('Al. Niepodleg³oœci 99D/12'),
('UL. 23 MARCA 39a/1')

select replace(REPLACE(upper(ulica),'UL. ',''), 'AL. ','') from Adres

--zadanie 4
go
create function oszysc(@tekstnieoczyszczony varchar(50))
returns varchar(50)
as 
begin
	return replace(replace(upper(@tekstnieoczyszczony),'UL.',''),'AL.','')
end

go
select dbo.oszysc(ulica) as ulica from adres

--zadanie 5
go
create function LiczbaWierszy()
returns numeric(3)
as
begin
declare @ilewierszy as numeric(3)
select @ilewierszy=count(*) from Adres
return @ilewierszy
end
go

select dbo.liczbawierszy()