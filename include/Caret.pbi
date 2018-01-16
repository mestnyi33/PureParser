DeclareModule Caret
  Declare SetPos(Gadget, Position)
EndDeclareModule

Module Caret
  Procedure SetPos(Gadget, Position)
    ;     SetActiveGadget(Gadget)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        If GadgetType( Gadget) = #PB_GadgetType_Editor
          Protected PositionIter.GtkTextIter
          Protected TextBuffer = gtk_text_view_get_buffer_(GadgetID(Gadget))
          gtk_text_buffer_get_iter_at_offset_(TextBuffer, @PositionIter, Position)
          gtk_text_buffer_place_cursor_(TextBuffer, PositionIter)
        Else
          gtk_editable_set_position_( GadgetID(Gadget), Position )
        EndIf
        
      CompilerCase #PB_OS_MacOS
        Protected Range.NSRange : Range\location = Position
        CocoaMessage(0, GadgetID(Gadget), "setSelectedRange:@", @Range)
        CocoaMessage(0, GadgetID(Gadget), "scrollRangeToVisible:@", @Range)
        
      CompilerCase #PB_OS_Windows
        SendMessage_(GadgetID(Gadget), #EM_SETSEL, Position, Position) 
        
    CompilerEndSelect
  EndProcedure
EndModule

Macro SetCaretPos(_gadget_, _position_)
  Caret::SetPos(_gadget_, _position_)
EndMacro

