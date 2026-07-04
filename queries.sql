-- Task 1.3 Inserts
INSERT INTO Advisors VALUES
(1,'Dr. Sharma','sharma@uni.edu'),
(2,'Dr. Mehta','mehta@uni.edu');

INSERT INTO Instructors VALUES
(101,'Prof. Rao','rao@uni.edu'),
(102,'Prof. Gupta','gupta@uni.edu');

INSERT INTO Students VALUES
(1,'Rahul','CSE',1),
(2,'Anjali','ECE',2),
(3,'Vikas','CSE',1);

INSERT INTO Courses VALUES
('CS101','Database Systems',101),
('CS202','Operating Systems',102),
('CS404','Advanced DBMS',101);

INSERT INTO Enrollments VALUES
(1,'CS101',2024,85),
(2,'CS101',2024,65),
(3,'CS202',2025,30);

UPDATE Instructors SET instructor_email='newrao@uni.edu' WHERE instructor_id=101;

DELETE FROM Enrollments WHERE marks_obtained<35;

/* DELETE is transactional and portable. TRUNCATE differs by DBMS. */
DELETE FROM StudentRecords;

SELECT s.student_name,c.course_name
FROM Students s JOIN Enrollments e ON s.student_id=e.student_id
JOIN Courses c ON e.course_code=c.course_code
WHERE e.course_code IN ('CS101','CS202','CS303');

SELECT s.student_name,e.marks_obtained
FROM Students s JOIN Advisors a ON s.advisor_id=a.advisor_id
JOIN Enrollments e ON s.student_id=e.student_id
WHERE e.marks_obtained BETWEEN 60 AND 85 AND a.advisor_email IS NOT NULL;

SELECT department,AVG(marks_obtained) avg_marks,MIN(marks_obtained) min_marks,MAX(marks_obtained) max_marks
FROM Students s JOIN Enrollments e ON s.student_id=e.student_id
GROUP BY department HAVING AVG(marks_obtained)>55;

SELECT s.student_name,c.course_name,e.marks_obtained
FROM Students s INNER JOIN Enrollments e ON s.student_id=e.student_id
INNER JOIN Courses c ON e.course_code=c.course_code;

SELECT s.student_name,c.course_name,e.marks_obtained
FROM Students s LEFT JOIN Enrollments e ON s.student_id=e.student_id
LEFT JOIN Courses c ON e.course_code=c.course_code;

SELECT s.student_name,e.marks_obtained
FROM Students s JOIN Enrollments e ON s.student_id=e.student_id
WHERE e.marks_obtained>(
SELECT AVG(e2.marks_obtained)
FROM Students s2 JOIN Enrollments e2 ON s2.student_id=e2.student_id
WHERE s2.department=s.department);

SELECT student_id FROM Enrollments WHERE enrollment_year=2024
EXCEPT
SELECT student_id FROM Enrollments WHERE enrollment_year=2025;

SELECT s.student_name,s.department,e.marks_obtained
FROM Students s JOIN Enrollments e ON s.student_id=e.student_id
WHERE 1=(SELECT COUNT(DISTINCT e2.marks_obtained)
FROM Students s2 JOIN Enrollments e2 ON s2.student_id=e2.student_id
WHERE s2.department=s.department AND e2.marks_obtained>e.marks_obtained);

SELECT student_name,department,marks_obtained,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY marks_obtained DESC) row_number,
RANK() OVER(PARTITION BY department ORDER BY marks_obtained DESC) rank_value,
DENSE_RANK() OVER(PARTITION BY department ORDER BY marks_obtained DESC) dense_rank_value
FROM Students s JOIN Enrollments e ON s.student_id=e.student_id;

BEGIN;
DELETE FROM Enrollments WHERE student_id=1 AND course_code='CS101';
INSERT INTO Enrollments VALUES(1,'CS404',2026,0);
COMMIT;
-- If INSERT fails: ROLLBACK;

-- 1.5b Non-repeatable Read. Prevent: REPEATABLE READ.
-- 1.5c Write Skew. Prevent: SERIALIZABLE.
-- 1.5d MVCC: reporting transaction rereads original snapshot value under REPEATABLE READ; trade-off: higher storage/version overhead and reduced concurrency.
