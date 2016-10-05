parent(tom, bob).
parent(tom, liz).
parent(pam, bob).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).
grandparent(X, Y) :- 
  parent(X, Z), parent(Z, Y).
