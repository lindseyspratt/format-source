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


:- object(fpu_string).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'String utilities for format-prolog system.'
	]).

	:- public(left_trim/3).
	:- mode(left_trim(+list, +list, -list), one).
	:- info(left_trim/3, [
		comment is 'Trim elements of `TrimList` from the beginning of `Input` list until an element not in `TrimList` is encountered to create `Output` list.',
		argnames is ['Input', 'TrimList', 'Output']
	]).

	:- public(repeated_codes/1).
	:- mode(repeated_codes(+list), one).
	:- info(repeated_codes/1, [
		comment is 'Check that `Codes` is all the same character.',
		argnames is ['Codes']
	]).

	:- public(repeated_codes/2).
	:- mode(repeated_codes(+list, +integer), one).
	:- info(repeated_codes/2, [
		comment is 'Check that `Codes` is all the same character `Code`.',
		argnames is ['Codes', 'Code']
	]).
	
	
	:- uses(list, [member/2]).

	/*------------------------------------------------------------------*/

	trim([], _, []).
	trim([C0 | Cs0], TrimCs, Cs1) :-
		(	member(C0, TrimCs)
		->	Cs1 = OtherCs1
		;	Cs1 =  [C0 | OtherCs1]
		),
		trim(Cs0, TrimCs, OtherCs1).


    /*------------------------------------------------------------------*/

	left_trim([], _, []).
	left_trim([C0 | Cs0], TrimCs, Cs1) :-
		(	member(C0, TrimCs)
		->	Cs1 = OtherCs1,
			left_trim(Cs0, TrimCs, OtherCs1)
		;	Cs1 =  [C0 | Cs0]
		).

	/*------------------------------------------------------------------*/

	repeated_codes( [C | Cs]) :-
		repeated_codes(Cs, C).

	repeated_codes( [], _).
	repeated_codes( [C | Cs], C) :-
		repeated_codes(Cs, C).

:- end_object.
