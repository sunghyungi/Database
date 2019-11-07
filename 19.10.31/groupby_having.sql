select user(), database();

select count(*), count(manager)
	from employee;

select *
	from employee;
	
select count(distinct(title)) as 직책수
	from employee;
	
-- group by
-- 모든 사원들의 평균 급여와 최대 급여를 검색
select format(avg(salary),0) as '평균 급여', max(salary) as '최대 급여'
	from employee;
	
select dno, avg(salary)
	from employee
group by dno;

-- 모든 사원들에 대해서 사원들이 속한 부서번호 별로 그룹화하고, 각 부서마다 부서번호, 평균급여, 최대 급여를 검색하라
select concat(deptname, '(', dno, ')') 부서, round(avg(salary),-1) 평균급여, max(salary) 최대급여
	from employee e, department d
where e.dno = d.deptno
	group by dno;
	
-- 모든 사원들에 대해서 사원들이 속한 부서번호 별로 그룹화하고, 평균 급여가 2500000원 이상인 부서에 대해서
-- 부서번호, 평균급여, 최대급여를 검색하라
select concat(deptname, '(', dno, ')') 부서, round(avg(salary),-1) 평균급여, max(salary) 최대급여
	from employee e, department d
where e.dno = d.deptno
	group by dno
having avg(salary)>= 2500000;

 -- where 절에 조건을 넣는 것(아래)이 더 성능적으로 좋음
select concat(deptname, '(', dno, ')') 부서, round(avg(salary),-1) 평균급여, max(salary) 최대급여
	from employee e, department d
where e.dno = d.deptno
	group by dno
having dno in (1,2);

select concat(deptname, '(', dno, ')') 부서, round(avg(salary),-1) 평균급여, max(salary) 최대급여
	from employee e, department d
where e.dno = d.deptno and dno in (1,2)
	group by dno;


-- 김창섭이 속한 부서이거나 개발 부서의 부서번호를 검색하라
select distinct(dno)
	from employee e, department d
where e.dno=d.deptno and (empname ='김창섭' or d.deptname = '기획');

(select dno
	from employee
where empname = '김창섭')
UNION
(select deptno
	from department
where deptname = '기획');

select * from employee;
select * from department;


-- join
-- 학생테이블을 생성(학생 번호, 성명, 국어, 영어, 수학)
-- student(sno, sname, kor, eng, math) 테이블 생성, 학생 데이터 입력 후
-- 학생번호, 학생명, 국어, 영어, 수학, 총점, 평균을 검색하시오(select문)
-- 나머지 학생 국어, 영어, 수학 점수는 랜덤하게 0~100사이의 점수가 입력되도록 하여 9명의 데이터를 입력
-- 평균점수에 따라 성적(grade)를 구하시오
create table student(
	sno int AUTO_INCREMENT primary key,
	sname varchar(20),
	kor int,
	eng int,
	math int
);

select * from student;

insert into student(sname, kor, eng, math)
	values	('지재삼', 90, 80, 70),
			('김승영', 78, 68, 58),
			('이지혜', 89, 70, 50);

select sno, sname, kor, eng, math, (kor + eng + math) 총점, round((kor + eng + math)/3) 평균
	from student;

select sno, sname, kor, eng, math, (kor + eng + math) 총점, round((kor + eng + math)/3) 평균,
case
	when round((kor+eng+math)/3)>=90 then 'A'
	when round((kor+eng+math)/3)>=80 then 'B'
	when round((kor+eng+math)/3)>=70 then 'C'
	when round((kor+eng+math)/3)>=60 then 'D'
	else 'F'
END 성적
	from student;

update student set kor = floor(rand()*100), eng = floor(rand()*100), math = floor(rand()*100)
where sname not in('지재삼','김승영','이지혜');



create table sal_grade(
	grade int primary key,
	losal int,
	hisal int
);

