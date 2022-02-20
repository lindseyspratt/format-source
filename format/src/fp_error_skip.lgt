:- object(fp_error_skip).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for a named characters for format prolog system.'
	]).

	:- public(error_skipDCTG/4).
	:- mode(error_skipDCTG(+term, -term, +list, -list), one).
	:- info(error_skipDCTG/4, [
		comment is 'Parse `Tokens` `SkipToken` is found to create the annotated abstract syntax tree `Tree`.',
		argnames is ['SkipToken', 'Tree', 'Tokens', 'Remainder']
	]).
	
	:- uses(fpu_display_item, [display_item/2]).

	error_skip(SkipToken) ::=
	          [SkipToken],
	          !
	    <:> display ::- display_item(1, SkipToken).

	error_skip(SkipToken) ::=
	          [Token],
	          {Token \= SkipToken},
	          error_skip1(SkipToken, Tokens)
	    <:> display ::-
	          display_item(1, Token),
	          display_item_list(Tokens, 1).


	error_skip1(SkipToken, [SkipToken]) ::=
	          [SkipToken],
	          !.

	error_skip1(SkipToken, [Token|OtherTokens]) ::=
	          [Token],
	          {Token \= SkipToken},
	          error_skip1(SkipToken, OtherTokens).

	error_skip1(_SkipToken, [t("END OF SOURCE")]) ::= [].

:- end_object.
