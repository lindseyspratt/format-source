%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Copyright (c) 2022 Lindsey Spratt
%  SPDX-License-Identifier: MIT
%
%  Licensed under the MIT License (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%
%      https://opensource.org/licenses/MIT
%
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(fpu_node_evaluation,
	imports([dctg_evaluate])).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'Utilities for handling format-specific operator information at format-time in the annotated abstract syntax tree for format-prolog system.'
	]).

	:- public(eval_clause/1).
	:- mode(eval_clause(+term), one).
	:- info(eval_clause/1, [
		comment is 'Evaluates annotated abstract syntax tree ``Clause``.',
		argnames is ['Clause']
	]).

	:- public(eval_conj/1).
	:- mode(eval_conj(+term), one).
	:- info(eval_conj/1, [
		comment is 'Evaluates annotated abstract syntax tree ``Conjunction``.',
		argnames is ['Conjunction']
	]).

	:- public(eval_goal/1).
	:- mode(eval_goal(+term), one).
	:- info(eval_goal/1, [
		comment is 'Evaluates annotated abstract syntax tree ``Goal``.',
		argnames is ['Goal']
	]).

	:- public(eval_op/1).
	:- mode(eval_op(+term), one).
	:- info(eval_op/1, [
		comment is 'Evaluates annotated abstract syntax tree ``Op``, recording the operator definition.',
		argnames is ['Op']
	]).

	:- public(eval_opclass/1).
	:- mode(eval_op(+term), one).
	:- info(eval_op/1, [
		comment is 'Evaluates annotated abstract syntax tree ``OpClass``, recording the operator class.',
		argnames is ['OpClass']
	]).

	:- public(read_op/3).
	:- mode(read_op(+atom, +atom, +atom), one).
	:- info(read_op/3, [
		comment is 'Unifies with the recorded fact ``Prec``, ``Assoc``, and ``Op`` for the operator.',
		argnames is ['Op', 'Context', 'Class']
	]).

	:- public(read_operator_class/3).
	:- mode(read_operator_class(+atom, +atom, +atom), one).
	:- info(read_operator_class/3, [
		comment is 'Unifies with the recorded fact ``Op``, ``Context``, and ``Class`` for the operator class.',
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
		(	Args =  [First, Second]
		->	eval_goal(First),
			eval_goal(Second)
		;	[Goal] = Args,
			eval_goal(Goal)
		).



	/*------------------------------------------------------------------*/

	eval_goal(Goal) :-
		Goal ^^ functor(Functor),
		(	Functor = (',')
			/* conjunction */
		->	eval_conj(Goal)
		;	Functor = op
		->	eval_op(Goal)
		;	Functor = opclass
		->	eval_opclass(Goal)
		;	true
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
