show tables;


create table guest (
	idx int not null auto_increment primary key, /* 고유번호 */
	name varchar(20) not null, 	/* 방문자 성명 */
	email varchar(60),					/* 이메일 주소 */
	homePage varchar(60),				/* 홈페이지 주소 */
	/* EL에서 변환시 ${vo.vDate}가 되는데 첫글자다음 글자가 대문자일경우 */
	/* ${vo.VDate}로 변환시킴. 설계시 필드명 2번째 글자가 대문자가 안되게 설계 */
	visitDate datetime default now(), /* 방문일자 */
 	hostIp	varchar(50) not null,		/* 방문자 IP */
  content text not null						/* 방문소감 */
);

desc guest;

insert into guest values (default,'관리자','cjsk1126@naver.com','cjsk1126.tistory.com',default,'192.168.50.79','방명록 서비스를 개시합니다.');

select * from guest;

drop table guest;

select * from guest order by idx desc;

select count(*) from guest;

select count(*) as cnt from guest;

select count(*) as cnt from guest where name = '러시아 마피아' or name = '홍길동';

