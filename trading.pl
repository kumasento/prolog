sells(usa, grain, mexico).
sells(S, P, R) :-
  produces(S, P),
  needs(R, P).

needs(britain, cars).
needs(japan, cars).
needs(france, pork).
needs(_, cameras).
% any country needs oil will needs cars
% or any country needs cars should need oil?
needs(C, oil) :-
  needs(C, cars). 

produces(oman, oil).
produces(iraq, oil).
produces(japan, cameras).
produces(germany, pork).
produces(france, wine).

bilateral_traders(X, Z) :-
  sells(X, _, Z), sells(Z, _, X), X \= Z.

