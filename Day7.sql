-- instr(문자열, 검색할 문자, 시작지점, n번째 검색단어)
-- 찾는 문자의 위치를 반환
-- 찾는 문자가 없으면 0을 반환
-- 찾는 단어 앞글자의 인덱스를 반환
SELECT instr('Hello Oracle','Ok') AS idx FROM dual;
SELECT instr('Hello Oracle','Or') AS idx FROM dual;
-- 5번째 인덱스부터 'l' 문자 찾기
SELECT instr('Hello Oracle','l', 5) AS idx FROM dual;
-- 2번째 인덱스부터 'l' 문자 중 2번째 문자 찾기
SELECT instr('Hello Oracle','l', 2, 2) AS idx FROM dual;
-- 뒤에서 3번째 인덱스부터 왼쪽으로 'l' 문자 중 2번째 문자 찾기
SELECT instr('Hello Oracle','l', -3, 2) AS idx FROM dual;


-- 정규표현식
-- REGEXP_INSTR() 함수
-- 문자함수 instr()의 기능을 확장한 것으로 정규 표현식을 이용해 입력된 문장을 검색
SELECT * FROM EMPLOYEES;
SELECT phone_number, REGEXP_INSTR(phone_number, '([[:digit:]]{4})') FROM EMPLOYEES;

CREATE TABLE example(
	ex_a varchar2(100)
);

INSERT INTO example values('abc123-abc-01');
INSERT INTO example values('abb123-abc-02');
INSERT INTO example values('acc123-abc-03');
INSERT INTO example values('add123-abc-04');
INSERT INTO example values('aee123-abc-05');


SELECT * FROM example;

-- 문자열에 'b'가 2번 들어있는 값을 반환(REGEXP_INSTR를 사용)
SELECT ex_a, REGEXP_INSTR(ex_a, 'bb', 1) FROM example; 

SELECT * FROM example where regexp_instr(ex_a, 'bb',1) > 0;
-- REGEXP_INSTR(대상문자열, 패턴, 시작위치, 몇번째 일치, 일치하는 문자열 시작위치)
SELECT * FROM example where regexp_instr(ex_a, 'b',1,3,0) > 0;

-- regexp_substr() 함수
-- 정규 표현식 패턴을 적용하여 문자열 일부를 반환
DROP TABLE example;

-- concat() : 문자열을 연결하는 함수
CREATE TABLE example AS SELECT employee_id, first_name, 
CONCAT(email, '@koreait.com') AS email FROM employees;
	
SELECT * FROM example;
SELECT employee_id, first_name, REGEXP_SUBSTR(email, '[^@]+') AS email_id, 
email FROM example; 

CREATE TABLE t1(
	c1 NUMBER,
	c2 varchar2(10)
);

CREATE TABLE t2(
	c1 varchar2(10),
	c2 number(2)
);

INSERT INTO t1 values(1, 'A');
INSERT INTO t1 values(2, 'C');
INSERT INTO t1 values(3, 'B');
INSERT INTO t1 values(4, '가');
INSERT INTO t1 values(5, NULL);

INSERT INTO t2 values('A', 20);
INSERT INTO t2 values('B', 50);
INSERT INTO t2 values('가', 40);
INSERT INTO t2 values('A', 10);
INSERT INTO t2 values('B', 20);
INSERT INTO t2 values('A', 10);

SELECT * FROM t1; -- A C B 가 null
SELECT * FROM t2; -- A B 가 A B A

-- t1 5번 i/o 발생, t2 6번 i/o 발생
SELECT COUNT(*) FROM t1, t2; 

SELECT t1.c1, t2.c2 FROM t1, t2 WHERE t1.c2 = t2.c1;
SELECT t1.c1, t2.c2 FROM t1 JOIN t2 ON t1.c2 = t2.c1;

SELECT t1.c1, sum(t2.c2) FROM t1, t2 WHERE t1.c2 = t2.c1 GROUP BY t1.c1;

-- left join = 외부조인(left outer join)
SELECT t1.c1, sum(t2.c2) FROM t1 LEFT JOIN t2 ON t1.c2 = t2.c1 GROUP BY t1.c1
ORDER BY t1.c1 asc;

-- 외부 조인 연산자 (+)
SELECT t1.c1, sum(t2.c2) FROM t1, t2 WHERE t1.c2 = t2.c1(+) GROUP BY t1.c1;

SELECT * FROM employees;
SELECT * FROM departments;


SELECT department_name FROM EMPLOYEES, DEPARTMENTS
WHERE last_name = 'King' AND first_name = 'Steven';

SELECT department_name FROM EMPLOYEES, DEPARTMENTS
WHERE last_name = 'King' AND first_name = 'Steven'
AND employees.DEPARTMENT_ID = departments.DEPARTMENT_ID;

SELECT department_name FROM EMPLOYEES e, DEPARTMENTS d
WHERE last_name = 'King' AND first_name = 'Steven'
AND e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- 표준코드(ANSI)로 변경하기
SELECT department_name FROM EMPLOYEES e JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID 
WHERE last_name = 'King' AND first_name = 'Steven';

-- UNION
-- SELECT 결과를 합칠 수 있음
-- 합친 결과에서 중복되는 행은 하나만 표시
-- 컬럼의 개수가 같아야 하고, 각 컬럼의 데이터타입이 같아야 함
/*
 * select * from tb_a
 * union (ALL)
 * select * from tb_b
 */
SELECT * FROM COUNTRIES;
SELECT * FROM regions;

-- 두 테이블을 union 하기 위해 컬럼의 개수와 타입이 같아야 함
-- countries에서 country_name과 region_id를 SELECT
-- regions테이블은 region_name과 region_id를 SELECT

-- 중복을 제거함
SELECT country_name, region_id FROM countries
UNION
SELECT region_name, region_id FROM regions;

-- 중복을 제거하지 않음
SELECT country_name, region_id FROM countries
UNION ALL
SELECT region_name, region_id FROM regions;