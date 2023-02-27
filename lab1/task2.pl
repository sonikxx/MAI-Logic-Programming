% Вариант 3
% 1. Для каждого студента, найти средний балл, и сдал ли он экзамены или нет
:- set_prolog_flag(encoding, utf8).
:- [two].

% нахождение суммы оценок студента
sum([],0).
sum([H|T],X):-
	sum(T,X1),
    X is X1 + H.

% проверка на сдачу экзамена: 2 - не сдал какой-то экзамен, 1 - сдал все экзамены
check([2|_],2):-!.
check([],1):-!.
check([_|T],Status):-
    check(T,Status).

% средняя оценка студента
get_marks(Student,Mark,Status):-                        
	findall(Mrk,grade(_,Student,_,Mrk),Marks),
	sum(Marks,N),
	check(Marks,Status),
	length(Marks,Len),
	Mark is N / Len.

mark(Student,[Student,Mark,Message]):-
	get_marks(Student,Mark,Status),
	Status = 2,
	Message = 'dont pass exams',
	!;
	get_marks(Student,Mark,Status),
	Message = 'pass exams',!.

% 2.Для каждого предмета, найти количество не сдавших студентов
dont_passed(Subject,Count):-
	setof(Student,A^grade(A,Student,Subject,2),S),
	length(S,Count).

% 3.Для каждой группы, найти студента (студентов) с максимальным средним баллом 
% получает список из средних оценок студентов одной группы
get_list_marks([],[]):-!.
get_list_marks([Students|S],[Max|M]):-
	findall(Mrk,grade(_,Students,_,Mrk),Marks),
	sum(Marks,N),
	length(Marks,Len),
	Max is N / Len,
	get_list_marks(S,M).

% считает масимальную среднюю оценку среди списка оценок одной группы
calc_max_mark([],Current_Max,Max):-
	Max is Current_Max,!.
calc_max_mark([Marks|M],Current_Max,Max):-
	Marks > Current_Max,
	calc_max_mark(M,Marks,Max),!;
	calc_max_mark(M,Current_Max,Max),!.

% максимальная средняя оценка в группе
max_mark(Group,Max):-
    findall(Student,grade(Group,Student,_,_),S),
	get_list_marks(S,Marks),
	calc_max_mark(Marks,0,Max).

%сравнение средних оценок студентов
students_with_max(Group,List):-
    max_mark(Group,Max),    
    setof(Student,(grade(Group,Student,_,_),get_marks(Student,Mark),Mark==Max),List),!.   
