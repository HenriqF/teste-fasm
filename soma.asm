format PE Console 4.0
entry start

include 'C:\Users\henri\Documentos\fasm\INCLUDE\win32ax.inc'


section '.data' data readable writeable
    msg db 'wow', 0
    msg_len = $ - msg
    written db ?

    ;
    hStdOut dd ?

section '.code' code readable executable
    start:
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov [hStdOut], eax

        push 10
        push 20
        call soma

        .if eax = 30
            invoke WriteConsole, [hStdOut], msg, msg_len, written, 0
        .endif


        invoke ExitProcess, 0

    soma:
        push ebp
        mov ebp, esp

        mov eax, [ebp+8]
        add eax, [ebp+12]

        pop ebp
        ret 8
    


section '.idata' import data readable
    library kernel32, 'KERNEL32.DLL'
    import kernel32, \
           GetStdHandle, 'GetStdHandle', \
           ReadConsole, 'ReadConsoleA', \
           WriteConsole, 'WriteConsoleA', \
           ExitProcess, 'ExitProcess' \