/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#ifndef GLOBLDEF_H
#define GLOBLDEF_H

#ifndef __EXTERNC__
#ifdef __cplusplus
#define __EXTERNC__ extern "C"
#else
#define __EXTERNC__ extern
#endif
#endif

#ifndef __i386__
#error "This kernel is designed for i386 CPUs"
#endif

#include "_macros.h"
#include <stddef.h>
#include <stdbool.h>
#include <stdint.h>

#define PTR_SIZE_BYTES (sizeof(void*))
#define PTR_SIZE_BITS (PTR_SIZE_BYTES*8U)

#define PTR_MAX_VALUE ((uintptr_t) -1)
#define PTR_MSB_VALUE ((uintptr_t) ~(PTR_MAX_VALUE >> 1))

#define TEXTBUF_SIZE_CHARS 256U
#define TEXTBUF_SIZE_BYTES TEXTBUF_SIZE_CHARS

__EXTERNC__ void _start(void) __attribute__((__noreturn__ , __section__(".__kernel_start__")));
__EXTERNC__ void _end(void) __attribute__((__noreturn__ , __section__(".__kernel_start__")));
__EXTERNC__ void _main(void) __attribute__((__section__(".__kernel__")));

/*_memset and _memcpy behave the same as string.h memset and memcpy.*/

__EXTERNC__ void _memset(void *p, uint8_t value, uintptr_t size) __attribute__((__section__(".__kernel__")));
__EXTERNC__ void _memcpy(void *p_dst, const void *p_src, uintptr_t size) __attribute__((__section__(".__kernel__")));

/*_is_power2(): Check if a given value is a power of 2*/

__EXTERNC__ bool _is_power2(uintptr_t value) __attribute__((__section__(".__kernel__")));

/*
 * _get_closest_power2_...()
 * Returns the closest power of 2 of a given value, or 0 if no possible value.
 */

__EXTERNC__ uintptr_t _get_closest_power2_floor(uintptr_t value) __attribute__((__section__(".__kernel__")));
__EXTERNC__ uintptr_t _get_closest_power2_ceil(uintptr_t value) __attribute__((__section__(".__kernel__")));
__EXTERNC__ uintptr_t _get_closest_power2_round(uintptr_t value) __attribute__((__section__(".__kernel__")));

/*
 * _rdseed_is_available()
 * Check if the current CPU supports RDSEED instruction. (Random number generator).
 *
 * Returns "true" if RDSEED is supported, "false" otherwise.
 */

__EXTERNC__ bool _rdseed_is_available(void) __attribute__((__section__(".__kernel__")));

/*
 * _rdseed_get_random()
 * Generates a random number using the RDSEED instruction.
 *
 * Only works if current CPU supports RDSEED instruction.
 *
 * Returns random number, or 0 if RDSEED is not supported.
 */

__EXTERNC__ uintptr_t _rdseed_get_random(void) __attribute__((__section__(".__kernel__")));

/*
 * _delay()
 * Delays the CPU process by a given number of delay cycles.
 */

__EXTERNC__ void _delay(uintptr_t _time) __attribute__((__section__(".__kernel__")));

/*_round_f32(): behave the same as math.h roundf()*/

__EXTERNC__ float _round_f32(float value) __attribute__((__section__(".__kernel__")));

/*_abs_f32(): behave the same as math.h absf()*/

__EXTERNC__ float _abs_f32(float value) __attribute__((__section__(".__kernel__")));

/*_abs_i32(): same as _abs_f32, but for int32_t*/

__EXTERNC__ int32_t _abs_i32(int32_t value) __attribute__((__section__(".__kernel__")));

__EXTERNC__ char textbuf[] __attribute__((__section__(".__data__")));

static inline intptr_t _abs_iptr(intptr_t value)
{
	return (intptr_t) _abs_i32((int32_t) value);
}

#endif /*GLOBLDEF_H*/

