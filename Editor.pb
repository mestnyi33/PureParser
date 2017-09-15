;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
;
; Regex Trim(Arguments)
; https://regex101.com/r/zxBLgG/2
; ~"((?:(?:\".*?\")|(?:\\(.*?\\))|[^,])+)"
; ~"(?:\"(?:.*?)\"|(?:\\w*)\\s*\\((?:(?>[^()]+|(?R))*)\\)|[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\])+"
; #Button_0, ReadPreferenceLong("x", WindowWidth(#Window_0)/WindowWidth(#Window_0)+20), 20, WindowWidth(#Window_0)-(390-155), WindowHeight(#Window_0) - 180 * 2, GetWindowTitle(#Window_0) + Space( 1 ) +"("+ "Button" + "_" + Str(1)+")"

; Regex Trim(Captions)
; https://regex101.com/r/3TwOgS/1
; ~"((?:\"(.*?)\"|\\((.*?)\\)|[^+\\s])+)"
; ~"(?:(\\w*)\\s*\\(((?>[^()\"]+|(?R))+)\\))|\"(.*?)\"|[^+\\s]+"
; ~"(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^()\"]+|(?R))+)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\/])|([\\*])|([\\-])|([\\+])"
; ~"(?:(?:\"(.*?)\"|(\\w*)\\s*\\(((?>[^()\"]+|(?R))*)\\))|([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+)|([\\/])|([\\*])|([\\-])|([\\+]))"
; Str(ListIndex(List( )))+"Число между"+Chr(10)+"это 2!"+
; ListIndex(List()) ; вот так не работает

EnableExplicit

Global MainWindow=-1
Global Window_0=-1, 
       Window_0_Menu_0, 
       Window_0_Tree_0, 
       Window_0_Tree_1, 
       Window_0_Panel_0,
       Window_0_Splitter_0

Global Window_0_Properties
Global Properties_Gadget_X 
Global Properties_Gadget_Y 
Global Properties_Gadget_Width
Global Properties_Gadget_Height

Global Window_0_Menu_0_New=1,
       Window_0_Menu_0_Open=2,
       Window_0_Menu_0_Save=3,
       Window_0_Menu_0_Save_as=4,
       Window_0_Menu_0_Close=5
    
Declare Window_Event()
Declare Window_0_Resize_Event()
Declare Window_0_Panel_0_Resize_Event()

XIncludeFile "Transformation.pbi"

DeclareModule Properties
  EnableExplicit
  Structure PropertiesStruct
    Gadget.i
    Object.i
    CheckGadget.i
    CheckWindow.i
    Str.S
    Int.i
    
    ComboBox.i
    String.i
    Button.i
    ButtonImage.i
    ItemHeight.i
    GadgetType.i
    LinePos.i
    Text.S
    Info.S
    Spin.i
    
    Font.i
    Seperator.i
  EndStructure
  
  Global NewList Properties.PropertiesStruct()
  
  Declare UpdatePropertiesItem( Item )
  Declare UpdateProperties( Object )
  
  Declare Size( Width, Height )
  Declare AddItem( Gadget, Text.S, GadgetType)
  Declare Gadget( Gadget, Width, Height, LinePos = 95 )
EndDeclareModule

Module Properties
  ;UseModule CC_Form
  Declare Events()
  Global LineGadget =- 1
  
  Global IsShow
  Global Style.b = 0
  
  Procedure SetLayoutLang( kbLayout$ );
    #ENGLISH = "00000409"                    ;
    #RUSSIAN = "00000419"                    ;
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

  ;-
  CompilerSelect #PB_Compiler_OS 
    CompilerCase #PB_OS_Linux
      
      #G_TYPE_STRING = 64
      
      ImportC ""
        g_object_get_Properties(*widget.GtkWidget, Properties.p-utf8, *gval)
      EndImport
  CompilerEndSelect

  ;-
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
  
  ;-
  Procedure Update( Object )
    Protected Color
         
    With Properties()
      If IsGadget( Object ) 
        Select Trim(\Info.S)
          Case "ID:"   : SetGadgetText(\String, Str(Object))
          ;Case "Type:"   : SetGadgetText(\String, CC_Class(GadgetType(Object)) + "Gadget()")
          Case "Text:"   : SetGadgetText(\String, GetGadgetText(Object))
            
