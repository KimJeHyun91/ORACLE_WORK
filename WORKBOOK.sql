-- 1. BASIC
-- 1
SELECT DEPARTMENT_NAME "학과 명", CATEGORY 계열
FROM TB_DEPARTMENT;

-- 2
SELECT DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || ' 입니다' "학과별 정원"
FROM TB_DEPARTMENT;

-- 3
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119');

-- 4
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

-- 5
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 6
SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 7
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 8
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;

-- 9
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'N' AND ENTRANCE_DATE BETWEEN '02/01/01' AND '02/12/31' AND STUDENT_ADDRESS LIKE '전주시%';

-- 2. ADDITIONAL FUNTION
-- 1
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, ENTRANCE_DATE 입학년도 FROM TB_STUDENT WHERE DEPARTMENT_NO = 002;

-- 2
SELECT PROFESSOR_NAME, PROFESSOR_SSN FROM TB_PROFESSOR WHERE NOT PROFESSOR_NAME LIKE '___';

-- 3
SELECT * FROM TB_PROFESSOR WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1' ORDER BY PROFESSOR_SSN;
SELECT PROFESSOR_NAME 교수이름
, -- EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(19000000+SUBSTR(PROFESSOR_SSN, 1, 6))) 나이
FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(19000000+SUBSTR(PROFESSOR_SSN, 1, 6)))/12) 나이
FROM TB_PROFESSOR 
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1'
ORDER BY 나이;

-- 4
SELECT SUBSTR(PROFESSOR_NAME, 2) 이름 FROM TB_PROFESSOR;

-- 5
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 6))) > 19;

-- 6
SELECT TO_CHAR(TO_DATE(20201225), 'DAY') FROM DUAL;

-- 7
SELECT TO_DATE('991011', 'YY/MM/DD')
, TO_DATE('991011','YYMMDD')
, TO_CHAR(TO_DATE('99/10/11', 'rr/MM/DD'), 'YYYY/MM/DD')
, TO_CHAR(TO_DATE('49/10/11', 'rr/mm/dd'), 'YYYY/MM/DD')
, TO_CHAR(TO_DATE('99/10/11'), 'RRRR/MM/DD')
, TO_CHAR(TO_DATE('49/10/11'), 'RRRR/MM/DD')
FROM DUAL;

-- 8
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE NOT STUDENT_NO LIKE 'A%';

-- 9
SELECT ROUND(AVG(POINT),1) FROM TB_GRADE WHERE STUDENT_NO = 'A517178';

-- 10
SELECT DEPARTMENT_NO 학과번호, COUNT(*) "학생수(명)" FROM TB_STUDENT GROUP BY DEPARTMENT_NO ORDER BY 학과번호;

-- 11
SELECT COUNT(*) FROM TB_STUDENT WHERE COACH_PROFESSOR_NO IS NULL;

-- 12
SELECT SUBSTR(TERM_NO, 1, 4) 년도, ROUND(AVG(POINT), 1) "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4)
HAVING SUBSTR(TERM_NO, 1, 4) = '여자'
ORDER BY 년도;

-- 13
SELECT DEPARTMENT_NO 학과코드명 , COUNT(*) "휴학생 수"
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
GROUP BY DEPARTMENT_NO
ORDER BY 학과코드명;

-- 14
SELECT STUDENT_NAME 동일이름, COUNT(*) "동명인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*) >= 2
ORDER BY 동일이름;

-- 15
SELECT NVL(SUBSTR(TERM_NO, 1, 4), ' ') 년도, NVL(SUBSTR(TERM_NO, 5, 2), ' ') 학기, ROUND(AVG(POINT), 1) 평점 
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2));

-- 3. ADDITIONAL OPTION
-- 1
SELECT STUDENT_NAME "학생 이름", STUDENT_ADDRESS 주소지
FROM TB_STUDENT
ORDER BY STUDENT_NAME;

-- 2
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD'));

-- 3
SELECT STUDENT_NAME "학생 이름", STUDENT_NO 학번, STUDENT_ADDRESS 주소지
FROM TB_STUDENT
WHERE ENTRANCE_DATE BETWEEN '19900101' AND '19991231'
 AND (STUDENT_ADDRESS LIKE '강원%' OR STUDENT_ADDRESS LIKE '경기%') -- SUBSTR(STUDENT_ADDRESS, 1, 3) IN ('강원도', '경기도')
