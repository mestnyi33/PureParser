EnableExplicit

Global Window_0=-1, 
       Window_0_Container_0=-1, 
       Window_0_Container_1=-1, 
       Window_0_Container_2=-1, 
       Window_0_Container_0_Button_0=-1, 
       Window_0_Container_1_Button_0=-1, 
       Window_0_Container_2_Button_0=-1, 
       Window_0_Canvas_0=-1, 
       Window_0_Canvas_1=-1

Declare Window_0_Events()

Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 0, 0, 441, 381, "Window_0", Flag)
    Window_0_Container_0 = ContainerGadget(#PB_Any, 5, 5, 141, 121, #PB_Container_Flat) 
    Window_0_Container_0_Button_0 = ButtonGadget(#PB_Any, 5, 5, 81, 21, "Button_0")
    CloseGadgetList()
    Window_0_Container_1 = ContainerGadget(#PB_Any, 150, 130, 141, 121, #PB_Container_Flat)
    Window_0_Container_1_Button_0 = ButtonGadget(#PB_Any, 5, 5, 81, 21, "Button_0")
    CloseGadgetList()
    Window_0_Container_2 = ContainerGadget(#PB_Any, 295, 255, 141, 121, #PB_Container_Flat)
    Window_0_Container_2_Button_0 = ButtonGadget(#PB_Any, 5, 5, 81, 21, "Button_0")
    CloseGadgetList()
    Window_0_Canvas_0 = CanvasGadget(#PB_Any, 5, 255, 141, 121) 
    Window_0_Canvas_1 = CanvasGadget(#PB_Any, 295, 5, 141, 121, #PB_Canvas_Container)                                                             
    CloseGadgetList()
    
    BindEvent(#PB_Event_Gadget, @Window_0_Events(), Window_0)
  EndIf

  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Events()
  Select Event()
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
             
          EndSelect
      EndSelect
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Window_0_Open()

  While IsWindow(Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf