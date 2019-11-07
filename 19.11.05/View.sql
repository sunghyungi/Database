select user(), database();

-- view
-- 3번 부서에 근무하는 사원들의 사원번호, 사원이름, 직책, 부서번호로 이루어진 뷰를 정의하시오.
drop view vw_employee_dno3;

create view  vw_employee_dno3(eno, ename, title, dno) as
select empno, empname, title, dno
	from employee
where dno = 3
 with check option;

select *
	from vw_employee_dno3;
	

-- employee와 department 릴레이션에 대해서 "기획부에 근무하는 사원들의 이름, 직책, 급여로 이루어진 뷰를 정의하시오"

create view emp_planning as
select e.empname, e.title, e.salary
	from employee e, department d
where e.dno = d.deptno and d.deptname = '기획';

select *
	from emp_planning
where empname = '이성래';

select e.empname, e.title, e.salary
	from employee e, department d
where e.dno = d.deptno and d.deptname = '기획' and empname = '이성래';

create view vw_full_employee as
select concat(e.empname, '(', e.empno, ')') 사원,
		e.title,
		concat(m.empname, '(', e.manager, ')') 직속상사,
		e.salary,
		concat(deptname, '(', deptno, ')') 소속부서
	from employee e join employee m on e.manager = m.empno join department d on e.dno = d.deptno;


select *
	from vw_full_employee
where title like '과%';

select * from employee;

update vw_employee_dno3
	set dno = 2
where eno = 3427;


-- view의 장점

select *
	from employee2;

create table emp1 as
select empno, empname, salary
	from employee2;

create table emp2 as
select empno, title, manager, dno
	from employee2;

select *
	from employee2;

drop table employee2;

create view employee2 as
select e1.empno, e1.empname, e2.title, e1.salary, e2.manager, e2.dno
 from emp1 e1, emp2 e2
 where e1.empno = e2.empno;
 
drop view employee2;


-- 데이터 보안 기능 제공 (동일한 릴레이션에 여러가지 뷰를 생성)
-- 총무(manager(x), dno(x)), 인사(salary(x))

create view vw_chongmu as
select empno, empname, title, salary
	from employee;
	
select *
	from vw_chongmu;
	
create view vw_insa as
select empno, empname, title, manager, dno
	from employee;
	
select *
	from vw_insa;
	

-- view 갱신 (기본키 없이는 insert 안됨)

select *
	from vw_employee_dno3;

insert into vw_employee_dno3 values(1006, '태연', '사원', 3);
-- insert into employee(empno, empname, title, dno) values(1006, '태연', '사원', 3);

select *
	from employee;
	
select * from emp_planning;

insert into emp_planning values('김선호', '과장', 3100000);
-- insert into employee(empname, title, salary) values('김선호', '과장', 3100000);


-- 집단함수를 포함한 view
create view vw_emp_avgsal as
select dno, avg(salary) as avgsal
	from employee
group by dno;

select dno, avgsal
	from vw_emp_avgsal;
	
update vw_emp_avgsal
	set avgsal = 5000000
where dno = 1;

insert into vw_emp_avgsal values(5, 5000000);

select *
	from vw_full_employee;
	




