;           Case "Disable:": SetGadgetState(\ComboBox, IsDisableGadget(Object))
;           Case "Hide:"   : SetGadgetState(\ComboBox, IsHideGadget(Object))
          Case "Font:"   : SetGadgetText(\String, "("+ Str(FontSize( GetGadgetFont(Object) )) +") "+ FontName( GetGadgetFont(Object) ) )   
          Case "Color:"  : Color = GetGadgetColor( Object, #PB_Gadget_BackColor )
            If Color =- 1
              DisableGadget( \Button, 1) 
              DisableGadget( \String, 1) 
              SetGadgetText(\String, " False")
            Else
              DisableGadget( \Button, 0) 
              DisableGadget( \String, 0) 
              SetGadgetText(\String, " "+Str(Red(Color))+";"+Str(Blue(Color))+";"+Str(Green(Color)))
            EndIf
            
          Case "X:"      : SetGadgetState(\Spin, GadgetX(Object))
          Case "Y:"      : SetGadgetState(\Spin, GadgetY(Object))
          Case "Width:"  : SetGadgetState(\Spin, GadgetWidth(Object))
          Case "Height:" : SetGadgetState(\Spin, GadgetHeight(Object))
        EndSelect
        
      Else 
         Select Trim(\Info.S)
          Case "ID:"   : SetGadgetText(\String, Str(Object))
          ;Case "Type:"   : SetGadgetText(\String, "Open"+CC_Class(-1)+"()")
          Case "Text:"   : SetGadgetText(\String, GetWindowTitle(Object))
            
;           Case "Disable:": SetGadgetState(\ComboBox, IsDisableWindow(Object))
;           Case "Hide:"   : SetGadgetState(\ComboBox, IsHideWindow(Object))
          Case "Font:"   : SetGadgetText(\String, "("+ Str(FontSize( GetGadgetFont(#PB_Default) )) +") "+  FontName( GetGadgetFont(#PB_Default)) )   
          Case "Color:"   
            ;If  GetWindowColor(Object) =- 1
              Color = GetWindowColor(Object)
              ;SetWindowPoint( Object, 1 )
              If \Int
                Color = \Int
              EndIf
              
              If Color =- 1
                DisableGadget( \Button, 1) 
                DisableGadget( \String, 1) 
                SetGadgetText(\String, " False")
              Else
                DisableGadget( \Button, 0) 
                DisableGadget( \String, 0) 
                SetGadgetText(\String, " "+Str(Red(Color))+";"+Str(Blue(Color))+";"+Str(Green(Color)))
              EndIf
              
          Case "X:"      : SetGadgetState(\Spin, WindowX(Object))
          Case "Y:"      : SetGadgetState(\Spin, WindowY(Object))
          Case "Width:"  : SetGadgetState(\Spin, WindowWidth(Object))
          Case "Height:" : SetGadgetState(\Spin, WindowHeight(Object))
        EndSelect
      EndIf
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
  
  Procedure UpdateProperties( Object )
    Static CheckObject =- 1
    
    With Properties()
      If CheckObject <> Object
        ForEach Properties()
          \Object = Object
          
          Update( Object )
        Next
        CheckObject = Object
      EndIf
    EndWith
    
  EndProcedure
  
  ;-
  Procedure Events()
    
    ForEach Properties()
      With Properties()
        Select EventGadget()
          Case \String
            ;   #PB_EventType_Change    : The Text has been modified by the user.
            ;   #PB_EventType_Focus     : The StringGadget got the focus.
            ;   #PB_EventType_LostFocus : The StringGadget lost the focus.
            Select EventType()
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
            ;   #PB_EventType_Change   : The current selection of the Text in the edit field changed.
            ;   #PB_EventType_Focus    : The edit field received the keyboard focus (editable ComboBox only).
            ;   #PB_EventType_LostFocus: The edit field lost the keyboard focus (editable ComboBox only).
            Select EventType()
              Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \ComboBox )
                Change( \Object )
                
;               Case #PB_EventType_Focus : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Focus, \ComboBox )
;               Case #PB_EventType_LostFocus : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_LostFocus, \ComboBox )
                
            EndSelect
            
          Case \Button
            Select EventType()
              Case #PB_EventType_LeftClick ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_LeftClick, \Button )
                Change( \Object )
                Update( \Object )
                
            EndSelect
            
          Case \Spin
            ;   #PB_EventType_Change: The Text in the edit area has been modified by the user.
            ;   #PB_EventType_Up    : The 'Up' button was pressed.
            ;   #PB_EventType_Down  : The 'Down' button was pressed.
            
            Select EventType()
              Case #PB_EventType_Change ; : PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Change, \Spin )
                Change( \Object )
                
              Case #PB_EventType_Up ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Up, \Spin )
              Case #PB_EventType_Down ;: PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_Down, \Spin )
                
            EndSelect
            
        EndSelect
      EndWith
    Next
    
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
          Box(X+1,Y+2,Width-2,\ItemHeight-2, $F5F5F5)
          
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawingFont(GetGadgetFont(#PB_Default))
          DrawText(Width-TextWidth(\Info.S),Y+TextHeight(\Info.S)/3,\Info.S,0)
          
          DrawingMode(#PB_2DDrawing_Outlined)
          Box(X,Y+1,Width-2,\ItemHeight-1, $A9A9A9)
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
  
  Macro Clip(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        SetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
        
    CompilerEndSelect
  EndMacro
  
  Procedure Gadget( Gadget, Width, Height, LinePos = 95 )
    Shared LineGadget
    Gadget = ScrollAreaGadget( #PB_Any,0,0,Width,Height, Width,Height,0,#PB_ScrollArea_Single)
      
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
              \ItemHeight = 22
            CompilerCase #PB_OS_Linux
              \ItemHeight = 32;GadgetHeight(LineGadget)
          CompilerEndSelect
          
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
                  \Info.S = String.S + ":  "
                EndIf
              EndIf
            Next
          Else
            \Info.S = Text.S+":  "
          EndIf
          ;}
          
          If ((GadgetType & #PB_GadgetType_Button) = #PB_GadgetType_Button)
            Width-(Bw)
            \Button = ButtonGadget(#PB_Any, (\LinePos+Width),Y,Bw + 1,\ItemHeight + 1,"...") : Result = \Button
            Clip(\Button)
            BindGadgetEvent(\Button, @Events())
          EndIf
          
          If ((GadgetType & #PB_GadgetType_Spin) = #PB_GadgetType_Spin)
            \Spin = SpinGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,-32767,32767,#PB_Spin_Numeric) : Result = \Spin
            
            
            CompilerSelect #PB_Compiler_OS
              CompilerCase #PB_OS_Windows
                SetWindowLongPtr_( GetWindow_(GadgetID( \Spin ), #GW_HWNDNEXT), #GWL_STYLE, GetWindowLongPtr_( GetWindow_(GadgetID( \Spin ), #GW_HWNDNEXT), #GWL_STYLE )|#WS_CLIPSIBLINGS )
                SetWindowLongPtr_( GadgetID( \Spin ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( \Spin ), #GWL_STYLE )|#WS_CLIPSIBLINGS|#SS_CENTER )
                
            CompilerEndSelect
            BindGadgetEvent(\Spin, @Events())
            
          ElseIf ((GadgetType & #PB_GadgetType_ComboBox) = #PB_GadgetType_ComboBox)
            Protected IC 
            \ComboBox = ComboBoxGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1) : Result = \ComboBox
            For IC=0 To CountString(\Text.S,"|")
              If Trim(StringField(\Text.S,IC+1,"|"))
                AddGadgetItem(\ComboBox,-1,Trim(StringField(\Text.S,IC+1,"|")))
              EndIf
            Next
            SetGadgetState(\ComboBox, 0)
            
            Clip(\ComboBox)
            BindGadgetEvent(\ComboBox,@Events())
            
          ElseIf ((GadgetType & #PB_GadgetType_String) = #PB_GadgetType_String)
            \String = StringGadget(#PB_Any, \LinePos,Y + 1,Width,\ItemHeight - 1,\Text.S) : Result = \String
            
            Clip(\String)
            BindGadgetEvent(\String,@Events())
            
          Else
            \Seperator = ListIndex(Properties())
          EndIf
          
          
          SetGadgetData(\Gadget,Properties())
          
          PushListPosition(Properties())
          Size( GadgetWidth(\Gadget), GadgetHeight(\Gadget))
          Repaint()
          PopListPosition(Properties())
        EndWith
      CloseGadgetList()
    EndIf
    
    ProcedureReturn ListSize(Properties()) - 1
  EndProcedure 
  
EndModule



;-
;#RegEx_Pattern_Others1 = ~"[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\]"
#RegEx_Pattern_Quotes = ~"(?:\"(.*?)\")" ; - Находит Кавычки
#RegEx_Pattern_Others = ~"(?:[\\s\\^\\|\\!\\~\\&\\$])" ; Находим остальное
#RegEx_Pattern_Match = ~"(?:([\\/])|([\\*])|([\\-])|([\\+]))" ; Находит (*-+/)
#RegEx_Pattern_Function = ~"(?:(\\w*)\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
#RegEx_Pattern_World = ~"(?:([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+))"
#RegEx_Pattern_Captions = #RegEx_Pattern_Quotes+"|"+#RegEx_Pattern_Function+"|"+#RegEx_Pattern_Match+"|"+#RegEx_Pattern_World
#RegEx_Pattern_Arguments = "("+#RegEx_Pattern_Captions+"|"+#RegEx_Pattern_Others+")+"

#RegEx_Func = ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)"

#File=0
#Window=0


Structure FONT
  ID.i
  Name$
  Height.i
  Style.i
EndStructure

Structure IMG
  ID.i
  Name$
EndStructure

Structure Struct
  ID$ 
  Type$
  Args$
EndStructure

Structure ParsePBGadget Extends Struct
  
  ID.i 
  Type.i
  X.i 
  Y.i
  Width.i
  Height.i
  Param1.i
  Param2.i
  Param3.i
  Flag.i
  
  X$ 
  Y$
  Width$
  Height$
  Caption$
  Param1$
  Param2$
  Param3$
  Flag$
  
  Map Object.i() ; Получить идентификатор объекта
  Map Parent.i() ; Получить родитель объекта
  
  Map Font.FONT()
  Map Img.IMG()
  
  Content$            ; Содержимое. К примеру: "OpenWindow(#Butler_Window_Settings, x, y, width, height, "Настройки", #PB_Window_SystemMenu)"
  Position.i          ; Положение Content-a в исходном файле
  Length.i            ; длинна Content-a в исходном файле
  SubLevel.i
  
EndStructure

Global This_File$
Global NewList OpenPBGadget.ParsePBGadget() 
Global NewList ParsePBGadget.ParsePBGadget() 
Global *This.ParsePBGadget = AllocateStructure(ParsePBGadget)


Enumeration RegularExpression
  #RegEx_Function
  #RegEx_Arguments
  #RegEx_Arguments1
  #RegEx_Captions
  #RegEx_Captions1
  #Regex_Procedure
  #RegEx_Var
EndEnumeration

Procedure$ GetStr1(String$)
  Protected Result$, ID, Index, Value.f, Param1, Param2, Param3, Param1$
  Protected operand$, val$
  
  With *This
    If ExamineRegularExpression(#RegEx_Captions1, String$)
      While NextRegularExpressionMatch(#RegEx_Captions1)
        If RegularExpressionMatchString(#RegEx_Captions1)
          If operand$ = "-"
            val$ = RegularExpressionMatchString(#RegEx_Captions1)
            Result$ = Str(Val(Result$)-Val(RegularExpressionMatchString(#RegEx_Captions1)))
            operand$ = ""
          EndIf
          If operand$ = "*"
            If val$
              Result$ = Str(Val(Result$)+Val(val$))
              Result$ = Str(Val(Result$) - Val(val$)*Val(RegularExpressionMatchString(#RegEx_Captions1)))
              val$=""
            Else
              Result$ = Str(Val(Result$)*Val(RegularExpressionMatchString(#RegEx_Captions1)))
            EndIf
            operand$ = ""
          EndIf
          
          ;;Debug "    out - " + Result$
          
          Select RegularExpressionMatchString(#RegEx_Captions1)
            Case "#PB_Compiler_Home" : Result$+#PB_Compiler_Home
            Case "-" : operand$="-"
            Case "*" : operand$="*"
          EndSelect
          ;           Debug 55555555555
          ;           Debug Result$
          ;           Debug RegularExpressionMatchString(#RegEx_Captions1)
          
          If RegularExpressionGroup(#RegEx_Captions1, 2)
            ID = (\Object(RegularExpressionGroup(#RegEx_Captions1, 3)))
          EndIf
          
          
          Select RegularExpressionGroup(#RegEx_Captions1, 2) ; Название функции
            Case "Chr"            : Result$+Chr(10)
            Case "Str"            : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "StrF"           
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions1, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Value.f = ValF(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 2 : Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result$ + StrF(Value, Param2)
              EndIf
              
            Case "LCase" 
              ;                 If ExamineRegularExpression(#RegEx_Captions1, RegularExpressionGroup(#RegEx_Captions1, 3))
              ;                   While NextRegularExpressionMatch(#RegEx_Captions1)
              ;                     Select RegularExpressionGroup(#RegEx_Captions1, 2) ; Название функции
              ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((\Object(RegularExpressionGroup(#RegEx_Captions1, 3)))))
              ;                     EndSelect
              ;                   Wend
              ;                 EndIf
              
            Case "FontID"         : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "ImageID"        : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "GadgetID"       : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "WindowID"       : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
            Case "Space"          : Result$+Space(Val(RegularExpressionGroup(#RegEx_Captions1, 3)))
            Case "GetWindowTitle" : Result$+GetWindowTitle(ID)
            Case "WindowHeight"   
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions1, 3)) : Index=0
                Param2 = #PB_Window_InnerCoordinate ; Default value
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Param1$ = RegularExpressionMatchString(#RegEx_Arguments1)
                      Case 2 
                        Select RegularExpressionMatchString(#RegEx_Arguments1)
                          Case "#PB_Window_FrameCoordinate" : Param2 = #PB_Window_FrameCoordinate
                        EndSelect
                    EndSelect
                  EndIf
                Wend
                Result$ + WindowHeight(ID, Param2)
              EndIf
              
            Default               
              Result$+RegularExpressionGroup(#RegEx_Captions1, 1) ; То что между кавичкамы
          EndSelect
        EndIf
      Wend
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure

Procedure$ GetStr(String$)
  Protected Result$, ID, Index, Value.f, Param1, Param2, Param3, Param1$
  Protected operand$, val$
  
  With *This
    If ExamineRegularExpression(#RegEx_Captions, String$)
      While NextRegularExpressionMatch(#RegEx_Captions)
        If RegularExpressionMatchString(#RegEx_Captions)
          If operand$ = "-"
            val$ = RegularExpressionMatchString(#RegEx_Captions)
            Result$ = Str(Val(Result$)-Val(RegularExpressionMatchString(#RegEx_Captions)))
            operand$ = ""
          EndIf
          If operand$ = "*"
            If val$
              Result$ = Str(Val(Result$)+Val(val$))
              Result$ = Str(Val(Result$) - Val(val$)*Val(RegularExpressionMatchString(#RegEx_Captions)))
              val$=""
            Else
              Result$ = Str(Val(Result$)*Val(RegularExpressionMatchString(#RegEx_Captions)))
            EndIf
            operand$ = ""
          EndIf
          
          ;Debug "    out - " + Result$
          
          Select RegularExpressionMatchString(#RegEx_Captions)
            Case "#PB_Compiler_Home" : Result$+#PB_Compiler_Home
            Case "-" : operand$="-"
            Case "*" : operand$="*"
          EndSelect
          ;           Debug 55555555555
          ;           Debug Result$
          ;           Debug RegularExpressionMatchString(#RegEx_Captions)
          
          If RegularExpressionGroup(#RegEx_Captions, 2)
            ID = (\Object(RegularExpressionGroup(#RegEx_Captions, 3)))
          EndIf
          
          
          Select RegularExpressionGroup(#RegEx_Captions, 2) ; Название функции
            Case "Chr"            : Result$+Chr(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "Str"            : Result$+Str(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "StrF"           
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Value.f = ValF(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 2 : Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result$ + StrF(Value, Param2)
              EndIf
              
            Case "LCase" 
              ;                 If ExamineRegularExpression(#RegEx_Captions1, RegularExpressionGroup(#RegEx_Captions, 3))
              ;                   While NextRegularExpressionMatch(#RegEx_Captions1)
              ;                     Select RegularExpressionGroup(#RegEx_Captions1, 2) ; Название функции
              ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((\Object(RegularExpressionGroup(#RegEx_Captions1, 3)))))
              ;                     EndSelect
              ;                   Wend
              ;                 EndIf
              Result$+LCase(GetStr1(RegularExpressionGroup(#RegEx_Captions, 3)))
              
            Case "FontID"         : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "ImageID"        : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "GadgetID"       : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "WindowID"       : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
            Case "Space"          : Result$+Space(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "GetWindowTitle" : Result$+GetWindowTitle(ID)
            Case "WindowHeight"   
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                Param2 = #PB_Window_InnerCoordinate ; Default value
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1 : Param1$ = RegularExpressionMatchString(#RegEx_Arguments1)
                      Case 2 
                        Select RegularExpressionMatchString(#RegEx_Arguments1)
                          Case "#PB_Window_FrameCoordinate" : Param2 = #PB_Window_FrameCoordinate
                        EndSelect
                    EndSelect
                  EndIf
                Wend
                Result$ + WindowHeight(ID, Param2)
              EndIf
              
            Default               
              Result$+RegularExpressionGroup(#RegEx_Captions, 1) ; То что между кавичкамы
          EndSelect
        EndIf
      Wend
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure

Procedure GetVal(String$)
  Protected Result, Index, Param1, Param2, Param3, Param1$
  
  With *This
    If ExamineRegularExpression(#RegEx_Captions, String$)
      While NextRegularExpressionMatch(#RegEx_Captions)
        If RegularExpressionMatchString(#RegEx_Captions) 
          Select RegularExpressionGroup(#RegEx_Captions, 2)
            Case "RGB"
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1) 
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1
                        Param1 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 2
                        Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                      Case 3
                        Param3 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result = RGB(Param1, Param2, Param3)
              EndIf
              
            Case "ReadPreferenceLong"
              If ExamineRegularExpression(#RegEx_Arguments1, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                While NextRegularExpressionMatch(#RegEx_Arguments1)
                  If RegularExpressionMatchString(#RegEx_Arguments1) : Index+1
                    Select Index
                      Case 1
                        Param1$ = RegularExpressionMatchString(#RegEx_Arguments1)
                      Case 2
                        Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments1))
                    EndSelect
                  EndIf
                Wend
                Result = ReadPreferenceLong(Param1$, Param2)
              EndIf
              
            Case "WindowHeight"   
              Result = Val(GetStr1(String$))
          EndSelect
        EndIf
      Wend
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure AddPBFunction(*This.ParsePBGadget, Index)
  Protected Result
  
  With *This
    Select \Type$
      Case "LoadFont"
        Select Index
          Case 1 : \ID$ = \Args$
          Case 2 : \Param1$ = \Args$
          Case 3 : \Param2$ = \Args$
          Case 4 : \Param3$ = \Args$
        EndSelect
        
      Case "LoadImage", 
           "SetGadgetFont", 
           "SetGadgetState",
           "SetGadgetText"
        Select Index
          Case 1 : \ID$ = \Args$
          Case 2 : \Param1$=GetStr(\Args$)
        EndSelect
        
      Case "ResizeGadget"
        Select Index
          Case 1 : \ID$ = \Args$
          Case 2 
            If "#PB_Ignore"=\Args$ 
              \X = #PB_Ignore
            Else
              \X = Val(\Args$)
            EndIf
            
          Case 3 
            If "#PB_Ignore"=\Args$ 
              \Y = #PB_Ignore
            Else
              \Y = Val(\Args$)
            EndIf
            
          Case 4 
            If "#PB_Ignore"=\Args$ 
              \Width = #PB_Ignore
            Else
              \Width = Val(\Args$)
            EndIf
            
          Case 5 
            If "#PB_Ignore"=\Args$ 
              \Height = #PB_Ignore
            Else
              \Height = Val(\Args$)
            EndIf
            
        EndSelect
        
      Case "SetGadgetColor"
        Select Index
          Case 1 : \ID$ = \Args$
          Case 2 
            Select \Args$
              Case "#PB_Gadget_FrontColor"      : \Param1 = #PB_Gadget_FrontColor      ; Цвет текста гаджета
              Case "#PB_Gadget_BackColor"       : \Param1 = #PB_Gadget_BackColor       ; Фон гаджета
              Case "#PB_Gadget_LineColor"       : \Param1 = #PB_Gadget_LineColor       ; Цвет линий сетки
              Case "#PB_Gadget_TitleFrontColor" : \Param1 = #PB_Gadget_TitleFrontColor ; Цвет текста в заголовке    (для гаджета CalendarGadget())
              Case "#PB_Gadget_TitleBackColor"  : \Param1 = #PB_Gadget_TitleBackColor  ; Цвет фона в заголовке 	 (для гаджета CalendarGadget())
              Case "#PB_Gadget_GrayTextColor"   : \Param1 = #PB_Gadget_GrayTextColor   ; Цвет для серого текста     (для гаджета CalendarGadget())
            EndSelect
            
          Case 3
            \Param2 = Val(\Args$)
            Result = GetVal(\Args$)
            If Result
              \Param2 = Result
            EndIf
        EndSelect
        
        
    EndSelect
    
  EndWith
  
EndProcedure

Procedure SetPBFunction(*This.ParsePBGadget)
  Protected I, ID
  
  With *This
    ID = \Object(\ID$)
    
    Select \Type$
      Case "UsePNGImageDecoder"      : UsePNGImageDecoder()
      Case "UsePNGImageEncoder"      : UsePNGImageEncoder()
      Case "UseJPEGImageDecoder"     : UseJPEGImageDecoder()
      Case "UseJPEG2000ImageEncoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEG2000ImageDecoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEGImageEncoder"     : UseJPEGImageEncoder()
      Case "UseGIFImageDecoder"      : UseGIFImageDecoder()
      Case "UseTGAImageDecoder"      : UseTGAImageDecoder()
      Case "UseTIFFImageDecoder"     : UseTIFFImageDecoder()
        
      Case "LoadFont"
        AddMapElement(\Font(), \ID$) 
        
        \Font()\Name$=\Param1$
        \Font()\Height=Val(\Param2$)
        
        For I = 0 To CountString(\Param3$,"|")
          Select Trim(StringField(\Param3$,(I+1),"|"))
            Case "#PB_Font_Bold"        : \Font()\Style|#PB_Font_Bold
            Case "#PB_Font_HighQuality" : \Font()\Style|#PB_Font_HighQuality
            Case "#PB_Font_Italic"      : \Font()\Style|#PB_Font_Italic
            Case "#PB_Font_StrikeOut"   : \Font()\Style|#PB_Font_StrikeOut
            Case "#PB_Font_Underline"   : \Font()\Style|#PB_Font_Underline
          EndSelect
        Next
        
        \Font()\ID=LoadFont(#PB_Any,\Font()\Name$,\Font()\Height,\Font()\Style)
        
      Case "LoadImage"
        AddMapElement(\Img(), \ID$) 
        \Img()\Name$=\Param1$
        
        \Img()\ID=LoadImage(#PB_Any, \Img()\Name$)
        
    EndSelect
    
    If IsGadget(ID)
      Select \Type$
        Case "SetGadgetFont"
          Protected Font = \Font(\Param1$)\ID
          If IsFont(Font)
            SetGadgetFont(ID, FontID(Font))
          EndIf
          
        Case "SetGadgetState"
          Protected Img = \Img(\Param1$)\ID
          If IsImage(Img)
            SetGadgetState(ID, ImageID(Img))
          EndIf
          
        Case "SetGadgetText"
          SetGadgetText(ID, \Param1$)
          
        Case "ResizeGadget"
          ResizeGadget(ID, \X, \Y, \Width, \Height)
          Transformation::Update(ID)
          
        Case "SetGadgetColor"
          SetGadgetColor(ID, \Param1, \Param2)
      EndSelect
    EndIf
  EndWith
  
EndProcedure

Procedure$ GetRegExString(Pattern$, Group)
  Protected Result$
  Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
  Protected RegExID = CreateRegularExpression(#PB_Any, Pattern$, Create_Reg_Flag)
  
  If RegExID
    
    If ExamineRegularExpression(RegExID, This_File$)
      While NextRegularExpressionMatch(RegExID)
        If Group
          Result$ = RegularExpressionGroup(RegExID, Group)
        Else
          Result$ = RegularExpressionMatchString(RegExID)
        EndIf
      Wend
    EndIf
    
    FreeRegularExpression(RegExID)
  EndIf
  
  Debug Result$
  ProcedureReturn Result$
EndProcedure

Macro GetVarValue(StrToFind)
  Trim(GetRegExString(StrToFind+"\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 1), #CR$)
EndMacro

Procedure OpenPBObjectFlag(Flag$) ; Ok
  Protected I, Flag 
  
  For I = 0 To CountString(Flag$,"|")
    Select Trim(StringField(Flag$,(I+1),"|"))
        ; window
      Case "#PB_Window_BorderLess"              : Flag = Flag | #PB_Window_BorderLess
      Case "#PB_Window_Invisible"               : Flag = Flag | #PB_Window_Invisible
      Case "#PB_Window_Maximize"                : Flag = Flag | #PB_Window_Maximize
      Case "#PB_Window_Minimize"                : Flag = Flag | #PB_Window_Minimize
      Case "#PB_Window_MaximizeGadget"          : Flag = Flag | #PB_Window_MaximizeGadget
      Case "#PB_Window_MinimizeGadget"          : Flag = Flag | #PB_Window_MinimizeGadget
      Case "#PB_Window_NoActivate"              : Flag = Flag | #PB_Window_NoActivate
      Case "#PB_Window_NoGadgets"               : Flag = Flag | #PB_Window_NoGadgets
      Case "#PB_Window_SizeGadget"              : Flag = Flag | #PB_Window_SizeGadget
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
  
  ProcedureReturn Flag
EndProcedure 

;-
Procedure OpenPBObject(*This.ParsePBGadget) ; Ok
  Static Parent=-1, SubLevel
  Protected OpenGadgetList, GetParent, Result=-1
  
  With *This
    Select \Type$
      Case "OpenWindow"          : Result = OpenWindow          (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag|#PB_Window_SizeGadget) 
      Case "ButtonGadget"        : Result = ButtonGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "StringGadget"        : Result = StringGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "TextGadget"          : Result = TextGadget          (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "CheckBoxGadget"      : Result = CheckBoxGadget      (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "OptionGadget"        : Result = OptionGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$)
      Case "ListViewGadget"      : Result = ListViewGadget      (#PB_Any, \X,\Y,\Width,\Height, \Flag)
      Case "FrameGadget"         : Result = FrameGadget         (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "ComboBoxGadget"      : Result = ComboBoxGadget      (#PB_Any, \X,\Y,\Width,\Height, \Flag)
      Case "ImageGadget"         : Result = ImageGadget         (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
      Case "HyperLinkGadget"     : Result = HyperLinkGadget     (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
      Case "ContainerGadget"     : Result = ContainerGadget     (#PB_Any, \X,\Y,\Width,\Height, \Flag)
      Case "ListIconGadget"      : Result = ListIconGadget      (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
      Case "IPAddressGadget"     : Result = IPAddressGadget     (#PB_Any, \X,\Y,\Width,\Height)
      Case "ProgressBarGadget"   : Result = ProgressBarGadget   (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
      Case "ScrollBarGadget"     : Result = ScrollBarGadget     (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Param3, \Flag)
      Case "ScrollAreaGadget"    : Result = ScrollAreaGadget    (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Param3, \Flag) 
      Case "TrackBarGadget"      : Result = TrackBarGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
      Case "WebGadget"           : Result = WebGadget           (#PB_Any, \X,\Y,\Width,\Height, \Caption$)
      Case "ButtonImageGadget"   : Result = ButtonImageGadget   (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
      Case "CalendarGadget"      : Result = CalendarGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
      Case "DateGadget"          : Result = DateGadget          (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
      Case "EditorGadget"        : Result = EditorGadget        (#PB_Any, \X,\Y,\Width,\Height, \Flag)
      Case "ExplorerListGadget"  : Result = ExplorerListGadget  (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "ExplorerTreeGadget"  : Result = ExplorerTreeGadget  (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "ExplorerComboGadget" : Result = ExplorerComboGadget (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
      Case "SpinGadget"          : Result = SpinGadget          (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
      Case "TreeGadget"          : Result = TreeGadget          (#PB_Any, \X,\Y,\Width,\Height, \Flag)
      Case "PanelGadget"         : Result = PanelGadget         (#PB_Any, \X,\Y,\Width,\Height) 
      Case "SplitterGadget"      
        Debug "Splitter FirstGadget "+\Param1
        Debug "Splitter SecondGadget "+\Param2
        If IsGadget(\Param1) And IsGadget(\Param2)
          Result = SplitterGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
        EndIf
      Case "MDIGadget"          
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Result = MDIGadget           (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag) 
        CompilerEndIf
      Case "ScintillaGadget"     : Result = ScintillaGadget     (#PB_Any, \X,\Y,\Width,\Height, \Param1)
      Case "ShortcutGadget"      : Result = ShortcutGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1)
      Case "CanvasGadget"        : Result = CanvasGadget        (#PB_Any, \X,\Y,\Width,\Height, \Flag)
    EndSelect
    
    If IsWindow(Result)
      AddMapElement(\Object(), \ID$) : \Object()=Result
    ElseIf IsGadget(Result)
      AddMapElement(\Object(), \ID$) : \Object()=Result
      AddMapElement(\Parent(), Str(Result)) : \Parent()=Parent
    EndIf
    
    Select \Type$
      Case "OpenWindow" : Parent = Result : SubLevel = 1
      Case "UseGadgetList" : UseGadgetList( WindowID(Parent) )
      Case "ContainerGadget", "ScrollAreaGadget", "PanelGadget" :  Parent = Result : SubLevel + 1
      Case "CloseGadgetList" 
        If IsGadget(Parent) : CloseGadgetList() : Parent = \Parent(Str(Parent)) : EndIf
        
      Case "AddGadgetColumn"       
        AddGadgetColumn( \Object(\ID$), \Param1, \Caption$, \Param2)
      Case "AddGadgetItem"   
        If IsGadget(\Object(\ID$))
          AddGadgetItem( \Object(\ID$), \Param1, \Caption$, \Param2, \Flag)
        Else
          Debug " add gadget column "+\ID$
        EndIf
        
      Case "OpenGadgetList"      
        Parent = \Object(\ID$)
        
        If IsGadget(Parent)
          OpenGadgetList( Parent, \Param1 )
        EndIf
    EndSelect
    
    If IsGadget(Result)
      ParsePBGadget()\ID = Result
      
      If IsGadget(Parent)
        GetParent = \Parent(Str(Parent))
      EndIf
      
      If Result = Parent
        If IsWindow(GetParent)
          CloseGadgetList() ; Bug PB
          UseGadgetList(WindowID(GetParent))
        EndIf
        If IsGadget(GetParent) 
          OpenGadgetList = OpenGadgetList(GetParent) 
          SubLevel + 1
        EndIf
      EndIf
      
      Transformation::Enable(Result, 5)
      Properties::UpdateProperties(Result)
      
      If GadgetType(Result) = #PB_GadgetType_Splitter
        Transformation::Disable(GetGadgetAttribute(Result, #PB_Splitter_FirstGadget))
        Transformation::Disable(GetGadgetAttribute(Result, #PB_Splitter_SecondGadget))
      EndIf
      
      If Result = Parent
        If IsWindow(GetParent) 
          OpenGadgetList(Result) 
        EndIf
        If OpenGadgetList 
          CloseGadgetList() 
          SubLevel - 1
        EndIf
      EndIf
      
      Debug \ID$ +" "+ Str(SubLevel) 
      Select GadgetType(Result)
        Case #PB_GadgetType_Container, #PB_GadgetType_Panel, #PB_GadgetType_ScrollArea
          ParsePBGadget()\SubLevel = SubLevel-1
        Default
          ParsePBGadget()\SubLevel = SubLevel
      EndSelect
      
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure$ SavePBObject(*This.ParsePBGadget) ; Ok
  Protected Result$
  
  With *This
    Select \Type$
        Case "OpenWindow"          : Result$ = "OpenWindow          ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ButtonGadget"        : Result$ = "ButtonGadget        ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "StringGadget"        : Result$ = "StringGadget        ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "TextGadget"          : Result$ = "TextGadget          ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "CheckBoxGadget"      : Result$ = "CheckBoxGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
      Case "OptionGadget"        : Result$ = "OptionGadget        ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)
        Case "ListViewGadget"      : Result$ = "ListViewGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$                                                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "FrameGadget"         : Result$ = "FrameGadget         ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ComboBoxGadget"      : Result$ = "ComboBoxGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$                                                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ImageGadget"         : Result$ = "ImageGadget         ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$                                                                 : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "HyperLinkGadget"     : Result$ = "HyperLinkGadget     ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)+", "+\Param1$                                  : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ContainerGadget"     : Result$ = "ContainerGadget     ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$                                                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ListIconGadget"      : Result$ = "ListIconGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)+", "+\Param1$                                  : If \Flag$ : Result$ +", "+\Flag$ : EndIf
      Case "IPAddressGadget"     : Result$ = "IPAddressGadget     ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$
        Case "ProgressBarGadget"   : Result$ = "ProgressBarGadget   ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$+", "+\Param2$                                                   : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ScrollBarGadget"     : Result$ = "ScrollBarGadget     ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$+", "+\Param2$+", "+\Param3$                                     : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ScrollAreaGadget"    : Result$ = "ScrollAreaGadget    ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$+", "+\Param2$    : If \Param3$ : Result$ +", "+\Param3$ : EndIf : If \Flag$ : Result$ +", "+\Flag$ : EndIf 
        Case "TrackBarGadget"      : Result$ = "TrackBarGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$+", "+\Param2$                                                   : If \Flag$ : Result$ +", "+\Flag$ : EndIf
      Case "WebGadget"           : Result$ = "WebGadget           ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)
        Case "ButtonImageGadget"   : Result$ = "ButtonImageGadget   ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$                                                                 : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "CalendarGadget"      : Result$ = "CalendarGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$                                 : If \Param1$ : Result$ +", "+\Param1$ : EndIf : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "DateGadget"          : Result$ = "DateGadget          ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34) : If \Param1$ : Result$ +", "+\Param1$ : EndIf : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "EditorGadget"        : Result$ = "EditorGadget        ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$                                                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ExplorerListGadget"  : Result$ = "ExplorerListGadget  ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ExplorerTreeGadget"  : Result$ = "ExplorerTreeGadget  ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "ExplorerComboGadget" : Result$ = "ExplorerComboGadget ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ Chr(34)+\Caption$+Chr(34)                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "SpinGadget"          : Result$ = "SpinGadget          ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$+", "+\Param2$                                                   : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "TreeGadget"          : Result$ = "TreeGadget          ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$                                                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
      Case "PanelGadget"         : Result$ = "PanelGadget         ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$ 
        Case "SplitterGadget"      : Result$ = "SplitterGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$+", "+\Param2$                                                   : If \Flag$ : Result$ +", "+\Flag$ : EndIf
        Case "MDIGadget"           : Result$ = "MDIGadget           ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$+", "+\Param2$                                                   : If \Flag$ : Result$ +", "+\Flag$ : EndIf 
      Case "ScintillaGadget"     : Result$ = "ScintillaGadget     ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$
      Case "ShortcutGadget"      : Result$ = "ShortcutGadget      ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$+", "+ \Param1$
        Case "CanvasGadget"        : Result$ = "CanvasGadget        ("+\ID$+", "+\X$+", "+\Y$+", "+\Width$+", "+\Height$                                                                                : If \Flag$ : Result$ +", "+\Flag$ : EndIf
    EndSelect
  EndWith
  
  ProcedureReturn Result$+")"
EndProcedure

;-
Procedure.S ParsePBFile(FileName.s)
  Protected i,Result, Texts.S, Text.S, Find.S, String.S, Count, Position, Index, Args$, Arg$
  
  If ReadFile(#File, FileName)
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_Extended    
    Protected Line, FindWindow, Content$, FunctionArgs$
    Protected Format=ReadStringFormat(#File)
    Protected Length = Lof(#File) 
    Protected *File = AllocateMemory(Length)
    
    If *File 
      ReadData(#File, *File, Length)
      This_File$ = PeekS(*File, Length, Format) ; "+#RegEx_Pattern_Function+~"
      
      If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
         CreateRegularExpression(#RegEx_Arguments, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
         CreateRegularExpression(#RegEx_Captions, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) And
         
        CreateRegularExpression(#RegEx_Arguments1, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
CreateRegularExpression(#RegEx_Captions1, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) 
        
        
        If ExamineRegularExpression(#RegEx_Function, This_File$)
          While NextRegularExpressionMatch(#RegEx_Function)
            With *This
              
              If RegularExpressionGroup(#RegEx_Function, 1) = "" And RegularExpressionGroup(#RegEx_Function, 9) = ""
                \Type$=RegularExpressionGroup(#RegEx_Function, 7)
                \Args$=Trim(RegularExpressionGroup(#RegEx_Function, 8))
                
                If RegularExpressionGroup(#RegEx_Function, 3)
                  \ID$ = RegularExpressionGroup(#RegEx_Function, 3)
                EndIf
                
                If \Type$
                  ;Debug "All - "+RegularExpressionMatchString(#RegEx_Function)
                  
                  Select \Type$
                    Case "OpenWindow", 
                         "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
                         "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
                         "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
                         "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
                         "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
                         "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
                         "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
                         "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
                      
                      AddElement(ParsePBGadget()) 
                      ParsePBGadget()\Type$ = \Type$
                      ParsePBGadget()\Content$ = RegularExpressionMatchString(#RegEx_Function)
                      ParsePBGadget()\Length = RegularExpressionMatchLength(#RegEx_Function)
                      ParsePBGadget()\Position = RegularExpressionMatchPosition(#RegEx_Function)
                      
                      
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Arg$ : Index+1
                            If (Index>5)
                              Select \Type$
                                Case "OpenGLGadget","EditorGadget","CanvasGadget",
                                     "ComboBoxGadget","ContainerGadget","ListViewGadget","TreeGadget"
                                  If Index=6 : Index+4 : EndIf
                                  
                                Case "ScrollBarGadget","ScrollAreaGadget","ScintillaGadget"
                                  If Index=6 : Index+1 : EndIf
                                  
                                  
                                Case "TrackBarGadget","SpinGadget","SplitterGadget","ProgressBarGadget"
                                  Select Index 
                                    Case 6,8 : Index+1
                                  EndSelect
                                  
                                Case "CalendarGadget","ButtonImageGadget","ImageGadget"
                                  Select Index 
                                    Case 6 : Index+1
                                    Case 7 : Index+2
                                  EndSelect
                                  
                                Case "OpenWindow",
                                     "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget","FrameGadget",
                                     "ExplorerListGadget","ExplorerTreeGadget","ExplorerComboGadget"
                                  If Index=7 : Index+3 : EndIf
                                  
                                Case "HyperLinkGadget","DateGadget","ListIconGadget"
                                  If Index=8 : Index+2 : EndIf
                                  
                              EndSelect
                            EndIf
                            
                            Select Index
                              Case 1
                                If "#PB_Any" <> Arg$
                                  \ID$ = Arg$
                                EndIf
                                ParsePBGadget()\ID$ = \ID$
                                
                              Case 2 : ParsePBGadget()\X$ = Arg$
                                Select Asc(Arg$)
                                  Case '0' To '9'
                                    \X = Val(Arg$) ; Если строка такого рода "10"
                                  Default
                                    \X = GetVal(Arg$) ; Если строка такого рода "GadgetX(#Gadget)"
                                    If \X = 0
                                      \X = Val(GetVarValue(Arg$)) ; Если строка такого рода "x"
                                    EndIf
                                EndSelect
                                
                              Case 3 : ParsePBGadget()\Y$ = Arg$
                                Select Asc(Arg$)
                                  Case '0' To '9'
                                    \Y = Val(Arg$) ; Если строка такого рода "10"
                                  Default
                                    \Y = GetVal(Arg$) ; Если строка такого рода "GadgetY(#Gadget)"
                                    If \Y = 0
                                      \Y = Val(GetVarValue(Arg$)) ; Если строка такого рода "y"
                                    EndIf
                                EndSelect
                                
                              Case 4 : ParsePBGadget()\Width$ = Arg$
                                Select Asc(Arg$)
                                  Case '0' To '9'
                                    \Width = Val(Arg$) ; Если строка такого рода "10"
                                  Default
                                    \Width = GetVal(Arg$) ; Если строка такого рода "GadgetWidth(#Gadget)"
                                    If \Width = 0
                                      \Width = Val(GetVarValue(Arg$)) ; Если строка такого рода "width"
                                    EndIf
                                EndSelect
                                
                              Case 5 : ParsePBGadget()\Height$ = Arg$
                                Select Asc(Arg$)
                                  Case '0' To '9'
                                    \Height = Val(Arg$) ; Если строка такого рода "10"
                                  Default
                                    \Height = GetVal(Arg$) ; Если строка такого рода "GadgetHeight(#Gadget)"
                                    If \Height = 0
                                      \Height = Val(GetVarValue(Arg$)) ; Если строка такого рода "height"
                                    EndIf
                                EndSelect
                                
                              Case 6 : ParsePBGadget()\Caption$ = Arg$
                                \Caption$ = GetStr(Arg$) 
                                
                              Case 7 : ParsePBGadget()\Param1$ = Arg$
                                Select \Type$ 
                                  Case "SplitterGadget"      
                                    \Param1 = \Object(Arg$)
                                    
                                  Case "ImageGadget"      
                                    Result = \Img(GetStr(Arg$))\ID 
                                    If IsImage(Result)
                                      \Param1 = ImageID(Result)
                                    EndIf
                                    
                                  Default
                                    Select Asc(Arg$)
                                      Case '0' To '9'
                                        \Param1 = Val(Arg$)
                                      Default
                                    EndSelect
                                EndSelect
                                
                              Case 8 : ParsePBGadget()\Param2$ = Arg$
                                Select \Type$ 
                                  Case "SplitterGadget"      
                                    \Param2 = \Object(Arg$)
                                    
                                  Default
                                    Select Asc(Arg$)
                                      Case '0' To '9'
                                        \Param2 = Val(Arg$)
                                      Default
                                    EndSelect
                                EndSelect
                                
                              Case 9 : ParsePBGadget()\Param3$ = Arg$
                                \Param3 = Val(Arg$)
                                
                              Case 10 : ParsePBGadget()\Flag$ = Arg$
                                
                                Select Asc(Arg$)
                                  Case '0' To '9'
                                    \Flag = Val(Arg$)
                                  Default
                                    \Flag = OpenPBObjectFlag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    If \Flag = 0
                                      Arg$ = GetVarValue(Arg$)
                                      \Flag = Val(Arg$)
                                    EndIf
                                    If \Flag = 0
                                      \Flag = OpenPBObjectFlag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    EndIf
                                EndSelect
                            EndSelect
                            
                          EndIf
                        Wend
                      EndIf
                      
                      Protected win = CallFunctionFast(@OpenPBObject(), *This)
                      
                      \ID=-1
                      \ID$=""
                      \Param1 = 0
                      \Param2 = 0
                      \Param3 = 0
                      \Caption$ = ""
                      \Flag = 0
                      
                    Case "CloseGadgetList"      : CallFunctionFast(@OpenPBObject(), *This) ; , "UseGadgetList" ; TODO
                      
                    Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"      
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Arg$ : Index+1
                            Select Index
                              Case 1 : \ID$ = Arg$
                              Case 2 : \Param1 = Val(Arg$)     ; 
                              Case 3 : \Caption$=GetStr(Arg$)
                              Case 4 : \Param2 = Val(Arg$)
                              Case 5 : \Flag$ = Arg$
                                \Flag = OpenPBObjectFlag(Arg$)
                                If Not \Flag
                                  Select Asc(\Flag$)
                                    Case '0' To '9'
                                    Default
                                      \Flag = OpenPBObjectFlag(GetVarValue(Arg$))
                                  EndSelect
                                EndIf
                            EndSelect
                          EndIf
                        Wend
                      EndIf
                      
                      CallFunctionFast(@OpenPBObject(), *This)
                      
                      
                      \ID =- 1
                      \ID$ = ""
                      \Flag = 0
                      \Param1 = 0
                      \Param2 = 0
                      \Param3 = 0
                      \Flag$ = ""
                      \Param1$ = ""
                      \Param2$ = ""
                      \Param3$ = ""
                      \Caption$ = ""
                      ;ClearStructure(*This, ParsePBGadget)
                      ;                         FreeStructure(*This)
                      ;                         *This.ParsePBGadget = AllocateStructure(ParsePBGadget)
                      
                    Default
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Args$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Args$
                            \Args$ = Args$ 
                            Index+1
                            AddPBFunction(*This, Index)
                          EndIf
                        Wend
                        
                        SetPBFunction(*This)
                      EndIf
                      
                  EndSelect
                  
                EndIf
              EndIf
            EndWith
          Wend
          
        Else
          Debug "Nothing to extract from: " + This_File$
          ProcedureReturn 
        EndIf
        
        
        If IsRegularExpression(#RegEx_Arguments1)
          FreeRegularExpression(#RegEx_Arguments1)
        EndIf
        If IsRegularExpression(#RegEx_Captions1)
          FreeRegularExpression(#RegEx_Captions1)
        EndIf
        
        FreeRegularExpression(#RegEx_Function)
        FreeRegularExpression(#RegEx_Arguments)
        FreeRegularExpression(#RegEx_Captions)
      Else
        Debug "Error creating #RegEx"
        End
      EndIf
    EndIf
    
    CloseFile(#File)
    ;Protected Properties = Properties_Window_Show( win ); WindowID(win))
                                                    ;       ResizeWindow(Properties, WindowX(win)+WindowWidth(win), WindowY(win), #PB_Ignore, #PB_Ignore)
                                                    ;       SetActiveWindow(win)
                                                    ;       SetActiveWindow(Properties)
  EndIf
  
  ;Debug result
  ProcedureReturn 
EndProcedure



;-
Macro ULCase(String)
  InsertString(UCase(Left(String,1)), LCase(Right(String,Len(String)-1)), 2)
EndMacro

Declare CreateObject(Type$)

Procedure CreateObject_Events()
  Select Event()
    Case #PB_Event_WindowDrop
      CreateObject(ReplaceString(EventDropText(), "gadget", ""))
  EndSelect
EndProcedure

Procedure CreateObject(Type$)
  With *This
    \ID$= Type$
    
    Select Type$
      Case "Window" 
        \Type$ = "OpenWindow"
        \Width=200
        \Height=100
      Case "Menu", "ToolBar"
        \Type$ = Type$
      Default
        \Type$=ULCase(Type$) + "Gadget"
        \Width=80
        \Height=40
    EndSelect
    
    \Caption$=\ID$
    \Flag=#PB_Window_SystemMenu|#PB_Window_ScreenCentered
    
    AddElement(ParsePBGadget()) 
    ParsePBGadget()\ID$ = \ID$
    ParsePBGadget()\Type$ = \Type$
    Protected Object=CallFunctionFast(@OpenPBObject(), *This)
    
    If IsWindow(Object)
      EnableWindowDrop(Object, #PB_Drop_Text, #PB_Drag_Copy)
      BindEvent(#PB_Event_WindowDrop, @CreateObject_Events(), Object)
    EndIf
    
    AddGadgetItem(Window_0_Tree_0, -1, \ID$, 0, ParsePBGadget()\SubLevel)
  EndWith
EndProcedure

Procedure LoadControls()
  UsePNGImageDecoder()
  
  Protected ZipFile.i, GadgetName.s, GadgetImageSize.i, *GadgetImage, GadgetImage, GadgetCtrlCount.l
  Define ZipFileTheme.s = GetCurrentDirectory()+"SilkTheme.zip"
  
  If FileSize(ZipFileTheme) < 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ZipFileTheme = #PB_Compiler_Home+"themes\SilkTheme.zip"
    CompilerElse
      ZipFileTheme = #PB_Compiler_Home+"themes/SilkTheme.zip"
    CompilerEndIf
    If FileSize(ZipFileTheme) < 1
      MessageRequester("Designer Error", "SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
      End
    EndIf
  EndIf
  
  CompilerIf #PB_Compiler_Version > 522
    UseZipPacker()
  CompilerEndIf

  ZipFile = OpenPack(#PB_Any, ZipFileTheme, #PB_PackerPlugin_Zip)
  If ZipFile
    If ExaminePack(ZipFile)
      While NextPackEntry(ZipFile)

        GadgetName = PackEntryName(ZipFile)
        GadgetName = ReplaceString(GadgetName,"chart_bar","vd_tabbargadget")   ;use chart_bar png for TabBarGadget
        GadgetName = ReplaceString(GadgetName,"page_white_edit","vd_scintillagadget")   ;vd_scintillagadget.png not found. Use page_white_edit.png instead
        GadgetName = ReplaceString(GadgetName,"frame3dgadget","framegadget")            ;vd_framegadget.png not found. Use vd_frame3dgadget.png instead
        
        If FindString(Left(GadgetName, 3), "vd_")
          GadgetImageSize = PackEntrySize(ZipFile)
          *GadgetImage = AllocateMemory(GadgetImageSize)
          UncompressPackMemory(ZipFile, *GadgetImage, GadgetImageSize)
          GadgetImage = CatchImage(#PB_Any, *GadgetImage, GadgetImageSize)
          GadgetName = LCase(GadgetName)
          GadgetName = ReplaceString(GadgetName,".png","")
          GadgetName = ReplaceString(GadgetName,"vd_","")

          Select PackEntryType(ZipFile)
            Case #PB_Packer_File
              If GadgetImage
                AddGadgetItem(Window_0_Tree_1, -1, GadgetName, ImageID(GadgetImage))
              EndIf
          EndSelect
          
          FreeMemory(*GadgetImage)
        EndIf
      Wend
    EndIf
    ClosePack(ZipFile)
  EndIf
EndProcedure

Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu, ParentID=0)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 900, 100, 230, 600, "Window_0", Flag, ParentID)
    Window_0_Menu_0 = CreateMenu(#PB_Any, WindowID(Window_0))
    StickyWindow(Window_0, #True)
    
    If Window_0_Menu_0
      MenuTitle("Project")
      MenuItem(Window_0_Menu_0_New, "New"   +Chr(9)+"Ctrl+N")
      MenuItem(Window_0_Menu_0_Open, "Open"   +Chr(9)+"Ctrl+O")
      MenuItem(Window_0_Menu_0_Save, "Save"   +Chr(9)+"Ctrl+S")
      MenuItem(Window_0_Menu_0_Save_as, "Save as"+Chr(9)+"Ctrl+A")
      MenuItem(Window_0_Menu_0_Close, "Close"  +Chr(9)+"Ctrl+C")
    EndIf
    
    Window_0_Tree_0 = TreeGadget(#PB_Any, 5, 5, 225, 145, #PB_Tree_AlwaysShowSelection)
    Window_0_Panel_0 = PanelGadget(#PB_Any, 5, 159, 225, 261)
    AddGadgetItem(Window_0_Panel_0, -1, "Свойства")
    
    Window_0_Properties = Properties::Gadget( #PB_Any, 225, 261 )
    Properties::AddItem( Window_0_Properties, "Propertieses:", #False )
    Properties::AddItem( Window_0_Properties, "ID:", #PB_GadgetType_String )
    ;DisableGadget(Properties::AddItem( Window_0_Properties, "Type:", #PB_GadgetType_String ),#True)
    Properties::AddItem( Window_0_Properties, "Text:", #PB_GadgetType_String )
    Properties::AddItem( Window_0_Properties, "Disable:False|True", #PB_GadgetType_ComboBox )
    Properties::AddItem( Window_0_Properties, "Hide:False|True", #PB_GadgetType_ComboBox )
    
    Properties::AddItem( Window_0_Properties, "Other:", #False )
    Properties::AddItem( Window_0_Properties, "Font:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( Window_0_Properties, "Image:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( Window_0_Properties, "Puth", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( Window_0_Properties, "Color:", #PB_GadgetType_String|#PB_GadgetType_Button )
    
    Properties::AddItem( Window_0_Properties, "Layouts:", #False )
;     Properties::AddItem( Window_0_Properties, "Align:#PB_Align_None|#PB_Align_Left|#PB_Align_Top|#PB_Align_Right|#PB_Align_Bottom|#PB_Align_Center", #PB_GadgetType_ComboBox )
;     Properties::AddItem( Window_0_Properties, "Dock:#PB_Align_None|#PB_Align_Left|#PB_Align_Top|#PB_Align_Right|#PB_Align_Bottom|#PB_Align_Full", #PB_GadgetType_ComboBox )
    Properties_Gadget_X = Properties::AddItem( Window_0_Properties, "X:", #PB_GadgetType_Spin )
    Properties_Gadget_Y = Properties::AddItem( Window_0_Properties, "Y:", #PB_GadgetType_Spin )
    Properties_Gadget_Width = Properties::AddItem( Window_0_Properties, "Width:", #PB_GadgetType_Spin )
    Properties_Gadget_Height = Properties::AddItem( Window_0_Properties, "Height:", #PB_GadgetType_Spin )
    
    
    AddGadgetItem(Window_0_Panel_0, -1, "Объекты")
    Window_0_Tree_1 = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
    EnableGadgetDrop(Window_0_Tree_1, #PB_Drop_Text, #PB_Drag_Copy)
    
    AddGadgetItem(Window_0_Panel_0, -1, "Событие")
    CloseGadgetList()
    
    Window_0_Splitter_0 = SplitterGadget(#PB_Any, 5, 5, 230-10, 600-MenuHeight()-10, Window_0_Tree_0, Window_0_Panel_0, #PB_Splitter_FirstFixed)
    SetGadgetState(Window_0_Splitter_0, 145)
    
    LoadControls()
    Window_0_Panel_0_Resize_Event()
    
    BindEvent(#PB_Event_Menu, @Window_Event(), Window_0)
    BindEvent(#PB_Event_Gadget, @Window_Event(), Window_0)
    BindEvent(#PB_Event_SizeWindow, @Window_0_Resize_Event(), Window_0)
    BindEvent(#PB_Event_Gadget, @Window_0_Panel_0_Resize_Event(), Window_0, Window_0_Panel_0, #PB_EventType_Resize)
  EndIf
  
  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Panel_0_Resize_Event()
  Protected GadgetWidth = GetGadgetAttribute(Window_0_Panel_0, #PB_Panel_ItemWidth)
  Protected GadgetHeight = GetGadgetAttribute(Window_0_Panel_0, #PB_Panel_ItemHeight)
  
  Select GetGadgetItemText(Window_0_Panel_0, GetGadgetState(Window_0_Panel_0))
    Case "Свойства" : Properties::Size(GadgetWidth, GadgetHeight)
    Case "Объекты"  : ResizeGadget(Window_0_Tree_1, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
  EndSelect
EndProcedure

Procedure Window_0_Resize_Event()
  Protected WindowWidth = WindowWidth(Window_0)
  Protected WindowHeight = WindowHeight(Window_0)-MenuHeight()
  ResizeGadget(Window_0_Splitter_0, 5, 5, WindowWidth - 10, WindowHeight - 10)
  Window_0_Panel_0_Resize_Event()
EndProcedure

Procedure Window_Event()
  Select Event()
    Case #PB_Event_Gadget
      Select EventGadget()
        Case Window_0_Tree_0
          Select EventType()
            Case #PB_EventType_Change      
              Properties::UpdateProperties(*This\Object(GetGadgetText(EventGadget())))
          EndSelect
          
        Case Window_0_Tree_1
          Select EventType()
            Case #PB_EventType_DragStart
              DragText(GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget())))
          EndSelect
      EndSelect
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case Window_0_Menu_0_New
          CreateObject("Window")
          
        Case Window_0_Menu_0_Open
          Define File$=OpenFileRequester("Выберите файл с описанием окон", "", "Все файлы|*", 0)
          If File$
            Define Load$ = ParsePBFile(File$)
            
            Protected IsContainer.b, Object, SubItem
            PushListPosition(ParsePBGadget())
            ForEach ParsePBGadget()
              Object = *This\Object(ParsePBGadget()\ID$)
              
              If IsGadget(Object) 
                Select GadgetType(Object)
                  Case #PB_GadgetType_Container, #PB_GadgetType_Panel, #PB_GadgetType_ScrollArea
                    IsContainer = #True
                EndSelect
              EndIf
              
              ;If IsWindow(Object) Or IsContainer
                AddGadgetItem (Window_0_Tree_0, -1, ParsePBGadget()\ID$, 0, ParsePBGadget()\SubLevel)
                ;SubItem + 1
;               EndIf
;               If IsGadget(Object)
;                 AddGadgetItem (Window_0_Tree_0, -1, ParsePBGadget()\ID$, 0, ParsePBGadget()\SubLevel)
;               EndIf
            Next
            PopListPosition(ParsePBGadget())
            
            SetGadgetItemState(Window_0_Tree_0, 0, #PB_Tree_Expanded|#PB_Tree_Selected)
              
          EndIf 
          
 
      EndSelect
  EndSelect
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  MainWindow = Window_0_Open(#PB_Window_SystemMenu|
                             #PB_Window_SizeGadget)
  
  While IsWindow(MainWindow)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(MainWindow)
        EndIf
    EndSelect
  Wend
CompilerEndIf
