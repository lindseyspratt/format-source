:- object(fpu_display_item).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Display items for format prolog system.'
	]).

	:- public(display_item/2).
	:- mode(display_item(+integer, +atom), one).
	:- info(display_item/2, [
		comment is 'Display `Item` with left padding of `Indent`.',
		argnames is ['Indent', 'Item']
	]).

	:- uses(fpu_output_position, [fp_nl/0, fp_write/1, pos/2, adjusted_pos/2]).
	:- uses(fpu_string, [left_trim/3]).
	
	display_item_list([], _).

	display_item_list([Item|Items], Col) :-
	          display_item(Col, Item),
	          display_item_list(Items, Col).

	/*------------------------------------------------------------*/

	display_item(Col, Item) :-
	   adjusted_pos(Col, Ncol),
	   pos(Ncol, Newline),
	   display_item1(Item, Newline).


	/*------------------------------------------------------------*/

	display_item1(nl, _Newline) :-
	    fp_nl.
	display_item1(w(Cs), Newline) :-
	   (Newline == yes
	     -> left_trim(Cs, " ", TrimmedCs)
	    /* trim blanks */  
	    ;
	    TrimmedCs = Cs
	   ),
	   atom_codes(W, TrimmedCs),
	   fp_write(W).
	display_item1(t(Cs), _) :-
	   atom_codes(T, Cs),
	   fp_write(T).
	display_item1(p(C), _) :-
	   atom_codes(P,  [C]),
	   fp_write(P).

:- end_object.
