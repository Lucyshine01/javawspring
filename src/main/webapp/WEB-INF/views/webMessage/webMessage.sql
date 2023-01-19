show tables;


create table webMessage (
	idx int not null auto_increment primary key,	/* 교유번호 */
	title varchar(100) not null,	/* 메세지 제목 */
	content text not null,				/* 메세지 내용 */
	sendId varchar(20) not null,	/* 보내는 사람 아이디 */
	sendSw char(1) not null,			/* 보낸메세지(s), 휴지통(g)-생략, 휴지통에서 삭제(x)표시 */
	sendDate datetime default now(),	/* 메세지 보낸날짜 */
	receiveId varchar(20) not null, 	/* 받는 사람 아이디 */
	receiveSw char(1) not null,		/* 받은메세지(n), 읽은 메세지(r), 휴지통(g), 휴지통에서삭제(x) */
	receiveDate datetime default now()	/* 메세지 받은 날짜 */
);

desc webMessage;

insert into webMessage values(default,'test','test1','baemiok','s',default,'hkd1234','n',default);
insert into webMessage values(default,'test','test2','baemiok','s',default,'admin','n',default);
insert into webMessage values(default,'test','test3','admin','s',default,'baemiok','n',default);
insert into webMessage values(default,'test','test4','hkd1234','s',default,'baemiok','n',default);
insert into webMessage values(default,'test','test5','admin','s',default,'baemiok','n',default);
insert into webMessage values(default,'test','test6','baemiok','s',default,'admin','n',default);
insert into webMessage values(default,'test','test7','admin','s',default,'baemiok','n',default);
insert into webMessage values(default,'test','test8','hkd1234','s',default,'baemiok','n',default);
insert into webMessage values(default,'test','test9','baemiok','s',default,'admin','n',default);
insert into webMessage values(default,'test','test10','admin','s',default,'baemiok','n',default);

select * from webMessage;


select * from webMessage 
	where sendSw != 'x' and receiveSw != 'x' and sendId in ('asdf','admin') and receiveId in ('asdf','admin') 
	order by receiveDate desc;


delete from webMessage;











