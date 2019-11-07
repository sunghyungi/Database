select user(), database();

-- 박영권과 같은 직급을 갖는 모든 사원들의 이름과 직급을 검색하라
select empname, title
	from employee
where title = (select title from employee where empname = '박영권');

-- select절에서 사용하는 서브쿼리 (스칼라 서브쿼리)
-- 사원정보와 해당 사원의 부서별 평균급여를 검색하시오.
select empno, empname, title, manager, dno,
		(select round(avg(salary)) from employee e2 where e2.dno = e1.dno) as '부서별 평균급여'
	from employee e1; -- scope rule

	
-- From절에서 서브쿼리(Inline View)
-- 1번부서에 소속된 사원의 사원명및 부서명을 검색하시오.
select e.empname, d.deptname
	from employee e, (select deptno, deptname, floor
							from department
						where deptno=1) d
where e.dno = d.deptno;

-- having절에서 서브쿼리
-- 부서별 급여의 평균이 사원의 평균급여보다 많은 부서의 부서번호, 평균급여, 부서명을 검색하시오.
select e.dno, avg(e.salary), d.deptname
	from employee e, department d
where e.dno = d.deptno
	group by e.dno
having avg(salary)>(select avg(salary) from employee);

select dno, avg(salary), (select avg(salary) from employee) 
	from employee e
group by dno;

-- insert문의 values절에서 서브쿼리
-- 사번(1007), 관리자(4377), 1500000, '개발'부서인 서현진사원을 추가하시오
select * from employee;

insert into employee values(
	1007, '서현진', '사원', 4377, 1500000, (select d.deptno from department d where d.deptname='개발'), 2
);

select * from department;


-- In
select *
	from employee
where salary in(select salary from employee where dno=1);

-- Any (어느 하나 보다)
select *
	from employee
where salary > any(select salary from employee where dno = 1);

-- All (모든 것 보다)
select *
	from employee
where salary > all(select salary from employee where dno = 1);


-- In을 사용한 질의
-- 영업부나 개발부에 근무하는 사원들의 이름을 검색하라.

-- SubQuery
select empname
	from employee e
where e.dno in(select deptno from department where deptname in('영업', '개발'));

-- join
select empname
	from employee e, department d
where e.dno = d.deptno and d.deptname in ('영업','개발');


-- EXISTS
-- 영업부나 개발부에 근무하는 사원들의 이름을 검색하라
select empname, dno
	from employee e
where exists(select d.deptno from department d where e.dno=d.deptno and deptname in('영업', '개발'));
                        -- *

-- correlated nested query(상관 중첩 질의)
-- 자신이 속한 부서의 사원들의 평균급여보다 많은 급여를 받는 사원들에 대해서 이름, 부서번호, 급여를 검색하라.
select empname, dno, salary, (select round(avg(y.salary)) from employee y where e.dno=y.dno) as 부서평균급여
	from employee e
where e.salary > (select round(avg(y.salary)) from employee y where e.dno=y.dno);


-- derived table
select *
	from (select empname, title, dno from employee) t
where t.dno in(select deptno from department where deptname ='개발');


-- 순위 구하기
create table rank_tbl(
	name char(1),
	score integer
);

insert into rank_tbl 
VALUES	('F', 60), ('E', 80), ('D', 80),
		('C', 90), ('B', 100), ('A', 100);
	
select * from rank_tbl;


-- 방법 1
select name, score,
	(select count(*)+1 from rank_tbl where score > t.score) as 순위
from rank_tbl t
order by 순위 asc;

-- 급여가 많이 받은 사원 순으로 순위를 검색하라
select empname, salary, (select count(*)+1 from employee where salary > e.salary) as rank
	from employee e
order by rank asc;

-- 방법 2
set @score:=0, @rank:=0;
select name, score,
		greatest(@rank := if(@score = score, @rank, @rank + 1),
		least(0, @score := score)) as 순위
from rank_tbl order by score desc;

select * from rank_tbl;













