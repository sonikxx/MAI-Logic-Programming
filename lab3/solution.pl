%принадлежность
member(L, [L|_]).
member(L, [_|Tail]) :-
    member(L, Tail).

%конкатенация 
append([], L, L).
append([Head|Tail], L, [Head|NewTail]) :-
    append(Tail, L, NewTail).
 
%возможные преобразования
step(A,B):-
    append(Begin,["_","w"|Tail],A),
    append(Begin,["w","_"|Tail],B).

step(A,B):-
    append(Begin,["b","_"|Tail],A),
    append(Begin,["_","b"|Tail],B).

step(A,B):-
    append(Begin,["_","b","w"|Tail],A),
    append(Begin,["w","b","_"|Tail],B).

step(A,B):-
    append(Begin,["b","w","_"|Tail],A),
    append(Begin,["_","w","b"|Tail],B).

%вывод списков с конца
print_list([]).
print_list([Head|Tail]):-
    print_list(Tail),
    writeln(Head).

%вывод ответа
dfs(Finish,[Finish|Tail]) :-
    !, print_list([Finish|Tail]).
       
dfs(Finish, [Curr|Tail]) :-
    step(Curr, New),
    not(member(New,Tail)),              %проверка решения на уникальность, Tail - найденные списки
    dfs(Finish, [New, Curr|Tail]). 

%преобразование списка для bfs
next(Curr, HasBeen, New) :-
    step(Curr, New),
    not(member(New,HasBeen)). 

bfs([First|_],Finish,First) :- 
    First = [Finish|_].
bfs([[LastWay|HasBeen]|OtherWays],Finish,Way):-  
    findall([Z,LastWay|HasBeen], next(LastWay, HasBeen, Z), List),
    append(List,OtherWays,NewWays), 
    bfs(NewWays,Finish,Way).

%преобразование списка для id                
next2([Curr|Tail],[New,Curr|Tail]) :-
    step(Curr,New),
    not(member(New,[Curr|Tail])). 

id([Finish|Tail],Finish,[Finish|Tail],0).

id(TempWay,Finish,Way,N):- 
    N > 0,
    next2(TempWay,NewWay),
    N1 is N-1,
    id(NewWay,Finish,Way,N1).

%цикл для итеративного поиска
for(X, X, _).
for(I, X, Y):-
    X < Y,
    X1 is X + 1,
    for(I, X1 ,Y).

solve(Start, Finish):-
    writeln('DFID'),
    get_time(S1),
    for(Lvl, 1, 100),
    id([Start], Finish, Way, Lvl),
    print_list(Way),
    get_time(R1),
    T1 is R1 - S1,
    write('Time is '), writeln(T1), nl,

    writeln('DFS'),
    get_time(S2),
    dfs(Finish, [Start]),
    get_time(R2),
    T2 is R2 - S2,
    write('Time is '), writeln(T2), nl,

    writeln('BFS'),
    get_time(S3),
    bfs([[Start]],Finish,Way), 
    print_list(Way),
    get_time(R3),
    T3 is R3 - S3,
    write('Time is '), writeln(T3), nl,
    !.
