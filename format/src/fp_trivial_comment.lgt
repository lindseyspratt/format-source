:- object(fp_trivial_comment).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for a trivial Prolog comment for format prolog system.'
	]).

	:- public(trivial_commentDCTG/3).
	:- mode(trivial_commentDCTG(-term, +list, -list), one).
	:- info(trivial_commentDCTG/3, [
		comment is 'Parse `Tokens` as a trivial Prolog comment to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).
	
	:- uses(fp_whitespace_handling, [wlsDCTG/3]).
	:- uses(fp_comment_body, [comment_startDCTG/5, comment_endDCTG/4, comment_body_wlsDCTG/4]).
	:- uses(fp_repeated_characters, [repeated_charactersDCTG/3]).

/*------------------------------------------------------------------*/
/* A trivial_comment is a string of any number of occurrences of the same
   character.
   */  
trivial_comment ::=
          comment_start(_, End),
          wls,
          trivial_comment_body(End),
          !.

trivial_comment ::=
           [].



/*------------------------------------------------------------------*/

trivial_comment_body(End) ::=
          repeated_characters,
          comment_body_wls(End),
          comment_end(End),
          !.

trivial_comment_body(End) ::=
          comment_body_wls(End),
          comment_end(End),
          !.

:- end_object.


