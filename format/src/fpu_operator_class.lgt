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


:- object(fpu_operator_class).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'Operator class for format prolog system.'
	]).

	:- public(operator_class/3).
	:- mode(operator_class(+atom, +atom, -atom), one).
	:- info(operator_class/3, [
		comment is 'Bind the `Class` of an `Operator` in a particular `Context`. The `Context` is either `clause` or something else (e.g. `term`). The `Class` is `neck`, `conjunction`, `disjunction(1)`, `dependent_clause`, or `general`.',
		argnames is ['Operator', 'Context', 'Class']
	]).

	:- uses(fpu_node_evaluation, [read_operator_class/3]).
	
	/*------------------------------------------------------------------*/

	operator_class(Opf, Context, Class) :-
		read_operator_class(Opf, Context, Class)
		 -> true
		;
		Context \= clause
		 -> Class = general
		;
		(Opf == '*NECK*'
		 ;
		 Opf == ('-->')
		 ;
		 Opf == ('::=')
		 ;
		 Opf == ('::-')
		)-> Class = neck
		;
		Opf == (',')
		 -> Class = conjunction
		;
		(Opf == ('|')
		 ;
		 Opf == (';')
		)-> Class = disjunction(1)
		;
		(Opf == ('->')
		 ;
		 Opf == ('<:>')
		)-> Class = dependent_clause
		;
		Class = general.

:- end_object.

