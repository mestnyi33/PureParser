; Должен находить функции
; Различать где нашел
; то есть внутри процедури или где то еще
;-
EnableExplicit

Global Window_0

Global Editor_0, Editor_1, Editor_2, Check,Open,Run,Save


Structure ParsePBGadget
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
  
  ID$ 
  Type$
  X$ 
  Y$
  Width$
  Height$
  Caption$
  Param1$
  Param2$
  Param3$
  Flag$
  
  Position.i
  Length.i
  
  Class$
  FuncClass$
  Font.i
  File$
  Function$
EndStructure

Global NewList ParsePBGadget.ParsePBGadget() 
Global *This.ParsePBGadget = AllocateStructure(ParsePBGadget)


CompilerIf #PB_Compiler_IsMainFile
  #File=0
  #Window=0
  
  Enumeration RegularExpression
    #RegEx_FindFunction
    #RegEx_FindArguments
    #Regex_FindProcedure
    #RegEx_FindVar
  EndEnumeration
  
  Procedure PB_Flag(Flag$) ; Ok
    Protected i
    Protected Flag 
    For i = 0 To CountString(Flag$,"|")
      Select Trim(StringField(Flag$,(i+1),"|"))
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
          ; button  
        Case "#PB_Button_Default"                 : Flag = Flag | #PB_Button_Default
        Case "#PB_Button_Left"                    : Flag = Flag | #PB_Button_Left
        Case "#PB_Button_MultiLine"               : Flag = Flag | #PB_Button_MultiLine
        Case "#PB_Button_Right"                   : Flag = Flag | #PB_Button_Right
        Case "#PB_Button_Toggle"                  : Flag = Flag | #PB_Button_Toggle
          ; buttonimage 
        Case "#PB_Button_Image"                   : Flag = Flag | #PB_Button_Image
        Case "#PB_Button_PressedImage"            : Flag = Flag | #PB_Button_PressedImage
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
          ; checkbox
        Case "#PB_CheckBox_Center"                : Flag = Flag | #PB_CheckBox_Center
        Case "#PB_CheckBox_Right"                 : Flag = Flag | #PB_CheckBox_Right
        Case "#PB_CheckBox_ThreeState"            : Flag = Flag | #PB_CheckBox_ThreeState
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
      EndSelect
    Next
    ProcedureReturn Flag
  EndProcedure 
  
  Procedure PB_Type(Class$) ; Ok
    Enumeration - 7         ; Type
      #__Type_Message       ; -7
      #__Type_PopupMenu     ; -6
      #__Type_Desktop       ; -5
      #__Type_StatusBar     ; -4
      #__Type_Menu          ; -3 "Menu"
      #__Type_Toolbar       ; -2 "Toolbar"
      #__Type_Window        ; -1 "Window"
      #__Type_Unknown       ; 0 "Create"
      #__Type_Button        ; 1 "Button"
      #__Type_String        ; 2 "String"
      #__Type_Text          ; 3 "Text"
      #__Type_CheckBox      ; 4 "CheckBox"
      #__Type_Option        ; 5 "Option"
      #__Type_ListView      ; 6 "ListView"
      #__Type_Frame         ; 7 "Frame"
      #__Type_ComboBox      ; 8 "ComboBox"
      #__Type_Image         ; 9 "Image"
      #__Type_HyperLink     ; 10 "HyperLink"
      #__Type_Container     ; 11 "Container"
      #__Type_ListIcon      ; 12 "ListIcon"
      #__Type_IPAddress     ; 13 "IPAddress"
      #__Type_ProgressBar   ; 14 "ProgressBar"
      #__Type_ScrollBar     ; 15 "ScrollBar"
      #__Type_ScrollArea    ; 16 "ScrollArea"
      #__Type_TrackBar      ; 17 "TrackBar"
      #__Type_Web           ; 18 "Web"
      #__Type_ButtonImage   ; 19 "ButtonImage"
      #__Type_Calendar      ; 20 "Calendar"
      #__Type_Date          ; 21 "Date"
      #__Type_Editor        ; 22 "Editor"
      #__Type_ExplorerList  ; 23 "ExplorerList"
      #__Type_ExplorerTree  ; 24 "ExplorerTree"
      #__Type_ExplorerCombo ; 25 "ExplorerCombo"
      #__Type_Spin          ; 26 "Spin"
      #__Type_Tree          ; 27 "Tree"
      #__Type_Panel         ; 28 "Panel"
      #__Type_Splitter      ; 29 "Splitter"
      #__Type_MDI           ; 30
      #__Type_Scintilla     ; 31 "Scintilla"
      #__Type_Shortcut      ; 32 "Shortcut"
      #__Type_Canvas        ; 33 "Canvas"
      
      #__Type_ImageButton    ; 34 "ImageButton"
      #__Type_Properties     ; 35 "Properties"
      
      #__Type_StringImageButton    ; 36 "ImageButton"
      #__Type_StringButton         ; 37 "ImageButton"
      #__Type_AnchorButton         ; 38 "ImageButton"
      #__Type_ComboButton          ; 39 "ImageButton"
      #__Type_DropButton           ; 40 "ImageButton"
      
    EndEnumeration
    
    If     FindString(Class$, LCase("Desktop")       ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Desktop
    ElseIf FindString(Class$, LCase("PopupMenu")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_PopupMenu
    ElseIf FindString(Class$, LCase("Toolbar")       ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Toolbar
    ElseIf FindString(Class$, LCase("Menu")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Menu
    ElseIf FindString(Class$, LCase("Status")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_StatusBar
    ElseIf FindString(Class$, LCase("Window")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Window
    ElseIf FindString(Class$, LCase("ButtonImage")   ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ButtonImage
    ElseIf FindString(Class$, LCase("String")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_String
    ElseIf FindString(Class$, LCase("Text")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Text
    ElseIf FindString(Class$, LCase("CheckBox")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_CheckBox
    ElseIf FindString(Class$, LCase("Option")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Option
    ElseIf FindString(Class$, LCase("ListView")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ListView
    ElseIf FindString(Class$, LCase("Frame")         ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Frame  
    ElseIf FindString(Class$, LCase("ComboBox")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ComboBox
    ElseIf FindString(Class$, LCase("Image")         ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Image
    ElseIf FindString(Class$, LCase("HyperLink")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_HyperLink
    ElseIf FindString(Class$, LCase("Container")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Container
    ElseIf FindString(Class$, LCase("ListIcon")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ListIcon
    ElseIf FindString(Class$, LCase("IPAddress")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_IPAddress
    ElseIf FindString(Class$, LCase("ProgressBar")   ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ProgressBar
    ElseIf FindString(Class$, LCase("ScrollBar")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ScrollBar
    ElseIf FindString(Class$, LCase("ScrollArea")    ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ScrollArea
    ElseIf FindString(Class$, LCase("TrackBar")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_TrackBar
    ElseIf FindString(Class$, LCase("Web")           ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Web
    ElseIf FindString(Class$, LCase("Button")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Button
    ElseIf FindString(Class$, LCase("Calendar")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Calendar
    ElseIf FindString(Class$, LCase("Date")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Date
    ElseIf FindString(Class$, LCase("Editor")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Editor
    ElseIf FindString(Class$, LCase("ExplorerList")  ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ExplorerList
    ElseIf FindString(Class$, LCase("ExplorerTree")  ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ExplorerTree
    ElseIf FindString(Class$, LCase("ExplorerCombo") ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_ExplorerCombo
    ElseIf FindString(Class$, LCase("Spin")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Spin
    ElseIf FindString(Class$, LCase("Tree")          ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Tree
    ElseIf FindString(Class$, LCase("Panel")         ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Panel
    ElseIf FindString(Class$, LCase("Splitter")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Splitter
    ElseIf FindString(Class$, LCase("MDI")           ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_MDI
    ElseIf FindString(Class$, LCase("Scintilla")     ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Scintilla
    ElseIf FindString(Class$, LCase("Shortcut")      ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Shortcut
    ElseIf FindString(Class$, LCase("Canvas")        ,-1,#PB_String_NoCase) :ProcedureReturn #__Type_Canvas
    EndIf
    
    ProcedureReturn #False
  EndProcedure
  
  Procedure SetPBFunction(*This.ParsePBGadget)
    
    With *This
      PushListPosition(ParsePBGadget())
      ForEach ParsePBGadget()
        Select \Type$
          Case "SetGadgetFont"
            If ParsePBGadget()\ID$ = Trim(\ID$)
              If IsFont(\Font)
                SetGadgetFont(ParsePBGadget()\ID, FontID(\Font))
              EndIf
            EndIf
        EndSelect
      Next
      PopListPosition(ParsePBGadget())
    EndWith
    
  EndProcedure
  
  Procedure CreatePBGadget(*This.ParsePBGadget)
    Protected Result
    
    With *This
      Select \Type$
        Case "OpenWindow"          : \ID = OpenWindow          (#PB_Any, \X,\Y,\Width,\Height, \Caption$,\Flag|#PB_Window_SizeGadget) 
        Case "ButtonGadget"        : \ID = ButtonGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$,\Flag)
        Case "StringGadget"        : \ID = StringGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$,\Flag)
        Case "TextGadget"          : \ID = TextGadget          (#PB_Any, \X,\Y,\Width,\Height, \Caption$,\Flag)
        Case "CheckBoxGadget"      : \ID = CheckBoxGadget      (#PB_Any, \X,\Y,\Width,\Height, \Caption$,\Flag)
        Case "OptionGadget"        : \ID = OptionGadget        (#PB_Any, \X,\Y,\Width,\Height, \Caption$)
        Case "ListViewGadget"      : \ID = ListViewGadget      (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "FrameGadget"         : \ID = FrameGadget         (#PB_Any, \X,\Y,\Width,\Height, \Caption$,\Flag)
        Case "ComboBoxGadget"      : \ID = ComboBoxGadget      (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "ImageGadget"         : \ID = ImageGadget         (#PB_Any, \X,\Y,\Width,\Height, \Param1,\Flag)
        Case "HyperLinkGadget"     : \ID = HyperLinkGadget     (#PB_Any, \X,\Y,\Width,\Height, \Caption$,\Param1,\Flag)
        Case "ContainerGadget"     : \ID = ContainerGadget     (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "ListIconGadget"      : \ID = ListIconGadget      (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
        Case "IPAddressGadget"     : \ID = IPAddressGadget     (#PB_Any, \X,\Y,\Width,\Height)
        Case "ProgressBarGadget"   : \ID = ProgressBarGadget   (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
        Case "ScrollBarGadget"     : \ID = ScrollBarGadget     (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Param3, \Flag)
        Case "ScrollAreaGadget"    : \ID = ScrollAreaGadget    (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Param3, \Flag) 
        Case "TrackBarGadget"      : \ID = TrackBarGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
        Case "WebGadget"           : \ID = WebGadget           (#PB_Any, \X,\Y,\Width,\Height, \Caption$)
        Case "ButtonImageGadget"   : \ID = ButtonImageGadget   (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
        Case "CalendarGadget"      : \ID = CalendarGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Flag)
        Case "DateGadget"          : \ID = DateGadget          (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Param1, \Flag)
        Case "EditorGadget"        : \ID = EditorGadget        (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "ExplorerListGadget"  : \ID = ExplorerListGadget  (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "ExplorerTreeGadget"  : \ID = ExplorerTreeGadget  (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "ExplorerComboGadget" : \ID = ExplorerComboGadget (#PB_Any, \X,\Y,\Width,\Height, \Caption$, \Flag)
        Case "SpinGadget"          : \ID = SpinGadget          (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
        Case "TreeGadget"          : \ID = TreeGadget          (#PB_Any, \X,\Y,\Width,\Height, \Flag)
        Case "PanelGadget"         : \ID = PanelGadget         (#PB_Any, \X,\Y,\Width,\Height) 
        Case "SplitterGadget"      
          Debug "Splitter FirstGadget "+\Param1
          Debug "Splitter SecondGadget "+\Param2
          If IsGadget(\Param1) And IsGadget(\Param2)
            \ID = SplitterGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag)
          EndIf
        Case "MDIGadget"          
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            \ID = MDIGadget           (#PB_Any, \X,\Y,\Width,\Height, \Param1, \Param2, \Flag) 
          CompilerEndIf
        Case "ScintillaGadget"     : \ID = ScintillaGadget     (#PB_Any, \X,\Y,\Width,\Height, \Param1)
        Case "ShortcutGadget"      : \ID = ShortcutGadget      (#PB_Any, \X,\Y,\Width,\Height, \Param1)
        Case "CanvasGadget"        : \ID = CanvasGadget        (#PB_Any, \X,\Y,\Width,\Height, \Flag)
      EndSelect
      
      ForEach ParsePBGadget()
        If ParsePBGadget()\ID$ = \ID$
          ParsePBGadget()\ID = \ID
          ParsePBGadget()\X = \X
          ParsePBGadget()\Y = \Y
          ParsePBGadget()\Width = \Width
          ParsePBGadget()\Height = \Height
          ParsePBGadget()\Caption$ = \Caption$
          ParsePBGadget()\Param1 = \Param1
          ParsePBGadget()\Param2 = \Param2
          ParsePBGadget()\Param3 = \Param3
          ParsePBGadget()\Flag = \Flag
          
          ParsePBGadget()\X$ = \X$
          ParsePBGadget()\Y$ = \Y$
          ParsePBGadget()\Width$ = \Width$
          ParsePBGadget()\Height$ = \Height$
          ParsePBGadget()\Param1$ = \Param1$
          ParsePBGadget()\Param2$ = \Param2$
          ParsePBGadget()\Param3$ = \Param3$
          ParsePBGadget()\Flag$ = \Flag$
          
          ParsePBGadget()\Position = \Position
          ParsePBGadget()\Length = \Length
        EndIf
      Next
    EndWith
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure$ FindVar(File, *File, Length, Format, StrToFind$)
    Protected result$
    Protected Line, FindWindow, Function$, FunctionName$, FunctionArgs$
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
    
    If *File 
      ;FileSeek(File, Loc(File), #PB_Absolute)
      ReadData(File, *File, Length)
      Protected String$ = PeekS(*File, Length, Format)
      
      If CreateRegularExpression(#RegEx_FindVar, "(\s*?"+StrToFind$+"\s*?=\s*?)(\d+)", Create_Reg_Flag)
        
        If ExamineRegularExpression(#RegEx_FindVar, String$)
          While NextRegularExpressionMatch(#RegEx_FindVar)
            result$ = RegularExpressionGroup(#RegEx_FindVar,2)
            ;             Debug result
            ;             Debug RegularExpressionMatchLength(#RegEx_FindVar)
            ;             Debug RegularExpressionMatchPosition(#RegEx_FindVar)
            ;             Debug RegularExpressionMatchString(#RegEx_FindVar)
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
      Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
      Protected Line, FindWindow, Function$, FunctionArgs$
      Protected Format=ReadStringFormat(#File)
      Protected Length = Lof(#File) 
      Protected *File = AllocateMemory(Length)
      
      If *File 
        ReadData(#File, *File, Length)
        *This\File$ = PeekS(*File, Length, Format)
          
        If CreateRegularExpression(#Regex_FindProcedure, "[^;]Procedure.*?EndProcedure", Create_Reg_Flag) And
           CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?)\)(?=\s*($|:))", Create_Reg_Flag) And
           CreateRegularExpression(#RegEx_FindArguments, "[^,]+", Create_Reg_Flag)
          
          If ExamineRegularExpression(#Regex_FindProcedure, *This\File$)
            While NextRegularExpressionMatch(#Regex_FindProcedure)
              Function$=RegularExpressionMatchString(#Regex_FindProcedure)
              
              If ExamineRegularExpression(#RegEx_FindFunction, Function$)
                While NextRegularExpressionMatch(#RegEx_FindFunction)
                  With *This
                    \Type$=RegularExpressionGroup(#RegEx_FindFunction, 1)
                    FunctionArgs$=RegularExpressionGroup(#RegEx_FindFunction, 2)
                    \Type = PB_Type(\Type$)
                    
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
                        
                        \Position = RegularExpressionMatchPosition(#Regex_FindProcedure)+RegularExpressionMatchPosition(#RegEx_FindFunction) -2 
                        \Length = RegularExpressionMatchLength(#RegEx_FindFunction)
                        Debug "Position - "+\Position
                        Debug "Length - "+\Length
                        Count = 0
                        Texts =  Chr(10)+ \Type$
                        
                        AddElement(ParsePBGadget()) 
                        ParsePBGadget()\Type$ = \Type$
                        ParsePBGadget()\Function$ = RegularExpressionMatchString(#RegEx_FindFunction)
                                
                        If ExamineRegularExpression(#RegEx_FindArguments, FunctionArgs$)
                          While NextRegularExpressionMatch(#RegEx_FindArguments)
                            Count + 1
                            Args$ = RegularExpressionMatchString(#RegEx_FindArguments)
                            
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
                                \ID$ = Trim(Args$)
                                ParsePBGadget()\ID$ = \ID$
                                
                              Case 2 : \X$ = Trim(Args$)
                                Select Asc(Trim(Args$))
                                  Case '0' To '9'
                                    \X = Val(Args$)
                                  Default
                                    \X = Val(FindVar(#File, *File, Length, Format, Trim(Args$)))
                                EndSelect
                              Case 3 : \Y$ = Trim(Args$)
                                Select Asc(Trim(Args$))
                                  Case '0' To '9'
                                    \Y = Val(Args$)
                                  Default
                                    \Y = Val(FindVar(#File, *File, Length, Format, Trim(Args$)))
                                EndSelect
                              Case 4 : \Width$ = Trim(Args$)
                                Select Asc(Trim(Args$))
                                  Case '0' To '9'
                                    \Width = Val(Args$)
                                  Default
                                    \Width = Val(FindVar(#File, *File, Length, Format, Trim(Args$)))
                                EndSelect
                              Case 5 : \Height$ = Trim(Args$)
                                Select Asc(Trim(Args$))
                                  Case '0' To '9'
                                    \Height = Val(Args$)
                                  Default
                                    \Height = Val(FindVar(#File, *File, Length, Format, Trim(Args$)))
                                EndSelect
                              Case 6
                                \Caption$ = Trim(Trim(Args$), Chr(34))
                                
                              Case 7 : \Param1$ = Trim(Args$)
                                Select Asc(Trim(Args$))
                                  Case '0' To '9'
                                    \Param1 = Val(Args$)
                                  Default
                                    Select \Type$
                                      Case "SplitterGadget"      
                                        PushListPosition(ParsePBGadget())
                                        ForEach ParsePBGadget()
                                          If ParsePBGadget()\ID$ = Trim(Args$)
                                            \Param1 = ParsePBGadget()\ID
                                          EndIf
                                        Next
                                        PopListPosition(ParsePBGadget())
                                    EndSelect
                                EndSelect
                                
                              Case 8 : \Param2$ = Trim(Args$)
                                Select Asc(Trim(Args$))
                                  Case '0' To '9'
                                    \Param2 = Val(Args$)
                                  Default
                                    Select \Type$
                                      Case "SplitterGadget"      
                                        PushListPosition(ParsePBGadget())
                                        ForEach ParsePBGadget()
                                          If ParsePBGadget()\ID$ = Trim(Args$)
                                            \Param2 = ParsePBGadget()\ID
                                          EndIf
                                        Next
                                        PopListPosition(ParsePBGadget())
                                    EndSelect
                                EndSelect
                                
                              Case 9 : \Param3$ = Trim(Args$)
                                \Param3 = Val(Args$)
                                
                              Case 10 : \Flag$ = Trim(Args$)
                                \Flag = PB_Flag(Args$)
                                If Not \Flag
                                  Select Asc(\Flag$)
                                    Case '0' To '9'
                                    Default
                                      \Flag = PB_Flag(FindVar(#File, *File, Length, Format, Trim(Args$)))
                                  EndSelect
                                EndIf
                            EndSelect
                            
                          Wend
                        EndIf
                        
                        CallFunctionFast(@CreatePBGadget(), *This)
                        
                        AddGadgetItem(Editor_2, -1, Texts)
                        Texts = ""
                        
                      Default
                        Text = RegularExpressionMatchString(#RegEx_FindFunction)
                        ;Debug \Function$
                        
                        If ExamineRegularExpression(#RegEx_FindArguments, FunctionArgs$)
                          Index=0
                          While NextRegularExpressionMatch(#RegEx_FindArguments)
                            Index+1
                            Protected Args1$ = RegularExpressionMatchString(#RegEx_FindArguments)
                            
                            Select Index
                              Case 1
                                \ID$ = Trim(Args1$)
                            EndSelect
                            
                            Select \Type$
                              Case "LoadFont"
                                Protected ID$,FontName$,FontHeight,FontStyle
                                
                                Select Index
                                  Case 2
                                    FontName$ = Args1$
                                  Case 3
                                    FontHeight = Val(Args1$)
                                  Case 4
                                    Select Args1$
                                      Case "#PB_Font_Bold"
                                        FontStyle = #PB_Font_Bold
                                    EndSelect
                                EndSelect
                                
                              Case "SetGadgetFont"
                                SetPBFunction(*This)
                                
                            EndSelect
                            
                          Wend
                          
                          If FontName$
                            \Font = LoadFont(#PB_Any,FontName$,FontHeight,FontStyle)
                          EndIf
                          
                        EndIf
                        
                        
                        
                    EndSelect
                    
                  EndWith
                Wend
                
              EndIf
              
            Wend
          EndIf
          
        EndIf
      EndIf
      
      CloseFile(#File)
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
        
        ;-SaveEvent
      Case Save  
        Title$="test1.pb/save"
        File$ = "test1.pb"
        Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*"
        Pattern = 0
        
        File$ = SaveFileRequester(Title$,File$,Pattern$,Pattern)
        If File$
          If OpenFile(0, File$)         ; we create a new text file...
            
            PushListPosition(ParsePBGadget())
            ;SortStructuredList(ParsePBGadget(), #PB_Sort_Descending, OffsetOf(ParsePBGadget\Position), TypeOf(ParsePBGadget\Position)) ; Сортировка
            ;WriteStringFormat(0,#PB_Unicode)
            WriteString(0, *This\File$, #PB_UTF8) ; 
            
            Protected len, add$ ;= " ; ADD" 
            
            ForEach ParsePBGadget()
              FileSeek(0, ParsePBGadget()\Position-len, #PB_Absolute)
              len = StringByteLength(add$)
              WriteStringN(0, ParsePBGadget()\Function$+add$, #PB_UTF8) ; 
              
            Next
            PopListPosition(ParsePBGadget())
            
            CloseFile(0)                       ; close the previously opened file and store the written data this way
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