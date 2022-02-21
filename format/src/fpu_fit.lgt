:- object(fpu_fit).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Operator class for format prolog system.'
	]).

	:- public(fit/5).
	:- mode(fit(+atom, +integer, -atom, -integer, +integer), one).
	:- info(fit/5, [
		comment is 'Determine `ACol1` and `NextMode` fit given `Len`, `Mode` and start `Col`.',
		argnames is ['Mode', 'Col', 'NextMode', 'Acol1', 'Len']
	]).

	:- uses(fpu_output_position, [pos/1, current_column/1, adjusted_pos/2]).

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
	          format('fit_process: Unrecognized mode = "^w".',  [NextMode]),
	          !,
	          fail.



	/*------------------------------------------------------------------*/

	fits(Len, Col) :-
	          current_column(Col),
	          Max is 70 - Col,
	          Max > Len.

:- end_object.


