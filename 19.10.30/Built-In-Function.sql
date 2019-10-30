select user(), database();

-- mysql 내장 함수

-- ASCII, char
select ascii('A'), char(65);

-- BIT_LENGTH, CHAR_LENGTH, LENGTH
select bit_length('abc'), char_length('abc'), length('abc');

-- concat, concat_ws
select concat('2020','01','01'), concat_ws('/', '2020', '01', '01');

-- elt
select elt(2, '하나', '둘', '셋');

-- field
select field('셋', '하나', '둘', '셋', '넷');

-- find_in_set
select FIND_IN_SET('둘','하나,둘,셋,넷');

-- instr
select instr('하나둘셋넷','둘');

-- locate
select locate('둘','하나둘셋넷');

-- format
select format(9090.90,0), format(9090.90,2);

-- bin(2진수), hex(16진수), oct(8진수)
select bin(10), hex(18), oct(10);

-- insert
select insert('abcdefg',3,4,'####'), insert('abcdefg',3,2,'@@');

-- left, right
select left('abcdefghi',3), right('abcdefghi',3);

-- ucase, lcase
select ucase('abcdefg'), lcase('ABCDEFG');

-- upper, lower
select upper('abcdefg'), lcase('ABCDEFG');

-- lpad, rpad
select lpad('abcdefg',10,'******'), rpad('abcdefg',10,'******');

-- ltrim, rtrim
select ltrim('      abcd'), rtrim('abcd     ');

-- 문제
select * from employee2;

alter table employee2 add column jumin char(14);
alter table employee2 add column email varchar(50);

update employee2 set jumin = '901212-2345678', email = 'jmh@naver.com'
	where empname = '조민희';

update employee2 set jumin = '910101-2123456', email = 'lyy91@gmail.com'
	where empname = '이유영';

-- 1번
select concat(lpad(left(jumin,2),4,19),'년 ', mid(jumin,3,2), '월 ', mid(jumin,5,2), '일') as 생년월일
	from employee2;

select concat(lpad(left(jumin,2),4,19), '년 ', right(left(jumin,4),2),'월 ', right(left(jumin, 6),2), '일') as 생년월일
	from employee2;
-- 2번
select left(email,instr(email,'@')-1) as id, right(email,char_length(email)-instr(email,'@')) as mailaddress
	from employee2;

select substring_index(email,'@',1) as id, SUBSTRING_INDEX(email,'@',-1) as mailaddress
	from employee2
	
-- 3번
alter table employee2 change column empno empno char(6);
update employee2 set empno = lpad(empno,6,'E00000');

update employee2 set empno = lpad(left(empno,5),6,'E00000');

select empno, lpad(left(empno,5),6,'E00000') as nempno
	from employee2;

-- 4번
select insert(jumin, 9, 6, '******') as 주민번호
	from employee2;

select replace (jumin, right(jumin,6), '******' ) as 주민번호
	from employee2;

-- 5번
select concat(empno,'@yi.or.kr')
	from employee2;

select *
	from employee2
where empname <> '조민희' and empname <> '이유영';

select *
	from employee2
where empname not in('조민희','이유영');

update employee2 set email = concat(lower(empno),'@yi.or.kr')
	where empname <> '조민희' and empname <> '이유영';

update employee2 set email = concat(lower(empno),'@yi.or.kr')
	where not in('조민희','이유영');


select * from employee2;

-- 6번
select empname, (year(now())-concat(19,left(jumin,2))) as 나이
	from employee2;

select concat(empname,'(',(year(now())-concat(19,left(jumin,2))),')') as 사원
	from employee2;

-- trim
select trim('   abcd   '), trim(leading '' from '   abcdㅋㅋㅋ'), trim(both 'ㅋㅋㅋ' from 'ㅋㅋㅋabcdㅋㅋㅋ'), trim(trailing 'zzz' from 'ㅋㅋㅋabcdzzz');

-- repeat
select repeat('*',7);

-- replace
select replace('123456-1234567', '1234567', '*******');

-- reverse
select reverse('mysql');

-- substring_index
select substring_index('cafe.naver.com','.',2), substring_index('cafe.naver.com', '.', -2);

-- ceiling, floor, round
select ceiling(4.7), floor(4.7), round(4.7);

-- mod, pow, sqrt
select mod(4,3), pow(2,3), sqrt(4);

-- rand
select rand(), floor(rand()*10), floor(20 + (rand()*10));

-- sign
select sign(-2), sign(1), sign(0);

-- truncate
select truncate(10.56234,2),truncate(12.5555,-1);

-- curdate, curtime, now(), sysdate()
select curdate(), curtime(), now(), sysdate();

-- adddate, subdate
select curdate(), adddate(curdate(), 3), subdate(curdate(),3);

-- addtime, subtime
select curtime(), addtime(curtime(), '1:0:0'), subtime(curtime(), '1:0:0');

-- year, month, day, hour, minute, second
select now(), year(now()), month(now()), hour(now()), minute(now()), second(now());

--  date
select now(), date(now()), time(now());

-- dayofweek, monthname, dayofyear
select elt(dayofweek(now()),'일','월','화','수','목','금','토') 요일, monthname(now()), dayofyear(now());



