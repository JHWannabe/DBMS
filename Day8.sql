/*
 * Ʈ������(Transaction)
 * - �ϳ��� �۾��� ����
 * - �����ͺ��̽��� ���¸� ��ȯ��Ű�� �ϳ��� ���� ����� �����ϱ� ���� �۾��� ����
 * - rollback(����), commit(�Ϸ�)
 * - savepoint
 * - ��) savepoint sp1; -> rollback to sp1;
 * 
 * ��� ����
 * - �����, ����Ŭ����, ���ø����̼� ������, DBA��� ������ ��ġ���� ������ ���ù߻��� ����
 */
CREATE TABLE bonuses (
	employee_id number(6),
	bonus number(8,2)
);

INSERT INTO bonuses values(100, 2400);

SELECT * FROM bonuses;

DELETE FROM bonuses;

-- �ѹ��� �� ����� �������� �޿��� 10%�� ���ʽ��� ����
SELECT * FROM EMPLOYEES e ;

INSERT INTO bonuses
	SELECT employee_id, salary * 0.1 FROM EMPLOYEES;
	COMMIT;
	
DELETE FROM bonuses WHERE employee_id = 100;
SELECT * FROM bonuses;
ROLLBACK;
COMMIT;

-- rownum : ��ȸ�� ������� ������ ����
SELECT rownum, employee_id, bonus FROM bonuses;
DELETE FROM bonuses WHERE rownum = 1;
ROLLBACK;

/*
 * ��(view)
 * - �ϳ� �̻��� ���̺��̳� �ٸ� ���� �����͸� �� �� �ְ� �ϴ� �����ͺ��̽� ��ü
 * - ���� �����ʹ� �並 �����ϴ� ���̺� ��� ������ ��ġ ���̺�ó�� ����� �� ����
 */
-- ����߿��� �Ի����� ���� ��� 10�� ���
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

-- disable novalidate : constraint ���� �Ͱ� ���� -> �����͸� �Ÿ��� �ʰ� �־���
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
values('apple','����','1111');


-- ����1 employees ���̺��� 20�� �μ�(department_id)�� ���� ������ �����ϴ�
-- emp_20 view�� ����
CREATE OR REPLACE VIEW emp_20
AS SELECT * FROM employees WHERE DEPARTMENT_ID = 20;

SELECT * FROM emp_20;

-- ����2 employees ���̺��� 30�� �μ��� employee_id�� emp_no��
-- last_name�� name���� salary�� sal�� �ٲپ� emp_30 view�� ����
CREATE OR REPLACE VIEW emp_30("emp_no", "name", "sal")
AS SELECT employee_id, last_name, salary FROM employees WHERE DEPARTMENT_ID = 30;

SELECT * FROM emp_30;

-- ����3 �μ����� �μ���, �ּұ޿�, �ִ�޿�, �μ��� ��ձ޿��� �����ϴ� dept_sum view�� ����
-- �ʵ�� : �μ���, �ּұ޿�, �ִ�޿�, ��ձ޿�
SELECT * FROM EMPLOYEES e ;
SELECT * FROM dept_sum;

CREATE OR REPLACE VIEW dept_sum("�μ���","�ּұ޿�","�ִ�޿�","��ձ޿�")
AS SELECT department_name, min(salary), max(salary),trunc(avg(salary),0)
FROM employees e, departments d WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY department_name;

/*
 * ������(sequence)
 * - �ڵ����� ���������� �����ϴ� ������ ��ȯ�ϴ� �����ͺ��̽� ��ü
 * - �ߺ����� �����ϰų� PK���� ����
 * create sequence �������� �ɼ�...
 * increment by [��������] : �������ڰ� ����� ����, ������ ����. default�� 1
 * start with [���ۼ���] : ���ۼ����� ����Ʈ���� ������ �� minvalue, ������ �� maxvalue
 * minvalue [�ּҰ�]
 * maxvalue [�ִ밪]
 * cycle or nocycle : cycle ������ �ִ밪�� �����ϸ� �ּҰ����� �ٽ� ����
 */
CREATE SEQUENCE test_seq
INCREMENT BY 1
START WITH 10
MAXVALUE 1000;

SELECT test_seq.currval FROM dual; -- ����
SELECT test_seq.nextval FROM dual; -- nextval�� ���� �ʱ�ȭ�ؾ� ��밡��
SELECT test_seq.currval FROM dual; -- ���� ��
SELECT test_seq.nextval FROM dual; -- 11�� �����Ǿ� ����

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
 * alter sequence [��������] �ɼ�..
 */
ALTER SEQUENCE test_seq
INCREMENT BY 2
MINVALUE 1
MAXVALUE 10000
CYCLE;

INSERT INTO tb_ex(idx, userid) values(test_seq.nextval, 'orange');

DROP SEQUENCE test_seq;

/*
 * index(����)
 * - index�� ���ϴ� ������ ��ġ�� ������ ��Ȯ�ϰ� �˾Ƴ� �� �ִ� ���
 * - �ڵ����� : primary key
 * - �������� : Query�� ���� ���
 * 
 * �����ϸ� ���� ���
 * - WHERE���̳� JOIN���� �ȿ� ���� ���Ǵ� �÷�
 * - null���� ���� ���ԵǾ� �ִ� �÷�
 * 
 * �����ϸ� ������ ���
 * - ���̺��� ���� ��(row�� 10000�� ����)
 * - ���̺��� ���� ���ŵ� ��
*/
CREATE TABLE emp_copy
AS SELECT * FROM employees;

SELECT * FROM emp_copy;

ALTER TABLE emp_copy ADD CONSTRAINT pk_emp_01 PRIMARY KEY (employee_id);

SELECT * FROM all_indexes WHERE index_name IN ('PK_EMP_01');

CREATE INDEX emp_index1 ON emp_copy(manager_id);