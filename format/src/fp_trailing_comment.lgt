:- object(fp_trailing_comment).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for a trivial Prolog comment for format prolog system.'
	]).

	:- public(trailing_commentDCTG/3).
	:- mode(trailing_commentDCTG(-term, +list, -list), one).
	:- info(trailing_commentDCTG/3, [
		comment is 'Parse `Tokens` as a trailing Prolog comment to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).
	
	:- uses(fp_whitespace_handling, [nnl_wlsDCTG/3]).
	:- uses(fp_comment, [commentDCTG/3]).

	/*------------------------------------------------------------------*/
	/* A trailing comment is a comment preceded by any amount of non-newline
	   whitespace.
	   */  
	trailing_comment ::=
	          nnl_wls,
	          comment ^^ C,
	          !
	 <:> display(Col) ::-
	               C ^^ display(Col).

	trailing_comment ::=
	           []
	 <:> display(_).

:- end_object.
