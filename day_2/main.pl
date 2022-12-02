read_file(Stream, []) :-
    at_end_of_stream(Stream).
read_file(Stream, [X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    atom_chars(X, Codes),
    read_file(Stream, L), !.

process_input(Input, Output):-
    split_string(Input, " ", " ", Output).

shape_score("X", 1).
shape_score("Y", 2).
shape_score("Z", 3).

equal_score("A", "X").
equal_score("B", "Y").
equal_score("C", "Z").

expected_play_score("X", 0).
expected_play_score("Y", 3).
expected_play_score("Z", 6).

% TheirPlay -> OurPlay -> Score
score("C", "X", 6).
score("A", "Y", 6).
score("B", "Z", 6).
score("A", "X", 3).
score("B", "Y", 3).
score("C", "Z", 3).
score("A", "Z", 0).
score("B", "X", 0).
score("C", "Y", 0).

get_total_score_part1([], 0).
get_total_score_part1([[Their, Our]|Tail], TotalScore):-
    score(Their, Our, Score),
    shape_score(Our, ShapeScore),
    get_total_score_part1(Tail, NextScore),
    TotalScore is NextScore + Score + ShapeScore.

get_total_score_part2([], 0).
get_total_score_part2([[Their, Our]|Tail], TotalScore):-
    expected_play_score(Our, ExpectedScore),
    score(Their, CurrentPlay, ExpectedScore),
    shape_score(CurrentPlay, ShapeScore),
    get_total_score_part2(Tail, NextScore),
    TotalScore is NextScore + ExpectedScore + ShapeScore.

:-
    open('input.txt', read, Stream),
    read_file(Stream, Lines),
    maplist(process_input, Lines, ProcessedInput),
    close(Stream),
    get_total_score_part1(ProcessedInput, Result1),
    write("Result 1 : "),
    writeln(Result1),
    get_total_score_part2(ProcessedInput, Result2),
    write("Result 2 : "),
    writeln(Result2).

:- halt.

