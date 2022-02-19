:- object(fpl_token).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'token grammar for the format prolog source system lexical analysis.'
	]).

	:- public(token//3).
	:- mode(token(-list, +atom, -atom), one).
	:- info(token//3, [
		comment is 'Parse the beginning of a list of codes into a list of token codes, updating the ModeIn to ModeOut where a mode is `comment` or `code`.',
		argnames is ['Codes', 'ModeIn', 'ModeOut']
	]).

	:- uses(fpl_quoted_char_list, [quoted_char_list//2]).
	:- uses(fpl_chars, [token_char/2]).
	
	/* The start of a comment is forced to be an entire token, even if it's immediately followed by (more) "graphic" characters. ("/" and "*" are both "graphic" type characters.)
	*/

	token([Quote|X], code, code) -->
	  {[Quote] = "'" ; [Quote] = """"},
	  [Quote],
	  !,
	  quoted_char_list(Quote, X).
	token(Special, ModeIn, ModeOut) -->
	  {Special = "/*",
	    Special = [C1,C2]},
	  [C1,C2],
	  !,
	  {ModeIn = code
	       -> ModeOut = comment("*/")
	   ; ModeOut = ModeIn}.
	token(Special, ModeIn, ModeOut) -->
	  {Special = "%",
	    Special = [C]},
	  [C],
	  !,
	  {ModeIn = code
	       -> ModeOut = comment("
	")
	   ; ModeOut = ModeIn}.
	token(Special, ModeIn, ModeOut) -->
	  {Special = "*/",
	    Special = [C1,C2]},
	  [C1,C2],
	  !,
	  {ModeIn = comment(Special)
	       -> ModeOut = code
	   ; ModeOut = ModeIn}.
	token([H|T], Mode, Mode) -->
	  tokenc(Type, H),
	  token_ls(Type, T).

	token_ls(Type, [H|T]) -->
	  tokenc(Type, H),
	  !,
	  token_ls(Type, T).
	token_ls(_, []) --> [].

	tokenc(_, _) -->
	  "/*",
	  {!, fail}.
	tokenc(_, _) -->
	  "*/",
	  {!, fail}.
	tokenc(Type, X) -->
	  [X],
	  {token_char(X, Type)}.

:- end_object.
