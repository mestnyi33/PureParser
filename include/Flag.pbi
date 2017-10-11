; http://www.purebasic.fr/english/viewtopic.php?f=13&t=61700&p=462648#p462648
DeclareModule Flag
  EnableExplicit
  
  #PB_Window_NoIcon= 1<<32
  #PB_Window_Drag = 1<<33
  #PB_Window_BorderFlat = 1<<34
  #PB_Window_NoTaskBar = 1<<35
  #PB_Window_Transparentes = 1<<35
  
  Macro IsFlag(GetFlag, IsFlag)
    Bool((GetFlag & IsFlag) = IsFlag)
  EndMacro
  
  Declare SetWindow(Window, Flags.q, Value=0)
  Declare RemoveWindow(Window, Flags.q)
  Declare.q GetWindow(Window)
;   Declare SetGadget(Gadget, Flags.q, Value=0)
;   Declare RemoveGadget(Gadget, Flags.q)
;   Declare.q GetGadget(Gadget)
  
  Declare GetStyle(Handle)
  Declare SetStyle(Handle, Style)
  Declare GetExStyle(Handle)
  Declare SetExStyle(Handle, ExStyle)
  Declare RemoveStyle(Handle, Style)
  Declare RemoveExStyle(Handle, ExStyle)
EndDeclareModule

Module Flag
  Procedure GetStyle(Handle)
    CompilerSelect #PB_Compiler_OS  
      CompilerCase #PB_OS_Windows
        ProcedureReturn GetWindowLongPtr_(Handle, #GWL_STYLE)
    CompilerEndSelect         
  EndProcedure   
  
  Procedure SetStyle(Handle, Style) 
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      SetWindowLongPtr_(Handle, #GWL_STYLE, GetWindowLong_(Handle, #GWL_STYLE)|Style)
      
      If (Style & #WS_SIZEBOX | #WS_BORDER | #WS_VISIBLE)
        SetWindowPos_(Handle, 0,0,0,0,0, #SWP_FRAMECHANGED|#SWP_DRAWFRAME|#SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER)
        InvalidateRect_(Handle,0,#True)
      EndIf
    CompilerEndIf
  EndProcedure
  
  Procedure RemoveStyle(Handle,Style)
    CompilerSelect #PB_Compiler_OS  
      CompilerCase #PB_OS_Windows
        SetWindowLongPtr_(Handle,#GWL_STYLE,GetWindowLongPtr_(Handle,#GWL_STYLE) &~ Style)
        
        If (Style & #WS_SIZEBOX | #WS_BORDER | #WS_VISIBLE)
          SetWindowPos_(Handle, 0, 0, 0, 0, 0,  #SWP_FRAMECHANGED|#SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER)
          InvalidateRect_(Handle,0,#True)
        EndIf
    CompilerEndSelect         
  EndProcedure   
  
  Procedure GetExStyle(Handle)
    CompilerSelect #PB_Compiler_OS  
      CompilerCase #PB_OS_Windows
        ProcedureReturn GetWindowLongPtr_(Handle, #GWL_EXSTYLE)
    CompilerEndSelect         
  EndProcedure  
  
  Procedure SetExStyle(Handle,ExStyle)
    CompilerSelect #PB_Compiler_OS  
      CompilerCase #PB_OS_Windows
        SetWindowLongPtr_(Handle,#GWL_EXSTYLE,GetWindowLongPtr_(Handle,#GWL_EXSTYLE)|ExStyle)
        SetWindowPos_(Handle, 0, 0, 0, 0, 0, #SWP_FRAMECHANGED| #SWP_NOMOVE| #SWP_NOSIZE| #SWP_NOZORDER)
    CompilerEndSelect         
  EndProcedure   
  
  Procedure RemoveExStyle(Handle,ExStyle)
    CompilerSelect #PB_Compiler_OS  
      CompilerCase #PB_OS_Windows
        SetWindowLongPtr_(Handle,#GWL_EXSTYLE,GetWindowLongPtr_(Handle,#GWL_EXSTYLE) &~ ExStyle)
    CompilerEndSelect         
  EndProcedure   
  
  Procedure.q GetWindow( Window )
    Static Flag
    Protected Handle = WindowID(Window)
    Protected Flags = GetStyle(Handle)
    
    If IsFlag(Flags,#WS_MAXIMIZEBOX)   ;Ok 
      Flag | #PB_Window_MaximizeGadget&~#PB_Window_TitleBar&~#PB_Window_SystemMenu 
    EndIf
    
    If IsFlag(Flags,#WS_MINIMIZEBOX)   ;Ok 
      Flag | #PB_Window_MinimizeGadget&~#PB_Window_TitleBar&~#PB_Window_SystemMenu 
    EndIf
    
    If IsFlag(Flags,#WS_SYSMENU)       ;Ok
      Flag | #PB_Window_SystemMenu&~#PB_Window_TitleBar
    EndIf
    
    If IsFlag(Flags,#WS_SIZEBOX)       ;Ok
      Flag | #PB_Window_SizeGadget&~#PB_Window_TitleBar 
    EndIf
    
    If IsFlag(Flags,#WS_CAPTION)       ;Ok
      Flag | #PB_Window_TitleBar 
    EndIf
    
    If Not IsFlag(Flags,#WS_BORDER)    ;Ok
      Flag | #PB_Window_BorderLess 
    EndIf
    
    If Not IsFlag(Flags,#WS_VISIBLE)   ;Ok
      Flag | #PB_Window_Invisible
    EndIf
    
    If IsFlag(Flags,#WS_MAXIMIZE)      ;Ok
      Flag | #PB_Window_Maximize
    EndIf
    
    If IsFlag(Flags,#WS_MINIMIZE)      ;Ok
      Flag | #PB_Window_Minimize
    EndIf
    
    If IsFlag(Flags,#PB_Window_NoGadgets)      ;
      If Not Bool(Handle = UseGadgetList(0))
        Flag | #PB_Window_NoGadgets
      EndIf
    EndIf
    
    ;{   If IsFlag(Flags,#PB_Window_WindowCentered) ;
    If IsWindow(GetProp_(GetParent_(Handle),"PB_WindowID")-1)
      Protected WindowWidth = (WindowWidth(GetProp_(GetParent_(Handle),"PB_WindowID")-1)-WindowWidth(Window,#PB_Window_FrameCoordinate))/2
      Protected WindowHeight = (WindowHeight(GetProp_(GetParent_(Handle),"PB_WindowID")-1)-WindowHeight(Window,#PB_Window_FrameCoordinate))/2
      If WindowX(Window) = WindowWidth And WindowY(Window) = WindowHeight
        Flag = Flag|#PB_Window_WindowCentered
        ; Debug "^#PB_Window_ScreenCentered"
      EndIf
    EndIf
    ;} 
    
    ;{   If IsFlag(Flags,#PB_Window_ScreenCentered) ;
    Protected I,DesktopWidth,DesktopHeight,Desktop = ExamineDesktops()-1
    For i =0 To Desktop
      DesktopWidth + DesktopWidth(Desktop)
      DesktopHeight + DesktopHeight(Desktop)
    Next
    DesktopWidth = (DesktopWidth-WindowWidth(Window,#PB_Window_FrameCoordinate))/2
    DesktopHeight = (DesktopHeight-WindowHeight(Window,#PB_Window_FrameCoordinate))/2
    
    If WindowX(Window) = DesktopWidth And WindowY(Window) = DesktopHeight
      Flag = Flag|#PB_Window_ScreenCentered
      ; Debug "^#PB_Window_ScreenCentered"
    EndIf
    ;}
    
    ; EXSTYLE
    Flags = GetExStyle(Handle)
    If IsFlag(Flags,#WS_EX_TOOLWINDOW)         ;Ok
      Flag | #PB_Window_Tool 
    EndIf
    If IsFlag(Flags,#WS_EX_NOACTIVATE)     ;Ok
      Flag | #PB_Window_NoActivate 
    EndIf
    
    ;; Debug Bin(Flag)
    ProcedureReturn Flag
  EndProcedure
  
  Procedure SetWindow( Window, Flags.q, Value=0 )
    Protected Handle = WindowID(Window)
    
    If IsFlag(Flags,#PB_Window_SizeGadget)     ;Ok
      SetStyle(Handle, (#WS_SIZEBOX))
      Flags&~#PB_Window_TitleBar
    EndIf
    If IsFlag(Flags,#PB_Window_TitleBar)       ;Ok
      SetStyle(Handle, (#WS_CAPTION))
    EndIf
    If IsFlag(Flags,#PB_Window_SystemMenu)     ;Ok
      SetStyle(Handle, (#WS_SYSMENU))
    EndIf
    If IsFlag(Flags,#PB_Window_MaximizeGadget) ;Ok 
      SetStyle(Handle, (#WS_MAXIMIZEBOX))
    EndIf
    If IsFlag(Flags,#PB_Window_MinimizeGadget) ;Ok 
      SetStyle(Handle, (#WS_MINIMIZEBOX))
    EndIf
    If IsFlag(Flags,#PB_Window_BorderLess)     ;Ok
      RemoveStyle(Handle, (#WS_BORDER))
    EndIf
    
    If IsFlag(Flags,#PB_Window_Invisible)      ;Ok
      ShowWindow_(Handle, #SW_HIDE)
    EndIf
    If IsFlag(Flags,#PB_Window_Maximize)       ;Ok
      SetWindowState(Window, #PB_Window_Maximize)
    EndIf
    If IsFlag(Flags,#PB_Window_Minimize)       ;Ok
      SetWindowState(Window, #PB_Window_Minimize)
    EndIf
    If IsFlag(Flags,#PB_Window_WindowCentered) ;Ok
      SetProp_(Handle, "WindowCentered", 1)
      If GetProp_(Handle, "ScreenCentered") = 0
        SetProp_(Handle, "CenteredX", WindowX(Window))
        SetProp_(Handle, "CenteredY", WindowY(Window))
      EndIf
      HideWindow(Window,#False,#PB_Window_WindowCentered)
    EndIf
    If IsFlag(Flags,#PB_Window_ScreenCentered) ;Ok
      SetProp_(Handle, "ScreenCentered", 1)
      If GetProp_(Handle, "WindowCentered") = 0
        SetProp_(Handle, "CenteredX", WindowX(Window))
        SetProp_(Handle, "CenteredY", WindowY(Window))
      EndIf
      HideWindow(Window,#False,#PB_Window_ScreenCentered)
    EndIf
    If IsFlag(Flags,#PB_Window_NoGadgets)      ;
      UseGadgetList(UseGadgetList(0))
    EndIf
    
    If IsFlag(Flags,#PB_Window_Tool)           ;Ok
      SetExStyle(Handle, (#WS_EX_TOOLWINDOW))
    EndIf
    If IsFlag(Flags,#PB_Window_NoActivate)     ;Ok
      RemoveExStyle(Handle, (#WS_EX_NOACTIVATE))
    EndIf
    If IsFlag(Flags,#PB_Window_Transparentes) ;Ok
      Protected State = Bool(IsWindowVisible_(Handle)=0) 
      If State : ShowWindow_(Handle, #SW_SHOW) : EndIf
      SetWindowLongPtr_(Handle,#GWL_EXSTYLE,GetWindowLongPtr_(Handle,#GWL_EXSTYLE) | #WS_EX_LAYERED)
      SetLayeredWindowAttributes_(Handle, 0, Value, #LWA_ALPHA)
      If State : ShowWindow_(Handle, #SW_HIDE) : EndIf
    EndIf
    
  EndProcedure
  
  Procedure RemoveWindow( Window, Flags.q )
    Protected Handle = WindowID(Window)
    
    If IsFlag(Flags,#PB_Window_MaximizeGadget) Or IsFlag(Flags,#PB_Window_MinimizeGadget)     ;Ok
      Flags &~#PB_Window_SystemMenu
    ElseIf IsFlag(Flags,#PB_Window_SizeGadget) Or IsFlag(Flags,#PB_Window_SystemMenu)     ;Ok
      Flags &~#PB_Window_TitleBar
    EndIf

    If IsFlag(Flags,#PB_Window_TitleBar)       ;Ok
     If Not Bool(IsFlag(GetStyle(Handle),#WS_SYSMENU|#WS_MAXIMIZEBOX|#WS_MINIMIZEBOX))   ;Ok 
       RemoveStyle(Handle, (#WS_CAPTION&~#WS_BORDER))
     EndIf
    EndIf
    If IsFlag(Flags,#PB_Window_SystemMenu&~#PB_Window_TitleBar)     ;Ok
      If Not Bool(IsFlag(GetStyle(Handle),#WS_MAXIMIZEBOX|#WS_MINIMIZEBOX))   ;Ok 
        RemoveStyle(Handle, (#WS_SYSMENU))
      EndIf
    EndIf
    If IsFlag(Flags,#PB_Window_MaximizeGadget&~#PB_Window_TitleBar&~#PB_Window_SystemMenu) ;Ok 
      RemoveStyle(Handle, (#WS_MAXIMIZEBOX))
    EndIf
    If IsFlag(Flags,#PB_Window_MinimizeGadget&~#PB_Window_TitleBar&~#PB_Window_SystemMenu) ;Ok 
      RemoveStyle(Handle, (#WS_MINIMIZEBOX))
    EndIf
    If IsFlag(Flags,#PB_Window_SizeGadget&~#PB_Window_TitleBar)     ;Ok
      RemoveStyle(Handle, (#WS_SIZEBOX))
    EndIf
    If IsFlag(Flags,#PB_Window_BorderLess)     ;Ok
      SetStyle(Handle, (#WS_BORDER))
    EndIf
    If IsFlag(Flags,#PB_Window_Invisible)      ;
      SetStyle(Handle, (#WS_VISIBLE))
    EndIf
    If IsFlag(Flags,#PB_Window_Tool)           ;Ok
      RemoveExStyle(Handle, (#WS_EX_TOOLWINDOW))
    EndIf
    If IsFlag(Flags,#PB_Window_NoActivate)     ;Ok
      SetExStyle(Handle, (#WS_EX_NOACTIVATE))
    EndIf
    
    If IsFlag(Flags,#PB_Window_Maximize)       ;
      SetWindowState(Window, #PB_Window_Normal)
    EndIf
    If IsFlag(Flags,#PB_Window_Minimize)       ;
      SetWindowState(Window, #PB_Window_Normal)
    EndIf
    
    If IsFlag(Flags,#PB_Window_NoGadgets)      ;
      UseGadgetList(Handle)
    EndIf
    If IsFlag(Flags,#PB_Window_WindowCentered) 
      RemoveProp_(Handle, "WindowCentered")
      ResizeWindow(Window, GetProp_(Handle, "CenteredX"), GetProp_(Handle, "CenteredY"), #PB_Ignore, #PB_Ignore)
      If GetProp_(Handle, "ScreenCentered") = 0
        RemoveProp_(Handle, "CenteredX")
        RemoveProp_(Handle, "CenteredY")
      EndIf
    EndIf
    If IsFlag(Flags,#PB_Window_ScreenCentered) ;
      RemoveProp_(Handle, "ScreenCentered")
      ResizeWindow(Window, GetProp_(Handle, "CenteredX"), GetProp_(Handle, "CenteredY"), #PB_Ignore, #PB_Ignore)
      If GetProp_(Handle, "WindowCentered") = 0
        RemoveProp_(Handle, "CenteredX")
        RemoveProp_(Handle, "CenteredY")
      EndIf
    EndIf
  EndProcedure
EndModule

CompilerIf #PB_Compiler_IsMainFile
  
  Global Tree
  Global Flag.q
  
  OpenWindow( 0, 11, 11, 300, 240, "Window" ,#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered) 
  ResizeWindow(0, #PB_Ignore, WindowY(0)+220, #PB_Ignore, #PB_Ignore)
  StickyWindow(0,1)
  Tree = TreeGadget(#PB_Any, 5,5,290,230, #PB_Tree_NoLines|#PB_Tree_NoButtons|#PB_Tree_CheckBoxes) 
  AddGadgetItem (Tree, -1, "#PB_Window_SystemMenu")
  AddGadgetItem (Tree, -1, "#PB_Window_MinimizeGadget")
  AddGadgetItem (Tree, -1, "#PB_Window_MaximizeGadget")
  AddGadgetItem (Tree, -1, "#PB_Window_SizeGadget")
  AddGadgetItem (Tree, -1, "#PB_Window_Invisible")
  AddGadgetItem (Tree, -1, "#PB_Window_TitleBar")
  AddGadgetItem (Tree, -1, "#PB_Window_Tool")
  AddGadgetItem (Tree, -1, "#PB_Window_BorderLess")
  AddGadgetItem (Tree, -1, "#PB_Window_ScreenCentered")
  AddGadgetItem (Tree, -1, "#PB_Window_WindowCentered")
  AddGadgetItem (Tree, -1, "#PB_Window_Maximize")
  AddGadgetItem (Tree, -1, "#PB_Window_Minimize")
  AddGadgetItem (Tree, -1, "#PB_Window_NoGadgets")
  AddGadgetItem (Tree, -1, "#PB_Window_NoActivate")
  
  
  OpenWindow( 1, 221, 211, 300, 200, "test to set window centered", #PB_Window_SystemMenu) 
  OpenWindow( 2, 221, 11, 200, 100, "test set flag", #PB_Window_TitleBar, WindowID(1)) 
  
  ButtonGadget(#PB_Any ,5,5,WindowWidth(2)-10,WindowHeight(2)-10,"NoFlag")
  
  Flag::RemoveWindow(2, #PB_Window_TitleBar)
  
  Flag.q = Flag::GetWindow(2)
   
  If Flag::IsFlag(Flag,#PB_Window_SystemMenu) 
    SetGadgetItemState(Tree,0 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_MinimizeGadget) 
    SetGadgetItemState(Tree,1 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_MaximizeGadget) 
    SetGadgetItemState(Tree,2 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_SizeGadget) 
    SetGadgetItemState(Tree,3 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_Invisible) 
    SetGadgetItemState(Tree,4 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_TitleBar) 
    SetGadgetItemState(Tree,5 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_Tool) 
    SetGadgetItemState(Tree,6 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_BorderLess) 
    SetGadgetItemState(Tree,7 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_ScreenCentered) 
    SetGadgetItemState(Tree,8 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_WindowCentered) 
    SetGadgetItemState(Tree,9 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_Maximize) 
    SetGadgetItemState(Tree,10 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_Minimize) 
    SetGadgetItemState(Tree,11 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_NoGadgets) 
    SetGadgetItemState(Tree,12 ,#PB_Tree_Checked)
  EndIf
  If Flag::IsFlag(Flag,#PB_Window_NoActivate) 
    SetGadgetItemState(Tree,13 ,#PB_Tree_Checked)
  EndIf
  
  
  Repeat 
    Select WaitWindowEvent()
      Case #PB_Event_Gadget
        Select EventGadget()
          Case Tree
            Select EventType()
              Case #PB_EventType_Change
                If Not GetGadgetItemState(Tree, GetGadgetState(Tree)) & #PB_Tree_Checked
                  Select GetGadgetItemText(Tree, GetGadgetState(Tree))
                    Case "#PB_Window_SystemMenu" : Flag::RemoveWindow(2, #PB_Window_SystemMenu)
                    Case "#PB_Window_MinimizeGadget" : Flag::RemoveWindow(2, #PB_Window_MinimizeGadget)
                    Case "#PB_Window_MaximizeGadget" : Flag::RemoveWindow(2, #PB_Window_MaximizeGadget)
                    Case "#PB_Window_SizeGadget" : Flag::RemoveWindow(2, #PB_Window_SizeGadget)
                    Case "#PB_Window_Invisible" : Flag::RemoveWindow(2, #PB_Window_Invisible)
                    Case "#PB_Window_TitleBar" : Flag::RemoveWindow(2, #PB_Window_TitleBar)
                    Case "#PB_Window_Tool" : Flag::RemoveWindow(2, #PB_Window_Tool)
                    Case "#PB_Window_BorderLess" : Flag::RemoveWindow(2, #PB_Window_BorderLess)
                    Case "#PB_Window_ScreenCentered" : Flag::RemoveWindow(2, #PB_Window_ScreenCentered)
                    Case "#PB_Window_WindowCentered" : Flag::RemoveWindow(2, #PB_Window_WindowCentered)
                    Case "#PB_Window_Maximize" : Flag::RemoveWindow(2, #PB_Window_Maximize)
                    Case "#PB_Window_Minimize" : Flag::RemoveWindow(2, #PB_Window_Minimize)
                    Case "#PB_Window_NoGadgets" : Flag::RemoveWindow(2, #PB_Window_NoGadgets)
                    Case "#PB_Window_NoActivate" : Flag::RemoveWindow(2, #PB_Window_NoActivate)
                  EndSelect
                EndIf
                
                If GetGadgetItemState(Tree, GetGadgetState(Tree)) & #PB_Tree_Checked
                  Select GetGadgetItemText(Tree, GetGadgetState(Tree))
                    Case "#PB_Window_SystemMenu" : Flag::SetWindow(2, #PB_Window_SystemMenu)
                    Case "#PB_Window_MinimizeGadget" : Flag::SetWindow(2, #PB_Window_MinimizeGadget)
                    Case "#PB_Window_MaximizeGadget" : Flag::SetWindow(2, #PB_Window_MaximizeGadget)
                    Case "#PB_Window_SizeGadget" : Flag::SetWindow(2, #PB_Window_SizeGadget)
                    Case "#PB_Window_Invisible" : Flag::SetWindow(2, #PB_Window_Invisible)
                    Case "#PB_Window_TitleBar" : Flag::SetWindow(2, #PB_Window_TitleBar)
                    Case "#PB_Window_Tool" : Flag::SetWindow(2, #PB_Window_Tool)
                    Case "#PB_Window_BorderLess" : Flag::SetWindow(2, #PB_Window_BorderLess)
                    Case "#PB_Window_ScreenCentered" : Flag::SetWindow(2, #PB_Window_ScreenCentered)
                    Case "#PB_Window_WindowCentered" : Flag::SetWindow(2, #PB_Window_WindowCentered)
                    Case "#PB_Window_Maximize" : Flag::SetWindow(2, #PB_Window_Maximize)
                    Case "#PB_Window_Minimize" : Flag::SetWindow(2, #PB_Window_Minimize)
                    Case "#PB_Window_NoGadgets" : Flag::SetWindow(2, #PB_Window_NoGadgets)
                    Case "#PB_Window_NoActivate" : Flag::SetWindow(2, #PB_Window_NoActivate)
                  EndSelect
                EndIf  
                ; ; ; ;                 
                ; ;                               Flag::RemoveWindow(2, Flag::GetWindow(2))
                ; ;                               ; Debug ""
                ; ;                               Flag::GetWindow(2)
                ; ;                               For i=0 To CountGadgetItems(Tree)-1
                ; ;                                 If GetGadgetItemState(Tree, i) & #PB_Tree_Checked  
                ; ;                                   Select GetGadgetItemText(Tree, i)
                ; ;                                     Case "#PB_Window_SystemMenu" : Flag::SetWindow(2, #PB_Window_SystemMenu)
                ; ;                                     Case "#PB_Window_MinimizeGadget" : Flag::SetWindow(2, #PB_Window_MinimizeGadget)
                ; ;                                     Case "#PB_Window_MaximizeGadget" : Flag::SetWindow(2, #PB_Window_MaximizeGadget)
                ; ;                                     Case "#PB_Window_SizeGadget" : Flag::SetWindow(2, #PB_Window_SizeGadget)
                ; ;                                     Case "#PB_Window_Invisible" : Flag::SetWindow(2, #PB_Window_Invisible)
                ; ;                                     Case "#PB_Window_TitleBar" : Flag::SetWindow(2, #PB_Window_TitleBar)
                ; ;                                     Case "#PB_Window_Tool" : Flag::SetWindow(2, #PB_Window_Tool)
                ; ;                                     Case "#PB_Window_BorderLess" : Flag::SetWindow(2, #PB_Window_BorderLess)
                ; ;                                     Case "#PB_Window_ScreenCentered" : Flag::SetWindow(2, #PB_Window_ScreenCentered)
                ; ;                                     Case "#PB_Window_WindowCentered" : Flag::SetWindow(2, #PB_Window_WindowCentered)
                ; ;                                     Case "#PB_Window_Maximize" : Flag::SetWindow(2, #PB_Window_Maximize)
                ; ;                                     Case "#PB_Window_Minimize" : Flag::SetWindow(2, #PB_Window_Minimize)
                ; ;                                     Case "#PB_Window_NoGadgets" : Flag::SetWindow(2, #PB_Window_NoGadgets)
                ; ;                                     Case "#PB_Window_NoActivate" : Flag::SetWindow(2, #PB_Window_NoActivate)
                ; ;                                   EndSelect
                ; ;                                 EndIf
                ; ;                               Next
            EndSelect
        EndSelect
        
      Case #PB_Event_CloseWindow
        End
    EndSelect
  ForEver 
CompilerEndIf