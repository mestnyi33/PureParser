; http://www.purebasic.fr/english/viewtopic.php?f=13&t=61700&p=462648#p462648
; Устанавливает удаляет и получает флаги PB окон и гаджетов

DeclareModule Flag
  EnableExplicit
  
  #PB_GadgetType_Window = -1
  #PB_GadgetType_Menu = -2
  #PB_GadgetType_Toolbar = -3
  #PB_GadgetType_ImageButton = #PB_GadgetType_Canvas+1
  
  #PB_Window_NoIcon= 1<<32
  #PB_Window_Drag = 1<<33
  #PB_Window_BorderFlat = 1<<34
  #PB_Window_NoTaskBar = 1<<35
  #PB_Window_Transparentes = 1<<35
  
  Macro IsFlag(GetFlag, IsFlag)
    Bool((GetFlag & IsFlag) = IsFlag)
  EndMacro
  
  Declare.q GetWindow(Window)
  Declare RemoveWindow(Window, Flags.q)
  Declare SetWindow(Window, Flags.q, Value=0)
  
  Declare.q GetGadget(Gadget)
  Declare RemoveGadget(Gadget, Flags.q)
  Declare SetGadget(Gadget, Flags.q, Value=0)
  
  Declare GetStyle(Handle)
  Declare SetStyle(Handle, Style)
  Declare GetExStyle(Handle)
  
  Declare SetExStyle(Handle, ExStyle)
  Declare RemoveStyle(Handle, Style)
  Declare RemoveExStyle(Handle, ExStyle)
EndDeclareModule

