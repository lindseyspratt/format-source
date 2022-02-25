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


:- object(fpl_token).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'Token grammar for the format-prolog source system lexical analysis.'
	]).

	:- public(token//3).
	:- mode(token(-list, +atom, -atom), one).
	:- info(token//3, [
		comment is 'Parse the beginning of a list of codes into a list of token codes, updating the ``ModeIn`` to ``ModeOut`` where a mode is ``comment`` or ``code``.',
		argnames is ['Codes', 'ModeIn', 'ModeOut']
	]).

	:- uses(fpl_quoted_char_list, [quoted_char_list//2]).
	:- uses(fpl_chars, [token_char/2]).
	
	/* The start of a comment is forced to be an entire token, even if it's immediately followed by (more) "graphic" characters. ("/" and "*" are both "graphic" type characters.)
	*/

	token([Quote|X], code, code) -->
		{	[Quote] = "'"
		;	[Quote] = """"
		},
		[Quote],
		!,
		quoted_char_list(Quote, X).
	token(Special, ModeIn, ModeOut) -->
		{	Special = "/*",
			Special = [C1,C2]
		},
		[C1,C2],
		!,
		{	ModeIn = code
		->	ModeOut = comment("*/")
		;	ModeOut = ModeIn
		}.
	token(Special, ModeIn, ModeOut) -->
		{	Special = "%",
			Special = [C]
		},
		[C],
		!,
		{	ModeIn = code
		->	ModeOut = comment("\n")
		;	ModeOut = ModeIn
		}.
	token(Special, ModeIn, ModeOut) -->
		{	Special = "*/",
			Special = [C1,C2]
		},
		[C1,C2],
		!,
		{	ModeIn = comment(Special)
		->	ModeOut = code
		;	ModeOut = ModeIn
		}.
	token([H|T], Mode, Mode) -->
		tokenc(Type, H),
		token_ls(Type, T).

	token_ls(Type, [H|T]) -->
		tokenc(Type, H),
		!,
		token_ls(Type, T).
	token_ls(_, []) -->
		[].

	tokenc(_, _) -->
		"/*",
		{!, fail}.
	tokenc(_, _) -->
		"*/",
		{!, fail}.
	tokenc(Type, X) -->
		[X],
		{token_char(X, Type)}.

:- end_object.
