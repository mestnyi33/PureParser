; http://www.purebasic.fr/english/viewtopic.php?f=13&t=61700&p=462648#p462648
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
  
  Declare$ PB( Type, Type$="" )
  
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
  Procedure$ PB( Type, Type$="" ) ; 
    Protected Flags.S
    
    If Type$=""
      Select Type
        Case #PB_GadgetType_Window        
          ;{- Ok
          Flags.S = "#PB_Window_TitleBar|"+
                    "#PB_Window_BorderLess|"+
                    "#PB_Window_SystemMenu|"+
                    "#PB_Window_MaximizeGadget|"+
                    "#PB_Window_MinimizeGadget|"+
                    "#PB_Window_ScreenCentered|"+
                    "#PB_Window_SizeGadget|"+
                    "#PB_Window_WindowCentered|"+
                    "#PB_Window_Tool|"+
                    "#PB_Window_Normal|"+
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
          Flags.S = "#PB_String_Numeric|"+
                    "#PB_String_Password|"+
                    "#PB_String_ReadOnly|"+
                    "#PB_String_LowerCase|"+
                    "#PB_String_UpperCase|"+
                    "#PB_String_BorderLess" 
          ;}
          
        Case #PB_GadgetType_Text           
          ;{- Ok
          Flags.S = "#PB_Text_Center|"+
                    "#PB_Text_Right|"+
                    "#PB_Text_Border"
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
          Flags.S = "#PB_Frame_Single|"+
                    "#PB_Frame_Double|"+
                    "#PB_Frame_Flat"
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
                    "#PB_Container_Raised|"+
                    "#PB_Container_Single|"+
                    "#PB_Container_Double"
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
          Flags.S = "#PB_ScrollArea_Flat|"+
                    "#PB_ScrollArea_Raised|"+
                    "#PB_ScrollArea_Single|"+
                    "#PB_ScrollArea_BorderLess|"+
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
    Else
      Select Type$
        Case "OpenWindow"        
          ;{- Ok
          Flags.S = "#PB_Window_TitleBar|"+
                    "#PB_Window_BorderLess|"+
                    "#PB_Window_SystemMenu|"+
                    "#PB_Window_MaximizeGadget|"+
                    "#PB_Window_MinimizeGadget|"+
                    "#PB_Window_ScreenCentered|"+
                    "#PB_Window_SizeGadget|"+
                    "#PB_Window_WindowCentered|"+
                    "#PB_Window_Tool|"+
                    "#PB_Window_Normal|"+
                    "#PB_Window_Minimize|"+
                    "#PB_Window_Maximize|"+
                    "#PB_Window_Invisible|"+
                    "#PB_Window_NoActivate|"+
                    "#PB_Window_NoGadgets|"
          ;}
          
        Case "ButtonGadget"         
          ;{- Ok
          Flags.S = "#PB_Button_MultiLine|"+
                    "#PB_Button_Default|"+
                    "#PB_Button_Toggle|"+
                    "#PB_Button_Left|"+
                    "#PB_Button_Right"
          ;}
          
        Case "StringGadget"         
          ;{- Ok
          Flags.S = "#PB_String_Numeric|"+
                    "#PB_String_Password|"+
                    "#PB_String_ReadOnly|"+
                    "#PB_String_LowerCase|"+
                    "#PB_String_UpperCase|"+
                    "#PB_String_BorderLess" 
          ;}
          
        Case "TextGadget"           
          ;{- Ok
          Flags.S = "#PB_Text_Center|"+
                    "#PB_Text_Right|"+
                    "#PB_Text_Border"
          ;}
          
        Case "CheckBoxGadget"       
          ;{- Ok
          Flags.S = "#PB_CheckBox_Right|"+
                    "#PB_CheckBox_Center|"+
                    "#PB_CheckBox_ThreeState"
          ;}
          
        Case "OptionGadget"         
          Flags.S = ""
          
        Case "ListViewGadget"       
          ;{- Ok
          Flags.S = "#PB_ListView_Multiselect|"+
                    "#PB_ListView_ClickSelect"
          ;}
          
        Case "FrameGadget"          
          ;{- Ok
          Flags.S = "#PB_Frame_Single|"+
                    "#PB_Frame_Double|"+
                    "#PB_Frame_Flat"
          ;}
          
        Case "ComboBoxGadget"       
          ;{- Ok
          Flags.S = "#PB_ComboBox_Editable|"+
                    "#PB_ComboBox_LowerCase|"+
                    "#PB_ComboBox_UpperCase|"+
                    "#PB_ComboBox_Image"
          ;}
          
        Case "ImageGadget"          
          ;{- Ok
          Flags.S = "#PB_Image_Border|"+
                    "#PB_Image_Raised"
          ;}
          
        Case "HyperLinkGadget"      
          ;{- Ok
          Flags.S = "#PB_Hyperlink_Underline"
          ;}
          
        Case "ContainerGadget"      
          ;{- Ok
          Flags.S = "#PB_Container_BorderLess|"+
                    "#PB_Container_Flat|"+
                    "#PB_Container_Raised|"+
                    "#PB_Container_Single|"+
                    "#PB_Container_Double"
          ;}
          
        Case "ListIconGadget"       
          ;{- Ok
          Flags.S = "#PB_ListIcon_CheckBoxes|"+
                    "#PB_ListIcon_ThreeState|"+
                    "#PB_ListIcon_MultiSelect|"+
                    "#PB_ListIcon_GridLines|"+
                    "#PB_ListIcon_FullRowSelect|"+
                    "#PB_ListIcon_HeaderDragDrop|"+
                    "#PB_ListIcon_AlwaysShowSelection"
          ;}
          
        Case "IPAddressGadget"     
          Flags.S = ""
          
        Case "ProgressBarGadget"    
          ;{- Ok
          Flags.S = "#PB_ProgressBar_Smooth|"+
                    "#PB_ProgressBar_Vertical"
          ;}
          
        Case "ScrollBarGadget"      
          ;{- Ok
          Flags.S = "#PB_ScrollBar_Vertical"
          ;}
          
        Case "ScrollAreaGadget"     
          ;{- Ok
          Flags.S = "#PB_ScrollArea_Flat|"+
                    "#PB_ScrollArea_Raised|"+
                    "#PB_ScrollArea_Single|"+
                    "#PB_ScrollArea_BorderLess|"+
                    "#PB_ScrollArea_Center"
          ;}
          
        Case "TrackBarGadget"       
          ;{- Ok
          Flags.S = "#PB_TrackBar_Ticks|"+
                    "#PB_TrackBar_Vertical"
          ;}
          
        Case "WebGadget"            
          Flags.S = ""
          
        Case "ButtonImageGadget"    
          ;{- Ok
          Flags.S = "#PB_Button_Toggle"
          ;}
          
        Case "CalendarGadget"       
          ;{- Ok
          Flags.S = "#PB_Calendar_Borderless"
          ;}
          
        Case "DateGadget"           
          ;{- Ok
          Flags.S = "#PB_Date_UpDown"
          ;}
          
        Case "EditorGadget"         
          ;{- Ok
          Flags.S = "#PB_Editor_ReadOnly|"+
                    "#PB_Editor_WordWrap"
          ;}
          
        Case "ExplorerListGadget"   
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
          
        Case "ExplorerTreeGadget"   
          Flags.S = ""
          
        Case "ExplorerComboGadget"  
          Flags.S = ""
          
        Case "SpinGadget"           
          Flags.S = ""
          
        Case "TreeGadget"           
          ;{- Ok
          Flags.S = "#PB_Tree_AlwaysShowSelection|"+
                    "#PB_Tree_NoLines|"+
                    "#PB_Tree_NoButtons|"+
                    "#PB_Tree_CheckBoxes|"+
                    "#PB_Tree_ThreeState"
          ;}
          
        Case "PanelGadget"          
          Flags.S = ""
          
        Case "SplitterGadget"       
          ;{- Ok
          Flags.S = "#PB_Splitter_Vertical|"+
                    "#PB_Splitter_Separator|"+
                    "#PB_Splitter_FirstFixed|"+
                    "#PB_Splitter_SecondFixed" 
          ;}
          
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Case "MDIGadget"           
            Flags.S = ""
          CompilerEndIf
          
        Case "ScintillaGadget"      
          Flags.S = ""
          
        Case "ShortcutGadget"       
          Flags.S = ""
          
        Case "CanvasGadget" 
          ;{- Ok
          Flags.S = "#PB_Canvas_Border|"+
                    "#PB_Canvas_Container|"+
                    "#PB_Canvas_ClipMouse|"+
                    "#PB_Canvas_Keyboard|"+
                    "#PB_Canvas_DrawFocus"
          ;}
          
      EndSelect
    EndIf
    
    If Flags.S=""
      Flags.S="#PB_Flag_None"
    EndIf
    
    ProcedureReturn Flags.S
  EndProcedure
  
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
        
        If (ExStyle & #WS_EX_CLIENTEDGE);|#WS_EX_TOOLWINDOW|#WS_EX_NOACTIVATE)
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
        EndSelect
        
        ProcedureReturn Flag
      EndProcedure
      
      Procedure SetGadget( Gadget, Flags.q, Value=0 )
        Protected Handle = GadgetID(Gadget)
        
        Select GadgetType(Gadget)
          Case #PB_GadgetType_String
            If IsFlag(Flags,#PB_String_BorderLess) ;Ok
              RemoveExStyle(Handle, (#WS_EX_CLIENTEDGE))
            EndIf
            If IsFlag(Flags,#PB_String_Password)   ;Ok
              SetStyle(Handle, (#ES_PASSWORD))
              SendMessage_(Handle, #EM_SETPASSWORDCHAR, 9679,0)
            EndIf
            If IsFlag(Flags,#PB_String_ReadOnly)   ;Ok
              SetStyle(Handle, (#ES_READONLY))
              SendMessage_(Handle, #EM_SETREADONLY, 1,0)
            EndIf
            If IsFlag(Flags,#PB_String_Numeric)    ;Ok
              SetStyle(Handle, (#ES_NUMBER))
            EndIf
            If IsFlag(Flags,#PB_String_LowerCase)  ;Ok
              SetStyle(Handle, (#ES_LOWERCASE))
            ;  SetGadgetText(Gadget, LCase(GetGadgetText(Gadget)))
            EndIf
            If IsFlag(Flags,#PB_String_UpperCase)  ;Ok 
              SetStyle(Handle, (#ES_UPPERCASE))
              ;SetWindowText_(Handle, UCase(GetWindowText_(Handle)))
              ;SendMessage_(Handle, #EM_SETMODIFY, 1,0)
;               SetGadgetText(Gadget, UCase(GetGadgetText(Gadget)))
            EndIf
            
          Case #PB_GadgetType_Button
            If IsFlag(Flags,#PB_Button_Toggle)     ;Ok
              SetStyle(Handle, (#BS_PUSHLIKE|#BS_CHECKBOX))
              SendMessage_(Handle, #BM_SETCHECK, 1, 0) ; Чтобы видет эфект сразу
            EndIf
            If IsFlag(Flags,#PB_Button_Left)       ;Ok
              SetStyle(Handle, (#BS_LEFT))
            EndIf
            If IsFlag(Flags,#PB_Button_Right)      ;Ok
              SetStyle(Handle, (#BS_RIGHT))
            EndIf
            If IsFlag(Flags,#PB_Button_Default)    ;Ok
              SetStyle(Handle, (#BS_DEFPUSHBUTTON))
            EndIf
            If IsFlag(Flags,#PB_Button_MultiLine)  ;Ok
              SetStyle(Handle, (#BS_MULTILINE))
            EndIf
        EndSelect
      EndProcedure
      
      Procedure RemoveGadget( Gadget, Flags.q )
        Protected Handle = GadgetID(Gadget)
        
        Select GadgetType(Gadget)
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
            EndIf
            If IsFlag(Flags,#PB_String_UpperCase)     ;Ok
              RemoveStyle(Handle, (#ES_UPPERCASE))
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