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

odd(s(0)).
odd(X) :-
  plus(s(s(0)), X1, X),
  odd(X1).

% recursion - prod
prod([], 1).
prod([X | Y], Z) :-
  prod(Y, Z1),
  Z is X * Z1.

% recursion - contains
starts_with(_, []).
starts_with([H | T1], [H | T2]) :-
  starts_with(T1, T2).

contains(L1, L2, 1) :- starts_with(L1, L2).
contains([_ | T], L, N) :-
  contains(T, L, N1), N is N1 + 1.

% recursion - multiples
% use inner to generate the list(N): [1 * N, 2 * N, ..., 3 * N]
% then use multiples to build the final result.
inner(N, N, []).
inner(N, I, [H | T]) :-
  I  <  N,        % try to terminate this branch
  I2 is I + 1,
  H  is N * I2,
  inner(N, I2, T).

multiples(1, [[1]]).
multiples(N, L) :-
  N > 0, % N should be larger than 0, or it can not terminate
  N1 is N - 1,
  inner(N, 0, L2),
  multiples(N1, L1),
  append(L1, [L2], L).

% recursion - add_poly
% helper functions
filter_larger([],      _, []).
filter_larger([(C1, H) | T], (C2, X), L) :- H  > X, filter_larger(T, (C2, X), L1), append([(C1, H)], L1, L).
filter_larger([(_,  H) | T], (C2, X), L) :- H =< X, filter_larger(T, (C2, X), L1), L = L1.

filter_exists([], _, []).
filter_exists([H | T], L, L1) :- \+ member(H, L), filter_exists(T, L, L2), append([H], L2, L1).
filter_exists([H | T], L, L1) :-    member(H, L), filter_exists(T, L, L2), L1 = L2.

% quick_sort: sort the list with qsort algorithm
%   L1 - input list of tuples
%   L2 - output list of sorted tuples 
quick_sort([],      []).
quick_sort([H | T], L) :-
  filter_larger(T,  H, L1),
  filter_exists(T, L1, L2),
  quick_sort(L1, L3),
  quick_sort(L2, L4),
  append(L3, [H | L4], L).

% all lists input are sorted from outside.
add_poly_inner(L, [], L).
add_poly_inner([], L, L).
add_poly_inner([(C1,I1)|T1], [(C2,I2)|T2], L) :-
  I1 == I2,
  add_poly_inner(T1, T2, L1),
  C3 is C1 + C2,
  append([(C3,I1)], L1, L).
add_poly_inner([(C1,I1)|T1], [(C2,I2)|T2], L) :-
  I2  > I1,
  add_poly_inner([(C1,I1)|T1], T2, L1),
  append([(C2,I2)], L1, L).
add_poly_inner([(C1,I1)|T1], [(C2,I2)|T2], L) :-
  I1  > I2,
  add_poly_inner(T1, [(C2,I2)|T2], L1),
  append([(C1,I1)], L1, L).

add_poly(L1, L2, L3) :-
  length(L1, LN1),
  length(L2, LN2),
  LN1 >= LN2,
  quick_sort(L1, S1),
  quick_sort(L2, S2),
  add_poly_inner(S1, S2, L3).
add_poly(L1, L2, L3) :-
  length(L1, LN1),
  length(L2, LN2),
  LN1 < LN2,
  quick_sort(L2, S1),
  quick_sort(L1, S2),
  add_poly_inner(S1, S2, L3).
