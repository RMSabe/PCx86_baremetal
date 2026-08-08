/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#include "globldef.h"
#include "cstr.h"
#include "console.h"

void __attribute__((__section__(".__kernel__"))) _main(void)
{
	/*Kernel Process Starts Here*/



	/*Recommended Startup*/

	_memset(textbuf, 0, TEXTBUF_SIZE_BYTES);
	console_init();

	console_printtext("Kernel Process Started\n");

	/*Place your code here*/

	/*Recommended Exit*/

	console_printtext("\nKernel Process Finished\n");

	return;
}

