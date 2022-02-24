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


:- object(fpu_fit).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-24,
		comment is 'Operator class for format prolog system.'
	]).

	:- public(fit/5).
	:- mode(fit(+atom, +integer, -atom, -integer, +integer), one).
	:- info(fit/5, [
		comment is 'Determine `ACol1` and `NextMode` fit given `Len`, `Mode` and start `Col`.',
		argnames is ['Mode', 'Col', 'NextMode', 'Acol1', 'Len']
	]).

	:- uses(fpu_output_position, [pos/1, current_column/1, adjusted_pos/2]).
	:- uses(format, [format/2]).

	/*------------------------------------------------------------------*/

	fit(Mode, Col, NextMode, Acol1, Len) :-
		fit_setup(Mode, NextMode, Acol1, Len),
		fit_process(Mode, Col, NextMode, Acol1).



	/*------------------------------------------------------------------*/

	fit_setup(check, adjust, Acol1, Len) :-
		fits(Len, Acol1),
		!.

	fit_setup(check, nl, _, _) :-
		!.

	fit_setup(Mode, Mode, _, _).



	/*------------------------------------------------------------------*/

	fit_process(check, _, adjust, _) :-
		!.

	fit_process(_, Col, adjust, Acol1) :-
		!,
		adjusted_pos(Col, Acol1).

	fit_process(_, Col, nl, Col) :-
		!,
		pos(Col).

	fit_process(_, _, NextMode, _) :-
		format('fit_process: Unrecognized mode = "~w".',  [NextMode]),
		!,
		fail.



	/*------------------------------------------------------------------*/

	fits(Len, Col) :-
		current_column(Col),
		Max is 70 - Col,
		Max > Len.

:- end_object.


