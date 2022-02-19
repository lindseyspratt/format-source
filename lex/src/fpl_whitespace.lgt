:- object(fpl_whitespace).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'whitespace grammar for the format prolog source system lexical analysis.'
	]).

	:- public(whitespace//3).
	:- mode(whitespace(-list, +atom, -atom), one).
	:- info(whitespace//3, [
		comment is 'Parse the beginning of a list of codes into a list of whitespace codes, updating the ModeIn to ModeOut where a mode is `comment` or `code`.',
		argnames is ['SourceFile', 'Tokens']
	]).

	:- uses(fpl_chars, [ws_char/1, punctuation_char/1]).
	:- uses(list, [member/2]).
	
	/* Only one newline is allowed in a whitespace token, and it must be the first code in the token. This is the first code. 
	If another newline is encountered, it must be placed in a separate whitespace token.
	*/

	whitespace([H|T], ModeIn, ModeOut) -->
	  wsc(H),
	  ws_list(T),
	  {ModeIn = comment([Code]),
	    member(Code, [H|T])
	     -> ModeOut = code
	   ; ModeOut = ModeIn}.

	ws_list([H|T]) -->
	  wsc(H),
	  {[H] \= "
	"},
	  ws_list(T).
	ws_list([]) --> [].

	wsc(Char) -->
	  [Char],
	  {ws_char(Char)}.

	punctuation(Quote, comment(_)) -->
	  {[Quote] = "'" ; [Quote] = """"},
	  [Quote],
	  !.
	punctuation(X, _) -->
	  [X],
	  {punctuation_char(X)}.

:- end_object.
