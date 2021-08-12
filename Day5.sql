-- 사원 테이블
SELECT * FROM employees;

-- 사번, 이름, 입사년월일 출력
SELECT employee_id, first_name, last_name, hire_date FROM employees;

-- 입사한 월
-- extract() : 날짜 데이터로 부터 원하는 값을 반환
-- extract(일 or 월 or 년 from 필드명)
SELECT employee_id, first_name, last_name, hire_date, EXTRACT(MONTH FROM hire_date) AS HIRE_MONTH FROM employees;

-- 입사 분기
-- ceil() : 올림 처리한 정수값을 반환
SELECT employee_id, first_name, last_name, hire_date, EXTRACT(MONTH FROM hire_date) AS HIRE_MONTH, ceil(EXTRACT(MONTH FROM hire_date)/3) AS Quarter FROM employees;

-- 분기별로 입사한 사원수
SELECT CEIL(EXTRACT(MONTH FROM hire_date)/3) AS Quarter, count(employee_id) AS Count_Member FROM employees GROUP BY ceil(EXTRACT(MONTH FROM hire_date)/3);


-- 2005년 3월에 입사한 사원을 대상으로 일주일 간격으로 입사자의 수
-- 2005년 3월 입사자
-- trunc() : 원하는 소수점 자릿수만큼 반환
-- trunc(값, 옵션)
-- trunc(소수점포함, 1) --> 첫째 절사
-- trunc(날짜, 'YEAR')

SELECT employee_id, EXTRACT(DAY FROM hire_date) AS hire_day FROM employees WHERE extract(YEAR FROM hire_date) = 2005 AND EXTRACT(MONTH FROM hire_date) = 3;
-- 주차
SELECT employee_id, EXTRACT(DAY FROM hire_date) AS hire_day, trunc(EXTRACT(DAY FROM hire_date)/7)+1 AS num_week FROM employees WHERE extract(YEAR FROM hire_date) = 2005 AND EXTRACT(MONTH FROM hire_date) = 3;
-- 각 주에 입사한 사원수
SELECT trunc(EXTRACT(DAY FROM hire_date)/7)+1 AS num_week, count(employee_id) AS Count_Member FROM employees WHERE extract(YEAR FROM hire_date) = 2005 AND EXTRACT(MONTH FROM hire_date) = 3 GROUP BY trunc(EXTRACT(DAY FROM hire_date)/7)+1 ORDER BY num_week;

-- 짝수 해와 홀수 해에 입사한 사원의 정보
-- 연도별 입사자
SELECT EXTRACT(YEAR FROM hire_date), count(employee_id) FROM employees GROUP BY EXTRACT(YEAR FROM hire_date);
-- mod() : 값을 나눈 다음 그 나머지를 구함
-- 짝수와 홀수 연도를 구분하기 위해 mod() 사용
SELECT mod(EXTRACT(YEAR FROM hire_date), 2) AS oddeven, count(employee_id) AS Count_Member FROM employees GROUP BY mod(EXTRACT(YEAR FROM hire_date), 2);
-- 출력 결과를 수정
/*
 * 	case 값 when 비교값 then 출력1 else 출력2 end
 */
SELECT CASE mod(EXTRACT(YEAR FROM hire_date), 2)
	WHEN 0 THEN 'even' ELSE 'odd' END AS YEAR
	, count(employee_id) AS Count_Member FROM EMPLOYEES GROUP BY mod(EXTRACT(YEAR FROM hire_date), 2);

-- 2005년에 입사한 사원의 정보를 상반기, 하반기로 구분해서 출력
SELECT employee_id, hire_date FROM employees WHERE extract(YEAR FROM hire_date) = 2006;
-- 2005년에 입사한 사원의 월
SELECT employee_id, hire_date, EXTRACT(MONTH FROM hire_date) AS MONTH FROM employees WHERE extract(YEAR FROM hire_date) = 2006;
/*
 * width_bucket() : 최소값과 최대값을 설정하고 버킷을 설정한 다음 지정한 값이 범위에서 어느 위치에 있는지 반환
 * width_bucket(값, 최소값, 최대값+1, 2) -> width_bucket(값, 1, 13, 2)
 */
