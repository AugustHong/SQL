/* MSSQL 沒有像 Oracle 有 Array 陣列，所以是用類似Table的方式來存取陣列*/
declare @tmp table (n int, t varchar(30));
insert into @tmp values (1, 'A') ,(2, 'B') ,(3, 'C');
select * from @tmp;
insert into @tmp values (4, 'D');
select * from @tmp;