EnableExplicit

Global W_Window_1=-1,
       G_Window_1_Image_0=-1,
       G_Window_1_Button_0=-1

Global I_Window_1_0=-1

Declare W_Window_1_Events(Event)

I_Window_1_0 = LoadImage(#PB_Any, #PB_Compiler_Home + "examples\sources\Data\PureBasic.bmp")  

Procedure W_Window_1_CallBack()
  W_Window_1_Events(Event())
EndProcedure

Procedure W_Window_1_Open(ParentID.i=0, Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If IsWindow(W_Window_1)
    SetActiveWindow(W_Window_1)
    ProcedureReturn W_Window_1
  EndIf
  
  W_Window_1 = OpenWindow(#PB_Any, 0, 0, 261, 156, "Window_1", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If IsWindow(W_Window_1)
    SetActiveWindow(W_Window_1)
    ProcedureReturn W_Window_1
  EndIf
)                                                                             
  G_Window_1_Image_0 = ImageGadget(#PB_Any, 5, 5, 251, 121, ImageID(I_Window_1_0), #PB_Image_Border)                                                       
  G_Window_1_Button_0 = ButtonGadget(#PB_Any, 90, 130, 81, 21, "Button_0") 
  
  ProcedureReturn W_Window_1
EndProcedure

Procedure W_Window_1_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      If MessageRequester("Предупреждение!!!","Вы, хотите выйти?"+#CRLF$+"Может быть вы останетесь", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        ProcedureReturn #False
      EndIf
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case G_Window_1_Button_0
              If MessageRequester("Предупреждение!!!","Вы, хотите выйти?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
                ProcedureReturn #PB_Event_CloseWindow
              EndIf
              
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Event
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  W_Window_1_Open()
  
  Repeat : Until W_Window_1_Events(WaitWindowEvent()) = #PB_Event_CloseWindow 
CompilerEndIf