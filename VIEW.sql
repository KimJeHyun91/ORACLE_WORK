-- VIEW
--  - SELECT문을 저장해둘 수 있는 객체
--  - 실제테이블이 아님/임시테이블(논리적 테이블)
--  - 실제로 데이터가 담겨있지 않음
--  - 자주 사용하는 긴 SELECT문
--  - 한번만 만들어 놓으면 다시 기술할 필요가 없음
--  - 서브쿼리의 SELECT절에 함수식이나 산술연산식이 기술되어 있는 경우는 반드시 별칭 부여
--  - CREATE [OR REPLACE][FORCE|NOFORCE] VIEW 뷰명 AS 서브쿼리 [WITH CHECK OPTION][WITH READ ONLY]
--      1) OR REPLACE  : 기존에 동일한 이름의 뷰가 존재하면 덮어쓰기, 존재하지 않으면 새로 생성
--      2) FORCE|NOFORCE 
--          - FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰를 생성할 수 있음
--          - NOFORCE : 서브쿼리에 기술된 테이블이 반드시 존재 해야만 뷰를 생성할 수 있음(기본값)
--      3) WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML이 가능하도록 함
--      4) WIHT READ OPTION : 뷰를 조회만 가능(SELECT를 제외한 DML 불가)
--  - 생성되 뷰를 통해 DML(INSERT, UPDATE, DELETE) 가능
--  - 뷰를 통해 DML을 실행하면 실제 데이터가 담겨있는 테이블에 반영됨
--      1) 뷰에 정의되어 있지 않은 컬럼을 조작하지 못함
--      2) 뷰에 정의되어 있는 컬럼 중에 테이블에 NOT NULL 제약조건이 지정되어 있는 경우
--      3) 산술연산식 또는 함수식을 정의되어 있는 경우
--      4) 그룹함수나 GRUOP BY절이 포함된 경우
--      5) DISTINCT 구문이 포함된 경우
--      6) JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT
ON (DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE)
JOIN LOCATION
ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL
USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국'; 

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT
ON (DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE)
JOIN LOCATION
ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL
USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT
ON (DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE)
JOIN LOCATION
ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL
USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본';

-- VIEW 생성
-- CREATE VIEW 뷰명 AS (서브쿼리);
CREATE VIEW VIEW_LOCATION
AS (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT
    ON (DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE)
    JOIN LOCATION
    ON (LOCAL_CODE = LOCATION_ID)
    JOIN NATIONAL
    USING (NATIONAL_CODE)
    );

SELECT *
FROM VIEW_LOCATION
WHERE NATIONAL_NAME = '한국';

CREATE OR REPLACE VIEW VIEW_EMPLOYEE
AS (
        SELECT 
            EMP_ID, 
            EMP_NAME, 
            JOB_NAME, 
            DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여') GENDER, 
            EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) || '년' WORK_YEAR
        FROM EMPLOYEE
        JOIN JOB
        USING (JOB_CODE)
        WHERE END_DATE IS NULL
    );

CREATE OR REPLACE VIEW VIEW_EMPLOYEE (사번, 사원명, 직급명, 성별, 근무년수)
AS (
    SELECT 
        EMP_ID, 
        EMP_NAME, 
        JOB_NAME, 
        DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여', '3', '남', '4', '여'), 
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE
    JOIN JOB
    USING (JOB_CODE)
    WHERE END_DATE IS NULL
);

SELECT *
FROM VIEW_EMPLOYEE
WHERE 근무년수 >= 30;

SELECT *
FROM VIEW_EMPLOYEE
WHERE 성별 = '여';

DROP VIEW VIEW_EMPLOYEE;

CREATE VIEW VIEW_JOB
AS (
    SELECT
        JOB_CODE,
        JOB_NAME
    FROM JOB
    );

INSERT 
INTO VIEW_JOB 
VALUES (
        'J8', 
        '인턴'
        ); -- JOB 테이블에도 삽입(JOB의 제약조건을 지켜야됨)
        
UPDATE VIEW_JOB
SET JOB_NAME = '수습사원'
WHERE JOB_CODE = 'J8';
        
DELETE
FROM VIEW_JOB
WHERE JOB_CODE = 'J8';

CREATE OR REPLACE VIEW VIEW_JOB
AS (
    SELECT 
        JOB_NAME
    FROM JOB
    );

