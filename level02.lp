% Please insert the names and email addresses of the group members:
% Yerkezhan Abdullayeva     <abdullayeva@uni-potsdam.de>
%%clingo 0 asp/instances/ex01.lp -
% Tips:
% - You may include the facts below to represent the differences
%   between the coordinates of neighboring cells
diff(0,1). diff(0,-1). diff(1,0). diff(-1,0).
% notes provided from the binder notebook
% cell(X, Y). first(X, Y). final(X, Y).
% hint(X, Y, N).  % the cell (X,Y) contains the hint number N
% there is no hint in the first cell, it represents merely that there should be no turn.
hint(X, Y, 0) :- first(X, Y).

% number of turns given by the hint
turn(0..T) :- hint(_, _, T).

not_first(X, Y) :- cell(X, Y), not first(X, Y).

% a cell is considered a candidate cell for the path if it is not a final cell and not a hint cell
candidate(X, Y) :- not_first(X, Y), not hint(X, Y, _), not final(X, Y).
stop(X, Y) :- hint(X, Y, _).
stop(X, Y) :- final(X, Y).

% -:- CHOOSING SOLUTIONS -:-
% -- find paths
1 = { path(X1, Y1, X2, Y2, T) : not_first(X2, Y2), diff(X2-X1, Y2-Y1) } :- hint(X1, Y1, T).
1 = { path(X1, Y1, X2, Y2, T) : not_first(X2, Y2), diff(X2-X1, Y2-Y1), turn(T) } :- candidate(X1, Y1).

% -:- CONSTRAINTS -:-
% -- keep turning until the hint or the final cell
:- T != Z, candidate(A, B), path(A, B, X2, Y2, T), path(X1, Y1, A, B, Z), (X1 - A, Y1 - B) == (A - X2, B - Y2).
:- T != Z-1, candidate(A, B), path(A, B, X2, Y2, T), path(X1, Y1, A, B, Z), (X1 - A, Y1 - B) != (A - X2, B - Y2).
:- T != 0, stop(X, Y), path(_, _, X, Y, T).

% -- drop paths that are not traversed
traversed(X, Y) :- first(X, Y).
traversed(X, Y) :- traversed(A, B), path(A, B, X, Y).
:- cell(X, Y), not traversed(X, Y).

% T = Turns
path(X1, Y1, X2, Y2) :- path(X1, Y1, X2, Y2, T). % the path has an edge between the cells (X1,Y1) and (X2,Y2)

#show path/4.
