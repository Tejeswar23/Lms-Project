-- Created a Users table
CREATE TABLE lms.Users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL
)

-- Created a Courses table
CREATE TABLE lms.Courses (
     course_id INT PRIMARY KEY,
     course_name VARCHAR(50) NOT NULL,
     user_id INT NOT NULL,
     CONSTRAINT FK_COURSES_USERS
     FOREIGN KEY (user_id)
     REFERENCES lms.users(user_id)
)

-- Created a Lessons table
CREATE TABLE lms.lessons (
     lesson_id INT PRIMARY KEY,
     lesson_name VARCHAR(50) NOT NULL,
     course_id INT,
     duration INT NOT NULL,
     CONSTRAINT FK_LESSONS_COURSES
     FOREIGN KEY (course_id)
     REFERENCES lms.courses(course_id)
)
-- Created a Enrollments table
CREATE TABLE lms.Enrollments (
    enrollment_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    CONSTRAINT FK_Enroll_User
    FOREIGN KEY (user_id) REFERENCES lms.Users(user_id),
    CONSTRAINT FK_Enroll_Course
    FOREIGN KEY (course_id) REFERENCES lms.Courses(course_id)
);

-- Created a UserActivity table
CREATE TABLE lms.UserActivity (
    activity_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    activity_time DATETIME NOT NULL,
    CONSTRAINT FK_Activity_User
    FOREIGN KEY (user_id) REFERENCES lms.Users(user_id),
    CONSTRAINT FK_Activity_Lesson
    FOREIGN KEY (lesson_id) REFERENCES lms.Lessons(lesson_id)
);
-- Created a Assessments table
CREATE TABLE lms.Assessments (
    assessment_id INT PRIMARY KEY,
    assessment_name VARCHAR(150) NOT NULL,
    course_id INT NOT NULL,
    total_marks INT NOT NULL,
    CONSTRAINT FK_Assessment_Course
    FOREIGN KEY (course_id) REFERENCES lms.Courses(course_id)
);

-- Created a AssessmentsSubmissions table
CREATE TABLE lms.AssessmentSubmissions (
    submission_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    assessment_id INT NOT NULL,
    score INT NOT NULL,
    CONSTRAINT FK_Submission_User
    FOREIGN KEY (user_id) REFERENCES lms.Users(user_id),
    CONSTRAINT FK_Submission_Assessment
    FOREIGN KEY (assessment_id) REFERENCES lms.Assessments(assessment_id)
);


-- Inserting the data into users table
INSERT INTO lms.Users VALUES
(1,'Ravi','Kumar','ravi@gmail.com'),
(2,'Sita','Reddy','sita@gmail.com'),
(3,'Amit','Sharma','amit@gmail.com'),
(4,'Neha','Singh','neha@gmail.com'),
(5,'Rahul','Verma','rahul@gmail.com'),
(6,'Anjali','Patel','anjali@gmail.com'),
(7,'Kiran','Naik','kiran@gmail.com'),
(8,'Pooja','Mehta','pooja@gmail.com'),
(9,'Arjun','Das','arjun@gmail.com'),
(10,'Sneha','Joshi','sneha@gmail.com'),
(11,'Vijay','Rao','vijay@gmail.com'),
(12,'Divya','Nair','divya@gmail.com'),
(13,'Rohit','Kapoor','rohit@gmail.com'),
(14,'Priya','Gupta','priya@gmail.com'),
(15,'Manoj','Yadav','manoj@gmail.com'),
(16,'Kavya','Iyer','kavya@gmail.com'),
(17,'Suresh','Babu','suresh@gmail.com'),
(18,'Nikita','Malik','nikita@gmail.com'),
(19,'Harsha','Teja','harsha@gmail.com'),
(20,'Asha','Roy','asha@gmail.com'),
(21,'Naveen','Kumar','naveen@gmail.com'),
(22,'Isha','Chopra','isha@gmail.com'),
(23,'Tarun','Mishra','tarun@gmail.com'),
(24,'Meena','Shah','meena@gmail.com'),
(25,'Sunil','Patil','sunil@gmail.com'),
(26,'Ritika','Sen','ritika@gmail.com'),
(27,'Akash','Jain','akash@gmail.com'),
(28,'Swathi','Kulkarni','swathi@gmail.com'),
(29,'Varun','Arora','varun@gmail.com'),
(30,'Pallavi','Shetty','pallavi@gmail.com');

