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


:- object(fpu_output_position).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-28,
		comment is 'Utilities for output for format prolog system.'
	]).

	:- public(initialize_output_position_info/0).
	:- mode(initialize_output_position_info, one).
	:- info(initialize_output_position_info/0, [
		comment is 'Initialize output position.'
	]).

	:- public(fp_nl/0).
	:- mode(fp_nl, one).
	:- info(fp_nl/0, [
		comment is 'Write a newline on the current output stream and update the current output position.'
	]).

	:- public(fp_nl/1).
	:- mode(fp_nl(+stream), one).
	:- info(fp_nl/1, [
		comment is 'Write a newline on `Stream` and update the current output position.',
		argnames is ['Stream']
	]).

	:- public(pos/1).
	:- mode(pos(-integer), one).
	:- info(pos/1, [
		comment is 'Pads (by writing zero or more spaces) the current output position to ``Pos``, writing a newline before padding if ``Pos`` is less than the current output position.',
		argnames is ['Pos']
	]).

	:- public(adjusted_pos/3).
	:- mode(adjusted_pos(+integer, +integer, -integer), one).
	:- info(adjusted_pos/3, [
		comment is 'Calculates ``ColumnOut`` based on the current output position plus ``Add`` (``AdjustedCurrent``) compared to ``ColumnIn``: if ``AdjustedCurrent`` is between ``ColumnIn`` and 70 then ``ColumnOut`` is ``AdjustedCurrent``, otherwise it is bound to ``ColumnIn``.',
		argnames is ['ColumnIn', 'Add', 'ColumnOut']
	]).

	:- public(current_line/1).
	:- mode(current_line(-integer), one).
	:- info(current_line/1, [
		comment is 'Binds `Line` to the current output line count.',
		argnames is ['Line']
	]).

	:- private(known_current_position_/2).
	:- dynamic(known_current_position_/2).

	:- private(known_line_count_/3).
	:- dynamic(known_line_count_/3).

	/*------------------------------------------------------------------*/

	fp_write(Symbol) :-
		current_output(Channel),
		fp_write(Channel, Symbol).

	fp_write(Channel, Symbol) :-
		write(Channel, Symbol),
		atom_codes(Symbol, Codes),
		length_after_newline(Codes, Length, NewLine),
		(	NewLine = no
		->	true
		;	reset_current_position(Channel)
		),
		adjust_current_position(Channel, Length).

	length_after_newline(Codes, Length, NewLine) :-
		length_after_newline(Codes, 0, Length, NewLine).

	length_after_newline([], Length, Length, _).
	length_after_newline([C|OCs], LIn, LOut, NewLine) :-
		(	[C] = "\n"
		->	LNext = 0,
			NewLine = yes
		;	LNext is LIn + 1
		),
		length_after_newline(OCs, LNext, LOut, NewLine).


	/*------------------------------------------------------------------*/

	fp_writenl(Symbol) :-
		current_output(Channel),
		fp_writenl(Channel, Symbol).

	fp_writenl(Channel, Symbol) :-
		write(Channel, Symbol), nl(Channel),
		reset_current_position(Channel).


	/*------------------------------------------------------------------*/

	fp_tab(Count) :-
		current_output(Channel),
		fp_tab(Channel, Count).

	fp_tab(Channel, Count) :-
		tab(Channel, Count),
		adjust_current_position(Channel, Count).

	tab(Channel, N) :-
		N > 0,
		write(' '),
		K is N - 1,
		tab(Channel, K).
	tab(_Channel, 0).


	/*------------------------------------------------------------------*/

	fp_nl :-  current_output(Channel),
		fp_nl(Channel).

	fp_nl(Channel) :-
		nl(Channel),
		reset_current_position(Channel).


	/*------------------------------------------------------------------*/

	known_current_position(Channel, Position) :-
		(	known_current_position_(Channel, Position)
		->	true
		;	Position = 1
		).


	/*------------------------------------------------------------------*/

	adjust_current_position(Channel, Change) :-
		(	retract(known_current_position_(Channel, OldPosition))
		->	NewPosition is OldPosition + Change,
			assertz(known_current_position_(Channel, NewPosition))
		;	logtalk::print_message(warning, format_prolog, 'adjust_current_position: no recorded position.'),
			assertz(known_current_position_(Channel, Change))
		).


	/*------------------------------------------------------------------*/

	reset_current_position :-
		current_output(Channel),
		reset_current_position(Channel).

	reset_current_position(Channel) :-
		retractall(known_current_position_(Channel, _)),
		assertz(known_current_position_(Channel, 1)),
		!.


	/*------------------------------------------------------------------*/

	initialize_output_position_info :-
		reset_current_position(_),
		% retractall(known_position_(_, _, _, _)),
		retractall(known_line_count_(_, _, _)).


	/*------------------------------------------------------------------*/

	pos(Column) :-
		pos(Column, _).

	pos(ColumnIn, Newline) :-
		(ColumnIn < 1 -> Column = 1; Column = ColumnIn),
		current_column(P),
		PositionDifference is Column - P,
		(	PositionDifference < 0
		->	fp_nl,
			Newline = yes,
			Pad is Column - 1
		;	Pad = PositionDifference,
			Newline = no
		),
		fp_tab(Pad).


	/*------------------------------------------------------------------*/

	adjusted_pos(Column0, Column1) :-
		adjusted_pos(Column0, 0, Column1).

	adjusted_pos(Column0, Add, Column1) :-
		current_column(P),
		Ncol is P + Add,
		(	(Ncol < Column0; Ncol > 70)
		->	Column1 = Column0
		;	Column1 = Ncol
		).


	/*------------------------------------------------------------------*/

	current_column(Col) :-
		current_output(Stream),
		line_position(Stream, Col).


	/*------------------------------------------------------------------*/

	current_line(Line) :-
		current_output(Stream),
		stream_line_count(Stream, Line).


	/*------------------------------------------------------------------*/

/*	current_output(C) :-
		telling(C).
*/


	/*------------------------------------------------------------------*/

	line_position(C, P) :-
		known_current_position(C, P).


	/*------------------------------------------------------------------*/

	stream_line_count(C, Line) :-
		stream_property(C, position(OriginalPosition)), % cursor(C, OriginalPosition, OriginalPosition),
		(	known_line_count_(C, KnownPosition, KnownCount)
		->	true
		;	KnownPosition = 1,
			KnownCount = 1
		),
		set_stream_position(C, position(KnownPosition)), % cursor(C, KnownPosition, KnownPosition),
		stream_line_count(C, OriginalPosition, KnownCount, Line),
		replace_line_count(C, OriginalPosition, Line),
		set_stream_position(C, position(OriginalPosition)). % cursor(C, OriginalPosition, OriginalPosition).

	stream_line_count(C, OriginalPosition, CountIn, CountOut) :-
		(	skip(C, 0'\n)
		->	stream_property(C, position(CurrentPosition)), % cursor(C, CurrentPosition, CurrentPosition),
			(	CurrentPosition > OriginalPosition
			->	CountIn = CountOut
			;	CountNext is CountIn + 1,
				stream_line_count(C, OriginalPosition, CountNext, CountOut)
			)
		;	CountIn = CountOut
		).


	/*------------------------------------------------------------------*/

	replace_line_count(C, Pos, Line) :-
		ignore(retract(known_line_count_(C, _, _))),
		assertz(known_line_count_(C, Pos, Line)).
	
	skip(Stream, Code) :-
		get_code(Stream, Check),
		(	(Code = Check; Check = -1)
		->	true
		;	skip(Stream, Code)
		).

:- end_object.
