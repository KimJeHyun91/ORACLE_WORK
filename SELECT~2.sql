/*
함수 FUNCTION
전달된 컬럼값을 읽어들여 함수를 실행한 결과를 반환

- 단일행 함수: n개의 값을 읽어들여 n개의 결과값 반환(매 행마다 함수 실행)
- 그룹 함수: n개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)

* SELECT절에 단일행 함수와 그룹합수를 함께 사용할 수 없음
* 함수식을 기술할 수 있는 위치: SELECT절, WHERE절, ORDER BY절, HAVING절
*/

-- 단일행 함수
-- 문자 처리 함수
-- LENGTH/LENGTHB : NUMBER로 반환
-- LENGTH(컬럼|'문자열'):해당 문자열의 글자수를 반환
-- LENGTHB(컬럼|'문자열'):해당 문자열의 byte를 반환
--      - 한글: XE버전일 때는 1글자당 3byte('ㄱ','ㅏ' 등도 1글자에 해당)
--      - 한글: EE버전일 때는 1글자당 2byte
--      - 그외: 1글자당 1byte

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL; -- DUAL: 오라클에서 제공하는 가상 테이블

SELECT LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

-- INSTR : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(NUMBER)
-- *주의사항 : 오라클의 인덱스번호는 1번부터 시작, 찾는 문자가 없을 때는 0 반환
-- INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을 위치의 시작값,[순번]])
-- 찾을 위치의 시작값 : 1은 앞에서부터 찾기(기본값), -1은 뒤에서부터 찾기

SELECT INSTR('JAVASCRIPTJAVASCRIPT', 'A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVASCRIPT', 'A', 1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVASCRIPT', 'A', 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVASCRIPT', 'A', -1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVASCRIPT', 'A', -8) FROM DUAL;

SELECT INSTR('JAVASCRIPTJAVASCRIPT', 'A', 1, 3) FROM DUAL; -- 앞에서부터 3번째에 있는 'A'의 인덱스 번호
SELECT INSTR('JAVASCRIPTJAVASCRIPT', 'A', -1, 3) FROM DUAL; -- 뒤에서부터 3번째에 있는 'A'의 인덱스 번호

SELECT EMAIL, INSTR(EMAIL, '_') "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

-- SUBSTR: 문자열에서 특정 문자열을 추출하여 반환(CHARACTER)
-- SUBSTR('문자열', POSITION,[LENGTH])
--      - POSITION: 문자열을 추출할 시작위치 INDEX
--      - LENGTH: 추출할 문자의 갯수(생략시 맨 마지막까지 추출)

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -3) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;

SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) GENDER
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 주민번호에서 성별만 추출하여 여성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) GENDER
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- EMPLOYEE 테이블에서 주민번호에서 성별만 추출하여 남성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) GENDER
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- EMPLOYEE 테이블에서 EMAIL에서 아이디만 추출해서 사원명, 이메일, 아이디를 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) ID
FROM EMPLOYEE;

-- LPAD/RPAD : 문자열을 조회할 때 통일감 있게 자리수에 맞춰서 조회하고자 할 때(반환형: CHARACTER)
-- LPAD/RPAD('문자열',최종적으로 반활할 문자의 길이, [덧붙이고자 하는 문자])
-- 문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 n길이 만큼의 문자열 반환

SELECT EMP_NAME, LPAD(EMAIL, 25)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 25, '-')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 25, '+')
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 주민번호 형식 사번, 사원명, 주민번호(형식에 맞춰) 조회
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') EMP_NO
FROM EMPLOYEE;

-- LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 나머지를 반환(반환형: CHARACTER)
-- TRIM: 문자열의 앞/뒤쪽에 있는 특정 문자를 제거한 다음 나며지 반환

-- LRTIM/RTRIM[제거하고자하는 문자])
-- TRIM[LEADING]TRAINING[BOTH] 제거하고나 하는 문자들 FROM 재거하고나 하는 문자 1개만 가능