-- Inserting the data into courses table
INSERT INTO lms.Courses VALUES
(1,'SQL Basics',1),(2,'Advanced SQL',2),(3,'Python Fundamentals',3),(4,'Java Programming',4),(5,'Web Development',5),
(6,'Data Science Intro',6),(7,'Machine Learning',7),(8,'Cloud Computing',8),(9,'DevOps Basics',9),(10,'Power BI',10),
(11,'Excel Analytics',11),(12,'Cyber Security',12),(13,'AI Fundamentals',13),(14,'Spring Boot',14),(15,'React JS',15),
(16,'Node JS',16),(17,'Linux Admin',17),(18,'Networking',18),(19,'Big Data',19),(20,'AWS Cloud',20),(21,'Azure Cloud',21),
(22,'Testing Tools',22),(23,'Agile Methodology',23),(24,'UI UX Design',24),(25,'C Programming',25),(26,'C++ Programming',26),
(27,'DSA',27),(28,'Blockchain',28),(29,'IoT',29),(30,'Mobile App Dev',30);

-- Inserting the data into lessons table
INSERT INTO lms.Lessons VALUES
(1,'Intro SQL',1,30),(2,'Select Queries',1,45),(3,'Joins',2,50),(4,'Subqueries',2,40),(5,'Python Intro',3,35),
(6,'Loops',3,45),(7,'Java Basics',4,50),(8,'OOP Concepts',4,60),(9,'HTML Basics',5,30),(10,'CSS Styling',5,40),
(11,'Statistics',6,50),(12,'Pandas Intro',6,45),(13,'Regression',7,55),(14,'Classification',7,60),(15,'EC2 Setup',20,45),
(16,'S3 Storage',20,40),(17,'Git Basics',9,30),(18,'CI CD',9,50),(19,'Power BI Charts',10,40),(20,'DAX Basics',10,50),
(21,'Excel Formulas',11,35),(22,'Pivot Tables',11,45),(23,'Network Types',18,40),(24,'Protocols',18,45),(25,'Big Data Intro',19,50),
(26,'Hadoop',19,60),(27,'React Components',15,45),(28,'State Management',15,55),(29,'Linux Commands',17,35),(30,'Shell Scripts',17,50);

-- Inserting the data into Enrollments table
INSERT INTO lms.Enrollments VALUES
(1,1,1),(2,1,2),(3,2,1),(4,3,3),(5,4,4),
(6,5,5),(7,6,6),(8,7,7),(9,8,8),(10,9,9),
(11,10,10),(12,11,11),(13,12,12),(14,13,13),(15,14,14),
(16,15,15),(17,16,16),(18,17,17),(19,18,18),(20,19,19),
(21,20,20),(22,21,21),(23,22,22),(24,23,23),(25,24,24),
(26,25,25),(27,26,26),(28,27,27),(29,28,28),(30,29,29);

-- Inserting the data into UserActivity table
INSERT INTO lms.UserActivity VALUES
(1,1,1,'2025-01-01 09:10:00'),(2,1,2,'2025-01-02 10:20:00'),
(3,2,1,'2025-01-03 11:15:00'),(4,3,5,'2025-01-01 09:45:00'),
(5,4,7,'2025-01-02 14:10:00'),(6,5,9,'2025-01-03 16:00:00'),
(7,6,11,'2025-01-04 10:30:00'),(8,7,13,'2025-01-05 11:00:00'),
(9,8,15,'2025-01-06 15:20:00'),(10,9,17,'2025-01-07 09:50:00'),
(11,10,19,'2025-01-08 13:40:00'),(12,11,21,'2025-01-09 10:10:00'),
(13,12,23,'2025-01-10 11:25:00'),(14,13,25,'2025-01-11 14:30:00'),
(15,14,27,'2025-01-12 16:45:00'),(16,15,28,'2025-01-13 09:05:00'),
(17,16,29,'2025-01-14 10:55:00'),(18,17,30,'2025-01-15 15:10:00'),
(19,18,24,'2025-01-16 11:40:00'),(20,19,26,'2025-01-17 13:15:00'),
(21,20,16,'2025-01-18 09:35:00'),(22,21,22,'2025-01-19 14:00:00'),
(23,22,10,'2025-01-20 10:45:00'),(24,23,4,'2025-01-21 16:20:00'),
(25,24,6,'2025-01-22 11:10:00'),(26,25,8,'2025-01-23 15:55:00'),
(27,26,12,'2025-01-24 09:25:00'),(28,27,14,'2025-01-25 10:35:00'),
(29,28,18,'2025-01-26 14:50:00'),(30,29,20,'2025-01-27 16:05:00');


