/*
	decode() : sql문에 조건문(if)을 사용할 수 있도록 제공
	- decode(컬럼, 조건1, 결과1, 조건2, 결과2 ... 결과 n) ---> (결과n은 default)
	- 찾는 값을 비교할 때 equal 연산만 가능(비교 연산은 불가능)
	
	예) 파이썬
	if 조건식1:
		결과1
	elif 조건식2:
		결과2
	else:
		결과n
*/
SELECT employee_id, job_id FROM employees;

-- job_id가 'SA_REP', 'SA_MAN' -> 'SALES'
SELECT employee_id, job_id, 
	decode(job_id, 'SA_REP', 'SALES1','SA_MAN', 'SALES2') AS departments 
	FROM employees WHERE job_id IN ('SA_REP', 'SA_MAN');

/*
 * case 문
 * 직무 SA_MAN, SA_REP 영업인 사원의 부서를 'sales'로 표현
 */
SELECT employee_id, job_id, CASE job_id
	WHEN 'SA_REP' THEN 'sales1'
	WHEN 'SA_MAN' THEN 'sales2'
	END AS departments
	FROM EMPLOYEES
	WHERE job_id IN ('SA_REP', 'SA_MAN');

-- 부서이름을 출력. 단 8자가 넘는 경우 8자까지만 표시. 그 이하는 '...'
/*
 * LPAD : 지정한 길이만큼 왼쪽부터 특정문자로 채워줌
 * 	LPAD("값", "총문자길이", "채워질 문자")
 * RPAD : 지정한 길이만큼 오른쪽부터 특정문자로 채워줌
 * 	RPAD("값", "총문자길이", "채워질 문자")
 */
SELECT CASE WHEN LENGTH(department_name) <= 8 THEN department_name
	ELSE RPAD(substr(department_name, 1, 8), 10, '..')
	END AS department_name FROM departments;

SELECT * FROM departments;

/*
 * rank() : 순위를 표현할 때 사용하는 함수
 * - order by는 필수
 * 
 * 분석 함수
 * rank() over() : 동일 순위인 경우 1, 1, 3 형식으로 출력
 * row_number() over() : 동일 순위인 경우 1, 2, 3 형식으로 출력
 * dense_rank() over() : 동일 순위인 경우 1, 1, 2 형식으로 출력
 */
-- 영업 부서 사원을 대상으로 급여가 적은 하위 6명의 사원을 출력
SELECT * FROM departments;
SELECT * FROM employees;

SELECT d.department_id, e.first_name, e.last_name, e.salary
FROM employees e, departments d
WHERE e.DEPARTMENT_ID =d.DEPARTMENT_ID AND department_name = 'Sales';

SELECT d.department_id, e.first_name, e.last_name, e.salary,
rank() over(ORDER BY SALARY ASC) rnk
FROM employees e, departments d
WHERE e.DEPARTMENT_ID =d.DEPARTMENT_ID AND department_name = 'Sales';

/*
 * 서브쿼리(sub query)
 * - sql문 내에 쓰인 select 문을 의미
 * - 바깥에 있는 sql문을 메인 쿼리라 부름
 * - 메인 쿼리 안에 포함된 종속적인 관계이기 때문엥 논리적인 실행순서는 항상 메인쿼리에서
 * 읽혀진 데이터에 대해 서브쿼리에서 해당 조건이 만족하는지 확인하는 방식으로 수행
 */

SELECT department_id, first_name, last_name, salary FROM (
	SELECT d.department_id, e.first_name, e.last_name, e.salary,
	rank() over(ORDER BY SALARY ASC) rnk
	FROM employees e, departments d
	WHERE e.DEPARTMENT_ID =d.DEPARTMENT_ID AND department_name = 'Sales'
) WHERE rnk <= 6;

-- rank() 함수를 이용하지 않는 쿼리
SELECT department_id, first_name, last_name, salary,
(SELECT count(salary)+1 FROM EMPLOYEES WHERE DEPARTMENT_ID = 80 AND e.salary > salary) rnk
FROM employees e WHERE DEPARTMENT_ID = 80 ORDER BY rnk ASC;

/*
 * 	percent_rank() : 백분율로 나타냄
 * 
 * 	select 분석함수 over([PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING 절]) FROM 테이블명;
 * 
 * 	OVER() : 분석절, 분석함수에 대한 조절
 * 	PARTITION BY : group by와 동일(그룹지어 결과를 출력)
 * 	ORDER BY -> PARTITION BY로 정의된 그룹을 WINDOW내에서 행들의 정렬 순서를 정의
 * 	
 * 	from -> where -> group by -> having -> select -> order by -> over()
 * 
 */
-- 배송 업무(job_id -> SH로 시작)를 담당하는 사원을 대상으로 급여를 많이 받는 순위 20%내의 사원정보
SELECT * FROM employees;
SELECT department_id, first_name, last_name, salary, 
	PERCENT_RANK() over(PARTITION BY job_id ORDER BY salary DESC) * 100 AS rnk
	FROM EMPLOYEES e WHERE job_id LIKE 'SH%';

SELECT * from(
	SELECT department_id, first_name, last_name, salary, 
	ROUND(PERCENT_RANK() over(PARTITION BY job_id ORDER BY salary DESC) * 100, 2) AS rnk
	FROM EMPLOYEES e WHERE job_id LIKE 'SH%'
) WHERE rnk <= 20;

/*
 * 	sum() 함수 : 누적 합계를 구할 때 사용
 */
-- 재고 관련 업무를 하는 사원들을 대상으로 업무별 누적 급여의 합
-- 'ST%'
SELECT employee_id, job_id, salary,
	sum(salary) OVER(PARTITION BY job_id ORDER BY salary ASC) accm_sal
	FROM EMPLOYEES e WHERE job_id LIKE 'ST%';

/*
 * 	avg() : 평균을 구하는 함수
 * - 분석함수로도 사용
 * - 분석함수로 사용될 때는 레코드 세트와 함께 평균의 정보를 얻을 수 있음
 * - 그룹을 나눴다면 그룹 내 레코드 세트와 평균값을 함께 얻을 수 있음
 */
-- 사원 자신의 받는 급여가 해당 부서 내 평균과 얼마나 차이가 있는지 확인
-- (단, 부서발령을 받지 않은 사람은 제외)
SELECT * FROM employees;
SELECT employee_id, first_name, salary,
	round(avg(salary) OVER(PARTITION BY department_id)) AS avg_dept_sal,
	TO_CHAR(salary - avg(salary) over(PARTITION BY department_id), '$999,999') AS diff
	FROM EMPLOYEES WHERE DEPARTMENT_ID IS NOT NULL;

/*
 * 정규 표현식
 * aaaa-.@aaa.aaa
 * 010-0000-0000
 */

CREATE READ UPDATE DELETE (CRUD)
