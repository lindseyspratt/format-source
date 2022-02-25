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


:- object(fpu_miscellaneous).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'Miscellaneous utilities for format-prolog system.'
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
		comment is 'Extends the context when ``NewContext`` is `expression`, leaves it unchanged otherwise.',
		argnames is ['OldContext', 'NewContext', 'ExtendedContext']
	]).
	
	%------------------------------------------------------------------

	precedence_constraint(Prec0, Comp, Prec1) :-
		Goal =..  [Comp, Prec0, Prec1],
		call(Goal).


	extend_context(clause, expression, clause) :- !.
	extend_context(OldContext, expression, expression) :-
		OldContext \= clause,
		!.
	extend_context(_, NewContext, NewContext) :-
		NewContext \= expression.

:- end_object.