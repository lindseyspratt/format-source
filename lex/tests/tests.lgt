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


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 0:4:0,
		date is 2022-02-18,
		author is 'Lindsey Spratt',
		comment is 'Test cases for the lexical analysis for the format-prolog system.'
	]).

	% terminal tests with list notation

	:- uses(fp_lex, [lex//1]).

	% Whitespace
	test(fpl_ws_01, true(V == [w(" ")])) :-
		lex(V, " ", []).
	test(fpl_ws_02, true(V == [w("  ")])) :-
		lex(V, "  ", []).
	test(fpl_ws_03, true(V == [w("\n")])) :-
		lex(V, "\n", []).
	test(fpl_ws_04, true(V == [w("\n"),w("\n")])) :-
		lex(V, "\n\n", []).
	
	% Punctuation
	test(fpl_p_01, true(V == [p(0'.)])) :-
		lex(V, ".", []).
	test(fpl_p_02, true(V == [p(0',)])) :-
		lex(V, ",", []).
	test(fpl_p_03, true(V == [p(0'|)])) :-
		lex(V, "|", []).
	test(fpl_p_04, true(V == [p(0'()])) :-
		lex(V, "(", []).
	test(fpl_p_05, true(V == [p(0') )])) :-
		lex(V, ")", []).
	test(fpl_p_06, true(V == [p(0'[)])) :-
		lex(V, "[", []).
	test(fpl_p_07, true(V == [p(0'])])) :-
		lex(V, "]", []).
	test(fpl_p_08, true(V == [p(0'{)])) :-
		lex(V, "{", []).
	test(fpl_p_09, true(V == [p(0'})])) :-
		lex(V, "}", []).
	
	% Token
	test(fpl_t_01, true(V == [t("a")])) :-
		lex(V, "a", []).
	test(fpl_t_02, true(V == [t("ab")])) :-
		lex(V, "ab", []).
	test(fpl_t_03, true(V == [t("%")])) :-
		lex(V, "%", []).
	test(fpl_t_04, true(V == [t("/")])) :-
		lex(V, "/", []).
	test(fpl_t_05, true(V == [t("++&")])) :-
		lex(V, "++&", []).
	test(fpl_t_06, true(V == [t("1")])) :-
		lex(V, "1", []).
	test(fpl_t_07, true(V == [t("12")])) :-
		lex(V, "12", []).
	test(fpl_t_08, true(V == [t("'a b'")])) :-
		lex(V, "'a b'", []).
	test(fpl_t_09, true(V == [t("\"a b\"")])) :-
		lex(V, "\"a b\"", []).

	% Mixed
	test(fpl_m_01, true(V == [t("X"),w(" "),t("="),w(" "),t("'a'"),p(0'.)])) :-
		lex(V, "X = 'a'.", []).
	
:- end_object.
