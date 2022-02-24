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


:- object(fp_term_expression, 
	imports([dctg_evaluate])).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'DCTG for term expression for format prolog system.'
	]).

	:- public(term_expressionDCTG/6).
	:- mode(term_expressionDCTG(+term, +integer, +atom, -term, +list, -list), one).
	:- info(term_expressionDCTG/6, [
		comment is 'Parse `Tokens` as a Prolog term expression, honoring the `Context`, `Precedence`, and `ContextOperator` to create the annotated abstract syntax tree `Tree`.',
		argnames is ['Context', 'Precedence', 'ContextOperator', 'Tree', 'Tokens', 'Remainder']
	]).

	:- uses(fpu_miscellaneous, [precedence_constraint/3,extend_context/3]).
	:- uses(fp_op, [opDCTG/6]).
	:- uses(fp_function, [functionDCTG/3]).

	:- uses(fp_comments, [commentsDCTG/3]).
	:- uses(fp_trailing_comment, [trailing_commentDCTG/3]).
	:- uses(fp_named_characters, [commaDCTG/3, vertbarDCTG/3, lparenDCTG/3, rparenDCTG/3, lbraceDCTG/3, rbraceDCTG/3, lbracketDCTG/3, rbracketDCTG/3]).
	:- uses(fpu_output_position, [pos/1, adjusted_pos/2, adjusted_pos/3, current_line/1, fp_write/1]).
	:- uses(fpu_display, [display_element_list/6, tst_display/3]).

	^^(A, B) :- ::eval(A, B).

	/* "term_expression" is the heart of the grammar of Prolog. 
	A term_expression is either a simple term, or an operator term.  
	A simple term is either atomic, a stucture, or a list. 
	An operator term uses a prefix, infix or suffix operator plus one (for prefix and suffix)
	or two (for infix) term expressions.  
	The operators have various precedences and associativities which the parse honors.  
	The grammar is somewhat convoluted to avoid the left-recursion of 
	the "natural" grammar for the infix and suffix operators.
	*/

	term_expression(Context, Prec0, Comp0) ::=
	  term_prefix(Context, Prec0, Comp0, Prec1) ^^ Pfx,
	  !,
	  term_expression_continuation(Context, Pfx, Prec1, Prec0, Comp0) ^^ R,
	  {Pfx ^^ len(Lpfx),
	   R ^^ len(Lr),
	  Len is Lpfx + Lr
	  }
	  <:> (display(Col) ::-
		Pfx ^^ display(Col),
		R ^^ display(Col)
	        ),
	        (len(Len)),
	        (functor(F) ::- R ^^ functor(F)),
	        (args(As) ::- R ^^ args(As)).


	term_expression(Context, Prec0, Comp0) ::=
	  simple_term(Context) ^^ T,
	  !,
	  term_expression_continuation(Context, T, 0, Prec0, Comp0) ^^ R,
	  {T ^^ len(Lt),
	   R ^^ len(Lr),
	  Len is Lt + Lr
	  }
	  <:> (display(Col) ::-
		T ^^ display(Col),
		R ^^ display(Col)
	        ),
	        (len(Len)),
	        (functor(F) ::- R ^^ functor(F)),
	        (args(As) ::- R ^^ args(As)).


	/* term_expression_continuation parses the rest of a term expression, 
			which term_expression has determined (before invoking term_expression_continuation) 
			starts with either a prefix operator or a simple term.
	*/

	term_expression_continuation(Context, PrecedingTerm, PrecIn, Prec0, Comp0) ::=
	  comments ^^ Comments,
	  term_infix_or_suffix(Context, PrecedingTerm, Prec0, Comp0, PrecIn, PrecNext) ^^ T,
	  term_expression_continuation(Context, T, PrecNext, Prec0, Comp0) ^^ R,
	  {T ^^ len(Lt),
	   R ^^ len(Lr),
	   Len is Lt + Lr
	  }
	  <:> (display(Col) ::-
		Comments ^^ display(Col),
		T ^^ display(Col),
		R ^^ display(Col)
	        ),
	        (len(Len)),
	        (functor(F) ::- R ^^ functor(F)),
	        (args(As) ::- R ^^ args(As)).

	term_expression_continuation(_Context, PrecedingTerm, _PrecIn, _Prec0, _Comp0) ::=
	  []
	  <:> (display(_)),
	        (len(0)),
	        (functor(F) ::- PrecedingTerm ^^ functor(F)),
	        (args(As) ::- PrecedingTerm ^^ args(As)).

	/*------------------------------------------------------------------*/
	/* term_prefix parses a prefix operator and its accompanying (following
	   ) term expression.
	   */  
	term_prefix(Context, Prec0, Comp0, Prec1) ::=
		op(Context, Prec1, Assoc) ^^ Op,
		{precedence_constraint(Prec0, Comp0, Prec1),
		 (Assoc == fx
		   -> Comp1 = ('>')
		  ;
		  Assoc == fy,
		  Comp1 = ('>=')
		 )
		},
		comments ^^ C,
		term_expression(Context, Prec1, Comp1) ^^ T,
		{Op ^^ len(Lop),
		 T ^^ len(Lt),
		 Len is Lop + Lt
		}
	 <:> (display(Col) ::-
		      Op ^^ display(Col),
		      adjusted_pos(Col, 1, Ncol1),
		      C ^^ display(Ncol1),
		      adjusted_pos(Col, 1, Ncol2),
		      T ^^ display(Ncol2)
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      Op ^^ functor(F)
	     ),
	     (args( [T])).



	/*------------------------------------------------------------------*/
	/* term_infix_or_suffix parses an infix or suffix operator and, in the
	   case of an infix operator, its accompanying (following) term expression
	   .
	   */  
	term_infix_or_suffix(Context,
			 PrecedingTerm, Prec0, Comp0, PrecPrev, Prec1
			) ::=
		op(Context, Prec1, Assoc) ^^ Op,
		{precedence_constraint(Prec0, Comp0, Prec1),
		 (Assoc == yfx
		   -> Comp1 = ('>'),
		      Prec1 >= PrecPrev
		  ;
		  Assoc == xfy
		   -> Comp1 = ('>='),
		      Prec1 > PrecPrev
		  ;
		  Assoc == xfx,
		  Comp1 = ('>'),
		  Prec1 > PrecPrev
		 )
		},
		trailing_comment ^^ Ct,
		comments ^^ Cr,
		term_expression(Context, Prec1, Comp1) ^^ T,
		{Op ^^ len(Lop),
		 T ^^ len(Lt),
		 Len is Lop + Lt
		}
	 <:> (display(Col) ::-
		      display_infix_term(Col, Op, Context, Ct, Cr, T)
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      Op ^^ functor(F)
	     ),
	     (args( [PrecedingTerm, T])).

	term_infix_or_suffix(_Context, T, Prec0, Comp0, PrecPrev, Prec1) ::=
		op(argls, Prec1, Assoc) ^^ Op,
		{precedence_constraint(Prec0, Comp0, Prec1),
		 (Assoc == yf
		   -> Prec1 >= PrecPrev
		  ;
		  Assoc == xf,
		  Prec1 > PrecPrev
		 ),
		 Op ^^ len(Len)
		}
	 <:> (display(Col) ::-
		      Op ^^ display(Col)
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      Op ^^ functor(F)
	     ),
	     (args( [T])).


	/*------------------------------------------------------------------*/
	/* simple_term parses the forms of a Prolog term which do not involve 
	   an operator (directly): parenthesized term expression, curly-bracketed
	   term expression, list, and structure (including 0-arity).
	   */  
	simple_term(Context) ::=
		lparen,
		!,
		comments ^^ C1,
		{extend_context(Context, expression, NewContext)},
		term_expression(NewContext, 0, '=<') ^^ T,
		comments ^^ C2,
		rparen,
		{T ^^ len(Lt),
		 Len is 2 + Lt
		}
	 <:> (display(C) ::-
		      pos(C),
		      current_line(Ln1),
		      fp_write('('),
		      adjusted_pos(C, Nc),
		      C1 ^^ display(Nc),
		      T ^^ display(Nc),
		      C2 ^^ display(Nc),
		      current_line(Ln2),
		      (Ln1 =:= Ln2
		        -> true
		       ;
		       pos(C)
		      ),
		      fp_write(')')
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      T ^^ functor(F)
	     ),
	     (args(As) ::-
		      T ^^ args(As)
	     ).


	simple_term(Context) ::=
		lbrace,
		!,
		comments ^^ C1,
		{extend_context(Context, expression, NewContext)},
		term_expression(NewContext, 0, '=<') ^^ T,
		comments ^^ C2,
		rbrace,
		{T ^^ len(Lt),
		 Len is 2 + Lt
		}
	 <:> (display(C) ::-
		      pos(C),
		      current_line(Ln1),
		      fp_write('{'),
		      adjusted_pos(C, Nc),
		      C1 ^^ display(Nc),
		      T ^^ display(Nc),
		      C2 ^^ display(Nc),
		      current_line(Ln2),
		      (Ln1 =:= Ln2
		        -> true
		       ;
		       pos(C)
		      ),
		      fp_write('}')
	     ),
	     (len(Len)),
	     (functor('{}')),
	     (args( [T])).

	simple_term(_) ::=
		term_list ^^ T,
		!,
		{T ^^ len(Len)}
	 <:> (display(C) ::-
		      T ^^ display(C)
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      T ^^ functor(F)
	     ),
	     (args(As) ::-
		      T ^^ args(As)
	     ).

	simple_term(_) ::=
		term_structure ^^ T,
		!,
		{T ^^ len(Len)}
	 <:> (display(C) ::-
		      T ^^ display(C)
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      T ^^ functor(F)
	     ),
	     (args(As) ::-
		      T ^^ args(As)
	     ).


	/*------------------------------------------------------------------*/
	/* term_list parses a list, including the outermost square brackets. */  
	term_list ::=
		lbracket,
		comments ^^ Cl,
		element_list ^^ E,
		{E ^^ len(Le),
		 Len is Le + 1
		}
	 <:> (display(Col) ::-
		      pos(Col),
		      fp_write(' ['),
		      current_column(NextCol),
		      Cl ^^ display(NextCol),
		      E ^^ display(check, NextCol)
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      E ^^ functor(F)
	     ),
	     (args(As) ::-
		      E ^^ args(As)
	     ).



	/*------------------------------------------------------------------*/

	element_list ::=
		term_expression(list, 0, '=<') ^^ T,
		!,
		comments ^^ C,
		element_list1 ^^ L,
		{T ^^ len(Lt),
		 L ^^ len(Ll),
		 Len is Lt + Ll
		}
	 <:> (display(Mode, Col) ::-
		      display_element_list(Mode, Col, Len, T, C, L)
	     ),
	     (len(Len)),
	     (functor('.')),
	     (args( [T, L])).

	element_list ::=
		rbracket
	 <:> (display(_, Col) ::-
		      adjusted_pos(Col, Ncol),
		      pos(Ncol),
		      fp_write(']')
	     ),
	     (len(1)),
	     (functor('[]')),
	     (args( [])).


	/*------------------------------------------------------------------*/

	element_list1 ::=
		comma,
		!, /* performance */ 
		comments ^^ C,
		element_list ^^ L,
		{L ^^ len(Ll),
		 Len is 2 + Ll
		}
	 <:> (display(Mode, Col) ::-
		      fp_write(','),
		      adjusted_pos(Col, 1, Acol),
		      pos(Acol),
		      C ^^ display(Acol),
		      L ^^ display(Mode, Col)
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      L ^^ functor(F)
	     ),
	     (args(Args) ::-
		      L ^^ args(Args)
	     ).

	element_list1 ::=
		vertbar,
		!, /* performance */ 
		comments ^^ C1,
		term_expression(list, 0, '=<') ^^ T,
		comments ^^ C2,
		rbracket,
		{T ^^ len(Lt),
		 Len is 2 + Lt
		}
	 <:> (display(_Mode, Col) ::-
		      fp_write(' |'),
		      adjusted_pos(Col, 1, Acol1),
		      C1 ^^ display(Acol1),
		      adjusted_pos(Col, 1, Acol2),
		      T ^^ display(Acol2),
		      adjusted_pos(Col, 1, Acol3),
		      C2 ^^ display(Acol3),
		      fp_write(']')
	     ),
	     (len(Len)),
	     (functor(F) ::-
		      T ^^ functor(F)
	     ),
	     (args(Args) ::-
		      T ^^ args(Args)
	     ).

	element_list1 ::=
		rbracket
	 <:> (display(_Mode, Col) ::-
		      adjusted_pos(Col, Ncol),
		      pos(Ncol),
		      fp_write(']')
	     ),
	     (len(1)),
	     (functor(' []')),
	     (args( [])).


	/*------------------------------------------------------------------*/
	/* term_structure parses a structure (a functor with an argument list)
	   or an atom (a 0-arity structure).
	   */  
	term_structure ::=
		function ^^ F,
		term_structure_tail ^^ A,
		{F ^^ len(Lf),
		 A ^^ len(La),
		 Len is Lf + La
		}
	 <:> (display(Col) ::-
		      F ^^ display(Col),
		      adjusted_pos(Col, Ncol),
		      A ^^ display(Ncol)
	     ),
	     (len(Len)),
	     (functor(Fn) ::-
		      F ^^ functor(Fn)
	     ),
	     (args(Args) ::-
		      A ^^ args(Args)
	     ).


	/*------------------------------------------------------------------*/

	term_structure_tail ::=
		lparen,
		!,
		term_args ^^ T,
		comments ^^ C,
		rparen,
		{T ^^ len(Lt),
		 Len is Lt + 2
		}
	 <:> (display(Col) ::-
		      tst_display(Col, T, C)
	     ),
	     (len(Len)),
	     (args(Args) ::-
		      T ^^ args(Args)
	     ).

	term_structure_tail ::=
		 []
	 <:> (display(_)),
	     (len(0)),
	     (args( [])).

	/*------------------------------------------------------------------*/
	/* term_args parses the argument list of a structure, not including the
	   outermost parentheses. It requires that there be at least one argument
	   .
	   */  
	term_args ::=
		comments ^^ C,
		argument_list ^^ T,
		{T ^^ len(Len)}
	 <:> (display(Col) ::-
		      adjusted_pos(Col, NextCol),
		      C ^^ display(NextCol),
		      T ^^ display(check, NextCol)
	     ),
	     (len(Len)),
	     (args(Args) ::-
		      T ^^ args(Args)
	     ).



	/*------------------------------------------------------------------*/

	argument_list ::=
		term_expression(argls, 0, '=<') ^^ T,
		comments ^^ C,
		argument_list1 ^^ L,
		{T ^^ len(Lt),
		 L ^^ len(Ll),
		 Len is Lt + Ll
		}
	 <:> (display(Mode, Col) ::-
		      fit(Mode, Col, NextMode, Acol1, Len),
		      T ^^ display(Acol1),
		      adjusted_pos(Col, Acol2),
		      C ^^ display(Acol2),
		      L ^^ display(NextMode, Col)
	     ),
	     (len(Len)),
	     (args( [T | Args]) ::-
		      L ^^ args(Args)
	     ).



	/*------------------------------------------------------------------*/

	argument_list1 ::=
		comma,
		!, /* performance */ 
		comments ^^ C,
		argument_list ^^ L,
		{L ^^ len(Ll),
		 Len is 2 + Ll
		}
	 <:> (display(Mode, Col) ::-
		      fp_write(','),
		      adjusted_pos(Col, 1, Acol),
		      pos(Acol),
		      C ^^ display(Acol),
		      L ^^ display(Mode, Col)
	     ),
	     (len(Len)),
	     (args(Args) ::-
		      L ^^ args(Args)
	     ).

	argument_list1 ::=
		 []
	 <:> (display(_, _)),
	     (len(0)),
	     (args( [])).

:- end_object.