insert into sal_grade VALUES
(1, 0, 1500000),
(2, 1500001, 2000000),
(3, 2000001, 3000000),
(4, 3000001, 4000000),
(5, 4000001, 9999999);

select * from sal_grade;

-- 모든 사원의 급여에 대한 등급을 검색하시오
SELECT e.empno, e.empname, e.salary, g.grade, g.losal, g.hisal 
	from employee e, sal_grade g
where e.salary between g.losal and g.hisal;


-- 이전 문제 적용
create table s_grade(
	grade char(5),
	loavg int,
	hiavg int
);

insert into s_grade VALUES
('A+', 96, 100),
('A0', 91, 95),
('B+', 86, 90),
('B0', 81, 85),
('C+', 76, 80),
('C0', 71, 75),
('D+', 66, 70),
('D0', 61, 65),
('F', 0, 60);

select * from s_grade;
select s.sname, s.kor, s.eng, s.math, (kor+eng+math)/3 평균, g.grade, g.loavg, g.hiavg
	from student s, s_grade g
where (kor+eng+math)/3 between g.loavg and g.hiavg;

-- 서브쿼리 이용 각 과목 성적 검색
select gs.grade from student ss, s_grade gs where ss.kor between gs.loavg and gs.hiavg;

select s.sname,
		concat(s.kor, '(', (select gs.grade from s_grade gs where kor between gs.loavg and gs.hiavg),')') as 국어성적,
		concat(s.eng, '(', (select gs.grade from s_grade gs where eng between gs.loavg and gs.hiavg),')') as 영어성적,
		concat(s.math, '(', (select gs.grade from s_grade gs where math between gs.loavg and gs.hiavg),')') as 수학성적,
		floor((kor+eng+math)/3) 평균, g.grade
	from student s, s_grade g
where (kor+eng+math)/3 between g.loavg and g.hiavg;


select * from student;

-- join 이용
select s.sname,
		concat(s.kor, '(', g.grade, ')') 국어성적,
		concat(s.eng, '(', e.grade, ')') 영어성적,
		concat(s.math,'(', m.grade, ')') 수학성적
	from student s, s_grade g, s_grade e, s_grade m
where (kor between g.loavg and g.hiavg) and (eng between e.loavg and e.hiavg) and (math between m.loavg and m.hiavg);




-- 모든 사원에 대해서 사원의 이름과 직속 상사의 이름을 검색하라.
select e.empname 사원, y.empname 직속상사 
	from employee e, employee y
where e.manager=y.empno;

select * from employee;

-- 모든 사원에 대해서 아래 결과와 같이 나오도록 검색하라.
-- if 사용
select e.empno, e.empname, e.title, if(e.manager is null,'없음',concat(y.empname,'(',y.empno,')')) 직속상사, e.salary,
		if(e.dno is null, '소속없음', concat(d.deptname,'(',d.deptno,')')) 부서
	from employee e left join employee y on e.manager=y.empno left join department d on e.dno = d.deptno
order by d.deptname, e.salary desc;

-- ifnull 사용
select e.empno, e.empname, e.title, ifnull(concat(y.empname,'(',y.empno,')'),'없음') 직속상사, e.salary,
		ifnull(concat(d.deptname,'(',d.deptno,')'), '소속없음') 부서
	from employee e left join employee y on e.manager=y.empno left join department d on e.dno = d.deptno
order by d.deptname, e.salary desc;

-- left join 할 때는 from 절에서 해야함(mysql은 where절 left join 불가능)

update employee set dno = NULL	
 	where empname in('이유영', '조민희');

 -- 부서별 오름차순, 직책별 정렬
 select e.empno, e.empname, e.title, ifnull(concat(y.empname,'(',y.empno,')'),'없음') 직속상사, e.salary,
		ifnull(concat(d.deptname,'(',d.deptno,')'), '소속없음') 부서
	from employee e left join employee y on e.manager=y.empno left join department d on e.dno = d.deptno
order by d.deptno, field(e.title,'사장','부장','과장','대리','사원');

 