-- 2005년 상반기, 하반기 입사한 사원 수
SELECT WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date), 1, 13, 2) AS Half_Year, count(employee_id) AS Count_Member FROM employees WHERE extract(YEAR FROM hire_date) = 2005 GROUP BY WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date), 1, 13, 2);
SELECT CASE WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date), 1, 13, 2)
WHEN 1 THEN '상반기' ELSE '하반기' END AS half_Year,
count(employee_id) FROM EMPLOYEES WHERE extract(YEAR FROM hire_date) = 2005 GROUP BY WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date),1,13,2);

-- round() : 숫자를 지정한 자리 수로 반올림하여 반환
SELECT round(19.854, 1) FROM dual;
SELECT round(265, -1) FROM dual;

-- substr() : 문자열에서 일부 문자만을 반환
SELECT substr('대한민국', 1, 2) FROM dual; -- 1부터 2글자
SELECT substr('oracle database', 7) FROM dual; -- 7부터 끝까지
SELECT substr('oracle database', -7) FROM dual; -- 끝에서 7자리

-- concat() : 입력되는 두 문자열을 연결한 다음 그 값을 반환
SELECT * FROM employees;
SELECT last_name || ' ' || first_name AS name FROM employees;
SELECT concat(last_name, first_name) AS name FROM employees;
SELECT concat(last_name, concat(' ', first_name)) AS name FROM employees;

-- trim(), ltrim(), rtrim() : 문자열에서 공백이나 특정 문자를 제거한 값을 반환
CREATE TABLE sample(
	test varchar2(20)
);

INSERT INTO sample values('oracle');
INSERT INTO sample values('oracle ');
INSERT INTO sample values(' oracle');
INSERT INTO sample values('apple');
INSERT INTO sample values('orange');

SELECT * FROM sample;
SELECT * FROM sample WHERE test='oracle';
SELECT * FROM sample WHERE trim(test)='oracle';

-- 날짜 함수
SELECT * FROM employees;
SELECT sysdate + 365 FROM dual;
-- add_months() : 특정 날짜의 월에 정수를 더한 다음 해당 날짜를 반환
SELECT ADD_MONTHS(sysdate, 12) FROM dual;
-- months_between() : 날짜 간의 차이를 월로 반환
-- 현재 근무하는 사원의 재직 기간을 계산
SELECT employee_id, hire_date FROM employees;
SELECT employee_id, sysdate-hire_date FROM employees;
SELECT employee_id, floor((sysdate-hire_date) /365) AS YEAR FROM employees;
SELECT employee_id, floor((sysdate-hire_date) /365) AS YEAR, MOD(MONTHS_BETWEEN(sysdate, hire_date), 12) AS MONTH FROM employees;

-- extract()
-- to_char() : 날짜를 문자형 데이터로 변환
SELECT to_char(sysdate, 'HH24:MI:SS') AS time FROM dual;
/*
 *  D : 주(1~7) 1은 일요일, 7은 토요일
 *  DD : 일(1~31)
 *  DDD : 1년 중 날짜(1-366)
 *  HH24 : 시간(0~23)
 *  IW : 1년중 몇 주(1~53)
 *  MI : 분(0~59)
 *  SS : 초(0~59)
 *  MM : 월(01~12)
 *  Q : 분기(1,2,3,4)
 *  YYYY : 년
 *  W : 월 중 몇 주(1~5)
*/
-- 2005년 입사한 사원들의 목록 분기별 입사자 수
SELECT TO_CHAR(hire_date, 'Q') AS Quarter, count(employee_id) AS employee_number FROM employees WHERE extract(YEAR FROM hire_date) = 2005 GROUP BY to_char(hire_date, 'Q') ORDER BY Quarter;