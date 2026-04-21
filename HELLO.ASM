
include 'C:\Users\henri\Documentos\fasm\INCLUDE\WIN32AX.INC'

.code

  start:

	invoke MessageBox,HWND_DESKTOP,"May I introduce myself?",invoke GetCommandLine,MB_YESNO

	.if eax = IDYES
		invoke MessageBox,HWND_DESKTOP,"Hi! I'm the example program! Wanna know a secret?", "Hello!",MB_YESNO

		.if eax = IDYES
			invoke MessageBox,HWND_DESKTOP,"idontcare", "Potato",MB_OK
		.endif

	.endif

	invoke ExitProcess,0

.end start