CompilerIf Not Defined(Const, #PB_Module)
  DeclareModule Const
    Enumeration #PB_Event_FirstCustomValue
      #PB_Event_Create
      #PB_Event_LeftButtonDown
      #PB_Event_LeftButtonUp
      #PB_Event_MouseMove
      #PB_Event_Destroy
    EndEnumeration
    
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_Destroy
      #PB_EventType_Move
      #PB_EventType_Size
      #PB_EventType_Create
    EndEnumeration
  EndDeclareModule
  
  Module Const 
  EndModule 
  
  UseModule Const
CompilerEndIf


DeclareModule Process
  Declare Init()
  Declare Free()
EndDeclareModule

Module Process
  UseModule Const
  Global ProcessHook
  
  Macro Clip(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Define ___ClipMacroGadgetHeight___ = GadgetHeight( Gadget )
        SetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
        If ___ClipMacroGadgetHeight___ And GadgetType( Gadget ) = #PB_GadgetType_ComboBox
          ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, ___ClipMacroGadgetHeight___ )
        EndIf
        SetWindowPos_( GadgetID( Gadget ), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    CompilerEndSelect
  EndMacro
  
  Procedure events_()
    Select Event()
      Case #WM_CREATE
        If IsGadget(GetProp_( EventGadget() , "PB_ID"))
          Clip(GetProp_( EventGadget() , "PB_ID"))
          PostEvent(#PB_Event_Gadget, GetProp_( EventWindow() , "PB_WindowID")-1, GetProp_( EventGadget() , "PB_ID"), #PB_EventType_Create)
        ElseIf IsWindow(GetProp_( EventWindow() , "PB_WindowID")-1)
          PostEvent(#PB_Event_Create, GetProp_( EventWindow() , "PB_WindowID")-1, #PB_Ignore)
        EndIf
        
      Case #WM_MOVE
        If IsGadget(GetProp_( EventGadget() , "PB_ID"))
          Clip(GetProp_( EventGadget() , "PB_ID"))
          PostEvent(#PB_Event_Gadget, GetProp_( EventWindow() , "PB_WindowID")-1, GetProp_( EventGadget() , "PB_ID"), #PB_EventType_Move)
        ElseIf IsWindow(GetProp_( EventWindow() , "PB_WindowID")-1)
          PostEvent(#PB_Event_MoveWindow, GetProp_( EventWindow() , "PB_WindowID")-1, #PB_Ignore)
        EndIf
    EndSelect
  EndProcedure
  
  Procedure ProcessHook(nCode,wParam,lParam)
    Protected *p.CWPRETSTRUCT = lParam
    
    Select *p\message
      Case #WM_GETMINMAXINFO     ; 36
      Case #WM_GETICON           ; 127
      Case #WM_ACTIVATEAPP       ; 28
      Case #WM_NCACTIVATE        ; 134
      Case #WM_ACTIVATE          ; 6
        
      Case #WM_CREATE, #WM_MOVE            ; 1
        If IsWindowEnabled_(*p\hWnd)
          If *p\hWnd = GetAncestor_( *p\hWnd, #GA_ROOTOWNER )
            PostEvent(*p\message, *p\hWnd, #PB_Ignore)
            BindEvent(*p\message, @events_(), *p\hWnd)
          Else
            PostEvent(*p\message, GetAncestor_( *p\hWnd, #GA_ROOT ), (*p\hWnd))
          EndIf
        EndIf
        
      Case #WM_SIZE              ; 5
;       Case #WM_MOVE              ; 3
;         Debug 5555555
;         Debug GetProp_( *p\hWnd, "PB_ID")
        
      Case #WM_PARENTNOTIFY      ; 528
      Case #WM_SHOWWINDOW        ; 24
      Case #WM_WINDOWPOSCHANGING ; 70
      Case #WM_ERASEBKGND        ; 20
      Case #WM_WINDOWPOSCHANGED  ; 71
      Case #WM_SETFONT           ; 48
        
      Case #WM_NCCREATE          ; 129
      Case #WM_NCCALCSIZE        ; 131
      Case #WM_NOTIFYFORMAT      ; 85
      Case #WM_QUERYUISTATE      ; 297
      Case #WM_CHANGEUISTATE     ; 295
        
      Case #WM_SETFOCUS          ; 7
      Case #WM_KILLFOCUS         ; 8
        
      Case #WM_CAPTURECHANGED    ; 533
      Case #WM_CLOSE             ; 16
      Case #WM_SYSCOMMAND        ; 274
                                 ;           Debug *p\lParam
                                 ;           Debug #SC_CLOSE 
                                 ;           Debug lParam
        
      Case #WM_NCDESTROY         ; 130
                                 ;Debug 55555555555
      Case #WM_DESTROY           ; 2
                                 ; Debug *p\hwnd
                                 ; Debug IsWindow(EventWindow()) ; GetActiveWindow()
                                 ;ProcedureReturn 1
    EndSelect
    
    
    ProcedureReturn CallNextHookEx_(ProcessHook,nCode,wParam,lParam)
  EndProcedure
  
  Procedure Init()
    ProcessHook = SetWindowsHookEx_(#WH_CALLWNDPROCRET, @ProcessHook(), GetModuleHandle_(0), GetCurrentThreadId_()) 
  EndProcedure
  
  Procedure Free()
    UnhookWindowsHookEx_(ProcessHook)
  EndProcedure
EndModule


DeclareModule Mouse
  Declare Init()
  Declare Free()
EndDeclareModule

Module Mouse
  UseModule Const
  Global hhkLLMouse
  
  Procedure MouseHook(nCode,wParam,lParam)
    Protected *ms.MOUSEHOOKSTRUCT = lParam
    Protected hWnd, Window=-1, Gadget=-1
    Protected PB_handle = *ms\hWnd
    Static *Window=-1, *Gadget=-1
    Static LeaveGadget = -1
    
    hWnd = GetAncestor_( *ms\hWnd, #GA_ROOT)
    Window = GetProp_( hWnd , "PB_WindowID") - 1
    
    While GetParent_( GetParent_( PB_handle ) )
      PB_handle = GetParent_( PB_handle )
      
      If IsGadget( GetDlgCtrlID_( PB_handle )) And 
         PB_handle = GadgetID( GetDlgCtrlID_( PB_handle ))
        Break
      EndIf
    Wend
    
    If IsGadget( GetDlgCtrlID_( PB_handle )) And
       PB_handle = GadgetID( GetDlgCtrlID_( PB_handle ))
      Gadget = GetProp_( PB_handle, "PB_ID")
    EndIf
    
    Select wParam
      Case #WM_MOUSEMOVE
        If *Window=-1
          If Gadget=-1
            If LeaveGadget<>Gadget
              PostEvent(#PB_Event_Gadget, Window, LeaveGadget, #PB_EventType_MouseLeave)
              LeaveGadget = Gadget  
            EndIf
          Else
            If LeaveGadget<>Gadget
              If (LeaveGadget<>-1 And Gadget<>-1) And 
                 Not IsChild_(GadgetID(LeaveGadget), GadgetID(Gadget))
                PostEvent(#PB_Event_Gadget, Window, LeaveGadget, #PB_EventType_MouseLeave)
                
                If Not IsChild_(GadgetID(Gadget), GadgetID(LeaveGadget))
                  PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseEnter)
                EndIf
              Else
                PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseEnter)
              EndIf
              LeaveGadget = Gadget
            EndIf
          EndIf
          
          If *ms\hWnd = hWnd
            PostEvent(#PB_Event_MouseMove, Window, #PB_Ignore)
          Else
            PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_MouseMove)
          EndIf
        Else
          If *Gadget=-1
            PostEvent(#PB_Event_MouseMove, *Window, #PB_Ignore)
          Else
            PostEvent(#PB_Event_Gadget, *Window, *Gadget, #PB_EventType_MouseMove)
          EndIf
        EndIf
        
      Case #WM_LBUTTONDOWN
        *Window = Window
        *Gadget = Gadget
        
        If *ms\hWnd = hWnd
          PostEvent(#PB_Event_LeftButtonDown, Window, #PB_Ignore)
        Else
          PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_LeftButtonDown)
        EndIf
        
      Case #WM_LBUTTONUP
        *Window =- 1
        *Gadget =- 1
        
        If *ms\hWnd = hWnd
          PostEvent(#PB_Event_LeftButtonUp, Window, #PB_Ignore)
        Else
          PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_LeftButtonUp)
        EndIf
        
    EndSelect
    
    ProcedureReturn CallNextHookEx_(hhkLLMouse,nCode,wParam,lParam)
  EndProcedure
  
  Procedure Init()
    hhkLLMouse = SetWindowsHookEx_(#WH_MOUSE, @MouseHook(), GetModuleHandle_(0), GetCurrentThreadId_())
  EndProcedure
  
  Procedure Free()
    UnhookWindowsHookEx_(hhkLLMouse)
  EndProcedure
EndModule


DeclareModule Hook
  Declare Init()
  Declare Free()
EndDeclareModule

Module Hook
  Procedure Init()
    Mouse::Init()
    Process::Init()
  EndProcedure
  
  Procedure Free()
    Mouse::Free()
    Process::Free()
  EndProcedure
EndModule 


CompilerIf #PB_Compiler_IsMainFile
  Hook::Init()
  
  Procedure GadgetHandler( EventGadget, EventType )
    Protected MouseX, MouseY, DesktopMouseX = DesktopMouseX(), DesktopMouseY = DesktopMouseY(), Steps = 5
    Static CheckGadget, OffsetX, OffsetY
    
    Select EventType
        ;     Case #PB_EventType_Size : Debug "#PB_EventType_Size " + EventGadget
        ;     Case #PB_EventType_Move : Debug "#PB_EventType_Move " + EventGadget
        
      Case  #PB_EventType_LeftButtonUp : CheckGadget =- 1
      Case  #PB_EventType_LeftButtonDown : CheckGadget = EventGadget
        If IsGadget(CheckGadget)
          OffsetX = DesktopMouseX - (GadgetX(CheckGadget, #PB_Gadget_ContainerCoordinate))
          OffsetY = DesktopMouseY - (GadgetY(CheckGadget, #PB_Gadget_ContainerCoordinate))
        EndIf
        
      Case #PB_EventType_MouseMove
        If IsGadget( CheckGadget )
          MouseX = (DesktopMouseX-OffsetX)
          MouseY = (DesktopMouseY-OffsetY)
          
          If Steps
            ResizeGadget( CheckGadget, ((MouseX / Steps) * Steps), ((MouseY / Steps) * Steps), #PB_Ignore, #PB_Ignore)
          Else
            ResizeGadget( CheckGadget, MouseX , MouseY, #PB_Ignore, #PB_Ignore)
          EndIf
        EndIf
        
    EndSelect
    
  EndProcedure
  
  Procedure events_()
    GadgetHandler( EventGadget(), EventType() )
    If EventType() <> #PB_EventType_MouseMove
      Debug " PB "+Str(Event())+" "+Str(EventWindow())+" "+Str(EventGadget())+" "+Str(EventType())
    EndIf
  EndProcedure
  
  OpenWindow(30,0,0,240,140,"MouseBlock",#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget  |#PB_Window_SizeGadget | 1)
  ButtonGadget(5,5,5,100,30,"but")
  ButtonGadget(15,5,25,100,30,"but")
  
  StickyWindow(30,1)
  
  BindEvent(#PB_Event_LeftButtonDown, @events_(), 30);, WindowID(30))
  BindEvent(#PB_Event_LeftButtonUp, @events_(), 30)  ;, WindowID(30))
  BindEvent(#PB_Event_Gadget, @events_(), 30)        ;, WindowID(30))
  
  While WaitWindowEvent() ! #PB_Event_CloseWindow : Wend
  
  Debug "Close"
  
  Hook::Free()
CompilerEndIf