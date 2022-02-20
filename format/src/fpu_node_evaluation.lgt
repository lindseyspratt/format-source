:- object(fpu_node_evaluation, 
	imports([dctg_evaluate])).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Utilities for nodes in the annotated abstract syntax tree for format prolog system.'
	]).

	:- public(read_operator_class/3).
	:- mode(read_operator_class(+atom, +atom, +atom), one).
	:- info(read_operator_class/3, [
		comment is 'Unifies with the recorded fact `Op`, `Context`, and `Class` for the operator class.',
		argnames is ['Op', 'Context', 'Class']
	]).
	
	:- dynamic('format_prolog$read_op'/3).
	:- dynamic('format_prolog$read_operator_class'/3).
	
	^^(A, B) :- ::eval(A, B).

	/*------------------------------------------------------------------*/

	eval_clause(T) :-
	          T ^^ args( [Goal]),
	          eval_goal(Goal).



	/*------------------------------------------------------------------*/

	eval_conj(Conj) :-
	          Conj ^^ args(Args),
	          (Args =  [First, Second]
	            -> eval_goal(First),
	               eval_goal(Second)
	           ;
	           [Goal] = Args,
	           eval_goal(Goal)
	          ).



	/*------------------------------------------------------------------*/

	eval_goal(Goal) :-
	          Goal ^^ functor(Functor),
	          (Functor = ','
	           /* conjunction */  
	            -> eval_conj(Goal)
	           ;
	           Functor = op
	            -> eval_op(Goal)
	           ;
	           Functor = opclass
	            -> eval_opclass(Goal)
	           ;
	           true
	          ).



	/*------------------------------------------------------------------*/

	eval_op(OpGoal) :-
	          OpGoal ^^ args( [PrecNode, AssocNode, OpNode]),
	          PrecNode ^^ functor(Prec),
	          AssocNode ^^ functor(Assoc),
	          OpNode ^^ functor(Op),
	          record_read_op(Prec, Assoc, Op).



	/*------------------------------------------------------------------*/

	read_op(Prec, Assoc, Op) :-
	          'format_prolog$read_op'(Prec, Assoc, Op).



	/*------------------------------------------------------------------*/

	record_read_op(Prec, Assoc, Op) :-
	          retractall('format_prolog$read_op'(_, Assoc, Op)),
	          assertz('format_prolog$read_op'(Prec, Assoc, Op)).



	/*------------------------------------------------------------------*/

	eval_opclass(OpclassGoal) :-
	          OpclassGoal ^^ args( [OpNode, ContextNode, ClassNode]),
	          OpNode ^^ functor(Op),
	          ClassNode ^^ functor(Class),
	          ContextNode ^^ functor(Context),
	          record_read_operator_class(Op, Context, Class).



	/*------------------------------------------------------------------*/

	read_operator_class(Op, Context, Class) :-
	          'format_prolog$read_operator_class'(Op, Context, Class).



	/*------------------------------------------------------------------*/

	record_read_operator_class(Op, Context, Class) :-
	          retractall('format_prolog$read_operator_class'(Op, Context, _)),
	          assertz('format_prolog$read_operator_class'(Op, Context, Class)).


:- end_object.

