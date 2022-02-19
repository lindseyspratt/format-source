:- object(fpl_token).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'display utility for the format prolog source system lexical analysis.'
	]).

	display_lex_list([]) :-
	  nl.
	display_lex_list([Item|Items]) :-
	  display_lex_item(Item),
	  display_lex_list(Items).

	display_lex_item(t(Cs)) :-
	  atom_codes(Token, Cs),
	  write(t(Token)).
	display_lex_item(p(C)) :-
	  atom_codes(Punctuation, [C]),
	  write(' '),
	  write(p(Punctuation)).
	display_lex_item(w(Cs)) :-
	  atom_codes(W, Cs),
	  write(' '),
	  write(w(W)).

:- end_object.