SELECT LTRIM('     TRAVELL     ')||'김제현' FROM DUAL;
SELECT RTRIM('     TRAVELL     ')||'김제현' FROM DUAL;

SELECT LTRIM('JAVAJAVASCRIPTJAVA', 'JAVA') FROM DUAL;

SELECT LTRIM('BCABACABCVCASE', 'ABC') FROM DUAL;

SELECT LTRIM('124125412DFSA1242', '0123456789') FROM DUAL;

SELECT RTRIM('124125412DFSA1242', '0123456789') FROM DUAL;

SELECT TRIM('     1FSD     ') FROM DUAL;
SELECT TRIM('A' FROM 'AAAVEGAAA') FROM DUAL;
-- 오류 SELECT TRIM('ABC' FROM 'AAAVEGAAA') FROM DUAL;

SELECT TRIM(LEADING 'A' FROM 'AAAABDSGAAAA') FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAAABDSGAAAA') FROM DUAL;
SELECT TRIM(BOTH 'A' FROM 'AAAABDSGAAAA') FROM DUAL; -- BOTH 생략 가능

-- LOWER : 문자열을 모두 소문자로
-- UPPER : 문자열을 모두 대문자로
-- INITCAP : 문자열 첫글자를 모두 대문자로
-- LOWER/UPPER/INICAP('문자열')

SELECT LOWER('dnkSDFewa fASDFndklAS DNFK') FROM DUAL;
SELECT UPPER('dnkSDFewa fASDFndklAS DNFK') FROM DUAL;
SELECT INITCAP('dnkSDFewa fASDFndklAS DNFK') FROM DUAL;

-- CONCAT : 문자열 2개를 전달받아 1개로 합쳐서 문자로 반환
-- CONCAT('문자열', '문자열')

SELECT CONCAT('ORACLE', '오라클') FROM DUAL; -- CONCAT은 2개의 문자열만 가능
SELECT 'ORACLE' || '오라클' FROM DUAL; -- ||은 개수 제한 없음

-- REPLACE : 기존문자열을 새로운 문자열로 바꿈
-- REPLACE('문자열', '기존문자열', '새로운 문자열')

SELECT EMAIL, REPLACE(EMAIL, SUBSTR(EMAIL, INSTR(EMAIL, '@')+1), 'naver.com') "NEW EMAIL" FROM EMPLOYEE;

-- 숫자 처리 함수
-- ABS : 숫자의 절대값을 구해주는 함수
-- ABS(숫자)
SELECT ABS(-10) FROM DUAL;
SELECT ABS(10.12312) FROM DUAL;
SELECT ABS(-10.232) FROM DUAL;

-- MOD : 두 수를 나눈 나머지값을 반환해주는 함수
-- MOD(숫자, 숫자)
SELECT MOD(10, 2) FROM DUAL;
SELECT MOD(10, 3) FROM DUAL;

-- ROUND : 반올림한 결과를 반환해주는 함수
-- ROUND(숫자[, 위치])
SELECT ROUND(2412.6412) FROM DUAL; -- 위치는 0 소수점 첫번째 자리에서 반올림
SELECT ROUND(2412.6412, 1) FROM DUAL; -- 위치는 1 소수점 두번째자리에서 반올림
SELECT ROUND(2412.6412, 2) FROM DUAL; -- 위치는 2 소수점 세번째자리에서 반올림
SELECT ROUND(2412.6412, 7) FROM DUAL;
SELECT ROUND(2412.6412, -3) FROM DUAL; -- 정수자리 3번째 자리에서 반올림
SELECT ROUND(2412.6412, -2) FROM DUAL; -- 정수자리 2번째 자리에서 반올림

-- CEIL : 무조건 올림
-- CEIL(숫자)
SELECT CEIL(234) FROM DUAL;
SELECT CEIL(234.11) FROM DUAL;
SELECT CEIL(234.66) FROM DUAL;
SELECT CEIL(-234.11) FROM DUAL; 
SELECT CEIL(-234.66) FROM DUAL;

