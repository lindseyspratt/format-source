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


:- object(fp_trailing_comment,
	imports([dctg_evaluate])).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'DCTG for a trivial Prolog comment for format-prolog system.'
	]).

	:- public(trailing_commentDCTG/3).
	:- mode(trailing_commentDCTG(-term, +list, -list), one).
	:- info(trailing_commentDCTG/3, [
		comment is 'Parse ``Tokens`` as a trailing Prolog comment to create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).
	
	:- uses(fp_whitespace_handling, [nnl_wlsDCTG/3]).
	:- uses(fp_comment, [commentDCTG/3]).

	^^(A, B) :- ::eval(A, B).

	/*------------------------------------------------------------------*/
	/* A trailing comment is a comment preceded by any amount of non-newline
	   whitespace.
	   */

	trailing_comment ::=
		nnl_wls,
		comment ^^ C,
		!
	 <:> display(Col) ::-
		C ^^ display(Col).

	trailing_comment ::=
		 []
	 <:> display(_).

:- end_object.
