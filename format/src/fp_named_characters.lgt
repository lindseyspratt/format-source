:- object(fp_named_characters).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for a named characters for format prolog system.'
	]).

	:- public(lparenDCTG/3).
	:- mode(lparenDCTG(-term, +list, -list), one).
	:- info(lparenDCTG/3, [
		comment is 'Parse `Tokens` as a left parenthesis to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(rparenDCTG/3).
	:- mode(rparenDCTG(-term, +list, -list), one).
	:- info(rparenDCTG/3, [
		comment is 'Parse `Tokens` as a right parenthesis to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(lbraceDCTG/3).
	:- mode(lbraceDCTG(-term, +list, -list), one).
	:- info(lbraceDCTG/3, [
		comment is 'Parse `Tokens` as a left brace `{` to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(rbraceDCTG/3).
	:- mode(rbraceDCTG(-term, +list, -list), one).
	:- info(rbraceDCTG/3, [
		comment is 'Parse `Tokens` as a right brace `}` to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(lbracketDCTG/3).
	:- mode(lbracketDCTG(-term, +list, -list), one).
	:- info(lbracketDCTG/3, [
		comment is 'Parse `Tokens` as a left bracket `[` to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(rbracketDCTG/3).
	:- mode(rbracketDCTG(-term, +list, -list), one).
	:- info(rbracketDCTG/3, [
		comment is 'Parse `Tokens` as a right bracket `]` to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(commaDCTG/3).
	:- mode(commaDCTG(-term, +list, -list), one).
	:- info(commaDCTG/3, [
		comment is 'Parse `Tokens` as a comma to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(periodDCTG/3).
	:- mode(periodDCTG(-term, +list, -list), one).
	:- info(periodDCTG/3, [
		comment is 'Parse `Tokens` as a period to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(vertbarDCTG/3).
	:- mode(vertbarDCTG(-term, +list, -list), one).
	:- info(vertbarDCTG/3, [
		comment is 'Parse `Tokens` as a vertical bar `|` to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	/* Below are several nonterminals which parse a single character
	    token.
	   */  

	/*------------------------------------------------------------------*/

	lparen ::={ [C] = "("},
	           [p(C)].



	/*------------------------------------------------------------------*/

	rparen ::={ [C] = ")"},
	           [p(C)].



	/*------------------------------------------------------------------*/

	lbrace ::={ [C] = "{"},
	           [p(C)].



	/*------------------------------------------------------------------*/

	rbrace ::={ [C] = "}"},
	           [p(C)].



	/*------------------------------------------------------------------*/

	lbracket ::=
	          { [C] = "["},
	           [p(C)].



	/*------------------------------------------------------------------*/

	rbracket ::=
	          { [C] = "]"},
	           [p(C)].



	/*------------------------------------------------------------------*/

	comma ::= { [C] = ","},
	           [p(C)].



	/*------------------------------------------------------------------*/

	period ::={ [C] = "."},
	           [p(C)].



	/*------------------------------------------------------------------*/

	vertbar ::=
	          { [C] = "|"},
	           [p(C)].

:- end_object.
