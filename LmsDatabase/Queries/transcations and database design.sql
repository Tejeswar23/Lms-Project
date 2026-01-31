-- Section 5: Transactions and Concurrency
-- Design a transaction flow for enrolling a user into a course.
DECLARE @user_id INT = 5;
DECLARE @course_id INT = 3;
DECLARE @enrollment_id INT = 101;

BEGIN TRY
    BEGIN TRANSACTION;
    --checking user exists
    IF NOT EXISTS (
        SELECT 1
        FROM lms.Users
        WHERE user_id = @user_id
    )
    BEGIN
        RAISERROR('User does not exist', 16, 1);
    END
    --check course exists
    IF NOT EXISTS (
        SELECT 1
        FROM lms.Courses
        WHERE course_id = @course_id
    )
    BEGIN
        RAISERROR('Course does not exist', 16, 1);
    END
    --check user already enrolled
    IF EXISTS (
        SELECT 1
        FROM lms.Enrollments
        WHERE user_id = @user_id
          AND course_id = @course_id
    )
    BEGIN
        RAISERROR('User already enrolled', 16, 1);
    END
    -- insert enrollment
    INSERT INTO lms.Enrollments
        (enrollment_id, user_id, course_id, current_status)
    VALUES
        (@enrollment_id, @user_id, @course_id, 'active');

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    RAISERROR('Enrollment failed', 16, 1);
END CATCH;

-- Explain how to handle concurrent assessment submissions safely.
/*  concurrent assessment submission - two or more users submitted assessment at the same time 
    If not handled properly,this can cause: Duplicate submissions ,Overwritten scores ,Inconsistent data */
DECLARE @assessment_id INT = 10;
DECLARE @submission_id INT = 7;
DEClARE @score INT = 80;
BEGIN TRY
BEGIN TRANSACTION
      IF EXISTS (
      SELECT 1
      FROM lms.AssessmentSubmissions
      WHERE user_id = @user_id 
      AND assessment_id = @assessment_id
      )
      BEGIN
           RAISERROR('Already submitted',16,1)
      END
      INSERT INTO lms.AssessmentSubmissions
        (submission_id, user_id, assessment_id, score)
    VALUES
        (@submission_id, @user_id, @assessment_id, @score);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    RAISERROR('Submission failed',16,1);
END CATCH;

-- Describe how partial failures should be handled during assessment submission.
/*A partial failure happens when-Some steps of assessment submission succeed ,But other steps fail
   */
SET @assessment_id INT = 11;
SET @submission_id INT = 23;
SET @user_id INT = 43;
SET @score INT = 24;
BEGIN TRY
BEGIN TRANSACTION
      IF EXISTS (
      SELECT 1 FROM 
      lms.AssessmentSubmissions
      WHERE user_id = @user_id
      AND assessment_id = @assessment_id
      )
      BEGIN
           RAISERROR('USER ALREADY SUBMITTED',16,1)
      END
      INSERT INTO LMS.AssessmentSubmissions
       (submission_id,user_id,assessment_id,score)
      VALUES
       (@submission_id, @user_id, @assessment_id, @score);
      COMMIT;
END TRY
BEGIN CATCH
      ROLLBACK
      RAISERROR('SUBMISSION FAILED',16,1);
END CATCH;

-- Recommend suitable transaction isolation levels for enrollments and submissions.
/* There are 4 types of transaction isolation levels - as levels of safety in the database.
   Dirty Read - Reading data that is not yet committed (saved).
   1.READ UNCOMMITTED - You can read data even before it is saved (committed).
   Example:Transaction A updates a score to 90 (but not saved yet)-Transaction B reads 90,-Transaction A fails and rolls back
   -Now B read wrong data.
   2.READ COMMITTED - You can read only saved (committed) data
   example :Transaction A updates score but not committed,-Transaction B cannot see it,-After commit B can see it
   3.REPEATABLE READ (More safety) - f you read a row once, it will not change during your transaction
   Example:You read score = 80,-Another transaction tries to update it,-You still see 80 until your transaction ends.
   4.SERIALIZABLE (Highest safety)-Transactions run one after another, not at the same time.
   Example:Only one user can submit at a time,-Others must wait
   -- for enrolling i use read commited because of it avoids reading uncommitted data, prevents dirty reads
   and allows multiple users to enroll safely at the same time without heavy locking.
   -- for submissions i use REPEATABLE READ because it ensures data consistency during the submission process
   prevents data from changing mid-transaction, and helps maintain accurate and reliable assessment results. */

