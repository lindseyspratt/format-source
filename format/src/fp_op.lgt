:- object(fp_op).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Miscellaneous utilities for format prolog system.'
	]).

	:- public(opDCTG/6).
	:- mode(opDCTG(+integer, +atom, -integer, -term, +list, -list), one).
	:- info(opDCTG/6, [
		comment is 'Determines the operator info.',
		argnames is ['Context', 'Prec', 'Associativity', 'Tree', 'Tokens', 'Remainder']
	]).

	:- uses(fpu_known_op, [known_op/4]).
	:- uses(fpu_output_position, [pos/1, fp_write/1]).

	/*------------------------------------------------------------------*/

	op(Context, Prec, Associativity) ::=
	          op_token( [], Ocs),
	          {atom_codes(Op, Ocs),
	           known_op(Prec, Associativity, Op, Context),
	           (Ocs = ":-"
	             -> Functor = '*NECK*'
	            ;
	            Functor = Op
	           ),
	           length(Ocs, Lo),
	           Len is Lo + 1
	          }
	 <:> (display(Col) ::-
	                pos(Col),
	                fp_write(Op)
	     ),
	     (len(Len)),
	     (functor(Functor)).



	/*------------------------------------------------------------------*/

	op_token(Cs, Ocs) ::=
	          op_token1(Ncs),
	          {append(Cs, Ncs, Ics)},
	          op_token(Ics, Ocs).

	op_token(Cs, Cs) ::=
	           [].



	/*------------------------------------------------------------------*/

	op_token1(Ncs) ::=
	           [p(C)],
	          {Ncs =  [C]},
	          !.

	op_token1(Ncs) ::=
	           [t(Ncs)].

:- end_object.


