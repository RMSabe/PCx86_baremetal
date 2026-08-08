/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#include "cstr.h"

intptr_t __attribute__((__section__(".__kernel__"))) cstr_getlength(const char *str)
{
	uintptr_t _len;

	if(str == NULL) return -1;

	_len = 0u;
	while(str[_len] != '\0') _len++;

	return (intptr_t) _len;
}

intptr_t __attribute__((__section__(".__kernel__"))) cstr_locatechar(const char *str, char c)
{
	uintptr_t _nlen;
	uintptr_t _nchar;

	if(str == NULL) return -1;

	_nlen = (uintptr_t) cstr_getlength(str);

	if(c == '\0') return _nlen;

	_nchar = 0u;
	while(_nchar < _nlen)
	{
		if(str[_nchar] == c) return (intptr_t) _nchar;
		_nchar++;
	}

	return -1;
}

bool __attribute__((__section__(".__kernel__"))) cstr_compare(const char *str1, const char *str2)
{
	uintptr_t _num1;
	uintptr_t _num2;

	if(str1 == NULL) return false;
	if(str2 == NULL) return false;

	_num1 = (uintptr_t) cstr_getlength(str1);
	_num2 = (uintptr_t) cstr_getlength(str2);

	if(_num1 != _num2) return false;

	_num1 = 0;
	while(_num1 < _num2)
	{
		if(str1[_num1] != str2[_num1]) return false;
		_num1++;
	}

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_compare_upto_len(const char *str1, const char *str2, uintptr_t stop_index, bool fail_if_nolen)
{
	uintptr_t _num1;
	uintptr_t _num2;

	if(str1 == NULL) return false;
	if(str2 == NULL) return false;

	_num1 = (uintptr_t) cstr_getlength(str1);
	_num2 = (uintptr_t) cstr_getlength(str2);

	if((_num1 < stop_index) && (_num2 < stop_index))
	{
		if(fail_if_nolen) return false;

		return cstr_compare(str1, str2);
	}

	if((_num1 < stop_index) || (_num2 < stop_index)) return false;

	_num1 = 0u;
	while(_num1 < stop_index)
	{
		if(str1[_num1] != str2[_num1]) return false;
		_num1++;
	}

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_compare_upto_char(const char *str1, const char *str2, char stop_char, bool fail_if_nochar)
{
	intptr_t _num1;
	intptr_t _num2;

	if(str1 == NULL) return false;
	if(str2 == NULL) return false;

	_num1 = cstr_locatechar(str1, stop_char);
	_num2 = cstr_locatechar(str2, stop_char);

	if((_num1 < 0) && (_num2 < 0))
	{
		if(fail_if_nochar) return false;

		return cstr_compare(str1, str2);
	}

	if(_num1 < 0) goto _l_cstr_compare_upto_char_compareloop;

	if((_num2 < 0) || (_num1 < _num2)) _num2 = _num1;

_l_cstr_compare_upto_char_compareloop:

	_num1 = 0;
	while(_num1 < _num2)
	{
		if(str1[_num1] != str2[_num1]) return false;
		_num1++;
	}

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_copy(const char *input_str, char *output_str, uintptr_t bufferout_length)
{
	uintptr_t stop_index;

	if(input_str == NULL) return false;
	if(output_str == NULL) return false;
	if(!bufferout_length) return false;

	stop_index = (uintptr_t) cstr_getlength(input_str);

	if(stop_index >= bufferout_length) stop_index = bufferout_length - 1u;

	_memcpy(output_str, input_str, stop_index);

	output_str[stop_index] = '\0';

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_copy_upto_len(const char *input_str, char *output_str, uintptr_t bufferout_length, uintptr_t stop_index, bool append_nullchar)
{
	uintptr_t input_len;

	if(input_str == NULL) return false;
	if(output_str == NULL) return false;
	if(!bufferout_length) return false;

	output_str[bufferout_length - 1u] = '\0'; /*Write null char terminator at the end of output buffer, for safety.*/

	input_len = (uintptr_t) cstr_getlength(input_str);
	if(input_len < stop_index) stop_index = input_len;

	if(stop_index >= bufferout_length) stop_index = bufferout_length - 1u;

	_memcpy(output_str, input_str, stop_index);

	if(append_nullchar) output_str[stop_index] = '\0';

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_copy_upto_char(const char *input_str, char *output_str, uintptr_t bufferout_length, char stop_char, bool append_nullchar)
{
	intptr_t _num1;

	if(input_str == NULL) return false;
	if(output_str == NULL) return false;
	if(!bufferout_length) return false;

	_num1 = cstr_locatechar(input_str, stop_char);

	if(_num1 < 0) _num1 = cstr_getlength(input_str);

	return cstr_copy_upto_len(input_str, output_str, bufferout_length, (uintptr_t) _num1, append_nullchar);
}

bool __attribute__((__section__(".__kernel__"))) cstr_tolower(char *str, uintptr_t buffer_length)
{
	uintptr_t _len;
	uintptr_t _nchar;

	if(str == NULL) return false;
	if(!buffer_length) return false;

	str[buffer_length - 1u] = '\0';

	_len = (uintptr_t) cstr_getlength(str);

	_nchar = 0u;
	while(_nchar < _len)
	{
		if((str[_nchar] >= 0x41) && (str[_nchar] <= 0x5a)) str[_nchar] |= 0x20;
		_nchar++;
	}

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_toupper(char *str, uintptr_t buffer_length)
{
	uintptr_t _len;
	uintptr_t _nchar;

	if(str == NULL) return false;
	if(!buffer_length) return false;

	str[buffer_length - 1u] = '\0';

	_len = (uintptr_t) cstr_getlength(str);

	_nchar = 0u;
	while(_nchar < _len)
	{
		if((str[_nchar] >= 0x61) && (str[_nchar] <= 0x7a)) str[_nchar] &= 0xdf;
		_nchar++;
	}

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_u32_to_text(char *str, uintptr_t buffer_length, uint32_t value, bool append_nullchar)
{
	uintptr_t _nchar;
	uintptr_t _div;
	char _char;

	if(str == NULL) return false;
	if(buffer_length < 11u) return false;

	str[buffer_length - 1u] = '\0';

	_div = 1000000000u;

	_nchar = 0u;

	do{
		_char = (char) (value/_div);
		_char |= 0x30;
		str[_nchar] = _char;
		_nchar++;
		value %= _div;
		_div /= 10;
	}while(_div > 1);

	_char = (char) value;
	_char |= 0x30;
	str[_nchar] = _char;

	if(append_nullchar) str[_nchar + 1u] = '\0';

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_i32_to_text(char *str, uintptr_t buffer_length, int32_t value, bool append_nullchar)
{
	if(str == NULL) return false;
	if(buffer_length < 12u) return false;

	if(value < 0)
	{
		value = ~value;
		value++;
		str[0] = '-';
		str = (char*) (((uintptr_t) str) + 1u);
		buffer_length--;
	}

	return cstr_u32_to_text(str, buffer_length, (uintptr_t) value, append_nullchar);
}

bool __attribute__((__section__(".__kernel__"))) cstr_text_to_i32(const char *input_str, int32_t *p_output)
{
	intptr_t _input_len;
	intptr_t _nchar;
	int32_t _output;
	int32_t _mul;
	char _char;

	if(input_str == NULL) return false;

	_input_len = cstr_getlength(input_str);
	if(_input_len <= 0) return false;

	_output = 0;
	_mul = 1;

	_nchar = _input_len - 1;
	while(_nchar > 0)
	{
		_char = input_str[_nchar];
		if(_char < 0x30 || _char > 0x39) return false;

		_char &= 0xf;

		_output += ((int32_t) _char)*_mul;
		_mul *= 10;

		_nchar--;
	}

	_char = input_str[_nchar];
	if((_char >= 0x30) && (_char <= 0x39))
	{
		_char &= 0xf;
		_output += ((int32_t) _char)*_mul;

		goto _l_cstr_text_to_i32_success;
	}

	if((_char == '-') && (_input_len > 1))
	{
		_output *= -1;

		goto _l_cstr_text_to_i32_success;
	}

	return false;

_l_cstr_text_to_i32_success:

	if(p_output != NULL) *p_output = _output;
	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_f32_to_text(char *str, uintptr_t buffer_length, float value, bool append_nullchar)
{
	uintptr_t _nloop;
	uintptr_t _nchar;
	int32_t _i32_0;
	int32_t _i32_1;
	int32_t _div;
	char _char;

	if(str == NULL) return false;
	if(buffer_length < 11u) return false;

	str[buffer_length - 1u] = '\0';

	_nchar = 0u;

	if(*((uint32_t*) &value) & 0x80000000)
	{
		str[0] = '-';
		_nchar++;

		*((uint32_t*) &value) &= 0x7fffffff;
	}

	_i32_1 = (int32_t) value;

	value -= ((float) _i32_1);
	value *= 1000000.0f;
	value = _round_f32(value);

	_i32_0 = (int32_t) value;

	_i32_1 += _i32_0/1000000;
	_i32_0 %= 1000000;

	if(!cstr_u32_to_text(&str[_nchar], (buffer_length - _nchar), (uint32_t) _i32_1, true)) return false;

	_nchar = (uintptr_t) cstr_getlength(str);

	if(_nchar >= (buffer_length - 1u)) return true;

	str[_nchar] = '.';
	_nchar++;

	_div = 100000;

	_nloop = 0u;
	while(_nloop < 6u)
	{
		if(_nchar >= (buffer_length - 1u)) break;

		_char = (char) (_i32_0/_div);
		_char |= 0x30;
		str[_nchar] = _char;
		_nchar++;

		_i32_0 %= _div;
		_div /= 10;

		_nloop++;
	}

	if(append_nullchar) str[_nchar] = '\0';

	return true;
}

bool __attribute__((__section__(".__kernel__"))) cstr_text_to_f32(const char *input_str, float *p_output)
{
	intptr_t _input_len;
	intptr_t _nchar;
	intptr_t _dot_index;
	int32_t _i32;
	float _output;
	float _f32;
	char _char;

	if(input_str == NULL) return false;

	_input_len = cstr_getlength(input_str);
	if(_input_len <= 0) return false;

	_dot_index = cstr_locatechar(input_str, '.');

	if(_dot_index < 0)
	{
		if(!cstr_text_to_i32(input_str, &_i32)) return false;
		_output = (float) _i32;
		goto _l_cstr_text_to_f32_success;
	}

	_output = 0.0f;

	_nchar = _dot_index + 1;
	_f32 = 10.0f;

	while(_nchar < _input_len)
	{
		_char = input_str[_nchar];
		if((_char < 0x30) || (_char > 0x39)) return false;

		_char &= 0xf;

		_output += ((float) _char)/_f32;
		_f32 *= 10.0f;

		_nchar++;
	}

	if(!_dot_index) goto _l_cstr_text_to_f32_success;

	_nchar = _dot_index - 1;
	_f32 = 1.0f;

	while(_nchar > 0)
	{
		_char = input_str[_nchar];
		if((_char < 0x30) || (_char > 0x39)) return false;

		_char &= 0xf;

		_output += ((float) _char)*_f32;
		_f32 *= 10.0f;

		_nchar--;
	}

	_char = input_str[0];

	if((_char >= 0x30) && (_char <= 0x39))
	{
		_char &= 0xf;
		_output += ((float) _char)*_f32;
		goto _l_cstr_text_to_f32_success;
	}

	if(_char == '-')
	{
		*((uint32_t*) &_output) |= 0x80000000;
		goto _l_cstr_text_to_f32_success;
	}

	return false;

_l_cstr_text_to_f32_success:

	if(p_output != NULL) *p_output = _output;

	return true;
}