-- FLOOR : 무조건 내림
-- FLOOR(숫자)
SELECT FLOOR(234) FROM DUAL;
SELECT FLOOR(234.11) FROM DUAL;
SELECT FLOOR(234.66) FROM DUAL;
SELECT FLOOR(-234.11) FROM DUAL; 
SELECT FLOOR(-234.66) FROM DUAL;

-- TRUNC : 위치 지정 가능한 버림처리 함수
-- TRUNC(숫자[, 위치])
SELECT TRUNC(12345.789) FROM DUAL; 
SELECT TRUNC(12345.789, 1) FROM DUAL; -- 소수점 첫째자리 다음부터 버림
SELECT TRUNC(12345.789, 2) FROM DUAL; -- 소수점 둘째자리 다음부터 버림
SELECT TRUNC(12345.789, -1) FROM DUAL; -- 정수 첫째자리부터 버림
SELECT TRUNC(12345.789, -2) FROM DUAL; -- 정수 둘째자리부터 버림

-- 날짜 처리 함수
-- SYSDATE : 시스템 날짜 및 시간 반환
SELECT SYSDATE FROM DUAL;

-- MONTHS_BETWEEN(날짜1, 날짜2) : 두 날짜 사이의 개월 수 반환
SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE)||'일차' "근무일수", CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'개월차' 근무개월
FROM EMPLOYEE
WHERE END_DATE IS NULL;

-- ADD_MONTHS(날짜, 숫자) : 특정 날짜에 해당 숫자만큼의 개월수를 더해 그 날짜를 반환
SELECT ADD_MONTHS(SYSDATE, 2) FROM DUAL;

SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원 전환일"
FROM EMPLOYEE;

-- NEXT_DAY(날짜, 요일(문자|숫자)) : 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환해주는 함수
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 1) FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 3) FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 오류 : 현재 언어가 KOREA이기 때문
ALTER SESSION SET NLS_LANGUAGE = AMERICAN; -- 언어를 변경하면 위 실행문이 실행됨

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- LAST_DAY(날짜) : 해당 월의 마지막 날짜를 반환해주는 함수
SELECT LAST_DAY(ADD_MONTHS(SYSDATE,2)) FROM DUAL;

SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

-- EXTRACT : 특정 날짜로부터 년, 월, 일의 값을 추출하여 반환해주는 함수(숫자 반환)
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE) 입사년, EXTRACT(MONTH FROM HIRE_DATE) 입사월, EXTRACT(DAY FROM HIRE_DATE) 입사일 
FROM EMPLOYEE
ORDER BY 입사년, 입사월, 입사일;

-- 형변환
-- TO_CHAR : 숫자나 날짜를 문자 타입으로 변환시켜주는 함수
-- TO_CHAR(숫자,날짜,포맷)

-- 숫자를 문자로 변환
-- 9 : 해당 자리의 숫자를 의미한다.
--      - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
-- 0 : 해당 자리의 숫자를 의미한다.
--      - 값이 없을 경우 0으로 표시하며, 숫자의 길이를 고정적으로 표시할 때 주로 사용
-- FM : 해당자리에 값이 없을 경우 자리차지하지 않음
SELECT 10 숫자 FROM DUAL;
SELECT TO_CHAR(10) 문자 FROM DUAL;

SELECT TO_CHAR(1234, '999999') FROM DUAL; -- 6칸 공간 확보, 왼쪽 정렬 빈칸은 공백
SELECT TO_CHAR(123456, '999999') FROM DUAL; -- 6칸 공간 확보, 왼쪽 정렬 빈칸은 공백
SELECT TO_CHAR(1234, '000000') FROM DUAL; -- 6칸 공간 확보, 왼쪽 정렬 빈칸은 0
SELECT TO_CHAR(123456, '000000') FROM DUAL; -- 6칸 공간 확보, 왼쪽 정렬 빈칸은 0

SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- 현재 설정된 나라(LOCAL)의 화폐단위(빈칸 공백) : 오른쪽 정렬
SELECT TO_CHAR(123456, '9,999,999L') FROM DUAL; -- 3자리마다 쉼표(,)를 넣음

SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999') 월급, TO_CHAR(SALARY*12, 'L999,999,999') 연봉
FROM EMPLOYEE;

SELECT TO_CHAR(123.456, 'FM999990.999'), TO_CHAR(1234.56, 'FM9990.99'), TO_CHAR(0.1000, 'FM9999.999'), TO_CHAR(0.1000, 'FM9990.99') FROM DUAL;

SELECT TO_CHAR(123.456, '999990.999'), TO_CHAR(1234.56, '9990.99'), TO_CHAR(0.1000, '9999.999'), TO_CHAR(0.1000, '9990.99') FROM DUAL;

-- 날짜를 문자로 변환
-- 시간
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL; -- 12시간제 형식
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL; -- 24시간제 형식

-- 날짜
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

SELECT TO_CHAR(HIRE_DATE, 'YY"-"MM"-"DD') FROM EMPLOYEE;
SELECT TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" DAY') FROM EMPLOYEE;
SELECT TO_CHAR(HIRE_DATE, 'YY"년" MM"월" DD"일"') FROM EMPLOYEE;

-- 년
-- YY는 무조건 앞에 '20'이 붙는다.
-- rr는 50년을 기준으로 50보다 작으면 앞에 '20'을 붙이고, 50보다 크면 '19를 붙인다.
SELECT TO_CHAR(SYSDATE, 'YYYY'), TO_CHAR(SYSDATE, 'YY'), TO_CHAR(SYSDATE, 'RRRR'), TO_CHAR(SYSDATE, 'RR') FROM DUAL;

-- 월
SELECT TO_CHAR(SYSDATE, 'MM'), TO_CHAR(SYSDATE,'MON'), TO_CHAR(SYSDATE, 'MONTH'), TO_CHAR(SYSDATE, 'RM') FROM DUAL; -- LOCAL이 영어권일때 MONTH와 MON은 조금 다름

-- 일
SELECT TO_CHAR(SYSDATE, 'DDD'), TO_CHAR(SYSDATE,'DD'), TO_CHAR(SYSDATE, 'D') FROM DUAL; -- DDD : 년을 기준으로 몇일째 DD : 월을 기준으로 몇일쨰 D : 주를 기준으로 몇일쨰

-- 요일
SELECT TO_CHAR(SYSDATE, 'DAY'), TO_CHAR(SYSDATE, 'DY') FROM DUAL;

-- TO_DATE : 숫자 또는 문자를 날짜 타입으로 변환
-- TO DATE(숫자|문자[, 포맷])
SELECT TO_DATE(20241230) FROM DUAL;
SELECT TO_DATE(241230) FROM DUAL;

SELECT TO_DATE(050101) FROM DUAL; -- 앞이 0일때 오류
SELECT TO_DATE('050101') FROM DUAL; -- 앞이 0일때는 문자 형태로 넣어줘야 한다.

SELECT TO_DATE('070204 142530', 'YYMMDD HHMISS') FROM DUAL; -- 오류 12시간제로 출력 14시는 없음
SELECT TO_DATE('070204 142530', 'YYMMDD HH24MISS') FROM DUAL; -- 오류 14시를 변환 해야됨

SELECT TO_CHAR(TO_DATE('070204 142530', 'YYMMDD HH24MISS'), 'YY-MM-DD HH24:MI:SS') FROM DUAL;

