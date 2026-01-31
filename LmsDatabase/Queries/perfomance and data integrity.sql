-- Section 3: Performance and Optimization
-- Suggest appropriate indexes for improving performance of:
-- Course dashboards
-- User activity analytics
/* The most use table is enrollments,courses,assessmentsubmisson,assessment
   so we create index on that tables to searching purpose it will be fast,
   first we crate a index on enrollments table */
CREATE INDEX idx_enrollments
ON lms.Enrollments(course_id);

-- here we creating a index on lessons table
CREATE INDEX idx_lessons_course
ON lms.lessons(course_id);

-- here we creating a index on assessments table
CREATE INDEX idx_assessments_course
ON lms.Assessments(course_id);

-- In the analytics we use most repeated table that is useractivity table
--create a index on useractivity table
CREATE INDEX idx_activity_course
ON lms.UserActivity(course_id);
-- And also create a index on assessmentsubmission
CREATE INDEX idx_submission_user
ON lms.AssessmentSubmissions(user_id);


-- Identify potential performance bottlenecks in queries involving user activity.
/* basically what is happen in real time useractivity table become very large because of students login 
   and watching the lessons and submitting the tests.
   performance bottlenecks means - places where query become slow
   so the question is what are the things can make queries on user activity data slow?
   - for this create indexs on table
   - and only select require data */
CREATE INDEX idx_useractivity_user
ON lms.UserActivity(user_id);
-- index on an activity time
CREATE INDEX idx_useractivity_time
ON lms.UserActivity(activity_time);

-- Explain how you would optimize queries when the user_activity table grows to millions of rows.
/* database has to read too much data and conting and grouping takes time
   so help the database read less data and find rows faster.
   the solution is creating indexes and select the wanted data and use summary aggregated fucntions
    and we use the stored procedures, before queries already we create indexs on useractivity table. */

-- Describe scenarios where materialized views would be useful for this schema.
/* what is happen in the normal view the query is saved but data is not stored in
   materialized view the data is also stored ,so instead of calculating again and again , the database reads the data very fast
   first when we use the materialized views
   -same heavy query run again and again
   -and the data does not change in every second
   the scenarios happen when we need to calculate total in the dashboard like total lessons,total students
   in the daily user activity also to calculate the daily activity users and activity count
   --first create a  view and then Create UNIQUE CLUSTERED INDEX (This Materializes It) 
    schema binding - it locks the structure of tables used in the view.
    you cannot drop the table,you cannot change column types
    count_big returns very large number type -BIGINT */

/*CREATE VIEW lms.vw_DailyUserActivity
WITH SCHEMABINDING
AS
SELECT
    ua.user_id,
    CAST(ua.activity_time AS DATE) AS activity_date,
    COUNT_BIG(*) AS activity_count
FROM lms.UserActivity ua
GROUP BY
    ua.user_id,
    CAST(ua.activity_time AS DATE); */

-- Create UNIQUE CLUSTERED INDEX
-- now this view is materialized -stored on disk.
CREATE UNIQUE CLUSTERED INDEX idx_vw_DailyUserActivity
ON lms.vw_DailyUserActivity(user_id, activity_date);

-- Explain how partitioning could be applied to user_activity.
/* partitioning means-splitting one big table into smaller parts based on a column (usually date).
   imagine that 10 millions rows in the table,by searching it is difficult so we need partiton the table
   by the month wise
   it is useful fast for searching operations based on the data not all the from start to end
   -How Partitioning Is Applied
    1.Partition Function → defines ranges
    2.Partition Scheme → maps ranges to storage
    3.Table on Partition Scheme */
-- create partition function
CREATE PARTITION FUNCTION pf_UserActivity_Date (DATE)
AS RANGE RIGHT FOR VALUES
(
    '2025-02-01',
    '2025-03-01',
    '2025-04-01'
);
-- Create Partition Scheme
CREATE PARTITION SCHEME ps_UserActivity_Date
AS PARTITION pf_UserActivity_Date
ALL TO ([PRIMARY]);
-- Create Table on Partition Scheme
-- We split the user activity table by date so that queries read only required months instead of the whole table.
CREATE TABLE lms.UserActivity (
    activity_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    activity_time DATE
)
ON ps_UserActivity_Date(activity_time);


-- Section 4: Data Integrity and Constraints
-- Propose constraints to ensure a user cannot submit the same assessment more than once.
-- adding a constraint , two rows have same user_id and assessment_id together.
ALTER TABLE AssessmentSubmissions
ADD CONSTRAINT uq_user_assessment
UNIQUE (user_id,assessment_id)

-- Ensure that assessment scores do not exceed the defined maximum score.
-- creating a trigger because every assessment total marks is diffenernt, we cannot ensure with constraint
-- inserted -it is a special temporary table created automatically by SQL Server inside triggers.
CREATE TRIGGER TRG_CheckScoreLimit
ON lms.AssessmentSubmissions
AFTER INSERT, UPDATE
AS
BEGIN
    -- If any inserted/updated row has score greater than total_marks,block it.
    -- select 1 means it does not care about the actual data,it checks only the any row exists or not
    -- raise error(message,severity,state)severity means how serious this error,state means number - identify where error came from
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN lms.Assessments a
            ON i.assessment_id = a.assessment_id
        WHERE i.score > a.total_marks
    )
    BEGIN
        RAISERROR ('Score cannot be greater than total marks of the assessment.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- Prevent users from enrolling in courses that have no lessons.
-- create a trigger because we need to check two tables and where the course have the no lessons
CREATE TRIGGER TRG_CheckCourseHasLessons
ON lms.Enrollments
AFTER INSERT
AS
BEGIN
    -- If inserted course has no lessons, block enrollment
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN lms.Lessons l
            ON i.course_id = l.course_id
        WHERE l.course_id IS NULL
    )
    BEGIN
        RAISERROR ('Cannot enroll in a course that has no lessons.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- Ensure that only instructors can create courses.
ALTER TABLE lms.Users
ADD CONSTRAINT CK_User_Role
CHECK (role IN ('Student', 'Instructor', 'Admin'));


-- Describe a safe strategy for deleting courses while preserving historical data.
/* use the soft delete,instead of deleting the row, mark it as inactive.
   adding a is_active column to the courses table and setting bit default 1 is active,0 means inactive. */
ALTER TABLE lms.Courses
ADD is_active BIT DEFAULT 1;
-- deleting the course by updating the is_active and set to the 0
UPDATE lms.Courses
SET is_active = 0
WHERE course_id = 101;
-- Show only active courses in queries
SELECT *
FROM lms.Courses
WHERE is_active = 1;
