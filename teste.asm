format PE Console 4.0
entry start

include 'C:\Users\henri\Documentos\fasm\INCLUDE\win32a.inc'


;carriagereturn 13
;nl 10
section '.data' data readable writeable
    msg db 'escreva:', 13, 10, 0
    msg_len = $ - msg
    written dd ?

    buffer_size dd 512

    in_buffer db 512 dup(?)
    bytesread dd ?

    cifra_buffer db 512 dup(?)

    hStdIn dd ?
    hStdOut dd ?


section '.code' code readable executable
    start:
        invoke GetStdHandle, STD_INPUT_HANDLE
        mov [hStdIn], eax
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov [hStdOut], eax

        invoke WriteConsole, [hStdOut], msg, msg_len, written, 0
        invoke ReadConsole, [hStdIn], in_buffer, [buffer_size], bytesread, 0


        mov ecx, 0
        sub [bytesread], 2
        loops:
            cmp ecx, [bytesread]
            jge loops_fim

            mov bl, [in_buffer + ecx]
            add bl, 2
            mov [cifra_buffer+ecx], bl

            inc ecx
            jmp loops
        loops_fim:


        invoke WriteConsole, [hStdOut], cifra_buffer, [bytesread], written, 0
        invoke ExitProcess, 0


section '.idata' import data readable
    library kernel32, 'KERNEL32.DLL'
    import kernel32, \
           GetStdHandle, 'GetStdHandle', \
           ReadConsole, 'ReadConsoleA', \
           WriteConsole, 'WriteConsoleA', \
           ExitProcess, 'ExitProcess'