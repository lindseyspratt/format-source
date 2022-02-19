:- object(fpl_quoted_char_list).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'whitespace grammar for the format prolog source system lexical analysis.'
	]).

	:- public(quoted_char_list//2).
	:- mode(quoted_char_list(+integer, -list), one).
	:- info(quoted_char_list//2, [
		comment is 'Parse the beginning of a list of codes into a list of quoted string codes that ends with the specified `Quote` code.',
		argnames is ['Quote', 'Codes']
	]).

	quoted_char_list(Quote, [Quote, Quote|OtherCodes]) -->
	  [Quote],
	  [Quote],
	  !,
	  quoted_char_list(Quote, OtherCodes).
	quoted_char_list(Quote, [Quote]) -->
	  [Quote],
	  !.
	quoted_char_list(Quote, [Code|OtherCodes]) -->
	  [Code],
	  quoted_char_list(Quote, OtherCodes).
  
:- end_object.
