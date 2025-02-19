-- DML(DATA MANIPLATION LANGUAGE) : 데이터 조작 언어
-- 테이블에 값을 검색 (SELECT), 삽입 (INSERT), 수정 (UPDATE), 삭제 (DELETE)하는 구문

-- 1. INSERT : 테이블에 새로운 행을 추가하는 구문
-- 1) INSERT INTO 테이블명 VALUESS (값1, 값2, ...);
-- 테이블에 모든 컬럼에 대한 값을 넣고자 할 때 컬럼의 순서를 지켜야 한다.
-- 부족하게 값을 넣는 경우 : NOT ENOUGH VALUE 오류
-- 값을 많이 넣는 경우 : TOO MANY VALUE 오류
INSERT INTO EMPLOYEE VALUES (300, '강아지', '940200-1234567', 'gang@naver.com', '01011111111', NULL, 'J2', 3000000, NULL, 200, '25/02/11', NULL, DEFAULT);

-- 2) INSERT INTO 테이블명 (컬럼명, 컬럼명, 컬럼명, ...) VALUES (값1, 값2, 값3, ...)
-- 테이블에 내가 선택한 컬럼에 대한 값만 넣고자 할 때
-- 한 행 단위로 추가되고 선택하지 않은 컬럼은 NULL이 들어감
-- 만약 DEFAULT가 지정되어 있으면 DEFAULT 값이 들어감
-- NOT NULL 제약조건이 지정되어 있는 컬럼은 반드시 선택해서 값을 넣어야 함
INSERT 
INTO EMPLOYEE (
    EMP_ID, 
    HIRE_DATE, 
    JOB_CODE, 
    EMP_NO, 
    EMP_NAME
) VALUES (
'301', 
'25/02/11', 
'J4', 
'872013-1263153', 
'고양이');

-- 3) INSERT INTO 테이블명 (서브 쿼리)
-- 서브쿼리로 조회된 결과값을 모두 INSERT함 (여러행 INSERT 가능)  

CREATE TABLE EMP_01 (
    EMP_ID VARCHAR(5) PRIMARY KEY,
    EMP_NAME VARCHAR(20),
    DEPT_CODE VARCHAR(20)
);
INSERT INTO EMP_01 (
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
);

CREATE TABLE EMP_02 (
    EMP_ID VARCHAR(5) PRIMARY KEY,
    EMP_NAME VARCHAR(20),
    DEPT_CODE VARCHAR(20)
);
INSERT INTO EMP_02 (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT
    ON (DEPT_CODE = DEPT_ID)
);

-- 4) INSERT ALL : 2개 이상의 테이블에 각각 INSERT 할 때
-- 사용되는 서브쿼리가 동일한 경우

CREATE TABLE EMP_DEPT AS (
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1 = 0
);
CREATE TABLE EMP_MANAGER AS (
    SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1 = 0
);
    
INSERT ALL
INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID) (
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID  
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

-- 조건을 사용하여 각 테이블에 값 INSERT 가능
-- INSERT ALL 
-- WHEN 조건1 THEN INTO 테이블명1 VALUES (컬럼명, 컬럼명, ...)
-- WHEN 조건2 THEN INTO 테이블명2 VALUES (컬럼명, 컬럼명, ...)
-- 서브쿼리
CREATE TABLE EMP_OLD AS (
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1 = 0
);
CREATE TABLE EMP_NEW AS (
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1 = 0
);
INSERT ALL
WHEN HIRE_DATE < '20000101' THEN INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '20000101' THEN INTO EMP_NEW VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY) (
        SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
        FROM EMPLOYEE
);

CREATE TABLE SALARY_HIGH AS (
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE 1 = 0
);
CREATE TABLE SALARY_LOW AS (
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE 1 = 0
);
INSERT ALL
WHEN SALARY > 3000000 THEN INTO SALARY_HIGH VALUES (EMP_ID, EMP_NAME, SALARY, BONUS)
WHEN SALARY <= 3000000 THEN INTO SALARY_LOW VALUES (EMP_ID, EMP_NAME, SALARY, BONUS) (
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
);

