select user(), database();

-- 데이터 베이스 확인
show databases;

-- 권한 확인
show grants;

-- 테이블 확인
show tables from mysql_study;


DROP TABLE if EXISTS employee;		-- 순서 주의
DROP TABLE if EXISTS department;

CREATE TABLE if not EXISTS department (
	deptno INT(11) not null AUTO_INCREMENT,		-- 번호를 자동부여, 먼저 생성된 기본키가 1, 2인 투플을 삭제하면 새로 생성했을때 3, 4, 5..........
														-- 빈곳의 값을 직접 지정하면 됨 
	deptname CHAR(10),		-- 
	floor INT(11) DEFAULT 0,
	PRIMARY KEY (deptno)
);

CREATE TABLE if not EXISTS employee (
	empno INT(11) not null,
	empname VARCHAR(20) unique,
	title VARCHAR(13) DEFAULT '사원',
	manager int(11),
	salary int(11),
	dno int(11) DEFAULT 1
);


SELECT *
  from information_schema.TABLE_CONSTRAINTS;
-- 테이블 제약조건 확인
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
  from information_schema.TABLE_CONSTRAINTS;
  
-- ALTER 문 사용하여 기본키 제약조건 추가 및 삭제
ALTER TABLE employee ADD CONSTRAINT PRIMARY KEY (empno); 
-- ALTER TABLE employee DROP PRIMARY KEY;  -- 기본키는 하나이기 때문에 지정안해도 됨

-- ALTER 문 사용하여 외래키 제약조건 추가 및 삭제(외래키 명을 지정, 삭제)
-- fk_employee_manager
ALTER TABLE employee ADD CONSTRAINT fk_employee_manager
		FOREIGN KEY (manager) REFERENCES employee (empno);
-- ALTER TABLE employee DROP FOREIGN KEY fk_employee_manager;
-- fk_employee_dno
ALTER TABLE employee ADD CONSTRAINT fk_employee_dno
		FOREIGN KEY (dno) REFERENCES department (deptno);
-- ALTER TABLE employee DROP FOREIGN KEY fk_employee_dno;



-- department table에 튜플 삽입
insert into department (deptno, deptname, floor) values(1, '영업', 8);
insert into department values(2, '기획', 10);
insert into department (deptname, floor) values('개발', 9);
insert into department values(null, '총무', 7);

-- employee table에 튜플 삽입
insert into employee values(4377, '이성래', '사장', null, 5000000, 2);
insert into employee values(3426, '박영권', '과장', 4377, 3000000, 1);
insert into employee values(1003, '조민희', '과장', 4377, 3000000, 2);
insert into employee values(3011, '이수민', '부장', 4377, 4000000, 3);
insert into employee values(1365, '김상원', '사원', 3426, 1500000, 1);
insert into employee values(2106, '김창섭', '대리', 1003, 2500000, 2);
insert into employee values(3427, '최종철', '사원', 3011, 1500000, 3);


-- department, employee 테이블 검색
select * from employee;
select * from department;


-- 다른 테이블에 존재하는 튜플을 검색하여 삽입
create table department2(
	deptno int(11) not null auto_increment,
	deptname char(10),
	floor int(11) default 0,
	primary key(deptno)
	);

insert into department2 values(1, '마케팅', 80);

select * from department2;

insert into department(deptname, floor) select deptname, floor from department2;

select * from department;

create table department3 as
	select deptno, deptname, FLOOR
	from department;

select *
from department3;

desc department;
desc department3;

-- department 릴레이션에서 부서번호 5, 부서명이 '연구'인 튜플을 삽입하는 insert 문은 아래와 같다.
desc department;

-- 부서번호 5인 튜플을 department에서 삭제
delete from department
where deptno = 5;

insert into department(deptname, deptno) values('연구', 5);

select deptno, deptname, FLOOR
	from department;
	
-- subscribers 테이블 생성
create table subscribers (
	id int primary key AUTO_INCREMENT,
	email varchar(50) not null UNIQUE
);

-- insert
insert into subscribers(email)
	values('john.doe@gmail.com');

-- 검색
select id, email
from subscribers;

-- insert
insert into subscribers(email)
	values('john.doe@gmail.com'),
			('jane.smith@ibm.com');
		
select id, email from subscribers;

insert ignore into subscribers(email)
	values('john.doe@gmail.com'),
			('jane.smith@ibm.com');

		
		