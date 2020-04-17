

Enumeration FormWindow
  #Test
EndEnumeration

Enumeration FormGadget
  #B1
  #B2
  #B3
  #B4
  #B5
  #B6
  #B7
  #B8
  #B9
  #B10
  #B11
  #B12
  #B13
  #B14
  #B15
  #B16
  
  #S1
  #S2
  #S3
  #S4
  #S5
  #S6
  #S7
  #S8
  #S9
  #S10
  #S11
  #S12
  
  #M1
  #M2
  #M3
EndEnumeration


Procedure OpenWindow_Test()
  OpenWindow(#Test, 0, 0, 400, 400, "", #PB_Window_SystemMenu)
  
  ButtonGadget(#B1, 0, 0, 50, 50, "B1")
  ButtonGadget(#B2, 0, 50, 50, 50, "B2")
  SplitterGadget(#S1, 0, 0, 50, 100, #B1, #B2)
  
  ButtonGadget(#B3, 50, 0, 50, 50, "B3")
  ButtonGadget(#B4, 50, 50, 50, 50, "B4")
  SplitterGadget(#S2, 50, 0, 50, 100, #B3, #B4)
  
  SplitterGadget(#S3, 0, 0, 100, 100, #S1, #S2, #PB_Splitter_Vertical)
  
  
  ButtonGadget(#B5, 0, 100, 50, 50, "B5")
  ButtonGadget(#B6, 0, 150, 50, 50, "B6")
  SplitterGadget(#S4, 0, 100, 50, 100, #B5, #B6)
  
  ButtonGadget(#B7, 50, 100, 50, 50, "B7")
  ButtonGadget(#B8, 50, 150, 50, 50, "B8")
  SplitterGadget(#S5, 50, 100, 50, 100, #B7, #B8)
  
  SplitterGadget(#S6, 0, 100, 100, 100, #S4, #S5, #PB_Splitter_Vertical)
  
  SplitterGadget(#M1, 0, 0, 100, 200, #S3, #S6)
  
  
  
  ButtonGadget(#B9, 100, 0, 50, 50, "B9")
  ButtonGadget(#B10, 100, 50, 50, 50, "B10")
  SplitterGadget(#S7, 100, 0, 50, 100, #B9, #B10)
  
  ButtonGadget(#B11, 150, 0, 50, 50, "B11")
  ButtonGadget(#B12, 150, 50, 50, 50, "B12")
  SplitterGadget(#S8, 150, 0, 50, 100, #B11, #B12)
  
  SplitterGadget(#S9, 100, 0, 100, 100, #S7, #S8, #PB_Splitter_Vertical)
  
  
  ButtonGadget(#B13, 100, 100, 50, 50, "B13")
  ButtonGadget(#B14, 100, 150, 50, 50, "B14")
  SplitterGadget(#S10, 100, 100, 50, 100, #B13, #B14)
  
  ButtonGadget(#B15, 150, 100, 50, 50, "B15")
  ButtonGadget(#B16, 150, 150, 50, 50, "B16")
  SplitterGadget(#S11, 150, 100, 50, 100, #B15, #B16)
  
  SplitterGadget(#S12, 100, 100, 100, 100, #S10, #S11, #PB_Splitter_Vertical)
    
  SplitterGadget(#M2, 100, 0, 100, 200, #S9, #S12)
  
  
  SplitterGadget(#M3, 0, 0, 400, 400, #M1, #M2, #PB_Splitter_Vertical)
EndProcedure



OpenWindow_Test()
Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow


; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 57
; FirstLine = 30
; Folding = -
; EnableXP
; CompileSourceDirectory