/*
  PL/SQL
  ��� ������ �����ͺ��̽� �ý����� ����Ŭ DBMS����
  SQL�� Ȯ���ϱ� ���� ����ϴ� ��ǻ�� ���α׷��� ���
  
  ���� : �޸𸮿� �����͸� �����ϴ� ����
  
  ���� ����
  ������ ������Ÿ�� := ��;
  
  num number := 10;
  str varchar2(10) := 'Hello';
  
  ��� : �޸𸮿� �����͸� ����, �ѹ� ������ ���� ������ �� ����
  
  ��� ����
  ����� CONSTANT ������Ÿ�� := ��;
  
  num constant number := 20;
  
  * ��� ����ÿ��� �ʱⰪ�� ������  �Ҵ��Ͽ��� �ϰ�,
   ������ ����� ���ÿ� �ʱⰪ�� �Ҵ����� ������ ������ Ÿ�Կ� ������� NULL�� ������
   
   
   PL/SQL������ �����, �����, ����ó���η� ������
   - �����(DECLARE) : ���� �� ����� ����
   - �����(BEGIN) : ���
   - ����ó����(EXCEPTION) : ���� ��Ȳ�� �������� ó���Ǵ� ���� (�ɼ�)
   
   �ܼ�â Ȯ��
   cntl + shift + O(����)
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
 * ����) �� ������ �� ���ϱ�
 */
DECLARE
num1 NUMBER := 10;
num2 NUMBER := 5;
BEGIN
	dbms_output.put_line(num1 + num2);
END;

/*
 * ���(���ǹ�, �ݺ���)
 * ���ǹ�
 * if, case
 * 
 * �ݺ���
 * while, for, loop
 */

/*
 * if ���ǹ�1 then
 *  ���ǹ�1�� true�� ��� ����� ����;
 * elsif ���ǹ�2 then
 *  ���ǹ�2�� true�� ��� ����� ����;
 * elsif ���ǹ�3 then
 *  ���ǹ�3�� true�� ��� ����� ����;
 * ...
 * else
 *  ��� ���ǹ��� false�� ��� ����� ����;
 * end if;
 */

/*
 * ����) ��������� 85�̸� �� �������� �˾ƺ���
 */
DECLARE
avg_score NUMBER := 85;
BEGIN
	IF avg_score >= 90 THEN
		dbms_output.put_line('A����');
	ELSIF avg_score >= 80 THEN
		dbms_output.put_line('B����');
	ELSIF avg_score >= 70 THEN
		dbms_output.put_line('C����');
	ELSIF avg_score >= 60 THEN
		dbms_output.put_line('D����');
	ELSE
		dbms_output.put_line('F����');
	END IF;
END;

/*
 * CASE WHEN ���ǽ�1 THEN
 * 	 ���ǽ�1�� TRUE�� ��� ����� ����;
 * WHEN ���ǽ�2 THEN
 *   ���ǽ�2�� TRUE�� ��� ����� ����;
 * WHEN ���ǽ�3 THEN
 *   ���ǽ�3�� TRUE�� ��� ����� ����;
 * ELSE
 *   ��� ������ FALSE�� ��� ����� ����;
 * END CASE;
 */

/*
 * ����) ��������� 85�̸� �� �������� �˾ƺ���
 */
DECLARE
avg_score NUMBER := 85;
BEGIN
	CASE WHEN avg_score >= 90 THEN
		dbms_output.put_line('A����');
	WHEN avg_score >= 80 THEN
		dbms_output.put_line('B����');
	WHEN avg_score >= 70 THEN
		dbms_output.put_line('C����');
	WHEN avg_score >= 60 THEN
		dbms_output.put_line('D����');
	ELSE
		dbms_output.put_line('F����');
	END CASE;
END;

/*
 * loop ��
 * 
 * loop
 *   �ݺ��� ����;
 * exit ���ǹ�; -- ���ǹ��� true�̸� ����
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
 * while ��
 * 
 * while(���ǽ�) -- ���ǽ��� true�� ���� �ݺ�
 * 	 loop
 *     �ݺ��� ����;
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
 * for ��
 * 
 * for ���� in �ʱⰪ..������
 * 		loop
 * 			�ݺ��� ����;
 * 		end loop;
 */
BEGIN
	FOR i IN 1..10
		LOOP
			dbms_output.put_line('Hello Oracle');
		END LOOP;
END;

/*
 * for���� �̿��Ͽ� 1 ~ 10���� �Ʒ��� ���� ���
 * 
 * ��� ���
 * 1�� Ȧ��!
 * 2�� ¦��!
 * 3�� Ȧ��!
 * ...
 * 10�� ¦��!
 */
BEGIN
	FOR i IN 1..10
		LOOP
			CASE WHEN mod(i,2) = 0 THEN
				dbms_output.put_line(i || '�� ¦��!');
			WHEN mod(i,2) = 1 THEN
				dbms_output.put_line(i || '�� Ȧ��!');
			END CASE;
		END LOOP;
END;

/*
 * ����ó��
 * 1. �ý��� ����
 * 		EXCEPTION WHEN ���ܸ� THEN ����ó�� ����;
 * 
 * 2. ����� ���� ����
 * 		EXCEPTION WHEN OTHERS THEN ����ó�� ����;
 */
DECLARE
	num NUMBER := 0;
BEGIN
	num := 10 / 0;

EXCEPTION WHEN OTHERS THEN
	dbms_output.put_line('������ �߻��߾��!');
END;

/*
 * ���ν���(procedure)
 * ���� ����ϴ� SQL������ ���ν����� ���� �� �ʿ��� ������ ȣ��,
 * ����Ͽ� �۾� ȿ���� �ø� �� ����
 * - ������ ������� ��ȯ���� �ʴ� ���� ���α׷�
 * 
 * 
 * CREATE or REPLACE PROCEDURE ���ν�����(�Ű�������1[in|out]
 * ������Ÿ�� [:=����Ʈ��], �Ű�������1[in|out]
 * ������Ÿ�� [:=����Ʈ��]..)
 * 
 * in : �Է�, out : ���, in out : ������� ���� (����Ʈ�� in)
 * out �Ű������� ���ν��� ������ ���� ó�� ��, �ش� �Ű������� ���� ������
 * ���ν��� ȣ��κп��� �� ���� ������ �� �ְ� ����
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


-- EXEC proc_address(1, '���� ���ʱ� ���絿');
BEGIN
	proc_address(1, '���� ���ʱ� ���絿');
END;

SELECT * FROM tb_address;

/*
 * ����
 * jobs ���̺� �����͸� insert �� �� �ִ� ���ν��� �����
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

-- ���ν��� Ȯ��
SELECT * FROM user_objects WHERE object_type='PROCEDURE';