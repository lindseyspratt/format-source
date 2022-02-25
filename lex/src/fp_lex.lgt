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


:- object(fp_lex).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'lexical analysis for the format-prolog source system.'
	]).

	:- public(lex_file/2).
	:- mode(lex_file(+file_path, -list), one).
	:- info(lex_file/2, [
		comment is 'Parse a text file into a list of tokens.',
		argnames is ['SourceFile', 'Tokens']
	]).

	:- public(lex//1).
	:- mode(lex(-list), one).
	:- info(lex//1, [
		comment is 'Parse a list of character codes into a list of tokens.',
		argnames is ['Tokens']
	]).

	:- uses(fpl_whitespace, [whitespace//3, punctuation//2]).
	:- uses(fpl_token, [token//3]).
	
	lex(V) -->
		item_list(V, code).

	item_list([H|T], ModeIn) -->
		item(H, ModeIn, ModeNext),
		!,
		item_list(T, ModeNext).
	item_list([], _) --> [].

	item(w(V), ModeIn, ModeOut) -->
		whitespace(V, ModeIn, ModeOut),
		!.
	item(p(V), Mode, Mode) -->
		punctuation(V, Mode),
		!.
	item(t(V), ModeIn, ModeOut) -->
		token(V, ModeIn, ModeOut).

	lex_file(File, Token_list) :-
		open(File, read, S),
		listify(Source, S),
		close(S),
		lex(Token_list, Source, []).

	listify(L, S) :-
		get_code(S, H),
		(	H = -1
		->	L = []
		;	L = [H|T],
			listify(T, S)
		).

:- end_object.
