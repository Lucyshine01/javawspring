show tables;

create table pds2 (
	idx int not null auto_increment, 	/* 자료실 고유번호 */
	mid varchar(20) not null,					/* 업로더 아이디 */
	nickName varchar(20) not null,		/* 업로더 닉네임 */
	fiName varchar(200) not null,			/* 업로드 파일명 */
	fiSName varchar(200) not null,			/* 실제 파일서버에 저장되는 업로드 파일명 */
	fiSize int not null,								/* 파일의 총 사이즈 */
	title varchar(100) not null,			/* 업로드 파일의 제목 */
	part varchar(20) not null,				/* 파일 분류(카테고리) */
	pwd varchar(100) not null,				/* 비밀번호(암호화 - SHA256암호화 처리) */
	fiDate datetime default now(),			/* 파일 업로드한 날짜 */
	downNum int default 0,						/* 파일 다운로드 횟수 */
	openSw char(6) default '공개',			/* 파일 공개(비공개) 여부 */
	content text,											/* 업로드 파일의 상세설명 */
	hostIp varchar(50) not null,			/* 업로더의 PC IP */
	primary key(idx)									/* 기본키: 자료실의 고유번호 */
);

DESC pds2;

SELECT * FROM pds2 ORDER BY idx DESC;

select * from pds2 where (nickName like '%a%' or title like '%a%' or content like '%a%') and part = '학습';

