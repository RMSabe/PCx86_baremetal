/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#include "globldef.h"

__attribute__((__aligned__(PTR_SIZE_BITS) , __section__(".__data__"))) char textbuf[TEXTBUF_SIZE_CHARS];

void __attribute__((__section__(".__kernel__"))) _memset(void *p, uint8_t value, uintptr_t size)
{
	register uintptr_t _index;
	for(_index = 0u; _index < size; _index++) ((uint8_t*) p)[_index] = value;

	return;
}

void __attribute__((__section__(".__kernel__"))) _memcpy(void *p_dst, const void *p_src, uintptr_t size)
{
	register uintptr_t _index;
	for(_index = 0u; _index < size; _index++) ((uint8_t*) p_dst)[_index] = ((const uint8_t*) p_src)[_index];

	return;
}

bool __attribute__((__section__(".__kernel__"))) _is_power2(uintptr_t value)
{
	uintptr_t _numptr;

	if(!value) return false;

	_numptr = 1u;

	while(_numptr)
	{
		if(_numptr == value) return true;
		_numptr = (_numptr << 1);
	}

	return false;
}

uintptr_t __attribute__((__section__(".__kernel__"))) _get_closest_power2_floor(uintptr_t value)
{
	uintptr_t _numptr;

	if(!value) return 0u;
	if(_is_power2(value)) return value;

	if(value > PTR_MSB_VALUE) return PTR_MSB_VALUE;

	_numptr = _get_closest_power2_ceil(value);
	_numptr = (_numptr >> 1);

	return _numptr;
}

uintptr_t __attribute__((__section__(".__kernel__"))) _get_closest_power2_ceil(uintptr_t value)
{
	uintptr_t _numptr;

	if(!value) return 0u;
	if(_is_power2(value)) return value;

	_numptr = 1u;

	while(_numptr)
	{
		if(value < _numptr) break;
		_numptr = (_numptr << 1);
	}

	return _numptr;
}

uintptr_t __attribute__((__section__(".__kernel__"))) _get_closest_power2_round(uintptr_t value)
{
	uintptr_t _numptr1;
	uintptr_t _numptr2;

	if(!value) return 0u;
	if(_is_power2(value)) return value;

	if(value > PTR_MSB_VALUE)
	{
		_numptr1 = value - PTR_MSB_VALUE;
		_numptr2 = PTR_MAX_VALUE - value;

		if(_numptr1 < _numptr2) return PTR_MSB_VALUE;
		return 0u;
	}

	_numptr2 = _get_closest_power2_ceil(value);
	_numptr1 = (_numptr2 >> 1);

	if((value - _numptr1) < (_numptr2 - value)) return _numptr1;

	return _numptr2;
}

bool __attribute__((__section__(".__kernel__"))) _rdseed_is_available(void)
{
	bool _b;

	__asm__ __volatile__(
		"movl $0x7, %%eax\n\t"
		"xorl %%ecx, %%ecx\n\t"
		"cpuid\n\t"
		"shr $18, %%ebx\n\t"
		"andl $0x1, %%ebx\n\t"
		"movb %%bl, %0\n\t"
		: "=r" (_b) ::
	);

	return _b;
}

uintptr_t __attribute__((__section__(".__kernel__"))) _rdseed_get_random(void)
{
	uintptr_t _nrand;

	if(!_rdseed_is_available()) return 0u;

	__asm__ __volatile__(
		"_l__rdseed_get_random_loop:\n\t"
		"rdseed %%ebx\n\t"
		"jc _l__rdseed_get_random_loop_break\n\t"
		"jmp _l__rdseed_get_random_loop\n\t"
		"_l__rdseed_get_random_loop_break:\n\t"
		"movl %%ebx, %0\n\t"
		: "=r" (_nrand) ::
	);

	return _nrand;
}

void __attribute__((__section__(".__kernel__"))) _delay(uintptr_t _time)
{
	__asm__ __volatile__(
		"movl %0, %%edx\n\t"
		"xorl %%ecx, %%ecx\n\t"
		"_l__delay_loop:\n\t"
		"cmpl %%edx, %%ecx\n\t"
		"jae _l__delay_loop_break\n\t"
		"inc %%ecx\n\t"
		"jmp _l__delay_loop\n\t"
		"_l__delay_loop_break:\n\t"
		:: "r" (_time) :
	);

	return;
}

float __attribute__((__section__(".__kernel__"))) _round_f32(float value)
{
	int32_t _i32;
	float _f32_0;
	float _f32_1;
	float _f32_2;
	float _f32_out;

	_f32_0 = value;
	*((uint32_t*) &_f32_0) &= 0x7fffffff;

	_i32 = (int32_t) _f32_0;
	_f32_1 = (float) _i32;
	_f32_2 = _f32_1 + 1.0f;

	if((_f32_0 - _f32_1) < (_f32_2 - _f32_0)) _f32_out = _f32_1;
	else _f32_out = _f32_2;

	if(*((uint32_t*) &value) & 0x80000000) *((uint32_t*) &_f32_out) |= 0x80000000;

	return _f32_out;
}

float __attribute__((__section__(".__kernel__"))) _abs_f32(float value)
{
	return (*((uint32_t*) &value) & 0x7fffffff);
}

int32_t __attribute__((__section__(".__kernel__"))) _abs_i32(int32_t value)
{
	if(value & 0x80000000)
	{
		value = ~value;
		value++;
	}

	return value;
}

