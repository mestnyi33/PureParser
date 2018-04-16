EnableExplicit

Define Event

Global Window_0=-1

Global Window_0_Image_0=-1
Global Window_0_Button_0=-1
Global Window_0_Button_1=-1
Global Window_0_Button_2=-1
Global Window_0_Button_3=-1
Global Window_0_Button_4=-1
Global Window_0_Button_5=-1
Global Window_0_Button_6=-1

Procedure Open_Window_0()
  Window_0 = OpenWindow(#PB_Any, 29, 127, 416, 211, "Window_0")
  Window_0_Image_0 = ImageGadget(#PB_Any, 5, 5, 306, 201, 0, #PB_Image_Border)
  Window_0_Button_0 = ButtonGadget(#PB_Any, 315, 5, 96, 21, "Загрузить")
  Window_0_Button_1 = ButtonGadget(#PB_Any, 315, 30, 96, 21, "Сохранить")
  Window_0_Button_2 = ButtonGadget(#PB_Any, 315, 70, 96, 21, "Вырезать")
  Window_0_Button_3 = ButtonGadget(#PB_Any, 315, 95, 96, 21, "Копировать")
  Window_0_Button_4 = ButtonGadget(#PB_Any, 315, 120, 96, 21, "Вставить")
  Window_0_Button_5 = ButtonGadget(#PB_Any, 315, 160, 96, 21, "Применить")
  Window_0_Button_6 = ButtonGadget(#PB_Any, 315, 185, 96, 21, "Отмена")

EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Open_Window_0()

  While IsWindow(Window_0)
    Event = WaitWindowEvent()

    Select Event
       Case #PB_Event_CloseWindow
         CloseWindow(EventWindow())
    EndSelect

    Select EventWindow()
      Case Window_0
    EndSelect
  Wend

  End
CompilerEndIf


