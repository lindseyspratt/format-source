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


:- object(fpl_quoted_char_list).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-02-22,
		comment is 'whitespace grammar for the format prolog source system lexical analysis.'
	]).

	:- public(quoted_char_list//2).
	:- mode(quoted_char_list(+integer, -list), one).
	:- info(quoted_char_list//2, [
		comment is 'Parse the beginning of a list of codes into a list of quoted string codes that ends with the specified `Quote` code.',
		argnames is ['Quote', 'Codes']
	]).

	quoted_char_list(Quote, [Quote, Quote|OtherCodes]) -->
	  [Quote],
	  [Quote],
	  !,
	  quoted_char_list(Quote, OtherCodes).
	quoted_char_list(Quote, [Quote]) -->
	  [Quote],
	  !.
	quoted_char_list(Quote, [Code|OtherCodes]) -->
	  [Code],
	  quoted_char_list(Quote, OtherCodes).
  
:- end_object.
