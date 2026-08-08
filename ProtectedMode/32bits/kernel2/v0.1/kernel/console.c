/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#include "console.h"
#include "cstr.h"

#define __CONSOLE_VRAM_ADDR32 0xb8000
#define __CONSOLE_VRAM_SIZE_CHARS (CONSOLE_NCHARS*CONSOLE_NLINES)
#define __CONSOLE_VRAM_SIZE_BYTES (__CONSOLE_VRAM_SIZE_CHARS*2U)

#define __CONSOLE_BLINK_BIT 0x80

static __attribute__((__aligned__(PTR_SIZE_BITS) , __section__(".__data__"))) uintptr_t _console_vram_index16;
static __attribute__((__section__(".__data__"))) uint8_t _console_color;

static void _console_addlinefeed(void) __attribute__((__section__(".__kernel__")));
static void _console_addcarriagereturn(void) __attribute__((__section__(".__kernel__")));

bool __attribute__((__section__(".__kernel__"))) console_init(void)
{
	console_clearscreen();
	_console_vram_index16 = 0u;
	_console_color = CONSOLE_COLOR_DEFAULT;

	return true;
}

void __attribute__((__section__(".__kernel__"))) console_clearscreen(void)
{
	_memset((void*) __CONSOLE_VRAM_ADDR32, 0, __CONSOLE_VRAM_SIZE_BYTES);
	return;
}

void __attribute__((__section__(".__kernel__"))) console_cleartext(void)
{
	uintptr_t _index;
	uint16_t _word;

	_word = (_console_color << 8);

	for(_index = 0u; _index < __CONSOLE_VRAM_SIZE_CHARS; _index++) ((uint16_t*) __CONSOLE_VRAM_ADDR32)[_index] = _word;

	return;
}

bool __attribute__((__section__(".__kernel__"))) console_set_cursor_position(intptr_t cx, intptr_t cy)
{
	if((cx >= CONSOLE_NCHARS) || (cy >= CONSOLE_NLINES)) return false;

	if(cy >= 0)
	{
		_console_vram_index16 %= CONSOLE_NCHARS;
		_console_vram_index16 += cy*CONSOLE_NCHARS;
	}

	if(cx >= 0)
	{
		_console_vram_index16 -= (_console_vram_index16%CONSOLE_NCHARS);
		_console_vram_index16 += cx;
	}

	return true;
}

void __attribute__((__section__(".__kernel__"))) console_get_cursor_position(uint8_t *p_cx, uint8_t *p_cy)
{
	if(p_cx != NULL) *p_cx = (uint8_t) (_console_vram_index16%CONSOLE_NCHARS);
	if(p_cy != NULL) *p_cy = (uint8_t) (_console_vram_index16/CONSOLE_NCHARS);

	return;
}

bool __attribute__((__section__(".__kernel__"))) _console_set_cursor_position_index8(uintptr_t vram_index)
{
	if(vram_index >= __CONSOLE_VRAM_SIZE_BYTES) return false;

	_console_vram_index16 = (vram_index >> 1);
	return true;
}

uintptr_t __attribute__((__section__(".__kernel__"))) _console_get_cursor_position_index8(void)
{
	return (_console_vram_index16 << 1);
}

bool __attribute__((__section__(".__kernel__"))) _console_set_cursor_position_index16(uintptr_t vram_index)
{
	if(vram_index >= __CONSOLE_VRAM_SIZE_CHARS) return false;

	_console_vram_index16 = vram_index;
	return true;
}

uintptr_t __attribute__((__section__(".__kernel__"))) _console_get_cursor_position_index16(void)
{
	return _console_vram_index16;
}

void __attribute__((__section__(".__kernel__"))) console_set_color(intptr_t textcolor, intptr_t bkcolor)
{
	if(textcolor >= 0)
	{
		textcolor &= 0xf;
		_console_color &= 0xf0;
		_console_color |= textcolor;
	}

	if(bkcolor >= 0)
	{
		bkcolor &= 0xf0;
		_console_color &= 0xf;
		_console_color |= bkcolor;
	}

	return;
}

