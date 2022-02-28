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


:- object(format_prolog).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-28,
		comment is 'Format prolog source.'
	]).

	:- public(format_prolog/2).
	:- mode(format_prolog(+file, +file), one).
	:- info(format_prolog/2, [
		comment is 'Format ``Source`` file Prolog program to create ``Output`` file.',
		argnames is ['Source', 'Output']
	]).

	:- uses(fp_lex, [lex_file/2]).
	:- uses(fpu_output_position, [initialize_output_position_info/0, fp_nl/0]).
	:- uses(format, [format/2]).
	:- uses(os, [copy_file/2, delete_file/1]).

	/*------------------------------------------------------------------*/

	format_prolog(Source, Output) :-
		lex_file(Source, Tokens),
		!,
		current_output(Old),
		tellx('temp.pl'),
		(	format_prolog1(full, Tokens)
		->	tellx(Old),
			copy_file('temp.pl', Output),
			delete_file('temp.pl')
		;	format('Unable to fully parse "~w". Partial formatting in `temp.pl` follows:', [Source]),
			toldx,
			tellx('partial.pl'),
			format_prolog1(partial, Tokens),
			tellx(Old)
		).

	format_prolog1(Mode, Tokens) :-
		initialize_output_position_info,
		format_clause_groups(Mode, Tokens).

	/*------------------------------------------------------------------*/

	format_clause_groups(_, []) :- !.

	format_clause_groups(Mode, Tokens) :-
		fp_nl,
		fp_clause_group::evaluate(Tokens, RemainingTokens, Mode), % display/0 is the evaluate semantics.
		!,
		format_clause_groups(Mode, RemainingTokens).

	format_clause_groups(_, Tokens) :-
		fp_nl,
		fp_comments::evaluate(Tokens, 1),
		!.

	tellx(File) :-
		open(File, write, S),
		set_output(S).

	toldx :-
		current_output(S),
		set_output(user_output),
		close(S).

:- end_object.
