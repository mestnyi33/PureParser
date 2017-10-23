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
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows : ProcedureReturn Bool(IsWindowVisible_(Handle)=0)
      CompilerCase #PB_OS_Linux   : ProcedureReturn Bool(gtk_widget_get_visible(Handle)=0)
      CompilerCase #PB_OS_MacOS   : ProcedureReturn Bool(CocoaMessage(0, Handle, "isVisible")=0)
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

