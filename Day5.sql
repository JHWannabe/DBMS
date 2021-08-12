-- ��� ���̺�
SELECT * FROM employees;

-- ���, �̸�, �Ի����� ���
SELECT employee_id, first_name, last_name, hire_date FROM employees;

-- �Ի��� ��
-- extract() : ��¥ �����ͷ� ���� ���ϴ� ���� ��ȯ
-- extract(�� or �� or �� from �ʵ��)
SELECT employee_id, first_name, last_name, hire_date, EXTRACT(MONTH FROM hire_date) AS HIRE_MONTH FROM employees;

-- �Ի� �б�
-- ceil() : �ø� ó���� �������� ��ȯ
SELECT employee_id, first_name, last_name, hire_date, EXTRACT(MONTH FROM hire_date) AS HIRE_MONTH, ceil(EXTRACT(MONTH FROM hire_date)/3) AS Quarter FROM employees;

-- �б⺰�� �Ի��� �����
SELECT CEIL(EXTRACT(MONTH FROM hire_date)/3) AS Quarter, count(employee_id) AS Count_Member FROM employees GROUP BY ceil(EXTRACT(MONTH FROM hire_date)/3);


-- 2005�� 3���� �Ի��� ����� ������� ������ �������� �Ի����� ��
-- 2005�� 3�� �Ի���
-- trunc() : ���ϴ� �Ҽ��� �ڸ�����ŭ ��ȯ
-- trunc(��, �ɼ�)
-- trunc(�Ҽ�������, 1) --> ù° ����
-- trunc(��¥, 'YEAR')

SELECT employee_id, EXTRACT(DAY FROM hire_date) AS hire_day FROM employees WHERE extract(YEAR FROM hire_date) = 2005 AND EXTRACT(MONTH FROM hire_date) = 3;
-- ����
SELECT employee_id, EXTRACT(DAY FROM hire_date) AS hire_day, trunc(EXTRACT(DAY FROM hire_date)/7)+1 AS num_week FROM employees WHERE extract(YEAR FROM hire_date) = 2005 AND EXTRACT(MONTH FROM hire_date) = 3;
-- �� �ֿ� �Ի��� �����
SELECT trunc(EXTRACT(DAY FROM hire_date)/7)+1 AS num_week, count(employee_id) AS Count_Member FROM employees WHERE extract(YEAR FROM hire_date) = 2005 AND EXTRACT(MONTH FROM hire_date) = 3 GROUP BY trunc(EXTRACT(DAY FROM hire_date)/7)+1 ORDER BY num_week;

-- ¦�� �ؿ� Ȧ�� �ؿ� �Ի��� ����� ����
-- ������ �Ի���
SELECT EXTRACT(YEAR FROM hire_date), count(employee_id) FROM employees GROUP BY EXTRACT(YEAR FROM hire_date);
-- mod() : ���� ���� ���� �� �������� ����
-- ¦���� Ȧ�� ������ �����ϱ� ���� mod() ���
SELECT mod(EXTRACT(YEAR FROM hire_date), 2) AS oddeven, count(employee_id) AS Count_Member FROM employees GROUP BY mod(EXTRACT(YEAR FROM hire_date), 2);
-- ��� ����� ����
/*
 * 	case �� when �񱳰� then ���1 else ���2 end
 */
SELECT CASE mod(EXTRACT(YEAR FROM hire_date), 2)
	WHEN 0 THEN 'even' ELSE 'odd' END AS YEAR
	, count(employee_id) AS Count_Member FROM EMPLOYEES GROUP BY mod(EXTRACT(YEAR FROM hire_date), 2);

-- 2005�⿡ �Ի��� ����� ������ ��ݱ�, �Ϲݱ�� �����ؼ� ���
SELECT employee_id, hire_date FROM employees WHERE extract(YEAR FROM hire_date) = 2006;
-- 2005�⿡ �Ի��� ����� ��
SELECT employee_id, hire_date, EXTRACT(MONTH FROM hire_date) AS MONTH FROM employees WHERE extract(YEAR FROM hire_date) = 2006;
/*
 * width_bucket() : �ּҰ��� �ִ밪�� �����ϰ� ��Ŷ�� ������ ���� ������ ���� �������� ��� ��ġ�� �ִ��� ��ȯ
 * width_bucket(��, �ּҰ�, �ִ밪+1, 2) -> width_bucket(��, 1, 13, 2)
 */
