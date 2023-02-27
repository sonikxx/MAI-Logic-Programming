:- encoding(utf8).
    
length([],0).
length([_|T],N):-
    length(T,N1),
    N1 is N - 1.
    
memeber(H,[H|_]).
memeber(X, [_|T]):-
    memeber(X,T).
    
append([],X,X).
append([H|T],L,[H|R]):-
    append(T,L,R).

% словарь
nouns(['Саша', 'Ира', 'игрушки', 'кубики', 'мячи', 'стихи', 'прозы', 'пьесы']).
verbs(['любит']).
separators([['и'], ['да'], [',', 'но'], [',', 'а'], [','], [',', 'зато']]).

% проверка наличия слова в словаре 
check_noun(Noun) :-
    nouns(List),
    member(Noun, List).
check_verb(Verb) :- 
    verbs(List),
    member(Verb, List).
check_separator(Sep) :- 
    separators(List), 
    member(Sep, List).

% называем терм для глагола
verb_to_term('любит', 'likes').
verb_to_term(['не' | 'любит'], 'not_likes').

% разделение списка на 2 или 3 части
split(List, Part1, Part2) :- 
    append(Part1, Part2, List), 
    not(length(Part1, 0)), 
    not(length(Part2, 0)).
split(List, Part1, Part2, Part3) :- 
    append(Part1, TMP, List), 
    append(Part2, Part3, TMP),
    not(length(Part1, 0)), 
    not(length(Part2, 0)), 
    not(length(Part3, 0)).

decompose(Phrase, List) :- 
    setof(Deep_st, decompose_phrase(Phrase, Deep_st), List).

decompose_phrase(Phrase, Result) :- 
    check_phrase(Phrase, deep_st(Verb, Subject, Object)), 
    verb_to_term(Verb, Verb_Term), 
    Result=..[Verb_Term, Subject, Object].

% отделения действия от подлежащего
check_phrase([Subject | Actions], deep_st(Verb, Subject, Object)) :- 
    check_noun(Subject), 
    check_actions(Actions, Verb, Object).

% ДЕЙСТВИЯ -> ГРУППА_ГЛ
check_actions(Actions, Verb, Object) :- 
    check_verb_group(Actions, Verb, Object).

% ДЕЙСТВИЯ -> ГРУППА-ГЛ + ДЕЙСТВИЯ
check_actions(Actions, Verb, Object) :- 
    split(Actions, Verb_Group, TMP), 
    check_verb_group(Verb_Group, Verb, Object), 
    check_actions(TMP, _, _).

check_actions(Actions, Verb, Object) :- 
    split(Actions, TMP, Actions1),
    check_verb_group(TMP, _, _),
    check_actions(Actions1, Verb, Object).

% ГРУППА_ГЛ -> ГЛАГОЛ + ГРУППА_СУЩ
check_verb_group([Verb | Object_Group], Verb, Object) :- 
    check_verb(Verb),
    check_object_group(Object_Group, Object).

% ГРУППА_ГЛ -> РАЗДЕЛИТЕЛЬ + ГРУППА_ГЛ
check_verb_group([Sep | Verb_Group], Verb, Object) :- 
    check_separator([Sep]), 
    check_verb_group(Verb_Group, Verb, Object).

% ЕСЛИ РАЗДЕЛИТЕЛЬ СОДЕРЖИТ ЗАПЯТУЮ
check_verb_group([Sep1, Sep2 | Verb_Group], Verb, Object) :- 
    check_separator([Sep1, Sep2]), 
    check_verb_group(Verb_Group, Verb, Object).

% ГРУППА_ГЛ -> 'НЕ' + ГРУППА_ГЛ
check_verb_group(['не' | Verb_Group], ['не' | Verb], Object) :- 
    !, 
    check_verb_group(Verb_Group, Verb, Object).

% ГРУППА_СУЩ -> СУЩ
check_object_group([Object], Object) :- 
    check_noun(Object).

% ГРУППА_СУЩ -> ГРУППА_СУЩ + РАЗДЕЛИТЕЛЬ + ГРУППА_СУЩ 
check_object_group(Object_Group, Object) :- 
    split(Object_Group, Object_Group1, Sep, TMP), 
    length(Sep, 1), 
    check_separator(Sep), 
    check_object_group(Object_Group1, Object),
    check_object_group(TMP, _).

check_object_group(Object_Group, Object) :- 
    split(Object_Group, TMP, Sep, Object_Group2), 
    length(Sep, 1),
    check_separator(Sep), 
    check_object_group(TMP, _),
    check_object_group(Object_Group2, Object).
