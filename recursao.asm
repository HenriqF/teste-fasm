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

        push 1200
        call count_down

        .if eax = 0
            invoke WriteConsole, [hStdOut], msg, msg_len, written, 0
        .endif


        invoke ExitProcess, 0

    ; x   |??????
    ; x-4 |2
    ; x-8 |LINHA 21
    ; x-12|y
    ; x-16|
    ; x-20|
    ; x-24|
    ; x-28|
    ; x-32|
    ; x-36|
    ;esp -> topo
    ;ebp -> referencia
    count_down:
        push ebp
        mov ebp, esp

        mov eax, [ebp+8]
        sub eax, 1

        .if eax = 0
            pop ebp
            ret 4
        .endif

        push eax
        call count_down

        pop ebp
        ret 4
    


section '.idata' import data readable
    library kernel32, 'KERNEL32.DLL'
    import kernel32, \
           GetStdHandle, 'GetStdHandle', \
           ReadConsole, 'ReadConsoleA', \
           WriteConsole, 'WriteConsoleA', \
           ExitProcess, 'ExitProcess' \