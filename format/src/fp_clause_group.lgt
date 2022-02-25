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


:- object(fp_clause_group).

	:- uses(fpu_output_position, [fp_nl/0, fp_writenl/1]).
	:- uses(fpu_node_evaluation, [eval_clause/1]).
	:- uses(fp_comments, [commentsDCTG/3]).
	:- uses(fp_trailing_comment, [trailing_commentDCTG/3]).
	:- uses(fp_named_characters, [periodDCTG/3]).
	:- uses(fp_error_skip, [error_skipDCTG/4]).
	:- uses(fp_term_expression, [term_expressionDCTG/6]).
	:- uses(format, [format/3]).
	:- uses(list, [member/2]).

	dctg_main(clause_group/1, display/0).

	%/*------------------------------------------------------------------*/
	%/* clause_group_list parses a Prolog source file (or window). Thus, a
	%   file is viewed as containing any number of clause groups (procedures
	%   , roughly).
	%   */
	%clause_group_list ::=
	%	clause_group ^^ ClauseGroup,
	%	!,
	%	clause_group_list ^^ List
	% <:> display ::-
	%	     ClauseGroup ^^ display,
	%	     List ^^ display.
	%
	%clause_group_list ::=
	%	[]
	% <:> display.


	/*------------------------------------------------------------------*/
	/* clause_group parses a sequence of clauses which have the same "identifying functor"
	   . For certain functors, the identifying functor is not the top-level
	   functor.  The identifying functor is determined by the "clause" nonterminal.
	   */

	clause_group(Mode) ::=
		comments ^^ Cmt,
		clause(Mode, IdentifyingFunctor) ^^ Clause,
		{format(user, '~N~nParsed first clause for ~w.', [IdentifyingFunctor])},
		clause_group(Mode, IdentifyingFunctor) ^^ ClauseGroup,
		{format(user, '~N~nFinished clause group for ~w.',  [IdentifyingFunctor]),
		 !}
	 <:> display ::-
			format('~N~w~66(-)~w',  ['/*', '*/']),
			fp_nl, % resets the known current position to 0 as a side-effect. 
			Cmt ^^ display(1),
			Clause ^^ display,
			ClauseGroup ^^ display,
			fp_nl,
			fp_nl.

	clause_group(Mode, IdentifyingFunctor) ::=
		comments ^^ Cmt,
		clause(Mode, IdentifyingFunctor) ^^ Clause,
		!,
		clause_group(Mode, IdentifyingFunctor) ^^ List
	 <:> display ::-
			Cmt ^^ display(1),
			Clause ^^ display,
			List ^^ display.

	clause_group(_, _) ::=
		 []
	 <:> display.


	/*------------------------------------------------------------------*/
	/* A clause is a term followed by comments, followed by a period, followed
	   by a trailing comment.

	   If the top-level functor of the term of a clause
	   is ':-' or '-->', the identifying functor is the functor of the first
	   argument.  If the top-level functor is '<:>' (for a DCTG rule), the
	   identifying functor is the functor of the first argument of the structure
	   which is the first argument to the '<:>'.
	   */  
	clause(_Mode, IdentifyingFunctor) ::=
		term_expression(clause, 0, '=<') ^^ T,
		comments ^^ FirstComments,
		period,
		!, /* for performance, avoid fruitless backtracking. */ 
		trailing_comment ^^ TrailingComment,
		{clause_functor(T, IdentifyingFunctor),
		 (IdentifyingFunctor == '*NECK*'
		   -> eval_clause(T)
		  ;
		  true
		 )
		}
	 <:> display ::-
			fp_nl,
			T ^^ display(1),
			fp_writenl('.'),
			adjusted_pos(1, 1, Col),
			FirstComments ^^ display(Col),
			TrailingComment ^^ display(Col).
	clause(partial, _IdentifyingFunctor) ::=
		{[P] = "."},
		error_skip(p(P)) ^^ S
	 <:> display ::-
			fp_nl,
			fp_writenl('***** Begin Skip *****'),
			S ^^ display,
			fp_nl,
			fp_writenl('***** End Skip *****').

	clause_functor(T, Functor) :-
		T ^^ functor(F),
		clause_functor1(F, T, Functor).

	% DCTG with semantics.
	clause_functor1('<:>', T, Functor) :-
		!,
		(	T ^^ args( [Syntax, _]) 
		->	Syntax ^^ args( [H, _]),
			H ^^ functor(Functor)
		;	Functor = ('<:>')
		).
	% plain rule, DCG, DCTG without semantics.
	clause_functor1(F, T, Functor) :-
		member(F, ['*NECK*','==>','::=']),
		!,
		(	T ^^ args( [H, _])
		->	H ^^ functor(Functor)
		;	Functor = F
		).
	% fact.
	clause_functor1(F, _T, F).

:- end_object.
