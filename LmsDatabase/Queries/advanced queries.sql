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

-- List courses where lessons are frequently accessed but assessments are never attempted.
/* here using of an left join because of the user frequently accessed the course but never attempted the assessment that means the 
   from the submission table, definately the submisson_id is null. */
SELECT DISTINCT
       c.course_id,
       c.course_name
FROM lms.Courses c
LEFT JOIN lms.Assessments a
       ON c.course_id = a.course_id
LEFT JOIN lms.AssessmentSubmissions s
       ON a.assessment_id = s.assessment_id
WHERE s.submission_id IS NULL;
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
-- if the total count of enrollments user id must be equal to the total number of users in the assessmentsubmission must be equal
SELECT
    c.course_id,
    c.course_name
FROM lms.Courses c
JOIN lms.Enrollments e
    ON e.course_id = c.course_id
LEFT JOIN lms.Assessments a
    ON a.course_id = c.course_id
LEFT JOIN lms.AssessmentSubmissions s
    ON s.assessment_id = a.assessment_id
   AND s.user_id = e.user_id
GROUP BY c.course_id,c.course_name
HAVING COUNT(DISTINCT e.user_id)=COUNT(DISTINCT s.user_id)
