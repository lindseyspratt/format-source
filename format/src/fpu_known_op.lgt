:- object(fpu_known_op).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Display items for format prolog system.'
	]).

	:- public(known_op/4).
	:- mode(known_op(+integer, +atom, +atom, +atom), one).
	:- info(known_op/4, [
		comment is 'Determine a known operator.',
		argnames is ['Prec', 'Assoc', 'Op', 'Context']
	]).
	
	:- uses(fpu_node_evaluation, [read_op/3]).

	/*------------------------------------------------------------------*/

	known_op(1100, xfy, '|', Context) :-
	          Context \== list.

	known_op(Prec, Assoc, Op, _) :-
	          read_op(Prec, Assoc, Op).

	% Contexts are 'clause',  'expression', 'argls', 'list'.

	known_op(Prec, Assoc, Op, Context) :-
	          ((Context == argls; Context == list)
	            -> Op \== ','
	           ; true
	          ),
	          atom(Op),
	          current_op(Prec, Assoc, Op),
	          \+read_op(_, Assoc, Op).

:- end_object.