void __attribute__((__section__(".__kernel__"))) console_get_color(uint8_t *p_textcolor, uint8_t *p_bkcolor)
{
	if(p_textcolor != NULL) *p_textcolor = (_console_color & 0xf);
	if(p_bkcolor != NULL) *p_bkcolor = (_console_color & 0xf0);

	return;
}

void __attribute__((__section__(".__kernel__"))) _console_set_color(uint8_t colorbyte)
{
	_console_color = colorbyte;
	return;
}

uint8_t __attribute__((__section__(".__kernel__"))) _console_get_color(void)
{
	return _console_color;
}

void __attribute__((__section__(".__kernel__"))) console_enable_blink(bool enable)
{
	if(enable) _console_color |= __CONSOLE_BLINK_BIT;
	else _console_color &= ~__CONSOLE_BLINK_BIT;

	return;
}

bool __attribute__((__section__(".__kernel__"))) console_blink_is_enabled(void)
{
	return (_console_color & __CONSOLE_BLINK_BIT);
}

void __attribute__((__section__(".__kernel__"))) console_printchar(char c)
{
	_console_vram_index16 %= __CONSOLE_VRAM_SIZE_CHARS;

	switch(c)
	{
		case '\r':
			_console_addcarriagereturn();
			break;

		case '\n':
			_console_addlinefeed();
			break;

		default:
			((uint16_t*) __CONSOLE_VRAM_ADDR32)[_console_vram_index16] = ((_console_color << 8) | c);
			_console_vram_index16++;
			break;
	}

	return;
}

bool __attribute__((__section__(".__kernel__"))) console_printtext(const char *str)
{
	uintptr_t _len;

	if(str == NULL) return false;

	_len = (uintptr_t) cstr_getlength(str);

	return console_printtextlen(str, _len);
}

bool __attribute__((__section__(".__kernel__"))) console_printtextlen(const char *str, uintptr_t len)
{
	uintptr_t _nchar;
	uint16_t _word;

	if(str == NULL) return false;

	_word = (_console_color << 8);

	_nchar = 0u;
	while(_nchar < len)
	{
		_console_vram_index16 %= __CONSOLE_VRAM_SIZE_CHARS;

		switch(str[_nchar])
		{
			case '\r':
				_console_addcarriagereturn();
				break;

			case '\n':
				_console_addlinefeed();
				break;

			default:
				*((uint8_t*) &_word) = str[_nchar];
				((uint16_t*) __CONSOLE_VRAM_ADDR32)[_console_vram_index16] = _word;
				_console_vram_index16++;
				break;
		}

		_nchar++;
	}

	return true;
}

void __attribute__((__section__(".__kernel__"))) console_fillscreen_char(char c)
{
	uintptr_t _index;
	uint16_t _word;

	_word = ((_console_color << 8) | c);

	for(_index = 0u; _index < __CONSOLE_VRAM_SIZE_CHARS; _index++) ((uint16_t*) __CONSOLE_VRAM_ADDR32)[_index] = _word;

	return;
}

static void __attribute__((__section__(".__kernel__"))) _console_addlinefeed(void)
{
	uintptr_t _nextlineindex16;
	uint16_t _word;

	_nextlineindex16 = _console_vram_index16;
	_nextlineindex16 -= (_nextlineindex16%CONSOLE_NCHARS);
	_nextlineindex16 += CONSOLE_NCHARS;

	_word = (_console_color << 8);

	while(_console_vram_index16 < _nextlineindex16)
	{
		((uint16_t*) __CONSOLE_VRAM_ADDR32)[_console_vram_index16] = _word;
		_console_vram_index16++;
	}

	return;
}

static void __attribute__((__section__(".__kernel__"))) _console_addcarriagereturn(void)
{
	_console_vram_index16 -= (_console_vram_index16%CONSOLE_NCHARS);
	return;
}

