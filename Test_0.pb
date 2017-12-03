If 0_Window = OpenWindow(#PB_Any, 20, 20, 261, 161, "Заголовок", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)                                                                                                      
  
  Repeat
    A= WaitWindowEvent()
    If A=#PB_Event_CloseWindow
      Q=1
    EndIf
  Until Q=1 
  
EndIf 
End 
