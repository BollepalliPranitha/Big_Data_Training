use sql_sql;
create table customer
(cid INT PRIMARY KEY,name NVARCHAR(20),email NVARCHAR(50),Timestampchange DATETIME2 DEFAULT SYSDATETIME());

insert into customer (cid,name,email) values (1,'rishi','rishi@gmail.com');
insert into customer (cid,name,email) values (2,'sushi','sushi@gmail.com');
insert into customer (cid,name,email) values (3,'radha','radha@gmail.com');

select * from customer;

--Create customer_backup table same as customer table with same data--!

select * into customer_backup from customer where 1=0;

alter table customer_backup add timestamp_backup DATETIME2 DEFAULT SYSDATETIME();

select * from customer_backup;
--full load--!
insert into customer_backup (cid,name,email,Timestampchange)
select cid,name,email,Timestampchange from customer;

create table customer_logging(updated_timestamp DATETIME2);
go
CREATE TRIGGER trg_UpdateTimestamp
ON customer
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  UPDATE customer
  SET Timestampchange = SYSDATETIME()
  FROM customer
  INNER JOIN inserted i ON customer.cid = i.cid;
END;
go
--Trigger for logging--!
CREATE TRIGGER update_logging
on customer_backup
AFTER INSERT,UPDATE
as
begin
INSERT INTO customer_logging(updated_timestamp)
    SELECT Timestampchange FROM INSERTED;
end;
drop trigger update_logging;
declare @lastloggingtime DATETIME2;
select @lastloggingtime=max(updated_timestamp) from customer_logging;

merge customer_backup as target
using 
(select * from customer 
where Timestampchange > @lastloggingtime)
as source
on target.cid=source.cid
when MATCHED then
update set 
target.name=source.name,
target.email=source.email,
target.Timestampchange=source.Timestampchange
when not matched by target then
insert(cid,name,email,Timestampchange)
values(source.cid,source.name,source.email,source.Timestampchange);

update customer set email='rishiguptha@gmail.com' where cid=1;
insert into customer (cid,name,email) values(4,'krishna','krishna@gmail.com');
go


