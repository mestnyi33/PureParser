; Должен находить функции
; Различать где нашел
; то есть внутри процедури или где то еще
;-
XIncludeFile "Enumeration.pbi"
XIncludeFile "Transformation.pbi"
XIncludeFile "Property.pbi"


EnableExplicit

Global Window_0

Global Editor_0, Editor_1, Editor_2, Check,Open,Run,Save

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
  File$
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
  
  Map Object.i()
  Map Parent.i()
  Map Font.FONT()
  Map Img.IMG()
  
  Content$            ; Содержимое. К примеру: "OpenWindow(#Butler_Window_Settings, x, y, width, height, "Настройки", #PB_Window_SystemMenu)"
  Position.i          ; Положение Content-a в исходном файле
  Length.i            ; длинна Content-a в исходном файле
  
  Font1.i
  
  
EndStructure

Global NewList OpenPBGadget.ParsePBGadget() 
Global NewList ParsePBGadget.ParsePBGadget() 
Global *This.ParsePBGadget = AllocateStructure(ParsePBGadget)

CompilerIf #PB_Compiler_IsMainFile
  #File=0
  #Window=0
  
  Enumeration RegularExpression
    #RegEx_Function
    #RegEx_Arguments
    #RegEx_Captions
    #Regex_Procedure
    #RegEx_Var
  EndEnumeration
  
  Procedure$ GetCaptions(String$)
    Protected Result$
    ; TODO Если будут встречаться такие вункции; Chr (; Str  (; FontID   ( будут проблемы
    
    If ExamineRegularExpression(#RegEx_Captions, String$)
      While NextRegularExpressionMatch(#RegEx_Captions)
        Select RegularExpressionGroup(#RegEx_Captions, 1)
          Case "#PB_Compiler_Home"                                        : Result$+#PB_Compiler_Home
          Case "Chr("+RegularExpressionGroup(#RegEx_Captions, 3)+")"      : Result$+Chr(10)
          Case "Str("+RegularExpressionGroup(#RegEx_Captions, 3)+")"      : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
          Case "FontID("+RegularExpressionGroup(#RegEx_Captions, 3)+")"   : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
          Case "GadgetID("+RegularExpressionGroup(#RegEx_Captions, 3)+")" : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
          Case "WindowID("+RegularExpressionGroup(#RegEx_Captions, 3)+")" : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
          Case "ImageID("+RegularExpressionGroup(#RegEx_Captions, 3)+")"  : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
          Default                                                         : Result$+RegularExpressionGroup(#RegEx_Captions, 2) ; То что между кавичкамы
        EndSelect
      Wend
    EndIf
    
    ProcedureReturn Result$
  EndProcedure
  
  Procedure AddPBFunction(*This.ParsePBGadget, Index)
    Protected Param1, Param2, Param3
              
    With *This
     Select \Type$
        Case "LoadFont"
          Select Index
            Case 1 : \ID$ = \Args$
            Case 2 : \Param1$ = \Args$
            Case 3 : \Param2$ = \Args$
            Case 4 : \Param3$ = \Args$
          EndSelect
          
        Case "LoadImage"
          Select Index
            Case 1 : \ID$ = \Args$
            Case 2 : \Param1$=GetCaptions(\Args$)
              Debug \Param1$
          EndSelect
          
        Case "SetGadgetFont"
          Select Index
            Case 1 : \ID$ = \Args$
            Case 2 : \Param1$=GetCaptions(\Args$)
          EndSelect
          
        Case "SetGadgetState"
          Select Index
            Case 1 : \ID$ = \Args$
            Case 2 : \Param1$=GetCaptions(\Args$)
          EndSelect
          
        Case "SetGadgetText"
          Select Index
            Case 1 : \ID$ = \Args$
            Case 2 : \Param1$=GetCaptions(\Args$)
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
              If ExamineRegularExpression(#RegEx_Captions, \Args$)
                While NextRegularExpressionMatch(#RegEx_Captions)
                  If "RGB("+RegularExpressionGroup(#RegEx_Captions, 3)+")"=RegularExpressionGroup(#RegEx_Captions, 1)
                    If ExamineRegularExpression(#RegEx_Arguments, RegularExpressionGroup(#RegEx_Captions, 3)) : Index=0
                      While NextRegularExpressionMatch(#RegEx_Arguments) : Index+1
                        Select Index
                          Case 1
                            Param1 = Val(RegularExpressionMatchString(#RegEx_Arguments))
                          Case 2
                            Param2 = Val(RegularExpressionMatchString(#RegEx_Arguments))
                          Case 3
                            Param3 = Val(RegularExpressionMatchString(#RegEx_Arguments))
                        EndSelect
                      Wend
                      \Param2 = RGB(Param1, Param2, Param3)
                    EndIf
                  EndIf
                Wend
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
    Static Parent=-1
    Protected OpenGadgetList, GetParent, Result, ID=-1
    
    With *This
      Select \Type$
        Case "OpenWindow"          : ID = OpenWindow          (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag|#PB_Window_SizeGadget) 
        Case "ButtonGadget"        : ID = ButtonGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "StringGadget"        : ID = StringGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "TextGadget"          : ID = TextGadget          (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "CheckBoxGadget"      : ID = CheckBoxGadget      (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "OptionGadget"        : ID = OptionGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$)
        Case "ListViewGadget"      : ID = ListViewGadget      (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "FrameGadget"         : ID = FrameGadget         (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "ComboBoxGadget"      : ID = ComboBoxGadget      (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "ImageGadget"         : ID = ImageGadget         (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
        Case "HyperLinkGadget"     : ID = HyperLinkGadget     (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
        Case "ContainerGadget"     : ID = ContainerGadget     (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "ListIconGadget"      : ID = ListIconGadget      (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
        Case "IPAddressGadget"     : ID = IPAddressGadget     (#PB_Any, \X,\Y,\Width,\Height)
        Case "ProgressBarGadget"   : ID = ProgressBarGadget   (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
        Case "ScrollBarGadget"     : ID = ScrollBarGadget     (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Param3, \Flag)
        Case "ScrollAreaGadget"    : ID = ScrollAreaGadget    (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Param3, \Flag) 
        Case "TrackBarGadget"      : ID = TrackBarGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
        Case "WebGadget"           : ID = WebGadget           (#PB_Any, \X,\Y,\Width,\Height, \Caption$)
        Case "ButtonImageGadget"   : ID = ButtonImageGadget   (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
        Case "CalendarGadget"      : ID = CalendarGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
        Case "DateGadget"          : ID = DateGadget          (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
        Case "EditorGadget"        : ID = EditorGadget        (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "ExplorerListGadget"  : ID = ExplorerListGadget  (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "ExplorerTreeGadget"  : ID = ExplorerTreeGadget  (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "ExplorerComboGadget" : ID = ExplorerComboGadget (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "SpinGadget"          : ID = SpinGadget          (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
        Case "TreeGadget"          : ID = TreeGadget          (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "PanelGadget"         : ID = PanelGadget         (#PB_Any, \X,\Y,\Width,\Height) 
        Case "SplitterGadget"      
          Debug "Splitter FirstGadget "+\Param1
          Debug "Splitter SecondGadget "+\Param2
          If IsGadget(\Param1) And IsGadget(\Param2)
            ID = SplitterGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
          EndIf
        Case "MDIGadget"          
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            ID = MDIGadget           (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag) 
          CompilerEndIf
        Case "ScintillaGadget"     : ID = ScintillaGadget     (#PB_Any, \X,\Y,\Width,\Height, \Param1)
        Case "ShortcutGadget"      : ID = ShortcutGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1)
        Case "CanvasGadget"        : ID = CanvasGadget        (#PB_Any, \X,\Y,\Width,\Height, \Flag)
      EndSelect
      
      If IsGadget(ID)
        AddMapElement(\Object(), \ID$) : \Object()=ID
        AddMapElement(\Parent(), Str(ID)) : \Parent()=Parent
      EndIf
      
      Select \Type$
        Case "OpenWindow" : Parent = ID 
        Case "UseGadgetList" : UseGadgetList( WindowID(Parent) )
        Case "ContainerGadget", "ScrollAreaGadget", "PanelGadget" :  Parent = ID 
        Case "CloseGadgetList" 
          If IsGadget(Parent) : CloseGadgetList() : Parent = \Parent(Str(Parent)) : EndIf
          
        Case "AddGadgetColumn"       
          AddGadgetColumn( \Object(\ID$), \Param1, \Caption$, \Param2)
        Case "AddGadgetItem"   
          If IsGadget(\Object(\ID$))
            AddGadgetItem( \Object(\ID$), \Param1, \Caption$, \Param2, \Flag)
          Else
            Debug "add "+\ID$
          EndIf
          
        Case "OpenGadgetList"      
          Parent = \Object(\ID$)
          
          If IsGadget(Parent)
            OpenGadgetList( Parent, \Param1 )
          EndIf
      EndSelect
      
      If IsGadget(ID)
        ParsePBGadget()\ID = ID
        
        If IsGadget(Parent)
          GetParent = \Parent(Str(Parent))
        EndIf
        
        If ID = Parent
          If IsWindow(GetParent)
            CloseGadgetList() ; Bug PB
            UseGadgetList(WindowID(GetParent))
          EndIf
          If IsGadget(GetParent) 
            OpenGadgetList = OpenGadgetList(GetParent) 
          EndIf
        EndIf
        
        Transformation::Enable(ID, 5)
        
        If GadgetType(ID) = #PB_GadgetType_Splitter
          Transformation::Disable(GetGadgetAttribute(ID, #PB_Splitter_FirstGadget))
          Transformation::Disable(GetGadgetAttribute(ID, #PB_Splitter_SecondGadget))
        EndIf
        
        If ID = Parent
          If IsWindow(GetParent) 
            OpenGadgetList(ID) 
          EndIf
          If OpenGadgetList 
            CloseGadgetList() 
          EndIf
        EndIf
        
;         If (GetWindowLongPtr_(GadgetID( ID ), #GWL_STYLE) & #WS_CLIPSIBLINGS) = #False
;           SetWindowLongPtr_(GadgetID( ID ), #GWL_STYLE, GetWindowLongPtr_(GadgetID( ID ), #GWL_STYLE) | #WS_CLIPSIBLINGS)
;         EndIf
;         
;         If (GetWindowLongPtr_(GadgetID( ID ), #GWL_STYLE) & #WS_CLIPCHILDREN) = #False
;           SetWindowLongPtr_(GadgetID( ID ), #GWL_STYLE, GetWindowLongPtr_(GadgetID( ID ), #GWL_STYLE) | #WS_CLIPCHILDREN)
;         EndIf
        

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
  Procedure$ FindVar(File, *File, Length, Format, StrToFind$)
    Protected result$
    Protected Line, FindWindow, Content$, FunctionName$, FunctionArgs$
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
    
    If *File 
      ;FileSeek(File, Loc(File), #PB_Absolute)
      ReadData(File, *File, Length)
      Protected String$ = PeekS(*File, Length, Format)
      
      If CreateRegularExpression(#RegEx_Var, "(\s*?"+StrToFind$+"\s*?=\s*?)(\d+)", Create_Reg_Flag)
        
        If ExamineRegularExpression(#RegEx_Var, String$)
          While NextRegularExpressionMatch(#RegEx_Var)
            result$ = RegularExpressionGroup(#RegEx_Var,2)
            ;             Debug result
            ;             Debug RegularExpressionMatchLength(#RegEx_Var)
            ;             Debug RegularExpressionMatchPosition(#RegEx_Var)
            ;             Debug RegularExpressionMatchString(#RegEx_Var)
          Wend
        EndIf
      EndIf
      
      ;Debug "Position: " + Str(Loc(File))      ; отобразим текущую позицию указателя файла
      ;       FileSeek(File, 0, #PB_Absolute)
      ;       While Eof(File) = 0 ;:Line +1
      ;         Debug ReadString(File);, Format)
      ;         
      ;       Wend                          
    EndIf
    
    ProcedureReturn result$
  EndProcedure
  
  Procedure.S ParsePBFile(FileName.s)
    Protected i,result.S, Texts.S, Text.S, Find.S, String.S, Position, Args$, Count, Index
    
    If ReadFile(#File, FileName)
      Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_Extended    
      Protected Line, FindWindow, Content$, FunctionArgs$
      Protected Format=ReadStringFormat(#File)
      Protected Length = Lof(#File) 
      Protected *File = AllocateMemory(Length)
      
      If *File 
        ReadData(#File, *File, Length)
        *This\File$ = PeekS(*File, Length, Format)
        
        If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
           CreateRegularExpression(#RegEx_Arguments, ~"((?:(?:(;).*|\".*?\"|\\((.*?)\\))|\\+.*|(?=\\s*\\+)[^,]|[^,\\s])+)", Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
           CreateRegularExpression(#RegEx_Captions, ~"((?:\"(.*?)\"|\\((.*?)\\)|[^+\\s])+)", Create_Reg_Flag| #PB_RegularExpression_DotAll)
          
          If ExamineRegularExpression(#RegEx_Function, *This\File$)
            While NextRegularExpressionMatch(#RegEx_Function)
              With *This
                
                If RegularExpressionGroup(#RegEx_Function, 1) = "" And RegularExpressionGroup(#RegEx_Function, 9) = ""
                  \Type$=RegularExpressionGroup(#RegEx_Function, 7)
                  \Args$=RegularExpressionGroup(#RegEx_Function, 8)
                  
                  If RegularExpressionGroup(#RegEx_Function, 3)
                    \ID$ = RegularExpressionGroup(#RegEx_Function, 3)
                  EndIf
                  
                  If \Type$
                    Debug "All - "+RegularExpressionMatchString(#RegEx_Function)
                    
                    Select \Type$
                      Case "OpenWindow", ; FindString(\Type$, "Gadget"),-1,#PB_String_NoCase) ;
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
                        ;Debug  ParsePBGadget()\Content$
                        ParsePBGadget()\Position = RegularExpressionMatchPosition(#RegEx_Function)
                        ParsePBGadget()\Length = RegularExpressionMatchLength(#RegEx_Function)
                        ;                         Debug "Position - "+\Position
                        ;                         Debug "Length - "+\Length
                        Count = 0
                        Texts =  Chr(10)+ \Type$
                        
                        
                        If ExamineRegularExpression(#RegEx_Arguments, \Args$)
                          While NextRegularExpressionMatch(#RegEx_Arguments)
                            Count + 1
                            Args$ = RegularExpressionMatchString(#RegEx_Arguments)
                            
                            If (Count>5)
                              Select \Type$
                                Case "OpenGLGadget","EditorGadget","CanvasGadget","ComboBoxGadget","ContainerGadget","ListViewGadget","TreeGadget"
                                  Select Count 
                                    Case 6
                                      i = 4 ;Texts + #LF$ + #LF$ + #LF$ + #LF$
                                  EndSelect
                                  
                                Case "ScrollBarGadget","ScrollAreaGadget","ScintillaGadget"
                                  Select Count 
                                    Case 6
                                      i=1 ;Texts + #LF$
                                  EndSelect
                                  
                                Case "TrackBarGadget","SpinGadget","SplitterGadget","ProgressBarGadget"
                                  Select Count 
                                    Case 6,8
                                      i=1 ;Texts + #LF$
                                  EndSelect
                                  
                                Case "CalendarGadget","ButtonImageGadget","ImageGadget"
                                  Select Count 
                                    Case 6
                                      i=1 ;Texts + #LF$
                                    Case 7
                                      i=2 ;Texts + #LF$ + #LF$
                                  EndSelect
                                  
                                Case "OpenWindow",
                                     "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget","FrameGadget",
                                     "ExplorerListGadget","ExplorerTreeGadget","ExplorerComboGadget"
                                  Select Count 
                                    Case 7
                                      i=3 ; Texts + #LF$ + #LF$ + #LF$
                                  EndSelect
                                  
                                Case "HyperLinkGadget","DateGadget","ListIconGadget"
                                  Select Count 
                                    Case 8
                                      i=2 ; Texts + #LF$ + #LF$
                                  EndSelect
                                  
                              EndSelect
                            EndIf
                            
                            Protected ii : For ii=1 To i : Texts + #LF$ : Next 
                            i=Count+i
                            ii=i 
                            i=0
                            Texts + #LF$ + Args$
                            
                            ii = CountString(Texts,#LF$)-1
                            
                            Select ii
                              Case 1
                                If "#PB_Any" <> Args$
                                  \ID$ = Args$
                                EndIf
                                ParsePBGadget()\ID$ = \ID$
                                
                              Case 2 : \X$ = Args$
                                ParsePBGadget()\X$ = \X$
                                Select Asc(\X$)
                                  Case '0' To '9'
                                    \X = Val(\X$)
                                  Default
                                    \X = Val(FindVar(#File, *File, Length, Format, \X$))
                                EndSelect
                              Case 3 : \Y$ = Args$
                                ParsePBGadget()\Y$ = \Y$
                                Select Asc(\Y$)
                                  Case '0' To '9'
                                    \Y = Val(\Y$)
                                  Default
                                    \Y = Val(FindVar(#File, *File, Length, Format, \Y$))
                                EndSelect
                              Case 4 : \Width$ = Args$
                                ParsePBGadget()\Width$ = \Width$
                                Select Asc(\Width$)
                                  Case '0' To '9'
                                    \Width = Val(\Width$)
                                  Default
                                    \Width = Val(FindVar(#File, *File, Length, Format, \Width$))
                                EndSelect
                              Case 5 : \Height$ = Args$
                                ParsePBGadget()\Height$ = \Height$
                                Select Asc(\Height$)
                                  Case '0' To '9'
                                    \Height = Val(\Height$)
                                  Default
                                    \Height = Val(FindVar(#File, *File, Length, Format, Trim(Args$)))
                                EndSelect
                              Case 6
                                \Caption$ = Trim(Trim(Args$), Chr(34))
                                ParsePBGadget()\Caption$ = \Caption$
                                
                              Case 7 
                                If \Type$ = "SplitterGadget"      
                                  \Param1 = \Object(Args$)
                                ElseIf \Type$ = "ImageGadget"      
                                  \Param1$ = GetCaptions(Args$)
                                  Protected Img = \Img(\Param1$)\ID 
                                  If IsImage(Img)
                                    \Param1 = ImageID(img)
                                  EndIf
                                  
                                Else
                                  \Param1$ = Trim(Args$)
                                  ParsePBGadget()\Param1$ = \Param1$
                                Select Asc(Trim(Args$))
                                    Case '0' To '9'
                                      \Param1 = Val(Args$)
                                    Default
                                  EndSelect
                                EndIf
                                
                              Case 8 : \Param2$ = Trim(Args$)
                               ParsePBGadget()\Param2$ = \Param2$
                                 Select Asc(Trim(Args$))
                                  Case '0' To '9'
                                    \Param2 = Val(Args$)
                                  Default
                                    If \Type$ = "SplitterGadget"      
                                      \Param2 = \Object(Args$)
                                    EndIf
                                EndSelect
                                
                              Case 9 : \Param3$ = Trim(Args$)
                                ParsePBGadget()\Param3$ = \Param3$
                                \Param3 = Val(Args$)
                                
                              Case 10 : \Flag$ = Trim(Args$)
                                ParsePBGadget()\Flag$ = \Flag$
                                \Flag = OpenPBObjectFlag(Args$)
                                If Not \Flag
                                  Select Asc(\Flag$)
                                    Case '0' To '9'
                                    Default
                                      \Flag = OpenPBObjectFlag(FindVar(#File, *File, Length, Format, Trim(Args$)))
                                  EndSelect
                                EndIf
                            EndSelect
                            
                          Wend
                        EndIf
                        
                        Protected win = CallFunctionFast(@OpenPBObject(), *This)
                        
                        \ID=-1
                        \Flag = 0
                        \Param1 = 0
                        \Param2 = 0
                        \Param3 = 0
                        \ID$=""
                        \Flag$ = ""
                        \Param1$ = ""
                        \Param2$ = ""
                        \Param3$ = ""
                        \Caption$ = ""
                        
                        AddGadgetItem(Editor_2, -1, Texts)
                        Texts = ""
                        
                      Case "CloseGadgetList"      : CallFunctionFast(@OpenPBObject(), *This) ; , "UseGadgetList" ; TODO
                        
                      Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"      
                        If ExamineRegularExpression(#RegEx_Arguments, \Args$)
                          Index=0
                          While NextRegularExpressionMatch(#RegEx_Arguments)
                            Index+1
                            Protected Args3$ = RegularExpressionMatchString(#RegEx_Arguments)
                            ;Debug Str(Index)+" "+Args3$
                            
                            Select Index
                              Case 1
                                \ID$ = Trim(Args3$)
                                Debug RegularExpressionGroup(#RegEx_Function, 2)
                                
                              Case 2
                                \Param1 = Val(Args3$)
                              Case 3
                                \Caption$=GetCaptions(Args3$)
                                
                                
                              Case 4
                                \Param2 = Val(Args3$)
                              Case 5
                                \Flag$ = Trim(Args3$)
                                \Flag = OpenPBObjectFlag(Args3$)
                                If Not \Flag
                                  Select Asc(\Flag$)
                                    Case '0' To '9'
                                    Default
                                      \Flag = OpenPBObjectFlag(FindVar(#File, *File, Length, Format, Trim(Args3$)))
                                  EndSelect
                                EndIf
                            EndSelect
                            
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
                        
                      Default
                        If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                          While NextRegularExpressionMatch(#RegEx_Arguments) : Index+1
                            \Args$ = RegularExpressionMatchString(#RegEx_Arguments)
                            AddPBFunction(*This, Index)
                          Wend
                          
                          SetPBFunction(*This)
                        EndIf
                        
                    EndSelect
                    
                  EndIf
                EndIf
              EndWith
            Wend
            
          EndIf
          
          
        EndIf
      EndIf
      
      CloseFile(#File)
      Protected Property = Property_Window_Show( win ); WindowID(win))
                                                      ;       ResizeWindow(Property, WindowX(win)+WindowWidth(win), WindowY(win), #PB_Ignore, #PB_Ignore)
                                                      ;       SetActiveWindow(win)
                                                      ;       SetActiveWindow(Property)
    EndIf
    
    ;Debug result
    ProcedureReturn result.S
  EndProcedure
  
  ;-
  Procedure Window_0_Event_Gadget()
    Static Time
    Protected Load$,Title$,File$,Pattern$,Pattern
    
    Select EventGadget()
        ;-OpenEvent
      Case Open
        Time = ElapsedMilliseconds()
        ;{ 
        Title$="Open PureBasic project"
        File$ = "test1.pb"
        Pattern$ = "PureBasic (*.pb*)|*.pb*"
        Pattern = 0
        
        File$ = OpenFileRequester(Title$,File$,Pattern$,Pattern)
        If File$
          ClearGadgetItems(Editor_2)
          Load$ = ParsePBFile(File$)
          ClearGadgetItems(Editor_0)
          AddGadgetItem(Editor_0,-1,Load$)
        EndIf 
        ;}
        Time = ElapsedMilliseconds() - Time
        
        SetWindowTitle(EventWindow(), Str(Time))
        
        ;-RunEvent
      Case Run  
        Protected Object, len, add$ ;= " ; ADD" 
        Protected Space$, StringtoAdd$ = "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
        Protected Length 
        
        ;PokeS(@*This\File$, "999", 2)
        len = 0
        
        PushListPosition(ParsePBGadget())
        ForEach ParsePBGadget()
          
          If Enumerate::StartWindow( )
            While Enumerate::NextWindow( @Object )
              If ParsePBGadget()\ID = Object
                ParsePBGadget()\X$ = Str(WindowX(Object))
                ParsePBGadget()\Y$ = Str(WindowY(Object))
                ParsePBGadget()\Width$ = Str(WindowWidth(Object))
                ParsePBGadget()\Height$ = Str(WindowHeight(Object))
                ParsePBGadget()\Caption$ = GetWindowTitle(Object)
              EndIf
            Wend
            Enumerate::AbortWindow() 
          EndIf
          
          If Enumerate::StartGadget( )
            While Enumerate::NextGadget( @Object )
              If ParsePBGadget()\ID = Object
                ParsePBGadget()\X$ = Str(GadgetX(Object))
                ParsePBGadget()\Y$ = Str(GadgetY(Object))
                ParsePBGadget()\Width$ = Str(GadgetWidth(Object))
                ParsePBGadget()\Height$ = Str(GadgetHeight(Object))
                ParsePBGadget()\Caption$ = GetGadgetText(Object)
              EndIf
            Wend
            Enumerate::AbortGadget() 
          EndIf
          
          StringtoAdd$ = SavePBObject(ParsePBGadget())
          Debug ">>> - "+StringtoAdd$
          
          Length = Len(StringtoAdd$)
          
          If Length>ParsePBGadget()\Length
            *This\File$ = InsertString(*This\File$, Space(Length), ParsePBGadget()\Position+ParsePBGadget()\Length+len+1)
            len + Length
          Else
            Space$ = Space(ParsePBGadget()\Length-Length)
          EndIf
          
          ReplaceString(*This\File$, ParsePBGadget()\Content$, StringtoAdd$+Space$, #PB_String_InPlace, ParsePBGadget()\Position, 1)
          ;           ParsePBGadget()\Content$ = StringtoAdd$+Space$
          ;           ParsePBGadget()\Length = Len(StringtoAdd$+Space$)
        Next
        PopListPosition(ParsePBGadget())
        
        Debug *This\File$
        
        
        ;-SaveEvent
      Case Save  
        File$="test1.pb"
        Title$=File$+"/save"
        Pattern$="PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*"
        
        File$ = SaveFileRequester(Title$,File$,Pattern$,0)
        If File$
          If OpenFile(#File, File$) 
            WriteString(#File, *This\File$, #PB_UTF8) 
            CloseFile(#File)                       
          Else
            MessageRequester("Information","may not create the file!")
          EndIf
        EndIf 
        
        ;-CheckEvent
      Case Check  
        If EventType() = #PB_EventType_Change
          Protected ID$ = StringField(GetGadgetItemText(Check,GetGadgetState(Check)),1,":")
          Protected Type = FindString(StringField(GetGadgetItemText(Check,GetGadgetState(Check)),3,":"),"OpenWindow")
          Protected ID = Val(ID$)
          
          Debug ID
          If Type
            If IsWindow(ID)
              SetActiveWindow(ID)
            EndIf
          Else
            If IsGadget(ID)
              SetActiveGadget(ID)
            EndIf
          EndIf
        EndIf
    EndSelect
  EndProcedure
  
  Procedure Window_0_Event_Size()
    Protected Window = EventWindow()
    Protected WindowWidth, WindowHeight
    WindowWidth = WindowWidth(Window)
    WindowHeight = WindowHeight(Window)/3-15
    ResizeGadget(Editor_0, 6, 6, WindowWidth - 12, WindowHeight)
    ResizeGadget(Editor_1, 6, GadgetY(Editor_0)+GadgetHeight(Editor_0)+3, WindowWidth - 12, GadgetHeight(Editor_0))
    ResizeGadget(Editor_2, 6, GadgetY(Editor_1)+GadgetHeight(Editor_1)+3, WindowWidth - 12, GadgetHeight(Editor_1))
    
    ResizeGadget(Save, WindowWidth-240, (WindowHeight*3)+17, #PB_Ignore,#PB_Ignore)
    ResizeGadget(Run, WindowWidth-160, (WindowHeight*3)+17, #PB_Ignore,#PB_Ignore)
    ResizeGadget(Open, WindowWidth-80, (WindowHeight*3)+17, #PB_Ignore,#PB_Ignore)
    
    ResizeGadget(Check, #PB_Ignore, (WindowHeight*3)+17, GadgetX(Save)-12,#PB_Ignore)
  EndProcedure
  
  Procedure Window_0_Open(X = 0, Y = 0, Width = 966, Height = 530)
    Protected Flags  = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget |
                       #PB_Window_SizeGadget | #PB_Window_Invisible |
                       #PB_Window_ScreenCentered
    
    Window_0 = OpenWindow(#PB_Any, X, Y, Width, Height, "", Flags)
    ResizeWindow(Window_0,#PB_Ignore,WindowY(Window_0)<<1-35,#PB_Ignore,#PB_Ignore)
    SendMessage_(WindowID(Window_0), #WM_SETICON, 0, ExtractIcon_(0,"shell32.dll",2))
    ;       StickyWindow(Window_0,#True)
    
    Editor_0 = EditorGadget(#PB_Any, 6, 6, 354, 138)
    Editor_1 = EditorGadget(#PB_Any, 6, 150, 354, 102)
    Editor_2 = ListIconGadget(#PB_Any, 6, 150, 354, 88,"Text.S",180)
    ;   AddGadgetColumn(Editor_2, 1, "Count.S", 80)
    ;   AddGadgetColumn(Editor_2, 2, "Line.S", 80)
    ;   
    ;   AddGadgetColumn(Editor_2, 3, "Position.S", 80)
    ;   AddGadgetColumn(Editor_2, 4, "Lentgh.S", 80)
    
    ;   AddGadgetColumn(Editor_2, 5, "Param1.S", 80)
    ;   AddGadgetColumn(Editor_2, 6, "Param2.S", 80)
    ;   
    ;   AddGadgetColumn(Editor_2, 7, "Param3.S", 80)
    ;   AddGadgetColumn(Editor_2, 8, "Line.S", 80)
    ;   
    ;   AddGadgetColumn(Editor_2, 9, "Text.S", 80)
    ;   AddGadgetColumn(Editor_2, 10, "Line.S", 80)
    ;   
    AddGadgetColumn(Editor_2, 11, "Type.S", 130)
    AddGadgetColumn(Editor_2, 12, "ID.S", 80)
    AddGadgetColumn(Editor_2, 13, "X", 40)
    AddGadgetColumn(Editor_2, 14, "Y", 40)
    AddGadgetColumn(Editor_2, 15, "Width", 50)
    AddGadgetColumn(Editor_2, 16, "Height", 50)
    AddGadgetColumn(Editor_2, 17, "Caption.S", 80)
    AddGadgetColumn(Editor_2, 18, "Param1.S", 60)
    AddGadgetColumn(Editor_2, 19, "Param2.S", 60)
    AddGadgetColumn(Editor_2, 20, "Param3.S", 60)
    ;AddGadgetColumn(Editor_2, 21, "Flag", 80)
    AddGadgetColumn(Editor_2, 22, "Flag.S", 180)
    
    Save = ButtonGadget(#PB_Any, Width-240, 258, 75, 25,"Save")
    Run = ButtonGadget(#PB_Any, Width-160, 258, 75, 25,"Run")
    Open = ButtonGadget(#PB_Any, Width-80, 258, 75, 25,"Open")
    
    Check = ComboBoxGadget(#PB_Any, 6, 258, GadgetX(Save)-12, 24)
    
    
    BindEvent(#PB_Event_SizeWindow, @Window_0_Event_Size(),Window_0)
    BindEvent(#PB_Event_Gadget, @Window_0_Event_Gadget(),Window_0)
    HideWindow(Window_0,#False)
    ProcedureReturn Window_0
  EndProcedure
  
  ;-
  Window_0 = Window_0_Open()
  
  ;Define File$ = "CFE_Read_Test(const).pbf"
  ;Define File$ = "CFE_Read_Test(variab).pbf"
  Define File$=OpenFileRequester("Выберите файл с описанием окон", "", "Все файлы|*", 0)
  If File$
    ClearGadgetItems(Editor_2)
    Define Load$ = ParsePBFile(File$)
    ClearGadgetItems(Editor_0)
    AddGadgetItem(Editor_0,-1,Load$)
  EndIf 
  
  While IsWindow( Window_0 )
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow 
        CloseWindow( EventWindow() )
    EndSelect
  Wend
  
  End 
CompilerEndIf