
% lists - pairs
pairs([], []).
pairs([H | T1], [(U, V) | T2]) :- U is H - 1, V is H + 1, pairs(T1, T2).

% lists - arbpairs
arbpairs([], []).
arbpairs([N | T1], [(N, N) | T2]) :- arbpairs(T1, T2).
arbpairs([N | T1], [(N, L) | T2]) :- L is 2 * N, arbpairs(T1, T2).

% lists - numval
numval(A, V) :- number(A), V is A.
numval(a(X, Y), V) :- numval(X, V1), numval(Y, V2), V is V1 + V2.
numval(m(X, Y), V) :- numval(X, V1), numval(Y, V2), V is V1 * V2.

% lists - comb
% helper append_each
append_each(_, [], []).
append_each(N, [H | T], L) :-
  append_each(N, T, L1),
  append(H, [N], L2),
  append([L2], L1, L).

acc_comb([], L, L).
acc_comb([H | T], L, LL) :-
  append_each(H, L, L1),
  append(L, L1, L2),
  acc_comb(T, L2, LL). 

comb(L1, L2) :- acc_comb(L1, [[]], L2).

% lists - connected_parts
filter_edge([], _, L1, L1, L2, L2).
filter_edge([H | T], (U, V), L1, LL1, L2, LL2) :- \+ (\+ member(U, H), \+ member(V, H)), append([H], L1, L3), filter_edge(T, (U, V), L3, LL1, L2, LL2).
filter_edge([H | T], (U, V), L1, LL1, L2, LL2) :-    (\+ member(U, H), \+ member(V, H)), append([H], L2, L3), filter_edge(T, (U, V), L1, LL1, L3, LL2).

merge_edge((U, V), L, LL) :-    member(U, L),    member(V, L), LL = L.
merge_edge((U, V), L, LL) :-    member(U, L), \+ member(V, L), append(L, [V], LL).
merge_edge((U, V), L, LL) :- \+ member(U, L),    member(V, L), append(L, [U], LL).

add_edge((U, V), LC, LCN) :-
  filter_edge(LC, (U, V), [], [], [], LC2), append(LC2, [[U, V]], LCN).
add_edge((U, V), LC, LCN) :-
  filter_edge(LC, (U, V), [], [H], [], LC2), merge_edge((U, V), H, LC1), append(LC2, [LC1], LCN).
add_edge((U, V), LC, LCN) :-
  filter_edge(LC, (U, V), [], [H1,H2], [], LC2), append(H1, H2, LC1), append(LC2, [LC1], LCN).

merge_edges([], L, L).
merge_edges([E | T], L, LL) :- add_edge(E, L, LC), merge_edges(T, LC, LL).

sort_parts([], L, L).
sort_parts([E | T], L, LL) :-
  sort(E, L1), append(L, [L1], L2), sort_parts(T, L2, LL).

% you can easily change this to a /1 predicate if you make G as a fact.
connected_parts(G, L) :- merge_edges(G, [], LC), sort_parts(LC, [], L).

% lists - member
once_member_inner(E, [E | _], S) :- \+ member(E, S).
once_member_inner(E, [X | T], S) :- append([X], S, S1), once_member_inner(E, T, S1).

once_member(E, L) :- once_member_inner(E, L, []).
