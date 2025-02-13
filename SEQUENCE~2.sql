-- PL/SQL
-- 오라클 자체에 내장되어 있는 절차적 언어
-- SQL 문장 내에서 변수 정의, 조건 처리(IF), 반복문(LOOP, FOR, WHILE) 등을 지원함
--
-- [선언부(DECLARE SECTION)] : DECLARE로 시작, 변수나 상수정의 및 초기화 하는 부분
-- 실행부(EXECUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문(조건문, 반복문) 등의 로직을 기술하는 부분
-- [예외처리부(EXCEPTION SECTION)] : 예외처리 부분

SET SERVEROUTPUT ON; -- 화면에 출력문을 보려면 SERVEROUTPUT을 ON 해줘야됨

BEGIN 
    DBMS_OUTPUT.PUT_LINE('강아지'); 
END;
/

-- 1. 변수 정의 
--  DECLARE 선언부
--  - 변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능)
--  - 일반타입변수, 레퍼런스 타입 변수, ROW타입 변수
-- 1.1 일반타입변수 선언 및 초기화
-- 변수명[CONSTANT] 자료형[=값]
DECLARE
    EID NUMBER;
    ENAME VARCHAR (20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 800;
    ENAME := '강아지';
    
    DBMS_OUTPUT.PUT_LINE ('EID : '|| EID);
    DBMS_OUTPUT.PUT_LINE ('ENAME : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE ('PI : ' || PI);
END;
/
-- 1.2 레퍼런스 타입 변수 선언 및 초기화(테이블의 컬럼의 데이터타입을 참조하여 그 타입으로 지정)
-- 변수명 테이블명.컬럼명%TYPE;
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '200';
    ENAME := '강아지';
    ESALARY := 3000000;

    DBMS_OUTPUT.PUT_LINE ('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('ESALARY : ' || ESALARY);

END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT 
        EMP_ID
        , EMP_NAME
        , SALARY 
    INTO 
        EID
        , ENAME
        , ESALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '200';
    
    DBMS_OUTPUT.PUT_LINE ('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('ESALARY : ' || ESALARY);
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT 
        EMP_ID
        , EMP_NAME
        , SALARY 
    INTO 
        EID
        , ENAME
        , ESALARY
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE ('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('ESALARY : ' || ESALARY);
END;
/

CREATE VIEW VIEW_TEMP
AS (
    SELECT
        EMP_ID
        , EMP_NAME
        , SALARY
        , DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT
    ON (DEPT_ID = DEPT_CODE)
);
/
-- VIEW 사용
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESALARY EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT
        EMP_ID
        , EMP_NAME
        , SALARY
        , DEPT_TITLE
    INTO
        EID
        , ENAME
        , ESALARY
        , DTITLE
    FROM VIEW_TEMP
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE ('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('ESALARY : ' || ESALARY);
    DBMS_OUTPUT.PUT_LINE ('DTITLE : ' || DTITLE);
END;
/

-- SELECT 사용
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESALARY EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT
        EMP_ID
        , EMP_NAME
        , SALARY
        , DEPT_TITLE
    INTO
        EID
        , ENAME
        , ESALARY
        , DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT
    ON (DEPT_ID = DEPT_CODE)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE ('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('ESALARY : ' || ESALARY);
    DBMS_OUTPUT.PUT_LINE ('DTITLE : ' || DTITLE);
END;
/

-- 1.3 ROW 타입 변수 
-- 테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
-- 변수명 테이블명%ROWTYPE;
-- 주의사항 : ROW 타입 변수를 사용할 떄는 무조건 모든 컬럼을 불러와야됨 
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '210';

    DBMS_OUTPUT.PUT_LINE ('ID : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE ('NAME : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE ('SALARY : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE ('BONUS : ' || NVL(E.BONUS, 0));
END;
/

-- 2. 조건 처리
-- BEGIN 
--      <조건문>
--  1) IF 조건식 THEN 실행내용 END IF; (단일 IF문)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESALARY EMPLOYEE.SALARY%TYPE;
    EBONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT 
        EMP_ID
        , EMP_NAME
        , SALARY
        , NVL (BONUS, 0)
    INTO
        EID
        , ENAME
        , ESALARY
        , EBONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    DBMS_OUTPUT.PUT_LINE ('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('월급 : ' || ESALARY);
    IF EBONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE ('보너스를 지급받지 않는 사원입니다');
    END IF;
    DBMS_OUTPUT.PUT_LINE ('보너스 : ' || EBONUS*100 || '%');
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    ESALARY EMPLOYEE.SALARY%TYPE;
    EBONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT 
        EMP_ID
        , EMP_NAME
        , SALARY
        , NVL (BONUS, 0)
    INTO
        EID
        , ENAME
        , ESALARY
        , EBONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    DBMS_OUTPUT.PUT_LINE ('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('월급 : ' || ESALARY);
    IF EBONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE ('보너스를 지급받지 않는 사원입니다');
    ELSE 
            DBMS_OUTPUT.PUT_LINE ('보너스 : ' || EBONUS*100 || '%');
    END IF;
END;
/

CREATE OR REPLACE VIEW VIEW_TEMP
AS (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    FROM EMPLOYEE
    JOIN DEPARTMENT
    ON (DEPT_ID = DEPT_CODE)
    JOIN LOCATION
    ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL
    USING (NATIONAL_CODE)
);
    

DECLARE 
    TEAM CHAR(20);
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE; 
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    NNAME C##SEQUENCE.NATIONAL.NATIONAL_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCATION.NATIONAL_CODE, NATIONAL_NAME
    INTO EID, ENAME, DTITLE, NCODE, NNAME
    FROM EMPLOYEE
    JOIN DEPARTMENT
    ON (DEPT_ID = DEPT_CODE)
    JOIN LOCATION
    ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL
    ON (NATIONAL.NATIONAL_CODE = LOCATION.NATIONAL_CODE)
    WHERE EMP_ID = &사번;
    
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
    ELSE 
        TEAM := '해외팀';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE (EID || ', ' || ENAME || ', ' || DTITLE || ', ' || TEAM);
END;
/

-- 3) IF-ELSE IF.. 조건문
-- IF 조건식
--      THEN 실행내용1
-- ELSIF 조건식2
--      THEN 실행내용2;
-- ELSE
--      THEN 실행내용3;
-- END IF;

DECLARE
    SCORE NUMBER;
    GRADE CHAR (1);
BEGIN
    SCORE := &점수;
    IF SCORE >= 90
        THEN GRADE := 'A';
    ELSIF SCORE >= 80
        THEN GRADE := 'B';
    ELSIF SCORE >= 70
        THEN GRADE := 'C';
    ELSIF SCORE >= 60
        THEN GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE ('당신의 점수는 '||SCORE||'점 이고, '||'당신의 학점은 '||GRADE||' 입니다.');
END;
/

DECLARE
    TEMP_SALARY NUMBER;
    SALARY_GRADE CHAR (7);
BEGIN
    SELECT 
        SALARY
    INTO
        TEMP_SALARY
    FROM
        EMPLOYEE
    WHERE 
        EMP_ID = &사번;
    IF 
        TEMP_SALARY >= 5000000
    THEN
        SALARY_GRADE := '고급';
    ELSIF
        TEMP_SALARY >= 3000000
    THEN
        SALARY_GRADE := '중급';
    ELSE
        SALARY_GRADE := '초급';
    END IF;
    DBMS_OUTPUT.PUT_LINE ('해당 사원의 급여 등급은 ' || SALARY_GRADE || ' 입니다.');
END;
/

-- 4) CASE
-- CASE 비교대상자 WHEN 비교할값1 THEN 실행내용1 WHEN 비교할값2 THEN 실행내용2 WHEN 비교할값3 THEN 실행내용3 ... ELSE 실행내용4 END;
DECLARE
    TEMPORARY_EMPLOYEE EMPLOYEE%ROWTYPE;
    DEPARTMENT_NAME VARCHAR (20);
BEGIN
    SELECT 
        *
    INTO 
        TEMPORARY_EMPLOYEE
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;
    DEPARTMENT_NAME := CASE
        TEMPORARY_EMPLOYEE.DEPT_CODE
    WHEN
        'D1'
    THEN   
        '인사팀'
    WHEN
        'D2'
    THEN
        '회계관리팀'
    WHEN
        'D3'
    THEN
        '마케팅팀'
    WHEN
        'D4'
    THEN
        '국내영업팀'
    WHEN
        'D8'
    THEN
        '기술지원팀'
    WHEN
        'D9'
    THEN
        '총무팀'
    ELSE
        '해외영업팀'
    END;
    DBMS_OUTPUT.PUT_LINE ('해당 사번의 사원은 ' || DEPARTMENT_NAME || '입니다.');
END;
/

DECLARE
    DEPARTMENT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    DEPARTMENT_NAME VARCHAR (15);
BEGIN
    SELECT 
        DEPT_CODE
    INTO
        DEPARTMENT_CODE
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;
    DEPARTMENT_NAME := CASE
        DEPARTMENT_CODE
    WHEN
        'D5'
    THEN   
        '일본'
    WHEN
        'D6'
    THEN
        '중국'
    WHEN
        'D7'
    THEN
        '미국'
    WHEN
        'D8'
    THEN
        '러시아'
    ELSE
        '한국'
    END;
    DBMS_OUTPUT.PUT_LINE ('해당 사원의 근무지역은 ' || DEPARTMENT_NAME || '입니다.');
END;
/
 
-- 3. 반복문   
-- 3.1 BASIC LOOP문
-- LOOP 
--      반복적으로 실행할 구문;
--      반복을 빠져나갈 수 있는 구문
-- END LOOP;
-- 반복문을 빠져나오는 구문
--  1) IF 조건식 THEN EXIT; END IF;
--  2) EXIT WHEN 조건식;
DROP SEQUENCE SEQUENCE_NUMBER1;
CREATE SEQUENCE SEQUENCE_NUMBER1 NOCACHE;

DECLARE
    TEMPORARY_NUMBER NUMBER := 1;
BEGIN
    LOOP
       TEMPORARY_NUMBER := SEQUENCE_NUMBER1.NEXTVAL;
        DBMS_OUTPUT.PUT_LINE (TEMPORARY_NUMBER);
        IF
            TEMPORARY_NUMBER = 5
        THEN 
            EXIT;
        END IF;
    END LOOP;
END;-- 
/

SELECT SEQUENCE_NUMBER1.CURRVAL
FROM DUAL;

-- 3.2 FOR LOOP문
-- FOR 변수 IN [REVERSE] 초기값...최종값 
-- LOOP
--      반복적으로 실행할 구문
-- END LOOP;
DECLARE
    TEMPORARY_NUMBER NUMBER := 1;
BEGIN
    FOR 
        TEMPEORARY_NUMBER 
    IN 
        1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE (TEMPORARY_NUMBER);
    END LOOP;
END;
/

CREATE TABLE TABLE_SQL (
    TABLE_NO NUMBER PRIMARY KEY
    , TABLE_DATE DATE
);

CREATE SEQUENCE 
    SEQUENCE_NUMBER
INCREMENT BY
    2
NOCACHE;

BEGIN
    FOR TEMPORARY_NUMBER IN 1..100
        LOOP  
            INSERT INTO 
                TABLE_SQL
            VALUES (
                SEQUENCE_NUMBER.NEXTVAL
                , SYSDATE
            );
        END LOOP;
END;
/

-- 3.3 WHILE LOOP문
-- WHILE 조건식
-- LOOP
--      반복적으로 실행할 구문;
-- END LOOP;
DECLARE
    TEMPORARY_NUMBER NUMBER := 1;
BEGIN
    WHILE
        TEMPORARY_NUMBER != 5
        LOOP
            DBMS_OUTPUT.PUT_LINE(TEMPORARY_NUMBER);
            TEMPORARY_NUMBER := TEMPORARY_NUMBER + 1;
        END LOOP;
END;
/

-- 예외처리부
-- EXCEPTION
--      WHEN 예외명1 THEN 예외처리구문;
--      WHEN 예외명2 THEN 예외처리구문;
--      WHEN OTEHRS THEN 예외처리구문;
-- 시스템 예외 (오라클에서 미리 정의해둔 예외)
-- 1) NO_DATA_FOUND : SELECT 한 결과가 한 행도 없을 경우
-- 2) TOO_MANY_ROWS : SELECT 한 결과가 여러 행일 경우
-- 3) ZERO_DIVIDE : 0으로 나눌 때
-- 4) DUP_VAL_ON_INDEX : UNIQUE 제약 조건에 위배 되었을 때
-- ...
DECLARE 
    TEMPORARY_NUMBER NUMBER;
BEGIN
    TEMPORARY_NUMBER := 10/&숫자;
    DBMS_OUTPUT.PUT_LINE (TEMPORARY_NUMBER);
EXCEPTION
    WHEN
        ZERO_DIVIDE
    THEN   
        DBMS_OUTPUT.PUT_LINE ('0으로 나눌 수 없습니다.');
    WHEN
        OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE ('오류 발생');
END;
/

BEGIN
    UPDATE
        EMPLOYEE
    SET
        EMP_ID = '&변경할사번'
    WHERE
        EMP_NAME = '이정하';
EXCEPTION
    WHEN
        DUP_VAL_ON_INDEX 
    THEN
        DBMS_OUTPUT.PUT_LINE ('이미 존재하는 사번입니다.');
END;
/

DECLARE
    EMPLOYEE_ID EMPLOYEE.EMP_ID%TYPE;
    EMPLOYEE_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT
        EMP_ID
        , EMP_NAME
    INTO
        EMPLOYEE_ID
        , EMPLOYEE_NAME
    FROM 
        EMPLOYEE
    WHERE
        MANAGER_ID = '&사수사번';
    DBMS_OUTPUT.PUT_LINE ('사번 = ' || EMPLOYEE_ID || '사원명 = ' || EMPLOYEE_NAME);
EXCEPTION
    WHEN
        TOO_MANY_ROWS
    THEN
        DBMS_OUTPUT.PUT_LINE ('여러행을 조회할 수 없습니다.');
    WHEN
        NO_DATA_FOUND
    THEN
        DBMS_OUTPUT.PUT_LINE ('조회 결과가 없습니다.');
END;
/
        
DECLARE
    NAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY NUMBER;
    BONUS NUMBER;
    YEAR_SALARY NUMBER;
BEGIN
    SELECT 
        EMP_NAME
        , SALARY
        , BONUS
    INTO
        NAME
        , SALARY
        , BONUS
    FROM
        EMPLOYEE
    WHERE
        EMP_ID = &사번;
    IF 
        BONUS IS NOT NULL
    THEN
        YEAR_SALARY := SALARY * (1 + BONUS) * 12;
    ELSE
        YEAR_SALARY := SALARY * 12;
    END IF;
    DBMS_OUTPUT.PUT_LINE (NAME || '의 연봉은 ' || YEAR_SALARY || '입니다.');
END;
/

-- FOR
DECLARE
    FIRST_NUMBER NUMBER;
    SECONDE_NUMBER NUMBER;
BEGIN
    FOR 
        FIRST_NUMBER 
    IN 
        1 .. 9
    LOOP
        FOR
            SECONDE_NUMBER
        IN
            1 .. 9
        LOOP
            IF
                MOD (FIRST_NUMBER, 2) = 0 
                AND MOD (SECONDE_NUMBER, 2) = 0
            THEN
                DBMS_OUTPUT.PUT_LINE (FIRST_NUMBER || ' * ' || SECONDE_NUMBER || ' = ' || FIRST_NUMBER * SECONDE_NUMBER);
            END IF;
        END LOOP;
    END LOOP;
END;
/

-- WHILE
DECLARE
    FIRST_NUMBER NUMBER := 1;
    SECONDE_NUMBER NUMBER := 1;
BEGIN
    WHILE 
        FIRST_NUMBER != 10
    LOOP
        WHILE
            SECONDE_NUMBER != 10
        LOOP
            IF
                MOD (FIRST_NUMBER, 2) = 0 
                AND MOD (SECONDE_NUMBER, 2) = 0
            THEN
                DBMS_OUTPUT.PUT_LINE (FIRST_NUMBER || ' * ' || SECONDE_NUMBER || ' = ' || FIRST_NUMBER * SECONDE_NUMBER);
            END IF;
            SECONDE_NUMBER := SECONDE_NUMBER + 1;
        END LOOP;
            FIRST_NUMBER := FIRST_NUMBER + 1;
            SECONDE_NUMBER := 1;
    END LOOP;
END;
/



            
        
        
    
        
        

