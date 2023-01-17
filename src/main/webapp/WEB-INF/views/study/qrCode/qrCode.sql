show tables;

create table qrCode(
	idx int not null auto_increment primary key,
	qrCode varchar(200) not null,
	bigo varchar(200),
	qrDate datetime default now()
);

desc qrCode;
select * from qrCode;

insert into qrCode values(default,'test','test',default);

select * from qrCode order by idx desc limit 0,5;

drop table qrCode;
