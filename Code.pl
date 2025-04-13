:- consult('publicKB.pl').

university_schedule(S) :-
    findall(Student_id, studies(Student_id, _), StudentsList),
    sort(StudentsList, UniqueStudents),
    university_schedule_helper(UniqueStudents, S).

university_schedule_helper([], []).
university_schedule_helper([Student_id | Rest], [sched(Student_id, Slots) | Schedules]) :-
    student_schedule(Student_id, Slots),
    university_schedule_helper(Rest, Schedules).

	
	
	
student_schedule(Student_id, Slots) :-
    courses(Student_id, Courses),
    maplist(possible_slots, Courses, PossibleLists),
    permutate(PossibleLists, PossibleSchedule),
    no_clashes(PossibleSchedule),
    study_days(PossibleSchedule, 5),
    sort_by_course(PossibleSchedule, Slots).

courses(Student_id, Courses) :-
    findall(Course, studies(Student_id, Course), CourseList),
    sort(CourseList, Courses).

find_slot(Course, Schedule, Time) :-
    nth1(Time, Schedule, CoursesInSlot),
    member(Course, CoursesInSlot).

no_clash_with(_, []).
no_clash_with(slot(Day, Time, _), [slot(Day2, Time2, _) | Rest]) :-
    (Day \= Day2 ; Time \= Time2),
    no_clash_with(slot(Day, Time, _), Rest).

possible_slots(Course, PossibleSlots) :-
    findall(slot(Day, Time, Course),
        ( possible_day(Day),
          day_schedule(Day, Schedule),
          find_slot(Course, Schedule, Time)
        ),
        PossibleSlots).

permutate([], []).
permutate([H|T], [X|Xs]) :-
    member(X, H),
    permutate(T, Xs).

sort_by_course(Slots, SortedSlots) :-
    predsort(compare_courses, Slots, SortedSlots).

compare_courses(Order, slot(_, _, Course1), slot(_, _, Course2)) :-
    compare(Order, Course1, Course2).

	
	
	
study_days(Slots, DayCount) :-
    findall(Day, member(slot(Day, _, _), Slots), AllDays),
    sort(AllDays, UniqueDays),
    length(UniqueDays, NumberOfDays),
    NumberOfDays =< DayCount.

no_clashes([]).
no_clashes([Slot | Rest]) :-
    \+ (member(S, Rest), same_slot(Slot, S)),
    no_clashes(Rest).

same_slot(slot(D,T,_), slot(D,T,_)).

assembly_hours(Schedules, AH) :-
    findall(slot(Day, SlotNum), (
        possible_day(Day),
        possible_slot(SlotNum),
        \+ findallhelper(Day, SlotNum, Schedules),
        valid_day(Day, Schedules)
    ), UnsortedAH),
    predsort(sign1, UnsortedAH, AH).

sign1(Order, slot(D1,SN1), slot(D2,SN2)) :-
    day_priority(D1, P1),
    day_priority(D2, P2),
    (   P1 < P2 -> Order = '<'
    ;   P1 > P2 -> Order = '>'
    ;   SN1 < SN2 -> Order = '<'
    ;   SN1 > SN2 -> Order = '>'
    ;   Order = '='
    ).


findallhelper(Day, SlotNum, Schedules) :-
    member(sched(_, Slots), Schedules),
    member(slot(Day, SlotNum, _), Slots).

valid_day(Day, Schedules) :-
    forall(member(sched(_, Slots), Schedules),
           member(slot(Day, _, _), Slots)).

day_priority(saturday, 1).
day_priority(sunday, 2).
day_priority(monday, 3).
day_priority(tuesday, 4).
day_priority(wednesday, 5).
day_priority(thursday, 6).

possible_day(saturday).
possible_day(sunday).
possible_day(monday).
possible_day(tuesday).
possible_day(wednesday).
possible_day(thursday).

possible_slot(1).
possible_slot(2).
possible_slot(3).
possible_slot(4).
possible_slot(5).