-- 년도를 2자리 수만 넣을때
SELECT TO_DATE('040325', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980603', 'YYMMDD') FROM DUAL; -- YY는 현재 세기 즉, 앞에 20을 붙임
SELECT TO_DATE('040325', 'RRMMDD') FROM DUAL;
SELECT TO_DATE('980603', 'RRMMDD') FROM DUAL; -- RR은 50년을 기준으로 50이상이면 이전 세기 '19'를 붙이고 50미만이면 현제 세기'20'을 붙임
-- 만약 1926년 부터 1950년을 입력할 때는 4자리 수만 넣어야됨

-- TO_NUMBER : 문자타입을 숫자타입으로 변환
-- TO_NUMBER(문자[, 포맷])
SELECT TO_NUMBER('012341234') FROM DUAL;
SELECT '1000'+'5000' FROM DUAL; -- 문자가 자동으로 숫자로 형변환되어서 계산됨
SELECT '10,00'+'50,00' FROM DUAL; -- 문자 쉼표(,)가 있어서 자동 형변환이 안되어서 오류가남
SELECT TO_NUMBER('10,00','99,99')+TO_NUMBER('50,00', '99,99') FROM DUAL; -- 쉼표(,)를 넣는 형식을 지정했기 때문에 연산이 됨

-- NULL 처리 함수
-- NVL(컬럼, 해당컬럼이 NULL일 경우 반환할 값)
SELECT EMP_NAME, BONUS, NVL(BONUS, 0) FROM EMPLOYEE;

SELECT EMP_NAME, SALARY*(1+NVL(BONUS, 0))*12 "보너스포함연봉" FROM EMPLOYEE ORDER BY 보너스포함연봉 DESC;

SELECT EMP_NAME 이름, NVL(DEPT_CODE, '부서없음') 부서현황 FROM EMPLOYEE ORDER BY 부서현황;

-- NVL2(컬럼, 반환값1, 반환값2)
--      - 반환값1 : 컬럼값이 존재하면 반환값1이 반환
--      - 반환값2 : 컬럼값이 존재하지 않으면 반환값2가 반환
SELECT EMP_NAME 이름, NVL2(DEPT_CODE, 'Y', 'N') 부서현황 FROM EMPLOYEE ORDER BY 부서현황;

SELECT EMP_NAME 이름, SALARY 월급, NVL(BONUS, 0) 보너스, NVL2(BONUS, SALARY*0.5, SALARY*0.1) 성과급 FROM EMPLOYEE ORDER BY 월급;

-- NULLIF(비교대상1, 비교대상2)
--      - 두개의 값이 일치하면 NULL 반환
--      - 두개의 값이 일치하지 않으면 비교대상 1의 값 반환
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '345') FROM DUAL;

-- 선택함수
-- DECODE 비교하고자하는 대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2 ..)
SELECT EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', '2', '여자', '3', '남자', '4', '여자') GENDER FROM EMPLOYEE;

SELECT EMP_NAME, JOB_CODE, SALARY, DECODE(JOB_CODE, 'J7', SALARY*1.1, 'J6', SALARY*1.15, 'J5', SALARY*1.2, SALARY*1.05) "인상된 급여" FROM EMPLOYEE; 

-- CASE WHEN THEN END
-- CASE WHEN 조건식1 THEN 결과값1 WHEN 조건식2 THEN 결과값2 ... ELSE 결과값 END
SELECT EMP_NAME, SALARY, LPAD(CASE WHEN SALARY >= 5000000 THEN '고급' WHEN SALARY >= 3000000 THEN '중급' ELSE '초급' END, 8) 연봉등급
FROM EMPLOYEE;

-- 그룹 함수
-- SUM(숫자 타입 컬럼) : 해당 컬럼 값들의 총 합계를 반환해주는 함수
SELECT SUM(SALARY) "직원 급여 합계" FROM EMPLOYEE;
SELECT SUM(SALARY) "남자직원 급여 합계" FROM EMPLOYEE WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');
SELECT SUM(SALARY*12) "D5 직원 연봉 합계" FROM EMPLOYEE WHERE DEPT_CODE = 'D5';
SELECT TO_CHAR(SUM(SALARY*(1+NVL(BONUS, 0))*12), 'L999,999,999,999') "보너스 포함 연봉 합계" FROM EMPLOYEE;

-- AVG(숫자 타입 컬럼) : 해당 컬럼 값들의 평균을 반환해 주는 함수
SELECT ROUND(AVG(SALARY), 2) "직원 급여 평균" FROM EMPLOYEE;