-- 2. UPDATE : 테이블의 값들을 수정하는 구문
-- UPDATE 테이블명 SET 컬럼명 = 수정할 값, 컬럼명 = 수정할 값, ... [WHERER 조건];
-- WHERE절을 생략하면 테이블 안의 전체 컬럼값이 변경됨
CREATE TABLE DEPT_COPY AS (
    SELECT *
    FROM DEPARTMENT
);
UPDATE DEPT_COPY 
SET DEPT_TITLE = '전략기회팀' 
WHERE DEPT_ID = (
    SELECT DEPT_ID
    FROM DEPARTMENT
    WHERE DEPT_TITLE = '인사관리부'
);

CREATE TABLE EMP_SALARY AS (
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
);
UPDATE EMP_SALARY
SET SALARY = 2000000, BONUS = 0.1
WHERE EMP_ID = (
    SELECT EMP_ID
    FROM EMP_SALARY
    WHERE EMP_NAME = '지정보'
);
-- PRIMARY KEY가 아닌 컬럼값을 WHERE절에 사용하면 중복된 값이 있을 수 있으므로 주의
UPDATE EMP_SALARY
SET SALARY = SALARY*1.1;

UPDATE EMP_SALARY
SET SALARY = (
    SELECT SALARY
    FROM EMP_SALARY
    WHERE EMP_ID = '206'
), BONUS = (
    SELECT BONUS
    FROM EMP_SALARY
    WHERE EMP_ID = '206'
)
WHERE EMP_ID = '214';

UPDATE EMP_SALARY
SET (SALARY, BONUS) = (
    SELECT SALARY, BONUS
    FROM EMP_SALARY
    WHERE EMP_ID = '213'
)
WHERE EMP_ID = '214';

UPDATE EMP_SALARY 
SET (SALARY, BONUS) = (
    SELECT SALARY, BONUS
    FROM EMP_SALARY
    WHERE EMP_ID IN (
        SELECT EMP_ID
        FROM EMP_SALARY
        WHERE EMP_NAME = '문정보'
    )
)
WHERE EMP_ID IN (
    SELECT EMP_ID
    FROM EMP_SALARY
    WHERE EMP_NAME IN ('조정연', '유하보', '강정보')
);

CREATE TABLE EMPLOYEE_COPY AS (
    SELECT *
    FROM EMPLOYEE
);

ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY (EMP_ID);

UPDATE EMPLOYEE_COPY
SET BONUS = 0.3
WHERE EMP_ID IN (
    SELECT EMP_ID
    FROM EMPLOYEE_COPY
    JOIN DEPARTMENT
    ON (DEPT_ID = DEPT_CODE)
    JOIN LOCATION
    ON (LOCAL_CODE = LOCATION_ID)
    WHERE LOCAL_NAME LIKE '%ASIA%'
);

UPDATE EMPLOYEE_COPY
SET EMP_NAME = NULL
WHERE EMP_ID = '200'; -- 오류 : UPDATE 할 때는 제약조건을 만족해야됨

ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY (DEPT_CODE) REFERENCES DEPARTMENT (DEPT_ID);

UPDATE EMPLOYEE_COPY
SET DEPT_CODE = 'D0'
WHERE EMP_ID = '200'; -- 오류 : UPDATE 할 때는 제약조건을 만족해야됨

UPDATE EMPLOYEE_COPY
SET DEPT_CODE = NULL
WHERE EMP_ID = '200';

-- 3. DELETE : 테이블의 데이터를 행단위로 삭제
-- DELETE FROM 테이블명 [WHERE 조건식]
-- WHERE절이 없으면 모든 행이 삭제됨으로 주의
DELETE 
FROM EMPLOYEE_COPY
WHERE EMP_ID = '213';

INSERT INTO EMPLOYEE_COPY (
    SELECT *
    FROM EMPLOYEE
    WHERE EMP_ID = '213'
);

COMMIT;

DELETE 
FROM EMPLOYEE_COPY
WHERE DEPT_CODE = 'D8';

ROLLBACK;

-- TRUNCATE : 테이브의 전체 행을 삭제하는 구문
-- 테이블 전체를 삭제할 때는 DELETE 보다 속도가 빠름
-- 별도의 조건 제시 불가(WHERE 사용 불가)
-- ROLLBACK 불가

TRUNCATE TABLE EMP_SALARY;




