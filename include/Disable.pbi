DeclareModule Disable
  Declare.b Disable(Handle.i)
  Declare.b Window(Window.i)
  Declare.b Gadget(Gadget.i)
EndDeclareModule

Module Disable
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      ImportC ""
        gtk_widget_get_sensitive(*widget.GtkWidget)
      EndImport
  CompilerEndSelect
  
  ; editor 
 ; CocoaMessage (0, GadgetID (Gadget) , "setEditable:", Bool (Not State))
  
  Procedure.b Disable(Handle.i) ;Returns TRUE is window disabled
    If Handle
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows : ProcedureReturn Bool(IsWindowEnabled_(Handle)=0)
        CompilerCase #PB_OS_Linux   : ProcedureReturn Bool(gtk_widget_get_sensitive(Handle)=0)
          ; Protected *Widget.GtkWidget = GadgetID(Handle) : ProcedureReturn Bool(*Widget\state)
       ; CompilerCase #PB_OS_MacOS   : ProcedureReturn Bool(CocoaMessage(0, Handle, "isEnabled")=0)
      CompilerEndSelect
    EndIf
  EndProcedure
  
  Procedure.b Window(Window.i) ; Returns TRUE is window disable
    If IsWindow(Window)
     ; ProcedureReturn Disable(WindowID(Window))
    EndIf
  EndProcedure
  
  Procedure.b Gadget(Gadget.i) ; Returns TRUE is gadget disable
    If IsGadget(Gadget)
     ProcedureReturn Disable(GadgetID(Gadget))
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
    
    DisableWindow(0,1)
    
    DisableGadget(1,1)
;     Debug CocoaMessage (0, WindowID(0), "isDisabled") ;???
    Debug Disable::Gadget(1)
    Debug Disable::Gadget(2)
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP