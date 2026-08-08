/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#ifndef CONSOLE_H
#define CONSOLE_H

#include "globldef.h"

#define __CONSOLE_COLOR_BLACK 0x0
#define __CONSOLE_COLOR_BLUE 0x1
#define __CONSOLE_COLOR_GREEN 0x2
#define __CONSOLE_COLOR_CYAN 0x3
#define __CONSOLE_COLOR_RED 0x4
#define __CONSOLE_COLOR_MAGENTA 0x5
#define __CONSOLE_COLOR_BROWN 0x6
#define __CONSOLE_COLOR_LTGRAY 0x7
#define __CONSOLE_COLOR_DKGRAY 0x8
#define __CONSOLE_COLOR_LTBLUE 0x9
#define __CONSOLE_COLOR_LTGREEN 0xa
#define __CONSOLE_COLOR_LTCYAN 0xb
#define __CONSOLE_COLOR_LTRED 0xc
#define __CONSOLE_COLOR_LTMAGENTA 0xd
#define __CONSOLE_COLOR_YELLOW 0xe
#define __CONSOLE_COLOR_WHITE 0xf

#define CONSOLE_TEXTCOLOR_BLACK __CONSOLE_COLOR_BLACK
#define CONSOLE_TEXTCOLOR_BLUE __CONSOLE_COLOR_BLUE
#define CONSOLE_TEXTCOLOR_GREEN __CONSOLE_COLOR_GREEN
#define CONSOLE_TEXTCOLOR_CYAN __CONSOLE_COLOR_CYAN
#define CONSOLE_TEXTCOLOR_RED __CONSOLE_COLOR_RED
#define CONSOLE_TEXTCOLOR_MAGENTA __CONSOLE_COLOR_MAGENTA
#define CONSOLE_TEXTCOLOR_BROWN __CONSOLE_COLOR_BROWN
#define CONSOLE_TEXTCOLOR_LTGRAY __CONSOLE_COLOR_LTGRAY
#define CONSOLE_TEXTCOLOR_DKGRAY __CONSOLE_COLOR_DKGRAY
#define CONSOLE_TEXTCOLOR_LTBLUE __CONSOLE_COLOR_LTBLUE
#define CONSOLE_TEXTCOLOR_LTGREEN __CONSOLE_COLOR_LTGREEN
#define CONSOLE_TEXTCOLOR_LTCYAN __CONSOLE_COLOR_LTCYAN
#define CONSOLE_TEXTCOLOR_LTRED __CONSOLE_COLOR_LTRED
#define CONSOLE_TEXTCOLOR_LTMAGENTA __CONSOLE_COLOR_LTMAGENTA
#define CONSOLE_TEXTCOLOR_YELLOW __CONSOLE_COLOR_YELLOW
#define CONSOLE_TEXTCOLOR_WHITE __CONSOLE_COLOR_WHITE

#define CONSOLE_BKCOLOR_BLACK (__CONSOLE_COLOR_BLACK << 4)
#define CONSOLE_BKCOLOR_BLUE (__CONSOLE_COLOR_BLUE << 4)
#define CONSOLE_BKCOLOR_GREEN (__CONSOLE_COLOR_GREEN << 4)
#define CONSOLE_BKCOLOR_CYAN (__CONSOLE_COLOR_CYAN << 4)
#define CONSOLE_BKCOLOR_RED (__CONSOLE_COLOR_RED << 4)
#define CONSOLE_BKCOLOR_MAGENTA (__CONSOLE_COLOR_MAGENTA << 4)
#define CONSOLE_BKCOLOR_BROWN (__CONSOLE_COLOR_BROWN << 4)
#define CONSOLE_BKCOLOR_LTGRAY (__CONSOLE_COLOR_LTGRAY << 4)

/*Depending on the configuration of the graphics device on your PC, the following background colors may or may not be available*/

#define CONSOLE_BKCOLOR_DKGRAY (__CONSOLE_COLOR_DKGRAY << 4)
#define CONSOLE_BKCOLOR_LTBLUE (__CONSOLE_COLOR_LTBLUE << 4)
#define CONSOLE_BKCOLOR_LTGREEN (__CONSOLE_COLOR_LTGREEN << 4)
#define CONSOLE_BKCOLOR_LTCYAN (__CONSOLE_COLOR_LTCYAN << 4)
#define CONSOLE_BKCOLOR_LTRED (__CONSOLE_COLOR_LTRED << 4)
#define CONSOLE_BKCOLOR_LTMAGENTA (__CONSOLE_COLOR_LTMAGENTA << 4)
#define CONSOLE_BKCOLOR_YELLOW (__CONSOLE_COLOR_YELLOW << 4)
#define CONSOLE_BKCOLOR_WHITE (__CONSOLE_COLOR_WHITE << 4)

