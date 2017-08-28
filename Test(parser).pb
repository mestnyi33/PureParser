
; Простая строка с комменарием
WindowID = OpenWindow(#Window0, 0, 0, 100, 100, "Титул", Flags) ; Открывает окно
  ;    WindowID = OpenWindow(#Window1, 0, 0, 100, 100, "Титул", Flags) ; Открывает окно
  
  ; Строка с символами ";"
OpenWindow(#Window2, 100, 0, 100, 100, "Ти ; ту;л", Flags) 
  
  ; Строка с переносами
  OpenWindow(#Window3, 
             10, ; Положение X
             20, ; Положение Y
             30, ; Ширина
             40, ; Высота
             "Титул", Flags)
  
  OpenWindow(#Window4, 100, 100, 100, 100, " Титул", Flags) ; ; ; ; ; ; Открывает окно
  
  ;   OpenWindow(#Window5, 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
  ;;; OpenWindow(#Window,6 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
;   OpenWindow(#Window7, 100, 100, 100, 100, " Титул", Flags) ; Открывает окно
  
  
  Procedure WinEndProcedure()
  OpenWindow   (42, 800, 219, 200, 300, "Window 42", #PB_Window_SizeGadget)
  ButtonGadget(20, 10, 60, 80, 20, "But;ton 20") ; ButtonGadget(20, 10, 60, 80, 20, "Button 20 comment")
EndProcedure


  OpenWindow(8) : OpenWindow(9) : OpenWindow(10) : OpenWindow(11) ; hgjhgjhgjh
  

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 5
; Folding = -
; EnableXP
; CompileSourceDirectory