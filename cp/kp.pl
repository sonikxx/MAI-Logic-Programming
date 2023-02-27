:- ['my_kp.pl'].

brother(Brother, Y) :-
    father(Brother, _),
    mother(Mom, Brother),
    father(Dad, Brother), 
    mother(Mom, Y),
    father(Dad, Y),
    Brother \= Y.

sister(Sister, Y) :-
    mother(Sister, _),
    mother(Mom, Sister),
    father(Dad, Sister), 
    mother(Mom, Y),
    father(Dad, Y),
    Sister \= Y.

sibling(X, Y) :-
    mother(Mom, X),
    father(Dad, X), 
    mother(Mom, Y),
    father(Dad, Y),
    X \= Y.

married(Wife, Husband) :-
    mother(Wife, Child),
    father(Husband, Child).

% золовка - сестра мужа
sisterInLaw(X, Wife) :-
    married(Wife, Husband),
    sister(X, Husband).

% шурин - брат жены
brotherInLaw(X, Husband) :-
    married(Wife, Husband),
    brother(X, Wife).

% тёща - мать жены
tesha(X, Husband) :-
    married(Wife, Husband),
    mother(X, Wife).

% свекровь - мать мужа
svekrov(X, Wife) :-
    married(Wife, Husband),
    mother(X, Husband).

grandma(Grandma, X) :-
    mother(Mom, X),
    mother(Grandma, Mom),
    father(Dad, X),
    mother(Grandma, Dad).

grandson(Grandson, X) :-
    father(Grandson, _),
    grandma(X, Grandson).

grandson(Grandson, X) :-
    father(Grandson, _),
    grandad(X, Grandson).

grandaugther(Grandaugther,X) :-
    mother(Grandaugther, _),
    grandma(X, Grandaugther).

grandaugther(Grandaugther,X) :-
    mother(Grandaugther, _),
    grandad(X, Grandaugther).

grandad(Grandad, X) :-
    mother(Mom, X),
    father(Grandad, Mom),
    father(Dad, X),
    father(Grandad, Dad).

son(Son, Mom) :-
    father(Son, _),
    mother(Mom, Son).

son(Son, Dad) :-
    father(Son, _),
    father(Dad, Son).

daugther(Daugther, Mom) :-
    mother(Daugther, _),
    mother(Mom, Daugther).

daugther(Daugther, Dad) :-
    mother(Daugther, _),
    father(Dad, Daugther).

husband(Husband, Wife) :-
    father(Husband, Child),
    mother(Wife, Child).

wife(Wife, Husband) :-
    father(Husband, Child),
    mother(Wife, Child).

% движения для алгоритма поиска
move(X, Y, grandson) :- 
    grandson(X, Y).
move(X, Y, grandaugther) :- 
    grandaugther(X, Y).
move(X, Y, grandad):- 
    grandad(X, Y).
move(X, Y, grandma) :- 
    grandma(X, Y).
move(X, Y, svekrov) :- 
    svekrov(X, Y).
move(X, Y, tesha) :- 
    tesha(X, Y).
move(X, Y, father):-
    father(X, Y).
move(X, Y, mother) :-
    mother(X, Y).
move(X, Y, son) :-
    son(X, Y).
move(X, Y, daugther) :-
    daugther(X, Y).
move(X, Y, brother) :-
    brother(X, Y).
move(X, Y, sister) :-
    sister(X, Y).
move(X, Y, sibling) :-
    sibling(X, Y).
move(X, Y, sisterInLaw) :-
    sisterInLaw(X, Y).
move(X, Y, brotherInLaw) :-
    brotherInLaw(X, Y).
move(X, Y, husband) :- 
    husband(X, Y).
move(X, Y, wife):- 
    wife(X, Y).

% итерационный поиск
int(1).
int(N1) :-
	int(N),
	N1 is N+1.

search([Now|T1], Now, [Now|T1], [], 1). 
search([Now|T1], Final, Way, [Result|T2], N) :-
	N > 0,
	move(Now, New, Result),
	not(member(New, [Now|T1])),
	M is N-1,
	search([New, Now|T1], Final, Way, T2, M).

iter_search(Start, Final, Way, Result) :-
	int(N1),
	(N1 > 100, !;	
    search([Start], Final, Way, Result, N1)).

% Определение степени родства
relatives(X, Y, Result):-
	iter_search(X, Y, _, Result).

