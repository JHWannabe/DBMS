/*
  PL/SQL
  상용 관계형 데이터베이스 시스템인 오라클 DBMS에서
  SQL언어를 확장하기 위해 사용하는 컴퓨터 프로그래밍 언어
  
  변수 : 메모리에 데이터르 저장하는 공간
  
  변수 선언
  변수명 데이터타입 := 값;
  
  num number := 10;
  str varchar2(10) := 'Hello';
  
  상수 : 메모리에 데이터를 저장, 한번 설정한 값은 변경할 수 없음
  
  상수 선언
  상수명 CONSTANT 데이터타입 := 값;
  
  num constant number := 20;
  
  * 상수 선언시에는 초기값을 무조건  할당하여야 하고,
   변수는 선언과 동시에 초기값을 할당하지 않으면 데이터 타입에 상관없이 NULL로 설정됨
   
   
   PL/SQL에서는 선언부, 실행부, 예외처리부로 나눠짐
   - 선언부(DECLARE) : 변수 및 상수의 선언
   - 실행부(BEGIN) : 출력
   - 예외처리부(EXCEPTION) : 예외 상황이 벌어지면 처리되는 문장 (옵션)
   
   콘솔창 확인
   cntl + shift + O(영어)
 **/

DECLARE
num constant NUMBER := 10;
str varchar2(10);

BEGIN
	str := 'Hello';
	DBMS_OUTPUT.PUT_LINE(num);
	DBMS_OUTPUT.PUT_LINE(str);
END;

/*
 * 예제) 두 변수의 값 더하기
 */
DECLARE
num1 NUMBER := 10;
num2 NUMBER := 5;
BEGIN
	dbms_output.put_line(num1 + num2);
END;

/*
 * 제어문(조건문, 반복문)
 * 조건문
 * if, case
 * 
 * 반복문
 * while, for, loop
 */

/*
 * if 조건문1 then
 *  조건문1이 true인 경우 실행될 문장;
 * elsif 조건문2 then
 *  조건문2가 true인 경우 실행될 문장;
 * elsif 조건문3 then
 *  조건문3이 true인 경우 실행될 문장;
 * ...
 * else
 *  모든 조건문이 false인 경우 실행될 문장;
 * end if;
 */

/*
 * 예제) 평균점수가 85이면 몇 학점인지 알아보자
 */
DECLARE
avg_score NUMBER := 85;
BEGIN
	IF avg_score >= 90 THEN
		dbms_output.put_line('A학점');
	ELSIF avg_score >= 80 THEN
		dbms_output.put_line('B학점');
	ELSIF avg_score >= 70 THEN
		dbms_output.put_line('C학점');
	ELSIF avg_score >= 60 THEN
		dbms_output.put_line('D학점');
	ELSE
		dbms_output.put_line('F학점');
	END IF;
END;

/*
 * CASE WHEN 조건식1 THEN
 * 	 조건식1이 TRUE인 경우 실행될 문장;
 * WHEN 조건식2 THEN
 *   조건식2가 TRUE인 경우 실행될 문장;
 * WHEN 조건식3 THEN
 *   조건식3이 TRUE인 경우 실행될 문장;
 * ELSE
 *   모든 조건이 FALSE인 경우 실행될 문장;
 * END CASE;
 */

/*
 * 예제) 평균점수가 85이면 몇 학점인지 알아보자
 */
DECLARE
avg_score NUMBER := 85;
BEGIN
	CASE WHEN avg_score >= 90 THEN
		dbms_output.put_line('A학점');
	WHEN avg_score >= 80 THEN
		dbms_output.put_line('B학점');
	WHEN avg_score >= 70 THEN
		dbms_output.put_line('C학점');
	WHEN avg_score >= 60 THEN
		dbms_output.put_line('D학점');
	ELSE
		dbms_output.put_line('F학점');
	END CASE;
END;

/*
 * loop 문
 * 
 * loop
 *   반복할 문장;
 * exit 조건문; -- 조건문이 true이면 종료
 * end loop;
 */
DECLARE
num NUMBER := 1;
BEGIN
	LOOP
	dbms_output.put_line(num);
	num := num + 1;
	EXIT WHEN num >10;
	END LOOP;
