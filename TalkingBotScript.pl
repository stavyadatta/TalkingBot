/*
Name - Stavya Datta
Student ID - N1904552J
*/
/*list of games and their features, double list to keep them seperate
from each when appending together */
tennis([[court, singles, doubles, outdoor, ball, racket, nets, scoring_in_ones_twos, grand_slam, shots]]).
cricket([[ball,bat,fielding,umpire,wickets, wicket_keeper, bowler, batsman, out, sixes]]).
soccer([[goal,ball,shoes,fields,defence, offence, forward, backward, goalee, mid_field]]).
swimming([[pool,race,cap,underwear,goggles, butterfly_stroke, breast_stroke, back_stroke, fifty_metres, dive]]).
shooting([[rifle,bullet,aim,boards, board_points, bull_eye, balance, handguns, moving_target, dissapearing_target]]).

%counter inrement
incr(X, X1) :-
    X1 =  X+1.

list_of_games([tennis,cricket,soccer,swimming,shooting]).

% choosing random items from the list
random_choose([],[],Index).
random_choose(List,Elt,Index):-
    length(List,Length),
    random(0,Length,Index),
    nth0(Index, List, Elt).


/*
    This is the main Rule of the this program, it will first find, when the counter is 0,
    if its zero then the first function will begin, it will initially go through list of
    lists of all the details about the sports, once it gets that list, it will remove any
    sublist which has been repeated before. Once thats done it will
    randomly choose a sublist and then using its index number choose the
    name of the sport from list_of_games, it will assert the name
    sublist and the name of the respective sport in the random_list/1
    and selected_game/1 once thats done it will remove any elements that
    have been selected beofre from the sublist using the gone_ones list,
    it will then return the name of that elemnt from the list to the ask
    predicate

*/
validate_query(X,Non_entering_num):-
    Non_entering_num =:= 0, choosing_list(Z), removing_past_games_options(Z,Y),
    random_choose(Y,Selected,IndexSport),list_of_games(Sports_list_old),
    removing_past_games(Sports_list_old, Sports_list),nth0(IndexSport,Sports_list,Sport),
    assert(selected_game(Sport)),assert(random_list(Selected)), list_to_set(Selected, S),
    findall(A,gone_by_list(A),Gone_ones), subtract(S, Gone_ones, Choice),
    random_choose(Choice, X,IndexFeature),assert(gone_by_list(X)), asserting_games(Selected, Sport).

/*
    Basically does the same thing as the previous predicate only but
    only chooses elements from the sublist given before and chooses an
    element and returns it to the ask clause
*/
validate_query(X,Non_entering_num):-
   findall(A, random_list(A),List), nth0(1,List,Selected),
   list_to_set(Selected, S), findall(A,gone_by_list(A),Gone_ones),
   subtract(S, Gone_ones, Choice), random_choose(Choice, X,No_use),
   assert(gone_by_list(X)).

/* removes the past mentioned sport to have unique sport every game */
removing_past_games_options(Y,Z):-
    findall(X, preselected_games_options(X),Past_options), subtract(Y, Past_options,Z).
removing_past_games(Y,Z):-
    findall(X, preselected_games(X),Past_options), subtract(Y, Past_options,Z).

/* asserting the current sport to the list to avoid repetition*/
asserting_games(Selected, Sport):-
    assert(preselected_games_options(Selected)), assert(preselected_games(Sport)).
/* to append every sport*/
choosing_list(X):-
    tennis(A),cricket(B),soccer(C),swimming(D),shooting(E),
    append(A,B,List1),append(List1,C,List2),append(List2,D,List3),
    append(List3,E,X).

/* This is done to keep the program from deleting everything from the gone_by_list/1, random_list */
asserting:-
    assert(gone_by_list(nothing)),assert(random_list(nothing)), assert(selected_game(nothing)).

/* The ask is used when counter is at its end, it reads the guess of the user, tells whether its right or wrong,
    retractsall the lists to prevent any errors in the next games and
    asserts them to their original state.
*/
ask(Counter_num):-
    Counter_num =:=10,write("What game is it "), read(Y),findall(A,selected_game(A),Game_list),
    nth0(1,Game_list,Game),(Y == Game,print("Thats right") ; Y \== Game, print("Thats wrong")),
    read(X),retractall(gone_by_list(Empty_option)),retractall(random_list(Empty_list_oflist)),
    retractall(selected_game(Empty_game)),asserting,abort.

/*when the game starts it asks gives clues what the sport might be and increases the counter  */

ask(Counter_num):-
	print('The game has'),validate_query(X,Counter_num),read(Guess),findall(A, random_list(A), List_of_props),
        nth0(1, List_of_props, Features),(member(Guess, Features) -> writeln("Thats right "); writeln("Its wrong")),
        print("The game has "),print(X), print(' too!!! ( y for ok q for quit)'), incr(Counter_num,New_num),read(Y),
        (Y==q ->retractall(random_list(Empty_list_oflist)),retractall(selected_game(Empty_game)),
         asserting, abort;Y==y -> ask(New_num)).

/*Starts the game */
start:-
    ask(0).

/*lists to get the work done */
gone_by_list(nothing).
random_list(nothing).
selected_game(nothing).

preselected_games(nothing).
preselected_games_options(nothing).
