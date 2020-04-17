DeclareModule Hide
  Declare.b Hide(Handle.i)
  Declare.b Window(Window.i)
  Declare.b Gadget(Gadget.i)
EndDeclareModule

Module Hide
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      ImportC ""
        gtk_widget_get_visible(*widget.GtkWidget)
      EndImport
  CompilerEndSelect
  
  Procedure.b Hide(Handle.i) ; Returns TRUE is control hide
    Protected Result.i
    
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows : ProcedureReturn Bool(IsWindowVisible_(Handle)=0)
      CompilerCase #PB_OS_Linux   : ProcedureReturn Bool(gtk_widget_get_visible(Handle)=0)
      CompilerCase #PB_OS_MacOS   
        CocoaMessage(@Result, CocoaMessage(0, handle, "className"), "UTF8String")
        
        If PeekS(Result, -1, #PB_UTF8) = "PBWindow"
          ProcedureReturn Bool(CocoaMessage(0, Handle, "isVisible")=0)
        Else
          ProcedureReturn Bool(CocoaMessage(0, Handle, "isHidden"))
        EndIf
    CompilerEndSelect
  EndProcedure
  
  Procedure.b Window(Window.i) ; Returns TRUE is window hide
    If IsWindow(Window)
      ProcedureReturn Hide(WindowID(Window))
    EndIf
  EndProcedure
  
  Procedure.b Gadget(Gadget.i) ; Returns TRUE is gadget hide
    If IsGadget(Gadget)
      Protected GadgetID = GadgetID(Gadget)
      
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Linux
          Protected *Widget.GtkWidget = GadgetID
          If (GadgetType(Gadget) = #PB_GadgetType_Container Or
              GadgetType(Gadget) = #PB_GadgetType_Panel)
            GadgetID = *Widget\parent
          Else  
            GadgetID = *Widget\object
          EndIf
      CompilerEndSelect
      
      ProcedureReturn Hide(GadgetID)
    EndIf
  EndProcedure
EndModule


CompilerIf #PB_Compiler_IsMainFile
; Shows possible flags of ButtonGadget in action...
  If OpenWindow(0, 0, 0, 222, 200, "ButtonGadgets", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonGadget(0, 10, 10, 200, 20, "Standard Button")
    ButtonGadget(1, 10, 40, 200, 20, "Left Button", #PB_Button_Left)
    ButtonGadget(2, 10, 70, 200, 20, "Right Button", #PB_Button_Right)
    ButtonGadget(3, 10,100, 200, 60, "Multiline Button  (longer text gets automatically wrapped)", #PB_Button_MultiLine)
    ButtonGadget(4, 10,170, 200, 20, "Toggle Button", #PB_Button_Toggle)
    
    HideGadget(1,1)
    Debug Hide::Window(0) ; CocoaMessage (0, WindowID (0), "isVisible")
    Debug Hide::Gadget(1)
    Debug Hide::Gadget(2)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = --
; EnableXP