:- object(fp_comment).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for a Prolog comment for format prolog system.'
	]).

	:- public(commentDCTG/3).
	:- mode(commentDCTG(-term, +list, -list), one).
	:- info(commentDCTG/3, [
		comment is 'Parse `Tokens` as a Prolog comment to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).
	
	:- uses(list, [member/2]).
	:- uses(fpu_display, [display_comment/3]).
	:- uses(fp_whitespace_handling, [wlsDCTG/3]).
	:- uses(fp_comment_body, [comment_bodyDCTG/4, comment_startDCTG/5]).

	/*------------------------------------------------------------------*/
	/* A comment has one of two forms, as indicated by comment_start.  It 
	   either begins with a / * and ends with a * / or it begins with a % 
	   and ends with a newline.
	   */  
	comment ::=
	          comment_start(Start, End),
	          wls,
	          !,
	          comment_body(End) ^^ B
	 <:> display(Col) ::-
	               display_comment(Col, Start, B).

:- end_object.

