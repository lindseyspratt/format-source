:- object(fp_comments).

	:- public(commentsDCTG/3).
	:- mode(commentsDCTG(-term, +list, -list), one).
	:- info(commentsDCTG/3, [
		comment is 'Parse `Tokens` as a collection of Prolog comments to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- uses(fpu_output_position, [fp_write/1]).
	:- uses(fp_whitespace_handling, [wlsDCTG/3]).
	:- uses(fp_comment, [commentDCTG/3]).
	:- uses(fp_trivial_comment, [trivial_commentDCTG/3]).
	
	dctg_main(comments/0, display/1).
	
	/* comments are broadly considered to be any number of comments 
	preceded by any amount of whitespace, separated by any amount of whitespace, 
	and followed by any amount of whitespace.
	*/

	comments ::=
	  decoration,
	  comments_no_ws ^^ C,
	  !
	  <:> display(Col) ::-
	         C ^^ display(Col).

	comments_no_ws ::=
	  comment ^^ C,
	  !,
	  comments ^^ L
	  <:> display(Col) ::-
	         C ^^ display(Col),
	         fp_write(' '),
	         L ^^ display(Col).
	comments_no_ws ::=
	  []
	  <:> display(_).


	/* A decoration is a special kind of comment - one consisting of only a trivial comment, 
	preceded by any amount of whitespace and followed by any amount of whitespace.
	*/

	decoration ::=
	  wls,
	  trivial_comment,
	  wls.

:- end_object.
