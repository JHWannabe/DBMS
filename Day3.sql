-- ���̺� �����
CREATE TABLE tb_student(
	stu_idx NUMBER(4) NOT NULL,
	stu_name VARCHAR2(20),
	stu_gender CHAR(1),
	stu_hp VARCHAR2(20),
	CONSTRAINT stu_gender CHECK (stu_gender IN ('m', 'w'))
);

-- ������ Ȯ��
SELECT * FROM TB_STUDENT;

-- ���̺� ����
DROP TABLE tb_student;

-- ���̺� ����(�÷� �߰�)
ALTER TABLE tb_student ADD(
	stu_email VARCHAR2(50)
);

-- ���̺� ����(�÷� ����)
ALTER TABLE tb_student MODIFY(
	stu_gender VARCHAR2(6) CHECK(stu_gender IN ('male', 'female'))
);

-- ���̺� ����(�÷� ����)
--ALTER TABLE tb_student DROP(
--	stu_email
--);

ALTER TABLE tb_student DROP COLUMN stu_email;

-- ���̺� �̸�����
ALTER TABLE tb_student RENAME TO tb_member;
ALTER TABLE tb_member RENAME TO tb_student;

-- �÷� �̸�����
ALTER TABLE tb_student RENAME COLUMN stu_hp TO stu_tel;

SELECT * FROM tb_student;


/*
 * 	INSERT(����)
 *  1. INSERT INTO ���̺�� VALUES (��1, ��2, ��3 ..);
 *  2. INSERT INTO ���̺�� (�÷���1, �÷���2 ..) VALUES (��1, ��2, ��3 ..);
 */
INSERT INTO TB_STUDENT VALUES (1, '����', 'w', '010-1111-1111');
INSERT INTO TB_STUDENT VALUES (2, '���ϳ�', 'w'); -- not enough values
INSERT INTO TB_STUDENT VALUES (4, '�̸޷�', 'm', '010-4444-4444');
INSERT INTO TB_STUDENT VALUES (5, '��ָ�', '1', '010-5555-5555'); -- check constraint (SYSTEM.STU_GENDER) violated

INSERT INTO TB_STUDENT (stu_idx, stu_name) VALUES (2, '���ϳ�');
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp) VALUES (3, '������', 'm', '010-2222-2222');
INSERT INTO TB_STUDENT (stu_name, stu_gender) VALUES ('�̸޷�', 'm'); -- cannot insert NULL into ("SYSTEM"."TB_STUDENT"."STU_IDX")

SELECT * FROM tb_student;


/*
 * UPDATE(����)
 * 1. UPDATE ���̺�� SET �÷���1=��1, �÷���2=��2
 * 2. UPDATE ���̺�� SET �÷���1=��1, �÷���2=��2 WHERE ���ǽ�;
 */
UPDATE TB_STUDENT SET STU_GENDER = 'w';
UPDATE TB_STUDENT SET STU_GENDER = 'm' WHERE STU_IDX = 3;
UPDATE TB_STUDENT SET STU_GENDER = 'm' WHERE STU_NAME = '������';
UPDATE TB_STUDENT SET STU_GENDER = 'm' WHERE STU_HP = '010-2222-2222';

-- ���̺� ����(�÷� �߰�)
ALTER TABLE tb_student ADD(
	stu_jumsu NUMBER(3)
);

SELECT * FROM tb_student;

-- ������ ��� 0���� ����
UPDATE TB_STUDENT SET stu_jumsu = 0;

-- 10���� ��� �л����� ������
UPDATE tb_student SET stu_jumsu=stu_jumsu+10;


/*
 * DELETE(����)
 * 1. DELETE FROM ���̺��
 * 2. DELETE FROM ���̺�� WHERE ���ǽ�
 */
DELETE FROM TB_STUDENT WHERE STU_IDX = 3;


/*
 * SELECT(�˻�)
 * SELECT �÷�1, �÷�2 .. FROM ���̺��
 */

SELECT * FROM tb_student; -- *�� ��� �÷�
SELECT STU_IDX, STU_NAME, STU_GENDER FROM tb_student;
SELECT STU_GENDER, STU_NAME, STU_IDX FROM tb_student;

-- SELECT �÷�1, �÷�2 .. FROM ���̺�� WHERE ���ǽ�
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (3, '������', 'm', '010-2222-2222', 40);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (4, '�̸޷�', 'm', '010-3333-3333', 60);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (5, '��ָ�', 'w', '010-4444-4444', 80);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (6, '�Ȱ���', 'm', '010-5555-5555', 10);
INSERT INTO TB_STUDENT (stu_idx, stu_name, stu_gender, stu_hp, stu_jumsu) VALUES (7, 'ä��', 'w', '010-6666-6666', 75);

/* �� ������
 * = : ����
 * != : �ٸ���
 * > : ũ��
 * < : �۴�
 * >= : ũ�ų� ����
 * <= : �۰ų� ����
 */
-- �̸��� '����'�� �л��� ������ ���
SELECT * FROM TB_STUDENT WHERE STU_NAME ='����';
-- ������ 50�� �̻��� �л��� ������ ���
SELECT * FROM TB_STUDENT WHERE stu_jumsu >= 50;
-- ������ ����(m)�� �ƴ� �л��� ������ ���
SELECT * FROM TB_STUDENT WHERE STU_GENDER != 'm';

/*
 * �� ������
 * and : �� ���ǽ��� ����� ��� ���� �� ��
 * or : �� ���ǽ��� ����� �ϳ��� ���� �� ��
 * not : ����� �ݴ�� ���
 */
-- �̸��� '����'�̰�, ������ 'w'(����)�� �л��� ���
SELECT * FROM TB_STUDENT WHERE stu_name = '����' AND STU_GENDER ='w'; -- O
SELECT * FROM TB_STUDENT WHERE stu_name = '����' AND STU_GENDER ='m'; -- X
-- ������ 40�� �̻��̰� 75�� ������ �л��� ���
SELECT * FROM TB_STUDENT WHERE stu_jumsu >= 40 AND stu_jumsu <= 75;
-- ������ �����̰ų� ������ 50�� �̻��� �л��� ���
SELECT * FROM TB_STUDENT WHERE STU_GENDER ='w' OR stu_jumsu >= 50;
-- ����ó�� �ִ� �л��� ���
SELECT * FROM TB_STUDENT WHERE stu_hp is null; -- null�� �л��� ���
SELECT * FROM TB_STUDENT WHERE stu_hp IS NOT null; -- null�� ������ �л��� ���

-- in : �����͸� �����ϰ� �ִ� ���ڵ� ���
 SELECT * FROM TB_STUDENT WHERE stu_jumsu IN (40, 60, 10);
 SELECT * FROM TB_STUDENT WHERE stu_jumsu NOT IN (40, 60, 10);

-- like : �ش� ���ڿ��� �����ϰ� �ִ� ���ڵ带 ���
SELECT * FROM TB_STUDENT WHERE stu_hp LIKE '%4%';
SELECT * FROM TB_STUDENT WHERE stu_name LIKE '��%';
SELECT * FROM TB_STUDENT WHERE stu_name LIKE '%��';

-- BETWEEN A and B : A�̻� B������ ���ڵ带 ���
 -- ������ 40�� �̻��̰� 75�� ������ �л��� ���
SELECT * FROM TB_STUDENT WHERE stu_jumsu >= 40 AND stu_jumsu <= 75;
SELECT * FROM TB_STUDENT WHERE stu_jumsu BETWEEN 40 AND 75;

