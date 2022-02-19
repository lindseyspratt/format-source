:- object(fpl_chars).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'character types for the format prolog source system lexical analysis.'
	]).

	ws_char(32). /* blank */
	ws_char(9). /* tab */
	ws_char(13). /* carriage return */
	ws_char(10). /* linefeed */

	punctuation_char(46). /* period '.' */
	punctuation_char(44). /* comma ',' */
	punctuation_char(124). /*  '|' */
	punctuation_char(40). /* '(' */
	punctuation_char(41). /* ')' */
	punctuation_char(91). /* '[' */
	punctuation_char(93). /* '[' */
	punctuation_char(123). /* '{' */
	punctuation_char(125). /* '}' */

	token_char(X, graphic) :-
	  33 =< X,
	  X =< 39.
	token_char(42, graphic).
	token_char(43, graphic).
	token_char(45, graphic).
	token_char(47, graphic).
	token_char(X, alphanumeric) :-
	  /* '0' - '9' */
	  48 =< X, 
	  X =< 57,
	  !.
	token_char(X, graphic) :-
	/* ':', ';', <, =, >, ?, @ */
	  58 =< X,
	  X =< 64,
	  !.
	token_char(X, alphanumeric) :- /* A-Z */
	  65 =< X,
	  X =< 90,
	  !.
	token_char(92, graphic). /* \ */
	token_char(94, graphic). /* ^ */
	token_char(95, alphanumeric). /* _ */
	token_char(96, graphic). /* ` */
	token_char(X, alphanumeric) :- /* a-z */
	  97 =< X,
	  X =< 122,
	  !.
	token_char(X, graphic) :-
	  126 =< X,
	  X =< 127,
	  !.
	token_char(X, alphanumeric) :-
	  128 =< X,
	  X =< 159,
	  !.
	token_char(X, graphic) :-
	  160 =< X,
	  !.

:- end_object.
