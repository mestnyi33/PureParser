CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "Constant.pbi"
CompilerEndIf

DeclareModule Resize
   #PB_EventType_Repaint = 99999
  Declare Gadget( Gadget )
EndDeclareModule

Module Resize
  UseModule Constant
  ;-
  Procedure IDGadget( GadgetID )
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        ProcedureReturn GetProp_( GadgetID, "PB_GadgetID") - 1
        
      CompilerCase #PB_OS_Linux
        ProcedureReturn g_object_get_data_( GadgetID, "PB_GadgetID") - 1
        
    CompilerEndSelect
  EndProcedure
  
  
  ;-
  Procedure SetIDGadget( Gadget )
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        If GetProp_( GadgetID( Gadget ), "PB_GadgetID" ) = 0
          ProcedureReturn SetProp_( GadgetID( Gadget ), "PB_GadgetID", Gadget + (1))
        EndIf
        
      CompilerCase #PB_OS_Linux
        If g_object_get_data_( GadgetID( Gadget ), "PB_GadgetID" ) = 0
          ProcedureReturn g_object_set_data_( GadgetID( Gadget ), "PB_GadgetID", Gadget + (1))
        EndIf
        
    CompilerEndSelect
  EndProcedure
  
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      Procedure Resize_CallBack(GadgetID, Msg, wParam, lParam)
        Protected *Func = GetProp_( GadgetID, "Resize_Event_CallBack") 
        Protected *Gadget = IDGadget( GadgetID )
        Protected *Window = GetActiveWindow()
        
        Select Msg
          Case #WM_PAINT : PostEvent( #PB_Event_Gadget, *Window, *Gadget, #PB_EventType_Repaint)
              ProcedureReturn CallWindowProc_(*Func, GadgetID, Msg, wParam, lParam)
          Case #WM_SIZE : PostEvent( #PB_Event_Gadget, *Window, *Gadget , #PB_EventType_Size )
          Case #WM_MOVE : PostEvent( #PB_Event_Gadget, *Window, *Gadget , #PB_EventType_Move )
          Default
            ProcedureReturn CallWindowProc_(*Func, GadgetID, Msg, wParam, lParam)
        EndSelect
      EndProcedure
      
    CompilerCase #PB_OS_Linux
      ProcedureC Resize_CallBack( *Event.GdkEventAny, *Handle )
        Protected *Widget.GtkWidget = gtk_get_event_widget_(*Event)
        Protected *Gadget = IDGadget( *Widget )
        
        If *Widget
          Debug PeekS( gtk_widget_get_name_( (*Widget)), -1, #PB_UTF8 ) + " " + Str(*Gadget)
        EndIf
        
        If *Widget And *Widget = g_object_get_data_(*Widget, "Resize_Event_CallBack")
          Select *Event\type 
            Case #GDK_CONFIGURE
              PostEvent( #PB_Event_Gadget, *Window, *Gadget , #PB_EventType_Size )
              PostEvent( #PB_Event_Gadget, *Window, *Gadget , #PB_EventType_Move )
              
            Case #GDK_UNMAP
              
              gdk_event_handler_set_( 0, 0, 0 )
            Default
              
              gtk_main_do_event_( *Event )
          EndSelect
        Else
          gtk_main_do_event_( *Event )
        EndIf
      EndProcedure 
      
  CompilerEndSelect
  
  ;-
  Procedure Gadget( Gadget )
    Protected GadgetID, GadgetID1, GadgetID2, GadgetID3, GadgetID4
    
    If IsGadget( Gadget ) : SetIDGadget( Gadget )
      GadgetID = GadgetID( Gadget )
      
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux
          g_object_set_data_( GadgetID, "PB_GadgetID", Gadget + 1 )
          g_object_set_data_( GadgetID, "Resize_Event_CallBack", GadgetID )
          gdk_event_handler_set_( @Resize_CallBack(), GadgetID, 0 )
          
        CompilerCase #PB_OS_Windows
          If GadgetID  And GetProp_( GadgetID,  "Resize_Event_CallBack") = #False
            SetProp_( GadgetID, "Resize_Event_CallBack", SetWindowLong_(GadgetID, #GWL_WNDPROC, @Resize_CallBack()))
          EndIf
          
      CompilerEndSelect
    EndIf
  EndProcedure
  
EndModule


CompilerIf #PB_Compiler_IsMainFile
  Global Window_0
  
  
  Procedure GadgetEvents()
    
    Define CurrentGadget.i
    
    Select EventType()
        
      Case #PB_EventType_MouseEnter
        Debug "Mouse Entered Gadget " + Str(EventGadget())
        ResizeGadget( EventGadget(), #PB_Ignore, #PB_Ignore, 155, #PB_Ignore)
        
        
      Case #PB_EventType_MouseLeave 
        Debug "Mouse Left Gadget " + Str(EventGadget())       
        ResizeGadget( EventGadget(), #PB_Ignore, #PB_Ignore, 135, #PB_Ignore)
        
      Case #PB_EventType_Size
        Debug "#PB_EventType_Size " + Str(EventGadget())        
        
    EndSelect
    
  EndProcedure
  
  Procedure CustomGadget(Gadget, X,Y,Width,Height)
    Protected ID
    
    ;Create The Canvas For The Gadget
    ID = CanvasGadget(Gadget, X,Y,Width,Height) 
    If IsGadget(ID) : Gadget = ID : EndIf
    
    ;Bind This gadgets Events
    BindGadgetEvent(Gadget, @GadgetEvents())
    
    Resize::Gadget( Gadget )
  EndProcedure
  
 
  Window_0 = OpenWindow(#PB_Any, 0, 0, 550, 400, "", #PB_Window_SystemMenu)
  CustomGadget(#PB_Any,290, 40, 130, 80)
  CustomGadget(23,100, 40, 130, 80)  
  CustomGadget(#PB_Any,100, 240, 130, 80)
  CustomGadget(#PB_Any,290, 240, 130, 80)
  
  Repeat
    
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_CloseWindow
        End
    EndSelect
    
  ForEver
  
CompilerEndIf


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; Folding = ----
; EnableXP