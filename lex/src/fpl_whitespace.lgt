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


:- set_prolog_flag(double_quotes, codes).


:- object(fpl_whitespace).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'Whitespace grammar for the format-prolog source system lexical analysis.'
	]).

	:- public(whitespace//3).
	:- mode(whitespace(-list, +atom, -atom), one).
	:- info(whitespace//3, [
		comment is 'Parse the beginning of a list of codes into a list of whitespace codes, updating the ModeIn to ModeOut where a mode is ``comment`` or ``code``.',
		argnames is ['Codes', 'ModeIn', 'ModeOut']
	]).

	:- public(punctuation//2).
	:- mode(punctuation(-integer, -atom), one).
	:- info(punctuation//2, [
		comment is 'Parse the first code of a list of codes into a code and a mode where a mode is ``comment`` or unbound.',
		argnames is ['Code', 'Mode']
	]).

	:- uses(fpl_chars, [ws_char/1, punctuation_char/1]).
	:- uses(list, [member/2]).
	
	/* Only one newline is allowed in a whitespace token, and it must be the first code in the token. This is the first code. 
	If another newline is encountered, it must be placed in a separate whitespace token.
	*/

	whitespace([H|T], ModeIn, ModeOut) -->
		wsc(H),
		ws_list(T),
		{	ModeIn = comment([Code]),
			member(Code, [H|T])
		->	ModeOut = code
		;	ModeOut = ModeIn
		}.

	ws_list([H|T]) -->
		wsc(H),
		{[H] \= "\n"},
		ws_list(T).
	ws_list([]) -->
		[].

	wsc(Char) -->
		[Char],
		{ws_char(Char)}.

	punctuation(Quote, comment(_)) -->
		{	[Quote] = "'"
		;	[Quote] = """"
		},
		[Quote],
		!.
	punctuation(X, _) -->
		[X],
		{punctuation_char(X)}.

:- end_object.
