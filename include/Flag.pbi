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
    CompilerSelect #PB_Compiler_OS  
      CompilerCase #PB_OS_Windows
        SetWindowLongPtr_(Handle, #GWL_STYLE, GetWindowLong_(Handle, #GWL_STYLE)|Style)
        
        If (Style & #WS_SIZEBOX | #WS_BORDER | #WS_VISIBLE)
          SetWindowPos_(Handle, 0,0,0,0,0, #SWP_FRAMECHANGED|#SWP_DRAWFRAME|#SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER)
          InvalidateRect_(Handle,0,#True)
        EndIf
        
      CompilerCase #PB_OS_Linux
;         If (Style & #WINDOW_TITLEBAR)
;           gtk_window_set_decorated_(Handle, (Style & #WINDOW_TITLEBAR))
;         EndIf
;         If (Style & #WINDOW_RESIZABLE)
;           gtk_window_set_resizable_(Handle, (Style & #WINDOW_RESIZABLE))
;         EndIf
;         If (Style & #WINDOW_TOOL)
;           gtk_window_set_type_hint_(Handle, #GDK_WINDOW_TYPE_HINT_UTILITY)
;         EndIf
        
    CompilerEndSelect
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
        
        If (ExStyle & #WS_EX_CLIENTEDGE|#WS_EX_STATICEDGE|#WS_EX_DLGMODALFRAME);|#WS_EX_TOOLWINDOW|#WS_EX_NOACTIVATE)
          SetWindowPos_(Handle, 0, 0, 0, 0, 0,  #SWP_FRAMECHANGED|#SWP_NOMOVE|#SWP_NOSIZE|#SWP_NOZORDER)
          InvalidateRect_(Handle,0,#True)
        EndIf
    CompilerEndSelect         
  EndProcedure   
  
  CompilerSelect #PB_Compiler_OS  
    CompilerCase #PB_OS_Windows
      #PBM_GETPOS = $0408
      #CBS_UPPERCASE = $2000   ;
      #CBS_LOWERCASE = $4000   ;
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
            If IsFlag(Flags, #BS_USERBUTTON )
              If IsFlag(Flags, #WS_BORDER )
                Flag|#PB_Frame_Flat
              Else
                If IsFlag(GetExStyle(Handle), #WS_EX_STATICEDGE )
                  Flag|#PB_Frame_Single
                EndIf
                If IsFlag(GetExStyle(Handle), #WS_EX_CLIENTEDGE )
                  Flag|#PB_Frame_Double
                EndIf
              EndIf
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
            If SendMessage_(Handle,#TBM_GETNUMTICS, 0, 0)>2
              Flag|#PB_TrackBar_Ticks
            EndIf
            If IsFlag(Flags, #TBS_VERT )
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
        Protected i, Handle = GadgetID(Gadget)
        
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
            If IsFlag(Flags,#PB_ListView_MultiSelect) ; The LSB_EXTENDEDSEL style can not be changed after creation
              SetStyle(Handle, (#LBS_EXTENDEDSEL))
            EndIf
            If IsFlag(Flags,#PB_ListView_ClickSelect) ; The LBS_MULTIPLESEL style can not be changed after creation
              SetStyle(Handle, (#LBS_MULTIPLESEL))
            EndIf
            
          Case #PB_GadgetType_Frame
            If IsFlag(Flags,#PB_Frame_Flat)
              SetStyle(Handle, (#WS_BORDER|#BS_USERBUTTON))
            Else
              If IsFlag(Flags,#PB_Frame_Single)
                SetStyle(Handle, (#BS_USERBUTTON))
                SetExStyle(Handle, (#WS_EX_STATICEDGE))
              EndIf
              If IsFlag(Flags,#PB_Frame_Double)
                SetStyle(Handle, (#BS_USERBUTTON))
                SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
              EndIf
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
              SetStyle(Handle, (#LC_MARKER))
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
            If IsFlag(Flags,#PB_ListIcon_CheckBoxes)          ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE, 0,#LVS_EX_CHECKBOXES)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_ThreeState)
              MessageRequester("Предупреждение!!!","Еще не реализованно");SetStyle(Handle, (#LVSIL_STATE))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_MultiSelect)
              MessageRequester("Предупреждение!!!","Еще не реализованно");SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE, 0,#LBS_MULTIPLESEL)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_GridLines)           ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE, 0,#LVS_EX_GRIDLINES)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_FullRowSelect)       ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE, 0,#LVS_EX_FULLROWSELECT)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_HeaderDragDrop)      ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE, 0,#LVS_EX_HEADERDRAGDROP)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_AlwaysShowSelection) ;Ok
              SetStyle(Handle, (#LVS_SHOWSELALWAYS))
            EndIf
            
          Case #PB_GadgetType_IPAddress
            
          Case #PB_GadgetType_ProgressBar
            Protected ProgressPos = SendMessage_(Handle, #PBM_GETPOS, 0, 0)
            If IsFlag(Flags,#PB_ProgressBar_Smooth)
              SetStyle(Handle, (#PBS_SMOOTH))
            EndIf
            If IsFlag(Flags,#PB_ProgressBar_Vertical)
              SetStyle(Handle, (#PBS_VERTICAL))
            EndIf
            SendMessage_(Handle, #PBM_SETPOS, ProgressPos, 0); 
            
          Case #PB_GadgetType_ScrollBar
            If IsFlag(Flags,#PB_ScrollBar_Vertical)
              SetStyle(Handle, (#SB_VERT))
            EndIf
            
          Case #PB_GadgetType_ScrollArea
            If IsFlag(Flags,#PB_ScrollArea_BorderLess)
              RemoveStyle(Handle, (#WS_BORDER))
              RemoveExStyle(Handle, (#WS_EX_STATICEDGE))
              RemoveExStyle(Handle, (#WS_EX_DLGMODALFRAME))
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Flat)
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
              SetStyle(Handle, (#WS_BORDER))
            Else
              If IsFlag(Flags,#PB_ScrollArea_Raised)
                RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
                SetExStyle(Handle, (#WS_EX_DLGMODALFRAME))
              EndIf
              If IsFlag(Flags,#PB_ScrollArea_Single)
                RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
                SetExStyle(Handle, (#WS_EX_STATICEDGE))
              EndIf
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Center)
              ;SetStyle(Handle, (#))
            EndIf
            
          Case #PB_GadgetType_TrackBar
            If IsFlag(Flags,#PB_TrackBar_Ticks)    ;Ok
              For i=1 To SendMessage_(Handle,#TBM_GETRANGEMAX,0, 0)-1 : SendMessage_(Handle,#TBM_SETTIC,0, i) : Next
            EndIf
            If IsFlag(Flags,#PB_TrackBar_Vertical) ;Ok
              SetStyle(Handle, (#TBS_VERT))
            EndIf
            
          Case #PB_GadgetType_Web
            
          Case #PB_GadgetType_ButtonImage
            If IsFlag(Flags,#PB_Button_Toggle) 
              SetStyle(Handle, (#BS_PUSHLIKE|#BS_CHECKBOX))
              SendMessage_(Handle, #BM_SETCHECK, 1, 0) ; Чтобы видет эфект сразу
            EndIf
            
          Case #PB_GadgetType_Calendar
            If IsFlag(Flags,#PB_Calendar_Borderless)
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
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
            If IsFlag(Flags,#PB_Frame_Flat)
              RemoveStyle(Handle, (#WS_BORDER|#BS_USERBUTTON))
            Else
              If IsFlag(Flags,#PB_Frame_Single)
                RemoveStyle(Handle, (#BS_USERBUTTON))
                RemoveExStyle(Handle, (#WS_EX_STATICEDGE))
              EndIf
              If IsFlag(Flags,#PB_Frame_Double)
                RemoveStyle(Handle, (#BS_USERBUTTON))
                RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
              EndIf
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
            If IsFlag(Flags,#PB_ListIcon_CheckBoxes)        ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE,#LVS_EX_CHECKBOXES, 0)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_ThreeState)
              ;  RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_MultiSelect)
              ;  RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_ListIcon_GridLines)        ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE,#LVS_EX_GRIDLINES, 0)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_FullRowSelect)        ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE,#LVS_EX_FULLROWSELECT, 0)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_HeaderDragDrop)        ;Ok
              SendMessage_(Handle, #LVM_SETEXTENDEDLISTVIEWSTYLE,#LVS_EX_HEADERDRAGDROP, 0)
            EndIf
            If IsFlag(Flags,#PB_ListIcon_AlwaysShowSelection)        ;Ok
              RemoveStyle(Handle, (#LVS_SHOWSELALWAYS))
            EndIf
            
          Case #PB_GadgetType_IPAddress
            
          Case #PB_GadgetType_ProgressBar
            Protected ProgressPos = SendMessage_(Handle, #PBM_GETPOS, 0, 0)
            If IsFlag(Flags,#PB_ProgressBar_Smooth)        ;Ok
              RemoveStyle(Handle, (#PBS_SMOOTH))
            EndIf
            If IsFlag(Flags,#PB_ProgressBar_Vertical)        ;Ok
              RemoveStyle(Handle, (#PBS_VERTICAL))
            EndIf
            SendMessage_(Handle, #PBM_SETPOS, ProgressPos, 0); 
            
          Case #PB_GadgetType_ScrollBar
            If IsFlag(Flags,#PB_ScrollBar_Vertical)
              RemoveStyle(Handle, (#SB_VERT))
            EndIf
            
          Case #PB_GadgetType_ScrollArea
            If IsFlag(Flags,#PB_ScrollArea_BorderLess)
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Flat)
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
              RemoveStyle(Handle, (#WS_BORDER))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Raised)
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
              RemoveExStyle(Handle, (#WS_EX_DLGMODALFRAME))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Single)
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
              RemoveExStyle(Handle, (#WS_EX_STATICEDGE))
            EndIf
            If IsFlag(Flags,#PB_ScrollArea_Center)
              ;  RemoveStyle(Handle, (#BS_RIGHT))
            EndIf
            
          Case #PB_GadgetType_TrackBar
            If IsFlag(Flags,#PB_TrackBar_Ticks)
              SendMessage_(Handle, #TBM_CLEARTICS, #NUL,#NUL)
            EndIf
            If IsFlag(Flags,#PB_TrackBar_Vertical)
              RemoveStyle(Handle, (#TBS_VERT))
            EndIf
            
          Case #PB_GadgetType_Web
            
          Case #PB_GadgetType_ButtonImage
            If IsFlag(Flags,#PB_Button_Toggle)
              If SendMessage_(Handle, #BM_GETCHECK, 0, 0)
                SendMessage_(Handle, #BM_SETCHECK, 0, 0)
              EndIf
              RemoveStyle(Handle, (#BS_PUSHLIKE|#BS_CHECKBOX))
            EndIf
            
          Case #PB_GadgetType_Calendar
            If IsFlag(Flags,#PB_Calendar_Borderless)
              SetExStyle(Handle, (#WS_EX_CLIENTEDGE))
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
      
      ;-  
    CompilerDefault
      Procedure.q GetWindow( Window ) : EndProcedure
      Procedure SetWindow( Window, Flags.q, Value=0 ) 
        Protected Handle = WindowID(Window)
        
        If IsFlag(Flags,#PB_Window_SizeGadget)     ;Ok
          gtk_window_set_resizable_(Handle, #True)
          Flags&~#PB_Window_TitleBar
        EndIf
        If IsFlag(Flags,#PB_Window_TitleBar)       ;Ok
          gtk_window_set_decorated_(Handle, #True)
        EndIf
        If IsFlag(Flags,#PB_Window_Tool)           ;Ok
          gtk_window_set_type_hint_(Handle, #GDK_WINDOW_TYPE_HINT_UTILITY)
        EndIf
        
;         gtk_window_maximize(handle)
;         gtk_window_iconify(handle)
;         gtk_window_deiconify(handle)
;         gtk_window_unmaximize(handle)
;         gtk_window_present(handle)
      EndProcedure
      Procedure RemoveWindow( Window, Flags.q ) 
        Protected Handle = WindowID(Window)
        
        If IsFlag(Flags,#PB_Window_SizeGadget)     ;Ok
          gtk_window_set_resizable_(Handle, #False)
          Flags&~#PB_Window_TitleBar
        EndIf
        If IsFlag(Flags,#PB_Window_TitleBar)       ;Ok
          gtk_window_set_decorated_(Handle, #False)
        EndIf
        If IsFlag(Flags,#PB_Window_Tool)           ;Ok
          gtk_window_set_type_hint_(Handle, #GDK_WINDOW_TYPE_HINT_UTILITY)
        EndIf
      EndProcedure
      Procedure.q GetGadget( Gadget ) : EndProcedure
      Procedure SetGadget( Gadget, Flags.q, Value=0 ): EndProcedure
      Procedure RemoveGadget( Gadget, Flags.q ) : EndProcedure
  CompilerEndSelect
  
EndModule

;- >>>> Example demo
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Procedure Create( Object, Type$, Caption$="",Width=200,Height=100, X=5,Y=5, Param1=0, Param2=1, Param3=1000, Flag=0)
    Protected a
    
    Select Type$
      Case "OpenWindow"          : OpenWindow          (Object, X,Y,Width,Height, Caption$, Flag) 
      Case "ButtonGadget"        : ButtonGadget        (Object, X,Y,Width,Height, Caption$, Flag)
      Case "StringGadget"        : StringGadget        (Object, X,Y,Width,Height, Caption$, Flag)
      Case "TextGadget"          : TextGadget          (Object, X,Y,Width,Height, Caption$, Flag)
      Case "CheckBoxGadget"      : CheckBoxGadget      (Object, X,Y,Width,Height, Caption$, Flag)
      Case "OptionGadget"        : OptionGadget        (Object, X,Y,Width,Height, Caption$)
      Case "ListViewGadget"      : ListViewGadget      (Object, X,Y,Width,Height, Flag)
        For a = 1 To 12
          AddGadgetItem (Object, -1, "Элемент  " + Str(a) + "  Списка") ; Определить содержимое списка.
        Next
        SetGadgetState(Object, 9) ; Установить (начиная с 0) десятый элемент как активный.
        
      Case "FrameGadget"         : FrameGadget         (Object, X,Y,Width,Height, Caption$, Flag)
      Case "ComboBoxGadget"      : ComboBoxGadget      (Object, X,Y,Width,Height, Flag)
      Case "ImageGadget"         : ImageGadget         (Object, X,Y,Width,Height, Param1, Flag)
      Case "HyperLinkGadget"     : HyperLinkGadget     (Object, X,Y,Width,Height, Caption$, Param1, Flag)
      Case "ContainerGadget"     : ContainerGadget     (Object, X,Y,Width,Height, Flag) : CloseGadgetList()
      Case "ListIconGadget"      : ListIconGadget      (Object, X,Y,Width,Height, Caption$, Param1, Flag)
        AddGadgetColumn(Object, 0, "Name", 100)
        AddGadgetColumn(Object, 1, "Address", 250)
        AddGadgetItem(Object, -1, "Harry Rannit"+Chr(10)+"12 Parliament Way, Battle Street, By the Bay")
        AddGadgetItem(Object, -1, "Ginger Brokeit"+Chr(10)+"130 PureBasic Road, BigTown, CodeCity")
        
      Case "IPAddressGadget"     : IPAddressGadget     (Object, X,Y,Width,Height)
      Case "ProgressBarGadget"   : ProgressBarGadget   (Object, X,Y,Width,Height, Param1, Param2+100, Flag)
        SetGadgetState   (Object, 50)  
        
      Case "ScrollBarGadget"     : ScrollBarGadget     (Object, X,Y,Width,Height, Param1, Param2, Param3, Flag)
      Case "ScrollAreaGadget"    : ScrollAreaGadget    (Object, X,Y,Width,Height, Param1, Param2, Param3, Flag)  : CloseGadgetList()
      Case "TrackBarGadget"      : TrackBarGadget      (Object, X,Y,Width,Height, Param1, Param2, Flag)
      Case "WebGadget"           : WebGadget           (Object, X,Y,Width,Height, Caption$)
      Case "ButtonImageGadget"   : ButtonImageGadget   (Object, X,Y,Width,Height, Param1, Flag)
      Case "CalendarGadget"      : CalendarGadget      (Object, X,Y,Width,Height, Param1, Flag)
      Case "DateGadget"          : DateGadget          (Object, X,Y,Width,Height, Caption$, Param1, Flag)
      Case "EditorGadget"        : EditorGadget        (Object, X,Y,Width,Height, Flag)
        For a = 0 To 5
          AddGadgetItem(Object, a, "Строка "+Str(a))
        Next
        
      Case "ExplorerListGadget"  : ExplorerListGadget  (Object, X,Y,Width,Height, Caption$, Flag)
      Case "ExplorerTreeGadget"  : ExplorerTreeGadget  (Object, X,Y,Width,Height, Caption$, Flag)
      Case "ExplorerComboGadget" : ExplorerComboGadget (Object, X,Y,Width,Height, Caption$, Flag)
      Case "SpinGadget"          : SpinGadget          (Object, X,Y,Width,Height, Param1, Param2, Flag)
      Case "TreeGadget"          : TreeGadget          (Object, X,Y,Width,Height, Flag)
      Case "PanelGadget"         : PanelGadget         (Object, X,Y,Width,Height)  : CloseGadgetList()
      Case "SplitterGadget"      
        If IsGadget(Param1) And IsGadget(Param2)
          SplitterGadget      (Object, X,Y,Width,Height, Param1, Param2, Flag)
        EndIf
      Case "MDIGadget"          
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          MDIGadget           (Object, X,Y,Width,Height, Param1, Param2, Flag) 
        CompilerEndIf
      Case "ScintillaGadget"     : ScintillaGadget     (Object, X,Y,Width,Height, Param1)
      Case "ShortcutGadget"      : ShortcutGadget      (Object, X,Y,Width,Height, Param1)
      Case "CanvasGadget"        : CanvasGadget        (Object, X,Y,Width,Height, Flag)
    EndSelect
  EndProcedure  
  
  Procedure$ GetPBFlags( Type=#PB_GadgetType_Unknown ) ; 
    Protected Flags.S
    
    Select Type
      Case #PB_GadgetType_Unknown        
        ;{- Ok
        Flags.S = "#PB_Window_BorderLess|"+
                  "#PB_Window_TitleBar|"+
                  "#PB_Window_SystemMenu|"+
                  "#PB_Window_MaximizeGadget|"+
                  "#PB_Window_MinimizeGadget|"+
                  "#PB_Window_SizeGadget|"+
                  "#PB_Window_ScreenCentered|"+
                  "#PB_Window_WindowCentered|"+
                  "#PB_Window_Tool|"+
                  "#PB_Window_Minimize|"+
                  "#PB_Window_Maximize|"+
                  "#PB_Window_Invisible|"+
                  "#PB_Window_NoActivate|"+
                  "#PB_Window_NoGadgets|"
        ;}
        
      Case #PB_GadgetType_Button         
        ;{- Ok
        Flags.S = "#PB_Button_MultiLine|"+
                  "#PB_Button_Default|"+
                  "#PB_Button_Toggle|"+
                  "#PB_Button_Left|"+
                  "#PB_Button_Right"
        ;}
        
      Case #PB_GadgetType_String         
        ;{- Ok
        Flags.S = "#PB_String_BorderLess|"+
                  "#PB_String_Numeric|"+
                  "#PB_String_Password|"+
                  "#PB_String_ReadOnly|"+
                  "#PB_String_LowerCase|"+
                  "#PB_String_UpperCase"
        
        ;}
        
      Case #PB_GadgetType_Text           
        ;{- Ok
        Flags.S = "#PB_Text_Border|"+
                  "#PB_Text_Right|"+
                  "#PB_Text_Center"
        ;}
        
      Case #PB_GadgetType_CheckBox       
        ;{- Ok
        Flags.S = "#PB_CheckBox_Right|"+
                  "#PB_CheckBox_Center|"+
                  "#PB_CheckBox_ThreeState"
        ;}
        
      Case #PB_GadgetType_Option         
        Flags.S = ""
        
      Case #PB_GadgetType_ListView       
        ;{- Ok
        Flags.S = "#PB_ListView_Multiselect|"+
                  "#PB_ListView_ClickSelect"
        ;}
        
      Case #PB_GadgetType_Frame          
        ;{- Ok
        Flags.S = "#PB_Frame_Flat|"+
                  "#PB_Frame_Single|"+
                  "#PB_Frame_Double"
        ;}
        
      Case #PB_GadgetType_ComboBox       
        ;{- Ok
        Flags.S = "#PB_ComboBox_Editable|"+
                  "#PB_ComboBox_LowerCase|"+
                  "#PB_ComboBox_UpperCase|"+
                  "#PB_ComboBox_Image"
        ;}
        
      Case #PB_GadgetType_Image          
        ;{- Ok
        Flags.S = "#PB_Image_Border|"+
                  "#PB_Image_Raised"
        ;}
        
      Case #PB_GadgetType_HyperLink      
        ;{- Ok
        Flags.S = "#PB_Hyperlink_Underline"
        ;}
        
      Case #PB_GadgetType_Container      
        ;{- Ok
        Flags.S = "#PB_Container_BorderLess|"+
                  "#PB_Container_Flat|"+
                  "#PB_Container_Single|"+
                  "#PB_Container_Double|"+
                  "#PB_Container_Raised"
        ;}
        
      Case #PB_GadgetType_ListIcon       
        ;{- Ok
        Flags.S = "#PB_ListIcon_CheckBoxes|"+
                  "#PB_ListIcon_ThreeState|"+
                  "#PB_ListIcon_MultiSelect|"+
                  "#PB_ListIcon_GridLines|"+
                  "#PB_ListIcon_FullRowSelect|"+
                  "#PB_ListIcon_HeaderDragDrop|"+
                  "#PB_ListIcon_AlwaysShowSelection"
        ;}
        
      Case #PB_GadgetType_IPAddress      
        Flags.S = ""
        
      Case #PB_GadgetType_ProgressBar    
        ;{- Ok
        Flags.S = "#PB_ProgressBar_Smooth|"+
                  "#PB_ProgressBar_Vertical"
        ;}
        
      Case #PB_GadgetType_ScrollBar      
        ;{- Ok
        Flags.S = "#PB_ScrollBar_Vertical"
        ;}
        
      Case #PB_GadgetType_ScrollArea     
        ;{- Ok
        Flags.S = "#PB_ScrollArea_BorderLess|"+
                  "#PB_ScrollArea_Flat|"+
                  "#PB_ScrollArea_Single|"+
                  "#PB_ScrollArea_Raised|"+
                  "#PB_ScrollArea_Center"
        ;}
        
      Case #PB_GadgetType_TrackBar       
        ;{- Ok
        Flags.S = "#PB_TrackBar_Ticks|"+
                  "#PB_TrackBar_Vertical"
        ;}
        
      Case #PB_GadgetType_Web            
        Flags.S = ""
        
      Case #PB_GadgetType_ButtonImage    
        ;{- Ok
        Flags.S = "#PB_Button_Toggle"
        ;}
        
      Case #PB_GadgetType_Calendar       
        ;{- Ok
        Flags.S = "#PB_Calendar_Borderless"
        ;}
        
      Case #PB_GadgetType_Date           
        ;{- Ok
        Flags.S = "#PB_Date_UpDown"
        ;}
        
      Case #PB_GadgetType_Editor         
        ;{- Ok
        Flags.S = "#PB_Editor_ReadOnly|"+
                  "#PB_Editor_WordWrap"
        ;}
        
      Case #PB_GadgetType_ExplorerList   
        ;{- Ok
        Flags.S = "#PB_Explorer_BorderLess|"+
                  "#PB_Explorer_AlwaysShowSelection|"+
                  "#PB_Explorer_MultiSelect|"+
                  "#PB_Explorer_GridLines|"+
                  "#PB_Explorer_HeaderDragDrop|"+
                  "#PB_Explorer_FullRowSelect|"+
                  "#PB_Explorer_NoFiles|"+
                  "#PB_Explorer_NoFolders|"+
                  "#PB_Explorer_NoParentFolder|"+
                  "#PB_Explorer_NoDirectoryChange|"+
                  "#PB_Explorer_NoDriveRequester|"+
                  "#PB_Explorer_NoSort|"+
                  "#PB_Explorer_NoMyDocuments|"+
                  "#PB_Explorer_AutoSort|"+
                  "#PB_Explorer_HiddenFiles"
        ;}
        
      Case #PB_GadgetType_ExplorerTree   
        Flags.S = ""
        
      Case #PB_GadgetType_ExplorerCombo  
        Flags.S = ""
        
      Case #PB_GadgetType_Spin           
        Flags.S = ""
        
      Case #PB_GadgetType_Tree           
        ;{- Ok
        Flags.S = "#PB_Tree_AlwaysShowSelection|"+
                  "#PB_Tree_NoLines|"+
                  "#PB_Tree_NoButtons|"+
                  "#PB_Tree_CheckBoxes|"+
                  "#PB_Tree_ThreeState"
        ;}
        
      Case #PB_GadgetType_Panel          
        Flags.S = ""
        
      Case #PB_GadgetType_Splitter       
        ;{- Ok
        Flags.S = "#PB_Splitter_Vertical|"+
                  "#PB_Splitter_Separator|"+
                  "#PB_Splitter_FirstFixed|"+
                  "#PB_Splitter_SecondFixed" 
        ;}
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Case #PB_GadgetType_MDI           
          Flags.S = ""
        CompilerEndIf
        
      Case #PB_GadgetType_Scintilla      
        Flags.S = ""
        
      Case #PB_GadgetType_Shortcut       
        Flags.S = ""
        
      Case #PB_GadgetType_Canvas 
        ;{- Ok
        Flags.S = "#PB_Canvas_Border|"+
                  "#PB_Canvas_Container|"+
                  "#PB_Canvas_ClipMouse|"+
                  "#PB_Canvas_Keyboard|"+
                  "#PB_Canvas_DrawFocus"
        ;}
        
    EndSelect
    
    ProcedureReturn Flags.S
  EndProcedure
  
  Procedure.q GetPBFlag(Flags$)
    Protected i, Flag.q
    
    If Flags$
      For I = 0 To CountString(Flags$,"|")
        
        Select Trim(StringField(Flags$,(I+1),"|"))
            ; window
          Case "#PB_Window_BorderLess"              : Flag = Flag | #PB_Window_BorderLess
          Case "#PB_Window_Invisible"               : Flag = Flag | #PB_Window_Invisible
          Case "#PB_Window_Maximize"                : Flag = Flag | #PB_Window_Maximize
          Case "#PB_Window_Minimize"                : Flag = Flag | #PB_Window_Minimize
          Case "#PB_Window_MaximizeGadget"          : Flag = Flag | #PB_Window_MaximizeGadget
          Case "#PB_Window_MinimizeGadget"          : Flag = Flag | #PB_Window_MinimizeGadget
          Case "#PB_Window_NoActivate"              : Flag = Flag | #PB_Window_NoActivate
          Case "#PB_Window_NoGadgets"               : Flag = Flag | #PB_Window_NoGadgets
          Case "#PB_Window_SizeGadget"                    : Flag = Flag | #PB_Window_SizeGadget
          Case "#PB_Window_SystemMenu"              : Flag = Flag | #PB_Window_SystemMenu
          Case "#PB_Window_TitleBar"                : Flag = Flag | #PB_Window_TitleBar
          Case "#PB_Window_Tool"                    : Flag = Flag | #PB_Window_Tool
          Case "#PB_Window_ScreenCentered"          : Flag = Flag | #PB_Window_ScreenCentered
          Case "#PB_Window_WindowCentered"          : Flag = Flag | #PB_Window_WindowCentered
            ; buttonimage 
          Case "#PB_Button_Image"                   : Flag = Flag | #PB_Button_Image
          Case "#PB_Button_PressedImage"            : Flag = Flag | #PB_Button_PressedImage
            ; button  
          Case "#PB_Button_Default"                 : Flag = Flag | #PB_Button_Default
          Case "#PB_Button_Left"                    : Flag = Flag | #PB_Button_Left
          Case "#PB_Button_MultiLine"               : Flag = Flag | #PB_Button_MultiLine
          Case "#PB_Button_Right"                   : Flag = Flag | #PB_Button_Right
          Case "#PB_Button_Toggle"                  : Flag = Flag | #PB_Button_Toggle
            ; string
          Case "#PB_String_BorderLess"              : Flag = Flag | #PB_String_BorderLess
          Case "#PB_String_LowerCase"               : Flag = Flag | #PB_String_LowerCase
          Case "#PB_String_MaximumLength"           : Flag = Flag | #PB_String_MaximumLength
          Case "#PB_String_Numeric"                 : Flag = Flag | #PB_String_Numeric
          Case "#PB_String_Password"                : Flag = Flag | #PB_String_Password
          Case "#PB_String_ReadOnly"                : Flag = Flag | #PB_String_ReadOnly
          Case "#PB_String_UpperCase"               : Flag = Flag | #PB_String_UpperCase
            ; text
          Case "#PB_Text_Border"                    : Flag = Flag | #PB_Text_Border
          Case "#PB_Text_Center"                    : Flag = Flag | #PB_Text_Center
          Case "#PB_Text_Right"                     : Flag = Flag | #PB_Text_Right
            ; option
            ; checkbox
          Case "#PB_CheckBox_Center"                : Flag = Flag | #PB_CheckBox_Center
          Case "#PB_CheckBox_Right"                 : Flag = Flag | #PB_CheckBox_Right
          Case "#PB_CheckBox_ThreeState"            : Flag = Flag | #PB_CheckBox_ThreeState
            ; listview
          Case "#PB_ListView_ClickSelect"           : Flag = Flag | #PB_ListView_ClickSelect
          Case "#PB_ListView_MultiSelect"           : Flag = Flag | #PB_ListView_MultiSelect
            ; frame
          Case "#PB_Frame_Double"                   : Flag = Flag | #PB_Frame_Double
          Case "#PB_Frame_Flat"                     : Flag = Flag | #PB_Frame_Flat
          Case "#PB_Frame_Single"                   : Flag = Flag | #PB_Frame_Single
            ; combobox
          Case "#PB_ComboBox_Editable"              : Flag = Flag | #PB_ComboBox_Editable
          Case "#PB_ComboBox_Image"                 : Flag = Flag | #PB_ComboBox_Image
          Case "#PB_ComboBox_LowerCase"             : Flag = Flag | #PB_ComboBox_LowerCase
          Case "#PB_ComboBox_UpperCase"             : Flag = Flag | #PB_ComboBox_UpperCase
            ; image 
          Case "#PB_Image_Border"                   : Flag = Flag | #PB_Image_Border
          Case "#PB_Image_Raised"                   : Flag = Flag | #PB_Image_Raised
            ; hyperlink 
          Case "#PB_HyperLink_Underline"            : Flag = Flag | #PB_HyperLink_Underline
            ; container 
          Case "#PB_Container_BorderLess"           : Flag = Flag | #PB_Container_BorderLess
          Case "#PB_Container_Double"               : Flag = Flag | #PB_Container_Double
          Case "#PB_Container_Flat"                 : Flag = Flag | #PB_Container_Flat
          Case "#PB_Container_Raised"               : Flag = Flag | #PB_Container_Raised
          Case "#PB_Container_Single"               : Flag = Flag | #PB_Container_Single
            ; listicon
          Case "#PB_ListIcon_AlwaysShowSelection"   : Flag = Flag | #PB_ListIcon_AlwaysShowSelection
          Case "#PB_ListIcon_CheckBoxes"            : Flag = Flag | #PB_ListIcon_CheckBoxes
          Case "#PB_ListIcon_ColumnWidth"           : Flag = Flag | #PB_ListIcon_ColumnWidth
          Case "#PB_ListIcon_DisplayMode"           : Flag = Flag | #PB_ListIcon_DisplayMode
          Case "#PB_ListIcon_GridLines"             : Flag = Flag | #PB_ListIcon_GridLines
          Case "#PB_ListIcon_FullRowSelect"         : Flag = Flag | #PB_ListIcon_FullRowSelect
          Case "#PB_ListIcon_HeaderDragDrop"        : Flag = Flag | #PB_ListIcon_HeaderDragDrop
          Case "#PB_ListIcon_LargeIcon"             : Flag = Flag | #PB_ListIcon_LargeIcon
          Case "#PB_ListIcon_List"                  : Flag = Flag | #PB_ListIcon_List
          Case "#PB_ListIcon_MultiSelect"           : Flag = Flag | #PB_ListIcon_MultiSelect
          Case "#PB_ListIcon_Report"                : Flag = Flag | #PB_ListIcon_Report
          Case "#PB_ListIcon_SmallIcon"             : Flag = Flag | #PB_ListIcon_SmallIcon
          Case "#PB_ListIcon_ThreeState"            : Flag = Flag | #PB_ListIcon_ThreeState
            ; ipaddress
            ; progressbar 
          Case "#PB_ProgressBar_Smooth"             : Flag = Flag | #PB_ProgressBar_Smooth
          Case "#PB_ProgressBar_Vertical"           : Flag = Flag | #PB_ProgressBar_Vertical
            ; scrollbar 
          Case "#PB_ScrollBar_Vertical"             : Flag = Flag | #PB_ScrollBar_Vertical
            ; scrollarea 
          Case "#PB_ScrollArea_BorderLess"          : Flag = Flag | #PB_ScrollArea_BorderLess
          Case "#PB_ScrollArea_Center"              : Flag = Flag | #PB_ScrollArea_Center
          Case "#PB_ScrollArea_Flat"                : Flag = Flag | #PB_ScrollArea_Flat
          Case "#PB_ScrollArea_Raised"              : Flag = Flag | #PB_ScrollArea_Raised
          Case "#PB_ScrollArea_Single"              : Flag = Flag | #PB_ScrollArea_Single
            ; trackbar
          Case "#PB_TrackBar_Ticks"                 : Flag = Flag | #PB_TrackBar_Ticks
          Case "#PB_TrackBar_Vertical"              : Flag = Flag | #PB_TrackBar_Vertical
            ; web
            ; calendar
          Case "#PB_Calendar_Borderless"            : Flag = Flag | #PB_Calendar_Borderless
            
            ; date
          Case "#PB_Date_CheckBox"                  : Flag = Flag | #PB_Date_CheckBox
          Case "#PB_Date_UpDown"                    : Flag = Flag | #PB_Date_UpDown
            
            ; editor
          Case "#PB_Editor_ReadOnly"                : Flag = Flag | #PB_Editor_ReadOnly
          Case "#PB_Editor_WordWrap"                : Flag = Flag | #PB_Editor_WordWrap
            
            ; explorerlist
          Case "#PB_Explorer_BorderLess"            : Flag = Flag | #PB_Explorer_BorderLess          ; Создать гаджет без границ.
          Case "#PB_Explorer_AlwaysShowSelection"   : Flag = Flag | #PB_Explorer_AlwaysShowSelection ; Выделение отображается даже если гаджет не активирован.
          Case "#PB_Explorer_MultiSelect"           : Flag = Flag | #PB_Explorer_MultiSelect         ; Разрешить множественное выделение элементов в гаджете.
          Case "#PB_Explorer_GridLines"             : Flag = Flag | #PB_Explorer_GridLines           ; Отображать разделительные линии между строками и колонками.
          Case "#PB_Explorer_HeaderDragDrop"        : Flag = Flag | #PB_Explorer_HeaderDragDrop      ; В режиме таблицы заголовки можно перетаскивать (Drag'n'Drop).
          Case "#PB_Explorer_FullRowSelect"         : Flag = Flag | #PB_Explorer_FullRowSelect       ; Выделение охватывает всю строку, а не первую колонку.
          Case "#PB_Explorer_NoFiles"               : Flag = Flag | #PB_Explorer_NoFiles             ; Не показывать файлы.
          Case "#PB_Explorer_NoFolders"             : Flag = Flag | #PB_Explorer_NoFolders           ; Не показывать каталоги.
          Case "#PB_Explorer_NoParentFolder"        : Flag = Flag | #PB_Explorer_NoParentFolder      ; Не показывать ссылку на родительский каталог [..].
          Case "#PB_Explorer_NoDirectoryChange"     : Flag = Flag | #PB_Explorer_NoDirectoryChange   ; Пользователь не может сменить директорию.
          Case "#PB_Explorer_NoDriveRequester"      : Flag = Flag | #PB_Explorer_NoDriveRequester    ; Не показывать запрос 'пожалуйста, вставьте диск X:'.
          Case "#PB_Explorer_NoSort"                : Flag = Flag | #PB_Explorer_NoSort              ; Пользователь не может сортировать содержимое по клику на заголовке колонки.
          Case "#PB_Explorer_AutoSort"              : Flag = Flag | #PB_Explorer_AutoSort            ; Содержимое автоматически упорядочивается по имени.
          Case "#PB_Explorer_HiddenFiles"           : Flag = Flag | #PB_Explorer_HiddenFiles         ; Будет отображать скрытые файлы (поддерживается только в Linux и OS X).
          Case "#PB_Explorer_NoMyDocuments"         : Flag = Flag | #PB_Explorer_NoMyDocuments       ; Не показывать каталог 'Мои документы' в виде отдельного элемента.
            
            ; explorercombo
          Case "#PB_Explorer_DrivesOnly"            : Flag = Flag | #PB_Explorer_DrivesOnly          ; Гаджет будет отображать только диски, которые вы можете выбрать.
          Case "#PB_Explorer_Editable"              : Flag = Flag | #PB_Explorer_Editable            ; Гаджет будет доступен для редактирования с функцией автозаполнения.  			      С этим флагом он действует точно так же, как тот что в Windows Explorer.
            
            ; explorertree
          Case "#PB_Explorer_NoLines"               : Flag = Flag | #PB_Explorer_NoLines             ; Скрыть линии, соединяющие узлы дерева.
          Case "#PB_Explorer_NoButtons"             : Flag = Flag | #PB_Explorer_NoButtons           ; Скрыть кнопки разворачивания узлов в виде символов '+'.
            
            ; spin
          Case "#PB_Explorer_Type"                  : Flag = Flag | #PB_Spin_Numeric
          Case "#PB_Explorer_Type"                  : Flag = Flag | #PB_Spin_ReadOnly
            ; tree
          Case "#PB_Tree_AlwaysShowSelection"       : Flag = Flag | #PB_Tree_AlwaysShowSelection
          Case "#PB_Tree_CheckBoxes"                : Flag = Flag | #PB_Tree_CheckBoxes
          Case "#PB_Tree_NoButtons"                 : Flag = Flag | #PB_Tree_NoButtons
          Case "#PB_Tree_NoLines"                   : Flag = Flag | #PB_Tree_NoLines
          Case "#PB_Tree_ThreeState"                : Flag = Flag | #PB_Tree_ThreeState
            ; panel
            ; splitter
          Case "#PB_Splitter_Separator"             : Flag = Flag | #PB_Splitter_Separator
          Case "#PB_Splitter_Vertical"              : Flag = Flag | #PB_Splitter_Vertical
          Case "#PB_Splitter_FirstFixed"            : Flag = Flag | #PB_Splitter_FirstFixed
          Case "#PB_Splitter_SecondFixed"           : Flag = Flag | #PB_Splitter_SecondFixed
            ; mdi
          Case "#PB_MDI_AutoSize"                   : Flag = Flag | #PB_MDI_AutoSize
          Case "#PB_MDI_BorderLess"                 : Flag = Flag | #PB_MDI_BorderLess
          Case "#PB_MDI_NoScrollBars"               : Flag = Flag | #PB_MDI_NoScrollBars
            ; scintilla
            ; shortcut
            ; canvas
          Case "#PB_Canvas_Border"                  : Flag = Flag | #PB_Canvas_Border
          Case "#PB_Canvas_ClipMouse"               : Flag = Flag | #PB_Canvas_ClipMouse
          Case "#PB_Canvas_Container"               : Flag = Flag | #PB_Canvas_Container
          Case "#PB_Canvas_DrawFocus"               : Flag = Flag | #PB_Canvas_DrawFocus
          Case "#PB_Canvas_Keyboard"                : Flag = Flag | #PB_Canvas_Keyboard
        EndSelect
        
      Next
    EndIf
    
    ProcedureReturn Flag
  EndProcedure
  
  
  Macro GetWindowFlag(Window) : Flag::GetWindow(Window) : EndMacro
  Macro SetWindowFlag(Window, Flag) : Flag::SetWindow(Window, Flag) : EndMacro
  Macro RemoveWindowFlag(Window, Flag) : Flag::RemoveWindow(Window, Flag) : EndMacro
  
  Macro GetGadgetFlag(Gadget) : Flag::GetGadget(Gadget) : EndMacro
  Macro SetGadgetFlag(Gadget, Flag) : Flag::SetGadget(Gadget, Flag) : EndMacro
  Macro RemoveGadgetFlag(Gadget, Flag) : Flag::RemoveGadget(Gadget, Flag) : EndMacro
  
  Global i, Object=2, Text.S
  Global Tree, Combo
  Global Flag.q
  
  OpenWindow( 0, 11, 11, 300, 280, "Window" ,#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered) 
  ResizeWindow(0, #PB_Ignore, WindowY(0)+220, #PB_Ignore, #PB_Ignore)
  StickyWindow(0,1)
  Combo = ComboBoxGadget( #PB_Any,5,5,290,35 ) 
  AddGadgetItem( Combo, -1, "Window")
  AddGadgetItem( Combo, -1, "Button")
  AddGadgetItem( Combo, -1, "String")
  AddGadgetItem( Combo, -1, "Text")
  AddGadgetItem( Combo, -1, "CheckBox")
  AddGadgetItem( Combo, -1, "Option")
  AddGadgetItem( Combo, -1, "ListView")
  AddGadgetItem( Combo, -1, "Frame")
  AddGadgetItem( Combo, -1, "ComboBox")
  AddGadgetItem( Combo, -1, "Image")
  AddGadgetItem( Combo, -1, "HyperLink")
  AddGadgetItem( Combo, -1, "Container") ; Win = Ok
  AddGadgetItem( Combo, -1, "ListIcon")
  AddGadgetItem( Combo, -1, "IPAddress")
  AddGadgetItem( Combo, -1, "ProgressBar")
  AddGadgetItem( Combo, -1, "ScrollBar") ; Win = Ok
  AddGadgetItem( Combo, -1, "ScrollArea"); Win = Ok
  AddGadgetItem( Combo, -1, "TrackBar")
  AddGadgetItem( Combo, -1, "Web")
  AddGadgetItem( Combo, -1, "ButtonImage")
  AddGadgetItem( Combo, -1, "Calendar")
  AddGadgetItem( Combo, -1, "Date") ; Win = Ok
  AddGadgetItem( Combo, -1, "Editor") ; Win = Ok
  AddGadgetItem( Combo, -1, "ExplorerList") ; Win = Ok
  AddGadgetItem( Combo, -1, "ExplorerTree") ; Win = Ok
  AddGadgetItem( Combo, -1, "ExplorerCombo"); Win = Ok
  AddGadgetItem( Combo, -1, "Spin")         ; Win = Ok
  AddGadgetItem( Combo, -1, "Tree")         ; Ok
  AddGadgetItem( Combo, -1, "Panel")        ; Ok
  AddGadgetItem( Combo, -1, "Splitter")     ; Win = Ok
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( Combo, -1, "MDI") ; Ok
  CompilerEndIf
  AddGadgetItem( Combo, -1, "Scintilla") ; Ok
  AddGadgetItem( Combo, -1, "Shortcut")  ; Ok
  AddGadgetItem( Combo, -1, "Canvas")    ;Ok
  
  SetGadgetState( Combo, 0)
  Text.S = GetPBFlags(GetGadgetState(Combo))
  
  Tree = TreeGadget(#PB_Any, 5,45,290,230, #PB_Tree_NoLines|#PB_Tree_NoButtons|#PB_Tree_CheckBoxes) 
  ClearGadgetItems(Tree)
  
  For i=0 To CountString(Text.S,"|")
    If Trim(StringField(Text.S,i+1,"|"))
      AddGadgetItem(Tree,-1,Trim(StringField(Text.S,i+1,"|")))
      SetGadgetItemData(Tree, i, GetPBFlag( Trim(StringField(Text.S,i+1,"|")) ))
    EndIf
  Next
  
  
  OpenWindow( 1, 221, 211, 300, 200, "test to set window centered", #PB_Window_SystemMenu) 
  OpenWindow( 2, 221, 11, 200, 100, "test set flag", #PB_Window_TitleBar, WindowID(1)) 
  
  ButtonGadget(20 ,5,5,WindowWidth(2)-10,WindowHeight(2)-10,"NoFlag")
  
  ; Flag::RemoveWindow(2, #PB_Window_TitleBar)
  
  Flag.q = Flag::GetWindow(2)
  
  For i=0 To CountGadgetItems(Tree)-1
    If Flag::IsFlag(Flag,GetGadgetItemData(Tree, i)) 
      SetGadgetItemState(Tree, i,#PB_Tree_Checked)
    EndIf
  Next 
  
  Repeat 
    Select WaitWindowEvent()
      Case #PB_Event_Gadget
        Select EventGadget()
          Case Combo
            Select EventType()
              Case #PB_EventType_Change
                Text.S = GetPBFlags(GetGadgetState(Combo))
                ClearGadgetItems(Tree)
                
                For i=0 To CountString(Text.S,"|")
                  If Trim(StringField(Text.S,i+1,"|"))
                    AddGadgetItem(Tree,-1,Trim(StringField(Text.S,i+1,"|")))
                    SetGadgetItemData(Tree, i, GetPBFlag( Trim(StringField(Text.S,i+1,"|")) ))
                  EndIf
                Next
                
                If GetGadgetText(Combo) = "Window"
                  Object=2
                  CloseWindow(Object)
                  Create(2,GetGadgetText(Combo)+"Gadget", GetGadgetText(Combo), 200, 100)
                  Flag.q = Flag::GetWindow(Object)
                Else
                  Object=20
                  FreeGadget(Object)
                  Create(Object,GetGadgetText(Combo)+"Gadget", GetGadgetText(Combo)+" multi line text test then set long long text", 190, 90)
                  Flag.q = Flag::GetGadget(Object)
                EndIf
                
                
                For i=0 To CountGadgetItems(Tree)-1
                  If Flag::IsFlag(Flag,GetGadgetItemData(Tree, i)) 
                    SetGadgetItemState(Tree, i,#PB_Tree_Checked)
                  EndIf
                Next 
                
            EndSelect
            
          Case Tree
            Select EventType()
              Case #PB_EventType_Change
                i=GetGadgetState(Tree)
                Flag.q = GetPBFlag(GetGadgetItemText(Tree, i))
                
                If IsGadget(Object)
                  Select Bool(GetGadgetItemState(Tree, i) & #PB_Tree_Checked)
                    Case 1 : SetGadgetFlag(Object, Flag)
                    Case 0 : RemoveGadgetFlag(Object, Flag)
                  EndSelect
                ElseIf IsWindow(Object)
                  Select Bool(GetGadgetItemState(Tree, i) & #PB_Tree_Checked)
                    Case 1 : SetWindowFlag(Object, Flag)
                    Case 0 : RemoveWindowFlag(Object, Flag)
                  EndSelect
                EndIf
                
            EndSelect
        EndSelect
        
      Case #PB_Event_CloseWindow
        End
    EndSelect
  ForEver 
CompilerEndIf
