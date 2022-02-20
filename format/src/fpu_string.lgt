:- object(fpu_string).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'String utilities for format prolog system.'
	]).

	:- public(left_trim/3).
	:- mode(left_trim(+list, +list, -list), one).
	:- info(left_trim/3, [
		comment is 'Trim elements of `TrimList` from the beginning of `Input` list until an element not in `TrimList` is encountered to create `Output` list.',
		argnames is ['Input', 'TrimList', 'Output']
	]).

	:- public(repeated_codes/1).
	:- mode(repeated_codes(+list), one).
	:- info(repeated_codes/1, [
		comment is 'Check that `Codes` is all the same character.',
		argnames is ['Codes']
	]).

	:- public(repeated_codes/2).
	:- mode(repeated_codes(+list, +integer), one).
	:- info(repeated_codes/2, [
		comment is 'Check that `Codes` is all the same character `Code`.',
		argnames is ['Codes', 'Code']
	]).
	
	
	:- uses(list, [memberchk/2]).

	/*------------------------------------------------------------------*/

	trim( [], _,  []).
	trim( [C0 | Cs0], TrimCs, Cs1) :-
	          (memberchk(C0, TrimCs)
	            -> Cs1 = OtherCs1
	           ;
	           Cs1 =  [C0 | OtherCs1]
	          ),
	          trim(Cs0, TrimCs, OtherCs1).


    /*------------------------------------------------------------------*/

  	left_trim( [], _,  []).
  	left_trim( [C0 | Cs0], TrimCs, Cs1) :-
  	          (memberchk(C0, TrimCs)
  	            -> Cs1 = OtherCs1,
  	          	   left_trim(Cs0, TrimCs, OtherCs1)
  	           ;
  	           Cs1 =  [C0 | Cs0]
  	          ).

	/*------------------------------------------------------------------*/

	repeated_codes( [C | Cs]) :-
	          repeated_codes(Cs, C).
			  
	repeated_codes( [], _).
	repeated_codes( [C | Cs], C) :-
	          repeated_codes(Cs, C).

:- end_object.
