/*
 * create or replace function 함수이름(매개변수1, 매개변수2..)
 * return 데이터타입;
 * is
 *  변수, 상수 등 선언
 * begin
 *  실행문;
 *  return 반환값;
 * exception 예외처리부;
 * end 함수이름;
 */
CREATE OR REPLACE FUNCTION func_sum(num1 NUMBER, num2 NUMBER)
	RETURN NUMBER
	IS
	fn_num1 NUMBER := num1;
	fn_num2 NUMBER := num2;
	fn_sum NUMBER := 0;
BEGIN
	fn_sum := fn_num1 + fn_num2;
	RETURN fn_sum;
END func_sum;

SELECT func_sum(10, 5) FROM dual;

/*
 * 커서(cursor)
 * - 오라클에서 할당한 전용 메모리 영역에 대한 포인터
 * - 결과로 얻어진 행이 저장된 메모리상의 위치
 * - SELECT문의 결과 집합을 처리하는데 사용
 * 
 * 암시적 커서
 * - 오라클이나 PL/SQL실행에 의해 처리되는 SQL문장이 처리되는 곳에 대한 익명의 주소
 * - SQL문이 실행되는 순간 자동으로 OPEN과 CLOSE를 실행
 * - SQL커서 속성을 사용하면 SQL문의 결과를 테스트할 수 있음
 * 
 * SQL%FOUND : 해당 SQL문에 의해 반환된 총 행의 개수가 1개 이상일 경우 TRUE
 * SQL%NOTFOUND : 해당 SQL문에 의해 반환된 총 행의 개수가 없을 경우 TRUE
 * SQL%ISOPEN : 항상 FALSE, 암시적 커서가 열려 있는지 여부 검색
 * SQL%ROWCOUNT : 해당 SQL문에 의해 반한된 총 행의 개수를 리턴
 *  (PL/SQL은 실행 후 바로 묵시적 커서를 닫기 때문에 항상 FALSE)
 */

SELECT * FROM example;

DECLARE
	BEGIN
			DELETE FROM example WHERE employee_id = 100;
			dbms_output.put_line('처리건수 : ' || to_char(SQL%ROWCOUNT) || '건');
	END;
	
/*
 * 명시적 커서
 * - 프로그래머에 의해 선언되며 이름이 있는 커서
 * 
 * 문법
 * - DECLARE를 통해 SQL 영역을 생성
 * - OPEN을 이용하여 결과 행 집합을 식별
 * - FETCH를 통해 현재 행을 변수에 로드
 *  * 현재 데이터 행을 output 변수에 반환
 *  * 커서의 SELECT문의 컬럼의 수와 output 변수의 수가 동일
 *  * 커서컬럼의 변수타입과 output 변수의 데이터 타입도 역시 동일
 *  * 커서는 한 라인씩 데이터를 FETCH함
 * - CLOSE를 통해 결과 행 집합을 해제
 * 
 * DECLARE
 *  CURSOR 커서이름 IS SELECT문장;
 * BEGIN
 *  OPEN 커서이름;
 *  FETCH 커서이름 INTO 변수;
 *  CLOSE 커서이름;
 * END;
 * 
 */

SELECT * FROM employees;

DECLARE
	CURSOR emp_cur
	IS
	SELECT * FROM employees WHERE employee_id = 101;
	emp_result employees%rowtype;
BEGIN
	OPEN emp_cur;
	LOOP
	FETCH emp_cur INTO emp_result;
	EXIT WHEN emp_cur%NOTFOUND;
		dbms_output.put_line(emp_result.employee_id || ' ' || emp_result.last_name);
	END LOOP;
	CLOSE emp_cur;
END;
