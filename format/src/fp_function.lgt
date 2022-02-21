:- object(fp_function).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'DCTG for structure function for format prolog system.'
	]).

	:- public(functionDCTG/3).
	:- mode(functionDCTG(-term, +list, -list), one).
	:- info(functionDCTG/3, [
		comment is 'Parse `Tokens` as a Prolog structure function to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).


	:- uses(fpu_output_position, [pos/1, fp_write/1]).

	/*------------------------------------------------------------------*/

	function ::=
	           [t(FunctionCodes)],
	          {atom_codes(Function, FunctionCodes),
	           length(FunctionCodes, Len)
	          }
	 <:> (display(Col) ::-
	                pos(Col),
	                fp_write(Function)
	     ),
	     (len(Len)),
	     (functor(Function)).

:- end_object.
