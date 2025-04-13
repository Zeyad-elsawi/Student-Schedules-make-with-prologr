
University Course Schedule in Prolog

This project is a Prolog-based scheduling system developed for CSEN 403 – Concepts of Programming Languages at the German University in Cairo. It uses a provided knowledge base (publicKB.pl) containing student enrollments and daily course schedules to automatically generate non-clashing timetables for each student.

Key Features:

Student Schedule Generation:
For every student (identified by a unique Student_id), the program collects the courses they’re enrolled in and gathers all possible time slots for each course. By exploring permutations of these slots, it identifies a combination that meets the following constraints:

No Time Clashes: Two courses cannot occupy the same day and time slot.

Limited Study Days: The schedule is restricted to a maximum number of unique days (leaving two days off per week).

Assembly Hours Identification:
The system also computes common free slots (assembly hours) for all students based on their schedules. It filters available time slots so that each selected slot is free (unused by any student) and occurs on a day when all students have classes.

Clean Code and Modularity:
The solution is structured using higher-order predicates like maplist/3 and custom helper predicates (such as permutate/2 and sort_by_course/2) to simplify complex logical operations.
All constraints are enforced declaratively, and the code is well-commented for ease of understanding and future extensions.

Technologies:

Prolog (SWI-Prolog)

Standard built-in predicates for list processing and sorting

This project demonstrates effective use of declarative programming to solve real-world scheduling problems and is a foundational step toward more advanced constraint-based programming projects.
![image](https://github.com/user-attachments/assets/7f077e7a-fc84-400f-84af-043de8a7c9d9)
