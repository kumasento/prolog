% acyclic directed graph
arc(a, b).
arc(b, c).
arc(b, d).
arc(c, f).
arc(d, f).
arc(c, e).
arc(f, e).

% recursion - path
path(X, X). % there's always a path between two identical points
path(X, Z) :- arc(X, Y), path(Y, Z).

% recursion - list
ones_zeros([0]).
ones_zeros([1]).
ones_zeros([X | Y]) :- (X = 1; X = 0), ones_zeros(Y).

% recursion - duplicate
hasdups([U | X]) :-
  member(U, X); % if U is one member of X, then the whole list should have U appears twice
  hasdups(X).

% recursion - peano number
plus(0, X, X).
plus(s(X), Y, s(Z)) :- plus(X, Y, Z).

% recursion - prod
prod([], 1).
prod([X | Y], Z) :-
  prod(Y, Z1),
  Z is X * Z1.
