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


:- initialization((
	logtalk_load(basic_types(loader)),
	logtalk_load(os(loader)),
	logtalk_load(hook_flows(hook_pipeline), [optimize(on)]),
	logtalk_load(hook_objects(write_to_stream_hook), [optimize(on)]),
	logtalk_load('../../dctg-logtalk/loader'),
	logtalk_load([
		'../lex/loader'
	], [
		optimize(on)
	]),
	logtalk_load([
		'src/fpu_output_position',
		'src/fpu_fit',
		'src/fpu_string',
		'src/fpu_display_item',
		'src/fpu_node_evaluation',
		'src/fpu_operator_class',
		'src/fpu_known_op',
		'src/fpu_display',
		'src/fpu_miscellaneous',
		'src/fp_named_characters',
		'src/fp_error_skip',
		'src/fp_whitespace_handling',
		'src/fp_repeated_characters',
		'src/fp_function',
		'src/fp_op',
		'src/fp_format_directives',
		'src/fp_comment_items',
		'src/fp_comment_body',
		'src/fp_trivial_comment',
		'src/fp_comment',
		'src/fp_trailing_comment',
		'src/fp_comments',
		'src/fp_term_expression',
		'src/fp_clause_group',
		'src/format_prolog'
	], [hook(dctg),
		optimize(on)
	])
)).
