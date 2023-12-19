These are test routines created to test some features.
To run a test, use the "%include" directive to include any of the "test.asm" files in "kernel.asm" file, then add a "jmp _teststart" instruction after "_sysmain" label
Only one test.asm file may be included to kernel.asm. Including multiple test files may cause random behavior or assembler errors

