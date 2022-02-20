:- object(fp_whitespace_handling).

	:- public(wlsDCTG/3).
	:- mode(wlsDCTG(-term, +list, -list), one).
	:- info(wlsDCTG/3, [
		comment is 'Parse `Tokens` as whitespace to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- uses(list, [member/2,memberchk/2]).
	
	/*------------------------------------------------------------------*/
	/* wls parses a list of whitespace.  The "w" token ("w(X)") is a list 
	   of whitespace characters, where all of the characters in a token are
	   the same.
	   */  
	wls ::=    [w(_)],
	          !,
	          wls.

	wls ::=    [].



	/*------------------------------------------------------------------*/
	/* nnl_wls parses a list of whitespace characters, none of which is a 
	   carriage return (13) or linefeed (10).
	   */  
	nnl_wls ::=
	           [w(Cs)],
	          {\+member(10, Cs),
	           \+member(13, Cs)
	          },
	          !,
	          nnl_wls.

	nnl_wls ::=
	           [].



	/*------------------------------------------------------------------*/
	/* blank_lines parses a list of blank lines.  A blank line is whitespace
	   from the beginning of a line (ie, the first character after a newline
	   character) to the next newline character.
	   */  
	blank_lines ::=
	          nnl_wls,
	           [w(Codes)],
	          {member(10, Codes)
	           ;
	           member(13, Codes)
	          },
	          blank_lines1.



	/*------------------------------------------------------------------*/

	blank_lines1 ::=
	          nnl_wls,
	           [w(Codes)],
 	          {member(10, Codes)
 	           ;
 	           member(13, Codes)
 	          },
	          !,
	          blank_lines1.

	blank_lines1 ::=
	           [].



	/*------------------------------------------------------------------*/
	/* any_blanks parses a blank whitespace token (which is a list of blank
	   chars (32)), or the empty token (ie no token at all). Thus, it always
	   succeeds (once).
	   */  
	any_blanks ::=
	           [w(Codes)],
	          { [Code] = " ",
	           memberchk(Code, Codes)
	          },
	          !.

	any_blanks ::=
	           [].
			   
:- end_object.


