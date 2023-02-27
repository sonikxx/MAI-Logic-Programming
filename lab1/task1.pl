% 11.Удаление элемента с заданным номером
% без применения стандарных предикатов
remove_n(0,L,L):-!.
remove_n(1,[_|L],L):-!.
remove_n(N,[Y|L],[Y|L1]):-
    N1 is N - 1,
    remove_n(N1,L,L1).

% с применением стандартных предикатов 
remove_n1(0,L,L):-!.
remove_n1(1,[_|L],L):-!.
remove_n1(N,R,R1):-
    append(Y,[_|L],R),
    append(Y,L,R1),
    N1 is N - 1,
    length(Y,N1).

% 15.Вычисление позиции первого отрицательного элемента в списке
% без применения стандарных предикатов
first_negative(1,[Y|_]):- 
    Y < 0, !.
first_negative(N,[_|X]):- 
    first_negative(N1,X),
    N is N1 + 1.

% с применением стандарных предикатов
first_negative1(1,[Y|_]):- 
    Y < 0.
first_negative1(N,[Y|T]):-
    Y >= 0,
    length(T,K),
    K > 0,
    first_negative1(N1, T),
    N is N1 + 1.

% пример совместного использования предикатов
% предикат удаления первого отрицательного элемента
remove_negative(L,L1):-
    first_negative(N,L),
    remove_n(N,L,L1).

