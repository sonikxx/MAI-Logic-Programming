remove(H,[H|T],T).
remove(X,[H|T],[H|T1]) :- remove(X, T, T1).

permute([], []).
permute(L, [H|T]) :-
    remove(H, L, R),
    permute(R, T).

do_task(Dancer, Artist, Singer, Writer) :-
    permute([Dancer, Artist, Singer, Writer], [voronov, pavlov, levitsky, saharov]),
    % Певец - не Воронов или Левицкий
    Singer \= voronov, Singer \= levitsky,
    % Художник - не Павлов
    Artist \= pavlov,
    % Писатель - не Сахоров, Воронов, Павлов
    Writer \= saharov, Writer \= voronov, Writer \= pavlov, 
    % Воронов никогда не слышал о Левицком
    not((Artist = voronov, Writer = levitsky)),
    not((Writer = voronov, Artist = levitsky)).

solve:-
    do_task(Dancer, Artist, Singer, Writer),
    write("Dancer is "), write(Dancer), nl,
    write("Artist is "), write(Artist), nl,
    write("Singer is "), write(Singer), nl,
    write("Writer is "), write(Writer).