-- MIN(모든 타입 컬럼) : 해당 컬럼 값들 중 가장 작은 값을 반환해 주는 함수
-- MAX(모든 타입 컬럼) : 해당 컬럼 값들 중 가장 큰 값을 반환해 주는 함수
SELECT MIN(SALARY), MAX(SALARY), LPAD(MIN(EMP_NAME), 10), LPAD(MAX(EMP_NAME), 10) FROM EMPLOYEE;

-- COUNT(*|컬럼|DISTINCT 컬럼) : 행 개수를 반환
-- COUNT(*) : 조회한 결과의 모든 행의 개수를 반환
-- COUNT(컬럼) : 컬럼의 NULL값을 제외한 행의 개수 반환
-- COUNT(DISTINCT 컬럼) : 컬럼값에서 중복을 제거한 행의 개수 반환

SELECT COUNT(*) FROM EMPLOYEE;
SELECT COUNT(EMP_NAME) FROM EMPLOYEE;
SELECT COUNT(DISTINCT DEPT_CODE) FROM EMPLOYEE;
SELECT COUNT(*) FROM EMPLOYEE WHERE SUBSTR(EMP_NO, 8, 1) = '2';
SELECT COUNT(BONUS) FROM EMPLOYEE;



------------------------------- 종합 문제 ----------------------------------
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 6))) 생년, EXTRACT(MONTH FROM TO_DATE(SUBSTR(EMP_NO, 1, 6))) 생월, EXTRACT(DAY FROM TO_DATE(SUBSTR(EMP_NO, 1, 6))) 생일 FROM EMPLOYEE;

-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME, REPLACE(EMP_NO, SUBSTR(EMP_NO, 9),'******') 주민번호 FROM EMPLOYEE;
SELECT EMP_NAME, SUBSTR(EMP_NO, 1,7) || '*******' 주민번호 FROM EMPLOYEE;
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1,7), 14, '*') 주민번호 FROM EMPLOYEE;

-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME, ABS(FLOOR(HIRE_DATE-SYSDATE)) 근무일수1, FLOOR(SYSDATE-HIRE_DATE) 근무일수2 FROM EMPLOYEE;

-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT * FROM EMPLOYEE WHERE MOD(EMP_ID, 2) != 0;

-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT * FROM EMPLOYEE WHERE END_DATE IS NULL AND MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 20*12 ORDER BY HIRE_DATE;

-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME 이름, TO_CHAR(SALARY, 'L999,999,999') 급여 FROM EMPLOYEE;

-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT EMP_NAME 이름, DEPT_CODE 부서코드, TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6)), 'YY"년" MM"월" DD"일"') 생년월일, EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 6))) 나이
FROM EMPLOYEE;

-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부
--   , D6면 기획부, D9면 영업부로 처리(EMP_ID, EMP_NAME, DEPT_CODE, 총무부)
--    (단, 부서코드 오름차순으로 정렬)
SELECT EMP_ID, EMP_NAME, DECODE(DEPT_CODE, 'D5', '총무부', 'D6', '기획부', 'D9', '영업부') 부서  
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY 부서;

-- 9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--    주민번호 앞자리와 뒷자리의 합 조회
SELECT SUBSTR(EMP_NO, 1, 6) "주민번호 앞자리", SUBSTR(EMP_NO, 8) "주민번호 뒷자리", TO_NUMBER(SUBSTR(EMP_NO, 1, 6))-TO_NUMBER(SUBSTR(EMP_NO, 8)) 합
FROM EMPLOYEE
WHERE EMP_ID = 201;

-- 10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 조회
SELECT SUM(SALARY*(1+NVL(BONUS, 0))*12) "보너스 포함 연봉의 합"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      전체 직원 수, 2001년, 2002년, 2003년, 2004년
SELECT COUNT(*)
, COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2001' THEN 1 END) "2001년 직원수"
, COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2002' THEN 1 END) "2002년 직원수"
, COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2003' THEN 1 END) "2003년 직원수"
, COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2004' THEN 1 END) "2004년 직원수"
FROM EMPLOYEE;