--Inserting the data into Assessments
INSERT INTO lms.Assessments VALUES
(1,'SQL Test',1,100),(2,'Join Test',2,100),(3,'Python Quiz',3,50),
(4,'Java Quiz',4,75),(5,'HTML Test',5,50),(6,'DS Intro Test',6,100),
(7,'ML Quiz',7,80),(8,'Cloud Quiz',8,70),(9,'DevOps Test',9,100),
(10,'BI Test',10,60),(11,'Excel Test',11,50),(12,'Security Quiz',12,70),
(13,'AI Test',13,100),(14,'Spring Quiz',14,80),(15,'React Test',15,90),
(16,'Node Quiz',16,70),(17,'Linux Test',17,60),(18,'Network Quiz',18,75),
(19,'Big Data Test',19,100),(20,'AWS Quiz',20,80),
(21,'Azure Test',21,90),(22,'Testing Quiz',22,60),(23,'Agile Quiz',23,50),
(24,'UX Test',24,70),(25,'C Test',25,60),(26,'CPP Quiz',26,75),
(27,'DSA Test',27,100),(28,'Blockchain Quiz',28,80),(29,'IoT Test',29,90),
(30,'Mobile App Quiz',30,70);

-- Inserting the data into AssessmentsSubmissions table
INSERT INTO lms.AssessmentSubmissions VALUES
(1,1,1,78),(2,2,2,45),(3,3,3,40),   
(4,4,4,65),(5,5,5,20),(6,6,6,88),
(7,7,7,60),(8,8,8,30),(9,9,9,75),
(10,10,10,35),(11,11,11,42),(12,12,12,55),
(13,13,13,90),(14,14,14,48),(15,15,15,70),
(16,16,16,25),(17,17,17,58),(18,18,18,66),
(19,19,19,92),(20,20,20,50),(21,21,21,85),
(22,22,22,40),(23,23,23,30),(24,24,24,72),
(25,25,25,55),(26,26,26,60),(27,27,27,95),
(28,28,28,45),(29,29,29,88),(30,30,30,52);


--Section 1: Intermediate SQL Queries
-- List all users who are enrolled in more than three courses.
/* the first_name column from users and using aggregate function to count the course_id of user enrolled
   and having condition to filter count > 3 */
SELECT u.first_name AS user_names,
       u.user_id,
       COUNT(e.course_id) AS user_count
       FROM lms.Users u 
       JOIN lms.Enrollments e
       ON u.user_id = e.user_id
       GROUP BY u.user_id,u.first_name
       HAVING count(e.course_id) > 1;

-- Find courses that currently have no enrollments.
/*use left join because i want all courses names and that time form right table we want course_id is null*/
SELECT c.course_name AS course_no_enrollments
       FROM lms.courses c
       LEFT JOIN lms.enrollments e
       ON c.course_id = e.course_id
       where e.course_id IS NULL;

-- Display each course along with the total number of enrolled users.
/* use left join because of i want all courses_names from the left table and group by c.course_name */
SELECT c.course_name,count(e.user_id) AS count_enrolled_users
       FROM lms.courses c
       LEFT JOIN lms.Enrollments e
       ON c.course_id = e.course_id
       GROUP BY c.course_name

-- Identify users who enrolled in a course but never accessed any lesson.
/* I use left join because if user did not accessed any lesson the right table course_id is must be null */
SELECT u.first_name AS user_names
       FROM lms.Courses c
       JOIN lms.Users u
       ON u.user_id = c.user_id
       LEFT JOIN lms.lessons s
       ON c.course_id = s.course_id
       WHERE s.course_id IS NULL;

