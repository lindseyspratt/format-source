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


:- object(fpu_known_op).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
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
		  -> Op \== (',')
		 ; true
		),
		atom(Op),
		current_op(Prec, Assoc, Op),
		\+read_op(_, Assoc, Op).

:- end_object.
