format PE Console 4.0
entry start

include 'C:\Users\henri\Documentos\fasm\INCLUDE\win32ax.inc'


section '.data' data readable writeable
    new_line db 13, 10, 0
    new_line_len = $ - new_line


    keyword db 'carro', 0
    keyword_len = $ - keyword
    backup_keyword db 'carro', 0


    vitoria_msg db 'vitoria!', 13, 10, 0
    vitoria_msg_len = $ - vitoria_msg
    derrota_msg db 'se fode!', 13, 10 ,0
    derrota_msg_len = $ - derrota_msg


    input_buffer db 8 dup(?)
    input_buffer_len dd 8 

    truth_buffer db 8 dup(0)
    truth_buffer_len dd 8


    bytes_read dd ?
    bytes_written dd ?


    hStdIn dd ?
    hStdOut dd ?


    tentativas dd 6
    playing dd 1
    vitoria dd 0


section '.code' code readable executable

    char_in_backup_string:
        mov ebx, [esp+4]
        mov dl , [input_buffer+ebx]

        mov eax, 0 
        cib_loop:
            .if eax = 5
                jmp cib_end_loop
            .endif

            .if dl = [backup_keyword + eax]
                jmp cib_end_loop
            .endif

            add eax, 1
            jmp cib_loop
        cib_end_loop:
        ret 4


    compare_strings:
        mov eax, 0
        csl_loop:
            .if eax = 5
                jmp csl_end_loop
            .endif

            mov cl, [input_buffer+eax]
            mov bl, [keyword+eax]

            .if bl = cl
                add eax, 1
                jmp csl_loop
            .endif

            jmp csl_end_loop

        csl_end_loop:
            ret 

    get_word_input:

        invoke ReadConsole, [hStdIn], input_buffer, [input_buffer_len], bytes_read, 0
        mov eax, [bytes_read]

        .if eax = 7
            ret
        .endif

        mov byte [input_buffer + 7], 0

        call get_word_input
        ret

    start:
        invoke GetStdHandle, STD_INPUT_HANDLE
        mov [hStdIn], eax
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov [hStdOut], eax


        game_loop:

            .if [tentativas] = 0
                jmp end_game
            .endif

            call get_word_input
            call compare_strings
            .if eax = 5
                mov [vitoria], 1
                jmp end_game
            .endif

            mov eax, 0
            create_backup_loop:
                .if eax = 5
                    jmp cb_end_loop
                .endif
                mov dl, [keyword + eax]
                mov [backup_keyword + eax], dl
                add eax, 1
                jmp create_backup_loop

            cb_end_loop:
                
            mov eax, 0
            check_full_correct_loop:
                .if eax = 5
                    jmp cfc_end_loop
                .endif

                mov dl, [backup_keyword + eax]
                .if dl = [input_buffer + eax]
                    mov byte [truth_buffer+eax], 'o'
                    mov byte [backup_keyword+eax], '*'
                    mov byte [input_buffer+eax], '-'
                    add eax, 1
                    jmp check_full_correct_loop
                .endif

                mov byte [truth_buffer+eax] , '-'
                add eax, 1
                jmp check_full_correct_loop

            cfc_end_loop:
                
            mov eax, 0
            check_half_correct_loop:
                .if eax = 5
                    jmp chc_end_loop
                .endif

                push eax
                push eax
                call char_in_backup_string
                mov ebx, eax
                pop eax

                .if ebx <> 5
                    mov byte [backup_keyword + ebx], '*'
                    mov byte [truth_buffer + eax], '*'
                .endif

                add eax, 1
                jmp check_half_correct_loop
            chc_end_loop:

            invoke WriteConsole, [hStdOut], truth_buffer, [truth_buffer_len], bytes_written, 0
            invoke WriteConsole, [hStdOut], new_line, new_line_len, bytes_written, 0


            sub [tentativas], 1

            jmp game_loop


        end_game:
            mov eax, [vitoria]

            .if eax = 1
                invoke WriteConsole, [hStdOut], vitoria_msg, vitoria_msg_len, bytes_written, 0
                invoke ExitProcess, 0
            .endif

            invoke WriteConsole, [hStdOut], derrota_msg, derrota_msg_len, bytes_written, 0
            invoke ExitProcess, 0




section '.idata' import data readable
    library kernel32, 'KERNEL32.DLL'
    import kernel32, \
           GetStdHandle, 'GetStdHandle', \
           ReadConsole, 'ReadConsoleA', \
           WriteConsole, 'WriteConsoleA', \
           ExitProcess, 'ExitProcess'