ORDER BY STUDENT_NAME;

-- 4
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
JOIN TB_DEPARTMENT
USING (DEPARTMENT_NO)
WHERE TB_DEPARTMENT.DEPARTMENT_NAME = '법학과'
ORDER BY TO_DATE(SUBSTR(PROFESSOR_SSN, 1, 6), 'RRMMDD');

-- 5
SELECT STUDENT_NO, TO_CHAR(POINT, '9.99')
FROM TB_GRADE
WHERE CLASS_NO = 'C3118100' 
    AND TERM_NO = '200402'
ORDER BY POINT DESC, STUDENT_NO;

-- 6
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT
USING (DEPARTMENT_NO)
ORDER BY STUDENT_NAME;

-- 7
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_DEPARTMENT
JOIN TB_CLASS
USING (DEPARTMENT_NO);

-- 8
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_PROFESSOR
JOIN TB_CLASS_PROFESSOR
USING (PROFESSOR_NO)
JOIN TB_CLASS
USING (CLASS_NO);

-- 9
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_PROFESSOR
JOIN TB_CLASS_PROFESSOR
USING (PROFESSOR_NO)
JOIN TB_CLASS
USING (CLASS_NO)
JOIN TB_DEPARTMENT
ON (TB_PROFESSOR.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
WHERE CATEGORY = '인문사회';

-- 10
WITH "전체 평점" AS (SELECT STUDENT_NO, ROUND(AVG(POINT), 1) "전체 평점"
                    FROM TB_GRADE
                    GROUP BY STUDENT_NO)
SELECT STUDENT_NO 학번, STUDENT_NAME "학생 이름", "전체 평점"
FROM TB_STUDENT
JOIN "전체 평점"
USING (STUDENT_NO)
JOIN TB_DEPARTMENT
USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
ORDER BY 학번;

-- 11
SELECT DEPARTMENT_NAME, STUDENT_NAME, PROFESSOR_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT
ON (TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO)
JOIN TB_PROFESSOR
ON (TB_STUDENT.COACH_PROFESSOR_NO = TB_PROFESSOR.PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

-- 12
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT
JOIN TB_GRADE 
USING (STUDENT_NO)
JOIN TB_CLASS
USING (CLASS_NO)
WHERE SUBSTR(TERM_NO, 1, 4) = '2007'
    AND CLASS_NAME = '인간관계론'
ORDER BY STUDENT_NAME;
    
-- 13
WITH 클래스번호 AS (
    SELECT CLASS_NO
    FROM TB_CLASS
    MINUS
    SELECT CLASS_NO
    FROM TB_CLASS_PROFESSOR
)        
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT
USING (DEPARTMENT_NO)
JOIN 클래스번호
USING (CLASS_NO)
WHERE CATEGORY = '예체능'
ORDER BY DEPARTMENT_NAME;

-- 14
SELECT STUDENT_NAME, NVL(PROFESSOR_NAME, '지도교수 미지정')
FROM TB_STUDENT
JOIN TB_DEPARTMENT
USING (DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR
ON (PROFESSOR_NO = COACH_PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '서반아어학과';

-- 15
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, DEPARTMENT_NAME "학과 이름", 평점
FROM (
        SELECT STUDENT_NO, ROUND(AVG(POINT), 8) 평점
        FROM TB_GRADE
        GROUP BY STUDENT_NO
        HAVING AVG(POINT) >= 4
)
JOIN TB_STUDENT
USING (STUDENT_NO)
JOIN TB_DEPARTMENT
USING (DEPARTMENT_NO)
WHERE ABSENCE_YN = 'N'
ORDER BY 학번;

-- 16
SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM TB_CLASS
JOIN TB_GRADE
USING (CLASS_NO)
JOIN TB_DEPARTMENT
USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '환경조경학과' 
    AND CLASS_TYPE LIKE '%전공%'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY CLASS_NO;

-- 17
SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO IN (
    SELECT DEPARTMENT_NO
    FROM TB_STUDENT
    WHERE STUDENT_NAME = '최경희'
)
ORDER BY STUDENT_NAME DESC;

-- 18
WITH 국어국문학과 AS (
    SELECT STUDENT_NO, STUDENT_NAME
    FROM TB_STUDENT
    JOIN TB_DEPARTMENT
    USING (DEPARTMENT_NO)
    WHERE DEPARTMENT_NAME = '국어국문학과'
)
SELECT STUDENT_NO, STUDENT_NAME
FROM (
    SELECT STUDENT_NO, STUDENT_NAME, RANK () OVER (ORDER BY AVG(POINT) DESC) 평점순위
    FROM 국어국문학과
    JOIN TB_GRADE
    USING (STUDENT_NO)
    GROUP BY STUDENT_NO, STUDENT_NAME
)
WHERE 평점순위 = 1;

-- 19
WITH 환경조경학과 AS (
    SELECT CLASS_NO, AVG(POINT) 평점
    FROM TB_CLASS
    JOIN TB_GRADE
    USING (CLASS_NO)
    JOIN TB_DEPARTMENT
    USING (DEPARTMENT_NO)
    WHERE CATEGORY = (
            SELECT CATEGORY
            FROM TB_DEPARTMENT
            WHERE DEPARTMENT_NAME = '환경조경학과'
    )
        AND CLASS_TYPE = '전공선택'
    GROUP BY CLASS_NO
)
SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(평점), 1) 전공평점
FROM TB_DEPARTMENT
JOIN TB_CLASS
USING (DEPARTMENT_NO)
JOIN 환경조경학과
USING (CLASS_NO)
GROUP BY DEPARTMENT_NAME
ORDER BY "계열 학과명";

SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT), 1) 전공평점
FROM TB_DEPARTMENT
JOIN TB_STUDENT
ON (TB_STUDENT.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
JOIN TB_GRADE
USING (STUDENT_NO)
JOIN TB_CLASS
ON (TB_CLASS.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
WHERE CATEGORY = (
    SELECT CATEGORY
    FROM TB_DEPARTMENT
    WHERE DEPARTMENT_NAME = '환경조경학과'
)
    AND CLASS_TYPE = '전공선택'
GROUP BY DEPARTMENT_NAME
ORDER BY "계열 학과명";

-- DML
-- 1
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR(30);
INSERT INTO TB_CLASS_TYPE VALUES ('01', '전공필수');
INSERT INTO TB_CLASS_TYPE VALUES ('02', '전공선택');
INSERT INTO TB_CLASS_TYPE VALUES ('03', '교양필수');
INSERT INTO TB_CLASS_TYPE VALUES ('04', '교양선택');
INSERT INTO TB_CLASS_TYPE VALUES ('05', '논문지도');

-- 2
CREATE TABLE TB_학생일반정보 AS (
    SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름, STUDENT_ADDRESS 주소
    FROM TB_STUDENT
);

-- 3
CREATE TABLE TB_국어국문학과 AS (
    SELECT STUDENT_NO 학번, STUDENT_NAME 학생이름, TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD'), 'RRRR') 출생년도, PROFESSOR_NAME 교수이름
    FROM TB_STUDENT
    JOIN TB_PROFESSOR
    ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
    JOIN TB_DEPARTMENT
    ON (TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO)
    WHERE DEPARTMENT_NAME = '국어국문학과'
);

-- 4
UPDATE TB_DEPARTMENT
SET CAPACITY = ROUND(CAPACITY * 1.1, 0);

-- 5
UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042';

SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE STUDENT_NO = 'A413042';

-- 6
UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

-- 7
UPDATE TB_GRADE
SET POINT = 3.5
WHERE TERM_NO = '200501'
    AND (STUDENT_NO, CLASS_NO) IN (
        SELECT STUDENT_NO, CLASS_NO
        FROM TB_STUDENT
        JOIN TB_DEPARTMENT
        ON (TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO)
        JOIN TB_CLASS
        ON (TB_CLASS.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
        WHERE STUDENT_NAME = '김명훈'
            AND DEPARTMENT_NAME = '의학과'
            AND CLASS_NAME = '피부생리학'
        );

SELECT STUDENT_NAME, CLASS_NAME, TERM_NO, POINT
FROM TB_STUDENT
JOIN TB_DEPARTMENT
ON (TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO)
JOIN TB_CLASS
ON (TB_CLASS.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
JOIN TB_GRADE
ON (TB_GRADE.STUDENT_NO = TB_STUDENT.STUDENT_NO)
WHERE STUDENT_NAME = '김명훈'
    AND DEPARTMENT_NAME = '의학과'
    AND CLASS_NAME = '피부생리학'
    AND TERM_NO = '200501';

COMMIT;
-- 8
DELETE 
FROM TB_GRADE
WHERE STUDENT_NO IN (
    SELECT STUDENT_NO
    FROM TB_STUDENT
    WHERE ABSENCE_YN = 'Y'
);

SELECT STUDENT_NO, STUDENT_NAME, ABSENCE_YN
FROM TB_STUDENT
JOIN TB_GRADE
USING (STUDENT_NO)
WHERE ABSENCE_YN = 'Y';

-- DDL
-- 1
CREATE TABLE TB_CATEGORY (
    NAME VARCHAR (10)
    , USE_YN CHAR (1) DEFAULT 'Y'
);

-- 2
CREATE TABLE TB_CLASS_TYPE (
    NO VARCHAR (5) PRIMARY KEY
    , NAME VARCHAR (10)
);

-- 3
ALTER TABLE TB_CATEGORY ADD PRIMARY KEY (NAME);

-- 4
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

-- 5
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR (10);
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR (20);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR (20);

-- 6
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

-- 7
ALTER TABLE TB_CATEGORY RENAME CONSTRAINT SYS_C007537 TO PK_CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME CONSTRAINT SYS_C007536 TO PK_CLASS_TYPE_NAME;

-- 8
INSERT INTO TB_CATEGORY VALUES ('공학', 'Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학', 'Y');
INSERT INTO TB_CATEGORY VALUES ('의학', 'Y');
INSERT INTO TB_CATEGORY VALUES ('예체능', 'Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회', 'Y');
COMMIT;

-- 9
ALTER TABLE TB_DEPARTMENT ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY (CATEGORY) REFERENCES TB_CATEGORY (CATEGORY_NAME);

-- 10
CREATE VIEW VW_학생일반정보 AS (
    SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS FROM TB_STUDENT
);

-- 11
CREATE VIEW 
    VW_지도면담
AS (
    SELECT
        STUDENT_NAME
        , DEPARTMENT_NAME
        , PROFESSOR_NAME
    FROM 
        TB_STUDENT
    JOIN
        TB_DEPARTMENT
    USING
        (DEPARTMENT_NO)
    LEFT JOIN
        TB_PROFESSOR
    ON
        (PROFESSOR_NO = COACH_PROFESSOR_NO)
);

-- 12
CREATE VIEW
    VW_학과별학생수
AS (
    SELECT 
    DEPARTMENT_NAME
    , COUNT(*) STUDENT_COUNT
    FROM 
        TB_STUDENT
    JOIN
        TB_DEPARTMENT
    USING
        (DEPARTMENT_NO)
    GROUP BY DEPARTMENT_NAME
);

-- 13
UPDATE
    VW_학생일반정보
SET
    STUDENT_NAME = '강아지'
WHERE
    STUDENT_NO = 'A213046';
    
-- 14
CREATE OR REPLACE VIEW 
    VW_학생일반정보 
AS (
    SELECT 
        STUDENT_NO
        , STUDENT_NAME
        , STUDENT_ADDRESS 
    FROM 
        TB_STUDENT
)
WITH READ ONLY;

-- 15
WITH 
    수강신청수
AS (
    SELECT
       CLASS_NO, COUNT(*) 삼년수강신청수
    FROM
        TB_GRADE
    WHERE
        TERM_NO LIKE '2009%'
        OR TERM_NO LIKE '2008%'
        OR TERM_NO LIKE '2007%'
    GROUP BY
        CLASS_NO
    ORDER BY 
        삼년수강신청수 DESC
)
SELECT 
    CLASS_NO
    , CLASS_NAME
    , 삼년수강신청수 "누적수강생수(명)"
FROM
    TB_CLASS
JOIN
    수강신청수
USING
    (CLASS_NO)
WHERE
    ROWNUM < 4;

