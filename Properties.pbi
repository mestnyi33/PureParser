;-
;- Module (Properties)
DeclareModule Properties
  EnableExplicit
  Structure PropertiesStruct
    Gadget.i
    Object.i
    CheckGadget.i
    CheckWindow.i
    
    Flag$
    Class$
    
    Tree.i
    Spin.i
    Button.i
    String.i
    ComboBox.i
    TreeWindow.i
    
    ButtonImage.i
    ItemHeight.i
    GadgetType.i
    LinePos.i
    Text.S
    Info.S
    Str.S
    Int.i
    
    Font.i
    Seperator.i
  EndStructure
  
  Global NewList Properties.PropertiesStruct()
  
  Declare UpdatePropertiesItem( Item )
  Declare UpdateProperties( Object, Class$, Flag$ )
  
  Declare Size( Width, Height )
  Declare AddItem( Gadget, Text.S, GadgetType)
  Declare Gadget( Gadget, Width, Height, LinePos = 75 )
EndDeclareModule

Module Properties
  ;UseModule CC_Form
  Declare Events()
  Global LineGadget =- 1
  
  Global IsShow
  Global Style.b = 0
  
  Macro Clip(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Define ClipMacroGadgetHeight = GadgetHeight( Gadget )
        SetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
        If ClipMacroGadgetHeight And GadgetType( Gadget ) = #PB_GadgetType_ComboBox
          ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, ClipMacroGadgetHeight )
        EndIf
    CompilerEndSelect
  EndMacro
  
  Global Font
      
  Procedure SetLayoutLang( kbLayout$ );
    #ENGLISH = "00000409"             ;
    #RUSSIAN = "00000419"             ;
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        
        ;     ;Переключаем на английскую раскладку
        ;     If GetKeyboardLayout_(0) = 68748313 ;- US <-> Rus раскладка
        ;       ActivateKeyboardLayout_(#HKL_NEXT, 0)
        ;     EndIf
        ;     
        ;     ; Переключаем на русскую раскладку 
        ;     If GetKeyboardLayout_(0) = 67699721 ; US раскладка
        ;       ActivateKeyboardLayout_(#HKL_NEXT, 0)
        ;     EndIf
        
        Protected Layout = LoadKeyboardLayout_( kbLayout$, 0 ) ; Получить ссылку на раскладку
        SendMessage_( GetForegroundWindow_(), #WM_INPUTLANGCHANGEREQUEST, 1, Layout ) ; посылаем сообщение о смене раскладки
    CompilerEndSelect
  EndProcedure
  
  Procedure StringProc()
    
    Select EventType()
      Case #PB_EventType_Focus 
        AddKeyboardShortcut( EventWindow(), #PB_Shortcut_Return, 1 )
        
      Case #PB_EventType_LostFocus 
        RemoveKeyboardShortcut( EventWindow(), #PB_Shortcut_Return )
        
    EndSelect
    
  EndProcedure
  
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      
      #G_TYPE_STRING = 64
      
      ImportC ""
        gtk_widget_get_visible(*widget.GtkWidget)
        gtk_widget_get_sensitive (*widget.GtkWidget)
        g_object_get_Properties(*widget.GtkWidget, Properties.p-utf8, *gval)
      EndImport
      
  CompilerEndSelect
  
  Procedure.S FontName( FontID )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows 
        Protected sysFont.LOGFONT
        GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
        ProcedureReturn PeekS(@sysFont\lfFaceName[0])
        
      CompilerCase #PB_OS_Linux
        Protected gVal.GValue
        Protected.s StdFnt
        g_value_init_( @gval, #G_TYPE_STRING )
        g_object_get_Properties( gtk_settings_get_default_(), "gtk-font-name", @gval )
        StdFnt = PeekS( g_value_get_string_( @gval ), -1, #PB_UTF8 )
        g_value_unset_( @gval )
        ProcedureReturn StdFnt 
        
    CompilerEndSelect
  EndProcedure
  
  Procedure FontSize( FontID )
    CompilerSelect #PB_Compiler_OS 
      CompilerCase #PB_OS_Windows 
        Protected sysFont.LOGFONT
        GetObject_(FontID, SizeOf(LOGFONT), @sysFont)
        ProcedureReturn MulDiv_(-sysFont\lfHeight, 72, GetDeviceCaps_(GetDC_(#NUL), #LOGPIXELSY))
        
      CompilerCase #PB_OS_Linux
        Protected   gVal.GValue
        Protected.s StdFnt
        g_value_init_(@gval, #G_TYPE_STRING)
        g_object_get_Properties( gtk_settings_get_default_(), "gtk-font-name", @gval)
        StdFnt= PeekS(g_value_get_string_(@gval), -1, #PB_UTF8)
        g_value_unset_(@gval)
        ProcedureReturn Val(StringField((StdFnt), 2, " "))
        
    CompilerEndSelect
  EndProcedure
  
  Procedure IsHideGadget(Gadget) ;Returns TRUE is gadget hide
    
    If IsGadget(Gadget)
      Protected GadgetID = GadgetID(Gadget)
      
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows 
          ProcedureReturn Bool(IsWindowVisible_(GadgetID)=0)
          
        CompilerCase #PB_OS_Linux
          Protected *Widget.GtkWidget = GadgetID
          If (GadgetType(Gadget) = #PB_GadgetType_Container Or
              GadgetType(Gadget) = #PB_GadgetType_Panel)
            GadgetID = *Widget\parent
          Else  
            GadgetID = *Widget\object
          EndIf
          
          ProcedureReturn Bool(gtk_widget_get_visible(GadgetID)=0)
      CompilerEndSelect
    EndIf
  EndProcedure
  
  Procedure IsDisableGadget(Gadget) ;Returns TRUE is gadget disabled
    If IsGadget(Gadget)
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows 
          ProcedureReturn Bool(IsWindowEnabled_(GadgetID(Gadget))=0)
          
        CompilerCase#PB_OS_Linux
          ProcedureReturn Bool(gtk_widget_get_sensitive(GadgetID(Gadget))=0)
          
      CompilerEndSelect
    EndIf
  EndProcedure
  
  Procedure IsHideWindow(Window) ;Returns TRUE is window hide
    If IsWindow(Window)
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows 
          ProcedureReturn Bool(IsWindowVisible_(WindowID(Window))=0)
          
        CompilerCase #PB_OS_Linux
          ProcedureReturn Bool(gtk_widget_get_visible(WindowID(Window))=0)
          
      CompilerEndSelect
    EndIf
  EndProcedure
  
  Procedure IsDisableWindow(Window) ;Returns TRUE is window disabled
    If IsWindow(Window)
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows 
          ProcedureReturn Bool(IsWindowEnabled_(WindowID(Window))=0)
          
        CompilerCase#PB_OS_Linux
          ProcedureReturn Bool(gtk_widget_get_sensitive(WindowID(Window))=0)
          
      CompilerEndSelect
    EndIf
  EndProcedure
  
  Procedure$ Flag( Type )
      Protected Flags.S
      
      #PB_GadgetType_Window = -1
      #PB_GadgetType_Menu = -2
      #PB_GadgetType_Toolbar = -3
      #PB_GadgetType_ImageButton = 34
      
      Select Type
        Case #PB_GadgetType_Window        
          ;{- Ok
          Flags.S = "#PB_Window_SystemMenu|"+
                    "#PB_Window_TitleBar|"+
                    "#PB_Window_BorderLess|"+
                    "#PB_Window_Invisible|"+
                    "#PB_Window_SizeGadget|"+
                    "#PB_Window_MaximizeGadget|"+
                    "#PB_Window_MinimizeGadget|"+
                    "#PB_Window_ScreenCentered|"+
                    "#PB_Window_WindowCentered|"+
                    "#PB_Window_Tool|"+
                    "#PB_Window_Normal|"+
                    "#PB_Window_Minimize|"+
                    "#PB_Window_Maximize|"+
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
          
        Case #PB_GadgetType_MDI           
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            Flags.S = ""
          CompilerEndIf
          
        Case #PB_GadgetType_Scintilla      
          Flags.S = ""
          
        Case #PB_GadgetType_Shortcut       
          Flags.S = ""
          
        Case #PB_GadgetType_Canvas 
          ;{- Ok
          Flags.S = "#PB_Canvas_Border|"+
                    "#PB_Canvas_ClipMouse|"+
                    "#PB_Canvas_Keyboard|"+
                    "#PB_Canvas_DrawFocus"
          ;}
          
      EndSelect
      ;"#PB_Flag_None|"+
      ProcedureReturn Flags.S
    EndProcedure
    
  Procedure Update( Object )
    Protected Color
    
    With Properties()
      If IsGadget( Object ) 
        Select Trim(\Info.S)
            ;Case "ID:"   : SetGadgetText(\String, Str(Object))
          Case "Text:"   : SetGadgetText(\String, GetGadgetText(Object))
            
          Case "Hide:"   : SetGadgetState(\ComboBox, IsHideGadget(Object))
          Case "Disable:": SetGadgetState(\ComboBox, IsDisableGadget(Object))
          Case "Font:"   : SetGadgetText(\String, "("+ Str(FontSize( GetGadgetFont(Object) )) +") "+ FontName( GetGadgetFont(Object) ) )   
          Case "Color:"  : Color = GetGadgetColor( Object, #PB_Gadget_BackColor )
            ;             If Color =- 1
            ;               DisableGadget( \Button, 1) 
            ;               DisableGadget( \String, 1) 
            ;               SetGadgetText(\String, " False")
            ;             Else
            DisableGadget( \Button, 0) 
            DisableGadget( \String, 0) 
            SetGadgetText(\String, " "+Str(Red(Color))+";"+Str(Blue(Color))+";"+Str(Green(Color)))
            ;             EndIf
            
          Case "X:"      : SetGadgetState(\Spin, GadgetX(Object))
          Case "Y:"      : SetGadgetState(\Spin, GadgetY(Object))
          Case "Width:"  : SetGadgetState(\Spin, GadgetWidth(Object))
          Case "Height:" : SetGadgetState(\Spin, GadgetHeight(Object))
            
        EndSelect
        
      ElseIf IsWindow( Object )  
        Select Trim(\Info.S)
          Case "ID:"   : SetGadgetText(\String, Str(Object))
            ;Case "Type:"   : SetGadgetText(\String, "Open"+CC_Class(-1)+"()")
          Case "Text:"   : SetGadgetText(\String, GetWindowTitle(Object))
            
          Case "Hide:"   : SetGadgetState(\ComboBox, IsHideWindow(Object))
          Case "Disable:": SetGadgetState(\ComboBox, IsDisableWindow(Object))
          Case "Font:"   : SetGadgetText(\String, "("+ Str(FontSize( GetGadgetFont(#PB_Default) )) +") "+  FontName( GetGadgetFont(#PB_Default)) )   
          Case "Color:"  : Color = GetWindowColor(Object)
            
            ;               If Color =- 1
            ;                 DisableGadget( \Button, 1) 
            ;                 DisableGadget( \String, 1) 
            ;                 SetGadgetText(\String, " False")
            ;               Else
            DisableGadget( \Button, 0) 
            DisableGadget( \String, 0) 
            SetGadgetText(\String, " "+Str(Red(Color))+";"+Str(Blue(Color))+";"+Str(Green(Color)))
            ;               EndIf
            
          Case "X:"      : SetGadgetState(\Spin, WindowX(Object))
          Case "Y:"      : SetGadgetState(\Spin, WindowY(Object))
          Case "Width:"  : SetGadgetState(\Spin, WindowWidth(Object))
          Case "Height:" : SetGadgetState(\Spin, WindowHeight(Object))
        EndSelect
      EndIf
      
      Select Trim(\Info.S)
        Case "Flag:"   
          Protected IC, Len, height
          If IsGadget(\Tree)
            If IsGadget(Object)
              \Text = Flag(GadgetType(Object))
            ElseIf IsWindow(Object)
              \Text = Flag(-1)
            EndIf
            
            ClearGadgetItems(\Tree)
            
            For IC=0 To CountString(\Text.S,"|")
              If Trim(StringField(\Text.S,IC+1,"|"))
                If Len<Len(Trim(StringField(\Text.S,IC+1,"|")))
                  Len=Len(Trim(StringField(\Text.S,IC+1,"|")))
                EndIf
                AddGadgetItem(\Tree,-1,Trim(StringField(\Text.S,IC+1,"|")))
              EndIf
            Next
            
            height = (IC*17) : If height>100 : height = 100 : EndIf
            
            If height
              ResizeWindow(\TreeWindow, #PB_Ignore, #PB_Ignore, len*8, height)
              ResizeGadget(\Tree, #PB_Ignore, #PB_Ignore, WindowWidth(\TreeWindow), WindowHeight(\TreeWindow))
            EndIf
          EndIf
      EndSelect
    EndWith
    
  EndProcedure
  
  Procedure Change( Object )
    
    With Properties()
      If IsGadget( Object ) 
        Select Trim(\Info.S)
            ;Case "Type:"   : SetGadgetText(\String, Class(GadgetType(Object)) + "Gadget()")
          Case "Text:"   
            Select GadgetType( Object )
              Case #PB_GadgetType_ComboBox
                AddGadgetItem(Object, - 1, GetGadgetText(\String))
                SetGadgetState(Object, CountGadgetItems(Object) - 1)
                ;RemoveGadgetItem(\CheckGadget,CountGadgetItems(\CheckGadget) - 1)
                
              Case #PB_GadgetType_Shortcut
                SetGadgetState(Object, GetGadgetState( \String )) ;Asc(UCase(GetGadgetText(\String))))
              Case #PB_GadgetType_IPAddress
                SetGadgetState(Object, GetGadgetState( \String )) 
                
              Default
                SetGadgetText(Object, GetGadgetText(\String))
            EndSelect
            
          Case "Disable:": DisableGadget( Object, GetGadgetState( \ComboBox ))
          Case "Hide:"   : HideGadget( Object, GetGadgetState( \ComboBox ))
          Case "Color:"  : SetGadgetColor( Object, #PB_Gadget_BackColor, ColorRequester() )
          Case "Font:"   : FontRequester( "Arial", 8, #PB_FontRequester_Effects) 
            \Str.S = SelectedFontName()
            SetGadgetFont( Object, FontID( LoadFont( #PB_Any, \Str.S, SelectedFontSize(), SelectedFontStyle() ) ) )
            
            
          Case "X:"      : ResizeGadget( Object, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Case "Y:"      : ResizeGadget( Object, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore )
          Case "Width:"  : ResizeGadget( Object, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore )
          Case "Height:" : ResizeGadget( Object, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin) )
        EndSelect
        
      ElseIf  IsWindow( Object ) 
        Select Trim(\Info.S)
            ;Case "Type:"   : SetGadgetText(\String, "Open"+Class(-1)+"()")
          Case "Text:"   : SetWindowTitle( Object, GetGadgetText(\String))
            
          Case "Disable:": DisableWindow( Object, GetGadgetState( \ComboBox ))
          Case "Hide:"   : HideWindow( Object, GetGadgetState( \ComboBox ))
          Case "Color:"  : SetWindowColor( Object, ColorRequester() ) : \Int = GetWindowColor( Object ) ;: SetWindowPoint( Object )
          Case "Font:"   : FontRequester( FontName( GetGadgetFont(#PB_Default) ), 8, #PB_FontRequester_Effects)
            \Str.S = SelectedFontName()
            SetGadgetFont( #PB_Default, FontID( LoadFont( #PB_Any, \Str.S, SelectedFontSize(), SelectedFontStyle() ) ) )
            
            
          Case "X:"      : ResizeWindow( Object, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore, #PB_Ignore )
          Case "Y:"      : ResizeWindow( Object, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore, #PB_Ignore )
          Case "Width:"  : ResizeWindow( Object, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin), #PB_Ignore )
          Case "Height:" : ResizeWindow( Object, #PB_Ignore, #PB_Ignore, #PB_Ignore, GetGadgetState(\Spin) )
        EndSelect
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure UpdatePropertiesItem( Item )
    SelectElement( Properties(), Item )
    Update( Properties()\Object )
  EndProcedure
  
  Procedure UpdateProperties( Object, Class$, Flag$ )
    Static CheckObject =- 1
    
    With Properties()
      If CheckObject <> Object
        ForEach Properties()
          \Object = Object
          \Class$ = Class$
          \Flag$ = Flag$
          
          Update( Object )
        Next
        CheckObject = Object
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure Events()
    Static Window=-1, Gadget=-1, Click
    
    Select Event()
      Case #PB_Event_DeactivateWindow 
        If IsGadget(Gadget)
          Protected MouseX = DesktopMouseX()
          Protected MouseY = DesktopMouseY()
          Protected GadgetX = GadgetX(Gadget ,#PB_Gadget_ScreenCoordinate)
          Protected GadgetY = GadgetY(Gadget ,#PB_Gadget_ScreenCoordinate)
          Protected GadgetWidth = GadgetX + GadgetWidth(Gadget)
          Protected GadgetHeight = GadgetY + GadgetHeight(Gadget)
          
          If Not Bool(MouseX >= GadgetX And MouseY >= GadgetY And  
                      MouseX =< GadgetWidth And MouseY =< GadgetHeight)
            PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_LeftClick)
          EndIf
        EndIf
        
      Case #PB_Event_Gadget
        ForEach Properties()
          With Properties()
            Select EventGadget()
              Case \String
                ;   #PB_EventType_Change    : The Text has been modified by the user.
                ;   #PB_EventType_Focus     : The StringGadget got the focus.
                ;   #PB_EventType_LostFocus : The StringGadget lost the focus.
                Select EventType()
                  Case #PB_EventType_LeftClick
                    Change( \Object )
                    Update( \Object )
                    
                  Case #PB_EventType_Change
                    Change( \Object )
                    
                    ;                Case  #PB_EventType_LeftClick ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \String )
                  Case #PB_EventType_Focus ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Focus, \String )
                    \Str = GetGadgetText(\String) ; Запоминаем на тот случай если данные пусти чтобы возвратить исходние
                    
                  Case #PB_EventType_LostFocus ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_LostFocus, \String )
                    If GetGadgetText(\String) = "" : SetGadgetText(\String, \Str ) : EndIf ; Вот тут и понадобятся данные
                    
                    Change( \Object )
                    
                EndSelect
                
              Case \ComboBox
                ;   #PB_EventType_Change    : The current selection of the Text in the edit field changed.
                ;   #PB_EventType_Focus     : The edit field received the keyboard focus (editable ComboBox only).
                ;   #PB_EventType_LostFocus : The edit field lost the keyboard focus (editable ComboBox only).
                Select EventType()
                  Case #PB_EventType_LeftClick
                    Change( \Object )
                    Update( \Object )
                    
                  Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \ComboBox )
                    Change( \Object )
                    
                    ;               Case #PB_EventType_Focus : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Focus, \ComboBox )
                    ;               Case #PB_EventType_LostFocus : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_LostFocus, \ComboBox )
                    
                EndSelect
                
              Case \Spin
                ;   #PB_EventType_Change : The Text in the edit area has been modified by the user.
                ;   #PB_EventType_Up     : The 'Up' button was pressed.
                ;   #PB_EventType_Down   : The 'Down' button was pressed.
                Select EventType()
                  Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \Spin )
                    Change( \Object )
                    
                  Case #PB_EventType_Up ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Up, \Spin )
                  Case #PB_EventType_Down ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Down, \Spin )
                    
                EndSelect
                
              Case \Tree
                ;   #PB_EventType_LeftClick : Клик левой кнопкой мыши на элементе, или галочка на чек-боксе установлена/снята. 
                ;   #PB_EventType_LeftDoubleClick : Двойной клик левой кнопкой мыши на элементе.
                ;   #PB_EventType_RightClick : Клик правой кнопкой мыши на элементе
                ;   #PB_EventType_RightDoubleClick : Двойной Клик левой кнопкой мыши на элементе.
                ;   #PB_EventType_Change: Текущий элемент изменен.
                ;   #PB_EventType_DragStart: Пользователь попытался запустить операцию Drag & Drop.
                Select EventType()
                  Case #PB_EventType_Focus 
;                        \Flag$ = "#PB_Window_SystemMenu|#PB_Window_ScreenCentered"
                    Protected i,ii
                    For i=0 To CountString(\Flag$, "|")
                      For ii=0 To CountGadgetItems(\Tree)-1
                        If GetGadgetItemText(\Tree, ii) = Trim( StringField( \Flag$, (i + (1)), "|"))
                          SetGadgetItemState(\Tree, ii, #PB_Tree_Checked) 
                        EndIf
                      Next
                    Next
                    
                  Case #PB_EventType_LostFocus 
                    Protected iii, Text$
                    For iii=0 To CountGadgetItems(\Tree)-1
                      If GetGadgetItemState(\Tree, iii) & #PB_Tree_Checked  
                        Text$ + GetGadgetItemText(\Tree, iii)+"|"
                      EndIf
                    Next
                    Text$ = Trim(Text$, "|")
                    SetGadgetText(\String, Text$)
                    
                          
                  Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \Tree )
                    Change( \Object )
                    
                EndSelect
                
              Case \Button
                Select EventType()
                  Case #PB_EventType_LeftClick 
                    If GadgetType(GetGadgetData(\Button)) = #PB_GadgetType_Tree
                      If CountGadgetItems(\Tree) : Click!1
                        If Click
                          Gadget = EventGadget()
                          Window = EventWindow()
                          HideWindow(\TreeWindow, #False)
                          PostEvent(#PB_Event_Gadget, Window, \Tree, #PB_EventType_Focus, Gadget )
                          ResizeWindow(\TreeWindow, (GadgetX(\Button, #PB_Gadget_ScreenCoordinate)+GadgetWidth(\Button))-GadgetWidth(\Tree)-1, GadgetY(\Button, #PB_Gadget_ScreenCoordinate)+GadgetHeight(\Button), #PB_Ignore, #PB_Ignore)
                        Else
                          PostEvent(#PB_Event_Gadget, Window, \Tree, #PB_EventType_LostFocus, Gadget )
                          HideWindow(\TreeWindow, #True)
                          Window=-1 
                          Gadget=-1
                        EndIf
                      EndIf
                    Else
                      PostEvent(#PB_Event_Gadget, EventWindow(), GetGadgetData(\Button), #PB_EventType_LeftClick, \Button )
                    EndIf
                EndSelect
            EndSelect
          EndWith
        Next
    EndSelect
    
  EndProcedure
  
  Procedure Size( Width, Height )
    If ListSize(Properties())
      With Properties()
        If IsGadget(\Gadget)
          ResizeGadget( \Gadget, #PB_Ignore,#PB_Ignore, Width, Height )
          
          If GetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerHeight)  > GadgetHeight(\Gadget) - 2
            SetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerWidth, GadgetWidth(\Gadget) - 20)
          Else
            SetGadgetAttribute(\Gadget, #PB_ScrollArea_InnerWidth, GadgetWidth(\Gadget) - 4)
          EndIf
          
          ForEach Properties()
            Protected LinePos = #PB_Ignore
            If \LinePos <> GadgetWidth(LineGadget)
              \LinePos = GadgetWidth(LineGadget)
              LinePos = \LinePos
            EndIf
            Protected W = GetGadgetAttribute(\Gadget,#PB_ScrollArea_InnerWidth)-\LinePos
            
            If IsGadget(\Button)
              W-(GadgetWidth(\Button) - 1)
              ResizeGadget(\Button, (\LinePos+W),#PB_Ignore,#PB_Ignore,#PB_Ignore)
            EndIf
            
            If IsGadget(\Spin)
              ResizeGadget(\Spin, LinePos,#PB_Ignore,W,#PB_Ignore)
            EndIf
            
            If IsGadget(\ComboBox)
              ResizeGadget(\ComboBox, LinePos,#PB_Ignore,W,#PB_Ignore)
            EndIf
            
            If IsGadget(\String)
              ResizeGadget(\String , LinePos,#PB_Ignore,W,#PB_Ignore)
            EndIf
            
            If IsGadget(\Tree)
              ResizeGadget(\Tree, LinePos,#PB_Ignore,W,#PB_Ignore)
            EndIf
            
            
          Next
          
        EndIf
      EndWith
    EndIf
  EndProcedure 
  
  Procedure Repaint()
    Protected X,Width 
    
    With Properties()
      Protected Y = ListIndex(Properties()) * \ItemHeight
      
      If \Font = #False
        \Font = GetGadgetFont(#PB_Default)
        \Font = LoadFont(#PB_Any, PeekS(@\Font)  ,  10, #PB_Font_Bold )
      EndIf
      
      X = 16
      Width = GadgetWidth(LineGadget)
      
      
      If StartDrawing(CanvasOutput(LineGadget))
        ;ClipOutput(0,Y,X+1,OutputHeight())
        DrawingMode(#PB_2DDrawing_Default)
        Box(0,Y,X+1,OutputHeight(), $E7E7E7)
        
        If ListIndex(Properties()) = \Seperator
          ClipOutput(2,Y,Width,\ItemHeight)
          DrawingMode(#PB_2DDrawing_Default)
          Box(X,Y,Width,\ItemHeight, $F0F0F0)
          ;Line(X,Y,1,\ItemHeight,$C0C0C0)
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(2,Y+(\ItemHeight-12)/2,12,12, 0)
          Line(5,Y+(\ItemHeight-12)/2+6,6,1,0)
          
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawingFont(FontID(\Font) )
          DrawText(X+3,Y+3,\Info.S,0)
          
          
        Else
          ClipOutput(X,Y+1,Width-1,\ItemHeight-1)
          DrawingMode(#PB_2DDrawing_Default)
          Box(X+1,Y+2,Width-17-2,\ItemHeight-2, $F5F5F5)
          
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawingFont(FontID(\Font))
          DrawText(Width-5-TextWidth(\Info.S),Y+TextHeight(\Info.S)/3,\Info.S,0)
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(X,Y+1,Width-17,\ItemHeight-1, $A9A9A9)
        EndIf
        
        StopDrawing()
      EndIf
    EndWith    
  EndProcedure
  
  Procedure EventSplitter()
    Static SplitterGadget =-1
    Select EventType()
      Case #PB_EventType_LeftButtonDown 
        If GetGadgetAttribute(EventGadget(),#PB_Canvas_MouseX) >= GadgetWidth(EventGadget())-3
          SplitterGadget = EventGadget() 
        EndIf
        
        ;         CompilerSelect #PB_Compiler_OS
        ;           CompilerCase #PB_OS_Windows
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE) | #WS_CLIPCHILDREN)
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE) | #WS_EX_COMPOSITED)
        ;             
        ;         CompilerEndSelect
        
      Case #PB_EventType_LeftButtonUp  
        If IsGadget(SplitterGadget) 
          SplitterGadget =-1
        EndIf
        ;         CompilerSelect #PB_Compiler_OS
        ;           CompilerCase #PB_OS_Windows
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_STYLE) &~ #WS_CLIPCHILDREN)
        ;             SetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID(Properties()\Gadget), #GWL_EXSTYLE) &~ #WS_EX_COMPOSITED)
        ;             
        ;         CompilerEndSelect
        
      Case #PB_EventType_MouseMove
        If IsGadget(SplitterGadget)
          ResizeGadget(SplitterGadget,#PB_Ignore,#PB_Ignore,WindowMouseX(EventWindow())-GadgetX(Properties()\Gadget, #PB_Gadget_WindowCoordinate),#PB_Ignore)
          Size( #PB_Ignore,#PB_Ignore )
          ForEach Properties()
            Repaint()
          Next
          
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              RedrawWindow_(WindowID(EventWindow()), 0, 0, #RDW_ALLCHILDREN|#RDW_UPDATENOW)
          CompilerEndSelect
        EndIf
        
        ;
        If GetGadgetAttribute(EventGadget(),#PB_Canvas_MouseX) >= GadgetWidth(EventGadget())-3
          SetGadgetAttribute(EventGadget(),#PB_Canvas_Cursor,#PB_Cursor_LeftRight)
        Else
          SetGadgetAttribute(EventGadget(),#PB_Canvas_Cursor,#PB_Cursor_Default)
        EndIf
        
    EndSelect
    
  EndProcedure 
  
  Procedure Gadget( Gadget, Width, Height, LinePos = 75 )
    Shared LineGadget
    Gadget = ScrollAreaGadget( #PB_Any,0,0,Width,Height, Width,Height,0,#PB_ScrollArea_Single)
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected ParentID = GadgetID(Gadget)
        If FindWindowEx_( FindWindowEx_( ParentID, 0,0,0 ), 0,0,0 ) ; ScrollArea
          ParentID = FindWindowEx_( ParentID, 0,0,0 )
        EndIf
        SetWindowLongPtr_(ParentID, #GWL_STYLE, GetWindowLongPtr_(ParentID, #GWL_STYLE) | #WS_CLIPCHILDREN)
        SetWindowLongPtr_(ParentID, #GWL_EXSTYLE, GetWindowLongPtr_(ParentID, #GWL_EXSTYLE) | #WS_EX_COMPOSITED)
    CompilerEndSelect
    
    LineGadget = CanvasGadget( #PB_Any, 0,0,LinePos,0)
    Clip(LineGadget)
    BindGadgetEvent(LineGadget,@EventSplitter())
    
    CloseGadgetList()
    ProcedureReturn Gadget
  EndProcedure 
  
  Procedure AddItem( Gadget, Text.S, GadgetType)
    Protected Y,W,Width, Result =- 1
    If OpenGadgetList( Gadget )
      AddElement(Properties())
      With Properties()
        
        CompilerSelect #PB_Compiler_OS
          CompilerCase #PB_OS_Windows
            \ItemHeight = 24
          CompilerCase #PB_OS_Linux
            \ItemHeight = 34;GadgetHeight(LineGadget)
        CompilerEndSelect
        Font = LoadFont(#PB_Any,"Consolas",8 ) 
        \Font=Font
        
        Y = ListIndex(Properties()) * \ItemHeight
        \LinePos = GadgetWidth(LineGadget)
        
        SetGadgetAttribute(Gadget, #PB_ScrollArea_InnerHeight, ListSize(Properties()) * \ItemHeight)
        ResizeGadget(LineGadget,#PB_Ignore,#PB_Ignore,#PB_Ignore,GetGadgetAttribute(Gadget,#PB_ScrollArea_InnerHeight))
        
        Protected Bw = 19
        Width = GetGadgetAttribute(Gadget,#PB_ScrollArea_InnerWidth) - \LinePos 
        
        
        \GadgetType = GadgetType
        \Gadget = Gadget
        
        \Seperator =- 1
        \ComboBox =- 1
        \Spin =- 1
        \String =- 1
        \Button =- 1
        
        
        ;{ - Здесь происходит разделение текста
        Protected IT.I,String.S,Character.C = ':'
        Protected CountString.I = CountString( Text.S, Chr(Character))
        If CountString
          For IT = 0 To CountString
            String.S = Trim( StringField( Text.S, (IT + (1)), Chr(Character)))
            If String.S
              If IT
                \Text.S = String.S
              Else
                \Info.S = String.S + ":"
              EndIf
            EndIf
          Next
        Else
          \Info.S = Text.S+":"
        EndIf
        ;}
        
        If ((GadgetType & #PB_GadgetType_Tree) = #PB_GadgetType_Tree)
          Protected UseGadgetList
          CloseGadgetList()
          UseGadgetList = UseGadgetList(0)
          \TreeWindow = OpenWindow(#PB_Any, \LinePos,Y + 1,Width, 100, "", #PB_Window_BorderLess|#PB_Window_NoActivate|#PB_Window_Invisible)
          \Tree = TreeGadget(#PB_Any, 0,0,0,0, #PB_Tree_NoLines|#PB_Tree_NoButtons|#PB_Tree_CheckBoxes) : Result = \Tree
          BindEvent(#PB_Event_DeactivateWindow, @Events(), \TreeWindow)
          StickyWindow(\TreeWindow, #True)
          SetGadgetFont(\Tree, FontID(Font))
          ;BindGadgetEvent(\Tree, @Events())
          BindEvent(#PB_Event_Gadget, @Events(), GetActiveWindow(), \Tree)
          UseGadgetList(UseGadgetList)
          OpenGadgetList( Gadget )
          Clip(\Tree) 
          
          \String = StringGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,\Text.S) :Clip(\String) ; : Result = \String
          BindGadgetEvent(\String,@Events())
          SetGadgetFont(\String, FontID(Font))
          
        ElseIf ((GadgetType & #PB_GadgetType_Spin) = #PB_GadgetType_Spin)
          \Spin = SpinGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,-32767,32767,#PB_Spin_Numeric) : Result = \Spin
          CompilerSelect #PB_Compiler_OS
            CompilerCase #PB_OS_Windows
              SetWindowLongPtr_( GetWindow_(GadgetID( \Spin ), #GW_HWNDNEXT), #GWL_STYLE, GetWindowLongPtr_( GetWindow_(GadgetID( \Spin ), #GW_HWNDNEXT), #GWL_STYLE )|#WS_CLIPSIBLINGS )
              SetWindowLongPtr_( GadgetID( \Spin ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( \Spin ), #GWL_STYLE )|#WS_CLIPSIBLINGS|#SS_CENTER )
          CompilerEndSelect
          BindGadgetEvent(\Spin, @Events())
          SetGadgetFont(\Spin, FontID(Font))
        
        ElseIf ((GadgetType & #PB_GadgetType_ComboBox) = #PB_GadgetType_ComboBox)
          Protected IC 
          \ComboBox = ComboBoxGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1) :Clip(\ComboBox): Result = \ComboBox
          For IC=0 To CountString(\Text.S,"|")
            If Trim(StringField(\Text.S,IC+1,"|"))
              AddGadgetItem(\ComboBox,-1,Trim(StringField(\Text.S,IC+1,"|")))
            EndIf
          Next
          SetGadgetState(\ComboBox, 0)
          BindGadgetEvent(\ComboBox,@Events())
          SetGadgetFont(\ComboBox, FontID(Font))
        
        ElseIf ((GadgetType & #PB_GadgetType_String) = #PB_GadgetType_String)
          \String = StringGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,\Text.S) :Clip(\String): Result = \String
          BindGadgetEvent(\String,@Events())
          SetGadgetFont(\String, FontID(Font))
          
        Else
          \Seperator = ListIndex(Properties())
        EndIf
        
        
        If ((GadgetType & #PB_GadgetType_Button) = #PB_GadgetType_Button)
          If ((GadgetType & #PB_GadgetType_Tree) = #PB_GadgetType_Tree)
            \Button = ButtonGadget(#PB_Any, (\LinePos+Width-Bw),Y,Bw + 1,\ItemHeight + 1,"v") :Clip(\Button)
            SetGadgetFont(\Button, FontID(Font))
          Else
            \Button = ButtonGadget(#PB_Any, (\LinePos+Width-Bw),Y,Bw + 1,\ItemHeight + 1,"...") :Clip(\Button)
          EndIf
          BindGadgetEvent(\Button, @Events())
          SetGadgetData(\Button, Result)
        EndIf
        
        SetGadgetData(\Gadget, Properties())
        
        PushListPosition(Properties())
        Size( GadgetWidth(\Gadget), GadgetHeight(\Gadget))
        Repaint()
        PopListPosition(Properties())
      EndWith
      CloseGadgetList()
    EndIf
    
    ProcedureReturn Result ; ListSize(Properties()) - 1
  EndProcedure 
  
EndModule

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Global.i Window_0=-1, 
        Window_0_Properties=-1
  
  Enumeration Gadget
    #Window_0_Button_1
  EndEnumeration
  
  Declare Window_0_Event()
  Declare Window_0_Size_Event()
  
  Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_SizeGadget)
    If Not IsWindow(Window_0)
      Window_0 = OpenWindow(#PB_Any,230,230,200,200,"Window_0", Flag)
      Window_0_Properties = Properties::Gadget( #PB_Any, 200,200 )
      
      Properties::AddItem( Window_0_Properties, "ID:", #PB_GadgetType_String )
      Properties::AddItem( Window_0_Properties, "Text:", #PB_GadgetType_String )
      Properties::AddItem( Window_0_Properties, "Disable:False|True", #PB_GadgetType_ComboBox )
      Properties::AddItem( Window_0_Properties, "Hide:False|True", #PB_GadgetType_ComboBox )
      
      Properties::AddItem( Window_0_Properties, "Layouts:", #False )
      Properties::AddItem( Window_0_Properties, "X:", #PB_GadgetType_Spin )
      Properties::AddItem( Window_0_Properties, "Y:", #PB_GadgetType_Spin )
      Properties::AddItem( Window_0_Properties, "Width:", #PB_GadgetType_Spin )
      Properties::AddItem( Window_0_Properties, "Height:", #PB_GadgetType_Spin )
      
      Properties::AddItem( Window_0_Properties, "Other:", #False )
      Properties::AddItem( Window_0_Properties, "Flag:", #PB_GadgetType_Tree|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Font:", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Image:", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Puth", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( Window_0_Properties, "Color:", #PB_GadgetType_String|#PB_GadgetType_Button )
      
      BindEvent(#PB_Event_SizeWindow, @Window_0_Size_Event(), Window_0)
      BindEvent(#PB_Event_Gadget, @Window_0_Event(), Window_0)
    EndIf
    ProcedureReturn Window_0
  EndProcedure
  
  Procedure Window_0_Size_Event()
    Protected WindowWidth = WindowWidth(Window_0)
    Protected WindowHeight = WindowHeight(Window_0)
    Properties::Size(WindowWidth, WindowHeight)
  EndProcedure
  
  Procedure Window_0_Event()
    Select Event()
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftClick
            Select EventGadget()
                
            EndSelect
        EndSelect
    EndSelect
  EndProcedure
  
  
  Window_0_Open()
  
  While IsWindow(Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf


