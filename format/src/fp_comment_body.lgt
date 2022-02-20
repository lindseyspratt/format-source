:- object(fp_comment_body).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for a Prolog comment body for format prolog system.'
	]).

	:- public(comment_bodyDCTG/4).
	:- mode(comment_bodyDCTG(+term, -term, +list, -list), one).
	:- info(comment_bodyDCTG/4, [
		comment is 'Parse `Tokens` as a Prolog comment given the comment `End` and create the annotated abstract syntax tree `Tree`.',
		argnames is ['End', 'Tree', 'Tokens', 'Remainder']
	]).

	:- public(comment_body_wlsDCTG/4).
	:- mode(comment_body_wlsDCTG(+term, -term, +list, -list), one).
	:- info(comment_body_wlsDCTG/4, [
		comment is 'Parse `Tokens` as a Prolog comment whitespace based on the `End` input and create the annotated abstract syntax tree `Tree`.',
		argnames is ['End', 'Tree', 'Tokens', 'Remainder']
	]).

	:- public(comment_startDCTG/5).
	:- mode(comment_startDCTG(-term, -term, -term, +list, -list), one).
	:- info(comment_startDCTG/5, [
		comment is 'Parse `Tokens` as a Prolog comment to determine the comment `Start` and `End` and create the annotated abstract syntax tree `Tree`.',
		argnames is ['Start', 'End', 'Tree', 'Tokens', 'Remainder']
	]).

	:- public(comment_endDCTG/4).
	:- mode(comment_endDCTG(-term, -term, +list, -list), one).
	:- info(comment_endDCTG/4, [
		comment is 'Parse `Tokens` as a Prolog comment `End` and create the annotated abstract syntax tree `Tree`.',
		argnames is ['End', 'Tree', 'Tokens', 'Remainder']
	]).
	
	:- uses(fpu_display, [display_comment_end/3]).
	:- uses(fp_whitespace_handling, [wlsDCTG/3, nnl_wlsDCTG/3]).
	:- uses(fp_format_directives, [start_skip_directiveDCTG/3, end_skip_directiveDCTG/3]).
	:- uses(fp_comment_items, [nls_itemDCTG/3, skip_itemDCTG/3]).
	

	/*------------------------------------------------------------------*/
	/* comment_body(End) - parses the contents of a comment, starting after
	   the comment start indicator, and continuing up to and including the
	   comment end indicator.
	   */  
	comment_body(End) ::=
	          comment_body_wls(End),
	          comment_end(End),
	          !
	 <:> display(StartLine, Col) ::-
	               display_comment_end(StartLine, Col, t("*/")).

	comment_body(End) ::=
	          start_skip_directive ^^ S,
	          comment_body_skip(End, NewEnd) ^^ Cs,
	          comment_body(NewEnd) ^^ Cb
	 <:> display(StartLine, Col) ::-
	               S ^^ display,
	               Cs ^^ display,
	               Cb ^^ display(StartLine, Col).

	comment_body(End) ::=
	          nls_item ^^ H,
	          comment_body(End) ^^ C
	 <:> display(StartLine, Col) ::-
	               H ^^ display(Col),
	               C ^^ display(StartLine, Col).


	/*------------------------------------------------------------------*/

	comment_body_wls(nl) ::=
	          !,
	          nnl_wls.

	comment_body_wls(_) ::=
	          wls.


	/*------------------------------------------------------------------*/
	/* The skip can start in a comment of one kind and end in a comment of
	   the other kind.  Eg, the skip can start in a multiline comment and 
	   end in an end-of-line comment.  Thus, the end-of-comment delimiter 
	   which was true when the skip started may not be true when the skip 
	   ends.
	   */  
	comment_body_skip(End0, End1) ::=
	          comment_end(End0),
	          !,
	          comment_body_skip(none, End1) ^^ Cbs
	 <:> display ::-
	               display_item(1, End0),
	               Cbs ^^ display.

	comment_body_skip(none, End1) ::=
	          comment_start(Start, End0),
	          !,
	          comment_body_skip(End0, End1) ^^ Cbs
	 <:> display ::-
	               display_item(1, Start),
	               Cbs ^^ display.

	comment_body_skip(End, End) ::=
	          end_skip_directive ^^ S,
	          !
	 <:> display ::-
	               S ^^ display.

	comment_body_skip(End0, End1) ::=
	          skip_item ^^ H,
	          !,
	          comment_body_skip(End0, End1) ^^ Cbs
	 <:> display ::-
	               H ^^ display,
	               Cbs ^^ display.


   	/*------------------------------------------------------------------*/

   	comment_start(t("/*"), t("*/")) ::=
   	           [t("/*")].

   	comment_start(t("%"), nl) ::=
   	           [t("%")].


   	/*------------------------------------------------------------------*/

   	comment_end(t("*/")) ::=
   	           [t("*/")].

   	comment_end(nl) ::=
   	           [w(Codes)],
   	          {member(10, Codes)
   	           ;
   	           member(13, Codes)
   	          }.

:- end_object.


