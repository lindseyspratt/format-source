:- object(format_prolog).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Format prolog source.'
	]).

	:- uses(fp_lex, [lex_file/2]).
	:- uses(fpu_output_position, [initialize_output_position_info/0, fp_nl/0, writeseqnl/1]).
	
	/*------------------------------------------------------------------*/

	format_prolog(Source, Output) :-
	          lex_file(Source, Tokens),
	          !,
	          current_output(Old),
	          tellx('temp.pl'),
	          (format_prolog1(full, Tokens)
	            -> tellx(Old),
					copy_file('temp.pl', Output),
					delete_file('temp.pl')
	           ;
	           writeseqnl(['Unable to fully parse "', Source, '" . Partial formatting in `temp.pl` follows:']),
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
