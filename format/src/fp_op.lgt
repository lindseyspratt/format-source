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


:- object(fp_op).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-24,
		comment is 'Miscellaneous utilities for format-prolog system.'
	]).

	:- public(opDCTG/6).
	:- mode(opDCTG(+integer, +atom, -integer, -term, +list, -list), one).
	:- info(opDCTG/6, [
		comment is 'Determines the operator info.',
		argnames is ['Context', 'Prec', 'Associativity', 'Tree', 'Tokens', 'Remainder']
	]).

	:- uses(fpu_known_op, [known_op/4]).
	:- uses(fpu_output_position, [pos/1, fp_write/1]).
	:- uses(list, [append/3, length/2]).

	/*------------------------------------------------------------------*/

	op(Context, Prec, Associativity) ::=
		op_token( [], Ocs),
		{	atom_codes(Op, Ocs),
			known_op(Prec, Associativity, Op, Context),
			(	Ocs = ":-"
			->	Functor = '*NECK*'
			;	Functor = Op
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
		{Ncs =  [C],
		 [C] \= "." },
		!.

	op_token1(Ncs) ::=
		[t(Ncs)].

:- end_object.
