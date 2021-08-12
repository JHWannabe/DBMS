/*
 * 트랜젝션(Transaction)
 * - 하나의 작업의 단위
 * - 데이터베이스의 상태를 변환시키는 하나의 논리적 기능을 수행하기 위한 작업의 단위
 * - rollback(복원), commit(완료)
 * - savepoint
 * - 예) savepoint sp1; -> rollback to sp1;
 * 
 * 사용 이유
 * - 사용자, 오라클서버, 애플리케이션 개발자, DBA등에게 데이터 일치성과 데이터 동시발생을 보장
 */
CREATE TABLE bonuses (
	employee_id number(6),
	bonus number(8,2)
);

INSERT INTO bonuses values(100, 2400);

SELECT * FROM bonuses;

DELETE FROM bonuses;

-- 한번에 전 사원을 기준으로 급여의 10%를 보너스로 지급
SELECT * FROM EMPLOYEES e ;

INSERT INTO bonuses
	SELECT employee_id, salary * 0.1 FROM EMPLOYEES;
	COMMIT;
	
DELETE FROM bonuses WHERE employee_id = 100;
SELECT * FROM bonuses;
ROLLBACK;
COMMIT;

-- rownum : 조회된 순서대로 순번을 적용
SELECT rownum, employee_id, bonus FROM bonuses;
DELETE FROM bonuses WHERE rownum = 1;
ROLLBACK;

/*
 * 뷰(view)
 * - 하나 이상의 테이블이나 다른 뷰의 데이터를 볼 수 있게 하는 데이터베이스 객체
 * - 실제 데이터는 뷰를 구성하는 테이블에 담겨 잇지만 마치 테이블처럼 사용할 수 있음
 */
-- 사원중에서 입사일이 빠른 사람 10명 출력
SELECT employee_id, first_name, last_name, hire_date FROM employees ORDER BY hire_date;

SELECT rownum, employee_id, first_name, last_name FROM employees;
SELECT rownum, employee_id, first_name, last_name FROM employees WHERE rownum <= 10;

CREATE OR REPLACE VIEW vw_emp_hiredateASC AS
	SELECT * FROM employees ORDER BY hire_date;

SELECT employee_id, first_name, last_name, hire_date FROM vw_emp_hiredateASC
WHERE rownum < 11;


CREATE VIEW vw_jobs(job_id, job_title, min_salary, max_salary) AS
SELECT * FROM jobs;

SELECT * FROM vw_jobs;

CREATE TABLE tb_test01(
	key_01 varchar2(10),
	key_02 varchar2(10),
	col_01 varchar2(100),
	col_02 varchar2(100),
	CONSTRAINT pk_test01 PRIMARY key(key_01, key_02)
);

-- disable novalidate : constraint 없는 것과 동일 -> 데이터를 거르지 않고 넣어줌
CREATE OR REPLACE VIEW vw_test01(
	key_01,
	key_02,
	col_01,
	CONSTRAINT pk_vw_test01 PRIMARY key(key_01, key_02) disable novalidate
) AS
SELECT KEY_01, key_02, col_01 FROM tb_test01;

SELECT * FROM tb_test01;
SELECT * FROM vw_test01;

INSERT INTO vw_test01(key_01, key_02, col_01)
values('apple','김사과','1111');


-- 문제1 employees 테이블에서 20번 부서(department_id)의 세부 사항을 포함하는
-- emp_20 view를 생성
CREATE OR REPLACE VIEW emp_20
AS SELECT * FROM employees WHERE DEPARTMENT_ID = 20;

SELECT * FROM emp_20;

-- 문제2 employees 테이블에서 30번 부서만 employee_id를 emp_no로
-- last_name을 name으로 salary를 sal로 바꾸어 emp_30 view를 생성
CREATE OR REPLACE VIEW emp_30("emp_no", "name", "sal")
AS SELECT employee_id, last_name, salary FROM employees WHERE DEPARTMENT_ID = 30;

SELECT * FROM emp_30;

-- 문제3 부서별로 부서명, 최소급여, 최대급여, 부서의 평균급여를 포함하는 dept_sum view를 생성
-- 필드명 : 부서명, 최소급여, 최대급여, 평균급여
SELECT * FROM EMPLOYEES e ;
SELECT * FROM dept_sum;

CREATE OR REPLACE VIEW dept_sum("부서명","최소급여","최대급여","평균급여")
AS SELECT department_name, min(salary), max(salary),trunc(avg(salary),0)
FROM employees e, departments d WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY department_name;

/*
 * 시퀀스(sequence)
 * - 자동으로 순차적으로 증가하는 순번을 반환하는 데이터베이스 객체
 * - 중복값을 방지하거나 PK값을 설정
 * create sequence 시퀀스명 옵션...
 * increment by [증감숫자] : 증감숫자가 양수면 증가, 음수면 감소. default는 1
 * start with [시작숫자] : 시작숫자의 디폴트값은 증가일 때 minvalue, 감소일 때 maxvalue
 * minvalue [최소값]
 * maxvalue [최대값]
 * cycle or nocycle : cycle 설정시 최대값에 도달하면 최소값부터 다시 시작
 */
CREATE SEQUENCE test_seq
INCREMENT BY 1
START WITH 10
MAXVALUE 1000;

SELECT test_seq.currval FROM dual; -- 에러
SELECT test_seq.nextval FROM dual; -- nextval로 먼저 초기화해야 사용가능
SELECT test_seq.currval FROM dual; -- 현재 값
SELECT test_seq.nextval FROM dual; -- 11로 증가되어 있음

CREATE TABLE tb_ex(
	idx number(10) NOT NULL,
	userid varchar2(20) NOT NULL
);

INSERT INTO tb_ex(idx, userid) values(test_seq.nextval, 'apple');
SELECT * FROM tb_ex;
INSERT INTO tb_ex(idx, userid) values(test_seq.nextval, 'banana');
INSERT INTO tb_ex(idx, userid) values(test_seq.nextval, 'orange');
INSERT INTO tb_ex(idx, userid) values(test_seq.nextval, null);
INSERT INTO tb_ex(idx, userid) values(test_seq.nextval, 'null');

/*
 * alter sequence [시퀀스명] 옵션..
 */
ALTER SEQUENCE test_seq
INCREMENT BY 2
MINVALUE 1
MAXVALUE 10000
CYCLE;

INSERT INTO tb_ex(idx, userid) values(test_seq.nextval, 'orange');

DROP SEQUENCE test_seq;

/*
 * index(색인)
 * - index는 원하는 정보의 위치를 빠르고 정확하게 알아낼 수 있는 방법
 * - 자동생성 : primary key
 * - 수동생성 : Query로 만들어서 사용
 * 
 * 생성하면 좋은 경우
 * - WHERE절이나 JOIN조건 안에 자주 사용되는 컬럼
 * - null값이 많이 포함되어 있는 컬럼
 * 
 * 생성하면 안좋은 경우
 * - 테이블이 작을 때(row가 10000개 이하)
 * - 테이블이 자주 갱신될 때
*/
CREATE TABLE emp_copy
AS SELECT * FROM employees;

SELECT * FROM emp_copy;

ALTER TABLE emp_copy ADD CONSTRAINT pk_emp_01 PRIMARY KEY (employee_id);

SELECT * FROM all_indexes WHERE index_name IN ('PK_EMP_01');

CREATE INDEX emp_index1 ON emp_copy(manager_id);