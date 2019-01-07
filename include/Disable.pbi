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
  
  Procedure.b Disable(Handle.i) ;Returns TRUE is window disabled
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows : ProcedureReturn Bool(IsWindowEnabled_(Handle)=0)
        CompilerCase#PB_OS_Linux    : ProcedureReturn Bool(gtk_widget_get_sensitive(Handle)=0)
        ;CompilerCase #PB_OS_MacOS   : ProcedureReturn Bool(CocoaMessage(0, Handle, "isDisable")=0)
      CompilerEndSelect
  EndProcedure
  
  Procedure.b Window(Window.i) ; Returns TRUE is window disable
    If IsWindow(Window)
      ProcedureReturn Disable(WindowID(Window))
    EndIf
  EndProcedure
  
  Procedure.b Gadget(Gadget.i) ; Returns TRUE is gadget disable
    If IsGadget(Gadget)
     ProcedureReturn Disable(GadgetID(Gadget))
   EndIf
 EndProcedure
EndModule


; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP