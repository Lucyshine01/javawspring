show tables;



create table user2(
	idx int not null auto_increment primary key,
	mid varchar(5) not null,
	nickName varchar(20) not null,
	job varchar(10) not null
);

desc user;
desc user2;


drop table user2;

select * from user2;

insert into user values(default, 'aaaaa', 'AMEN', 29, '서울');
insert into user2 values(default, 'aaaaa', '하느님의 MC', 'MC');

insert into user values(default, 'bbbbbb', 'BMEN', 33, '청주');
insert into user2 values(default, 'bbbbbb', '사탄의 교주', '교주');


select u1.*,u2.* from user u1, user2 u2 where u1.mid = 'aaaaa' and u2.mid = 'aaaaa';
select u1.*,u2.* from user u1, user2 u2 where u1.mid = 'aaaaa' and u2.mid = 'aaaaa';
select u1.*,u2.nickName as nickName, u2.job as job 
	from user u1, user2 u2 
	where u1.mid = u2.mid 
	order by idx desc;
	
select u1.*,u2.nickName as nickName, u2.job as job 
	from user u1 join user2 u2 
	on u1.mid = u2.mid 
	order by idx desc;

