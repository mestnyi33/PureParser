; FindData module by Wilbert

; last update July 28, 2015

DeclareModule FindData
  
  ; all routines return a zero based index or -1 (not found)
  
  Declare TS(*HayStack, HayStackSize, *Needle, NeedleSize.l)          ; Tailed Substring algorithm
  Declare QS(*HayStack, HayStackSize, *Needle, NeedleSize.l)          ; Quick Search algorithm
  Declare BM(*HayStack, HayStackSize, *Needle, NeedleSize.u)          ; Boyer-Moore algorithm
  Declare FastSearch(*HayStack, HayStackSize, *Needle, NeedleSize)    ; Based on the Python fast search algorithm
  Declare SSE2_Find(*Haystack, HaystackSize, *Needle, NeedleSize, Count = #False)
  
EndDeclareModule

Module FindData
  
  EnableASM
  EnableExplicit
  DisableDebugger
  
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
    Macro rax : eax : EndMacro
    Macro rbx : ebx : EndMacro   
    Macro rcx : ecx : EndMacro
    Macro rdx : edx : EndMacro
    Macro rsi : esi : EndMacro
    Macro rdi : edi : EndMacro
    Macro rbp : ebp : EndMacro
    Macro rsp : esp : EndMacro
  CompilerEndIf
  
  Macro M_movdqa(arg1, arg2)
    !movdqa arg1, arg2
  EndMacro
  
  
  ; *** Tailed Substring algorithm code ***
  
  Macro M_TS_Phase(phase)
    !finddata.l_ts_#phase#0:
    movzx rax, byte [rsi + rcx] 
    !finddata.l_ts_#phase#1:
    cmp al, [rdi + rcx]
    !je finddata.l_ts_#phase#2
    inc rdi
    cmp rdi, rbp
    !jbe finddata.l_ts_#phase#1
    !jmp finddata.l_ts_exit_notfound
    !finddata.l_ts_#phase#2:
    sub rdx, rdx
    !finddata.l_ts_#phase#3:
    movzx rax, byte [rsi + rdx]
    cmp al, [rdi + rdx]
    !jne finddata.l_ts_#phase#4
    inc rdx
    cmp rdx, rbx
    !jne finddata.l_ts_#phase#3
    mov rax, rdi
    sub rax, [p.p_HayStack]
    !jmp finddata.l_ts_exit_found
    !finddata.l_ts_#phase#4:
    CompilerIf phase = 1
      mov rdx, rcx
      dec rdx
      !js finddata.l_ts_#phase#6
      movzx rax, byte [rsi + rcx]
      !finddata.l_ts_#phase#5:
      cmp al, [rsi + rdx]
      !je finddata.l_ts_#phase#6
      dec rdx
      !jns finddata.l_ts_#phase#5
      !finddata.l_ts_#phase#6:
      mov rax, rcx
      sub rax, rdx
      cmp rax, [rsp - 48]             ; if i-h > dim => {k=i; dim=i-h;}
      !jng finddata.l_ts_#phase#7
      mov [rsp - 40], rcx
      mov [rsp - 48], rax
      !finddata.l_ts_#phase#7:
      add rdi, rcx                    ;  s + i
      sub rdi, rdx                    ;  s - h
      dec rcx      
      cmp rcx, [rsp - 48]
      !jb finddata.l_ts_phase2        ; if i < dim => proceed with phase 2
    CompilerElse
      ; phase 2
      add rdi, [rsp - 48]
    CompilerEndIf
    cmp rdi, rbp
    !jbe finddata.l_ts_#phase#0
    !jmp finddata.l_ts_exit_notfound
    
  EndMacro
  
  Procedure TS(*HayStack, HayStackSize, *Needle, NeedleSize.l)
    
    ; backup some registers
    mov [rsp -  8], rbx
    mov [rsp - 16], rsi
    mov [rsp - 24], rdi
    mov [rsp - 32], rbp
    
    ; init some things
    mov ebx, [p.v_NeedleSize]
    mov ecx, ebx
    dec ecx
    !js finddata.l_ts_exit_notfound   ; exit when NeedleSize < 1
    mov rbp, [p.v_HayStackSize]
    sub rbp, rbx
    !jc finddata.l_ts_exit_notfound   ; exit when NeedleSize > HayStackSize
    mov rsi, [p.p_Needle]
    mov rdi, [p.p_HayStack]
    add rbp, rdi
    mov rax, 1
    mov [rsp - 40], rcx               ; k
    mov [rsp - 48], rax               ; dim
    
    ; search
    M_TS_Phase(1)
    !finddata.l_ts_phase2:
    mov rcx, [rsp - 40]
    M_TS_Phase(2)
    
    ; exit
    !finddata.l_ts_exit_notfound:  
    mov rax, -1
    !finddata.l_ts_exit_found:
    mov rbx, [rsp -  8]
    mov rsi, [rsp - 16]
    mov rdi, [rsp - 24]
    mov rbp, [rsp - 32]
    ProcedureReturn
    
  EndProcedure
  
  ; *** End of Tailed Substring algorithm code ***
  
  
  ; *** Code based on Quick Search / Sunday algorithm ***
  
  Macro M_QS_Search(n = 0)
    !finddata.l_qs_search0#n:
    !xor ecx, ecx
    !finddata.l_qs_search1#n:
    movzx eax, byte [rsi + rcx]
    cmp al, [rdi + rcx]
    !je finddata.l_qs_continue#n
    CompilerIf n = 0
      movzx eax, byte [rdi + rbx]
      mov eax, [rsp + rax * 4 - 1024]
      add rdi, rax
      cmp rdi, rdx
      !jb finddata.l_qs_search0#n
      !je finddata.l_qs_finalcheck
    CompilerEndIf
    !jmp finddata.l_qs_exit_notfound
    !finddata.l_qs_continue#n:
    !inc ecx
    !cmp ecx, ebx
    !jb finddata.l_qs_search1#n
    mov rax, rdi
    sub rax, [p.p_HayStack]
    !jmp finddata.l_qs_exit_found      
  EndMacro
  
  Procedure QS(*HayStack, HayStackSize, *Needle, NeedleSize.l)
    
    ; backup some registers
    mov [rsp - 1032], rbx
    mov [rsp - 1040], rsi
    mov [rsp - 1048], rdi
    
    ; perform some checks
    mov ebx, [p.v_NeedleSize]
    cmp ebx, 1
    !jl finddata.l_qs_exit_notfound
    mov rdx, [p.v_HayStackSize]
    sub rdx, rbx
    !jc finddata.l_qs_exit_notfound   ; exit when NeedleSize > HayStackSize
    
    ; prepare
    lea rdi, [rsp - 1024]
    lea eax, [ebx + 1]
    mov ecx, 256
    cld
    rep stosd
    mov rsi, [p.p_Needle]
    mov rdx, rsi
    mov ecx, ebx
    !finddata.l_qs_prep_table:
    movzx eax, byte [rdx]
    mov [rsp + rax * 4 - 1024], ecx
    inc rdx
    dec ecx
    !jnz finddata.l_qs_prep_table
    
    ; search
    mov rdi, [p.p_HayStack]
    mov rdx, [p.v_HayStackSize]
    sub rdx, rbx
    !jz finddata.l_qs_finalcheck      ; jump to finalcheck if NeedleSize = HayStackSize
    add rdx, rdi
    M_QS_Search(0)
    !finddata.l_qs_finalcheck:
    M_QS_Search(1)
    
    ; exit
    !finddata.l_qs_exit_notfound:  
    mov rax, -1
    !finddata.l_qs_exit_found:
    mov rbx, [rsp - 1032]
    mov rsi, [rsp - 1040]
    mov rdi, [rsp - 1048]
    ProcedureReturn
    
  EndProcedure
  
  ; *** End of code based on Quick Search / Sunday algorithm ***
  
  
  ; *** Code based on Boyer-Moore algorithm ***
  
  Macro M_BM(n=0)
    CompilerIf n=0
      add rsi, rcx      
    CompilerElse
      add rsi, 1
    CompilerEndIf
    mov ecx, ebx
    cmp rsi, rdx
    !jna finddata.l_bm_search1
    !jmp finddata.l_bm_exit
  EndMacro
  
  Procedure BM(*HayStack, HayStackSize, *Needle, NeedleSize.u)
    
    ; Boyer-Moore algorithm
    ; based on code from 'schic'
    ; http://www.purebasic.fr/english/viewtopic.php?p=130032#p130032
    
    ; backup some registers
    mov [rsp - 520], rbx
    mov [rsp - 528], rsi
    mov [rsp - 536], rdi
    
    ; perform some checks
    movzx ebx, word [p.v_NeedleSize]   ; exit if NeedleSize = 0
    cmp ebx, 0
    !je finddata.l_bm_exit
    mov rdx, [p.v_HayStackSize]        ; exit if NeedleSize > HayStackSize
    sub rdx, rbx
    !jc finddata.l_bm_exit
    
    ; prepare
    lea rdi, [rsp - 512]
    mov eax, 0xff
    mov ecx, 512
    cld
    rep stosb
    mov rdi, [p.p_Needle]
    mov ecx, ebx
    mov rsi, rdi
    !finddata.l_bm_table0:
    movzx eax, byte [rsi]
    add rsi, 1
    sub ecx, 1
    mov [rsp + rax * 2 - 512], cx
    !jnz finddata.l_bm_table0
    mov rsi, [p.p_HayStack]
    add rdx, rsi
    
    ; search
    mov ecx, ebx
    
    !finddata.l_bm_search1:
    movzx eax, byte [rsi + rcx - 1]
    cmp al, [rdi + rcx - 1]
    !je finddata.l_bm_search4
    
    movzx eax, word [rsp + rax * 2 - 512]
    cmp ax, 0xffff
    !jne finddata.l_bm_search2
    M_BM()
    
    !finddata.l_bm_search2:
    add ecx, eax
    sub ecx, ebx
    !jna finddata.l_bm_search3
    M_BM()
    
    !finddata.l_bm_search3:
    M_BM(1)
    
    !finddata.l_bm_search4:
    sub ecx, 1
    !jnz finddata.l_bm_search1
    
    mov rax, rsi
    sub rax, *HayStack
    !finddata.l_bm_return:
    mov rbx, [rsp - 520]
    mov rsi, [rsp - 528]
    mov rdi, [rsp - 536]
    ProcedureReturn
    
    ; exit not found
    !finddata.l_bm_exit:
    mov rax, -1
    !jmp finddata.l_bm_return
    
  EndProcedure
  
  ; *** End of code based on Boyer-Moore algorithm ***
  
  ; *** Code based on Python fast search algorithm ***
  
  Procedure FastSearch(*HayStack, HayStackSize, *Needle, NeedleSize)
    
    ; Based on the Python fast search algorithm (Python License)
    
    Protected.i reg_bx, reg_si, reg_di
    Protected.i hs_end, skip
    
    ; backup registers
    mov [p.v_reg_bx], rbx
    mov [p.v_reg_si], rsi
    mov [p.v_reg_di], rdi
    
    ; perform some checks
    mov rbx, [p.v_NeedleSize]
    mov rcx, [p.v_HayStackSize]
    cmp rbx, rcx
    !jg finddata.l_fs_exit                ; exit when NeedleSize > HayStackSize
    cmp rbx, 1
    !jg finddata.l_fs_prep
    !jne finddata.l_fs_exit               ; exit when NeedleSize < 1
    
    ; handle needle size 1
    mov rsi, [p.p_HayStack]    
    mov rdi, [p.p_Needle]
    mov rax, rcx
    mov bl, [rdi]
    !finddata.l_fs_sns0:
    cmp bl, [rsi]
    !je finddata.l_fs_sns1
    inc rsi
    dec rcx
    !jnz finddata.l_fs_sns0
    !jmp finddata.l_fs_exit
    !finddata.l_fs_sns1:
    sub rax, rcx
    !jmp finddata.l_fs_return
    
    ; prepare (skip and register rdx mask)
    !finddata.l_fs_prep:
    mov rdi, [p.p_Needle]
    lea rsi, [rbx - 2]
    mov [p.v_skip], rsi
    mov rdx, 0
    movzx ecx, byte [rdi + rsi + 1]
    bts rdx, rcx
    !finddata.l_fs_prep0:
    movzx eax, byte [rdi + rsi]
    bts rdx, rax
    sub rsi, 1
    !js finddata.l_fs_prep2
    cmp eax, ecx
    !jne finddata.l_fs_prep0
    lea rax, [rsi + 1]
    sub [p.v_skip], rax
    !finddata.l_fs_prep1:
    movzx eax, byte [rdi + rsi]
    bts rdx, rax
    sub rsi, 1
    !jns finddata.l_fs_prep1
    !finddata.l_fs_prep2:
    
    ; search
    mov rax, [p.v_HayStackSize]
    sub rax, rbx
    mov rsi, [p.p_HayStack]
    add rax, rsi
    mov [p.v_hs_end], rax
    movzx ecx, byte [rdi + rbx - 1]
    dec rsi
    
    !finddata.l_fs_search0:
    inc rsi
    cmp rsi, [p.v_hs_end]                 ; check for haystack end boundary
    !jae finddata.l_fs_search7
    cmp cl, [rsi + rbx - 1]               ; compare last needle byte
    !je finddata.l_fs_search2             ; equal => continue with search2
    movzx eax, byte [rsi + rbx]
    bt rdx, rax                           ; 'Sunday' check
    !jc finddata.l_fs_search0
    !finddata.l_fs_search1:
    add rsi, rbx
    !jmp finddata.l_fs_search0
    
    !finddata.l_fs_search2:               ; compare first two needle bytes
    movzx eax, word [rdi]
    cmp ax, [rsi]
    !je finddata.l_fs_search4             ; equal => continue with search4
    !finddata.l_fs_search3:
    movzx eax, byte [rsi + rbx]           ; 'Sunday' check
    bt rdx, rax
    !jnc finddata.l_fs_search1
    add rsi, [p.v_skip]                   ; 'Horspool' skip
    !jmp finddata.l_fs_search0
    
    !finddata.l_fs_search4:               ; compare remaining needle bytes
    mov rax, rbx
    sub rax, 3
    !jna finddata.l_fs_search9            ; no more bytes left => found !
    push rcx                              ; keep a copy of rcx
    lea rcx, [rax + 1]
    shr rcx, 1
    !finddata.l_fs_search5:
    movzx eax, word [rdi + rcx * 2]       ; compare two bytes at a time
    cmp ax, [rsi + rcx * 2]
    !jne finddata.l_fs_search6            ; not equal => restore rcx and back to search3
    dec rcx
    !jnz finddata.l_fs_search5            ; no more bytes left ?
    pop rcx                               ; restore rcx
    !jmp finddata.l_fs_search9            ; => found !
    !finddata.l_fs_search6:
    pop rcx
    !jmp finddata.l_fs_search3
    
    !finddata.l_fs_search7:               ; code to handle haystack exactly on end boundary
    !ja finddata.l_fs_exit                ; boundary exceeded => exit
    !finddata.l_fs_search8:               ; final check
    movzx eax, byte [rdi + rbx - 1]
    cmp al, [rsi + rbx - 1]    
    !jne finddata.l_fs_exit
    dec rbx
    !jnz finddata.l_fs_search8
    !finddata.l_fs_search9:               ; return result
    mov rax, rsi
    sub rax, [p.p_HayStack]    
    
    ; restore registers & return result
    !finddata.l_fs_return:
    mov rbx, [p.v_reg_bx]
    mov rsi, [p.v_reg_si]
    mov rdi, [p.v_reg_di]
    ProcedureReturn
    
    ; exit not found
    !finddata.l_fs_exit:
    mov rax, -1
    !jmp finddata.l_fs_return
    
  EndProcedure
  
  ; *** End of code based on Python fast search algorithm ***
  
  Procedure SSE2_Find(*Haystack, HaystackSize, *Needle, NeedleSize, Count = #False)
    
    ; backup some registers
    mov [rsp -  8], rbx
    mov [rsp - 16], rsi
    mov [rsp - 24], rdi
    
    ; init count
    mov rax, [p.v_Count]
    sub rax, 1
    sbb rax, rax
    mov [rsp - 40], rax
    
    ; perform some checks
    mov rax, [p.v_HaystackSize]
    mov rbx, [p.v_NeedleSize]
    sub rax, rbx
    !jc finddata.l_sse2_search8     ; exit if NeedleSize > HaystackSize
    add rax, [p.p_Haystack]  
    mov [rsp - 32], rax             ; rsp - 32 = *SearchEnd
    cmp rbx, 1
    !jl finddata.l_sse2_search8     ; exit if NeedleSize < 1

    ; load first two needle bytes
    !pcmpeqb xmm4, xmm4
    mov rdi, [p.p_Needle]
    movzx eax, byte [rdi]
    !je finddata.l_sse2_search0
    mov ah, [rdi + 1]
    !pslldq xmm4, 15
    !finddata.l_sse2_search0:
    !movd xmm2, eax
    !punpcklbw xmm2, xmm2
    !punpcklwd xmm2, xmm2
    !pshufd xmm3, xmm2, 01010101b   ; xmm3 = 16 times second needle byte
    !pshufd xmm2, xmm2, 0           ; xmm2 = 16 times first needle byte
    
    ; start search
    mov rsi, [p.p_Haystack]
    mov rcx, rsi
    shr rsi, 4                      ; align Haystack to 16 bytes
    shl rsi, 4
    sub rcx, rsi
    M_movdqa(xmm0, [rsi])           ; handle first 16 bytes
    !movdqa xmm1, xmm0
    !pcmpeqb xmm0, xmm2             ; compare against first needle byte
    !pmovmskb eax, xmm0
    !shr eax, cl                    ; shift off unwanted bytes
    !shl eax, cl
    !test eax, eax
    !jnz finddata.l_sse2_search2
    
    ; main search loop
    !finddata.l_sse2_search1:
    add rsi, 16                     ; next 16 bytes
    cmp rsi, [rsp - 32]
    !ja finddata.l_sse2_search8
    M_movdqa(xmm0, [rsi])
    !movdqa xmm1, xmm0
    !pcmpeqb xmm0, xmm2             ; compare against first needle byte
    !pmovmskb eax, xmm0
    !test eax, eax
    !jz finddata.l_sse2_search1     ; no match ? => search1
    !finddata.l_sse2_search2:
    !pcmpeqb xmm1, xmm3             ; compare against second needle byte
    !psrldq xmm1, 1
    !por xmm1, xmm4
    !pmovmskb ecx, xmm1
    !and eax, ecx                   ; combine both searches
    !jz finddata.l_sse2_search1     ; no match ? => search1
    
    ; compare rest of bytes
    !finddata.l_sse2_search3:
    !bsf ecx, eax                   ; get index of first match
    !jz finddata.l_sse2_search1
    !btr eax, ecx
    lea rdx, [rsi + rcx]            ; create a pointer to it
    cmp rdx, [rsp - 32]
    mov rcx, [p.v_NeedleSize]
    !ja finddata.l_sse2_search8
    sub rcx, 2
    !jb finddata.l_sse2_search5     ; NeedleSize < 2 ? => search5 (already done) 
    
    !finddata.l_sse2_search4:
    movzx ebx, word [rdx + rcx]     ; compare rest of needle right-to-left
    cmp bx, [rdi + rcx]             ; two bytes at a time
    !jne finddata.l_sse2_search3
    sub rcx, 2
    !jae finddata.l_sse2_search4
    
    !finddata.l_sse2_search5:
    mov rbx, [rsp - 40]
    cmp rbx, -1
    !je finddata.l_sse2_search6
    add rbx, 1                      ; increase count
    mov [rsp - 40], rbx
    !jmp finddata.l_sse2_search3
    !finddata.l_sse2_search6:
    mov rax, rdx                    ; return result
    sub rax, [p.p_Haystack]
    !finddata.l_sse2_search7:
    mov rbx, [rsp -  8]
    mov rsi, [rsp - 16]
    mov rdi, [rsp - 24]  
    ProcedureReturn
    
    ; not found / return count
    !finddata.l_sse2_search8:
    mov rax, [rsp - 40]
    !jmp finddata.l_sse2_search7
    
  EndProcedure   
  
EndModule

; _________________
; macOS 10.14 Mojave, PB 5.62 x64
; 
; 
; Last edited by wilbert on Tue Jul 28, 2015 6:54 am, edited 6 times in total. 
; 
; Report this post
; Top	 Profile Send private message  Reply With quote  
; 
; wilbert	
;  Post subject: Re: FindData modulePostPosted: Wed Jul 01, 2015 2:33 pm 
; Offline
; PureBasic Expert
; PureBasic Expert
; 
; Joined: Sun Aug 08, 2004 5:21 am
; Posts: 3265
; Location: Netherlands	
; Speed test
; Code:
DisableDebugger

HayStackSize = 65536
NeedleSize = 64

*HayStack = AllocateMemory(HayStackSize)
*Needle = AllocateMemory(NeedleSize)

RandomSeed(0)
RandomData(*HayStack, HayStackSize)

CopyMemory(*HayStack + HayStackSize - NeedleSize - 32, *Needle, NeedleSize)

t0 = ElapsedMilliseconds()
For i = 1 To 20000
  x = FindData::TS(*HayStack, HayStackSize, *Needle, NeedleSize)
Next
t1 = ElapsedMilliseconds()
For i = 1 To 20000
  x = FindData::QS(*HayStack, HayStackSize, *Needle, NeedleSize)
Next
t2 = ElapsedMilliseconds()
For i = 1 To 20000
  x = FindData::BM(*HayStack, HayStackSize, *Needle, NeedleSize)
Next
t3 = ElapsedMilliseconds()
For i = 1 To 20000
  x = FindData::FastSearch(*HayStack, HayStackSize, *Needle, NeedleSize)
Next
t4 = ElapsedMilliseconds()
For i = 1 To 20000
  x = FindData::SSE2_Find(*HayStack, HayStackSize, *Needle, NeedleSize)
Next
t5 = ElapsedMilliseconds()

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  S.s = "Windows "
CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
  S.s = "OSX "
CompilerElse
  S.s = "Linux "
CompilerEndIf

CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
  S + "(x86) "
CompilerElse
  S + "(x64) "
CompilerEndIf

S + #CRLF$ + CPUName() + #CRLF$ + #CRLF$

S + "Test 1" + #CRLF$
S + "----------" + #CRLF$
S + "Tailed Substring : " + Str(t1-t0) + "ms" + #CRLF$
S + "QuickSearch : " + Str(t2-t1) + "ms" + #CRLF$
S + "Boyer-Moore : " + Str(t3-t2) + "ms" + #CRLF$
S + "FastSearch : " + Str(t4-t3) + "ms" + #CRLF$
S + "SSE2 Find : " + Str(t5-t4) + "ms" + #CRLF$

PokeS(*HayStack, "A small test with a small haystack and short needle. This will perform differently because some algorithms take some time to initialize", -1, #PB_Ascii)
PokeS(*Needle, "initial", -1, #PB_Ascii)
HayStackSize2 = MemoryStringLength(*HayStack, #PB_Ascii)
NeedleSize2 = MemoryStringLength(*Needle, #PB_Ascii)


t0 = ElapsedMilliseconds()
For i = 1 To 1500000
  x = FindData::TS(*HayStack, HayStackSize2, *Needle, NeedleSize2)
Next
t1 = ElapsedMilliseconds()
For i = 1 To 1500000
  x = FindData::QS(*HayStack, HayStackSize2, *Needle, NeedleSize2)
Next
t2 = ElapsedMilliseconds()
For i = 1 To 1500000
  x = FindData::BM(*HayStack, HayStackSize2, *Needle, NeedleSize2)
Next
t3 = ElapsedMilliseconds()
For i = 1 To 1500000
  x = FindData::FastSearch(*HayStack, HayStackSize2, *Needle, NeedleSize2)
Next
t4 = ElapsedMilliseconds()
For i = 1 To 1500000
  x = FindData::SSE2_Find(*HayStack, HayStackSize2, *Needle, NeedleSize2)
Next
t5 = ElapsedMilliseconds()

S + #CRLF$
S + "Test 2" + #CRLF$
S + "----------" + #CRLF$
S + "Tailed Substring : " + Str(t1-t0) + "ms" + #CRLF$
S + "QuickSearch : " + Str(t2-t1) + "ms" + #CRLF$
S + "Boyer-Moore : " + Str(t3-t2) + "ms" + #CRLF$
S + "FastSearch : " + Str(t4-t3) + "ms" + #CRLF$
S + "SSE2 Find : " + Str(t5-t4) + "ms" + #CRLF$

SetClipboardText(S)
MessageRequester("Test results", S)


; ; ; OSX (x64) 
; ; ; Intel(R) Core(TM) i5-4250U CPU @ 1.30GHz
; ; ; 
; ; ; Test 1
; ; ; ----------
; ; ; Tailed Substring : 577ms
; ; ; QuickSearch : 134ms
; ; ; Boyer-Moore : 55ms
; ; ; FastSearch : 260ms
; ; ; SSE2 Find : 93ms
; ; ; 
; ; ; Test 2
; ; ; ----------
; ; ; Tailed Substring : 160ms
; ; ; QuickSearch : 195ms
; ; ; Boyer-Moore : 114ms
; ; ; FastSearch : 75ms
; ; ; SSE2 Find : 42ms

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP