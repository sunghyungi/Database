select user(), database();

-- delete

/* 
	DELETE
		from 테이블명
	[where 조건식]
*/

-- department 4번 부서 삭제
select *
	from employee;

select *
	from department;
	
delete 
	from department
where deptno = 4;

-- join
select * from department; -- 3개의 열과 4개의 행
select * from employee; -- 6개의 열과 7개의 행

select *
	from employee, department;	-- 카티션 프로덕트 (join문에 조건이 없을 때)

-- where절 조인, inner join, join, 동등조인
select *
	from employee, department
where dno=deptno;

-- from절 조인
select *
	from employee join department on employee.dno = department.deptno;

select *
	from employee e inner join department d on e.dno = d.deptno; 

-- 동일한 이름이 두 개의 릴레이션에 존재하는 경우 테이블명.속성명으로 접근
create table emp as
	select empno, empname, dno
		from employee;

select * from emp;

create table dept as
	select deptno as dno, deptname
		from department;
		
select * from dept;

select empno, empname, e.dno, deptname
	from emp e, dept d
where e.dno = d.dno;


create table joinTest1(
	a int,
	b varchar(2)
);
insert into joinTest1 values(1, 'a'), (2, 'b'), (3, 'b'), (4,'f');

create table joinTest2(
	b varchar(2),
	c int(2)
);
insert into joinTest2 values('a',1), ('b',2), ('c',3), ('d',4);

select * from joinTest1;
select * from joinTest1 t1 join joinTest2 t2;
select * 
	from joinTest1 t1 join joinTest2 t2 on t1.b = t2.b;

select * 
	from joinTest1 t1, joinTest2 t2
where t1.b = t2.b;

select *
	from joinTest1 t1 join joinTest2 t2 using(b);
	
select *
	from joinTest1 natural join joinTest2;
	
 select *
 	from joinTest1 t1 left join joinTest2 t2 on t1.b=t2.b;
 	
 
show databases;

select *
	from coffee2.product;
	
select *
	from coffee2.sale;
	
select * 
	from coffee2.product p left join coffee2.sale s
		on p.code = s.code
where s.code is null;
	
select *
	from coffee2.product p, coffee2.sale s
where p.code = s.code;

select *
	from employee;

insert into employee values(1004, '이유영', '사원', 4377, 20000000, null);


select *
	from joinTest1 t1, joinTest2 t2
where t1.b = t2.b;

-- 소속부서가 없는 사원을 검색하시오.

select *
	from joinTest1 t1 right join joinTest2 t2 on t1.b = t2.b;

-- t2 - t1
select t2.*
	from joinTest1 t1 right join joinTest2 t2 on t1.b = t2.b
where t1.a is null;


-- delete join

drop table if exists t1, t2;

create table t1(
	id int primary key AUTO_INCREMENT
);

create table t2(
	id varchar(20) primary KEY,
	ref int not NULL
);

insert into t1 values (1),(2),(3);

insert into t2(id,ref)
values('a',1),('b',2),('c',3);

select *
	from t1 join t2 on t1.id = t2.ref;
	
delete t1, t2
	from t1 join t2 on t2.ref = t1.id
where t1.id = 1;

select * from t1;
select * from t2;

insert into t1 values (4);

select *
	from t1 left join t2 on t1.id = t2.ref
where t2.id is null;

delete t1
from t1 left join t2 on t1.id = t2.ref
	where t2.ref is null;
	
-- update
-- 사원번호가 2106인 사원의 급열를 5% 인상된 결과를 검색하시오.

select empno, dno, salary, salary * 1.05 인상안
	from employee
where empno = 2106;

update employee
	set dno = 3, salary = salary * 1.05
where empno = 2106;

-- 사원번호가 1004 사원의 부서를 '영업'으로 변경하시오.
-- update select 문

select * from department;
select * from employee;

select * 
	from employee e,department d
where e.dno = d.deptno;

update employee
	set dno = (select deptno
					from department
				where deptname = '영업')
where empno = 1004;

-- 사원번호가 1005인 사원의 소속 부서를 '총무' 부서로 변경하시오.
-- department3에 있는 총무 부서의 정보를 department에 추가

select * from department3 where deptname='총무';

insert into department (select * from department3 where deptname='총무');

select * from department;
select * from employee;

select *
	from department
where deptname='총무';

update employee
	set dno = (select deptno
					from department
				where deptname='총무')
where empno = 1005;

select * 
	from employee e, department d
where e.dno = d.deptno;



-- update join

create database if not exists empdb;

show databases;

use empdb;

create table merits(
	performance int(11) not null,
	percentage float not null,
	primary key(performance)
);

create table employees(
	emp_id int(11) not null AUTO_INCREMENT,
	emp_name varchar(255) not null,
	performance int(11) default null,
	salary float default null,
	primary key (emp_id),
	constraint fk_performance foreign key (performance)
		references merits(performance)
);

insert into merits(performance, percentage)
	values	(1,0),
			(2, 0.01),
			(3, 0.03),
			(4, 0.05),
			(5, 0.08);
			
insert into employees(emp_name, performance, salary)
	values	('mary doe', 1, 50000),
			('cindy smith', 3, 65000),
			('sue greenspan', 4, 75000),
			('grace dell', 5, 125000),
			('nancy johnson', 3, 85000),
			('john doe', 2, 45000),
			('lily bush', 3, 55000);
			
select * from employees;

select * from merits;

select * 
	from employees e, merits m
where e.performance = m.performance;

select *, round(salary + salary * percentage) '내년 급여'
	from employees e join merits m using(performance);

update employees e join merits m on e.performance = m.performance	-- using(performance)
	set salary = round(salary + salary * percentage);
	
select format(salary + salary * percentage, 0), cast(salary + salary * percentage as signed integer)
	from employees e join merits m using(performance);

-- 신규고용에 대한 급여를 1.5 % 인상
insert into employees(emp_name, performance, salary)
values('jack william', null, 43000),
		('ricky bond', null, 52000);

update employees left join merits using(performance)
	set salary = salary + salary * 0.015
where merits.percentage is null;

select * 
	from employees e left join merits m using(performance)
where m.performance is null;
