:- object(fp_repeated_characters).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for repeated characters for format prolog system.'
	]).

	:- public(repeated_charactersDCTG/3).
	:- mode(repeated_charactersDCTG(-term, +list, -list), one).
	:- info(repeated_charactersDCTG/3, [
		comment is 'Parse `Tokens` as a repeated characters to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- uses(fpu_string, [repeated_codes/2]).
	
	/*------------------------------------------------------------------*/
	/* repeated_characters "consumes" a "token" (t) item which consists of
	   a character repeated any number of times, or a sequence of "punctuation"
	   (p) items which are identical.
	   */  
	repeated_characters ::=
	           [t( [C | Cs])],
	          {repeated_codes(Cs, C)},
	          repeated_characters(t, C).

	repeated_characters ::=
	           [p(C), p(C)],
	          repeated_characters(p, C).

	repeated_characters(t, C) ::=
	           [t( [C | Cs])],
	          {repeated_codes(Cs, C)},
	          !,
	          repeated_characters(t, C).

	repeated_characters(p, C) ::=
	           [p(C)],
	          !,
	          repeated_characters(p, C).

	repeated_characters(_, _) ::=
	           [].

:- end_object.


