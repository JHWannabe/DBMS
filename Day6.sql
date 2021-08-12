/*
	decode() : sql���� ���ǹ�(if)�� ����� �� �ֵ��� ����
	- decode(�÷�, ����1, ���1, ����2, ���2 ... ��� n) ---> (���n�� default)
	- ã�� ���� ���� �� equal ���길 ����(�� ������ �Ұ���)
	
	��) ���̽�
	if ���ǽ�1:
		���1
	elif ���ǽ�2:
		���2
	else:
		���n
*/
SELECT employee_id, job_id FROM employees;

-- job_id�� 'SA_REP', 'SA_MAN' -> 'SALES'
SELECT employee_id, job_id, 
	decode(job_id, 'SA_REP', 'SALES1','SA_MAN', 'SALES2') AS departments 
	FROM employees WHERE job_id IN ('SA_REP', 'SA_MAN');

/*
 * case ��
 * ���� SA_MAN, SA_REP ������ ����� �μ��� 'sales'�� ǥ��
 */
SELECT employee_id, job_id, CASE job_id
	WHEN 'SA_REP' THEN 'sales1'
	WHEN 'SA_MAN' THEN 'sales2'
	END AS departments
	FROM EMPLOYEES
	WHERE job_id IN ('SA_REP', 'SA_MAN');

-- �μ��̸��� ���. �� 8�ڰ� �Ѵ� ��� 8�ڱ����� ǥ��. �� ���ϴ� '...'
/*
 * LPAD : ������ ���̸�ŭ ���ʺ��� Ư�����ڷ� ä����
 * 	LPAD("��", "�ѹ��ڱ���", "ä���� ����")
 * RPAD : ������ ���̸�ŭ �����ʺ��� Ư�����ڷ� ä����
 * 	RPAD("��", "�ѹ��ڱ���", "ä���� ����")
 */
SELECT CASE WHEN LENGTH(department_name) <= 8 THEN department_name
	ELSE RPAD(substr(department_name, 1, 8), 10, '..')
	END AS department_name FROM departments;

SELECT * FROM departments;

/*
 * rank() : ������ ǥ���� �� ����ϴ� �Լ�
 * - order by�� �ʼ�
 * 
 * �м� �Լ�
 * rank() over() : ���� ������ ��� 1, 1, 3 �������� ���
 * row_number() over() : ���� ������ ��� 1, 2, 3 �������� ���
 * dense_rank() over() : ���� ������ ��� 1, 1, 2 �������� ���
 */
-- ���� �μ� ����� ������� �޿��� ���� ���� 6���� ����� ���
SELECT * FROM departments;
SELECT * FROM employees;

SELECT d.department_id, e.first_name, e.last_name, e.salary
FROM employees e, departments d
WHERE e.DEPARTMENT_ID =d.DEPARTMENT_ID AND department_name = 'Sales';

SELECT d.department_id, e.first_name, e.last_name, e.salary,
rank() over(ORDER BY SALARY ASC) rnk
FROM employees e, departments d
WHERE e.DEPARTMENT_ID =d.DEPARTMENT_ID AND department_name = 'Sales';

/*
 * ��������(sub query)
 * - sql�� ���� ���� select ���� �ǹ�
 * - �ٱ��� �ִ� sql���� ���� ������ �θ�
 * - ���� ���� �ȿ� ���Ե� �������� �����̱� ������ ������ ��������� �׻� ������������
 * ������ �����Ϳ� ���� ������������ �ش� ������ �����ϴ��� Ȯ���ϴ� ������� ����
 */

SELECT department_id, first_name, last_name, salary FROM (
	SELECT d.department_id, e.first_name, e.last_name, e.salary,
	rank() over(ORDER BY SALARY ASC) rnk
	FROM employees e, departments d
	WHERE e.DEPARTMENT_ID =d.DEPARTMENT_ID AND department_name = 'Sales'
) WHERE rnk <= 6;

-- rank() �Լ��� �̿����� �ʴ� ����
SELECT department_id, first_name, last_name, salary,
(SELECT count(salary)+1 FROM EMPLOYEES WHERE DEPARTMENT_ID = 80 AND e.salary > salary) rnk
FROM employees e WHERE DEPARTMENT_ID = 80 ORDER BY rnk ASC;

/*
 * 	percent_rank() : ������� ��Ÿ��
 * 
 * 	select �м��Լ� over([PARTITION BY �÷�] [ORDER BY �÷�] [WINDOWING ��]) FROM ���̺��;
 * 
 * 	OVER() : �м���, �м��Լ��� ���� ����
 * 	PARTITION BY : group by�� ����(�׷����� ����� ���)
 * 	ORDER BY -> PARTITION BY�� ���ǵ� �׷��� WINDOW������ ����� ���� ������ ����
 * 	
 * 	from -> where -> group by -> having -> select -> order by -> over()
 * 
 */
-- ��� ����(job_id -> SH�� ����)�� ����ϴ� ����� ������� �޿��� ���� �޴� ���� 20%���� �������
SELECT * FROM employees;
SELECT department_id, first_name, last_name, salary, 
	PERCENT_RANK() over(PARTITION BY job_id ORDER BY salary DESC) * 100 AS rnk
	FROM EMPLOYEES e WHERE job_id LIKE 'SH%';

SELECT * from(
	SELECT department_id, first_name, last_name, salary, 
	ROUND(PERCENT_RANK() over(PARTITION BY job_id ORDER BY salary DESC) * 100, 2) AS rnk
	FROM EMPLOYEES e WHERE job_id LIKE 'SH%'
) WHERE rnk <= 20;

/*
 * 	sum() �Լ� : ���� �հ踦 ���� �� ���
 */
-- ��� ���� ������ �ϴ� ������� ������� ������ ���� �޿��� ��
-- 'ST%'
SELECT employee_id, job_id, salary,
	sum(salary) OVER(PARTITION BY job_id ORDER BY salary ASC) accm_sal
	FROM EMPLOYEES e WHERE job_id LIKE 'ST%';

/*
 * 	avg() : ����� ���ϴ� �Լ�
 * - �м��Լ��ε� ���
 * - �м��Լ��� ���� ���� ���ڵ� ��Ʈ�� �Բ� ����� ������ ���� �� ����
 * - �׷��� �����ٸ� �׷� �� ���ڵ� ��Ʈ�� ��հ��� �Բ� ���� �� ����
 */
-- ��� �ڽ��� �޴� �޿��� �ش� �μ� �� ��հ� �󸶳� ���̰� �ִ��� Ȯ��
-- (��, �μ��߷��� ���� ���� ����� ����)
SELECT * FROM employees;
SELECT employee_id, first_name, salary,
	round(avg(salary) OVER(PARTITION BY department_id)) AS avg_dept_sal,
	TO_CHAR(salary - avg(salary) over(PARTITION BY department_id), '$999,999') AS diff
	FROM EMPLOYEES WHERE DEPARTMENT_ID IS NOT NULL;

/*
 * ���� ǥ����
 * aaaa-.@aaa.aaa
 * 010-0000-0000
 */

CREATE READ UPDATE DELETE (CRUD)