INSERT
INTO VIEW_JOB
VALUES ('인턴'); -- JOB 테이블에 NULL, '인턴'을 추가하는 작업이고, JOB 테이블의 JOB_CODE는 NOT NULL 제약조건이 지정되어 있기 때문에 오류 발생

CREATE OR REPLACE VIEW 
    VIEW_SALARY
AS (
    SELECT 
        EMP_ID
        , EMP_NAME
        , EMP_NO
        , JOB_CODE
        , SALARY
        , SALARY*12 연봉
    FROM 
        EMPLOYEE
    );

INSERT
INTO
    VIEW_SALARY
VALUES (
        400
        , '강아지'
        , '912425-1631644'
        , 'J2'
        , 3000000
        , 36000000
        ); -- 연봉 컬럼은 VIEW 생성시 만들어 낸 것이기 때문에 오류 발생

UPDATE
    VIEW_SALARY
SET 
    연봉 = 3000000
WHERE
    EMP_ID = '302'; -- 오류 : VEIW 생성시 생성한 컬럼은 실제로는 만들지 않은 가상 컬럼이기 때문에 오류 발생

DELETE
FROM
    VIEW_SALARY
WHERE
    연봉 = 18600000; -- 가상 컬럼을 직접 수정하는 것이 아니기 때문에 사용 가능
    
CREATE OR REPLACE VIEW 
    VIEW_GROUP
AS
    (SELECT 
        DEPT_CODE
        , SUM(SALARY) 합계
        , CEIL(AVG(SALARY)) 평균
    FROM
        EMPLOYEE
    GROUP BY
        DEPT_CODE);
        
INSERT
INTO
    VIEW_GROUP
VALUES 
    ('D3'
    , 8000000
    , 4000000); -- 오류

UPDATE
    VIEW_GROUP
SET
    DEPT_CODE = 'D0'
WHERE 
    DEPT_CODE = 'D9'; -- 오류
    
DELETE
FROM
    VIEW_GRUOP
WHERE
    DEPT_CODE = 'D9'; -- 오류
    
SELECT
    *
FROM
    VIEW_GROUP; -- 가능
    
CREATE OR REPLACE VIEW 
    VIEW_GROUP
AS
    (SELECT 
        DISTINCT DEPT_CODE 부서 
    FROM
        EMPLOYEE);

SELECT 
    *
FROM
    VIEW_GROUP;
    
DELETE
FROM 
    VIEW_GROUP
WHERE
    부서 = 'D9'; -- 오류
    
CREATE OR REPLACE VIEW
    VIEW_JOIN
AS
    (SELECT
        EMP_ID
        , EMP_NAME
        , EMP_NO
        , JOB_CODE
        , DEPT_TITLE
    FROM
        EMPLOYEE
    JOIN   
        DEPARTMENT
    ON
        (DEPT_CODE = DEPT_ID));

INSERT
INTO
    VIEW_JOIN
VALUES
    ('400'
    , '이순신'
    , '972152-1245353'
    , 'J1'
    , '총무부'); -- 오류

UPDATE
    VIEW_JOIN
SET 
    DEPT_TITLE = '회계관리부'
WHERE
    EMP_ID = 217;
    
DELETE
FROM
    VIEW_JOIN
WHERE
    EMP_ID = '217';

CREATE OR REPLACE FORCE VIEW
    VIEW_EMPLOYEE
AS
    (SELECT 
        TCODE
        , TNAME
        , TCONTENT
    FROM
        TTT); -- 뷰가 생성은 되었지만 활용은 하지 못함

CREATE OR REPLACE VIEW
    VIEW_EMPLOYEE
AS
    (SELECT
        *
    FROM
        EMPLOYEE
    WHERE
        SALARY >= 3000000);

UPDATE
    VIEW_EMPLOYEE
SET
    SALARY = 1000000
WHERE 
    EMP_ID = '201';

CREATE OR REPLACE VIEW
    VIEW_EMPLOYEE
AS
    (SELECT
        *
    FROM
        EMPLOYEE
    WHERE
        SALARY >= 3000000)
WITH CHECK OPTION; 

UPDATE
    VIEW_EMPLOYEE
SET
    SALARY = 1000000
WHERE 
    EMP_ID = '202';

CREATE OR REPLACE VIEW
    VIEW_EMPLOYEE
AS
    (SELECT
        *
    FROM
        EMPLOYEE
    WHERE
        SALARY >= 3000000)
WITH READ ONLY;

DELETE
FROM
    VIEW_EMPLOYEE
WHERE
    EMP_ID = '211'; -- SELECT만 가능
    


