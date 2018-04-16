EnableExplicit

Define Event

Enumeration FormWindow
  #Window_0
EndEnumeration

Enumeration FormGadget
  #Window_0_Image_0
  #Window_0_Button_0
  #Window_0_Button_1
  #Window_0_Button_2
  #Window_0_Button_3
  #Window_0_Button_4
  #Window_0_Button_5
  #Window_0_Button_6
EndEnumeration

Procedure Open_Window_0()
  OpenWindow(#Window_0, 29, 127, 416, 211, "Window_0")
  ImageGadget(#Window_0_Image_0, 5, 5, 306, 201, 0, #PB_Image_Border)
  ButtonGadget(#Window_0_Button_0, 315, 5, 96, 21, "Загрузить")
  ButtonGadget(#Window_0_Button_1, 315, 30, 96, 21, "Сохранить")
  ButtonGadget(#Window_0_Button_2, 315, 70, 96, 21, "Вырезать")
  ButtonGadget(#Window_0_Button_3, 315, 95, 96, 21, "Копировать")
  ButtonGadget(#Window_0_Button_4, 315, 120, 96, 21, "Вставить")
  ButtonGadget(#Window_0_Button_5, 315, 160, 96, 21, "Применить")
  ButtonGadget(#Window_0_Button_6, 315, 185, 96, 21, "Отмена")
  
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Open_Window_0()
  
  While IsWindow(#Window_0)
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(EventWindow())
    EndSelect
    
    Select EventWindow()
      Case #Window_0
    EndSelect
  Wend
  
  End
CompilerEndIf


