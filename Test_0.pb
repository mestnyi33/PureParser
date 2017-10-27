EnableExplicit

Global.i Window_0=-1, 
      Window_0_Button_0=-1, 
      Window_0_String_0=-1,
      Window_0_Button_1=-1,
      Window_0_String_1=-1,
      Window_0_Container_0=-1,
      Window_0_Container_1=-1

Global.i Font_String_0=-1,
      Font_Button_0=-1

Declare Window_0_Event()

Font_String_0 = LoadFont(#PB_Any, "Consolas", 12, #PB_Font_Bold)
Font_Button_0 = LoadFont(#PB_Any, "Consolas", 7, #PB_Font_Bold|#PB_Font_Italic)

Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 665, 282, 200, 260, "Window_0", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)                                                                                                                
    
                                                                         
                                                                     
                                                                                                                                              
    
    Window_0_Container_0 = ContainerGadget(#PB_Any, 5, 100, 190, 155, #PB_Container_Flat)
    SetGadgetColor(Window_0_Container_0, #PB_Gadget_BackColor, $77FF8A)
    Window_0_Button_0 = ButtonGadget(#PB_Any, 20, 10, 105, 30, "189 Button_0")                                                                                                                            
    
    Window_0_Container_1 = ContainerGadget(#PB_Any, 10, 50, 170, 70, #PB_Container_Single)
    SetGadgetColor(Window_0_Container_1, #PB_Gadget_BackColor, RGB(138, 255, 119))
    Window_0_String_0 = StringGadget(#PB_Any, 10, 10, 100, 30, "String_0")
    SetGadgetFont(Window_0_String_0, FontID(Font_String_0))
    CloseGadgetList()
    CloseGadgetList()
    
    Window_0_Button_1 = ButtonGadget(#PB_Any, 10, 70, 80, 20, "Button_1")                                                                  
    
    BindEvent(#PB_Event_Gadget, @Window_0_Event(), Window_0)
  EndIf
  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Event()
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
