



Enumeration FormWindow
  #Window
  
EndEnumeration

Enumeration FormGadget
  #Gadget_W1
  #Gadget_BottomPanel
  #Gadget_Right
  #Gadget_Left
  #Gadget_F3
  #Gadget_F1
  #Gadget_F2
EndEnumeration



Declare OpenWindow_Pager()
Declare CloseWindow_Pager()


Procedure Pager_Resize()
  WindowWidth=WindowWidth(#Window)
  WindowHeight=WindowHeight(#Window)
  
  ResizeGadget(#Gadget_W1, 0, 0, WindowWidth, WindowHeight-45)
  
  ResizeGadget(#Gadget_BottomPanel, (WindowWidth-545)/2, WindowHeight-45, #PB_Ignore, #PB_Ignore)
EndProcedure

Procedure OpenWindow_Pager()
  If OpenWindow(#Window, #PB_Ignore, #PB_Ignore, 800, 600, "", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_Maximize)
    
    WebGadget(#Gadget_W1, 0, 0, 800, 555, "")
    ContainerGadget(#Gadget_BottomPanel, 135, 555, 545, 45)
    ButtonGadget(#Gadget_Right, 455, 5, 85, 35, "Вперёд")
    ButtonGadget(#Gadget_Left, 365, 5, 85, 35, "Назад")
    
    ButtonGadget(#Gadget_F1, 5, 5, 90, 35, "F1")
    ButtonGadget(#Gadget_F2, 100, 5, 90, 35, "F2")
    ButtonGadget(#Gadget_F3, 225, 5, 110, 35, "F3")
    CloseGadgetList()
    
    SetGadgetColor(#Gadget_BottomPanel, #PB_Gadget_BackColor, RGB(100, 100, 100))
    
    

    
    
    
    
    Pager_Resize()
    


    BindEvent(#PB_Event_SizeWindow, @Pager_Resize(), #Window)
    BindEvent(#PB_Event_CloseWindow, @CloseWindow_Pager(), #Window)
  EndIf

EndProcedure



Procedure CloseWindow_Pager()
  If IsWindow(#Window)
    UnbindEvent(#PB_Event_SizeWindow, @Pager_Resize(), #Window)
    UnbindEvent(#PB_Event_CloseWindow, @CloseWindow_Pager(), #Window)
    
    
    CloseWindow(#Window)
  EndIf

EndProcedure






Declare OpenWindow_Util()
Declare CloseWindow_Util()


Enumeration FormWindow
  #Util_Window
EndEnumeration

Enumeration FormGadget
  #Util_OpenFile
  #Util_Editor
  #Util_OpenAll
  #Util_ViewAll
  #Util_Statistic
EndEnumeration


Enumeration RegEx
  #Util_RegEx_URL
EndEnumeration




Procedure Util_ViewAll()

  OpenWindow_Pager()

EndProcedure


Procedure OpenWindow_Util()
  OpenWindow(#Util_Window, #PB_Ignore, #PB_Ignore, 615, 400, "", #PB_Window_SystemMenu)
; ButtonGadget(#Util_OpenFile, 5, 5, 105, 15, "Из файла")
  EditorGadget(#Util_Editor, 5, 25, 500, 345)
  ButtonGadget(#Util_OpenAll, 510, 25, 100, 30, "Открыть все")
  ButtonGadget(#Util_ViewAll, 510, 60, 100, 30, "Просмотреть")
  TextGadget(#Util_Statistic, 5, 375, 605, 20, "")
  


  BindGadgetEvent(#Util_ViewAll, @Util_ViewAll())
  BindEvent(#PB_Event_CloseWindow, @CloseWindow_Util(), #Util_Window)
EndProcedure


Procedure CloseWindow_Util()
  If IsWindow(#Util_Window)


    UnbindGadgetEvent(#Util_ViewAll, @Util_ViewAll())
    UnbindEvent(#PB_Event_CloseWindow, @CloseWindow_Util(), #Util_Window)
    CloseWindow(#Util_Window)
  EndIf
EndProcedure


OpenWindow_Util()

While IsWindow(#Util_Window)
  WaitWindowEvent()
Wend

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 131
; FirstLine = 84
; Folding = --
; EnableXP
; Executable = ..\Google Диск\Новая папка (3)\Утилита 1.exe
; CompileSourceDirectory