;  ^^
; (oo)\__________
; (__)\          )\/\
;      ||------w||
;      ||       ||
; 43025500559246
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

;-
;- INCLUDE
XIncludeFile "include/Constant.pbi"
XIncludeFile "include/Hide.pbi"
XIncludeFile "include/Disable.pbi"
XIncludeFile "include/Flag.pbi"
XIncludeFile "include/Transformation.pbi"
XIncludeFile "include/Properties.pbi"


XIncludeFile "include/Scintilla.pbi"
Global WE_Code=-1, CodeShow.b

Procedure WE_Code_CallBack()
  Select Event()
    Case #PB_Event_DeactivateWindow
      ; HideWindow(EventWindow(), #True)
    Case #PB_Event_SizeWindow
      ResizeGadget(GetWindowData(EventWindow()), #PB_Ignore, #PB_Ignore, WindowWidth(EventWindow()), WindowHeight(EventWindow()))
  EndSelect
EndProcedure

Procedure WE_Code_Init(Parent)
  Protected UseGadgetList = UseGadgetList(0)
  WE_Code = OpenWindow(#PB_Any, WindowX(Parent)-800, (WindowY(Parent)+WindowHeight(Parent))-300, 800, 300, "(WE) - code", #PB_Window_TitleBar|#PB_Window_SizeGadget|#PB_Window_Invisible, WindowID(Parent))
  StickyWindow(WE_Code, #True)
  SetWindowData(WE_Code, Scintilla::Gadget(#PB_Any, 0, 0, 420, 600))
  BindEvent(#PB_Event_SizeWindow, @WE_Code_CallBack(), WE_Code)
  BindEvent(#PB_Event_DeactivateWindow, @WE_Code_CallBack(), WE_Code)
  UseGadgetList(UseGadgetList)
EndProcedure

Procedure WE_Code_Show(Text$)
  If CodeShow
    HideWindow(WE_Code, #False)
  EndIf
  Scintilla::SetText(GetWindowData(WE_Code), Text$)
EndProcedure


;-
;- GLOBAL
Global MainWindow=-1
Global WE=-1, 
       WE_Menu_0=-1, 
       WE_PopupMenu_0=-1,
       WE_Tree_0=-1, 
       WE_Tree_1=-1, 
       WE_Panel_0=-1,
       WE_Splitter_0=-1

Global WE_Properties
Global Properties_ID 
Global Properties_Image 
Global Properties_Color 
Global Properties_Puch
Global Properties_Flag

Global WE_Menu_New=1,
       WE_Menu_Open=2,
       WE_Menu_Save=3,
       WE_Menu_Save_as=4,
       WE_Menu_Delete=5,
       WE_Menu_Quit=6,
       WE_Menu_Code=7

;-
;- DECLARE
Declare WE_Events()
Declare WE_CloseWindow()
Declare WE_ResizeWindow()
Declare WE_ResizePanel_0()
Declare WE_Tree_0_Position(Gadget, Parent)
Declare WE_Tree_0_Update(Gadget, Position=-1)
Declare WE_OpenWindow(Flag.i=#PB_Window_SystemMenu, ParentID=0)

Declare$ GetObjectClass(Object)
Declare CF_Free(Object.i)

;-
;- MACRO
Macro ULCase(String)
  InsertString(UCase(Left(String,1)), LCase(Right(String,Len(String)-1)), 2)
EndMacro

Macro GetVarValue(StrToFind)
  ;GetArguments(*This\Content\Text$, "(?:(\w+)\s*\(.*)?"+StrToFind+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2)
  GetArguments(*This\Content\Text$, ~"(?:(\\w+)\\s*\\(.*)?"+StrToFind+~"(?:\\$)?(?:\\.\\w)?\\s*=\\s*(?:\")?([\\#\\w\\|\\s\\(\\)]+$|[\\#\\w\\|\\s\\(\\)]+)(?:\")?", 2)
EndMacro

Macro MacroCoordinate(MacroValue, MacroArg) ; 
  Select Asc(MacroArg)
    Case '0' To '9'
      MacroValue = Val(MacroArg) ; Если строка такого рода "10"
    Default
      MacroValue = GetVal(MacroArg) ; Если строка такого рода "GadgetX(#Gadget)"
      If MacroValue = 0
        MacroValue = Val(GetVarValue(MacroArg)) ; Если строка такого рода "x"
      EndIf
  EndSelect
EndMacro

Macro change_current_object_from_class(_class_)
  ChangeCurrentElement(ParsePBGadget(), *This\get(_class_)\Adress)
EndMacro

Macro change_current_object_from_id(_object_)
  change_current_object_from_class(Str(_object_))
EndMacro

Macro replace_map_key(_find_mapkey, _replace_mapkey)
  CopyStructure(*This\get(_find_mapkey), *This\get(_replace_mapkey), ObjectStruct)
  ChangeCurrentElement(ParsePBGadget(), *This\get(_replace_mapkey)\Adress)
  DeleteMapElement(*This\get(), _find_mapkey)
EndMacro

Macro get_argument_string(_string_)
  GetArguments(_string_, #RegEx_Pattern_Function, 2)
EndMacro

Macro is_object(_object_)
  Bool(IsGadget(_object_) | IsWindow(_object_))
EndMacro

Macro get_object_type(_object_)
  *This\get(Str(_object_))\Type\Argument$
EndMacro

Macro get_object_class(_object_)
  *This\get(Str(_object_))\Object\Argument$
EndMacro

Macro get_object_count(_object_)
  *This\get(Str(*This\get(Str(_object_))\Parent\Argument)+"_"+*This\get(Str(_object_))\Type\Argument$)\Count
EndMacro

Macro get_object_adress(_object_)
  *This\get(Str(_object_))\Adress
EndMacro

Macro get_object_parent(_object_)
  *This\get(Str(_object_))\Parent\Argument
EndMacro

Macro get_object_window(_object_)
  *This\get(Str(_object_))\Window\Argument
EndMacro

Macro get_class_id(_class_)
  *This\get(_class_)\Object\Argument
EndMacro


; Macro is_container(Object)
;   *This\get(Str(Object))\container)
; EndMacro

;-
;- STRUCTURE
Structure ArgumentStruct
  Argument.i 
  Argument$
EndStructure

Structure ObjectStruct
  Count.i
  Index.i
  Adress.i
  Position.i
  
  Type.ArgumentStruct 
  Object.ArgumentStruct 
  Parent.ArgumentStruct
  Window.ArgumentStruct
EndStructure

Structure FONT
  Object.ArgumentStruct
  Name$
  Height.i
  Style.i
EndStructure

Structure IMG
  Object.ArgumentStruct
  Name$
EndStructure

Structure ContentStruct
  File$
  Text$    ; Содержимое файла 
  String$  ; Строка к примеру: "OpenWindow(#Window_0, x, y, width, height, "Window_0", #PB_Window_SystemMenu)"
  Position.i  ; Положение Content-a в исходном файле
  Length.i    ; длинна Content-a в исходном файле
EndStructure

Structure ParseStruct Extends ObjectStruct
  Item.i
  SubLevel.i ; 
  Content.ContentStruct  
  
  X.ArgumentStruct 
  Y.ArgumentStruct
  Width.ArgumentStruct
  Height.ArgumentStruct
  Caption.ArgumentStruct
  Param1.ArgumentStruct
  Param2.ArgumentStruct
  Param3.ArgumentStruct
  Flag.ArgumentStruct
  
  Map Font.FONT()
  Map Img.IMG()
  
  Args$
EndStructure

Structure ThisStruct Extends ParseStruct
  Map get.ObjectStruct()
EndStructure

Global NewList ParsePBGadget.ParseStruct() 
Global *This.ThisStruct = AllocateStructure(ThisStruct)
;
*This\Index=-1
; *This\Item=-1

;-
;- ENUMERATION
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

;-
Enumeration RegularExpression
  #RegEx_Function
  #RegEx_Arguments
  #RegEx_Arguments1
  #RegEx_Captions
  #RegEx_Captions1
  #Regex_Procedure
  #RegEx_Var
EndEnumeration

;-
;- OTHERS
Runtime Procedure$ GetObjectClass(Object)
  ProcedureReturn *This\get(Str(Object))\Object\Argument$
EndProcedure


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
            ID = (*This\get(RegularExpressionGroup(#RegEx_Captions1, 3))\Object\Argument)
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
              ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((*This\get(RegularExpressionGroup(#RegEx_Captions1, 3)))))
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
            ID = (*This\get(RegularExpressionGroup(#RegEx_Captions, 3))\Object\Argument)
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
              ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((*This\get(RegularExpressionGroup(#RegEx_Captions1, 3)))))
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

Procedure$ GetArguments(String$, Pattern$, Group)
  Protected Result$
  Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
  Protected RegExID = CreateRegularExpression(#PB_Any, Pattern$, Create_Reg_Flag)
  
  If RegExID
    
    If ExamineRegularExpression(RegExID, String$)
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
  
  ;Debug " >> "+Result$ +" - "+Pattern$
  ProcedureReturn Trim(Trim(Trim(Result$), #CR$))
EndProcedure

Procedure$ ContentContent(FileName$)
  Protected *File, Format, Length
  Protected File = ReadFile(#PB_Any, FileName$)
  
  If File
    Length = Lof(File) 
    *File = AllocateMemory(Length)
    Format = ReadStringFormat(File)
    
    If *File 
      ReadData(File, *File, Length)
      ProcedureReturn PeekS(*File, Length, Format)
    EndIf
  Else
    MessageRequester("Предупреждение!!!", "Не получилось прочитать "+FileName$)
  EndIf
EndProcedure

;-
;- CREATE_FUNCTION
Procedure CF_Add(*This.ParseStruct, Index)
  Protected Result
  
  With *This
    Select \Type\Argument$
      Case "HideWindow", "HideGadget", 
           "DisableWindow", "DisableGadget"
        Select Index
          Case 1 : \Object\Argument$ = \Args$
          Case 2 : \Param1\Argument$ = \Args$
        EndSelect
        
        Select \Param1\Argument$
          Case "#True" : \Object\Argument = #True
          Case "#False" : \Param1\Argument = #False
          Default
            \Param1\Argument = Val(\Param1\Argument$)
        EndSelect
        
      Case "LoadFont"
        Select Index
          Case 1 : \Object\Argument$ = \Args$
          Case 2 : \Param1\Argument$ = \Args$
          Case 3 : \Param2\Argument$ = \Args$
          Case 4 : \Param3\Argument$ = \Args$
        EndSelect
        
      Case "LoadImage", 
           "SetGadgetFont", 
           "SetGadgetState",
           "SetGadgetText"
        Select Index
          Case 1 : \Object\Argument$ = \Args$
          Case 2 : \Param1\Argument$=GetStr(\Args$)
        EndSelect
        
      Case "ResizeGadget"
        Select Index
          Case 1 : \Object\Argument$ = \Args$
          Case 2 
            If "#PB_Ignore"=\Args$ 
              \X\Argument = #PB_Ignore
            Else
              \X\Argument = Val(\Args$)
            EndIf
            
          Case 3 
            If "#PB_Ignore"=\Args$ 
              \Y\Argument = #PB_Ignore
            Else
              \Y\Argument = Val(\Args$)
            EndIf
            
          Case 4 
            If "#PB_Ignore"=\Args$ 
              \Width\Argument = #PB_Ignore
            Else
              \Width\Argument = Val(\Args$)
            EndIf
            
          Case 5 
            If "#PB_Ignore"=\Args$ 
              \Height\Argument = #PB_Ignore
            Else
              \Height\Argument = Val(\Args$)
            EndIf
            
        EndSelect
        
      Case "SetGadgetColor"
        Select Index
          Case 1 : \Object\Argument$ = \Args$
          Case 2 
            Select \Args$
              Case "#PB_Gadget_FrontColor"      : \Param1\Argument = #PB_Gadget_FrontColor      ; Цвет текста гаджета
              Case "#PB_Gadget_BackColor"       : \Param1\Argument = #PB_Gadget_BackColor       ; Фон гаджета
              Case "#PB_Gadget_LineColor"       : \Param1\Argument = #PB_Gadget_LineColor       ; Цвет линий сетки
              Case "#PB_Gadget_TitleFrontColor" : \Param1\Argument = #PB_Gadget_TitleFrontColor ; Цвет текста в заголовке    (для гаджета CalendarGadget())
              Case "#PB_Gadget_TitleBackColor"  : \Param1\Argument = #PB_Gadget_TitleBackColor  ; Цвет фона в заголовке 	 (для гаджета CalendarGadget())
              Case "#PB_Gadget_GrayTextColor"   : \Param1\Argument = #PB_Gadget_GrayTextColor   ; Цвет для серого текста     (для гаджета CalendarGadget())
            EndSelect
            
          Case 3
            \Param2\Argument = Val(\Args$)
            Result = GetVal(\Args$)
            If Result
              \Param2\Argument = Result
            EndIf
        EndSelect
        
        
    EndSelect
    
  EndWith
  
EndProcedure

Procedure CF_Set(*ThisParse.ParseStruct)
  Protected Result, I, ID
  
  With *ThisParse ; 
    ID = *This\get(\Object\Argument$)\Object\Argument
    
    Select \Type\Argument$
      Case "GetActiveWindow"         : Result = GetActiveWindow()
      Case "GetActiveGadget"         : Result = GetActiveGadget()
        
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
        AddMapElement(\Font(), \Object\Argument$) 
        
        \Font()\Name$=\Param1\Argument$
        \Font()\Height=Val(\Param2\Argument$)
        
        For I = 0 To CountString(\Param3\Argument$,"|")
          Select Trim(StringField(\Param3\Argument$,(I+1),"|"))
            Case "#PB_Font_Bold"        : \Font()\Style|#PB_Font_Bold
            Case "#PB_Font_HighQuality" : \Font()\Style|#PB_Font_HighQuality
            Case "#PB_Font_Italic"      : \Font()\Style|#PB_Font_Italic
            Case "#PB_Font_StrikeOut"   : \Font()\Style|#PB_Font_StrikeOut
            Case "#PB_Font_Underline"   : \Font()\Style|#PB_Font_Underline
          EndSelect
        Next
        
        \Font()\Object\Argument=LoadFont(#PB_Any,\Font()\Name$,\Font()\Height,\Font()\Style)
        
      Case "LoadImage"
        AddMapElement(\Img(), \Object\Argument$) 
        \Img()\Name$=\Param1\Argument$
        \Img()\Object\Argument=LoadImage(#PB_Any, \Img()\Name$)
        
    EndSelect
    
    If IsWindow(ID)
      Select \Type\Argument$
        Case "SetActiveWindow"         : SetActiveWindow(ID)
        Case "HideWindow"              : HideWindow(ID, \Param1\Argument)
        Case "DisableWindow"           : DisableWindow(ID, \Param1\Argument)
      EndSelect
    EndIf
    
    If IsGadget(ID)
      Select \Type\Argument$
        Case "SetActiveGadget"         : SetActiveGadget(ID)
        Case "HideGadget"              : HideGadget(ID, \Param1\Argument)
        Case "DisableGadget"           : DisableGadget(ID, \Param1\Argument)
        Case "SetGadgetText"           : SetGadgetText(ID, \Param1\Argument$)
        Case "SetGadgetColor"          : SetGadgetColor(ID, \Param1\Argument, \Param2\Argument)
          
        Case "SetGadgetFont"
          Protected Font = \Font(\Param1\Argument$)\Object\Argument
          If IsFont(Font)
            SetGadgetFont(ID, FontID(Font))
          EndIf
          
        Case "SetGadgetState"
          Protected Img = \Img(\Param1\Argument$)\Object\Argument
          If IsImage(Img)
            SetGadgetState(ID, ImageID(Img))
          EndIf
          
        Case "ResizeGadget"
          ResizeGadget(ID, \X\Argument, \Y\Argument, \Width\Argument, \Height\Argument)
          Transformation::Update(ID)
          
      EndSelect
    EndIf
  EndWith
  
EndProcedure

Procedure CF_Free(Object.i)
  
  If ListSize(ParsePBGadget())
    With ParsePBGadget()
      If IsGadget(Object)
        Select GadgetType(Object)
          Case #PB_GadgetType_Panel, 
               #PB_GadgetType_Container, 
               #PB_GadgetType_ScrollArea
            
            ForEach ParsePBGadget()
              If \Parent\Argument = Object 
                Select GadgetType(\Object\Argument)
                  Case #PB_GadgetType_Panel, 
                       #PB_GadgetType_Container, 
                       #PB_GadgetType_ScrollArea
                    
                    CF_Free(\Object\Argument)
                    
                  Default
                    ReplaceString(*This\Content\Text$, \Content\String$, Space(Len(\Content\String$)), #PB_String_InPlace, \Content\Position, 1)
                    
                    *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count-1 
                    If *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count =< 0
                      DeleteMapElement(*This\get(), Str(\Parent\Argument)+"_"+\Type\Argument$)
                    EndIf
                    DeleteMapElement(*This\get(), \Object\Argument$)
                    DeleteMapElement(*This\get(), Str(\Object\Argument))
                    DeleteElement(ParsePBGadget())
                    
                EndSelect
              EndIf
            Next
        EndSelect
      EndIf
      
      If ChangeCurrentElement(ParsePBGadget(), *This\get(Str(Object))\Adress)
        ;         Debug 666666666666
        ;         Debug "Text$ "+\Content\String$
        ReplaceString(*This\Content\Text$, \Content\String$, Space(Len(\Content\String$)), #PB_String_InPlace, \Content\Position, 1)
        ;          \Content\String$ = ""
        ;         \Content\Position = 0
        ;         \Content\Length = 0
        ; Debug *This\Content\Text$
        
        *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count-1 
        If *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count =< 0
          DeleteMapElement(*This\get(), Str(\Parent\Argument)+"_"+\Type\Argument$)
        EndIf
        DeleteMapElement(*This\get(), \Object\Argument$)
        DeleteMapElement(*This\get(), Str(Object))
        DeleteElement(ParsePBGadget())
        
      EndIf
    EndWith  
  EndIf
  
EndProcedure

;-
;- CREATE_OBJECT
Declare CO_Create(Type$, X, Y, Parent=-1)
Declare CO_Open()

Macro CO_Flag(Flag) ; Ok
  Properties::GetPBFlag(Flag)
EndMacro

Procedure CO_Free(Object)
  Protected i
  ;ProcedureReturn 
  
  For i=0 To CountGadgetItems(WE_Tree_0)-1
    If Object=GetGadgetItemData(WE_Tree_0, i) 
      RemoveGadgetItem(WE_Tree_0, i)
      Break
    EndIf
  Next 
  
  With ParsePBGadget()
    ;     ChangeCurrentElement(ParsePBGadget(), *This\get(Str(Object))\Adress)
    ;     *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count-1 
    ;     If *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count =< 0
    ;       DeleteMapElement(*This\get(), Str(\Parent\Argument)+"_"+\Type\Argument$)
    ;     EndIf
    ;     DeleteMapElement(*This\get(), \Object\Argument$)
    ;     DeleteMapElement(*This\get(), Str(Object))
    ;     DeleteElement(ParsePBGadget())
    CF_Free(Object)
    
    Transformation::Free(Object)
    
    If IsGadget(Object)
      FreeGadget(Object)
    ElseIf IsWindow(Object)
      CloseWindow(Object)
    EndIf
  EndWith
EndProcedure

Procedure CO_Events()
  Protected I.i, Parent=-1, Object =- 1
  
  If IsGadget(EventGadget())
    Object = EventGadget()
  ElseIf IsWindow(EventWindow())
    Object = EventWindow()
  EndIf
  
  Select Event()
    Case #PB_Event_Create
      With ParsePBGadget()
        ;         PushListPosition(ParsePBGadget())
        ;         ForEach ParsePBGadget()
        ;           If Object = \Object\Argument
        change_current_object_from_id(Object)
        Transformation::Create(\Object\Argument, \Parent\Argument, \Window\Argument, \Item, 5)
        If IsGadget(\Object\Argument) And GadgetType(\Object\Argument) = #PB_GadgetType_Splitter
          Transformation::Free(GetGadgetAttribute(\Object\Argument, #PB_Splitter_FirstGadget))
          Transformation::Free(GetGadgetAttribute(\Object\Argument, #PB_Splitter_SecondGadget))
        EndIf
        Properties::Init(\Object\Argument, \Object\Argument$, \Flag\Argument$)
        ;             Break
        ;           EndIf
        ;         Next
        ;         PopListPosition(ParsePBGadget())
      EndWith
      
      ; 
      ;       If IsWindow(Object)
      ;         If Transformation::PopupMenu
      ;           MenuItem(WE_Menu_Delete, "Delete"          +Chr(9)+"Ctrl+D")
      ;           MenuItem(WE_Menu_Block, "Block changes"   +Chr(9)+"Ctrl+B")
      ;         EndIf
      ;       EndIf
      
    Case #PB_Event_Gadget
      
      Select EventType()
        Case #PB_EventType_CloseItem ; Delete
          CO_Free(Object)
          
        Case #PB_EventType_StatusChange
          
          ; При выборе гаджета обнавляем испектор
          For I=0 To CountGadgetItems(WE_Tree_0)-1
            If Object = GetGadgetItemData(WE_Tree_0, I) : SetGadgetState(WE_Tree_0, I)
              PostEvent(#PB_Event_Gadget, WE, WE_Tree_0, #PB_EventType_Change)
              Break
            EndIf
          Next  
          
      EndSelect
      
    Case #PB_Event_WindowDrop, #PB_Event_GadgetDrop
      
      CO_Create(ReplaceString(EventDropText(), "gadget", ""),
                WindowMouseX(EventWindow()), WindowMouseY(EventWindow()), Object)
      
  EndSelect
EndProcedure

Procedure CO_Insert_(*ThisParse.ParseStruct, Parent)
  Protected ID$, Handle$
  CodeShow = 1
  
  With *ThisParse
    Protected Variable$, VariableLength
    
    ; 
    Static VariablePosition, Container
    
    Static pos,plus
    
    
    If VariablePosition = 0
      VariablePosition = 18  ; Позиция откуда начинаем вставлять перемение
    EndIf
    
    If \Type\Argument$ = "OpenWindow"
      Variable$ = "Global "+\Object\Argument$+"=-1"
    Else
      Variable$ = ", "+#CRLF$+Space(Len("Global "))+\Object\Argument$+"=-1"
    EndIf
    
    ;     VariableLength = Len(Variable$)
    ;     *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, VariablePosition) 
    ;     VariablePosition + VariableLength
    
    
    
    ;
    If \Type\Argument$ = "OpenWindow"
      \Content\Position = (*This\Content\Position+*This\Content\Length)+VariableLength + Len(Space(5))
    Else
      \Content\Position = (*This\Content\Position+*This\Content\Length)+VariableLength + Len(#CRLF$+Space(4))
    EndIf
    
    
    If *This\Parent\Argument = Parent
      Debug 18888888888
      If *This\get(*This\get(Str(Parent))\Object\Argument$)\Position
        *This\get(*This\get(Str(Parent))\Parent\Argument$)\Position + (*This\Content\Length + Len(#CRLF$+Space(4)))
        \Content\Position = *This\get(*This\get(Str(Parent))\Object\Argument$)\Position
      EndIf
    Else
      If IsGadget(*This\Parent\Argument)
        If Container=1 : Container=0
          Debug 999
          \Content\Position+Len("CloseGadgetList()"+#CRLF$+Space(4))
        Else
          Debug 333
          \Content\Position=*This\get(*This\get(Str(Parent))\Object\Argument$)\Position + Len(#CRLF$+Space(4))
          *This\Content\Text$ = InsertString(*This\Content\Text$, Space(4), \Content\Position) 
          \Content\Position+Len(Space(4))
        EndIf
      ElseIf IsWindow(*This\Parent\Argument)
        Debug 666
        *This\get(*This\get(Str(Parent))\Parent\Argument$)\Position + (*This\Content\Length + Len(#CRLF$+Space(4)))
        \Content\Position = *This\get(*This\get(Str(Parent))\Object\Argument$)\Position
      EndIf
    EndIf
    
    
    If Asc(\Object\Argument$) = 35 ; '#'
      ID$ = \Object\Argument$
    Else
      Handle$ = \Object\Argument$+" = "
      ID$ = "#PB_Any"
    EndIf
    
    Select \Type\Argument$
        Case "OpenWindow"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ButtonGadget"        : \Content\String$ = Handle$+"ButtonGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "StringGadget"        : \Content\String$ = Handle$+"StringGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "TextGadget"          : \Content\String$ = Handle$+"TextGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "CheckBoxGadget"      : \Content\String$ = Handle$+"CheckBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "OptionGadget"        : \Content\String$ = Handle$+"OptionGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ListViewGadget"      : \Content\String$ = Handle$+"ListViewGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "FrameGadget"         : \Content\String$ = Handle$+"FrameGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ComboBoxGadget"      : \Content\String$ = Handle$+"ComboBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ImageGadget"         : \Content\String$ = Handle$+"ImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                 : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "HyperLinkGadget"     : \Content\String$ = Handle$+"HyperLinkGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                  : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ContainerGadget"     : \Content\String$ = Handle$+"ContainerGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ListIconGadget"      : \Content\String$ = Handle$+"ListIconGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                  : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "IPAddressGadget"     : \Content\String$ = Handle$+"IPAddressGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$
        Case "ProgressBarGadget"   : \Content\String$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollBarGadget"     : \Content\String$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$+", "+\Param3\Argument$                                     : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollAreaGadget"    : \Content\String$ = Handle$+"ScrollAreaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                        : If \Param3\Argument$ : \Content\String$ +", "+\Param3\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf 
        Case "TrackBarGadget"      : \Content\String$ = Handle$+"TrackBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                          : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "WebGadget"           : \Content\String$ = Handle$+"WebGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ButtonImageGadget"   : \Content\String$ = Handle$+"ButtonImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                              : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "CalendarGadget"      : \Content\String$ = Handle$+"CalendarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                         : If \Param1\Argument$ : \Content\String$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "DateGadget"          : \Content\String$ = Handle$+"DateGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                    : If \Param1\Argument$ : \Content\String$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "EditorGadget"        : \Content\String$ = Handle$+"EditorGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                           : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerListGadget"  : \Content\String$ = Handle$+"ExplorerListGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                            : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerTreeGadget"  : \Content\String$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                            : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerComboGadget" : \Content\String$ = Handle$+"ExplorerComboGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                           : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "SpinGadget"          : \Content\String$ = Handle$+"SpinGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                              : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "TreeGadget"          : \Content\String$ = Handle$+"TreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                             : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "PanelGadget"         : \Content\String$ = Handle$+"PanelGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$ 
        Case "SplitterGadget"      : \Content\String$ = Handle$+"SplitterGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "MDIGadget"           : \Content\String$ = Handle$+"MDIGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf 
      Case "ScintillaGadget"     : \Content\String$ = Handle$+"ScintillaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
      Case "ShortcutGadget"      : \Content\String$ = Handle$+"ShortcutGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
        Case "CanvasGadget"        : \Content\String$ = Handle$+"CanvasGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
    EndSelect
    
    \Content\String$+")" 
    
    \Content\Length = Len(\Content\String$)
    
    *This\Content\Length = \Content\Length
    *This\Content\Position = \Content\Position
    *This\Content\Text$ = InsertString(*This\Content\Text$, \Content\String$+#CRLF$+Space(4), \Content\Position) 
    
    ; 
    Select *This\Type\Argument$
      Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget"
        Container=1
        *This\Content\Text$ = InsertString(*This\Content\Text$, "CloseGadgetList()"+#CRLF$+Space(4),
                                           *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(4))) 
    EndSelect
    
    *This\get(\Object\Argument$)\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(4))
    *This\get(*This\get(Str(Parent))\Object\Argument$)\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(4))
    ;    Debug *This\get(Str(Parent))\Object\Argument$ +" "+ *This\get(*This\get(Str(Parent))\Object\Argument$)\Position
    ;    Debug *This\get(Str(Parent))\Object\Argument$ +" "+ *This\get(*This\get(Str(Parent))\Object\Argument$)\Position
    
    ;Debug "parent "+*This\Parent\Argument +" "+ Str(*This\get(Str(*This\Parent\Argument))\Position)
    ;        Debug "g "+*This\get("Window_0_Container_0")\Position
    
    
  EndWith
EndProcedure

Procedure CO_Insert(*ThisParse.ParseStruct, Parent)
  Protected ID$, Handle$
  CodeShow = 1
  
  With *ThisParse
    
    ; 
    Static VariablePosition
    Protected Variable$, VariableLength
;     
;     ; Позиция откуда начинаем вставлять перемение
;     If VariablePosition = 0 : VariablePosition = 18 : EndIf
;     
;     If \Type\Argument$ = "OpenWindow"
;       Variable$ = "Global "+\Object\Argument$+"=-1"
;     Else
;       Variable$ = ", "+#CRLF$+Space(Len("Global "))+\Object\Argument$+"=-1"
;     EndIf
;     
;     VariableLength = Len(Variable$)
;     *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, VariablePosition) 
;     VariablePosition + VariableLength
    
    
    ; TODO Надо посмотрет когда будем добавлять второе окно как себя поведет
    If Not *This\get(*This\get(Str(Parent))\Object\Argument$)\Position
      ;       If \Type\Argument$ = "OpenWindow"
      \Content\Position = (*This\Content\Position+*This\Content\Length)+VariableLength
    Else
      \Content\Position = *This\get(*This\get(Str(Parent))\Object\Argument$)\Position+VariableLength
;       *This\get(*This\get(Str(Parent))\Object\Argument$)\Position+VariableLength
    EndIf

    
 
    If Asc(\Object\Argument$) = 35 ; '#'
      ID$ = \Object\Argument$
    Else
      Handle$ = \Object\Argument$+" = "
      ID$ = "#PB_Any"
    EndIf
    
    Select \Type\Argument$
        Case "OpenWindow"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ButtonGadget"        : \Content\String$ = Handle$+"ButtonGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "StringGadget"        : \Content\String$ = Handle$+"StringGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "TextGadget"          : \Content\String$ = Handle$+"TextGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "CheckBoxGadget"      : \Content\String$ = Handle$+"CheckBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "OptionGadget"        : \Content\String$ = Handle$+"OptionGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ListViewGadget"      : \Content\String$ = Handle$+"ListViewGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "FrameGadget"         : \Content\String$ = Handle$+"FrameGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ComboBoxGadget"      : \Content\String$ = Handle$+"ComboBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ImageGadget"         : \Content\String$ = Handle$+"ImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                 : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "HyperLinkGadget"     : \Content\String$ = Handle$+"HyperLinkGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                  : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ContainerGadget"     : \Content\String$ = Handle$+"ContainerGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ListIconGadget"      : \Content\String$ = Handle$+"ListIconGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                  : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "IPAddressGadget"     : \Content\String$ = Handle$+"IPAddressGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$
        Case "ProgressBarGadget"   : \Content\String$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollBarGadget"     : \Content\String$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$+", "+\Param3\Argument$                                     : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollAreaGadget"    : \Content\String$ = Handle$+"ScrollAreaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                        : If \Param3\Argument$ : \Content\String$ +", "+\Param3\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf 
        Case "TrackBarGadget"      : \Content\String$ = Handle$+"TrackBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                          : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "WebGadget"           : \Content\String$ = Handle$+"WebGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ButtonImageGadget"   : \Content\String$ = Handle$+"ButtonImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                              : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "CalendarGadget"      : \Content\String$ = Handle$+"CalendarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                         : If \Param1\Argument$ : \Content\String$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "DateGadget"          : \Content\String$ = Handle$+"DateGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                    : If \Param1\Argument$ : \Content\String$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "EditorGadget"        : \Content\String$ = Handle$+"EditorGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                           : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerListGadget"  : \Content\String$ = Handle$+"ExplorerListGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                            : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerTreeGadget"  : \Content\String$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                            : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerComboGadget" : \Content\String$ = Handle$+"ExplorerComboGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                           : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "SpinGadget"          : \Content\String$ = Handle$+"SpinGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                              : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "TreeGadget"          : \Content\String$ = Handle$+"TreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                             : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      Case "PanelGadget"         : \Content\String$ = Handle$+"PanelGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$ 
        Case "SplitterGadget"      : \Content\String$ = Handle$+"SplitterGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "MDIGadget"           : \Content\String$ = Handle$+"MDIGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf 
      Case "ScintillaGadget"     : \Content\String$ = Handle$+"ScintillaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
      Case "ShortcutGadget"      : \Content\String$ = Handle$+"ShortcutGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
        Case "CanvasGadget"        : \Content\String$ = Handle$+"CanvasGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
    EndSelect
    
    \Content\String$+")" 
    
    \Content\Length = Len(\Content\String$)
    
    *This\Content\Length = \Content\Length
    *This\Content\Position = \Content\Position
    *This\Content\Text$ = InsertString(*This\Content\Text$, \Content\String$+#CRLF$+Space(4), \Content\Position) 
      
    ; 
    Select *This\Type\Argument$
      Case "OpenWindow", "PanelGadget", "ContainerGadget", "ScrollAreaGadget"
        ; Сохряняем у родителя последную позицию.
        *This\get(\Object\Argument$)\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(4))
        
        Select *This\Type\Argument$
          Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget"
            *This\Content\Text$ = InsertString(*This\Content\Text$, "CloseGadgetList()"+#CRLF$+Space(4), *This\get(\Object\Argument$)\Position) 
            *This\Content\Position+Len("CloseGadgetList()"+#CRLF$+Space(4))
        EndSelect
        
      Default
        ; У окна меняем последную позицию.
        *This\get(*This\get(Str(Parent))\Window\Argument$)\Position + (*This\Content\Length + Len(#CRLF$+Space(4)))
        
        If IsGadget(Parent)
          PushListPosition(ParsePBGadget())
          ForEach ParsePBGadget()
            Select ParsePBGadget()\Type\Argument
              Case #PB_GadgetType_Panel, #PB_GadgetType_Container, #PB_GadgetType_ScrollArea
                ; Проверяем стоит ли следующий родител в генерируемом коде ниже
                If *This\get(ParsePBGadget()\Object\Argument$)\Index > *This\get(*This\get(Str(Parent))\Object\Argument$)\Index
                  ; У родителя меняем последную позицию.
                  *This\get(ParsePBGadget()\Object\Argument$)\Position + (*This\Content\Length + Len(#CRLF$+Space(4)))
                EndIf
            EndSelect
          Next
          PopListPosition(ParsePBGadget())
        EndIf
    EndSelect
    
    ; Записываем у родителя позицию конца добавления объекта
    *This\get(*This\get(Str(Parent))\Object\Argument$)\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(4))
  EndWith
EndProcedure

Procedure CO_Create(Type$, X, Y, Parent=-1)
  Protected GadgetList
  Protected Object, Position
  Protected Buffer.s, BuffType$, i.i, j.i
  
  With *This
    ; Определяем позицию и родителя для создания объекта
    If IsGadget(Parent) 
      X - GadgetX(Parent, #PB_Gadget_WindowCoordinate)
      Y - GadgetY(Parent, #PB_Gadget_WindowCoordinate)
      GadgetList = OpenGadgetList(Parent, GetGadgetState(Parent)) 
    ElseIf IsWindow(Parent)
      GadgetList = UseGadgetList(WindowID(Parent))
    Else ; Создали новое окно
      X=0
      Y=0
      \Parent\Argument =- 1
    EndIf
    
    Select Type$
      Case "Window" : \Type\Argument$ = "OpenWindow"
      Case "Menu", "ToolBar" : \Type\Argument$ = Type$
      Default 
        \Type\Argument$=ULCase(Type$) + "Gadget"
        
        \Type\Argument$ = ReplaceString(\Type\Argument$, "box","Box")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "link","Link")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "bar","Bar")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "area","Area")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "Ipa","IPA")
        
        \Type\Argument$ = ReplaceString(\Type\Argument$, "view","View")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "icon","Icon")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "image","Image")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "combo","Combo")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "list","List")
        \Type\Argument$ = ReplaceString(\Type\Argument$, "tree","Tree")
    EndSelect
    
    Protected *ThisParse.ParseStruct = AddElement(ParsePBGadget())
    If  *ThisParse
      If *This\Content\Text$=""
        Restore Content
        Read.s Buffer
        *This\Content\Text$ = Buffer
        *This\Content\Position = 178 ; Позиция откуда начинаем вставлять объекты
        *This\Content\Length = 0  
      EndIf
      
      Restore Model 
      
      For i=1 To 1+33 ; gadget count
        For j=1 To 7  ; argument count
          Read.s Buffer
          
          Select j
            Case 1  
              If \Type\Argument$=Buffer
                BuffType$ = Buffer
              EndIf
          EndSelect
          
          If BuffType$ = \Type\Argument$
            Select j
              Case 1 
                ParsePBGadget()\Type\Argument$=Buffer
                If Buffer = "OpenWindow"
                  \Caption\Argument$=ReplaceString(Buffer, "Open","")+"_"
                Else
                  \Caption\Argument$=ReplaceString(Buffer, "Gadget","_")
                EndIf
                
              Case 2 : ParsePBGadget()\Width\Argument$=Buffer
              Case 3 : ParsePBGadget()\Height\Argument$=Buffer
              Case 4 : ParsePBGadget()\Param1\Argument$=Buffer
              Case 5 : ParsePBGadget()\Param2\Argument$=Buffer
              Case 6 : ParsePBGadget()\Param3\Argument$=Buffer
              Case 7 : ParsePBGadget()\Flag\Argument$=Buffer
            EndSelect
          EndIf
        Next  
        BuffType$ = ""
      Next  
      
      \Flag\Argument=CO_Flag(ParsePBGadget()\Flag\Argument$)
      \Caption\Argument$+*This\get(Str(Parent)+"_"+\Type\Argument$)\Count
      
      ; Формируем имя объекта
      If *This\get(Str(Parent))\Object\Argument$
        \Object\Argument$ = *This\get(Str(Parent))\Object\Argument$+"_"+\Caption\Argument$
      Else
        \Object\Argument$ = \Caption\Argument$
        ParsePBGadget()\Flag\Argument$="Flag"
      EndIf
      
      \X\Argument = X
      \Y\Argument = Y
      \Width\Argument = Val(ParsePBGadget()\Width\Argument$)
      \Height\Argument = Val(ParsePBGadget()\Height\Argument$)
      
      ParsePBGadget()\X\Argument$ = Str(\X\Argument)
      ParsePBGadget()\Y\Argument$ = Str(\Y\Argument)
      ParsePBGadget()\Type\Argument$ = \Type\Argument$
      ParsePBGadget()\Object\Argument$ = \Object\Argument$
      ParsePBGadget()\Caption\Argument$ = \Caption\Argument$
      
      ;ClearDebugOutput()
      CO_Insert(*ThisParse, Parent) 
      \Parent\Argument = Parent
    EndIf
    
    
    Position = WE_Tree_0_Position(WE_Tree_0, Parent)
    
    Object=CallFunctionFast(@CO_Open())
    
    If IsGadget(Object)
      ;       Select \Type\Argument
      ;         Case #PB_GadgetType_Panel
      ;           ;OpenGadgetList(Object, 0)
      ;           AddGadgetItem(Object, -1, \Object\Argument$)
      ;       EndSelect
      
      Select \Type\Argument ; GadgetType(Object)
        Case #PB_GadgetType_Panel, 
             #PB_GadgetType_Container, 
             #PB_GadgetType_ScrollArea
          CloseGadgetList()
      EndSelect
    EndIf
    
    WE_Tree_0_Update(WE_Tree_0, Position)
    
    
    If GadgetList 
      If IsGadget(Parent) 
        CloseGadgetList() 
      ElseIf IsWindow(Parent)
        UseGadgetList(GadgetList)
      EndIf
    EndIf
    
    ;     Debug "-------------create----------------"
    ;     Debug *This\Content\Text$
    WE_Code_Show(*This\Content\Text$)
    
  EndWith
  
  DataSection
    Model:
    ;{
    Data.s "OpenWindow","500","400","ParentID","0","0", "#PB_Window_SystemMenu"
    Data.s "ButtonGadget","80","20","0","0","0",""
    Data.s "StringGadget","80","20","0","0","0",""
    Data.s "TextGadget","80","20","0","0","0","#PB_Text_Border"
    Data.s "CheckBoxGadget","80","20","0","0","0",""
    Data.s "OptionGadget","80","20","0","0","0",""
    Data.s "ListViewGadget","150","150","0","0","0",""
    Data.s "FrameGadget","150","150","0","0","0",""
    Data.s "ComboBoxGadget","100","20","0","0","0",""
    Data.s "ImageGadget","120","120","0","0","0","#PB_Image_Border"
    Data.s "HyperLinkGadget","150","200","$0000FF","0","0",""
    Data.s "ContainerGadget","140","120","0","0","0", "#PB_Container_Flat"
    Data.s "ListIconGadget","180","180","0","0","0",""
    Data.s "IPAddressGadget","80", "20","0","0","0",""
    Data.s "ProgressBarGadget","80","20","0","0","0",""
    Data.s "ScrollBarGadget","80","20","0","0","0",""
    Data.s "ScrollAreaGadget","150","150","0","0","0",""
    Data.s "TrackBarGadget","180","150","0","0","0",""
    Data.s "WebGadget","100","20","0","0","0",""
    Data.s "ButtonImageGadget","20","20","0","0","0",""
    Data.s "CalendarGadget","150","200","0","0","0",""
    Data.s "DateGadget","80","20","0","0","0",""
    Data.s "EditorGadget","80","20","0","0","0",""
    Data.s "ExplorerListGadget","150","150","0","0","0",""
    Data.s "ExplorerTreeGadget","180","150","0","0","0",""
    Data.s "ExplorerComboGadget","100","20","0","0","0",""
    Data.s "SpinGadget","80","20","-1000","1000","0","#PB_Spin_Numeric"
    Data.s "TreeGadget","150","180","0","0","0",""
    Data.s "PanelGadget","140","120","0","0","0",""
    Data.s "SplitterGadget","180","100","0","0","0","#PB_Splitter_Separator"
    Data.s "MDIGadget","150","150","0","0","0",""
    Data.s "ScintillaGadget","180","150","0","0","0",""
    Data.s "ShortcutGadget","100","20","0","0","0",""
    Data.s "CanvasGadget","150","150","0","0","0",""
    ;}
    
    
    Content:
    ;{
    Data.s "EnableExplicit"+#CRLF$+
           ""+#CRLF$+
           ""+#CRLF$+
           "Declare Window_0_Events()"+#CRLF$+
           ""+#CRLF$+
           "Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)"+#CRLF$+
           "  If Not IsWindow(Window_0)"+#CRLF$+
           "    "+#CRLF$+    
           "    BindEvent(#PB_Event_Gadget, @Window_0_Events(), Window_0)"+#CRLF$+
           "  EndIf"+#CRLF$+
           ""+#CRLF$+  
           "  ProcedureReturn Window_0"+#CRLF$+
           "EndProcedure"+#CRLF$+
           ""+#CRLF$+
           "Procedure Window_0_Events()"+#CRLF$+
           "  Select Event()"+#CRLF$+
           "    Case #PB_Event_Gadget"+#CRLF$+
           "      Select EventType()"+#CRLF$+
           "        Case #PB_EventType_LeftClick"+#CRLF$+
           "          Select EventGadget()"+#CRLF$+
           "             "+#CRLF$+            
           "          EndSelect"+#CRLF$+
           "      EndSelect"+#CRLF$+
           "  EndSelect"+#CRLF$+
           "EndProcedure"+#CRLF$+
           ""+#CRLF$+
           ""+#CRLF$+
           "CompilerIf #PB_Compiler_IsMainFile"+#CRLF$+
           "  Window_0_Open()"+#CRLF$+
           ""+#CRLF$+  
           "  While IsWindow(Window_0)"+#CRLF$+
           "    Select WaitWindowEvent()"+#CRLF$+
           "      Case #PB_Event_CloseWindow"+#CRLF$+
           "        If IsWindow(EventWindow())"+#CRLF$+
           "          CloseWindow(EventWindow())"+#CRLF$+
           "        Else"+#CRLF$+
           "          CloseWindow(Window_0)"+#CRLF$+
           "        EndIf"+#CRLF$+
           "    EndSelect"+#CRLF$+
           "  Wend"+#CRLF$+
           "CompilerEndIf"
    ;}
    
  EndDataSection
  
EndProcedure

Procedure CO_Open() ; Ok
  Protected GetParent, OpenGadgetList, Object=-1
  Static AddGadget
  
  With *This
    ;
    Select \Type\Argument$
      Case "OpenWindow"          : \Type\Argument =- 1  : \Window\Argument =- 1  : \Object\Argument = OpenWindow          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument, \Param1\Argument)
        ; CanvasGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, #PB_Canvas_Container) : CloseGadgetList()
      Case "ButtonGadget"        : \Type\Argument = #PB_GadgetType_Button        : \Object\Argument = ButtonGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "StringGadget"        : \Type\Argument = #PB_GadgetType_String        : \Object\Argument = StringGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "TextGadget"          : \Type\Argument = #PB_GadgetType_Text          : \Object\Argument = TextGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "CheckBoxGadget"      : \Type\Argument = #PB_GadgetType_CheckBox      : \Object\Argument = CheckBoxGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "OptionGadget"        : \Type\Argument = #PB_GadgetType_Option        : \Object\Argument = OptionGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$)
      Case "ListViewGadget"      : \Type\Argument = #PB_GadgetType_ListView      : \Object\Argument = ListViewGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "FrameGadget"         : \Type\Argument = #PB_GadgetType_Frame         : \Object\Argument = FrameGadget         (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "ComboBoxGadget"      : \Type\Argument = #PB_GadgetType_ComboBox      : \Object\Argument = ComboBoxGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "ImageGadget"         : \Type\Argument = #PB_GadgetType_Image         : \Object\Argument = ImageGadget         (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Flag\Argument)
      Case "HyperLinkGadget"     : \Type\Argument = #PB_GadgetType_HyperLink     : \Object\Argument = HyperLinkGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Param1\Argument, \Flag\Argument)
      Case "ContainerGadget"     : \Type\Argument = #PB_GadgetType_Container     : \Object\Argument = ContainerGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "ListIconGadget"      : \Type\Argument = #PB_GadgetType_ListIcon      : \Object\Argument = ListIconGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Param1\Argument, \Flag\Argument)
      Case "IPAddressGadget"     : \Type\Argument = #PB_GadgetType_IPAddress     : \Object\Argument = IPAddressGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument)
      Case "ProgressBarGadget"   : \Type\Argument = #PB_GadgetType_ProgressBar   : \Object\Argument = ProgressBarGadget   (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
      Case "ScrollBarGadget"     : \Type\Argument = #PB_GadgetType_ScrollBar     : \Object\Argument = ScrollBarGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Param3\Argument, \Flag\Argument)
      Case "ScrollAreaGadget"    : \Type\Argument = #PB_GadgetType_ScrollArea    : \Object\Argument = ScrollAreaGadget    (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Param3\Argument, \Flag\Argument) 
      Case "TrackBarGadget"      : \Type\Argument = #PB_GadgetType_TrackBar      : \Object\Argument = TrackBarGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
        ;       Case "WebGadget"           : \Type\Argument = #PB_GadgetType_Web           : \Object\Argument = WebGadget           (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$)
      Case "ButtonImageGadget"   : \Type\Argument = #PB_GadgetType_ButtonImage   : \Object\Argument = ButtonImageGadget   (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Flag\Argument)
      Case "CalendarGadget"      : \Type\Argument = #PB_GadgetType_Calendar      : \Object\Argument = CalendarGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Flag\Argument)
      Case "DateGadget"          : \Type\Argument = #PB_GadgetType_Date          : \Object\Argument = DateGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Param1\Argument, \Flag\Argument)
      Case "EditorGadget"        : \Type\Argument = #PB_GadgetType_Editor        : \Object\Argument = EditorGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "ExplorerListGadget"  : \Type\Argument = #PB_GadgetType_ExplorerList  : \Object\Argument = ExplorerListGadget  (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "ExplorerTreeGadget"  : \Type\Argument = #PB_GadgetType_ExplorerTree  : \Object\Argument = ExplorerTreeGadget  (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "ExplorerComboGadget" : \Type\Argument = #PB_GadgetType_ExplorerCombo : \Object\Argument = ExplorerComboGadget (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "SpinGadget"          : \Type\Argument = #PB_GadgetType_Spin          : \Object\Argument = SpinGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
      Case "TreeGadget"          : \Type\Argument = #PB_GadgetType_Tree          : \Object\Argument = TreeGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "PanelGadget"         : \Type\Argument = #PB_GadgetType_Panel         : \Object\Argument = PanelGadget         (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument) 
      Case "SplitterGadget"      
        ;         Debug "Splitter FirstGadget "+\Param1\Argument
        ;         Debug "Splitter SecondGadget "+\Param2\Argument
        If IsGadget(\Param1\Argument) And IsGadget(\Param2\Argument)
          \Type\Argument = #PB_GadgetType_Splitter                               
          \Object\Argument = SplitterGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
        Else
          \Type\Argument = #PB_GadgetType_Splitter     
          \Param1\Argument = TextGadget(#PB_Any, 0,0,0,0, "Splitter")
          \Param2\Argument = TextGadget(#PB_Any, 0,0,0,0, "")
          \Object\Argument = SplitterGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
          
        EndIf
      Case "MDIGadget"          
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          \Type\Argument = #PB_GadgetType_MDI                                    : \Object\Argument = MDIGadget           (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument) 
        CompilerEndIf
      Case "ScintillaGadget"     : \Type\Argument = #PB_GadgetType_Scintilla     : \Object\Argument = ScintillaGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument)
      Case "ShortcutGadget"      : \Type\Argument = #PB_GadgetType_Shortcut      : \Object\Argument = ShortcutGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument)
      Case "CanvasGadget"        : \Type\Argument = #PB_GadgetType_Canvas        : \Object\Argument = CanvasGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
    EndSelect
    
    ; Заносим данные объекта в памят
    If Bool(IsGadget(\Object\Argument) | IsWindow(\Object\Argument))
      ParsePBGadget()\Type\Argument = \Type\Argument
      ParsePBGadget()\Object\Argument = \Object\Argument
      
      If ParsePBGadget()\Parent\Argument<>\Parent\Argument
        \Parent\Argument$ = \get(Str(\Parent\Argument))\Object\Argument$
        ParsePBGadget()\Parent\Argument=\Parent\Argument
        ParsePBGadget()\Parent\Argument$=\Parent\Argument$
      EndIf
      If ParsePBGadget()\Window\Argument<>\Window\Argument
        \Window\Argument$ = \get(Str(\Window\Argument))\Object\Argument$
        ParsePBGadget()\Window\Argument=\Window\Argument
        ParsePBGadget()\Window\Argument$=\Window\Argument$
      EndIf
      
      If IsWindow(\Object\Argument)
        \Parent\Argument =- 1
      EndIf
      
      Macro Init_object_data(_object_, _object_key_)
        If FindMapElement(*This\get(), _object_key_)
          *This\get(_object_key_)\Index=ListIndex(ParsePBGadget())
          *This\get(_object_key_)\Adress=@ParsePBGadget()
          
          *This\get(_object_key_)\Object\Argument=_object_ 
          *This\get(_object_key_)\Object\Argument$=*This\Object\Argument$ 
          
          *This\get(_object_key_)\Type\Argument=*This\Type\Argument 
          *This\get(_object_key_)\Type\Argument$=*This\Type\Argument$ 
          
          *This\get(_object_key_)\Window\Argument=*This\Window\Argument 
          *This\get(_object_key_)\Parent\Argument=*This\Parent\Argument 
          
          *This\get(_object_key_)\Window\Argument$=*This\Window\Argument$ 
          *This\get(_object_key_)\Parent\Argument$=*This\Parent\Argument$ 
        Else
          AddMapElement(*This\get(), _object_key_)
          *This\get()\Index=ListIndex(ParsePBGadget())
          *This\get()\Adress=@ParsePBGadget()
          
          *This\get()\Object\Argument=_object_ 
          *This\get()\Object\Argument$=*This\Object\Argument$ 
          
          *This\get()\Type\Argument=*This\Type\Argument 
          *This\get()\Type\Argument$=*This\Type\Argument$ 
          
          *This\get()\Window\Argument=*This\Window\Argument 
          *This\get()\Parent\Argument=*This\Parent\Argument 
          
          *This\get()\Window\Argument$=*This\Window\Argument$ 
          *This\get()\Parent\Argument$=*This\Parent\Argument$ 
        EndIf
        
      EndMacro
      
      ; Количество однотипных объектов
      If Not FindMapElement(\get(), Str(\Parent\Argument)+"_"+\Type\Argument$)
        AddMapElement(\get(), Str(\Parent\Argument)+"_"+\Type\Argument$)
        \get()\Index=ListIndex(ParsePBGadget())
        \get()\Adress=@ParsePBGadget()
        \get()\Count+1 
      Else
        \get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count+1 
      EndIf
      
      ; Чтобы по идентификатору 
      ; объекта получить все остальное
      Init_object_data(\Object\Argument, Str(\Object\Argument))
      
      ; Чтобы по классу
      ; объекта получить все остальное
      Init_object_data(\Object\Argument, \Object\Argument$)
      
    EndIf
    
    ; 
    Select \Type\Argument$
      Case "OpenWindow" : \Window\Argument = \Object\Argument : \Parent\Argument = \Object\Argument : \SubLevel = 1
      Case "ContainerGadget", "ScrollAreaGadget" : \Parent\Argument = \Object\Argument : \SubLevel + 1
      Case "PanelGadget" : \Parent\Argument = \Object\Argument : \SubLevel + 1 
        If IsGadget(\Parent\Argument) 
          \Item = GetGadgetData(\Parent\Argument) 
        EndIf
        
      Case "CanvasGadget"
        If ((\Flag\Argument & #PB_Canvas_Container)=#PB_Canvas_Container)
          \Parent\Argument = \Object\Argument : \SubLevel + 1
        EndIf
        
      Case "UseGadgetList" 
        If IsWindow(\Param1\Argument) : \SubLevel = 1
          \Window\Argument = \Param1\Argument
          \Parent\Argument = \Window\Argument
          UseGadgetList( WindowID(\Param1\Argument) )
        EndIf
        
      Case "CloseGadgetList" 
        If IsGadget(\Parent\Argument) : \SubLevel - 1 : CloseGadgetList() 
          \Parent\Argument = *This\get(Str(\Parent\Argument))\Parent\Argument 
          If IsGadget(\Parent\Argument) : \Item = GetGadgetData(\Parent\Argument) : EndIf
        EndIf
        
      Case "OpenGadgetList"      
        \Parent\Argument = \get(\Object\Argument$)\Object\Argument
        If IsGadget(\Parent\Argument) : OpenGadgetList(\Parent\Argument, \Param1\Argument) : EndIf
        
      Case "AddGadgetColumn"       
        Object=\get(\Object\Argument$)\Object\Argument
        If IsGadget(Object)
          AddGadgetColumn(Object, \Param1\Argument, \Caption\Argument$, \Param2\Argument)
        Else
          Debug " add column no_gadget "+\Object\Argument$
        EndIf
        
      Case "AddGadgetItem"   
        Object=\get(\Object\Argument$)\Object\Argument
        If IsGadget(Object) : \Item+1 : SetGadgetData(Object, \Item)
          AddGadgetItem(Object, \Param1\Argument, \Caption\Argument$, \Param2\Argument, \Flag\Argument)
        Else
          Debug " add item no_gadget "+\Object\Argument$
        EndIf
        
    EndSelect
    
    ;
    If IsGadget(\Parent\Argument)
      GetParent = \get(Str(\Parent\Argument))\Parent\Argument
    ElseIf IsWindow(\Parent\Argument)
      \SubLevel = 1
    EndIf
    
    ;
    If IsGadget(\Object\Argument)
      Select \Type\Argument
        Case #PB_GadgetType_Panel, #PB_GadgetType_Container, #PB_GadgetType_ScrollArea
          ParsePBGadget()\SubLevel = \SubLevel - 1
          EnableGadgetDrop(\Object\Argument, #PB_Drop_Text, #PB_Drag_Copy)
          BindEvent(#PB_Event_GadgetDrop, @CO_Events(), ParsePBGadget()\Window\Argument, \Object\Argument)
          
        Case #PB_GadgetType_Canvas
          If ((\Flag\Argument & #PB_Canvas_Container)=#PB_Canvas_Container)
            ParsePBGadget()\SubLevel = \SubLevel - 1
            EnableGadgetDrop(\Object\Argument, #PB_Drop_Text, #PB_Drag_Copy)
            BindEvent(#PB_Event_GadgetDrop, @CO_Events(), ParsePBGadget()\Window\Argument, \Object\Argument)
          EndIf
          
        Default
          ParsePBGadget()\SubLevel = \SubLevel
      EndSelect
      
      ; Итем родителя для создания в нем гаджетов
      If \Item : ParsePBGadget()\Item=\Item-1 : EndIf
      
      ; Открываем гаджет лист на том родителе где создан данный объект.
      If \Object\Argument = \Parent\Argument
        If IsWindow(GetParent) : CloseGadgetList() : UseGadgetList(WindowID(GetParent)) : EndIf
        If IsGadget(GetParent) : OpenGadgetList = OpenGadgetList(GetParent, ParsePBGadget()\Item) : EndIf
      EndIf
      
      ;       Transformation::Create(ParsePBGadget()\Object\Argument, ParsePBGadget()\Window\Argument, ParsePBGadget()\Parent\Argument, ParsePBGadget()\Item, 5)
      ;        Transformation::Create(ParsePBGadget()\Object\Argument, ParsePBGadget()\Parent\Argument, -1, 0, 5)
      ;       ButtonGadget(-1,0,0,160,20,Str(Random(5))+" "+\Parent\Argument$+"-"+Str(\Parent\Argument))
      ;       CallFunctionFast(@CO_Events())
      
      ; Посылаем сообщение, что создали гаджет.
      PostEvent(#PB_Event_Create,
                ParsePBGadget()\Window\Argument,
                ParsePBGadget()\Object\Argument, #PB_All,
                ParsePBGadget()\Parent\Argument)
      
      ; Закрываем ранее открытий гаджет лист.
      If \Object\Argument = \Parent\Argument
        If IsWindow(GetParent) : OpenGadgetList(\Parent\Argument) : EndIf
        If OpenGadgetList : CloseGadgetList() : EndIf
      EndIf
    EndIf
    
    ;
    If IsWindow(\Object\Argument)
      StickyWindow(\Object\Argument, #True)
      ;       Transformation::Create(ParsePBGadget()\Object\Argument, ParsePBGadget()\Window\Argument, ParsePBGadget()\Parent\Argument, ParsePBGadget()\Item, 5)
      PostEvent(#PB_Event_Create, \Object\Argument, #PB_Ignore)
      EnableWindowDrop(\Object\Argument, #PB_Drop_Text, #PB_Drag_Copy)
      
      BindEvent(#PB_Event_Create, @CO_Events(), \Object\Argument)
      BindEvent(#PB_Event_Gadget, @CO_Events(), \Object\Argument)
      BindEvent(#PB_Event_WindowDrop, @CO_Events(), \Object\Argument)
    EndIf
    
    ProcedureReturn \Object\Argument
  EndWith
EndProcedure

Procedure CO_Save(*ThisParse.ParseStruct) ; Ok
  Protected Result$, ID$, Handle$, Result, i
  
  With *ThisParse
    If \Content\String$
      Debug "      "+\Content\String$
      
      For i=2 To 5
        Result$ = Trim(Trim(StringField(\Content\String$, i, ","), ")"))
        ; Debug "Coordinate: "+Result$
        
        Select Asc(Result$)
          Case 'A' To 'Z' , 'a' To 'z'
            
            Select i 
              Case 2 : \X\Argument$ = Result$
              Case 3 : \Y\Argument$ = Result$
              Case 4 : \Width\Argument$ = Result$
              Case 5 : \Height\Argument$ = Result$
            EndSelect
        EndSelect
      Next
      
      If Asc(\Object\Argument$) = 35 ; '#'
        ID$ = \Object\Argument$
      Else
        Handle$ = \Object\Argument$+" = "
        ID$ = "#PB_Any"
      EndIf
      
      Select \Type\Argument$
          Case "OpenWindow"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ButtonGadget"        : \Content\String$ = Handle$+"ButtonGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                 : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "StringGadget"        : \Content\String$ = Handle$+"StringGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                 : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "TextGadget"          : \Content\String$ = Handle$+"TextGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "CheckBoxGadget"      : \Content\String$ = Handle$+"CheckBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                               : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "OptionGadget"        : \Content\String$ = Handle$+"OptionGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
          Case "ListViewGadget"      : \Content\String$ = Handle$+"ListViewGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                        : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "FrameGadget"         : \Content\String$ = Handle$+"FrameGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                  : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ComboBoxGadget"      : \Content\String$ = Handle$+"ComboBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                        : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ImageGadget"         : \Content\String$ = Handle$+"ImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "HyperLinkGadget"     : \Content\String$ = Handle$+"HyperLinkGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                                       : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ContainerGadget"     : \Content\String$ = Handle$+"ContainerGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                       : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ListIconGadget"      : \Content\String$ = Handle$+"ListIconGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                                        : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "IPAddressGadget"     : \Content\String$ = Handle$+"IPAddressGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$
          Case "ProgressBarGadget"   : \Content\String$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                      : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ScrollBarGadget"     : \Content\String$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$+", "+\Param3\Argument$                                                 : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ScrollAreaGadget"    : \Content\String$ = Handle$+"ScrollAreaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$    : If \Param3\Argument$ : \Content\String$ +", "+\Param3\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf 
          Case "TrackBarGadget"      : \Content\String$ = Handle$+"TrackBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                         : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "WebGadget"           : \Content\String$ = Handle$+"WebGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
          Case "ButtonImageGadget"   : \Content\String$ = Handle$+"ButtonImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                                             : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "CalendarGadget"      : \Content\String$ = Handle$+"CalendarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                     : If \Param1\Argument$ : \Content\String$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "DateGadget"          : \Content\String$ = Handle$+"DateGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                : If \Param1\Argument$ : \Content\String$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "EditorGadget"        : \Content\String$ = Handle$+"EditorGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                          : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ExplorerListGadget"  : \Content\String$ = Handle$+"ExplorerListGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                           : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ExplorerTreeGadget"  : \Content\String$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                           : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "ExplorerComboGadget" : \Content\String$ = Handle$+"ExplorerComboGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                          : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "SpinGadget"          : \Content\String$ = Handle$+"SpinGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                             : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "TreeGadget"          : \Content\String$ = Handle$+"TreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                            : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
        Case "PanelGadget"         : \Content\String$ = Handle$+"PanelGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$ 
          Case "SplitterGadget"      : \Content\String$ = Handle$+"SplitterGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                         : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
          Case "MDIGadget"           : \Content\String$ = Handle$+"MDIGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                              : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf 
        Case "ScintillaGadget"     : \Content\String$ = Handle$+"ScintillaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
        Case "ShortcutGadget"      : \Content\String$ = Handle$+"ShortcutGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
          Case "CanvasGadget"        : \Content\String$ = Handle$+"CanvasGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                          : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
      EndSelect
      
      \Content\String$+")" 
      Result = Len(\Content\String$)
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure



;-
Procedure ParsePBFile(FileName.s)
  Protected i,Result, Texts.S, Text.S, Find.S, String.S, Count, Position, Index, Args$, Arg$
  
  If ReadFile(#File, FileName)
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_Extended    
    Protected Line, FindWindow, Text$, FunctionArgs$
    Protected Format=ReadStringFormat(#File)
    Protected Length = Lof(#File) 
    Protected *File = AllocateMemory(Length)
    
    
    If *File 
      ReadData(#File, *File, Length)
      *This\Content\Text$ = PeekS(*File, Length, Format) ; "+#RegEx_Pattern_Function+~"
      
      If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
         CreateRegularExpression(#RegEx_Arguments, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
         CreateRegularExpression(#RegEx_Captions, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) And
         CreateRegularExpression(#RegEx_Arguments1, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
         CreateRegularExpression(#RegEx_Captions1, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) 
        
        
        If ExamineRegularExpression(#RegEx_Function, *This\Content\Text$)
          While NextRegularExpressionMatch(#RegEx_Function)
            With *This
              
              If RegularExpressionGroup(#RegEx_Function, 1) = "" And RegularExpressionGroup(#RegEx_Function, 9) = ""
                \Type\Argument$=RegularExpressionGroup(#RegEx_Function, 7)
                \Args$=Trim(RegularExpressionGroup(#RegEx_Function, 8))
                
                If RegularExpressionGroup(#RegEx_Function, 3)
                  \Object\Argument$ = RegularExpressionGroup(#RegEx_Function, 3)
                EndIf
                
                ; Если идентификатрор сгенерирован с #PB_Any то есть (Ident=PBFunction(#PB_Any))
                If RegularExpressionGroup(#RegEx_Function, 3)
                  \Object\Argument$ = RegularExpressionGroup(#RegEx_Function, 3)
                  \Content\String$ = RegularExpressionMatchString(#RegEx_Function)
                  \Content\Length = RegularExpressionMatchLength(#RegEx_Function)
                  \Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
                EndIf
                
                If \Type\Argument$
                  ; Debug "All - "+RegularExpressionMatchString(#RegEx_Function)
                  
                  Select \Type\Argument$
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
                      ParsePBGadget()\Type\Argument$ = \Type\Argument$
                      ParsePBGadget()\Content\String$ = \Content\String$ + RegularExpressionMatchString(#RegEx_Function)
                      ParsePBGadget()\Content\Length = \Content\Length + RegularExpressionMatchLength(#RegEx_Function)
                      If \Content\Position
                        ParsePBGadget()\Content\Position = \Content\Position
                      Else
                        ParsePBGadget()\Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
                      EndIf
                      
                      ; Границы для добавления объектов
                      \Content\Position=ParsePBGadget()\Content\Position
                      \Content\Length=ParsePBGadget()\Content\Length
                      
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Arg$ : Index+1
                            If (Index>5)
                              Select \Type\Argument$
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
                                  
                                Case "OpenWindow"
                                  If Index=7 : Index+3 : EndIf
                                  If Index=11 : Index-4: EndIf ; param1=OwnerID
                                  
                                Case "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget","FrameGadget",
                                     "ExplorerListGadget","ExplorerTreeGadget","ExplorerComboGadget"
                                  If Index=7 : Index+3 : EndIf
                                  
                                Case "HyperLinkGadget","DateGadget","ListIconGadget"
                                  If Index=8 : Index+2 : EndIf
                                  
                              EndSelect
                            EndIf
                            
                            Select Index
                              Case 1
                                If Bool(Arg$<>"#PB_Any" And Arg$<>"#PB_All" And Arg$<>"#PB_Default" And Asc(Arg$)<>'-')
                                  ; Если идентификаторы окон цыфри
                                  If Val(Arg$)
                                    If \Type\Argument$="OpenWindow"
                                      \Object\Argument$ = Arg$+"_Window"
                                    Else
                                      \Object\Argument$ = Arg$+"_"+ReplaceString(\Type\Argument$, "Gadget","")
                                    EndIf
                                  Else
                                    \Object\Argument$ = Arg$
                                  EndIf
                                EndIf
                                ParsePBGadget()\Object\Argument$ = \Object\Argument$
                                
                              Case 2 : ParsePBGadget()\X\Argument$ = Arg$
                                MacroCoordinate(\X\Argument, Arg$)
                                
                              Case 3 : ParsePBGadget()\Y\Argument$ = Arg$
                                MacroCoordinate(\Y\Argument, Arg$)
                                
                              Case 4 : ParsePBGadget()\Width\Argument$ = Arg$
                                MacroCoordinate(\Width\Argument, Arg$)
                                
                              Case 5 : ParsePBGadget()\Height\Argument$ = Arg$
                                MacroCoordinate(\Height\Argument, Arg$)
                                
                              Case 6 : ParsePBGadget()\Caption\Argument$ = Arg$
                                \Caption\Argument$ = GetStr(Arg$) 
                                
                              Case 7 : ParsePBGadget()\Param1\Argument$ = Arg$
                                Select \Type\Argument$ 
                                  Case "OpenWindow"      
                                    \Param1\Argument$ = get_argument_string(Arg$)
                                    
                                    ; Если идентификаторы окон цыфри
                                    If Val(\Param1\Argument$)
                                      \Param1\Argument$+"_Window"
                                    Else
                                      \Param1\Argument$ = Arg$
                                    EndIf
                                    
                                    \Param1\Argument = *This\get(\Param1\Argument$)\Object\Argument
                                    
                                    If \Param1\Argument
                                      \Param1\Argument = WindowID(\Param1\Argument)
                                    EndIf
                                    
                                  Case "SplitterGadget"      
                                    \Param1\Argument = *This\get(Arg$)\Object\Argument
                                    
                                  Case "ImageGadget"      
                                    Result = \Img(GetStr(Arg$))\Object\Argument 
                                    If IsImage(Result)
                                      \Param1\Argument = ImageID(Result)
                                    EndIf
                                    
                                  Default
                                    Select Asc(Arg$)
                                      Case '0' To '9'
                                        \Param1\Argument = Val(Arg$)
                                      Default
                                    EndSelect
                                EndSelect
                                
                              Case 8 : ParsePBGadget()\Param2\Argument$ = Arg$
                                Select \Type\Argument$ 
                                  Case "SplitterGadget"      
                                    \Param2\Argument = *This\get(Arg$)\Object\Argument
                                    
                                  Default
                                    Select Asc(Arg$)
                                      Case '0' To '9'
                                        \Param2\Argument = Val(Arg$)
                                      Default
                                    EndSelect
                                EndSelect
                                
                              Case 9 : ParsePBGadget()\Param3\Argument$ = Arg$
                                \Param3\Argument = Val(Arg$)
                                
                              Case 10 
                                Select Asc(Arg$)
                                  Case '0' To '9'
                                    \Flag\Argument = Val(Arg$)
                                  Default
                                    \Flag\Argument = CO_Flag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    If \Flag\Argument = 0
                                      Arg$ = GetVarValue(Arg$)
                                      \Flag\Argument = Val(Arg$)
                                    EndIf
                                    If \Flag\Argument = 0
                                      \Flag\Argument = CO_Flag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    EndIf
                                EndSelect
                                ParsePBGadget()\Flag\Argument$ = Arg$
                            EndSelect
                            
                          EndIf
                        Wend
                      EndIf
                      
                      Protected win = CallFunctionFast(@CO_Open())
                      
                      \Object\Argument=-1
                      \Object\Argument$=""
                      \Param1\Argument = 0
                      \Param2\Argument = 0
                      \Param3\Argument = 0
                      \Caption\Argument$ = ""
                      \Flag\Argument = 0
                      
                    Case "UseGadgetList"
                      \Param1\Argument$ = get_argument_string(\Args$)
                      
                      ; Если идентификаторы окон цыфри
                      If Val(\Param1\Argument$)
                        \Param1\Argument$+"_Window"
                      Else
                        \Param1\Argument$ = \Args$
                      EndIf
                      
                      \Param1\Argument = *This\get(\Param1\Argument$)\Object\Argument
                      
                      If \Param1\Argument
                        *This\get(\Object\Argument$)\Object\Argument = *This\get(Str(\Param1\Argument))\Window\Argument
                      Else
                        \Param1\Argument = *This\get(\Param1\Argument$)\Object\Argument
                      EndIf
                      
                      CallFunctionFast(@CO_Open())
                      
                    Case "CloseGadgetList"      : CallFunctionFast(@CO_Open()) ; ; TODO
                      
                    Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"      
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Arg$ : Index+1
                            Select Index
                              Case 1 
                                \Object\Argument$ = Arg$
                                If Val(Arg$)
                                  PushListPosition(ParsePBGadget())
                                  ForEach ParsePBGadget()
                                    If Val(ParsePBGadget()\Object\Argument$) = Val(Arg$)
                                      \Object\Argument$ = ParsePBGadget()\Object\Argument$
                                    EndIf
                                  Next
                                  PopListPosition(ParsePBGadget())
                                EndIf
                                
                                ;*This\get(Str(\Parent\Argument))\Object\Argument$
                                ;                                 \Object\Argument$ = *This\get(Str(\Parent\Argument))\Object\Argument$
                                
                                
                              Case 2 : \Param1\Argument = Val(Arg$)  
                              Case 3 : \Caption\Argument$=GetStr(Arg$)
                              Case 4 : \Param2\Argument = Val(Arg$)
                              Case 5 : \Flag\Argument$ = Arg$
                                \Flag\Argument = CO_Flag(Arg$)
                                If Not \Flag\Argument
                                  Select Asc(\Flag\Argument$)
                                    Case '0' To '9'
                                    Default
                                      \Flag\Argument = CO_Flag(GetVarValue(Arg$))
                                  EndSelect
                                EndIf
                            EndSelect
                          EndIf
                        Wend
                      EndIf
                      
                      ;Debug " g "+\Object\Argument$ +" "+ Str(*This\get(\Object\Argument$)\Object\Argument)
                      CallFunctionFast(@CO_Open())
                      
                      
                      \Object\Argument =- 1
                      \Object\Argument$ = ""
                      \Flag\Argument = 0
                      \Param1\Argument = 0
                      \Param2\Argument = 0
                      \Param3\Argument = 0
                      \Flag\Argument$ = ""
                      \Param1\Argument$ = ""
                      \Param2\Argument$ = ""
                      \Param3\Argument$ = ""
                      \Caption\Argument$ = ""
                      ;ClearStructure(*This, ParseStruct)
                      ;                         FreeStructure(*This)
                      ;                         *This.ParseStruct = AllocateStructure(ParseStruct)
                      
                    Default
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Args$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Args$
                            \Args$ = Args$ 
                            Index+1
                            CF_Add(*This, Index)
                          EndIf
                        Wend
                        
                        CF_Set(*This)
                      EndIf
                      
                  EndSelect
                  
                EndIf
              EndIf
            EndWith
          Wend
          
        Else
          Debug "Nothing to extract from: " + *This\Content\Text$
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
    Result = #True
  EndIf
  
  ProcedureReturn Result
EndProcedure



;-
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
      MessageRequester("Designer Error", "SilkTheme.zip Not found in the Content directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
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
                Select GadgetName
                  Case "buttongadget",
                       "stringgadget",
                       ;                        "textgadget",
                       ;                        "checkboxgadget",
                       ;                        "optiongadget",
                       ;                        "listviewgadget",
                       ;                        "framegadget",
                       ;                        "comboboxgadget",
                       ;                        "imagegadget",
                       ;                        "hyperlinkgadget",
                    "containergadget",
;                        "listicongadget",
;                        "ipaddressgadget",
;                        "progressbargadget",
;                        "scrollbargadget",
;                        "scrollareagadget",
;                        "trackbargadget",
; ;                        "webgadget",
;                        "buttonimagegadget",
;                        "calendargadget",
;                        "dategadget",
;                        "editorgadget",
;                        "explorerlistgadget",
;                        "explorertreegadget",
;                        "explorercombogadget",
;                        "spingadget",
;                        "treegadget",
                    "panelgadget",
;                        "splittergadget",
;                        "mdigadget",
;                        "scintillagadget",
;                        "shortcutgadget",
;                        "canvasgadget",
                    "gadget"
                    AddGadgetItem(WE_Tree_1, -1, GadgetName, ImageID(GadgetImage))
                EndSelect
                
                
              EndIf
          EndSelect
          
          FreeMemory(*GadgetImage)
        EndIf
      Wend
    EndIf
    ClosePack(ZipFile)
  EndIf
EndProcedure

;-
;- PI Редактора
Procedure WE_Tree_0_Position(Gadget, Parent)
  Protected i, Position=-1 ; 
  
  ; Определяем позицию в списке
  If IsGadget(Parent) 
    For i=0 To CountGadgetItems(Gadget)-1
      If Parent=GetGadgetItemData(Gadget, i) 
        *This\SubLevel=GetGadgetItemAttribute(Gadget, i, #PB_Tree_SubLevel)+1
        Position=(i+1)
        Break
      EndIf
    Next 
    For i=Position To CountGadgetItems(Gadget)-1
      If *This\SubLevel=<GetGadgetItemAttribute(Gadget, i, #PB_Tree_SubLevel)
        Position+1
      EndIf
    Next 
  ElseIf IsWindow(Parent)
    Position = CountGadgetItems(Gadget)
    *This\SubLevel = 1
  EndIf
  
  ProcedureReturn Position
EndProcedure

Procedure WE_Tree_0_Update(Gadget, Position=-1)
  Protected i
  
  ; Добавляем объекты к списку
  If Position=-1
    PushListPosition(ParsePBGadget())
    ForEach ParsePBGadget()
      Position = CountGadgetItems(Gadget)
      AddGadgetItem (Gadget, -1, ParsePBGadget()\Object\Argument$, 0, ParsePBGadget()\SubLevel)
      SetGadgetItemData(Gadget, Position, ParsePBGadget()\Object\Argument)
    Next
    PopListPosition(ParsePBGadget())
  Else
    AddGadgetItem(Gadget, Position, ParsePBGadget()\Object\Argument$, 0, ParsePBGadget()\SubLevel)
    SetGadgetItemData(Gadget, Position, ParsePBGadget()\Object\Argument)
    ;     SetGadgetItemImage(Gadget, Position, ImageID())
  EndIf
  
  ; Раскрываем весь список
  For i=0 To Position 
    If GetGadgetItemState(Gadget, i) & #PB_Tree_Collapsed
      SetGadgetItemState(Gadget, i, #PB_Tree_Expanded)
    EndIf
  Next 
  
  ; Выбыраем последный объект списка
  SetGadgetState(Gadget, Position) ; Bug
  SetGadgetItemState(Gadget, Position, #PB_Tree_Selected)
EndProcedure 

Procedure WE_Tree_0_Replace(Gadget)
  Protected Find$ = GetGadgetText(Gadget)
  Protected Replace$ = GetGadgetText(EventGadget())
  Protected RegExID = CreateRegularExpression(#PB_Any, "(?<!\w)"+Find$+"(?!\w|\s*"+~"\")")
  
  PushListPosition(ParsePBGadget())
  ForEach ParsePBGadget()
    If ParsePBGadget()\Object\Argument$ = Find$
      ParsePBGadget()\Object\Argument$ = Replace$ 
      Break 
    EndIf
  Next
  PopListPosition(ParsePBGadget())  
  
  replace_map_key(GetGadgetText(Gadget), Replace$)
  
  If RegExID
    If ExamineRegularExpression(RegExID, *This\Content\Text$)
      While NextRegularExpressionMatch(RegExID)
        *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Replace$)
        Break
      Wend
    EndIf
    FreeRegularExpression(RegExID)
  EndIf
  
  SetGadgetText(Gadget, Replace$)
  
  WE_Code_Show(*This\Content\Text$)
EndProcedure

Procedure WE_OpenFile(Path$) ; Открытие файла
  If Path$
    Debug "Открываю файл '"+Path$+"'"
    
    ; Начинаем перебырать файл
    If ParsePBFile(Path$)
      
      WE_Tree_0_Update(WE_Tree_0)
      
    EndIf
    
    *This\Content\File$=Path$
    Debug "..успешно"
  EndIf 
EndProcedure

Procedure WE_SaveFile(Path$) ; Процедура сохранения файла
  If Path$
    *This\Content\File$=Path$
    ClearDebugOutput()
    Debug "Сохраняю файл '"+Path$+"'"
    
    Protected Object
    Protected len, Length, Position
    Protected Space$, Text$
    
    len = 0
    
    PushListPosition(ParsePBGadget())
    ForEach ParsePBGadget()
      Object = ParsePBGadget()\Object\Argument ; *This\get(ParsePBGadget()\Object\Argument$)\Object\Argument
      
      If IsWindow(Object)
        ParsePBGadget()\X\Argument$ = Str(WindowX(Object))
        ParsePBGadget()\Y\Argument$ = Str(WindowY(Object))
        ParsePBGadget()\Width\Argument$ = Str(WindowWidth(Object))
        ParsePBGadget()\Height\Argument$ = Str(WindowHeight(Object))
        ParsePBGadget()\Caption\Argument$ = GetWindowTitle(Object)
      EndIf
      If IsGadget(Object)
        ParsePBGadget()\X\Argument$ = Str(GadgetX(Object))
        ParsePBGadget()\Y\Argument$ = Str(GadgetY(Object))
        ParsePBGadget()\Width\Argument$ = Str(GadgetWidth(Object))
        ParsePBGadget()\Height\Argument$ = Str(GadgetHeight(Object))
        ParsePBGadget()\Caption\Argument$ = GetGadgetText(Object)
      EndIf
      
    Next
    
    With ParsePBGadget()
      ForEach ParsePBGadget()
        ;         If \Content\String$=""
        ;           \Length = 53
        ;           \Position = 409
        ;           \Content\String$ = ~"OpenWindow(#Window_0, 230,230,240,200,\"Window_0\", Flag)"
        ;         EndIf
        
        
        Text$ = \Content\String$
        Length = CO_Save(ParsePBGadget())
        
        ;         If Text$= ""
        ;           Text$=\Content\String$
        ;           EndIf
        
        If (Length>\Content\Length)
          Position = \Content\Position
          *This\Content\Text$ = InsertString(*This\Content\Text$, Space(Length), 1+(\Content\Position+\Content\Length+len))
          \Content\Length = Length
          \Content\Position + Len
          len + Length
        Else
          \Content\String$ + Space((\Content\Length-Length))
        EndIf
        
        Debug ""+Str(Position)+" "+Str(Length)+" "+Text$+" "+\Object\Argument$
        Debug "  "+Str(\Content\Position)+" "+Str(\Content\Length)+" "+\Content\String$+" "+\Object\Argument$
        ;*This\Content\Text$=ReplaceString(*This\Content\Text$, Text$, \Content\String$, #PB_String_CaseSensitive, Position, 1)
        ReplaceString(*This\Content\Text$, Text$, \Content\String$, #PB_String_InPlace, Position, 1)
        ;Replace(\Content\String$, Text$, \Content\Position)
      Next
    EndWith
    PopListPosition(ParsePBGadget())
    
    Debug *This\Content\Text$
    
    If CreateFile(#File, *This\Content\File$, #PB_UTF8)
      WriteStringFormat(#File, #PB_UTF8)
      WriteString(#File, *This\Content\Text$, #PB_UTF8)
      CloseFile(#File)
      
      Debug "..успешно"
    Else
      MessageRequester("Information","may not create the file!")
    EndIf
  EndIf
  
  ProcedureReturn Bool(*This\Content\File$)
EndProcedure

;-
Procedure WE_OpenWindow(Flag.i=#PB_Window_SystemMenu, ParentID=0)
  If Not IsWindow(WE)
    WE = OpenWindow(#PB_Any, 900, 100, 320, 600, "(WE) - Редактор объектов", Flag, ParentID)
    StickyWindow(WE, #True)
    
    WE_Code_Init(WE)
    
    WE_Menu_0 = CreateMenu(#PB_Any, WindowID(WE))
    If WE_Menu_0
      MenuTitle("Project")
      MenuItem(WE_Menu_New, "New"         +Chr(9)+"Ctrl+N")
      MenuItem(WE_Menu_Open, "Open"       +Chr(9)+"Ctrl+O")
      MenuItem(WE_Menu_Save, "Save"       +Chr(9)+"Ctrl+S")
      MenuItem(WE_Menu_Save_as, "Save as" +Chr(9)+"Ctrl+A")
      MenuItem(WE_Menu_Code, "Code"       +Chr(9)+"Ctrl+C")
      MenuItem(WE_Menu_Quit, "Quit"     +Chr(9)+"Ctrl+Q")
    EndIf
    
    WE_Tree_0 = TreeGadget(#PB_Any, 5, 5, 315, 145, #PB_Tree_AlwaysShowSelection)
    WE_Panel_0 = PanelGadget(#PB_Any, 5, 159, 315, 261)
    
    AddGadgetItem(WE_Panel_0, -1, "Objects")
    WE_Tree_1 = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
    EnableGadgetDrop(WE_Tree_1, #PB_Drop_Text, #PB_Drag_Copy)
    
    AddGadgetItem(WE_Panel_0, -1, "Properties")
    WE_Properties = Properties::Gadget( #PB_Any, 315, 261 )
    Properties_ID = Properties::AddItem( WE_Properties, "ID:", #PB_GadgetType_String | #PB_GadgetType_CheckBox )
    Properties::AddItem( WE_Properties, "Text:", #PB_GadgetType_String )
    Properties::AddItem( WE_Properties, "Disable:False|True", #PB_GadgetType_ComboBox )
    Properties::AddItem( WE_Properties, "Hide:False|True", #PB_GadgetType_ComboBox )
    
    Properties::AddItem( WE_Properties, "Layouts:", #False )
    Properties::AddItem( WE_Properties, "X:", #PB_GadgetType_Spin )
    Properties::AddItem( WE_Properties, "Y:", #PB_GadgetType_Spin )
    Properties::AddItem( WE_Properties, "Width:", #PB_GadgetType_Spin )
    Properties::AddItem( WE_Properties, "Height:", #PB_GadgetType_Spin )
    
    Properties::AddItem( WE_Properties, "Other:", #False )
    Properties_Flag = Properties::AddItem( WE_Properties, "Flag:", #PB_GadgetType_Tree|#PB_GadgetType_Button )
    Properties::AddItem( WE_Properties, "Font:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties_Image = Properties::AddItem( WE_Properties, "Image:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( WE_Properties, "Puth", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( WE_Properties, "Color:", #PB_GadgetType_String|#PB_GadgetType_Button )
    
    ; 
    AddGadgetItem(WE_Panel_0, -1, "Events")
    CloseGadgetList()
    
    WE_Splitter_0 = SplitterGadget(#PB_Any, 5, 5, 320-10, 600-MenuHeight()-10, WE_Tree_0, WE_Panel_0, #PB_Splitter_FirstFixed)
    SetGadgetState(WE_Splitter_0, 145)
    
    LoadControls()
    WE_ResizePanel_0()
    
    ;;;WE_OpenFile("Ссылкодел.pb")
    
    BindEvent(#PB_Event_Menu, @WE_Events(), WE)
    BindEvent(#PB_Event_Gadget, @WE_Events(), WE)
    BindEvent(#PB_Event_SizeWindow, @WE_ResizeWindow(), WE)
    
    BindGadgetEvent(WE_Panel_0, @WE_ResizePanel_0(), #PB_EventType_Resize)
    BindEvent(#PB_Event_CloseWindow, @WE_CloseWindow(), WE)
  EndIf
  
  ProcedureReturn WE
EndProcedure


Procedure WE_ResizePanel_0()
  Protected GadgetWidth = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemWidth)
  Protected GadgetHeight = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemHeight)
  
  Select GetGadgetItemText(WE_Panel_0, GetGadgetState(WE_Panel_0))
    Case "Properties" : Properties::Size(GadgetWidth, GadgetHeight)
    Case "Objects"  : ResizeGadget(WE_Tree_1, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
  EndSelect
EndProcedure

Procedure WE_ResizeWindow()
  Protected WindowWidth = WindowWidth(WE)
  Protected WindowHeight = WindowHeight(WE)-MenuHeight()
  ResizeGadget(WE_Splitter_0, 5, 5, WindowWidth - 10, WindowHeight - 10)
  WE_ResizePanel_0()
EndProcedure

Procedure WE_CloseWindow()
  If IsWindow(WE)
    UnbindEvent(#PB_Event_Menu, @WE_Events(), WE)
    UnbindEvent(#PB_Event_Gadget, @WE_Events(), WE)
    UnbindEvent(#PB_Event_SizeWindow, @WE_ResizeWindow(), WE)
    
    UnbindGadgetEvent(WE_Panel_0, @WE_ResizePanel_0(), #PB_EventType_Resize)
    
    CloseWindow(WE)
  EndIf
EndProcedure



Procedure WE_Events()
  Protected I, File$, SubItem, UseGadgetList
  Protected IsContainer.b, Object, Parent=-1
  ;-
  Select Event()
    Case #PB_Event_Gadget ;- Gadget()
      Select EventGadget()
        Case Properties_ID ;- Event(_Properties_ID_)
          
          Select EventType()
            Case #PB_EventType_Change      
              WE_Tree_0_Replace(WE_Tree_0)
              
          EndSelect
          
        Case Properties_Flag ;- Event(_Properties_Flag_)
          
          Select EventType()
            Case #PB_EventType_LostFocus   
              PushListPosition(ParsePBGadget())
              ForEach ParsePBGadget()
                If ParsePBGadget()\Object\Argument$ = GetGadgetText(WE_Tree_0)
                  ParsePBGadget()\Flag\Argument$ = Properties::GetCheckedText(EventGadget()) 
                  Break
                EndIf
              Next
              PopListPosition(ParsePBGadget())
              
          EndSelect
          
        Case WE_Tree_0 ;- Event(_WE_Tree_0_)
          
          Select EventType()
            Case #PB_EventType_RightClick    
              Transformation::PopupMenu(GetGadgetItemData(WE_Tree_0, GetGadgetState(WE_Tree_0)))
              
              
            Case #PB_EventType_Change     
              ; Для удобства выбираем вкладку свойства 
              If GetGadgetState(WE_Panel_0) <> 1 : SetGadgetState(WE_Panel_0, 1) : EndIf
              
              PushListPosition(ParsePBGadget())
              With ParsePBGadget()
                ForEach ParsePBGadget()
                  If GetGadgetText(WE_Tree_0) = \Object\Argument$
                    Properties::Init(\Object\Argument, \Object\Argument$, \Flag\Argument$)
                    Transformation::Change(\Object\Argument)
                    Break
                  EndIf
                Next
              EndWith
              PopListPosition(ParsePBGadget())
              
          EndSelect
          
        Case WE_Tree_1 ;- Event(_WE_Tree_1_)
          
          Select EventType()
            Case #PB_EventType_DragStart
              DragText(GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget())))
          EndSelect
          
      EndSelect
      
    Case #PB_Event_Menu ;- Menu()
      
      Select EventMenu()
        Case WE_Menu_Quit
          End
        Case WE_Menu_Code
          CodeShow ! 1
          If CodeShow
            HideWindow(WE_Code, #False)
          Else
            HideWindow(WE_Code, #True)
          EndIf
          
        Case WE_Menu_Delete ;- Event(_WE_Menu_Delete_) 
                            ; Debug EventGadget()
          CO_Free(GetGadgetItemData(WE_Tree_0, GetGadgetState(WE_Tree_0)))
          
        Case WE_Menu_Open ;- Event(_WE_Menu_Open_) 
          WE_OpenFile(OpenFileRequester("Выберите файл с описанием окон", *This\Content\File$, "Все файлы|*", 0))
          
        Case WE_Menu_Save_as ;- Event(_WE_Menu_Save_as_) 
          If Not WE_SaveFile("Test_0.pb") ; SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
            MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
          EndIf
          
        Case WE_Menu_Save ;- Event(_WE_Menu_Save_) 
          If Not WE_SaveFile(*This\Content\File$)
            If Not WE_SaveFile(SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
              MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
            EndIf
          EndIf
          
        Case WE_Menu_New ;- Event(_WE_Menu_New_)
          CO_Create("Window",WindowX(EventWindow())-350,WindowHeight(EventWindow())-300)
          
          ;           WE_OpenFile("Window_0.pb")
          
          
          SetGadgetState(WE_Panel_0, 0)
          
          
      EndSelect
      
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  MainWindow = WE_OpenWindow(#PB_Window_SystemMenu|#PB_Window_SizeGadget) ; Инициализация окна редактора
  
  Select CountProgramParameters()                 ; Обработка параметров программы
    Case 1 : WE_OpenFile(ProgramParameter(0))
  EndSelect
  
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