-- Fetch lessons that have never been accessed by any user.
SELECT l.lesson_id,
       l.lesson_name
FROM lms.Lessons l
LEFT JOIN lms.UserActivity ua
    ON l.lesson_id = ua.lesson_id
WHERE ua.lesson_id IS NULL;

-- Show the last activity timestamp for each user.
/* with the group by function we group the data according to the user_id and find the last activity time with max function */
SELECT u.user_id,
       u.first_name,
       MAX(ua.activity_time) AS last_activity_time
FROM lms.Users u
JOIN lms.UserActivity ua
    ON u.user_id = ua.user_id
GROUP BY u.user_id, u.first_name;

-- List users who submitted an assessment but scored less than 50 percent of the maximum score.
/* assessments table contains total marks and assessments submissions table contains score,
    so we need to join two tables and also the user table */
SELECT u.user_id,
       u.first_name,
       u.last_name
FROM lms.AssessmentSubmissions s
JOIN lms.Assessments a
    ON s.assessment_id = a.assessment_id
JOIN lms.Users u
    ON s.user_id = u.user_id
WHERE s.score < (a.total_marks * 0.5);

--Find assessments that have not received any submissions.
/* used left join because of from right table where there is no match it will be null,and we find out */
SELECT a.assessment_id,a.assessment_name as No_Submission_Assessments
FROM lms.Assessments a
LEFT JOIN lms.AssessmentSubmissions sa
ON a.assessment_id = sa.assessment_id
where sa.assessment_id IS NULL;

-- Display the highest score achieved for each assessment.
/* with use of group by function and find the max_score with the max function and the join two tables */
SELECT a.assessment_name,max(sa.score) as max_score
from lms.Assessments a
JOIN lms.AssessmentSubmissions sa
ON  a.assessment_id = sa.assessment_id
GROUP BY a.assessment_name;

-- Identify users who are enrolled in a course but have an inactive enrollment status.
-- first adding a column to the table
ALTER TABLE lms.enrollments
ADD current_status varchar(30);
-- and changing the data into some records
UPDATE lms.Enrollments
SET current_status = 'Inactive'
where enrollment_id IN (3,7,12,18,25)
-- Remaining rows into Active 
UPDATE lms.Enrollments 
SET current_status = 'Active'
where current_status is null
-- query
SELECT u.user_id,
       u.first_name,
       u.last_name,
       e.course_id,
       e.current_status
FROM lms.Enrollments e
JOIN lms.Users u
    ON e.user_id = u.user_id
WHERE e.current_status = 'Inactive';

 -- Section :2 -Advanced SQL and Analytics
-- For each course, calculate:Total number of enrolled users,Total number of lessons,Average lesson duration
SELECT c.course_name,
       count(e.user_id) as enrolled_users,
       sum(l.lesson_id) as total_lessons,
       avg(l.duration) as avg_lesson_duration
FROM lms.Courses c
JOIN lms.lessons l
ON c.course_id = l.course_id
JOIN lms.Enrollments e
ON e.course_id = c.course_id
group by c.course_name

-- Identify the top three most active users based on total activity count.
/* use the top caluse to select top 3 and used order by to sort the data in decending order. */
SELECT TOP 3
    u.user_id,
    u.first_name,
    COUNT(ua.activity_id) AS total_activities
FROM lms.UserActivity ua
JOIN lms.Users u
    ON ua.user_id = u.user_id
GROUP BY u.user_id, u.first_name
ORDER BY total_activities DESC;

-- Calculate course completion percentage per user based on lesson activity.
/* first calculating the how many users are actively participated in lessons completition and
  then again calculate the lessons and divide by them */
SELECT e.user_id,
       u.first_name,
       e.course_id,
       c.course_name,
       COUNT(DISTINCT ua.lesson_id) * 100.0 / COUNT(DISTINCT l.lesson_id) AS completion_percentage
FROM lms.Enrollments e
JOIN lms.Users u
    ON e.user_id = u.user_id
JOIN lms.Courses c
    ON e.course_id = c.course_id
JOIN lms.Lessons l
    ON c.course_id = l.course_id
LEFT JOIN lms.UserActivity ua
    ON ua.lesson_id = l.lesson_id
   AND ua.user_id = e.user_id