-- 2005�� ��ݱ�, �Ϲݱ� �Ի��� ��� ��
SELECT WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date), 1, 13, 2) AS Half_Year, count(employee_id) AS Count_Member FROM employees WHERE extract(YEAR FROM hire_date) = 2005 GROUP BY WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date), 1, 13, 2);
SELECT CASE WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date), 1, 13, 2)
WHEN 1 THEN '��ݱ�' ELSE '�Ϲݱ�' END AS half_Year,
count(employee_id) FROM EMPLOYEES WHERE extract(YEAR FROM hire_date) = 2005 GROUP BY WIDTH_BUCKET(EXTRACT(MONTH FROM hire_date),1,13,2);

-- round() : ���ڸ� ������ �ڸ� ���� �ݿø��Ͽ� ��ȯ
SELECT round(19.854, 1) FROM dual;
SELECT round(265, -1) FROM dual;

-- substr() : ���ڿ����� �Ϻ� ���ڸ��� ��ȯ
SELECT substr('���ѹα�', 1, 2) FROM dual; -- 1���� 2����
SELECT substr('oracle database', 7) FROM dual; -- 7���� ������
SELECT substr('oracle database', -7) FROM dual; -- ������ 7�ڸ�

-- concat() : �ԷµǴ� �� ���ڿ��� ������ ���� �� ���� ��ȯ
SELECT * FROM employees;
SELECT last_name || ' ' || first_name AS name FROM employees;
SELECT concat(last_name, first_name) AS name FROM employees;
SELECT concat(last_name, concat(' ', first_name)) AS name FROM employees;

-- trim(), ltrim(), rtrim() : ���ڿ����� �����̳� Ư�� ���ڸ� ������ ���� ��ȯ
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

-- ��¥ �Լ�
SELECT * FROM employees;
SELECT sysdate + 365 FROM dual;
-- add_months() : Ư�� ��¥�� ���� ������ ���� ���� �ش� ��¥�� ��ȯ
SELECT ADD_MONTHS(sysdate, 12) FROM dual;
-- months_between() : ��¥ ���� ���̸� ���� ��ȯ
-- ���� �ٹ��ϴ� ����� ���� �Ⱓ�� ���
SELECT employee_id, hire_date FROM employees;
SELECT employee_id, sysdate-hire_date FROM employees;
SELECT employee_id, floor((sysdate-hire_date) /365) AS YEAR FROM employees;
SELECT employee_id, floor((sysdate-hire_date) /365) AS YEAR, MOD(MONTHS_BETWEEN(sysdate, hire_date), 12) AS MONTH FROM employees;

-- extract()
-- to_char() : ��¥�� ������ �����ͷ� ��ȯ
SELECT to_char(sysdate, 'HH24:MI:SS') AS time FROM dual;
/*
 *  D : ��(1~7) 1�� �Ͽ���, 7�� �����
 *  DD : ��(1~31)
 *  DDD : 1�� �� ��¥(1-366)
 *  HH24 : �ð�(0~23)
 *  IW : 1���� �� ��(1~53)
 *  MI : ��(0~59)
 *  SS : ��(0~59)
 *  MM : ��(01~12)
 *  Q : �б�(1,2,3,4)
 *  YYYY : ��
 *  W : �� �� �� ��(1~5)
*/
-- 2005�� �Ի��� ������� ��� �б⺰ �Ի��� ��
SELECT TO_CHAR(hire_date, 'Q') AS Quarter, count(employee_id) AS employee_number FROM employees WHERE extract(YEAR FROM hire_date) = 2005 GROUP BY to_char(hire_date, 'Q') ORDER BY Quarter;