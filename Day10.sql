/*
 * create or replace function �Լ��̸�(�Ű�����1, �Ű�����2..)
 * return ������Ÿ��;
 * is
 *  ����, ��� �� ����
 * begin
 *  ���๮;
 *  return ��ȯ��;
 * exception ����ó����;
 * end �Լ��̸�;
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
 * Ŀ��(cursor)
 * - ����Ŭ���� �Ҵ��� ���� �޸� ������ ���� ������
 * - ����� ����� ���� ����� �޸𸮻��� ��ġ
 * - SELECT���� ��� ������ ó���ϴµ� ���
 * 
 * �Ͻ��� Ŀ��
 * - ����Ŭ�̳� PL/SQL���࿡ ���� ó���Ǵ� SQL������ ó���Ǵ� ���� ���� �͸��� �ּ�
 * - SQL���� ����Ǵ� ���� �ڵ����� OPEN�� CLOSE�� ����
 * - SQLĿ�� �Ӽ��� ����ϸ� SQL���� ����� �׽�Ʈ�� �� ����
 * 
 * SQL%FOUND : �ش� SQL���� ���� ��ȯ�� �� ���� ������ 1�� �̻��� ��� TRUE
 * SQL%NOTFOUND : �ش� SQL���� ���� ��ȯ�� �� ���� ������ ���� ��� TRUE
 * SQL%ISOPEN : �׻� FALSE, �Ͻ��� Ŀ���� ���� �ִ��� ���� �˻�
 * SQL%ROWCOUNT : �ش� SQL���� ���� ���ѵ� �� ���� ������ ����
 *  (PL/SQL�� ���� �� �ٷ� ������ Ŀ���� �ݱ� ������ �׻� FALSE)
 */

SELECT * FROM example;

DECLARE
	BEGIN
			DELETE FROM example WHERE employee_id = 100;
			dbms_output.put_line('ó���Ǽ� : ' || to_char(SQL%ROWCOUNT) || '��');
	END;
	
/*
 * ����� Ŀ��
 * - ���α׷��ӿ� ���� ����Ǹ� �̸��� �ִ� Ŀ��
 * 
 * ����
 * - DECLARE�� ���� SQL ������ ����
 * - OPEN�� �̿��Ͽ� ��� �� ������ �ĺ�
 * - FETCH�� ���� ���� ���� ������ �ε�
 *  * ���� ������ ���� output ������ ��ȯ
 *  * Ŀ���� SELECT���� �÷��� ���� output ������ ���� ����
 *  * Ŀ���÷��� ����Ÿ�԰� output ������ ������ Ÿ�Ե� ���� ����
 *  * Ŀ���� �� ���ξ� �����͸� FETCH��
 * - CLOSE�� ���� ��� �� ������ ����
 * 
 * DECLARE
 *  CURSOR Ŀ���̸� IS SELECT����;
 * BEGIN
 *  OPEN Ŀ���̸�;
 *  FETCH Ŀ���̸� INTO ����;
 *  CLOSE Ŀ���̸�;
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