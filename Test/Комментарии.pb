; Простая строка с комменарием
OpenWindow(#Window1, 0, 0, 100, 100, "Титул", Flags) ; Открывает окно

; Строка с символами ";"
OpenWindow(#Window2, 100, 0, 100, 100, "Ти ; ту;л", Flags) 

; Строка с переносами
OpenWindow(#Window3, 
           0, ; Положение X
           100, ; Положение Y
           100, ; Ширина
           100, ; Высота
           "Титул", Flags)

OpenWindow(#Window4, 100, 100, 100, 100, " Титул", Flags) ; ; ; ; ; ; Открывает окно

;   OpenWindow(#Window5, 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
; OpenWindow(#Window,6 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
;   OpenWindow(#Window7, 100, 100, 100, 100, " Титул", Flags) ; Открывает окно

OpenWindow(8) : OpenWindow(9) : OpenWindow(10) : OpenWindow(11) ; hgjhgjhgjh

; Вложение
OpenWindow(OpenWindow(OpenWindow()), OpenWindow())

DefineWindow=OpenWindow(12)

Procedure WinEndProcedure()
  OpenWindow   (20, 800, 219, 200, 300, "Window 20", #PB_Window_SizeGadget)
  ButtonGadget(20, 10, 60, 80, 20, "But;ton 20") ; ButtonGadget(21, 10, 60, 80, 20, "Button 21 comment")
EndProcedure



; Procedure WinEndProcedureComment()
;   OpenWindow   (30, 800, 219, 200, 300, "Window 30 Comment", #PB_Window_SizeGadget)
;   ButtonGadget(30, 10, 60, 80, 20, "But;ton 30 Comment") ; ButtonGadget(31, 10, 60, 80, 20, "Button 31 comment-comment")
; EndProcedure

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 23
; Folding = -
; EnableXP
; CompileSourceDirectory