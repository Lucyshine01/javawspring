show tables;

create table board2 (
	idx int not null auto_increment, 	/* 게시글의 고유번호 */
	nickName varchar(20) not null,		/* 게시글 올린사람의 닉네임 */
	title varchar(100) not null,			/* 게시글 올린사람의 닉네임 */
	email varchar(50),								/* 글쓴이의 메일주소(회원가입시에 필수 입력처리 되어 있다.) */
	homePage varchar(50),							/* 글쓴이의 홈페이지(블로그)주소 */
	content text not null,						/* 글 내용 */
	wrDate datetime default now(),			/* 글 올린 날짜 */
	hostIp varchar(50) not null,			/* 글 올린이의 접속 IP */
	readNum int default 0,						/* 글 조회수 */
	good int default 0,								/* '좋아요' 클릭 횟수 누적하기 */
	mid varchar(20) not null,					/* 회원 아이디(내가 올린 게시글 전체 조회시체 사용) */
	uwrDate datetime default "",										/* 게시글을 업데이트한 날짜 */
	goodIdx not null text default "",
	primary key(idx)
);

ALTER TABLE board2 ADD goodId text;
ALTER TABLE board2 ADD uDate datetime;
alter table board2 ADD goodIdx text default null;
alter table board2 drop goodId;
alter table board2 drop uDate;
alter table board2 drop goodIdx;

desc board2;

insert into board2 values (default,'관리맨','게시판 서비스를 시작합니다.','saasdfhr@gmail.com','http://www.saasdfhr1234.com','이곳은 게시판입니다.',default,'192.168.50.79',default,default,'admin',default,default);

select idx, title from board2 where idx in(
(select idx from board2 where idx < 7 order by idx desc limit 1),
(select idx from board2 where idx > 7 order by idx limit 1));




update board2 set uDate = now() where idx=1;

select * from board2;

/* 게시판에 댓글 달기 */
create table boardReply2 (
	idx int not null auto_increment, 	/* 댓글의 고유번호 */
	boardIdx int not null,					 	/* 원본글의 고유번호(외래키로 지정) */
	mid varchar(20) not null,					/* 댓글 올린이의 아이디 */
	nickName varchar(20) not null,		/* 댓글 올린이의 닉네임 */
	wrDate datetime default now(),			/* 댓글 올린 날짜 */
	hostIp varchar(50) not null,			/* 댓글 올린 PC의 Ip */
	content text not null,						/* 댓글 내용 */
	level int not null default 0,			/* 댓글레벨 - 첫번째댓글(부모댓글)의 레벨은 0번 */
	levelOrder int not null default 0,/* 댓글의 순서 - 첫번째댓글(부모댓글)의 레벨은 0번 */
	primary key(idx),
	foreign key(boardIdx) references board2(idx)
	/* 문자면 상관x(정수형 같은 필드일때 문제가 됌) */
	/* on update cascade  부모키에 따라서 같이 업데이트 */
	/*	on delete restrict 부모키를 삭제하려하는 것 제약 */
);

desc boardReply2;
drop table boardReply2;



/* 날짜함수 처리 연습 */
select now(); -- now() : 오늘 날짜와 시간을 보여준다.

/* year() : 년도 출력 */
select year(now());
/* month() : 월 출력 */
select month(now());
/* day() : 일 출력 */
select day(now());
/* date(now()) : 년-월-일 출력 */
select date();
/* weekday(now()) : 요일 : 0(월), 1(화), 2(수), 3(목), 4(금), 5(토), 6(일) */
select weekday(now());
/* dayofweek() 요일 : 1(일), 2(월), 3(화), 4(수), 5(목), 6(금), 7(토) */
select dayofweek(now());

/* hour() : 시 출력 */
select hour(now());
/* minute() : 분 출력 */
select minute(now());
/* second() : 초 출력 */
select second(now());


select year('2022-12-1');
select idx, nickName, year(wDate) from board;
select idx, nickName, day(wDate) as 날짜 from board;
select idx, nickName, wDate, weekday(wDate) as 요일 from board;

/* 날짜 연산 */
-- date_add(date, interval 값 type) 앞에 날짜에서 뒤에 일수를 더함
/* 오늘날짜보다 +1일 출력 */
select date_add(now(), interval 1 day); 
/* 오늘날짜보다 -1일 출력 */
select date_add(now(), interval -1 day); 
/* 오늘날짜보다 +10시간 출력 */
select date_add(now(), interval 10 day_hour); 
/* 오늘날짜보다 -10시간 출력 */
select date_add(now(), interval -10 day_hour); 

-- date_sub(date, interval 값 type) 앞에 날짜에서 뒤에 일수를 뺌
select date_sub(now(), interval 1 day);
select date_sub(now(), interval -1 day);


select idx, wDate from board;
/* 년:%y,%Y 월:%m,%M 일:%d,%D */
/* %M 월을 영문출력 */
select idx, date_format(wDate, '%y-%M-%d') from board;
/* %m 월을 숫자출력 */
select idx, date_format(wDate, '%y-%m-%d') from board;
select idx, date_format(wDate, '%y년 %m월 %d일') from board;
/* %y 년도 2자리, %Y 년도 4자리 출력 */
select idx, date_format(wDate, '%Y-%m-%d') from board;
/* %D 일을 th붙여서 출력  */
select idx, date_format(wDate, '%Y-%m-%D') from board;

/* %h(12시간),%H(24시간) */
select idx, date_format(wDate, '%h시 %i분 %s초') from board;
select idx, date_format(wDate, '%H시 %i분 %s초') from board;

-- 현재부터 한달전의 날짜
select date_add(now(), interval -1 month);
select date_add(now(), interval -1 year);

-- 하루전 체크
select date_add(now(), interval -1 day);
select date_add(now(), interval -1 day), wDate from board;

-- 날짜차이 계산 : DATEDIFF(시작날짜, 마지막날짜)
select datediff('2022-11-30', '2022-12-01');
select datediff(now(), '2022-11-30');
select idx, wDate, datediff(now(), wDate) from board;
select *, datediff(now(), wDate) as day_diff from board;


select date(now());SELECT TIMESTAMPDIFF(minute, date_format('2022-04-20 01:01', '%Y-%m-%d %H:%i'), date_format('2022-12-31 23:59', '%Y-%m-%d %H:%i')) AS time_diff;
SELECT TIMESTAMPDIFF(hour, date_format('2022-11-30 13:01', '%Y-%m-%d %H:%i'), date_format(now(), '%Y-%m-%d %H:%i')) AS time_diff;
/* timestampdiff(시간타입, 시작날짜, 마지막날짜)*/
select timestampdiff(hour, now(), '2022-11-30');
select timestampdiff(hour, '2022-11-30', now());
select timestampdiff(minute, now(), '2022-11-30');
select timestampdiff(minute, '2022-11-30', now());
select timestampdiff(hour, wDate, now()) from board;
select *,timestampdiff(hour, wDate, now()) as hour_diff from board;
select *,datediff(now(), wDate) as day_diff, timestampdiff(hour, wDate, now()) as hour_diff from board;

select datediff(now(), wDate) as day_diff, TIMESTAMPDIFF(hour, date_format(wDate, '%Y-%m-%d %H:%i') ,date_format(now(), '%Y-%m-%d %H:%i')) AS hour_diff from board

select *, datediff(now(), wDate) as day_diff,
TIMESTAMPDIFF(hour, date_format(wDate, '%Y-%m-%d %H:%i'),
date_format(now(), '%Y-%m-%d %H:%i')) AS hour_diff from board
where title like '%인%' or content like '%인%' order by idx desc limit 0,5;

select datediff(now(), udate) as upDay_diff from board where idx=19;
select timestampdiff(minute, udate, now()) as upDay_diff from board where idx=19;

select count(*) as cnt from board where title like '%인%' or content like '%인%';
select count(*) as cnt from board where title like '%인%';

/* 이전글 다음글 체크 */
/* idx로 이전글 가져오기(rs.next 한번씩해서 가져오기) limit로 꼭 한건만 가져오기 */
select * from board where idx < 5 order by idx desc limit 1;
/* idx로 다음글 가져오기 */
select * from board where idx > 5 limit 1;
select * from board;


/* 댓글의 수를 전체 List에 출력하기 연습 */
select * from boardReply2 order by idx desc;
-- 댓글테이블(boardReply2)에서 board테이블의 고유번호 17번글에 딸려있는 댓글의 개수는?
select count(*) as cnt from boardReply2 where boardIdx = 17;
-- 댓글테이블(boardReply2)에서 board테이블의 고유번호 17번글에 딸려있는 댓글의 개수는?
-- 원본글의 고유번호와 함께 출력, 갯수의 별명은 replyCnt
select boardIdx,count(*) as replyCnt from boardReply2 where boardIdx = 17;

-- 댓글테이블(boardReply2)에서 board테이블의 고유번호 17번글에 딸려있는 댓글의 개수는?
-- 원본글의 고유번호와 함께 출력, 갯수의 별명은 replyCnt
-- 이떄 원본글을 쓴 닉네임을 함께 출력하시오. 단, 닉네임은 board(원본글)테이블에서 가져와서 출력하시오. 
select boardIdx,nickName,count(*) as replyCnt from boardReply2 where boardIdx = 17;
SELECT boardIdx,
	(SELECT nickName FROM board where idx=17) AS nickName,
	count(*) AS replyCnt 
	FROM boardReply2 WHERE boardIdx = 17;

-- 앞의 문장을 부모테이블(board)의 관점에서 보자...
SELECT mid, nickname FROM board where idx =17;
-- 앞의 닉네임을을 자식(댓글)테이블(boardReply2)에서 가져와서 보여준다면????
SELECT mid,
	(select nickName from boardReply2 where boardIdx=16) as nickName
	FROM where idx =16;

-- 부모관점(board)에서 고유번호 16번의 아이디와, 현재글에 달려있는 댓글의 개수???
SELECT mid,
	(SELECT count(*) FROM boardReply2 WHERE boardIdx=16)
	FROM board WHERE idx=16;
	
-- 부모관점(board)에서 고유번호 16번의 모든 내용과, 현재글에 달려있는 댓글의 개수를 가져오되, 최근글 5개만 출력?

SELECT *,
	(SELECT count(*) FROM boardReply2 WHERE boardIdx=board.idx) as replyCount
	FROM board
	limit 20;

-- 부모관점(board)에서 고유번호 16번의 모든 내용과, 현재글에 달려있는 댓글의 개수를 가져오되, 최근글 5개만 출력?
-- 각각의 테이블에 별명을 붙여서 앞의 내용을 변경시켜보자.
SELECT *,
	(SELECT count(*) FROM boardReply2 WHERE boardIdx=b.idx) as replyCount
	FROM board b
	limit 20;

select *,(select count(*) FROM boardReply2 WHERE boardIdx=b.idx) as replyCnt,
	datediff(now(), wDate) as day_diff,
	TIMESTAMPDIFF(hour, date_format(wDate, '%Y-%m-%d %H:%i'),
	date_format(now(), '%Y-%m-%d %H:%i')) AS 
	hour_diff from board b order by idx desc limit 0,10;