-- Explain how phantom reads could affect analytics queries and how to prevent them.
/* A phantom read happens when:
   -- You run the same query twice in one transaction.
   -- The result set changes because new rows were inserted or deleted by another transaction
   Transaction A (Analytics Report):-Reads total enrollments - 50 students
   Transaction B (At the same time):-Inserts 5 new enrollments and commits
   Transaction A (Runs again):-Reads total enrollments - 55 students
    -same query, same transaction - different result
    -- How to Prevent Phantom Reads -- Use SERIALIZABLE Isolation Level.
    -- It locks the range of rows, so no new rows can be inserted during the transaction. */
-- Section 6: Database Design and Architecture
-- Propose schema changes to support course completion certificates.
/* Add Course Completion Table and Certificate Table */
CREATE TABLE lms.CourseCompletions (
    completion_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    completion_date DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_CC_User
        FOREIGN KEY (user_id) REFERENCES lms.Users(user_id),

    CONSTRAINT FK_CC_Course
        FOREIGN KEY (course_id) REFERENCES lms.Courses(course_id),

    CONSTRAINT UQ_User_Course_Completion
        UNIQUE (user_id, course_id)
);
CREATE TABLE lms.Certificates (
    certificate_id INT IDENTITY PRIMARY KEY,
    completion_id INT NOT NULL,
    certificate_number VARCHAR(50) UNIQUE NOT NULL,
    issued_date DATETIME DEFAULT GETDATE(),
    certificate_url VARCHAR(255),   -- PDF or image link
    is_valid BIT DEFAULT 1,

    CONSTRAINT FK_Cert_Completion
        FOREIGN KEY (completion_id)
        REFERENCES lms.CourseCompletions(completion_id)
);
-- Add Completion Criteria in Courses Table
ALTER TABLE lms.Courses
ADD min_pass_percentage INT DEFAULT 60,
    require_all_lessons BIT DEFAULT 1;
-- Describe how you would track video progress efficiently at scale.
/* Track how much of a video a user has watched,Support millions of users,Avoid too many database writes,Keep progress accurate and fast
   -- Don’t update the database every second.Instead, track progress in small chunks and save it smartly.
   1.Track Progress on the Client --Track:video_id,user_id,current_time,duration
   Example:User watches till 2:30 of a 10-minute video
   2.Send Progress in Intervals -- Instead of sending updates every second:Send updates:Every 10–30 seconds,On pause,On video end,On page exit
   3.Use an Event-Based Backend - don’t write directly to DB every time,Instead:API receives progress event,Push event into:Queue / stream
   4.Cache for Fast Resume - Fetch progress from cache,Resume instantly,Sync cache DB asynchronously */

-- Discuss normalization versus denormalization trade-offs for user activity data.
/* normalization - organizing data into multiple tables to avoid duplication.
   denormalization - combining data into fewer tables to improve read performance even if data repeats.
   the data is stored in seperate tables in users(user_id, name) ,courses(course_id, course_name),useractivity(activity_id, user_id, activity_time)
   the advatanges is No data duplication,smaller storage,easy to update master data
   disadvantages-many JOINs needed,slow for analytics queries,heavy load on DB when tables grow huge
   -assume that in useractivity table contains all columns UserActivity(activity_id,user_id,user_name,course_id,course_name,activity_time) */

-- Explain how this schema should evolve to support millions of users.
/* when users become very high,we should change the schema so reports don’t become slow.we can split big tables by date, keep daily or 
   monthly summary tables, and move reporting data to another database for dashboards. We can also use cache for repeated dashboard results and move 
   old data to archive so he main system works fast. */