#define CONSOLE_TEXTCOLOR_DEFAULT CONSOLE_TEXTCOLOR_LTGRAY
#define CONSOLE_BKCOLOR_DEFAULT CONSOLE_BKCOLOR_BLACK
#define CONSOLE_COLOR_DEFAULT (CONSOLE_BKCOLOR_DEFAULT | CONSOLE_TEXTCOLOR_DEFAULT)

#define CONSOLE_NCHARS 80U
#define CONSOLE_NLINES 25U

/*
 * console_init(): Initializes the console resource.
 * Should be called before calling any other functions in this file.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool console_init(void) __attribute__((__section__(".__kernel__")));

/*
 * console_clearscreen(): clear all text on screen as well as the background color.
 * All text gets erased and the background returns to default black.
 */

__EXTERNC__ void console_clearscreen(void) __attribute__((__section__(".__kernel__")));

/*
 * console_cleartext(): similar to console_clearscreen(), clear all text on screen, but preserve text background color
 * All text gets erased, but the background color gets preserved and fills up the whole screen.
 */

__EXTERNC__ void console_cleartext(void) __attribute__((__section__(".__kernel__")));

/*
 * console_set_cursor_position(): set the current cursor position (horizontal offset (cx) and line offset (cy))
 *
 * If either cx or cy is set to -1, function will maintain the current value of that offset, keeping it unchanged.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool console_set_cursor_position(intptr_t cx, intptr_t cy) __attribute__((__section__(".__kernel__")));

/*
 * console_get_cursor_position(): get the current cursor position (horizontal offset (cx) and line offset(cy))
 *
 * p_cx and p_cy are pointers that receive data. Those pointers may be set to NULL if that data is not used.
 */

__EXTERNC__ void console_get_cursor_position(uint8_t *p_cx, uint8_t *p_cy) __attribute__((__section__(".__kernel__")));

/*
 * _console_set_cursor_position_index8() and _console_set_cursor_position_index16()
 *
 * Set the current cursor position based on the video memory offset (byte-index or word-index).
 *
 * Returns "true" if successful, "false" otherwise.
 *
 * _console_get_cursor_position_index8() and _console_get_cursor_position_index16()
 *
 * Get the current cursor position based on the video memory offset (byte-index or word-index).
 */

__EXTERNC__ bool _console_set_cursor_position_index8(uintptr_t vram_index) __attribute__((__section__(".__kernel__")));
__EXTERNC__ uintptr_t _console_get_cursor_position_index8(void) __attribute__((__section__(".__kernel__")));

__EXTERNC__ bool _console_set_cursor_position_index16(uintptr_t vram_index) __attribute__((__section__(".__kernel__")));
__EXTERNC__ uintptr_t _console_get_cursor_position_index16(void) __attribute__((__section__(".__kernel__")));

/*
 * console_set_color(): set the new text and background colors.
 *
 * If value is set to -1, function will maintain the current value of that color, keeping it unchanged.
 */

__EXTERNC__ void console_set_color(intptr_t textcolor, intptr_t bkcolor) __attribute__((__section__(".__kernel__")));

/*
 * console_get_color(): get the current text and background colors.
 *
 * p_textcolor and p_bkcolor are pointers that receive data. Those pointers may be set to NULL if that data is not used.
 */

__EXTERNC__ void console_get_color(uint8_t *p_textcolor, uint8_t *p_bkcolor) __attribute__((__section__(".__kernel__")));

/*
 * _console_set_color() and _console_get_color():
 * Get/Set the current console color byte value.
 */

__EXTERNC__ void _console_set_color(uint8_t colorbyte) __attribute__((__section__(".__kernel__")));
__EXTERNC__ uint8_t _console_get_color(void) __attribute__((__section__(".__kernel__")));

/*
 * console_enable_blink() and console_blink_is_enabled()
 * Set/Get the current setting for blinking text on console.
 * Keep in mind that this setting may or may not be available, depending on your PC video device configuration.
 */

__EXTERNC__ void console_enable_blink(bool enable) __attribute__((__section__(".__kernel__")));
__EXTERNC__ bool console_blink_is_enabled(void) __attribute__((__section__(".__kernel__")));

/*console_printchar(): prints a single character at the current cursor position.*/

__EXTERNC__ void console_printchar(char c) __attribute__((__section__(".__kernel__")));

/*
 * console_printtext() and console_printtextlen()
 * Prints a C style string at the current cursor position.
 *
 * console_printtext prints a null-terminated C style string, while
 * console_printtextlen prints a C style string of specified length.
 *
 * Returns "true" if successful, "false" otherwise.
 */

__EXTERNC__ bool console_printtext(const char *str) __attribute__((__section__(".__kernel__")));
__EXTERNC__ bool console_printtextlen(const char *str, uintptr_t len) __attribute__((__section__(".__kernel__")));

/*console_fillscreen_char(): fills the whole screen with a specified character, preserving text and background colors.*/

__EXTERNC__ void console_fillscreen_char(char c) __attribute__((__section__(".__kernel__")));

#endif /*CONSOLE_H*/

