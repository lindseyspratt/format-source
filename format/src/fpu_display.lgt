:- object(fpu_display, 
	imports([dctg_evaluate])).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'Utilities for display for format prolog system.'
	]).

	:- public(display_comment/3).
	:- mode(display_comment(+integer, +atom, +term), one).
	:- info(display_comment/3, [
		comment is 'Display the comment with annotated abstract syntax tree `ParseTree`, indenting by `Indent`.',
		argnames is ['Indent', 'StartToken', 'ParseTree']
	]).
	
	:- uses(fpu_output_position, [pos/1, current_line/1, adjusted_pos/2, adjusted_pos/3, fp_tab/1, fp_nl/0]).
	:- uses(fpu_display_item, [display_item/3]).
	:- uses(fpu_operator_class, [operator_class/3]).
	
	^^(A, B) :- ::eval(A, B).
	
	/*------------------------------------------------------------------*/

	display_comment(Col, _, B) :-
	         pos(Col),
	         current_line(L1),
	         NextCol is Col + 3,
	         display_item(1, t([0'/, 0'*])), % The explicit escapes avoid syntax-coloring bug in handling "/ *"
	         B ^^ display(L1, NextCol).


	display_comment_end(StartLine, Col, End) :-
	          current_line(L2),
	          ((StartLine =:= L2
	            ;
	            End = nl
	           )-> adjusted_pos(Col, 1, NextCol)
	           ;
	           NextCol = Col
	          ),
	          pos(NextCol),
	          (End = nl
	            -> fp_nl
	           ;
	           display_item(NextCol, End),
	           fp_tab(1)
	          ).



	/*------------------------------------------------------------------*/

	display_infix_term(Col, Op, Context, Ct, Cr, T) :-
	          Op ^^ functor(Opf),
	          operator_class(Opf, Context, Class),
	          class_indent(Class, ClassIndent),
	          (
			   % Rewrite the user_display_infix_term implementation to use Logtalk hook technique.
			   %def(user_display_infix_term),
	           %user_display_infix_term(Class, Col, Op, Ct, Cr, T)
	           % -> true
	           %;
	           Class = neck
	            -> adjusted_pos(Col, 1, Ncol1),
	               Op ^^ display(Ncol1),
	               adjusted_pos(Col, 1, Ncol2),
	               Ct ^^ display(Ncol2),
	               Ncol3 is Col + ClassIndent,
	               pos(Ncol3),
	               Cr ^^ display(Ncol3),
	               T ^^ display(Ncol3)
	           ;
	           (Class = conjunction
	            ;
	            Class = disjunction(2)
	           )-> adjusted_pos(Col, Ncol1),
	               Op ^^ display(Ncol1),
	               adjusted_pos(Col, 1, Ncol2),
	               Ct ^^ display(Ncol2),
	               Cr ^^ display(Col),
	               T ^^ display(Col)
	           ;
	           Class = disjunction(1)
	            -> pos(Col),
	               Op ^^ display(Col),
	               adjusted_pos(Col, 1, Ncol1),
	               Ct ^^ display(Ncol1),
	               Cr ^^ display(Col),
	               T ^^ display(Col)
	           ;
	           Class = dependent_clause
	            -> Ncol1 is Col + ClassIndent,
	               pos(Ncol1),
	               Op ^^ display(Ncol1),
	               adjusted_pos(Ncol1, 1, Ncol2),
	               Ct ^^ display(Ncol2),
	               Cr ^^ display(Ncol2),
	               T ^^ display(Ncol2)
	           ;
	           Class = general
	            -> adjusted_pos(Col, 1, Ncol1),
	               Op ^^ display(Ncol1),
	               adjusted_pos(Col, 1, Ncol2),
	               Ct ^^ display(Ncol2),
	               Cr ^^ display(Ncol2),
	               adjusted_pos(Col, 1, Ncol3),
	               T ^^ display(Ncol3)
			   ;
 			   logtalk::print_message(error, format_prolog, 'display_infix_term: unrecognized class ~w.'+[Class]),
			   throw(error(system_error, display_infix_term/6))
	          ).



	/*------------------------------------------------------------------*/

	class_indent(neck, 10) :- !.
	class_indent(dependent_clause, 1) :- !.
	class_indent(_, 0).

:- end_object.

