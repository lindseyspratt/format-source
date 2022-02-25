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


:- object(fp_format_directives).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'DCTG for a Prolog comment body for format-prolog system.'
	]).

	:- public(start_skip_directiveDCTG/3).
	:- mode(start_skip_directiveDCTG(-term, +list, -list), one).
	:- info(start_skip_directiveDCTG/3, [
		comment is 'Parse ``Tokens`` as a Prolog ``start`` skip directive to create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(end_skip_directiveDCTG/3).
	:- mode(end_skip_directiveDCTG(-term, +list, -list), one).
	:- info(end_skip_directiveDCTG/3, [
		comment is 'Parse ``Tokens`` as a Prolog ``end`` skip directive to create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

/*	:- public(format_directiveDCTG/3).
	:- mode(format_directiveDCTG(-term, +list, -list), one).
	:- info(format_directiveDCTG/3, [
		comment is 'Parse ``Tokens`` as a Prolog format directive to create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).
*/
	:- uses(fpu_output_position, [adjusted_pos/3, fp_write/1]).
%	:- uses(fpu_node_evaluation, [eval_goal/1]).
%	:- uses(fp_whitespace_handling, [wlsDCTG/3]).
	
	/*------------------------------------------------------------------*/

	start_skip_directive ::=
		format_key ^^ F,
		[t("off"), t("$")]
	 <:> display ::-
			F ^^ display,
			fp_write('off$').



	/*------------------------------------------------------------------*/

	end_skip_directive ::=
		format_key ^^ F,
		[t("on"), t("$")]
	 <:> display ::-
			F ^^ display,
			fp_write('on$').



	/*------------------------------------------------------------------*/

/*	format_directive ::=
		format_key ^^ K,
		wls,
		term_expression(clause, 0, '=<') ^^ T,
		[t("$")],
		{eval_goal(T)}
	 <:> display(Col) ::-
			K ^^ display,
			adjusted_pos(Col, 1, Ncol),
			T ^^ display(Ncol),
			fp_write('$').
*/


	/*------------------------------------------------------------------*/

	format_key ::=
		[t("$"), t("fmt"), t(":")]
	 <:> display ::-
			fp_write('$fmt:').

:- end_object.
