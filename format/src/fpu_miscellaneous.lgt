:- object(fpu_miscellaneous).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Miscellaneous utilities for format prolog system.'
	]).

	:- public(precedence_constraint/3).
	:- mode(precedence_constraint(+integer, +atom, -integer), one).
	:- info(precedence_constraint/3, [
		comment is 'Determines the operator precedence.',
		argnames is ['Prec0', 'Comp', 'Prec1']
	]).

	:- public(extend_context/3).
	:- mode(extend_context(+atom, +atom, -atom), one).
	:- info(extend_context/3, [
		comment is 'Extends the context when `NewContext` is `expression`, leaves it unchanged otherwise.',
		argnames is ['OldContext', 'NewContext', 'ExtendedContext']
	]).

	:- dynamic('format_prolog$read_op'/3).
	:- dynamic('format_prolog$read_operator_class'/3).
	
	%------------------------------------------------------------------

	precedence_constraint(Prec0, Comp, Prec1) :-
	          Goal =..  [Comp, Prec0, Prec1],
	          call(Goal).


	%------------------------------------------------------------------

	retract_read_info :-
	          retractall('format_prolog$read_op'(_, _, _)),
	          retractall('format_prolog$read_operator_class'(_, _, _)).


	extend_context(clause, expression, clause) :- !.
	extend_context(OldContext, expression, expression) :-
	          OldContext \= clause,
	          !.
	extend_context(_, NewContext, NewContext) :-
	          NewContext \= expression.
		  
:- end_object.