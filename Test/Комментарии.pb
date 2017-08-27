Procedure 
  ; Простая строка с комменарием
  OpenWindow(#Window, 0, 0, 100, 100, "Титул", Flags) ; Открывает окно
  
  ; Строка с символами ";"
  OpenWindow(#Window, 100, 0, 100, 100, "Ти ; ту;л", Flags) ; Открывает окно
  
  ; Строка с переносами
  OpenWindow(#Window, 
             0, ; Положение X
             100, ; Положение Y
             100, ; Ширина
             100, ; Высота
             "Титул", Flags)
  
  OpenWindow(#Window, 100, 100, 100, 100, " Титул", Flags) ; ; ; ; ; ; Открывает окно
  
  ;   OpenWindow(#Window, 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
  ; OpenWindow(#Window, 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
;   OpenWindow(#Window, 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
  
EndProcedure

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 17
; Folding = -
; EnableXP
; CompileSourceDirectory