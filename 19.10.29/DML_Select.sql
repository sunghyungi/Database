select user(), database();

select empname, title, salary,
	CASE
		when salary >= 4000000 then '3시 퇴근'
		when salary >= 3000000 then '5시 퇴근'
		when salary >= 2000000 then '7시 퇴근'
		else '야근'
	end 퇴근시간
from employee;

select left(empno, 1), right(empno, 2), empno
	from employee;
	

-- Employee 테이블을 이용해 employee2를 복사하여 생성하고
-- levaeoffice(varchar(10) 속성을 추가하고, 사원번호 첫 글자가 4면 '3시 퇴근'
-- 3이면 '5시 퇴근', 2이면 '7시 퇴근', 그 외 '야근'을 update문장을 이용하여 적용하시오.

drop table if exists employee2;

create table employee2 (
	select * from employee
);

select * from employee2;

alter table employee2 add leaveoffice varchar(10);

update employee2 set leaveoffice = (
	case
		when left(empno, 1) = 4 then '3시 퇴근'
		when left(empno, 1) = 3 then '5시 퇴근'
		when left(empno, 1) = 2 then '7시 퇴근'
		ELSE '야근'
	END 
);

update employee2 set leaveoffice = (
	case left(empno, 1)
		when 4 then '3시 퇴근'
		when 3 then '5시 퇴근'
		when 2 then '7시 퇴근'
		else '야근'
	end
);

-- select
select * from department;
select * from employee;

select deptname, deptno, floor
	from department;
-- from 테이블명 먼저 치면 ctrl+space로 컬럼이 자동완성 사용 가능


-- distinct (중복 제거)
select title
	from employee;

select distinct title
	from employee;

-- where (조건 부여)
select *
	from employee
where dno = 2;

-- % 사용 문자열 비교
-- %는 0개 이상의 문자, _는 1개의 문자
-- 이씨 성을 가진 사원들의 이름, 직급, 소속 부서를 검색 하라.
select empname, title, dno
	from employee
where empname like '이%';
-- not like 사용가능

-- and
-- 직급이 과장이면서 1번 부서에서 근무하는 사원들의 이름과 급여를 검색하라.
select * from employee;

select empname, salary
	from employee
where title = '과장' and dno = 1;

-- 직급이 과장이면서 1번 부서에 속하지 않은 사원들의 이름과 급여를 검색하라.
select empname, salary
	from employee
where title = '과장' and dno <> 1; -- != 도 사용 가능

-- 급여가 3000000원 이상이고, 4500000원 이하인 사원들의 이름, 직급, 급여를 검색하라.
SELECT empname, title, salary
	from employee
where salary >= 3000000 and salary <= 4500000;

select empname, title, salary
	from employee
where salary between 3000000 and 4500000;

-- or
-- 1번 부서나 3번 부서에 소속된 사원들에 관한 모든 정보를 검색하라.
SELECT *
	from employee
where dno = 1 or dno = 3;

select *
	from employee
where dno in(1,3);


-- 영업 부서나 개발 부서에 소속된 사원들에 관한 모든 정보를 검색하라.

-- 서브쿼리
select e.*
	from employee e
where dno in(select deptno from department where deptname in('영업','개발')); 
		
-- 조인
select e.*
	from employee e, department d
where e.dno = d.deptno and deptname in('영업','개발');


-- 직급이 과장인 사원들에 대하여 이름과, 현재의 급여, 급여가 10%인상 됐을 때의 값을 검색하라.
SELECT empname, salary, salary * 1.1 as newsalary
	from employee
where title = '과장';

-- 개발 부서에 소속 된 사원들에 대해 급여가 15%인상 됐을 때의 값을 검색하라

-- 서브 쿼리
select empname, salary, salary * 1.15 as newsalary
	from employee
where dno = (select deptno from department where deptname = '개발');

-- 조인
select empname, salary, salary * 1.15 as newsalary
	from employee e, department d
where e.dno = d.deptno and d.deptname = '개발';

-- count(*)
-- 사원의 수
select *
	from employee;

select count(*) as 사원수
	from employee;

select count(empno), count(manager)
	from employee;

-- NULL
select null > 300, null = 300, null <> 300, null = null, null is null;

-- 사장을 검색
select *
	from employee
where manager is NULL;

-- order by
select *
	from employee
order by manager;
-- 기본키 기준으로 오름차순으로 정렬됨

-- 2번 부서에 근무하는 사원들의 급여, 직급, 이름을 검색하여 급여의 오름차순으로 정렬하라.
select salary, title, empname
	from employee
where dno = 2
	order by salary;
	
-- 사원들의 급여, 직급, 이름을 검색하여 부서별 오름차순, 급여별 내림차순으로 정렬하시오.
select title, empname, dno, salary
	from employee
order by dno, salary desc;

-- 사원들의 직책을 사장->부장->과장->대리->사원 순으로 정렬하시오.
select *
	from employee e
order by field(e.title, '사장', '부장', '과장', '대리', '사원');
					     --   1      2       3      4      5

select field('셋','하나','둘','셋','넷');

select *
	from employee e;

-- case, convert, concat...
-- 자동 형변환

select '200', 200;
select concat(200, '200');	-- 문자열 함수
select '200' + '300';		-- 사칙연산
select 1 >'2mega'; -- 앞의 2로 비교
select 0 = '0mega', 0 = 'mega0';	-- 둘 다 참으로 나옴

select concat(empname, '(', empno, ')') as 사원, salary, title
	from employee;


select if (manager is null, '', manager), ifnull(manager, '')
	from employee;

select empno, empname, title, manager, salary, dno,
if(dno =1, '영업',if(dno =2, '기획', if(dno=3, '개발','소속없음'))),
elt(dno, '영업','기획', '개발', '소속없음')													
	from employee;

select ascii('A'), char(65);

select BIT_LENGTH('abc'), CHAR_LENGTH('abc'), bit_length('지재삼'), CHARACTER_LENGTH('abc'), length('abc');

-- employee gender tinyint(1) 컬럼을 추가
-- employee 테이블에서 gender 사원번호가 짝수면 1로 홀수면 2로 표시하도록 수정하시오
-- gender가 1이면 남자 2면 여자로 검색

alter table employee add column gender tinyint(1);

select * from employee;

update employee set gender = (if(empno%2=0,1,2));
update employee set gender = empno % 2 + 1;

select *, (if(gender = 1,'남자','여자')) as 성별
	from employee;
	
select *, elt(gender,'남자','여자') as 성별
	from employee;
	

