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


:- object(fpl_display_lex_list).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'Display utility for the format-prolog source system lexical analysis.'
	]).

	display_lex_list([]) :-
		nl.
	display_lex_list([Item|Items]) :-
		display_lex_item(Item),
		display_lex_list(Items).

	display_lex_item(t(Cs)) :-
		atom_codes(Token, Cs),
		write(t(Token)).
	display_lex_item(p(C)) :-
		atom_codes(Punctuation, [C]),
		write(' '),
		write(p(Punctuation)).
	display_lex_item(w(Cs)) :-
		atom_codes(W, Cs),
		write(' '),
		write(w(W)).

:- end_object.
