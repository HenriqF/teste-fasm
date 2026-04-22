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

        push 40
        call fibas

        .if eax = 102334155
            invoke WriteConsole, [hStdOut], msg, msg_len, written, 0
        .endif

        invoke ExitProcess, 0

    fibas:
        push ebp
        sub esp, 4
        mov ebp, esp

        mov eax, [ebp+12]

        .if eax = 0
            jmp .fib_done
        .endif

        .if eax = 1
            jmp .fib_done
        .endif

        sub dword [ebp+12], 1
        push dword [ebp+12]
        call fibas
        mov [ebp], eax

        sub dword [ebp+12], 1
        push dword [ebp+12]
        call fibas
        add eax, [ebp]


        jmp .fib_done

    .fib_done:
        add esp, 4
        pop ebp
        ret 4 ;le e muda esp!!!
    


section '.idata' import data readable
    library kernel32, 'KERNEL32.DLL'
    import kernel32, \
           GetStdHandle, 'GetStdHandle', \
           ReadConsole, 'ReadConsoleA', \
           WriteConsole, 'WriteConsoleA', \
           ExitProcess, 'ExitProcess' \