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


:- object(fp_function).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'DCTG for structure function for format prolog system.'
	]).

	:- public(functionDCTG/3).
	:- mode(functionDCTG(-term, +list, -list), one).
	:- info(functionDCTG/3, [
		comment is 'Parse `Tokens` as a Prolog structure function to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Tree', 'Tokens', 'Remainder']
	]).


	:- uses(fpu_output_position, [pos/1, fp_write/1]).
	:- uses(list, [length/2]).

	/*------------------------------------------------------------------*/

	function ::=
		 [t(FunctionCodes)],
		{atom_codes(Function, FunctionCodes),
		 length(FunctionCodes, Len)
		}
	 <:> (display(Col) ::-
		      pos(Col),
		      fp_write(Function)
	     ),
	     (len(Len)),
	     (functor(Function)).

:- end_object.
