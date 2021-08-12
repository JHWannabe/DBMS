-- instr(���ڿ�, �˻��� ����, ��������, n��° �˻��ܾ�)
-- ã�� ������ ��ġ�� ��ȯ
-- ã�� ���ڰ� ������ 0�� ��ȯ
-- ã�� �ܾ� �ձ����� �ε����� ��ȯ
SELECT instr('Hello Oracle','Ok') AS idx FROM dual;
SELECT instr('Hello Oracle','Or') AS idx FROM dual;
-- 5��° �ε������� 'l' ���� ã��
SELECT instr('Hello Oracle','l', 5) AS idx FROM dual;
-- 2��° �ε������� 'l' ���� �� 2��° ���� ã��
SELECT instr('Hello Oracle','l', 2, 2) AS idx FROM dual;
-- �ڿ��� 3��° �ε������� �������� 'l' ���� �� 2��° ���� ã��
SELECT instr('Hello Oracle','l', -3, 2) AS idx FROM dual;


-- ����ǥ����
-- REGEXP_INSTR() �Լ�
-- �����Լ� instr()�� ����� Ȯ���� ������ ���� ǥ������ �̿��� �Էµ� ������ �˻�
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

-- ���ڿ��� 'b'�� 2�� ����ִ� ���� ��ȯ(REGEXP_INSTR�� ���)
SELECT ex_a, REGEXP_INSTR(ex_a, 'bb', 1) FROM example; 

SELECT * FROM example where regexp_instr(ex_a, 'bb',1) > 0;
-- REGEXP_INSTR(����ڿ�, ����, ������ġ, ���° ��ġ, ��ġ�ϴ� ���ڿ� ������ġ)
SELECT * FROM example where regexp_instr(ex_a, 'b',1,3,0) > 0;

-- regexp_substr() �Լ�
-- ���� ǥ���� ������ �����Ͽ� ���ڿ� �Ϻθ� ��ȯ
DROP TABLE example;

-- concat() : ���ڿ��� �����ϴ� �Լ�
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
INSERT INTO t1 values(4, '��');
INSERT INTO t1 values(5, NULL);

INSERT INTO t2 values('A', 20);
INSERT INTO t2 values('B', 50);
INSERT INTO t2 values('��', 40);
INSERT INTO t2 values('A', 10);
INSERT INTO t2 values('B', 20);
INSERT INTO t2 values('A', 10);

SELECT * FROM t1; -- A C B �� null
SELECT * FROM t2; -- A B �� A B A

-- t1 5�� i/o �߻�, t2 6�� i/o �߻�
SELECT COUNT(*) FROM t1, t2; 

SELECT t1.c1, t2.c2 FROM t1, t2 WHERE t1.c2 = t2.c1;
SELECT t1.c1, t2.c2 FROM t1 JOIN t2 ON t1.c2 = t2.c1;

SELECT t1.c1, sum(t2.c2) FROM t1, t2 WHERE t1.c2 = t2.c1 GROUP BY t1.c1;

-- left join = �ܺ�����(left outer join)
SELECT t1.c1, sum(t2.c2) FROM t1 LEFT JOIN t2 ON t1.c2 = t2.c1 GROUP BY t1.c1
ORDER BY t1.c1 asc;

-- �ܺ� ���� ������ (+)
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

-- ǥ���ڵ�(ANSI)�� �����ϱ�
SELECT department_name FROM EMPLOYEES e JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID 
WHERE last_name = 'King' AND first_name = 'Steven';

-- UNION
-- SELECT ����� ��ĥ �� ����
-- ��ģ ������� �ߺ��Ǵ� ���� �ϳ��� ǥ��
-- �÷��� ������ ���ƾ� �ϰ�, �� �÷��� ������Ÿ���� ���ƾ� ��
/*
 * select * from tb_a
 * union (ALL)
 * select * from tb_b
 */
SELECT * FROM COUNTRIES;
SELECT * FROM regions;

-- �� ���̺��� union �ϱ� ���� �÷��� ������ Ÿ���� ���ƾ� ��
-- countries���� country_name�� region_id�� SELECT
-- regions���̺��� region_name�� region_id�� SELECT

-- �ߺ��� ������
SELECT country_name, region_id FROM countries
UNION
SELECT region_name, region_id FROM regions;

-- �ߺ��� �������� ����
SELECT country_name, region_id FROM countries
UNION ALL
SELECT region_name, region_id FROM regions;