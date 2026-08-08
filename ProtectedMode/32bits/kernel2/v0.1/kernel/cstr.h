/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#ifndef CSTR_H
#define CSTR_H

#include "globldef.h"

/*
 * cstr_getlength(): Retrieve the length of a null-terminated C style string.
 *
 * Returns string length, or -1 if error.
 */

__EXTERNC__ intptr_t cstr_getlength(const char *str) __attribute__((__section__(".__kernel__")));

/*
 * cstr_locatechar(): Retrieve the index of the first found specified character in a null-terminated C style string.
 *
 * Returns character index, or -1 if character is not present or error.
 */

__EXTERNC__ intptr_t cstr_locatechar(const char *str, char c) __attribute__((__section__(".__kernel__")));

/*
 * cstr_compare(): compare 2 null-terminated C style strings.
 *
 * Returns "true" if strings are equal, "false" if strings are not equal or error.
 */

__EXTERNC__ bool cstr_compare(const char *str1, const char *str2) __attribute__((__section__(".__kernel__")));

/*
 * cstr_compare_upto_len(): compare 2 null-terminated C style strings up to a certain index (stop_index).
 *
 * "fail_if_nolen" determines the function behavior if both strings are shorter than "stop_index".
 * If set to "true", the function automatically returns "false".
 * If set to "false", the function will run normal "cstr_compare()" on the strings.
 *
 * Returns "true" if strings are equal up to "stop_index", "false" if strings are not equal up to "stop_index" or error.
 */

__EXTERNC__ bool cstr_compare_upto_len(const char *str1, const char *str2, uintptr_t stop_index, bool fail_if_nolen) __attribute__((__section__(".__kernel__")));

/*
 * cstr_compare_upto_char(): compare 2 null-terminated C style strings up to the first instance of a given character (stop_char).
 * This function behaves similarly to cstr_compare_upto_len().
 *
 * "fail_if_nochar" determines the function behavior if neither strings have "stop_char".
 * If set to "true", the function automatically returns "false".
 * If set to "false", the function will run normal "cstr_compare()" on the strings.
 *
 * Returns "true" if strings are equal up to "stop_char", "false" if strings are not equal up to "stop_char" or error.
 */

__EXTERNC__ bool cstr_compare_upto_char(const char *str1, const char *str2, char stop_char, bool fail_if_nochar) __attribute__((__section__(".__kernel__")));

/*
 * cstr_copy(): copy a null-terminated C style string to an output buffer. Append a null-terminator character at the end.
 *
 * If output buffer is shorter than input string, the exceeding text will be truncated. A null-terminator character will be written at the end of output buffer.
 *
 * Returns "true" if successful, "false" if error.
 */

__EXTERNC__ bool cstr_copy(const char *input_str, char *output_str, uintptr_t bufferout_length) __attribute__((__section__(".__kernel__")));

/*
 * cstr_copy_upto_len(): copy a null-terminated C style string to an output buffer up to a specified index (stop_index).
 *
 * If append_nullchar is set to "true", function will write a null-terminator character after the copied text.
 * Function will always write a null-terminator character at the end of the buffer, regardless of append_nullchar.
 *
 * If "input_str" is shorter than "stop_index", function will behave like "cstr_copy()".
 *
 * If "input_str" is longer than output buffer length, the exceeding length of "input_str" will be truncated at the output.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool cstr_copy_upto_len(const char *input_str, char *output_str, uintptr_t bufferout_length, uintptr_t stop_index, bool append_nullchar) __attribute__((__section__(".__kernel__")));

/*
 * cstr_copy_upto_char(): copy a null-terminated C style string to an output buffer up to the first instance of a specified character (stop_char).
 * This function behaves similarly to cstr_copy_upto_len().
 *
 * If append_nullchar is set to "true", function will write a null-terminator character after the copied text.
 * Function will always write a null-terminator character at the end of the buffer, regardless of append_nullchar.
 *
 * If "stop_char" is not present in "input_str", function will behave like "cstr_copy()".
 *
 * If "input_str" is longer than output buffer length, the exceeding length of "input_str" will be truncated at the output.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool cstr_copy_upto_char(const char *input_str, char *output_str, uintptr_t bufferout_length, char stop_char, bool append_nullchar) __attribute__((__section__(".__kernel__")));

/*
 * cstr_tolower() and cstr_toupper(): converts all letters of a C style string to lower-case/upper-case.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool cstr_tolower(char *str, uintptr_t buffer_length) __attribute__((__section__(".__kernel__")));
__EXTERNC__ bool cstr_toupper(char *str, uintptr_t buffer_length) __attribute__((__section__(".__kernel__")));

/*
 * cstr_u32_to_text() and cstr_i32_to_text():
 * Convert a 32bit integer (unsigned/signed) into a C style string.
 * If append_nullchar is set to "true", it will append a null-terminator after the number.
 *
 * Function will always write a null-terminator at the end of the buffer, for safety.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool cstr_u32_to_text(char *str, uintptr_t buffer_length, uint32_t value, bool append_nullchar) __attribute__((__section__(".__kernel__")));
__EXTERNC__ bool cstr_i32_to_text(char *str, uintptr_t buffer_length, int32_t value, bool append_nullchar) __attribute__((__section__(".__kernel__")));

/*
 * cstr_text_to_i32(): Convert a null-terminated C style string into an int32_t.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool cstr_text_to_i32(const char *input_str, int32_t *p_output) __attribute__((__section__(".__kernel__")));

/*
 * cstr_f32_to_text() : behaves similarly to cstr_i32_to_text(), but for 32bit float.
 *
 * Returns "true" if successful, "false" if error.
 */

__EXTERNC__ bool cstr_f32_to_text(char *str, uintptr_t buffer_length, float value, bool append_nullchar) __attribute__((__section__(".__kernel__")));

/*
 * cstr_text_to_f32() : behaves similarly to cstr_text_to_i32(), but for 32bit float.
 *
 * Returns "true" if successful, "false" if error.
 */

__EXTERNC__ bool cstr_text_to_f32(const char *input_str, float *p_output) __attribute__((__section__(".__kernel__")));

static inline bool cstr_uptr_to_text(char *str, uintptr_t buffer_length, uintptr_t value, bool append_nullchar)
{
	return cstr_u32_to_text(str, buffer_length, (uint32_t) value, append_nullchar);
}

static inline bool cstr_iptr_to_text(char *str, uintptr_t buffer_length, intptr_t value, bool append_nullchar)
{
	return cstr_i32_to_text(str, buffer_length, (int32_t) value, append_nullchar);
}

static inline bool cstr_text_to_iptr(const char *input_str, intptr_t *p_output)
{
	return cstr_text_to_i32(input_str, (int32_t*) p_output);
}

#endif /*CSTR_H*/

