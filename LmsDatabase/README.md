Learning Management System (LMS) – MSSQL Database


Project Overview :
This project is a Learning Management System (LMS) designed using SQL.
It focuses on organizing users, courses, enrollments, lessons, assessments, and user activity in a structured and practical way.

The purpose of this project is to learn database design, relationships, and real-world SQL query
Technologies Used :
Microsoft SQL Server (MSSQL) as the relational database
Relational Database Management System (RDBMS)
Constraints, Joins, Indexes, and Triggers

Database Structure (7 Tables) :
The LMS database contains 7 tables, each representing a core feature of the system.
1️.Users
Stores basic information about users in the LMS.
Purpose:
Manage student and instructor details
Key Columns:
user_id (Primary Key)
first_name
last_name
email

2.Courses
Stores details of courses available in the system.
Purpose:
Maintain course information
Assign courses to instructors
Key Columns:
course_id (Primary Key)
course_name
user_id (Instructor – Foreign Key)

3.Enrollments
Tracks which users are enrolled in which courses.
Purpose:
Manage course enrollments
Prevent duplicate enrollments
Key Columns:
enrollment_id (Primary Key)
user_id (Foreign Key)
course_id (Foreign Key)
current_status

4️.Lessons
Contains lessons related to each course.
Purpose:
Break a course into multiple learning units
Key Columns:
lesson_id (Primary Key)
course_id (Foreign Key)
lesson_title

5️.Assessments
Stores assessment details for each course.
Purpose:
Manage quizzes or exams linked to courses
Key Columns:
assessment_id (Primary Key)
assessment_name
course_id (Foreign Key)
total_marks

6.AssessmentSubmissions
Stores submissions made by users for assessments.
Purpose:
Track assessment scores
Ensure submitted score does not exceed total marks
Key Columns:
submission_id (Primary Key)
assessment_id (Foreign Key)
user_id (Foreign Key)
score

7️.UserActivity
Tracks user interactions within the LMS.
Purpose:
Monitor user activity such as lesson access
Useful for progress tracking and analytics
Key Columns:
activity_id (Primary Key)
user_id (Foreign Key)
course_id (Foreign Key)
lesson_id (Foreign Key)
activity_time

Relationships Overview :
One User can create multiple Courses
One Course can have many Lessons
Users can enroll in many Courses through Enrollments
Courses can have multiple Assessments
Users can submit multiple AssessmentSubmissions
User learning behavior is tracked using UserActivity

Key Features :
Proper use of Primary Keys and Foreign Keys
Enforced data integrity using constraints
Business rules like valid assessment scores
Supports real-world LMS queries such as:
Users enrolled in each course
Users who never submitted assessments
First lesson accessed by a user
Course-wise performance analysis