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


:- object(fp_repeated_characters).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'DCTG for repeated characters for format prolog system.'
	]).

	:- public(repeated_charactersDCTG/3).
	:- mode(repeated_charactersDCTG(-term, +list, -list), one).
	:- info(repeated_charactersDCTG/3, [
		comment is 'Parse `Tokens` as a repeated characters to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).

	:- uses(fpu_string, [repeated_codes/2]).
	
	/*------------------------------------------------------------------*/
	/* repeated_characters "consumes" a "token" (t) item which consists of
	   a character repeated any number of times, or a sequence of "punctuation"
	   (p) items which are identical.
	   */  
	repeated_characters ::=
		 [t( [C | Cs])],
		{repeated_codes(Cs, C)},
		repeated_characters(t, C).

	repeated_characters ::=
		 [p(C), p(C)],
		repeated_characters(p, C).

	repeated_characters(t, C) ::=
		 [t( [C | Cs])],
		{repeated_codes(Cs, C)},
		!,
		repeated_characters(t, C).

	repeated_characters(p, C) ::=
		 [p(C)],
		!,
		repeated_characters(p, C).

	repeated_characters(_, _) ::=
		 [].

:- end_object.


