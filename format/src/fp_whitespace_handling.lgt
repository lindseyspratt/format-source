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


:- object(fp_whitespace_handling).

	:- public(wlsDCTG/3).
	:- mode(wlsDCTG(-term, +list, -list), one).
	:- info(wlsDCTG/3, [
		comment is 'Parse ``Tokens`` as whitespace to create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(nnl_wlsDCTG/3).
	:- mode(nnl_wlsDCTG(-term, +list, -list), one).
	:- info(nnl_wlsDCTG/3, [
		comment is 'Parse ``Tokens`` as `no newline` whitespace to create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- public(blank_linesDCTG/3).
	:- mode(blank_linesDCTG(-term, +list, -list), one).
	:- info(blank_linesDCTG/3, [
		comment is 'Parse ``Tokens`` as a sequence of lines of whitespace to create the annotated abstract syntax tree ``Tree``.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- uses(list, [member/2, memberchk/2]).
	
	/*------------------------------------------------------------------*/
	/* wls parses a list of whitespace.  The "w" token ("w(X)") is a list 
	   of whitespace characters, where all of the characters in a token are
	   the same.
	   */

	wls ::=    [w(_)],
		!,
		wls.

	wls ::=
		[].



	/*------------------------------------------------------------------*/
	/* nnl_wls parses a list of whitespace characters, none of which is a 
	   carriage return (13) or linefeed (10).
	   */  
	nnl_wls ::=
		[w(Cs)],
		{	\+ member(10, Cs),
			\+ member(13, Cs)
		},
		!,
		nnl_wls.

	nnl_wls ::=
		[].



	/*------------------------------------------------------------------*/
	/* blank_lines parses a list of blank lines.  A blank line is whitespace
	   from the beginning of a line (ie, the first character after a newline
	   character) to the next newline character.
	   */

	blank_lines ::=
		nnl_wls,
		[w(Codes)],
		{	member(10, Codes)
		;	member(13, Codes)
		},
		blank_lines1.



	/*------------------------------------------------------------------*/

	blank_lines1 ::=
		nnl_wls,
		[w(Codes)],
		{	member(10, Codes)
		;	member(13, Codes)
		},
		!,
		blank_lines1.

	blank_lines1 ::=
		[].



	/*------------------------------------------------------------------*/
	/* any_blanks parses a blank whitespace token (which is a list of blank
	   chars (32)), or the empty token (ie no token at all). Thus, it always
	   succeeds (once).
	   */

	any_blanks ::=
		[w(Codes)],
		{	[Code] = " ",
			memberchk(Code, Codes)
		},
		!.

	any_blanks ::=
		[].

:- end_object.