GROUP BY
    e.user_id, u.first_name,e.course_id, c.course_name;

-- Find users whose average assessment score is higher than the course average.
/* using the sub query we calcualte cousrse avg and comapre with the avg assessment score */
SELECT u.user_id,
       u.first_name,
       a.course_id
FROM lms.AssessmentSubmissions s
JOIN lms.Assessments a ON s.assessment_id = a.assessment_id
JOIN lms.Users u ON s.user_id = u.user_id
GROUP BY u.user_id, u.first_name,a.course_id
HAVING AVG(s.score) >
       (
         SELECT AVG(s2.score)
         FROM lms.AssessmentSubmissions s2
         JOIN lms.Assessments a2 ON s2.assessment_id = a2.assessment_id
         WHERE a2.course_id = a.course_id
       );

-- Rank users within each course based on their total assessment score.
/* calculating the total score using sub query and with window function partition by course and using order by desc */
SELECT
    u.first_name,
    c.course_name,
    t.total_score,
    DENSE_RANK() OVER (
        PARTITION BY t.course_id
        ORDER BY t.total_score DESC
    ) AS user_rank
FROM (
    SELECT
        s.user_id,
        a.course_id,
        SUM(s.score) AS total_score
    FROM lms.AssessmentSubmissions s
    JOIN lms.Assessments a
        ON s.assessment_id = a.assessment_id
    GROUP BY s.user_id, a.course_id
) t
JOIN lms.Users u ON t.user_id = u.user_id
JOIN lms.Courses c ON t.course_id = c.course_id;

-- Identify the first lesson accessed by each user for every course.
/* the inner query we are finding the course and activity time who has the started first with course and first lesson 
   with the partition by user_id and the order by the activity_time because of we get the first user in ascending time */
SELECT
    t.user_id,
    u.first_name,
    t.course_id,
    c.course_name,
    t.lesson_id,
    l.lesson_name,
    t.activity_time
FROM (
     SELECT ua.user_id,
            ua.lesson_id,
            l.course_id,
            ua.activity_time,
            ROW_NUMBER() over (PARTITION BY ua.user_id,l.course_id ORDER BY ua.activity_time) as rn
            FROM lms.lessons l
            JOIN lms.UserActivity ua
            ON l.lesson_id = ua.lesson_id
) t
JOIN lms.Users u
ON t.user_id = u.user_id
JOIN lms.Courses c
on t.course_id = c.course_id
JOIN lms.lessons l 
on t.lesson_id = l.lesson_id
where t.rn = 1

-- Find users with activity recorded on at least five consecutive days.
/* here we are using two cte,first one  we are calculating the distinct days,with help of cast function change datetime into date
   and in the second cte with help of dateadd function grouped the dates*/
WITH DistinctDays AS (
    SELECT DISTINCT
        user_id,
        CAST(activity_time AS DATE) AS activity_date
    FROM lms.UserActivity
),
-- DateAdd(part-(day,month,year),interval-(1,2..),date-(like starting date))
GroupedDates AS (
    SELECT
        user_id,
        activity_date,
        DATEADD(DAY, -ROW_NUMBER() over ( 
            PARTITION BY user_id
            ORDER BY activity_date
        ), activity_date) AS grp
    FROM DistinctDays
)-- filter the result
SELECT
    user_id
FROM GroupedDates
GROUP BY user_id, grp
HAVING COUNT(*) >= 5;

-- Retrieve users who enrolled in a course but never submitted any assessment.
/* used left join here because of in the AssessmetsSubmissions table the user_id must be null without submitting
   the assessment , so i am using the left join here */
SELECT DISTINCT
    u.user_id,
    u.first_name,
    u.last_name
FROM lms.Enrollments e
JOIN lms.Users u
    ON e.user_id = u.user_id
LEFT JOIN lms.AssessmentSubmissions s
    ON e.user_id = s.user_id
WHERE s.user_id IS NULL;

-- List courses where every enrolled user has submitted at least one assessment.
SELECT c.course_id,
       c.course_name
       FROM lms.Courses c
       JOIN lms.Enrollments e
       ON c.course_id = e.course_id
       LEFT JOIN lms.AssessmentSubmissions s
       on c.user_id = s.user_id
       WHERE s.user_id IS NULL;