Module Flag
  Global GetStyle
  Global GetExStyle
  Global GetText$
  
  ;-
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
  
  ;-
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
        
        If (ExStyle & #WS_EX_CLIENTEDGE|#WS_EX_STATICEDGE|#WS_EX_DLGMODALFRAME);|#WS_EX_TOOLWINDOW|#WS_EX_NOACTIVATE)
          SetWindowPos_(Handle, 0, 0, 0, 0, 0,  #SWP_FRAMECHANGED|#SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER)
          InvalidateRect_(Handle,0,#True)
        EndIf
    CompilerEndSelect         
  EndProcedure   
  
  Procedure RemoveExStyle(Handle,ExStyle)
    CompilerSelect #PB_Compiler_OS  
      CompilerCase #PB_OS_Windows
        SetWindowLongPtr_(Handle,#GWL_EXSTYLE,GetWindowLongPtr_(Handle,#GWL_EXSTYLE) &~ ExStyle)
        
        If (ExStyle & #WS_EX_CLIENTEDGE);|#WS_EX_TOOLWINDOW|#WS_EX_NOACTIVATE)
          SetWindowPos_(Handle, 0, 0, 0, 0, 0,  #SWP_FRAMECHANGED|#SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER)
          InvalidateRect_(Handle,0,#True)
        EndIf
    CompilerEndSelect         
  EndProcedure   
  
  CompilerSelect #PB_Compiler_OS  
    CompilerCase #PB_OS_Windows
      #CBS_UPPERCASE = $2000;
      #CBS_LOWERCASE = $4000;
                                           ;-
      Procedure.q GetWindow( Window )
        Protected Flag.q
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
      
      ;-
      Procedure.q GetGadget( Gadget )
        Protected Flag.q
        Protected Handle = GadgetID(Gadget)
        Protected Flags = GetStyle(Handle)
        
        Select GadgetType(Gadget)
          Case #PB_GadgetType_Text
            If IsFlag(GetExStyle(Handle),#WS_EX_CLIENTEDGE) ;Ok
              Flag|#PB_Text_Border
            EndIf
            If IsFlag(Flags,#ES_CENTER)   ;Ok
              Flag|#PB_Text_Center
            EndIf
            If IsFlag(Flags,#ES_RIGHT)   ;Ok
              Flag|#PB_Text_Right
            EndIf
            
          Case #PB_GadgetType_String
            If Not IsFlag(GetExStyle(Handle),#WS_EX_CLIENTEDGE) ;Ok
              Flag|#PB_String_BorderLess
            EndIf
            If IsFlag(Flags,#ES_PASSWORD)   ;Ok
              Flag|#PB_String_Password
            EndIf
            If IsFlag(Flags,#ES_READONLY)   ;Ok
              Flag|#PB_String_ReadOnly
            EndIf
            If IsFlag(Flags,#ES_NUMBER)    ;Ok
              Flag|#PB_String_Numeric
            EndIf
            If IsFlag(Flags,#ES_LOWERCASE)  ;Ok
              Flag|#PB_String_LowerCase
            EndIf
            If IsFlag(Flags,#ES_UPPERCASE)  ;Ok 
              Flag|#PB_String_UpperCase
            EndIf
            
          Case #PB_GadgetType_Button
            If IsFlag(Flags,#BS_PUSHLIKE|#BS_CHECKBOX)     ;Ok
              Flag|#PB_Button_Toggle
            EndIf
            If IsFlag(Flags,#BS_LEFT)       ;Ok
              Flag|#PB_Button_Left
            EndIf
            If IsFlag(Flags,#BS_RIGHT)      ;Ok
              Flag|#PB_Button_Right
            EndIf
            If IsFlag(Flags,#BS_DEFPUSHBUTTON)    ;Ok
              Flag|#PB_Button_Default
            EndIf
            If IsFlag(Flags,#BS_MULTILINE)  ;Ok
              Flag|#PB_Button_MultiLine
            EndIf
            
          Case #PB_GadgetType_CheckBox
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_CheckBox_Right
            EndIf
            If IsFlag(Flags, #BS_CENTER )
              Flag|#PB_CheckBox_Center
            EndIf
            If IsFlag(Flags, #BS_AUTO3STATE )
              Flag|#PB_CheckBox_ThreeState
            EndIf
            
          Case #PB_GadgetType_Option
            
          Case #PB_GadgetType_ListView
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListView_MultiSelect
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListView_ClickSelect
            EndIf
            
          Case #PB_GadgetType_Frame
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Frame_Single
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Frame_Double
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Frame_Flat
            EndIf
            
          Case #PB_GadgetType_ComboBox
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ComboBox_Editable
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ComboBox_LowerCase
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ComboBox_UpperCase
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ComboBox_Image
            EndIf
            
          Case #PB_GadgetType_Image
            If IsFlag(GetExStyle(Handle), #WS_EX_CLIENTEDGE )
              Flag|#PB_Image_Border
            EndIf
            If IsFlag(GetExStyle(Handle), #WS_EX_DLGMODALFRAME )
              Flag|#PB_Image_Raised
            EndIf
            
          Case #PB_GadgetType_HyperLink
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_HyperLink_Underline
            EndIf
            
          Case #PB_GadgetType_Container
            If Not IsFlag(Flags, #WS_BORDER ) And 
               Not IsFlag(GetExStyle(Handle), #WS_EX_DLGMODALFRAME ) And 
               Not IsFlag(GetExStyle(Handle), #WS_EX_STATICEDGE ) And 
               Not IsFlag(GetExStyle(Handle), #WS_EX_CLIENTEDGE ) 
              Flag|#PB_Container_BorderLess
            EndIf
            If IsFlag(Flags, #WS_BORDER )
              Flag|#PB_Container_Flat
            EndIf
            If IsFlag(GetExStyle(Handle), #WS_EX_DLGMODALFRAME )
              Flag|#PB_Container_Raised
            EndIf
            If IsFlag(GetExStyle(Handle), #WS_EX_STATICEDGE )
              Flag|#PB_Container_Single
            EndIf
            If IsFlag(GetExStyle(Handle), #WS_EX_CLIENTEDGE )
              Flag|#PB_Container_Double
            EndIf
            
          Case #PB_GadgetType_ListIcon
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListIcon_CheckBoxes
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListIcon_ThreeState
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListIcon_MultiSelect
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListIcon_GridLines
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListIcon_FullRowSelect
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListIcon_HeaderDragDrop
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ListIcon_AlwaysShowSelection
            EndIf
            
          Case #PB_GadgetType_IPAddress
            
          Case #PB_GadgetType_ProgressBar
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ProgressBar_Smooth
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ProgressBar_Vertical
            EndIf
            
          Case #PB_GadgetType_ScrollBar
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ScrollBar_Vertical
            EndIf
            
          Case #PB_GadgetType_ScrollArea
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ScrollArea_Flat
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ScrollArea_Raised
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ScrollArea_Single
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ScrollArea_BorderLess
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_ScrollArea_Center
            EndIf
            
          Case #PB_GadgetType_TrackBar
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_TrackBar_Ticks
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_TrackBar_Vertical
            EndIf
            
          Case #PB_GadgetType_Web
            
          Case #PB_GadgetType_ButtonImage
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Button_Toggle
            EndIf
            
          Case #PB_GadgetType_Calendar
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Calendar_Borderless
            EndIf
            
          Case #PB_GadgetType_Date
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Date_UpDown
            EndIf
            
          Case #PB_GadgetType_Editor
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Editor_ReadOnly
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Editor_WordWrap
            EndIf
            
          Case #PB_GadgetType_ExplorerList
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_BorderLess
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_AlwaysShowSelection
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_MultiSelect
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_GridLines
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_HeaderDragDrop
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_FullRowSelect
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_NoFiles
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_NoFolders
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_NoParentFolder
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_NoDirectoryChange
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_NoDriveRequester
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_NoSort
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_NoMyDocuments
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_AutoSort
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Explorer_HiddenFiles
            EndIf
            
          Case #PB_GadgetType_ExplorerTree
            
          Case #PB_GadgetType_ExplorerCombo
            
          Case #PB_GadgetType_Spin
            
          Case #PB_GadgetType_Tree
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Tree_AlwaysShowSelection
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Tree_NoLines
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Tree_NoButtons
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Tree_CheckBoxes
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Tree_ThreeState
            EndIf
            
          Case #PB_GadgetType_Panel
            
          Case #PB_GadgetType_Splitter
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Splitter_Vertical
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Splitter_Separator
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Splitter_FirstFixed
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Splitter_SecondFixed
            EndIf
            
          Case #PB_GadgetType_Scintilla
            
          Case #PB_GadgetType_Shortcut
            
          Case #PB_GadgetType_Canvas
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Canvas_Border
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Canvas_Container
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Canvas_ClipMouse
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Canvas_Keyboard
            EndIf
            If IsFlag(Flags, #BS_RIGHT )
              Flag|#PB_Canvas_DrawFocus
            EndIf
        EndSelect
        
        ProcedureReturn Flag
      EndProcedure
      
      Procedure SetGadget( Gadget, Flags.q, Value=0 )
        Protected Handle = GadgetID(Gadget)
        
        Select GadgetType(Gadget)
          Case #PB_GadgetType_Text
            If IsFlag(Flags,#PB_Text_Border)            ;Ok 
              SetExStyle(Handle, #WS_EX_CLIENTEDGE)
            EndIf
            If IsFlag(Flags,#PB_Text_Center)            ;Ok
              SetStyle(Handle, #ES_CENTER)
            EndIf
            If IsFlag(Flags,#PB_Text_Right)             ;Ok
              SetStyle(Handle, #ES_RIGHT)           
            EndIf
            
          Case #PB_GadgetType_String
            If IsFlag(Flags,#PB_String_BorderLess)      ;Ok
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            If IsFlag(Flags,#PB_String_Password)        ;Ok
              SetStyle(Handle, (#ES_PASSWORD))
              SendMessage_(Handle, #EM_SETPASSWORDCHAR, 9679,0)
            EndIf
            If IsFlag(Flags,#PB_String_ReadOnly)        ;Ok
              SetStyle(Handle, (#ES_READONLY))
              SendMessage_(Handle, #EM_SETREADONLY, 1,0)
            EndIf
            If IsFlag(Flags,#PB_String_Numeric)         ;Ok
              SetStyle(Handle, (#ES_NUMBER))
            EndIf
            If IsFlag(Flags,#PB_String_LowerCase)       ;?
              GetText$ = GetGadgetText(Gadget)
              SetStyle(Handle, (#ES_LOWERCASE))
              SetGadgetText(Gadget, LCase(GetText$))
            EndIf
            If IsFlag(Flags,#PB_String_UpperCase)       ;? 
              GetText$ = Space(GetWindowTextLength_(Handle) + 1)
              GetWindowText_(Handle, GetText$, Len(GetText$))
              SetStyle(Handle, (#ES_UPPERCASE))
              SetWindowText_(Handle, UCase(GetText$))
            EndIf
            
          Case #PB_GadgetType_Button
            If IsFlag(Flags,#PB_Button_Toggle)          ;Ok
              SetStyle(Handle, (#BS_PUSHLIKE|#BS_CHECKBOX))
              SendMessage_(Handle, #BM_SETCHECK, 1, 0) ; Чтобы видет эфект сразу
            EndIf
            If IsFlag(Flags,#PB_Button_Left)            ;Ok
              SetStyle(Handle, (#BS_LEFT))
            EndIf
            If IsFlag(Flags,#PB_Button_Right)           ;Ok
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Button_Default)         ;Ok
              SetStyle(Handle, (#BS_DEFPUSHBUTTON))
            EndIf
            If IsFlag(Flags,#PB_Button_MultiLine)       ;Ok
              SetStyle(Handle, (#BS_MULTILINE))
            EndIf
            
          Case #PB_GadgetType_CheckBox
            If IsFlag(Flags,#PB_CheckBox_Right)         ;Ok
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_CheckBox_Center)        ;Ok
              SetStyle(Handle, (#BS_CENTER))
            EndIf
            If IsFlag(Flags,#PB_CheckBox_ThreeState)    ;Ok
              RemoveStyle(Handle, (#BS_GROUPBOX))
              SetStyle(Handle, (#BS_AUTO3STATE))
              SendMessage_(Handle, #BM_SETCHECK, #BST_INDETERMINATE, 0)
            EndIf
            
          Case #PB_GadgetType_Option
            
          Case #PB_GadgetType_ListView
            If IsFlag(Flags,#PB_ListView_MultiSelect)
              SetExStyle(Handle, (#LVS_EX_MULTIWORKAREAS))
            EndIf
            If IsFlag(Flags,#PB_ListView_ClickSelect)
              SetExStyle(Handle, (#LVS_EX_ONECLICKACTIVATE))
            EndIf
            
          Case #PB_GadgetType_Frame
            If IsFlag(Flags,#PB_Frame_Single)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Frame_Double)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Frame_Flat)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ComboBox
            If IsFlag(Flags,#PB_ComboBox_Editable)
              SetStyle(Handle, (#CBS_SIMPLE|#CBS_DROPDOWN))
            EndIf
            If IsFlag(Flags,#PB_ComboBox_LowerCase)
              SetStyle(Handle, (#CBS_LOWERCASE))
            EndIf
            If IsFlag(Flags,#PB_ComboBox_UpperCase)
              SetStyle(Handle, (#CBS_UPPERCASE))
            EndIf
            If IsFlag(Flags,#PB_ComboBox_Image)
              SetStyle(Handle, (#BS_BITMAP))
            EndIf
            
          Case #PB_GadgetType_Image
            If IsFlag(Flags,#PB_Image_Border)           ;Ok
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            If IsFlag(Flags,#PB_Image_Raised)           ;Ok
              SetExStyle(Handle, (#WS_EX_DLGMODALFRAME))
            EndIf
            
          Case #PB_GadgetType_HyperLink
            If IsFlag(Flags,#PB_HyperLink_Underline)
              SetStyle(Handle, (#BS_FLAT))
            EndIf
            
          Case #PB_GadgetType_Container
            If IsFlag(Flags,#PB_Container_BorderLess)   ;Ok
              GetStyle = GetStyle(Handle)
              GetExStyle = GetExStyle(Handle)
              
              RemoveStyle(Handle, (#WS_BORDER))
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
              RemoveExStyle(Handle, (#WS_EX_STATICEDGE))
              RemoveExStyle(Handle, (#WS_EX_DLGMODALFRAME))
            EndIf
            If IsFlag(Flags,#PB_Container_Flat)         ;Ok
              SetStyle(Handle, (#WS_BORDER))
            EndIf
            If IsFlag(Flags,#PB_Container_Raised)       ;Ok
              SetExStyle(Handle, (#WS_EX_DLGMODALFRAME))
            EndIf
            If IsFlag(Flags,#PB_Container_Single)       ;Ok
              SetExStyle(Handle, (#WS_EX_STATICEDGE))
            EndIf
            If IsFlag(Flags,#PB_Container_Double)       ;Ok
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            
          Case #PB_GadgetType_ListIcon
            If IsFlag(Flags,#PB_ListIcon_CheckBoxes)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_ThreeState)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_MultiSelect)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_GridLines)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_FullRowSelect)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_HeaderDragDrop)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_AlwaysShowSelection)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_IPAddress
            
          Case #PB_GadgetType_ProgressBar
            If IsFlag(Flags,#PB_ProgressBar_Smooth)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ProgressBar_Vertical)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ScrollBar
            If IsFlag(Flags,#PB_ScrollBar_Vertical)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ScrollArea
            If IsFlag(Flags,#PB_ScrollArea_Flat)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Raised)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Single)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_BorderLess)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Center)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_TrackBar
            If IsFlag(Flags,#PB_TrackBar_Ticks)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_TrackBar_Vertical)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Web
            
          Case #PB_GadgetType_ButtonImage
            If IsFlag(Flags,#PB_Button_Toggle)
              SetStyle(Handle, (#BS_PUSHLIKE|#BS_CHECKBOX))
              SendMessage_(Handle, #BM_SETCHECK, 1, 0) ; Чтобы видет эфект сразу
            EndIf
            
          Case #PB_GadgetType_Calendar
            If IsFlag(Flags,#PB_Calendar_Borderless)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Date
            If IsFlag(Flags,#PB_Date_UpDown)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Editor
            If IsFlag(Flags,#PB_Editor_ReadOnly)
              SetStyle(Handle, (#ES_READONLY))
              SendMessage_(Handle, #EM_SETREADONLY, 1,0)
            EndIf
            If IsFlag(Flags,#PB_Editor_WordWrap)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ExplorerList
            If IsFlag(Flags,#PB_Explorer_BorderLess)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_AlwaysShowSelection)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_MultiSelect)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_GridLines)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_HeaderDragDrop)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_FullRowSelect)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoFiles)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoFolders)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoParentFolder)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoDirectoryChange)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoDriveRequester)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoSort)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoMyDocuments)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_AutoSort)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_HiddenFiles)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ExplorerTree
            
          Case #PB_GadgetType_ExplorerCombo
            
          Case #PB_GadgetType_Spin
            
          Case #PB_GadgetType_Tree
            If IsFlag(Flags,#PB_Tree_AlwaysShowSelection)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_NoLines)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_NoButtons)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_CheckBoxes)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_ThreeState)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Panel
            
          Case #PB_GadgetType_Splitter
            If IsFlag(Flags,#PB_Splitter_Vertical)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Splitter_Separator)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Splitter_FirstFixed)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Splitter_SecondFixed)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Scintilla
            
          Case #PB_GadgetType_Shortcut
            
          Case #PB_GadgetType_Canvas
            If IsFlag(Flags,#PB_Canvas_Border)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_Container)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_ClipMouse)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_Keyboard)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_DrawFocus)
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            
            
        EndSelect
      EndProcedure
      
      Procedure RemoveGadget( Gadget, Flags.q )
        Protected Text$, Handle = GadgetID(Gadget)
        
        Select GadgetType(Gadget)
          Case #PB_GadgetType_Text
            If IsFlag(Flags,#PB_Text_Border)          ;Ok 
              RemoveExStyle(Handle, #WS_EX_CLIENTEDGE)
            EndIf
            If IsFlag(Flags,#PB_Text_Center)          ;Ok
              RemoveStyle(Handle, #ES_CENTER)
            EndIf
            If IsFlag(Flags,#PB_Text_Right)           ;Ok
              RemoveStyle(Handle, #ES_RIGHT)         
            EndIf
            
          Case #PB_GadgetType_String
            If IsFlag(Flags,#PB_String_BorderLess)    ;Ok
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            If IsFlag(Flags,#PB_String_Numeric)       ;Ok
              RemoveStyle(Handle, (#ES_NUMBER))
            EndIf
            If IsFlag(Flags,#PB_String_Password)      ;Ok
              RemoveStyle(Handle, (#ES_PASSWORD))
              SendMessage_(Handle, #EM_SETPASSWORDCHAR, 0,0)
            EndIf
            If IsFlag(Flags,#PB_String_ReadOnly)      ;Ok
              RemoveStyle(Handle, (#ES_READONLY))
              SendMessage_(Handle, #EM_SETREADONLY, 0,0)
            EndIf
            If IsFlag(Flags,#PB_String_LowerCase)     ;Ok
              RemoveStyle(Handle, (#ES_LOWERCASE))
              
              Text$ = Space(GetWindowTextLength_(Handle) + 1)
              GetWindowText_(Handle, Text$, Len(Text$))
              If Text$ = LCase(GetText$)
                SetWindowText_(Handle, GetText$)
              EndIf
            EndIf
            If IsFlag(Flags,#PB_String_UpperCase)     ;Ok
              RemoveStyle(Handle, (#ES_UPPERCASE))
              
              Text$ = Space(GetWindowTextLength_(Handle) + 1)
              GetWindowText_(Handle, Text$, Len(Text$))
              If Text$ = UCase(GetText$)
                SetWindowText_(Handle, GetText$)
              EndIf
            EndIf
            
          Case #PB_GadgetType_Button
            If IsFlag(Flags,#PB_Button_Toggle)        ;Ok 
              If SendMessage_(Handle, #BM_GETCHECK, 0, 0)
                SendMessage_(Handle, #BM_SETCHECK, 0, 0)
              EndIf
              RemoveStyle(Handle, (#BS_PUSHLIKE|#BS_CHECKBOX))
            EndIf
            If IsFlag(Flags,#PB_Button_Left)          ;Ok
              RemoveStyle(Handle, (#BS_LEFT))
            EndIf
            If IsFlag(Flags,#PB_Button_Right)         ;Ok
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Button_Default)       ;Ok 
              RemoveStyle(Handle, (#BS_DEFPUSHBUTTON))
            EndIf
            If IsFlag(Flags,#PB_Button_MultiLine)     ;Ok
              RemoveStyle(Handle, (#BS_MULTILINE))
            EndIf
            
          Case #PB_GadgetType_CheckBox
            If IsFlag(Flags,#PB_CheckBox_Right)       ;Ok
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_CheckBox_Center)      ;Ok
              RemoveStyle(Handle, (#BS_CENTER))
            EndIf
            If IsFlag(Flags,#PB_CheckBox_ThreeState)  ;Ok
              SendMessage_(Handle, #BM_SETCHECK, 0, 0)
              RemoveStyle(Handle, (#BS_AUTO3STATE))
              SetStyle(Handle, (#BS_AUTOCHECKBOX))
            EndIf
            
          Case #PB_GadgetType_Option
            
          Case #PB_GadgetType_ListView
            If IsFlag(Flags,#PB_ListView_MultiSelect)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListView_ClickSelect)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Frame
            If IsFlag(Flags,#PB_Frame_Single)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Frame_Double)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Frame_Flat)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ComboBox
            If IsFlag(Flags,#PB_ComboBox_Editable)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ComboBox_LowerCase)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ComboBox_UpperCase)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ComboBox_Image)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Image
            If IsFlag(Flags,#PB_Image_Border)           ;Ok
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            If IsFlag(Flags,#PB_Image_Raised)           ;Ok
              RemoveExStyle(Handle, (#WS_EX_DLGMODALFRAME))
            EndIf
            
          Case #PB_GadgetType_HyperLink
            If IsFlag(Flags,#PB_HyperLink_Underline)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Container
            If IsFlag(Flags,#PB_Container_BorderLess)    ;?
              SetStyle(Handle, GetStyle)
              SetExStyle(Handle, GetExStyle)
            EndIf
            If IsFlag(Flags,#PB_Container_Flat)          ;Ok
              RemoveStyle(Handle, (#WS_BORDER))
            EndIf
            If IsFlag(Flags,#PB_Container_Raised)        ;Ok
              RemoveExStyle(Handle, (#WS_EX_DLGMODALFRAME))
            EndIf
            If IsFlag(Flags,#PB_Container_Single)        ;Ok
              RemoveExStyle(Handle, (#WS_EX_STATICEDGE))
            EndIf
            If IsFlag(Flags,#PB_Container_Double)        ;Ok
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            
          Case #PB_GadgetType_ListIcon
            If IsFlag(Flags,#PB_ListIcon_CheckBoxes)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_ThreeState)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_MultiSelect)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_GridLines)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_FullRowSelect)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_HeaderDragDrop)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_AlwaysShowSelection)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_IPAddress
            
          Case #PB_GadgetType_ProgressBar
            If IsFlag(Flags,#PB_ProgressBar_Smooth)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ProgressBar_Vertical)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ScrollBar
            If IsFlag(Flags,#PB_ScrollBar_Vertical)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ScrollArea
            If IsFlag(Flags,#PB_ScrollArea_Flat)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Raised)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Single)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_BorderLess)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Center)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_TrackBar
            If IsFlag(Flags,#PB_TrackBar_Ticks)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_TrackBar_Vertical)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Web
            
          Case #PB_GadgetType_ButtonImage
            If IsFlag(Flags,#PB_Button_Toggle)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Calendar
            If IsFlag(Flags,#PB_Calendar_Borderless)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Date
            If IsFlag(Flags,#PB_Date_UpDown)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Editor
            If IsFlag(Flags,#PB_Editor_ReadOnly)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Editor_WordWrap)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ExplorerList
            If IsFlag(Flags,#PB_Explorer_BorderLess)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_AlwaysShowSelection)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_MultiSelect)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_GridLines)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_HeaderDragDrop)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_FullRowSelect)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoFiles)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoFolders)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoParentFolder)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoDirectoryChange)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoDriveRequester)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoSort)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_NoMyDocuments)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_AutoSort)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Explorer_HiddenFiles)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_ExplorerTree
            
          Case #PB_GadgetType_ExplorerCombo
            
          Case #PB_GadgetType_Spin
            
          Case #PB_GadgetType_Tree
            If IsFlag(Flags,#PB_Tree_AlwaysShowSelection)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_NoLines)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_NoButtons)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_CheckBoxes)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Tree_ThreeState)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Panel
            
          Case #PB_GadgetType_Splitter
            If IsFlag(Flags,#PB_Splitter_Vertical)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Splitter_Separator)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Splitter_FirstFixed)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Splitter_SecondFixed)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_Scintilla
            
          Case #PB_GadgetType_Shortcut
            
          Case #PB_GadgetType_Canvas
            If IsFlag(Flags,#PB_Canvas_Border)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_Container)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_ClipMouse)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_Keyboard)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Canvas_DrawFocus)
              RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
        EndSelect
      EndProcedure
    CompilerDefault
      ;-
      Procedure.q GetWindow( Window )
        Protected Flag.q
        Protected Handle = WindowID(Window)
        Protected Flags = GetStyle(Handle)
        
        ;; Debug Bin(Flag)
        ProcedureReturn Flag
      EndProcedure
      
      Procedure SetWindow( Window, Flags.q, Value=0 )
        Protected Handle = WindowID(Window)
        
      EndProcedure
      
      Procedure RemoveWindow( Window, Flags.q )
        Protected Handle = WindowID(Window)
        
      EndProcedure
      
      ;-
      Procedure.q GetGadget( Gadget )
        Protected Flag.q
        Protected Handle = GadgetID(Gadget)
        Protected Flags = GetStyle(Handle)
        
        Select GadgetType(Gadget)
          Case #PB_GadgetType_String
          Case #PB_GadgetType_Button
        EndSelect
        
        ProcedureReturn Flag
      EndProcedure
      
      Procedure SetGadget( Gadget, Flags.q, Value=0 )
        Protected Handle = GadgetID(Gadget)
        
        Select GadgetType(Gadget)
          Case #PB_GadgetType_String
          Case #PB_GadgetType_Button
        EndSelect
      EndProcedure
      
      Procedure RemoveGadget( Gadget, Flags.q )
        Protected Handle = GadgetID(Gadget)
        
        Select GadgetType(Gadget)
          Case #PB_GadgetType_String
          Case #PB_GadgetType_Button
        EndSelect
      EndProcedure
  CompilerEndSelect
  
EndModule

;-
CompilerIf #PB_Compiler_IsMainFile
  Macro GetWindowFlag(Window) : Flag::GetWindow(Window) : EndMacro
  Macro SetWindowFlag(Window, Flag) : Flag::SetWindow(Window, Flag) : EndMacro
  Macro RemoveWindowFlag(Window, Flag) : Flag::RemoveWindow(Window, Flag) : EndMacro
  
  Macro GetGadgetFlag(Gadget) : Flag::GetGadget(Gadget) : EndMacro
  Macro SetGadgetFlag(Gadget, Flag) : Flag::SetGadget(Gadget, Flag) : EndMacro
  Macro RemoveGadgetFlag(Gadget, Flag) : Flag::RemoveGadget(Gadget, Flag) : EndMacro
  
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
  
  ; Flag::RemoveWindow(2, #PB_Window_TitleBar)
  
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