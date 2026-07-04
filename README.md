# University Database Assignment

## Normalization
Partial dependencies:
- student_id -> student_name, department, advisor
- course_code -> course_name, instructor

Transitive dependencies:
- advisor_name -> advisor_email
- instructor_name -> instructor_email

BCNF tables:
Advisors(advisor_id PK,...)
Instructors(instructor_id PK,...)
Students(student_id PK, advisor_id FK)
Courses(course_code PK, instructor_id FK)
Enrollments(student_id FK, course_code FK, enrollment_year, marks_obtained)

Integrity:
- Entity: satisfied.
- Referential: satisfied through foreign keys.
- Domain: satisfied through data types and CHECK.
- User-defined: marks constrained 0-100.

Design:
INT for IDs, VARCHAR for text, DECIMAL for marks, composite PK in Enrollments.

Transactions:
Non-repeatable read -> REPEATABLE READ.
Write skew -> SERIALIZABLE.
MVCC returns the original snapshot to the reporting transaction; REPEATABLE READ guarantees a consistent snapshot with the trade-off of additional version storage and lower concurrency.