END;

/*
 * while 문
 * 
 * while(조건식) -- 조건식이 true인 동안 반복
 * 	 loop
 *     반복할 문장;
 *     ...
 *   end loop;
 * end;
 */
DECLARE
num NUMBER := 1;
BEGIN
	while(num<=10)
		LOOP
			dbms_output.put_line(num);
			num := num + 1;
		END LOOP;
END;

/*
 * for 문
 * 
 * for 변수 in 초기값..최종값
 * 		loop
 * 			반복할 문장;
 * 		end loop;
 */
BEGIN
	FOR i IN 1..10
		LOOP
			dbms_output.put_line('Hello Oracle');
		END LOOP;
END;

/*
 * for문을 이용하여 1 ~ 10까지 아래와 같이 출력
 * 
 * 출력 결과
 * 1는 홀수!
 * 2는 짝수!
 * 3는 홀수!
 * ...
 * 10는 짝수!
 */
BEGIN
	FOR i IN 1..10
		LOOP
			CASE WHEN mod(i,2) = 0 THEN
				dbms_output.put_line(i || '는 짝수!');
			WHEN mod(i,2) = 1 THEN
				dbms_output.put_line(i || '는 홀수!');
			END CASE;
		END LOOP;
END;

/*
 * 예외처리
 * 1. 시스템 예외
 * 		EXCEPTION WHEN 예외명 THEN 예외처리 문장;
 * 
 * 2. 사용자 정의 예외
 * 		EXCEPTION WHEN OTHERS THEN 예외처리 문장;
 */
DECLARE
	num NUMBER := 0;
BEGIN
	num := 10 / 0;

EXCEPTION WHEN OTHERS THEN
	dbms_output.put_line('오류가 발생했어요!');
END;

/*
 * 프로시저(procedure)
 * 자주 사용하는 SQL쿼리를 프로시저로 만든 뒤 필요할 때마다 호출,
 * 사용하여 작업 효율을 늘릴 수 있음
 * - 일종의 결과값을 반환하지 않는 서브 프로그램
 * 
 * 
 * CREATE or REPLACE PROCEDURE 프로시저명(매개변수명1[in|out]
 * 데이터타입 [:=디폴트값], 매개변수명1[in|out]
 * 데이터타입 [:=디폴트값]..)
 * 
 * in : 입력, out : 출력, in out : 입출력을 동시 (디폴트는 in)
 * out 매개변수는 프로시저 내에서 문장 처리 후, 해당 매개변수에 값을 저장해
 * 프로시저 호출부분에서 이 값을 참조할 수 있게 만듦
 */
CREATE TABLE tb_address(
	add_num number(7),
	add_zipcode varchar2(5),
	add_address varchar2(100)
);

CREATE OR REPLACE PROCEDURE proc_address(
	p_add_num IN NUMBER,
	p_add_address IN varchar2
) 
IS 
	p_add_zipcode varchar2(5) := '12345';
BEGIN
	INSERT INTO tb_address(add_num, add_zipcode, add_address)
	VALUES (p_add_num, p_add_zipcode, p_add_address);
	COMMIT;
END proc_address;


-- EXEC proc_address(1, '서울 서초구 양재동');
BEGIN
	proc_address(1, '서울 서초구 양재동');
END;

SELECT * FROM tb_address;

/*
 * 과제
 * jobs 테이블에 데이터를 insert 할 수 있는 프로시저 만들기
 */
CREATE OR REPLACE PROCEDURE proc_jobs (
	p_job_id IN jobs.JOB_ID%TYPE,
	p_job_title IN jobs.JOB_TITLE%TYPE,
	p_min_salary IN jobs.MIN_SALARY%TYPE,
	p_max_salary IN jobs.MAX_SALARY%TYPE
)
IS
BEGIN 
	INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
	VALUES (p_job_id, p_job_title, p_min_salary, p_max_salary);
	COMMIT;
END proc_jobs;

BEGIN
	proc_jobs('test1', 'test2', 100, 200);
END;

SELECT * FROM jobs;

-- 프로시저 확인
SELECT * FROM user_objects WHERE object_type='PROCEDURE';