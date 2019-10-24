-- employee 테이블 삭제
drop table if EXISTS employee;
-- department 테이블 삭제
drop table if EXISTS department;


-- department 테이블 생성
create table if not exists department(
	deptno int(11) not null AUTO_INCREMENT,
	deptname char(10),
	floor int(11) DEFAULT 0,
	PRIMARY KEY (deptno)
);

-- employee 테이블 생성
create table if not exists employee(
	empno int(11) not null,
	empname varchar(20) unique,
	title varchar(10) default '사원',
	manager int(11),
	salary int(11),
	dno int(11) default 1,
	primary key (empno),
	foreign key (manager) REFERENCES employee(empno),
	foreign key (dno) REFERENCES department (deptno)
	on delete no ACTION
	on update cascade
);

-- 테이블 생성 확인
desc department;
desc employee;

-- 테이블 제약조건 확인 (기본키, 외래키, ..)
select TABLE_SCHEMA, TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME
	from information_schema.TABLE_CONSTRAINTS;

-- alter문을 이용한 테이블 이름 변경
alter table employee rename to emp;
desc emp;

alter table emp rename to employee;
desc employee;


-- 속성(애트리뷰트) 생성, 삭제 (테이블 변경)
alter table employee add column phone char(13);
alter table employee drop phone;

-- 속성 변경
alter table employee change column empname name char(30);
alter table employee change column name empname varchar(20);


alter table employee modify column title char(20);
desc employee;

alter table employee modify column title varchar(10);


drop table employee;
create table if not exists employee(
	empno int(11) not null,
	empname varchar(20) unique,
	title varchar(10) default '사원',
	manager int(11),
	salary int(11),
	dno int(11) default 1,
	primary key (empno),
	foreign key (manager) REFERENCES employee(empno),
	foreign key (dno) REFERENCES department (deptno)
		on delete cascade
);

-- department 테이블에 튜플 insert
insert into department(deptname, floor) values('영업', 8);
select * from department;

delete from department where deptno = 2;   









