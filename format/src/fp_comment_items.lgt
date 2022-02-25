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


:- object(fp_comment_items).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'DCTG for items in a Prolog comment for format-prolog system.'
	]).

	:- public(nls_itemDCTG/3).
	:- mode(nls_itemDCTG(-term, +list, -list), one).
	:- info(nls_itemDCTG/3, [
		comment is 'Parse ``Tokens`` as a ``no leading space`` comment item and create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(skip_itemDCTG/3).
	:- mode(skip_itemDCTG(-term, +list, -list), one).
	:- info(skip_itemDCTG/3, [
		comment is 'Parse ``Tokens`` as any item for display at column 1 and create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- uses(fp_format_directives, [format_directiveDCTG/3]).
	:- uses(fp_whitespace_handling, [blank_linesDCTG/3, nnl_wlsDCTG/3]).

	/*------------------------------------------------------------------*/
	/* nls_item is an item with "no leading space".  The name is something
	   of a misnomer, as the item in an nls_item may have leading space if
	   the space is between it and the beginning of a line.  Further, there
	   may be any number of blank_lines before the line on which the item 
	   is found (if it is only preceded by whitespace on its own line).
	   */

	nls_item ::=
		format_directive ^^ F
	 <:> display(Col) ::-
			F ^^ display(Col).

	nls_item ::=
		{[NL] = "\n"},
		
		[w([NL|_])],
		nls_blank_lines(NewLine, Adjust),
		nnl_wls,
		[Item],
		{Item \= w(_)},
		!
	 <:> display(Col) ::-
			NewLine,
			adjusted_pos(Col, Adjust, Ncol),
			display_item(Ncol, Item).

	nls_item ::=
		[Item]
	 <:> display(Col) ::-
			display_item(Col, Item).



	/*------------------------------------------------------------------*/

	nls_blank_lines(NewLine, Adjust) ::=
		blank_lines,
		!,
		{NewLine = fp_nl,
		 Adjust = 5
		}.

	nls_blank_lines(NewLine, Adjust) ::=
		[],
		{	NewLine = true,
			Adjust = 1
		}.



	/*------------------------------------------------------------------*/

	skip_item ::=
		[Item]
	 <:> display ::-
			display_item(1, Item).



	/*------------------------------------------------------------------*/

	item ::=   [Item]
	 <:> display(Col) ::-
			display_item(Col, Item).


:- end_object.
