select user(), database();

create table pivotTest(
		uName char(3),
		season char(2),
		amount int
);

insert into pivotTest 
	values ('김범수', '겨울', 10),
			('윤종신', '여름', 15),
			('김범수', '가을', 25),
			('김범수', '봄', 4),
 			('김범수', '봄', 40),
 			('윤종신', '겨울', 40),
  			('김범수', '여름', 15),
			('김범수', '겨울', 22),
  			('윤종신', '여름', 65);
  			
  select * from pivotTest;
  
 select *
 	from pivotTest
 order by uname, field(season, '봄', '여름', '가을', '겨울');
 
select uname, sum(if(season='봄', amount, 0)) as '봄',
				sum(if(season='여름', amount, 0)) as '여름',
				sum(if(season='가을', amount, 0)) as '가을',
				sum(if(season='겨울', amount, 0)) as '겨울',
				sum(amount) as '합계'
	from pivotTest
group by uname;



select season, 	sum(if(uname='김범수', amount, 0)) as '김범수',
					sum(if(uname='윤종신', amount, 0)) as '윤종신',
					sum(amount) as '합계'
	from pivotTest
group by season
UNION
	select '합계', sum(if(uname='김범수', amount, 0)) as '김범수',
					sum(if(uname='윤종신', amount, 0)) as '윤종신',
					sum(amount) as '합계'
		from pivotTest
	order by field(season, '봄', '여름', '가을', '겨울', '합계');


select uname, count(if(season='봄',1,null)) as '봄',
				count(if(season='여름',1,null)) as '여름',
				count(if(season='가을',1,null)) as '가을',
				count(if(season='겨울',1,null)) as '겨울',
				count(amount) as '합계'
	from pivotTest
	group by uname;

select season, count(if(uname='김범수', 1, null)) as '김범수',
				 count(if(uname='윤종신', 1, null)) as '윤종신',
				 count(amount) as '합계'
	from pivotTest
	group by season
union
select '합계',	 count(if(uname='김범수', 1, null)) as '김범수',
				 count(if(uname='윤종신', 1, null)) as '윤종신',
				 count(amount) as '합계'
	from pivotTest
order by field(season, '봄', '여름', '가을', '겨울', '합계');

-- 급여가 400만 이상, 300만 이상, 200만 이상, 그 외로 구간별 사원을 구하시오.
-- count, if 사용
select '급여별 인원수', count(if(salary>=4000000, 1, null)) as '400 이상',
						count(if(salary<4000000 and salary>=3000000, 1, null)) as '300 이상',
						count(if(salary<3000000 and salary>=2000000, 1, null)) as '200 이상',
						count(if(salary<2000000, 1, null)) as '그 외',
						count(salary) as '합계'
		from employee;
	
select * from employee order by salary desc;

-- 추후 구간 변경 등에 대비하기 위해 별도의 테이블 생성, 조인 이용
create table grade(
	grade int,
	low int,
	high int
);

insert into grade values 
	(4, 4000000, 9999999),
	(3, 3000000, 3999999), 
	(2, 2000000, 2999999), 
	(1, 0, 1999999);

select * from grade;


select '급여별 인원수', 	count(if(grade=4, 1, null)) as '400 이상',
						count(if(grade=3, 1, null)) as '300 이상',
						count(if(grade=2, 1, null)) as '200 이상',
						count(if(grade=1, 1, null)) as '그 외',
						count(salary) as '합계'
	from employee e, grade g
where salary between g.low and g.high;


select ifnull(deptname, '부서없음') as '부서별',
				count(if(grade=4, 1, null)) as '400 이상',
				count(if(grade=3, 1, null)) as '300 이상',
				count(if(grade=2, 1, null)) as '200 이상',
				count(if(grade=1, 1, null)) as '그 외',
				count(salary) as '합계'
	from employee e left join department d on e.dno = d.deptno, grade g
where salary between g.low and g.high
group by deptname
union
select '전체', count(if(grade=4, 1, null)) as '400 이상',
				count(if(grade=3, 1, null)) as '300 이상',
				count(if(grade=2, 1, null)) as '200 이상',
				count(if(grade=1, 1, null)) as '그 외',
				count(salary) as '합계'
		from employee e, grade g
	where salary between g.low and g.high;


-- rollup

select d.deptname, count(*) 사원수, sum(e.salary) as '급여 합계'
	from employee e left join department d on e.dno = deptno
group by deptname;

select * from employee;
select * from department;

select ifnull(deptname, '부서없음')as 부서, count(*) as '사원수', sum(salary) as '급여 합계'
	from employee e left join department d on e.dno = d.deptno
	group by d.deptname with rollup;


select ifnull(deptname, '모든부서') as '부서', count(*) as '사원수', sum(salary) as '급여 합계'
	from (select ifnull(deptname, '소속없음') as deptname, salary
					from employee e left join department d on e.dno = d.deptno) t
	group by deptname with rollup;


select title, count(if(salary, 1, 0)), sum(salary)
	from employee
group by title;

select ifnull(title, '총계') 직책, count(if(salary, 1, 0)), sum(salary)
	from employee
group by title with rollup;

select ifnull(deptname, '모든 부서') as '부서', ifnull(title, '전체') as '직책', count(*) as '사원수', sum(salary) as '급여합계'
	from (select empno, empname, title, manager, salary, ifnull(deptname, '소속없음') as deptname
          from employee e left join department d on e.dno = d.deptno) t
  group by t.deptname, t.title with rollup;









				