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


; Найти Enumeration 
; https://regex101.com/r/u60Wqt/1

#RegEx_Pattern_Find = ""+
                      ; https://regex101.com/r/oIDfrI/2
"(?P<Comments>;).* |"+
; #Эта часть нужна для поиска переменных
; #Например, "Window" в выражении "Window=OpenWindow(#PB_Any...)"
"(?:(?P<Handle>[^:\n\s]+)\s*=\s*)?"+
"(?P<FuncString>"+
~"\".*\" |"+
; #Эта часть для поиска функций
"\b(?P<FuncName>\w+)\s*"+
; #Эта часть для поиска аргументов функции
"(?:\((?P<FuncArguments>(?>(?R)|[^()])*)\))"+
") |"+
; #Эта часть для поиска процедур
"(?P<StartPracedure>\bProcedure[.A-Za-z]* \s*"+
; #Эта часть для поиска имени процедуры
"(?P<PracName>\w*) \s*"+
; #Эта часть для поиска аргументов процедуры
"(?:\((?P<ProcArguments>(?>(?R)|[^()])*)\))) |"+
; #Эта часть для поиска конец процедуры
"(?P<StopProcedure>\bEndProcedure\b)"
; 
; #После выполнения:
; # - В группе (Comments) будет находиться комментария
; # - В группе (Handle) будет находиться название переменной
; # - В группе (FunctionName) - название Функции
; # - В группе (FuncArguments) - перечень всех аргументов найденной Функции
; # - В группе (ProcedureName) - название процедуры
; # - В группе (ProcArguments) - перечень всех аргументов найденной процедуры


;#RegEx_Pattern_Others1 = ~"[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\]"
#RegEx_Pattern_Quotes = ~"(?:\"(.*?)\")" ; - Находит Кавычки
#RegEx_Pattern_Others = ~"(?:[\\s\\^\\|\\!\\~\\&\\$])" ; Находим остальное
#RegEx_Pattern_Match = ~"(?:([\\/])|([\\*])|([\\-])|([\\+]))" ; Находит (*-+/)
                                                              ;#RegEx_Pattern_Function = ~"(?:(\\w*)\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
#RegEx_Pattern_Function = ~"(?:(\\b[A-Za-z_]\\w+)?\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
#RegEx_Pattern_World = ~"(?:([\\d]+)|(\b[\\w]+)|([\\#\\w]+)|([\\*\\w]+)|[\\.]([\\w]+)|([\\\\w]+))"
#RegEx_Pattern_Captions = #RegEx_Pattern_Quotes+"|"+#RegEx_Pattern_Function+"|"+#RegEx_Pattern_Match+"|"+#RegEx_Pattern_World
#RegEx_Pattern_Arguments = "("+#RegEx_Pattern_Captions+"|"+#RegEx_Pattern_Others+")+"

#RegEx_Pattern_Func = ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)"


EnableExplicit

; CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
;   XIncludeFile "/Users/as/Documents/GitHub/Widget/TreeGadget.pb"
; CompilerElse
;   XIncludeFile "Z:/Documents/GitHub/Widget/TreeGadget.pb"
; CompilerEndIf
CompilerIf #PB_Compiler_OS = #PB_OS_MacOS 
   ; XIncludeFile "/Users/as/Documents/GitHub/Widget/gadget/gadgets.pbi"
CompilerElse
   ; XIncludeFile "";Z:/Documents/GitHub/widget/gadget/gadgets.pbi"
CompilerEndIf
#PB_EventType_CloseItem =- 55
;UseModule Gadget
;UseModule constants

;-
;- INCLUDE
XIncludeFile "Include/Memory.pbi"
XIncludeFile "include/Img.pbi"
XIncludeFile "include/SetIcon.pbi"
XIncludeFile "include/Constant.pbi"
XIncludeFile "include/Alignment.pbi"
XIncludeFile "include/Caret.pbi"
XIncludeFile "include/Disable.pbi"
;XIncludeFile "include/Resize.pbi"
XIncludeFile "include/Hide.pbi"
XIncludeFile "include/Flag.pbi"
XIncludeFile "include/Properties.pbi"
XIncludeFile "include/Transformation.pbi"
XIncludeFile "include/wg.pbi"

; helpers
XIncludeFile "include/Helper/Splitter.pbi"
XIncludeFile "include/Helper/Image.pbi"

;XIncludeFile "include/Scintilla.pbi"

XIncludeFile "include/Preferences.pbi" ; Окно настроек



Global WE_Code=-1, CodeShow.b



;-
;- GLOBAL
Global WE=-1, 
       WE_Menu_0=-1, 
       WE_PopupMenu_0=-1,
       WE_Selecting=-1, 
       WE_Objects=-1, 
       WE_Panel_0=-1,
       WE_Panel_1=-1,
       WE_Splitter_0=-1,
       WE_ScrollArea_0=-1,
       WE_Scintilla_0=-1,
       WE_Splitter_1=-1

Global WE_Properties
Global Properties_ID 
Global Properties_Align
Global Properties_Dock
Global Properties_X
Global Properties_Y 
Global Properties_Width 
Global Properties_Height
Global Properties_Caption
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
       WE_Menu_Code=7,
       WE_Menu_Settings=8


Global state_id=1, state_class, state_caption

;-
;- DECLARE
Declare WE_Events(Event)
Declare WE_Resize()
Declare WE_Panel_0_Size()
Declare WE_Panel_1_Size()
Declare inspector_get_pos(Gadget, Parent)
Declare inspector_add_pos(Gadget, Position=-1)
Declare WE_Open(ParentID=0, Flag.i=#PB_Window_SystemMenu)

Declare PC_Free(Object.i)

;-
;- MACRO
Macro ULCase(String)
   InsertString(UCase(Left(String,1)), LCase(Right(String,Len(String)-1)), 2)
EndMacro

Macro GetVarValue(StrToFind)
   ;GetArguments(*struct\Content\Text$, "(?:(\w+)\s*\(.*)?"+StrToFind+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2)
   GetArguments(*struct\Content\Text$, ~"(?:(\\w+)\\s*\\(.*)?"+StrToFind+~"(?:\\$)?(?:\\.\\w)?\\s*=\\s*(?:\")?([\\#\\w\\|\\s\\(\\)]+$|[\\#\\w\\|\\s\\(\\)]+)(?:\")?", 2)
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

;-
Macro is_object(_object_)
   Bool(IsGadget(_object_) | IsWindow(_object_))
EndMacro

Macro get_object_id(_class_)
   *struct\get(_class_)\Object
EndMacro

Macro get_object_class(_object_)
   *struct\get(Str(_object_))\Class$
EndMacro

Macro get_object_type(_object_)
   *struct\get(Str(_object_))\Type$
EndMacro

Macro get_object_adress(_object_)
   *struct\get(Str(_object_))\Adress
EndMacro

Macro get_object_parent(_object_)
   *struct\get(Str(_object_))\parent
EndMacro

Macro get_object_window(_object_)
   *struct\get(Str(_object_))\window
EndMacro

Macro get_object_count(_object_)
   *struct\get(Str(get_object_parent(_object_))+"_"+get_object_type(_object_))\Count
EndMacro

Macro get_argument_string(_string_)
   GetArguments(_string_, #RegEx_Pattern_Function, 2)
EndMacro

Macro change_current_object_from_class(_class_)
   Bool(*struct\get(_class_)\Adress And ChangeCurrentElement(ParsePBObject(), *struct\get(_class_)\Adress))
EndMacro

Macro change_current_object_from_id(_object_)
   change_current_object_from_class(Str(_object_))
EndMacro


; Macro is_container(Object)
;   *struct\get(Str(Object))\container)
; EndMacro

;-
;- STRUCTURE
Structure ContentStruct
   File$
   Text$    ; Содержимое файла 
   String$  ; Строка к примеру: "OpenWindow(#Window_0, x, y, width, height, "Window_0", #PB_Window_SystemMenu)"
   Position.i  ; Положение Content-a в исходном файле
   Length.i    ; длинна Content-a в исходном файле
   Open.i
   Close.i
EndStructure

Structure CodeStruct
   Glob.ContentStruct
   Enum.ContentStruct
   Func.ContentStruct
   Decl.ContentStruct
   Even.ContentStruct
   Bind.ContentStruct
   
EndStructure

Structure ObjectStruct
   Count.i
   Index.i
   Adress.i
   Position.i ; Code.CodeStruct
   Map Code.ContentStruct()
   
   Type.i  
   object.i ; Object$ = Window_0;Window_0_Button_0;Window_0_Text_0
   parent.i
   window.i
   
   type$    ; OpenWindow;ButtonGadget;TextGadget
   class$   ; Window_0;Button_0;Text_0
   object$
   parent$
   window$
EndStructure

Structure FONT
   Object.i
   Name$
   Height.i
   Style.i
EndStructure

Structure IMG
   Object.i
   Name$
EndStructure

Structure ParseStruct Extends ObjectStruct
   Item.i
   SubLevel.i ; 
   Container.i
   Content.ContentStruct  
   
   X.i 
   Y.i
   Width.i
   Height.i
   Param1.i
   Param2.i
   Param3.i
   Flag.i
   
   x$
   y$
   width$
   height$
   Caption$
   Param1$
   Param2$
   Param3$
   Param1Def$
   Param2Def$
   Param3Def$
   flag$
   
   Map Font.FONT()
   Map Img.IMG()
   ;Map Code.ContentStruct()
   
   Args$
EndStructure

Structure Struct Extends ParseStruct
   Map get.ObjectStruct()
EndStructure

Global NewList ParsePBObject.ParseStruct() 
Global *struct.Struct = AllocateStructure(Struct)
;
*struct\Index=-1
; *struct\Item=-1

Global Indent = 2, DragText.s
#Window$ = "W_"   
#Gadget$ = "G_"   

;-
;- ENUMERATION

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
Procedure WE_Code_Show(Text$)
   ; Scintilla::SetText(WE_Scintilla_0, Text$)
   Protected *Text=UTF8(Text$)
   ScintillaSendMessage(WE_Scintilla_0, #SCI_SETTEXT, 0, *Text)
   FreeMemory(*Text) ; The buffer made by UTF8() has to be freed, to avoid memory leak
   
EndProcedure


Procedure$ GetStr1(String$)
   Protected Result$, Object, Index, Value.f, Param1, Param2, Param3, Param1$
   Protected operand$, val$
   
   With *struct
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
                  Object = (*struct\get(RegularExpressionGroup(#RegEx_Captions1, 3))\Object)
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
                     ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((*struct\get(RegularExpressionGroup(#RegEx_Captions1, 3)))))
                     ;                     EndSelect
                     ;                   Wend
                     ;                 EndIf
                     
                  Case "FontID"         : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
                  Case "ImageID"        : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
                  Case "GadgetID"       : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
                  Case "WindowID"       : Result$+RegularExpressionGroup(#RegEx_Captions1, 3)
                  Case "Space"          : Result$+Space(Val(RegularExpressionGroup(#RegEx_Captions1, 3)))
                  Case "GetWindowTitle" : Result$+GetWindowTitle(Object)
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
                        Result$ + WindowHeight(Object, Param2)
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
   Protected Result$, Object, Index, Value.f, Param1, Param2, Param3, Param1$
   Protected operand$, val$
   
   With *struct
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
                  Object = (*struct\get(RegularExpressionGroup(#RegEx_Captions, 3))\Object)
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
                     ;                       Case "GetWindowTitle" : Result$+LCase(GetWindowTitle((*struct\get(RegularExpressionGroup(#RegEx_Captions1, 3)))))
                     ;                     EndSelect
                     ;                   Wend
                     ;                 EndIf
                     Result$+LCase(GetStr1(RegularExpressionGroup(#RegEx_Captions, 3)))
                     
                  Case "FontID"         : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
                  Case "ImageID"        : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
                  Case "GadgetID"       : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
                  Case "WindowID"       : Result$+RegularExpressionGroup(#RegEx_Captions, 3)
                  Case "Space"          : Result$+Space(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
                  Case "GetWindowTitle" : Result$+GetWindowTitle(Object)
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
                        Result$ + WindowHeight(Object, Param2)
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
   
   With *struct
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

;-
;- PARSER_CODE
Procedure PC_Add(*parse.ParseStruct, Index)
   Protected Result
   
   With *parse
      Select \Type$
         Case "HideWindow", "HideGadget", 
              "DisableWindow", "DisableGadget"
            Select Index
               Case 1 : \Object$ = \Args$
               Case 2 : \Param1$ = \Args$
            EndSelect
            
            Select \Param1$
               Case "#True" : \Object = #True
               Case "#False" : \Param1 = #False
               Default
                  \Param1 = Val(\Param1$)
            EndSelect
            
         Case "LoadFont"
            Select Index
               Case 1 : \Object$ = \Args$
               Case 2 : \Param1$ = \Args$
               Case 3 : \Param2$ = \Args$
               Case 4 : \Param3$ = \Args$
            EndSelect
            
         Case "LoadImage", 
              "SetGadgetFont", 
              "SetGadgetState",
              "SetGadgetText"
            Select Index
               Case 1 : \Object$ = \Args$
               Case 2 : \Param1$=GetStr(\Args$)
            EndSelect
            
         Case "ResizeGadget"
            Select Index
               Case 1 : \Object$ = \Args$
               Case 2 
                  If "#PB_Ignore"=\Args$ 
                     \x = #PB_Ignore
                  Else
                     \x = Val(\Args$)
                  EndIf
                  
               Case 3 
                  If "#PB_Ignore"=\Args$ 
                     \y = #PB_Ignore
                  Else
                     \y = Val(\Args$)
                  EndIf
                  
               Case 4 
                  If "#PB_Ignore"=\Args$ 
                     \width = #PB_Ignore
                  Else
                     \width = Val(\Args$)
                  EndIf
                  
               Case 5 
                  If "#PB_Ignore"=\Args$ 
                     \height = #PB_Ignore
                  Else
                     \height = Val(\Args$)
                  EndIf
                  
            EndSelect
            
         Case "SetGadgetColor"
            Select Index
               Case 1 : \Object$ = \Args$
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

Procedure PC_Set(*parse.ParseStruct)
   Protected Result, I, Object
   
   With *parse ; 
      Object = *struct\get(\Object$)\Object
      
      Select \Type$
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
            AddMapElement(\Font(), \Object$) 
            
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
            
            \Font()\Object=LoadFont(#PB_Any,\Font()\Name$,\Font()\Height,\Font()\Style)
            
         Case "LoadImage"
            AddMapElement(\Img(), \Object$) 
            \Img()\Name$=\Param1$
            \Img()\Object=LoadImage(#PB_Any, \Img()\Name$)
            
      EndSelect
      
      If IsWindow(Object)
         Select \Type$
            Case "SetActiveWindow"         : SetActiveWindow(Object)
            Case "HideWindow"              : HideWindow(Object, \Param1)
            Case "DisableWindow"           : DisableWindow(Object, \Param1)
         EndSelect
      EndIf
      
      If IsGadget(Object)
         Select \Type$
            Case "SetActiveGadget"         : SetActiveGadget(Object)
            Case "HideGadget"              : HideGadget(Object, \Param1)
            Case "DisableGadget"           : DisableGadget(Object, \Param1)
            Case "SetGadgetText"           : SetGadgetText(Object, \Param1$)
            Case "SetGadgetColor"          : SetGadgetColor(Object, \Param1, \Param2)
               
            Case "SetGadgetFont"
               Protected Font = \Font(\Param1$)\Object
               If IsFont(Font)
                  SetGadgetFont(Object, FontID(Font))
               EndIf
               
            Case "SetGadgetState"
               Protected Img = \Img(\Param1$)\Object
               If IsImage(Img)
                  SetGadgetState(Object, ImageID(Img))
               EndIf
               
            Case "ResizeGadget"
               ResizeGadget(Object, \x, \y, \width, \height)
               Transformation::Update(Object)
               
         EndSelect
      EndIf
   EndWith
   
EndProcedure



Procedure$ PC_Content(*parse.ParseStruct) ; Ok
   Protected ID$, Handle$, Result$
   
   With *parse
      If Asc(\Object$) = '#'
         ID$ = \Object$
      Else
         Select Asc(\Object$)
            Case '0' To '9'
               ID$ = Chr(Asc(\Object$))
            Default
               Handle$ = \Object$+" = "
               ID$ = "#PB_Any"
         EndSelect
      EndIf
      
      Select \Type$
            Case "OpenWindow", "WindowGadget" : Result$ = Handle$+"OpenWindow("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                            : If \flag$ : Result$ +", "+\flag$ : EndIf : If \Param1$ : Result$ +", "+\Param1$ : EndIf 
            Case "ButtonGadget"        : Result$ = Handle$+"ButtonGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                 : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "StringGadget"        : Result$ = Handle$+"StringGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                 : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "TextGadget"          : Result$ = Handle$+"TextGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                   : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "CheckBoxGadget"      : Result$ = Handle$+"CheckBoxGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                               : If \flag$ : Result$ +", "+\flag$ : EndIf
         Case "OptionGadget"        : Result$ = Handle$+"OptionGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)
            Case "ListViewGadget"      : Result$ = Handle$+"ListViewGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                        : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "FrameGadget"         : Result$ = Handle$+"FrameGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                                  : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ComboBoxGadget"      : Result$ = Handle$+"ComboBoxGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                        : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ImageGadget"         : Result$ = Handle$+"ImageGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$                                                                                                   : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "HyperLinkGadget"     : Result$ = Handle$+"HyperLinkGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)+", "+\Param1$                                                       : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ContainerGadget"     : Result$ = Handle$+"ContainerGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                       : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ListIconGadget"      : Result$ = Handle$+"ListIconGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)+", "+\Param1$                                                        : If \flag$ : Result$ +", "+\flag$ : EndIf
         Case "IPAddressGadget"     : Result$ = Handle$+"IPAddressGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$
            Case "ProgressBarGadget"   : Result$ = Handle$+"ProgressBarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                      : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ScrollBarGadget"     : Result$ = Handle$+"ScrollBarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$+", "+\Param3$                                                 : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ScrollAreaGadget"    : Result$ = Handle$+"ScrollAreaGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$    : If \Param3$ : Result$ +", "+\Param3$ : EndIf : If \flag$ : Result$ +", "+\flag$ : EndIf 
            Case "TrackBarGadget"      : Result$ = Handle$+"TrackBarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                         : If \flag$ : Result$ +", "+\flag$ : EndIf
         Case "WebGadget"           : Result$ = Handle$+"WebGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)
            Case "ButtonImageGadget"   : Result$ = Handle$+"ButtonImageGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$                                                                                             : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "CalendarGadget"      : Result$ = Handle$+"CalendarGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                     : If \Param1$ : Result$ +", "+\Param1$ : EndIf : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "DateGadget"          : Result$ = Handle$+"DateGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                : If \Param1$ : Result$ +", "+\Param1$ : EndIf : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "EditorGadget"        : Result$ = Handle$+"EditorGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                          : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ExplorerListGadget"  : Result$ = Handle$+"ExplorerListGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                           : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ExplorerTreeGadget"  : Result$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                           : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "ExplorerComboGadget" : Result$ = Handle$+"ExplorerComboGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ Chr(34)+\Caption$+Chr(34)                                                                          : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "SpinGadget"          : Result$ = Handle$+"SpinGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                             : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "TreeGadget"          : Result$ = Handle$+"TreeGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                            : If \flag$ : Result$ +", "+\flag$ : EndIf
         Case "PanelGadget"         : Result$ = Handle$+"PanelGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$ 
            Case "SplitterGadget"      : Result$ = Handle$+"SplitterGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                         : If \flag$ : Result$ +", "+\flag$ : EndIf
            Case "MDIGadget"           : Result$ = Handle$+"MDIGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$+", "+\Param2$                                                                              : If \flag$ : Result$ +", "+\flag$ : EndIf 
         Case "ScintillaGadget"     : Result$ = Handle$+"ScintillaGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$
         Case "ShortcutGadget"      : Result$ = Handle$+"ShortcutGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$+", "+ \Param1$
            Case "CanvasGadget"        : Result$ = Handle$+"CanvasGadget("+ID$+", "+\x$+", "+\y$+", "+\width$+", "+\height$                                                                                                                          : If \flag$ : Result$ +", "+\flag$ : EndIf
      EndSelect
      
      Result$+")" 
   EndWith
   
   ProcedureReturn Result$
EndProcedure

Procedure PC_Change(Indent.i, Replace$="")
   Protected RegExID, Identific$, delete_len
   ;   Debug "PC_Change "+Replace$
   ;   ProcedureReturn 
   ; Ищем функцию 
   With ParsePBObject()
      If Replace$
         ; Это значить заменяем строки
         Identific$ = \Content\String$
         delete_len = \Content\Length
         \Content\String$ = Replace$
         \Content\Length = Len( Replace$ )
         delete_len-\Content\Length
         
         Debug  ""+
                Identific$ + #CRLF$ +
                Replace$
         
      Else
         ;{ Remove string
         ; Это значить удаляем строки
         ; Для этого ищем идентификатор 
         ; (перечисление через два пробела) (переменые через длину "Global ") 
         If Asc(\Object$)='#'
            Identific$ = #CRLF$+Space(Len("  "))+\Object$
         Else
            Identific$ = ","+#CRLF$+Space(Len("Global "))+\Object$+"=-1"
         EndIf
         
         RegExID = CreateRegularExpression(#PB_Any, Identific$)
         delete_len = Len(Identific$)
         
         If RegExID
            *struct\get("Code")\Code("Code_Object")\Position - delete_len
            *struct\Content\Text$ = ReplaceRegularExpression(RegExID, *struct\Content\Text$, "")
            FreeRegularExpression(RegExID)
         EndIf
         
         ; Ищем строки функции
         Identific$ = #CRLF$+Space(Indent)+\Content\String$
         If \Container
            Identific$ = Identific$+#CRLF$+Space(Indent)+"CloseGadgetList()"
         EndIf
         delete_len = Len(Identific$)+delete_len
         ;}
      EndIf
      
      ;         Debug "-> "+Identific$
      ;         Debug " -> "+Replace$
      
      Identific$ = ReplaceString(Identific$, "(", "\(")
      Identific$ = ReplaceString(Identific$, ")", "\)")
      Identific$ = ReplaceString(Identific$, "|", "\|")
      RegExID = CreateRegularExpression(#PB_Any, Identific$)
      
      If RegExID
         ; Изменяем последнюю позицию добавления строки
         PushListPosition(ParsePBObject())
         ForEach ParsePBObject()
            If ParsePBObject()\Container 
               *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position - delete_len
            EndIf
         Next
         PopListPosition(ParsePBObject())
         
         *struct\Content\Text$ = ReplaceRegularExpression(RegExID, *struct\Content\Text$, Replace$)
         FreeRegularExpression(RegExID)
      EndIf
   EndWith
   
EndProcedure

Procedure PC_Destroy()
   With ParsePBObject()
      PC_Change(Indent)
      
      ;
      ;     *struct\get(Str(\parent)+"_"+\Type$)\Count-1 
      ;     If *struct\get(Str(\parent)+"_"+\Type$)\Count =< 0
      ;       DeleteMapElement(*struct\get(), Str(\parent)+"_"+\Type$)
      ;     EndIf
      
      DeleteMapElement(*struct\get(), \Object$)
      DeleteMapElement(*struct\get(), Str(\Object))
      DeleteElement(ParsePBObject())
      
   EndWith
EndProcedure

Procedure PC_Free(Object.i)
   
   If ListSize(ParsePBObject())
      With ParsePBObject()
         ; Если есть дети, работаем над детми
         If ChangeCurrentElement(ParsePBObject(), *struct\get(Str(Object))\Adress)
            If \Container
               ForEach ParsePBObject()
                  If \parent = Object 
                     If \Container
                        PC_Free(\Object)
                        
                     Else
                        PC_Destroy()
                        
                     EndIf
                  EndIf
               Next
            EndIf
         EndIf
         
         ; Удаляем строки объекта из кода 
         If ChangeCurrentElement(ParsePBObject(), *struct\get(Str(Object))\Adress)
            PC_Destroy()
         EndIf
      EndWith  
   EndIf
   
EndProcedure

Macro PC_Update(_object_=-1)
   PushListPosition(ParsePBObject())
   ForEach ParsePBObject() 
      PC_Change(Indent, PC_Content(ParsePBObject())) 
   Next
   PopListPosition(ParsePBObject())
   
   WE_Code_Show(*struct\Content\Text$)
EndMacro

;-
;- CREATE_OBJECT
Declare CO_Create(Type$, X, Y, Parent=-1)
Declare CO_Open()

Procedure.q CO_Flag(Arg$)
   Protected Flag$, I, String$
   
   For I = 0 To CountString(Arg$,"|")
      String$ = Trim(StringField(Arg$,(I+1),"|"))
      
      Select Asc(String$)
         Case '#', '0' To '9'
            Flag$+String$+"|"
         Default
            String$ = GetArguments(*struct\Content\Text$, "(?:(\w+)\s*\(.*)?"+String$+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2)
            
            Flag$+String$+"|"
      EndSelect
   Next
   
   ProcedureReturn Flag::Value(Trim(Flag$, "|"))
EndProcedure

Procedure CO_Init(Object.i)
   PushListPosition(ParsePBObject())
   Protected *Adress = *struct\get(Str(Object))\Adress
   If *Adress And ChangeCurrentElement(ParsePBObject(), *Adress)
      With ParsePBObject()
         Transformation::Create(wgParent(Object), \parent, \window, \Item, 5)
         If IsGadget(Object) And GadgetType(Object) = #PB_GadgetType_Splitter
            Transformation::Free(GetGadgetAttribute(Object, #PB_Splitter_FirstGadget))
            Transformation::Free(GetGadgetAttribute(Object, #PB_Splitter_SecondGadget))
         EndIf
         Properties::Change(WE_Properties, Object, \Object$, \flag$)
      EndWith
   EndIf
   PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Change(Object.i)
   PushListPosition(ParsePBObject())
   
   Protected *Adress = *struct\get(Str(Object))\Adress
   If *Adress And ChangeCurrentElement(ParsePBObject(), *Adress)
      With ParsePBObject()
         Properties::Change(WE_Properties, Object, \Object$, \flag$)
         If EventGadget()=WE_Selecting
            Transformation::Change(wgParent(Object))
         EndIf
      EndWith
   EndIf
   PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Free(Object.i)
   Protected i
   ;ProcedureReturn 
   
   ; Удаляем итем инспектора
   For i=0 To CountGadgetItems(WE_Selecting)-1
      If Object=GetGadgetItemData(WE_Selecting, i) 
         RemoveGadgetItem(WE_Selecting, i)
         Break
      EndIf
   Next 
   
   ; 
   PC_Free(Object)
   
   ; Удаляем якорья
   Transformation::Free(Object)
   
   ; Удаляем и объект
   If IsGadget(Object)
      FreeGadget(Object)
   ElseIf IsWindow(Object)
      CloseWindow(Object)
   EndIf
   
   WE_Code_Show(*struct\Content\Text$)
   
EndProcedure

Procedure CO_Update(Object, Gadget)
   
   PushListPosition(ParsePBObject())
   If ListSize(ParsePBObject()) And ChangeCurrentElement(ParsePBObject(), *struct\get(Str(Object))\Adress)
      With ParsePBObject()
         Select Gadget
            Case Properties_ID
               
            Case Properties_X,
                 Properties_Y,
                 Properties_Width,
                 Properties_Height
               Transformation::Change(Object)
         EndSelect        
         
         Select Gadget
            Case Properties_Caption 
               \Caption$ = GetGadgetText(Gadget)
            Case Properties_X       
               \x$ = GetGadgetText(Gadget)
            Case Properties_Y       
               \y$ = GetGadgetText(Gadget)
            Case Properties_Width   
               \width$ = GetGadgetText(Gadget)
            Case Properties_Height  
               \height$ = GetGadgetText(Gadget)
            Case Properties_Flag    
               \flag$ = GetGadgetText(Gadget)
         EndSelect
      EndWith
      
      PC_Update()
   EndIf
   PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Events()
   Protected I.i, Parent=-1, Object =- 1
   
   If IsGadget(EventGadget())
      Object = EventGadget()
   ElseIf IsWindow(EventWindow())
      Object = EventWindow()
   EndIf
   
   Select Event()
      Case #PB_Event_Gadget
         
         Select EventType()
            Case #PB_EventType_Create
               
               CO_Init(Object)
               
            Case #PB_EventType_CloseItem
               
               CO_Free(Object)
               
            Case #PB_EventType_Move, #PB_EventType_Size
               ;           Debug GadgetWidth(EventGadget())
               ;           Debug GadgetHeight(EventGadget())
               
            Case #PB_EventType_StatusChange
               ; При выборе форм гаджета 
               Object = wg(Object)
               
               ; При выборе гаджета обнавляем испектор
               For I=0 To CountGadgetItems(WE_Selecting)-1
                  If Object = GetGadgetItemData(WE_Selecting, I) 
                     SetGadgetState(WE_Selecting, I)
                     CO_Change(Object)
                     Break
                  EndIf
               Next  
               
               PC_Update()
               
               ; ;           
               ; ;           Debug GetGadgetText(Properties_Width)
               
               ;           PushListPosition(ParsePBObject())
               ;           ForEach ParsePBObject()
               ;             PC_Change(Indent, PC_Content(ParsePBObject()))
               ;           Next
               ;           PopListPosition(ParsePBObject())
         EndSelect
         
      Case #PB_Event_LeftClick
         CO_Create(ReplaceString(DragText, "gadget", ""),
                   WindowMouseX(EventWindow()), WindowMouseY(EventWindow()), Object)
         
      Case #PB_Event_WindowDrop, #PB_Event_GadgetDrop
         DragText = EventDropText()
         
         ; create new gadget
         If DragText
            If DragText = "Splitter"
               W_SH_Object = Object
               W_SH_Parent = EventWindow()
               W_SH_MouseX = WindowMouseX(W_SH_Parent)
               W_SH_MouseY = WindowMouseY(W_SH_Parent)
               
               DisableWindow(WE, #True)
               DisableWindow(W_SH_Parent, #True)
               W_SH_Open(WindowID(W_SH_Parent), #PB_Window_TitleBar|#PB_Window_WindowCentered)
               
               Protected Dim GadgetList.s(0)
               PushListPosition(ParsePBObject())
               ForEach ParsePBObject()
                  If ParsePBObject()\Container>=0
                     ReDim GadgetList(ListIndex(ParsePBObject())) 
                     GadgetList(ListIndex(ParsePBObject())) = ParsePBObject()\Object$
                  EndIf
               Next
               PopListPosition(ParsePBObject())
               W_SH_Load(GadgetList())
               
            Else
               CO_Create(ReplaceString(DragText, "gadget", ""),
                         WindowMouseX(EventWindow()), WindowMouseY(EventWindow()), Object)
            EndIf
            
            DragText = ""
         EndIf
   EndSelect
   
EndProcedure

Procedure CO_Insert(Parent)
   Protected ID$, Handle$
   CodeShow = 1
   
   With ParsePBObject()
      ; 
      Protected Variable$, VariableLength, pos
      
      If ListSize(ParsePBObject()) = 1
         *struct\get("Code")\Code("Code_Object")\Position = 16
      EndIf
      
      If Asc(\Object$)='#'
         If \Type$ = "OpenWindow"
            If ListSize(ParsePBObject()) = 1
               Variable$ = #CRLF$+"Enumeration Window"+#CRLF$+"EndEnumeration"
            EndIf
         Else
            If ListSize(ParsePBObject()) = 2
               Variable$ = #CRLF$+#CRLF$+"Enumeration Gadget"+#CRLF$+"EndEnumeration"
            EndIf
         EndIf
         
         If Variable$
            VariableLength = Len(Variable$)
            *struct\Content\Text$ = InsertString(*struct\Content\Text$, Variable$, 
                                                 *struct\get("Code")\Code("Code_Object")\Position) 
            *struct\get("Code")\Code("Code_Object")\Position + VariableLength
            
            If VariableLength
               PushListPosition(ParsePBObject())
               ForEach ParsePBObject()
                  If ParsePBObject()\Container 
                     *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position + VariableLength
                  EndIf
               Next
               PopListPosition(ParsePBObject())
            EndIf
         EndIf
         
         Variable$ = #CRLF$+Space(2)+\Object$
      Else
         If \Type$ = "OpenWindow"
            If ListSize(ParsePBObject()) = 1
               Variable$ = #CRLF$+"Global "+\Object$+"=-1"
            Else
               Variable$ = #CRLF$+#CRLF$+"Global "+\Object$+"=-1"
            EndIf
         Else
            Variable$ = ","+#CRLF$+Space(Len("Global "))+\Object$+"=-1"
         EndIf
      EndIf
      
      VariableLength = Len(Variable$)
      
      Debug "  Code_Object" + *struct\get("Code")\Code("Code_Object")\Position
      If Asc(\Object$)='#'
         *struct\Content\Text$ = InsertString(*struct\Content\Text$, Variable$, 
                                              *struct\get("Code")\Code("Code_Object")\Position - Len(#CRLF$+"EndEnumeration")) 
      Else
         *struct\Content\Text$ = InsertString(*struct\Content\Text$, Variable$, 
                                              *struct\get("Code")\Code("Code_Object")\Position) 
      EndIf
      
      *struct\get("Code")\Code("Code_Object")\Position + VariableLength
      
      If ListSize(ParsePBObject()) = 1
         If Asc(\Object$)='#'
            *struct\get(*struct\get(Str(Parent))\Object$)\Code("Code_Function")\Position = 297+*struct\get("Code")\Code("Code_Object")\Position
         Else
            *struct\get(*struct\get(Str(Parent))\Object$)\Code("Code_Function")\Position = 290+*struct\get("Code")\Code("Code_Object")\Position
         EndIf
      EndIf
      
      
      Debug "  Code_Function" + *struct\get(*struct\get(Str(Parent))\Object$)\Code("Code_Function")\Position
      \Content\Position = *struct\get(*struct\get(Str(Parent))\Object$)\Code("Code_Function")\Position  + VariableLength
      
      If VariableLength
         PushListPosition(ParsePBObject())
         ForEach ParsePBObject()
            If ParsePBObject()\Container 
               *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position + VariableLength
            EndIf
         Next
         PopListPosition(ParsePBObject())
      EndIf
      
      \Content\String$ = PC_Content(ParsePBObject())
      \Content\Length = Len(\Content\String$)
      
      *struct\Content\Length = \Content\Length
      *struct\Content\Position = \Content\Position
      *struct\Content\Text$ = InsertString(*struct\Content\Text$, \Content\String$+#CRLF$+Space(Indent), \Content\Position) 
      
      
      ; У окна меняем последную позицию.
      *struct\get(*struct\window$)\Code("Code_Function")\Position + (*struct\Content\Length + Len(#CRLF$+Space(Indent)))
      
      ; Сохряняем у объект-а последную позицию.
      *struct\get(*struct\Object$)\Code("Code_Function")\Position = *struct\Content\Position+*struct\Content\Length+Len(#CRLF$+Space(Indent))
      
      ; 
      If *struct\Container
         Select *struct\Type$
            Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
               ; 
               *struct\Content\Text$ = InsertString(*struct\Content\Text$, "CloseGadgetList()"+#CRLF$+Space(Indent), *struct\Content\Position+*struct\Content\Length+Len(#CRLF$+Space(Indent))) 
               *struct\Content\Position+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
               
               ; У окна меняем последную позицию.
               *struct\get(*struct\window$)\Code("Code_Function")\Position + Len("CloseGadgetList()"+#CRLF$+Space(Indent))
         EndSelect
         
      Else
         If IsGadget(Parent)
            PushListPosition(ParsePBObject())
            ForEach ParsePBObject()
               Select ParsePBObject()\Container
                  Case #PB_GadgetType_Panel, #PB_GadgetType_Container, #PB_GadgetType_ScrollArea, #PB_GadgetType_Canvas
                     ; Проверяем позицию родителя в генерируемом коде
                     If *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position>*struct\Content\Position
                        ; У родителя меняем последную позицию.
                        *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position + (*struct\Content\Length + Len(#CRLF$+Space(Indent)))
                     EndIf
               EndSelect
            Next
            PopListPosition(ParsePBObject())
         EndIf
         
      EndIf
      
      ; Записываем у родителя позицию конца добавления объекта
      *struct\get(*struct\get(Str(Parent))\Object$)\Code("Code_Function")\Position = *struct\Content\Position+*struct\Content\Length+Len(#CRLF$+Space(Indent))
   EndWith
EndProcedure

Procedure CO_Create(Type$, X, Y, Parent=-1)
   Protected GadgetList
   Protected Object, Position
   Protected *Parse.ParseStruct
   Protected Buffer.s, BuffType$, i.i, j.i
   
   Protected Constant.s
   If state_id=0 Or GetGadgetText(Properties_ID)="#"
      Constant = "#"
   Else
      Constant = ""
   EndIf
   
   
   With *struct
      ; Определяем позицию и родителя для создания объекта
      If IsGadget(Parent) And GadgetType(Parent) <> #PB_GadgetType_MDI 
         X - GadgetX(Parent, #PB_Gadget_WindowCoordinate)
         Y - GadgetY(Parent, #PB_Gadget_WindowCoordinate)
         GadgetList = OpenGadgetList(Parent, GetGadgetState(Parent)) 
      ElseIf IsWindow(Parent)
         GadgetList = UseGadgetList(WindowID(Parent))
      Else ; Создали новое окно
         X=0
         Y=0
         \parent =- 1
      EndIf
      
      Select Type$
         Case "Window" : \Type$ = "OpenWindow"
         Case "Menu", "ToolBar" : \Type$ = "Create"+Type$
         Default 
            \Type$=Type$ + "Gadget"
      EndSelect
      
      *Parse = AddElement(ParsePBObject())
      If *Parse
         Restore Model 
         For i=1 To 1+33 ; gadget count
            For j=1 To 7 ; argument count
               Read.s Buffer
               
               Select j
                  Case 1  
                     If \Type$=Buffer
                        BuffType$ = Buffer
                     EndIf
               EndSelect
               
               If BuffType$ = \Type$
                  Select j
                     Case 1 
                        ParsePBObject()\Type$=Buffer
                        
                        If Buffer = "OpenWindow"
                           \Class$=Constant+ReplaceString(Buffer, "Open","")+"_"
                        ElseIf Buffer = "WindowGadget"
                           \Class$=Constant+ReplaceString(Buffer, "Gadget","")+"_"
                        Else
                           \Class$=ReplaceString(Buffer, "Gadget","")+"_"
                        EndIf
                        
                     Case 2 : ParsePBObject()\width$=Buffer
                     Case 3 : ParsePBObject()\height$=Buffer
                     Case 4 : ParsePBObject()\Param1$=Buffer
                     Case 5 : ParsePBObject()\Param2$=Buffer
                     Case 6 : ParsePBObject()\Param3$=Buffer
                     Case 7 : ParsePBObject()\flag$=Buffer
                  EndSelect
               EndIf
            Next  
            BuffType$ = ""
         Next  
         
         If \flag$
            ParsePBObject()\flag$ = \flag$
         EndIf
         
         \flag=CO_Flag(ParsePBObject()\flag$)
         If state_class
            \Class$+\get(Str(Parent)+"_"+\Type$)\Count
         Else
            \Class$+\get(\Type$)\Count
         EndIf
         \Caption$ = \Class$
         
         ; Формируем имя объекта
         ParsePBObject()\Class$ = \Class$
         If \get(Str(Parent))\Object$
            If state_class
               \Object$ = \get(Str(Parent))\Object$+"_"+\Class$
            Else
               \Object$ = \Class$
            EndIf
         Else
            \Object$ = \Class$
            ParsePBObject()\flag$="Flag"
            \Param1$="ParentID"
         EndIf
         
         \x = X
         \y = Y
         \width = Val(ParsePBObject()\width$)
         \height = Val(ParsePBObject()\height$)
         
         ParsePBObject()\x$ = Str(\x)
         ParsePBObject()\y$ = Str(\y)
         ParsePBObject()\Type$ = \Type$
         ParsePBObject()\Object$ = \Object$
         ParsePBObject()\Caption$ = \Caption$
         
         If \Type$ = "SplitterGadget"      
            \Param1 = \get(\Param1$)\Object
            \Param2 = \get(\Param2$)\Object
         EndIf
         
         ParsePBObject()\Param1$ = \Param1$
         ParsePBObject()\Param2$ = \Param2$
         ParsePBObject()\Param3$ = \Param3$
         ParsePBObject()\Param1 = \Param1
         ParsePBObject()\Param2 = \Param2
         ParsePBObject()\Param3 = \Param3
         
         ; Загружаем выходной код
         If \Content\Text$=""
            Restore Content
            Read.s Buffer
            \Content\Text$ = Buffer
            ;         \get("Code")\Code("Code_Object")\Position = 16
            ;         \get(\get(Str(Parent))\Object$)\Code("Code_Function")\Position = 249+75+2
         EndIf
         
         \parent = Parent
      EndIf
      
      Position = inspector_get_pos(WE_Selecting, Parent)
      
      Object=CallFunctionFast(@CO_Open())
      
      CO_Insert(Parent) 
      
      If IsGadget(Object)
         ;       Select \type
         ;         Case #PB_GadgetType_Panel
         ;           ;OpenGadgetList(Object, 0)
         ;           AddGadgetItem(Object, -1, \Object$)
         ;       EndSelect
         
         Select GadgetType(Object)
            Case #PB_GadgetType_Panel, 
                 #PB_GadgetType_Container, 
                 #PB_GadgetType_ScrollArea
               CloseGadgetList()
         EndSelect
      EndIf
      
      inspector_add_pos(WE_Selecting, Position)
      
      
      If GadgetList 
         If IsGadget(Parent)
            CloseGadgetList() 
         ElseIf IsWindow(Parent)
            UseGadgetList(GadgetList)
         EndIf
      EndIf
      
      ;     Debug "-------------create----------------"
      ;     Debug \Content\Text$
      WE_Code_Show(\Content\Text$)
      
   EndWith
   
   DataSection
      Model:
      ;{
      Data.s "OpenWindow","300","200","ParentID","0","0", "#PB_Window_SystemMenu"
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
             "Declare Window_0_Events(Event.i)"+#CRLF$+
             ""+#CRLF$+
             "Procedure Window_0_CallBack()"+#CRLF$+
             "  Window_0_Events(Event())"+#CRLF$+
             "EndProcedure"+#CRLF$+
             ""+#CRLF$+
             "Procedure Window_0_Open(ParentID.i=0, Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)"+#CRLF$+
             "  If IsWindow(Window_0)"+#CRLF$+
             "    SetActiveWindow(Window_0)"+#CRLF$+    
             "    ProcedureReturn Window_0"+#CRLF$+    
             "  EndIf"+#CRLF$+
             "  "+#CRLF$+  
             "  "+#CRLF$+  
             "  ProcedureReturn Window_0"+#CRLF$+
             "EndProcedure"+#CRLF$+
             ""+#CRLF$+
             "Procedure Window_0_Events(Event.i)"+#CRLF$+
             "  Select Event"+#CRLF$+
             "    Case #PB_Event_Gadget"+#CRLF$+
             "      Select EventType()"+#CRLF$+
             "        Case #PB_EventType_LeftClick"+#CRLF$+
             "          Select EventGadget()"+#CRLF$+
             "             "+#CRLF$+            
             "          EndSelect"+#CRLF$+
             "      EndSelect"+#CRLF$+
             "  EndSelect"+#CRLF$+
             "  "+#CRLF$+
             "  ProcedureReturn Event"+#CRLF$+
             "EndProcedure"+#CRLF$+
             ""+#CRLF$+
             "CompilerIf #PB_Compiler_IsMainFile"+#CRLF$+
             "  Window_0_Open()"+#CRLF$+
             "  "+#CRLF$+  
             "  While IsWindow(Window_0)"+#CRLF$+
             "    Define.i Event = WaitWindowEvent()"+#CRLF$+
             "    "+#CRLF$+
             "    Select EventWindow()"+#CRLF$+
             "      Case Window_0"+#CRLF$+
             "        If Window_0_Events( Event ) = #PB_Event_CloseWindow"+#CRLF$+
             "          CloseWindow(Window_0)"+#CRLF$+
             "          Break"+#CRLF$+
             "        EndIf"+#CRLF$+
             "        "+#CRLF$+
             "    EndSelect"+#CRLF$+
             "  Wend"+#CRLF$+
             "CompilerEndIf"
      ;}
      
   EndDataSection
   
   ProcedureReturn Object
EndProcedure

Procedure CO_Open() ; Ok
                    ; ProcedureReturn 
   
   Protected GetParent, OpenGadgetList, Object=-1
   Static AddGadget
   
   With *struct
      ;
      Select \Type$
         Case "OpenWindow" : \type =- 1  : \window =- 1  
            If IsGadget(WE_ScrollArea_0)
               Select GadgetType(WE_ScrollArea_0)
                  Case #PB_GadgetType_ScrollArea
                     \Type$ = "WindowGadget"
                     \x = 20
                     \y = 20+25
                     \parent = WE_ScrollArea_0
                     OpenGadgetList(WE_ScrollArea_0)
                     
                     \Object = WindowGadget(#PB_Any, \x,\y,\width,\height, \Caption$, \flag);, \Param1)
                     \flag | #PB_Canvas_Container
                  Case #PB_GadgetType_MDI ; , \flag, \Param1)
                     \x = 20
                     \y = 20
                     \Object = AddGadgetItem(WE_ScrollArea_0, #PB_Any, \Caption$, 0, \flag) : ResizeWindow(\Object, \x,\y,\width,\height)
                     
               EndSelect
            Else
               \Param1 = UseGadgetList(0)
               \Object = OpenWindow          (#PB_Any, \x,\y,\width,\height, \Caption$, \flag, \Param1)
               StickyWindow(\Object, 1)
            EndIf
         Case "ButtonGadget"         : \type = #PB_GadgetType_Button        : \Object = ButtonGadget        (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "StringGadget"        : \type = #PB_GadgetType_String        : \Object = StringGadget        (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "TextGadget"          : \type = #PB_GadgetType_Text          : \Object = TextGadget          (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "CheckBoxGadget"      : \type = #PB_GadgetType_CheckBox      : \Object = CheckBoxGadget      (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "OptionGadget"        : \type = #PB_GadgetType_Option        : \Object = OptionGadget        (#PB_Any, \x,\y,\width,\height, \Caption$)
         Case "FrameGadget"         : \type = #PB_GadgetType_Frame         : \Object = FrameGadget         (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "ListViewGadget"      : \type = #PB_GadgetType_ListView      : \Object = ListViewGadget      (#PB_Any, \x,\y,\width,\height, \flag)
         Case "ComboBoxGadget"      : \type = #PB_GadgetType_ComboBox      : \Object = ComboBoxGadget      (#PB_Any, \x,\y,\width,\height, \flag)
         Case "ImageGadget"         : \type = #PB_GadgetType_Image         : \Object = ImageGadget         (#PB_Any, \x,\y,\width,\height, \Param1, \flag)
         Case "HyperLinkGadget"     : \type = #PB_GadgetType_HyperLink     : \Object = HyperLinkGadget     (#PB_Any, \x,\y,\width,\height, \Caption$, \Param1, \flag)
         Case "ContainerGadget"     : \type = #PB_GadgetType_Container     : \Object = ContainerGadget     (#PB_Any, \x,\y,\width,\height, \flag)
         Case "ListIconGadget"      : \type = #PB_GadgetType_ListIcon      : \Object = ListIconGadget      (#PB_Any, \x,\y,\width,\height, \Caption$, \Param1, \flag)
         Case "IPAddressGadget"     : \type = #PB_GadgetType_IPAddress     : \Object = IPAddressGadget     (#PB_Any, \x,\y,\width,\height)
         Case "ProgressBarGadget"   : \type = #PB_GadgetType_ProgressBar   : \Object = ProgressBarGadget   (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
         Case "ScrollBarGadget"     : \type = #PB_GadgetType_ScrollBar     : \Object = ScrollBarGadget     (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \Param3, \flag)
         Case "ScrollAreaGadget"    : \type = #PB_GadgetType_ScrollArea    : \Object = ScrollAreaGadget    (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \Param3, \flag) 
         Case "TrackBarGadget"      : \type = #PB_GadgetType_TrackBar      : \Object = TrackBarGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
            ;       Case "WebGadget"           : \type = #PB_GadgetType_Web           : \Object = WebGadget           (#PB_Any, \x,\y,\width,\height, \Caption$)
         Case "ButtonImageGadget"   : \type = #PB_GadgetType_ButtonImage   : \Object = ButtonImageGadget   (#PB_Any, \x,\y,\width,\height, \Param1, \flag)
         Case "CalendarGadget"      : \type = #PB_GadgetType_Calendar      : \Object = CalendarGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \flag)
         Case "DateGadget"          : \type = #PB_GadgetType_Date          : \Object = DateGadget          (#PB_Any, \x,\y,\width,\height, \Caption$, \Param1, \flag)
         Case "EditorGadget"        : \type = #PB_GadgetType_Editor        : \Object = EditorGadget        (#PB_Any, \x,\y,\width,\height, \flag)
         Case "ExplorerListGadget"  : \type = #PB_GadgetType_ExplorerList  : \Object = ExplorerListGadget  (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "ExplorerTreeGadget"  : \type = #PB_GadgetType_ExplorerTree  : \Object = ExplorerTreeGadget  (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "ExplorerComboGadget" : \type = #PB_GadgetType_ExplorerCombo : \Object = ExplorerComboGadget (#PB_Any, \x,\y,\width,\height, \Caption$, \flag)
         Case "SpinGadget"          : \type = #PB_GadgetType_Spin          : \Object = SpinGadget          (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
         Case "TreeGadget"          : \type = #PB_GadgetType_Tree          : \Object = TreeGadget          (#PB_Any, \x,\y,\width,\height, \flag)
         Case "PanelGadget"         : \type = #PB_GadgetType_Panel         : \Object = PanelGadget         (#PB_Any, \x,\y,\width,\height) 
         Case "SplitterGadget"      
            Debug "Splitter FirstGadget "+\Param1
            Debug "Splitter SecondGadget "+\Param2
            If IsGadget(\Param1) And IsGadget(\Param2)
               \type = #PB_GadgetType_Splitter                               
               \Object = SplitterGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
            Else
               \type = #PB_GadgetType_Splitter     
               \Param1 = TextGadget(#PB_Any, 0,0,0,0, "Splitter")
               \Param2 = TextGadget(#PB_Any, 0,0,0,0, "")
               \Object = SplitterGadget      (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag)
               
            EndIf
         Case "MDIGadget"          
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
               \type = #PB_GadgetType_MDI                                    : \Object = MDIGadget           (#PB_Any, \x,\y,\width,\height, \Param1, \Param2, \flag) 
            CompilerEndIf
         Case "ScintillaGadget"     : \type = #PB_GadgetType_Scintilla     : \Object = ScintillaGadget     (#PB_Any, \x,\y,\width,\height, \Param1)
         Case "ShortcutGadget"      : \type = #PB_GadgetType_Shortcut      : \Object = ShortcutGadget      (#PB_Any, \x,\y,\width,\height, \Param1)
         Case "CanvasGadget"        : \type = #PB_GadgetType_Canvas        : \Object = CanvasGadget        (#PB_Any, \x,\y,\width,\height, \flag)
      EndSelect
      
      ; Заносим данные объекта в памят
      If Bool(IsGadget(\Object) | IsWindow(\Object))
         If \Object$=""
            \Object$=Str(\Object)
            ParsePBObject()\Object$=\Object$
         EndIf
         
         ParsePBObject()\type = \type
         ParsePBObject()\Object = \Object
         
         If ParsePBObject()\parent<>\parent
            If \get(Str(\parent))\Object$
               \parent$ = \get(Str(\parent))\Object$
            EndIf
            ParsePBObject()\parent=\parent
            ParsePBObject()\parent$=\parent$
         EndIf
         If ParsePBObject()\window<>\window
            If \get(Str(\window))\Object$
               \window$ = \get(Str(\window))\Object$
            EndIf
            ParsePBObject()\window=\window
            ParsePBObject()\window$=\window$
         EndIf
         
         ; TODO -----------------------------------------
         If IsWindow(\Object)
            \parent =- 1
         EndIf
         
         Macro Init_object_data(_object_, _object_key_)
            If FindMapElement(*struct\get(), _object_key_)
               *struct\get(_object_key_)\Index=ListIndex(ParsePBObject())
               *struct\get(_object_key_)\Adress=@ParsePBObject()
               
               *struct\get(_object_key_)\Object=_object_ 
               *struct\get(_object_key_)\Object$=*struct\Object$ 
               
               *struct\get(_object_key_)\type=*struct\type 
               *struct\get(_object_key_)\Type$=*struct\Type$ 
               
               *struct\get(_object_key_)\window=*struct\window 
               *struct\get(_object_key_)\parent=*struct\parent 
               
               *struct\get(_object_key_)\window$=*struct\window$ 
               *struct\get(_object_key_)\parent$=*struct\parent$ 
            Else
               AddMapElement(*struct\get(), _object_key_)
               *struct\get()\Index=ListIndex(ParsePBObject())
               *struct\get()\Adress=@ParsePBObject()
               
               *struct\get()\Object=_object_ 
               *struct\get()\Object$=*struct\Object$ 
               
               *struct\get()\type=*struct\type 
               *struct\get()\Type$=*struct\Type$ 
               
               *struct\get()\window=*struct\window 
               *struct\get()\parent=*struct\parent 
               
               *struct\get()\window$=*struct\window$ 
               *struct\get()\parent$=*struct\parent$ 
            EndIf
            
         EndMacro
         
         ; Количество однотипных объектов
         If Not FindMapElement(\get(), \Type$)
            AddMapElement(\get(), \Type$)
            \get()\Index=ListIndex(ParsePBObject())
            \get()\Adress=@ParsePBObject()
            \get()\Count+1 
         Else
            \get(\Type$)\Count+1 
         EndIf
         
         ; Количество однотипных объектов
         If Not FindMapElement(\get(), Str(\parent)+"_"+\Type$)
            AddMapElement(\get(), Str(\parent)+"_"+\Type$)
            \get()\Index=ListIndex(ParsePBObject())
            \get()\Adress=@ParsePBObject()
            \get()\Count+1 
         Else
            \get(Str(\parent)+"_"+\Type$)\Count+1 
         EndIf
         
         ; Чтобы по идентификатору 
         ; объекта получить все остальное
         Init_object_data(\Object, Str(\Object))
         
         ; Чтобы по классу
         ; объекта получить все остальное
         Init_object_data(\Object, \Object$)
         
      EndIf
      
      ; 
      Select \Type$
         Case "WindowGadget" : \window = EventWindow() : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel = 1
         Case "OpenWindow" : \window = \Object : \window$ = \Object$ : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel = 1
         Case "ContainerGadget", "ScrollAreaGadget" : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel + 1
         Case "PanelGadget" : \parent$ = \Object$ : \parent = \Object : \Container = \type : \SubLevel + 1 
            If IsGadget(\parent) 
               \Item = GetGadgetData(\parent) 
            EndIf
            
         Case "CanvasGadget"
            If ((\flag & #PB_Canvas_Container)=#PB_Canvas_Container)
               \parent = \Object : \SubLevel + 1
               \Container = \type
            EndIf
            
         Case "UseGadgetList" 
            Debug "UseGadgetList( " + \Param1$ +" )"
            Debug "  "+*struct\get(Str(\Param1))\Object$
            If IsWindow(\Param1) 
               \SubLevel = 1
               \window = \Param1
               \parent = \window
               Debug "    " + GetWindowTitle(\parent)
               UseGadgetList( WindowID(\parent) )
            ElseIf IsGadget(\Param1) 
               Debug "    " + wgTitle(\Param1)
               \parent = \Param1
               OpenGadgetList(\parent)
            EndIf
            
         Case "CloseGadgetList" 
            If IsGadget(\parent) : \SubLevel - 1 : CloseGadgetList() 
               \parent = *struct\get(Str(\parent))\parent 
               If IsGadget(\parent) : \Item = GetGadgetData(\parent) : EndIf
            EndIf
            
         Case "OpenGadgetList"      
            \parent = \get(\Object$)\Object
            If IsGadget(\parent) : OpenGadgetList(\parent, \Param1) : EndIf
            
         Case "AddGadgetColumn"       
            Object=\get(\Object$)\Object
            If IsGadget(Object)
               AddGadgetColumn(Object, \Param1, \Caption$, \Param2)
            Else
               Debug " add column no_gadget "+\Object$
            EndIf
            
         Case "AddGadgetItem"   
            Object=\get(\Object$)\Object
            If IsGadget(Object) : \Item+1 : SetGadgetData(Object, \Item)
               AddGadgetItem(Object, \Param1, \Caption$, \Param2, \flag)
            Else
               Debug " add item no_gadget "+\Object$
            EndIf
            
         Default
            \Container = #PB_GadgetType_Unknown
            
      EndSelect
      
      ;
      If IsGadget(\parent)
         GetParent = \get(Str(\parent))\parent
      ElseIf IsWindow(\parent)
         \SubLevel = 1
      EndIf
      
      ;
      If \Object And IsGadget(\Object)
         ; Если объект контейнер, то есть (Panel;ScrollArea;Container;Canvas)
         If \Container
            ParsePBObject()\Container = \Container
            ParsePBObject()\SubLevel = \SubLevel - 1
            EnableGadgetDrop(\Object, #PB_Drop_Text, #PB_Drag_Copy)
            BindEvent(#PB_Event_GadgetDrop, @CO_Events(), \window, \Object)
            
            If \Type$ = "WindowGadget"
               BindEvent(#PB_Event_Gadget, @CO_Events(), \window)
            EndIf
         Else
            ParsePBObject()\SubLevel = \SubLevel
         EndIf
         
         ; Итем родителя для создания в нем гаджетов
         If \Item : ParsePBObject()\Item=\Item-1 : EndIf
         
         ; Открываем гаджет лист на том родителе где создан данный объект.
         If \Object = \parent
            If IsWindow(GetParent) : CloseGadgetList() : UseGadgetList(WindowID(GetParent)) : EndIf
            If IsGadget(GetParent) : OpenGadgetList = OpenGadgetList(GetParent, ParsePBObject()\Item) : EndIf
         EndIf
         
         ;       Transformation::Create(ParsePBObject()\Object, ParsePBObject()\window, ParsePBObject()\parent, ParsePBObject()\Item, 5)
         ;        Transformation::Create(ParsePBObject()\Object, ParsePBObject()\parent, -1, 0, 5)
         ;       ButtonGadget(-1,0,0,160,20,Str(Random(5))+" "+\parent$+"-"+Str(\parent))
         ;       CallFunctionFast(@CO_Events())
         
         ; Посылаем сообщение, что создали гаджет.
         If \Type$ = "WindowGadget"
            ParsePBObject()\window = \window
            PostEvent(#PB_Event_Gadget, \window, \Object, #PB_EventType_Create, \Object)
         Else
            PostEvent(#PB_Event_Gadget, \window, \Object, #PB_EventType_Create, \parent)
         EndIf
         
         ; Закрываем ранее открытий гаджет лист.
         If \Object = \parent
            If IsWindow(GetParent) : OpenGadgetList(\parent) : EndIf
            If OpenGadgetList : CloseGadgetList() : EndIf
         EndIf
      EndIf
      
      ;
      If IsWindow(\Object)
         StickyWindow(\Object, #True)
         ParsePBObject()\Container = \Container
         ;       Transformation::Create(ParsePBObject()\Object, ParsePBObject()\window, ParsePBObject()\parent, ParsePBObject()\Item, 5)
         PostEvent(#PB_Event_Gadget, \Object, #PB_Ignore, #PB_EventType_Create)
         EnableWindowDrop(\Object, #PB_Drop_Text, #PB_Drag_Copy)
         
         BindEvent(#PB_Event_Create, @CO_Events(), \Object)
         BindEvent(#PB_Event_Gadget, @CO_Events(), \Object)
         BindEvent(#PB_Event_WindowDrop, @CO_Events(), \Object)
         BindEvent(#PB_Event_LeftClick, @CO_Events(), \Object)
      EndIf
      
      ProcedureReturn \Object
   EndWith
EndProcedure

Procedure CO_Save(*parse.ParseStruct) ; Ok
   Protected result$, ID$, Handle$, Result, i
   
   If *parse\Content\String$
      Debug " [CO_Save]     " + *parse\Content\String$
      
      For i=2 To 5
         result$ = Trim(Trim(StringField( *parse\Content\String$, i, ","), ")"))
         ; Debug "Coordinate: "+result$
         
         Select Asc(result$)
            Case 'A' To 'Z' , 'a' To 'z'
               
               Select i 
                  Case 2 : *parse\x$ = result$
                  Case 3 : *parse\y$ = result$
                  Case 4 : *parse\width$ = result$
                  Case 5 : *parse\height$ = result$
               EndSelect
         EndSelect
      Next
      
      If *parse\Object$ = Chr('#')
         ID$ = *parse\Object$ + ", "
      Else
         ID$ = "#PB_Any, "
         Handle$ = *parse\Object$+" = "
      EndIf
      
      Select *parse\Type$
         Case "OpenWindow"          : result$ = Handle$+"OpenWindow("         +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                   
         Case "WindowGadget"        : result$ = Handle$+"OpenWindow("         +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                   
         Case "ButtonGadget"        : result$ = Handle$+"ButtonGadget("       +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                                 
         Case "StringGadget"        : result$ = Handle$+"StringGadget("       +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                                 
         Case "TextGadget"          : result$ = Handle$+"TextGadget("         +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                                   
         Case "CheckBoxGadget"      : result$ = Handle$+"CheckBoxGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                               
         Case "OptionGadget"        : result$ = Handle$+"OptionGadget("       +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')
         Case "WebGadget"           : result$ = Handle$+"WebGadget("          +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')
         Case "ExplorerListGadget"  : result$ = Handle$+"ExplorerListGadget(" +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                           
         Case "ExplorerTreeGadget"  : result$ = Handle$+"ExplorerTreeGadget(" +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                           
         Case "ExplorerComboGadget" : result$ = Handle$+"ExplorerComboGadget("+ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                          
         Case "FrameGadget"         : result$ = Handle$+"FrameGadget("        +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')                                                                                  
            
         Case "HyperLinkGadget"     : result$ = Handle$+"HyperLinkGadget("    +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')+", " + *parse\Param1$+", " + *parse\Param2$                                                          
         Case "ListIconGadget"      : result$ = Handle$+"ListIconGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ Chr('"') + *parse\Caption$+Chr('"')+", " + *parse\Param1$+", " + *parse\Param2$                                                       
            
         Case "ScrollBarGadget"     : result$ = Handle$+"ScrollBarGadget("    +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$+", " + *parse\Param2$+", " + *parse\Param3$                                                               
         Case "ProgressBarGadget"   : result$ = Handle$+"ProgressBarGadget("  +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$+", " + *parse\Param2$                                                                       
         Case "ScrollAreaGadget"    : result$ = Handle$+"ScrollAreaGadget("   +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$+", " + *parse\Param2$    
         Case "TrackBarGadget"      : result$ = Handle$+"TrackBarGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$+", " + *parse\Param2$                                                                                      
         Case "SpinGadget"          : result$ = Handle$+"SpinGadget("         +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$+", " + *parse\Param2$                                                                             
         Case "SplitterGadget"      : result$ = Handle$+"SplitterGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$+", " + *parse\Param2$                                                                         
         Case "MDIGadget"           : result$ = Handle$+"MDIGadget("          +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$+", " + *parse\Param2$                                                                              
         Case "ImageGadget"         : result$ = Handle$+"ImageGadget("        +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$                                                                                                     
         Case "ScintillaGadget"     : result$ = Handle$+"ScintillaGadget("    +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$
         Case "ShortcutGadget"      : result$ = Handle$+"ShortcutGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$
         Case "ButtonImageGadget"   : result$ = Handle$+"ButtonImageGadget("  +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$+", "+ *parse\Param1$                                                                                                 
            
         Case "ListViewGadget"      : result$ = Handle$+"ListViewGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$                                                                                                                       
         Case "ComboBoxGadget"      : result$ = Handle$+"ComboBoxGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$                                                                                                                       
         Case "ContainerGadget"     : result$ = Handle$+"ContainerGadget("    +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$                                                                                                                      
         Case "IPAddressGadget"     : result$ = Handle$+"IPAddressGadget("    +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$
         Case "CalendarGadget"      : result$ = Handle$+"CalendarGadget("     +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$                                                     
         Case "EditorGadget"        : result$ = Handle$+"EditorGadget("       +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$                                                                                                                          
         Case "DateGadget"          : result$ = Handle$+"DateGadget("         +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$               
         Case "TreeGadget"          : result$ = Handle$+"TreeGadget("         +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$                                                                                                                            
         Case "PanelGadget"         : result$ = Handle$+"PanelGadget("        +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$ 
         Case "CanvasGadget"        : result$ = Handle$+"CanvasGadget("       +ID$ + *parse\x$+", " + *parse\y$+", " + *parse\width$+", " + *parse\height$                                                                                                                          
      EndSelect
      
      Select *parse\Type$
         Case "ScrollAreaGadget"    
            If *parse\Param3$ : result$ +", " + *parse\Param3$ : EndIf     
         Case "CalendarGadget"
            If *parse\Param1$ : result$ +", " + *parse\Param1$ : EndIf 
         Case "DateGadget"         
            If *parse\Caption$ : result$ +", "+ Chr('"') + *parse\Caption$+Chr('"') : EndIf
            If *parse\Param1$ : result$ +", " + *parse\Param1$ : EndIf 
      EndSelect
      
      If *parse\flag$
         Select *parse\Type$
            Case "OpenWindow", "WindowGadget", 
                 "ScrollBarGadget", "TrackBarGadget", "ProgressBarGadget", "SpinGadget", "WebGadget", "OpenGLGadget",
                 "TextGadget", "StringGadget", "EditorGadget", "ButtonGadget", "CheckBoxGadget", "HyperLinkGadget", 
                 "TreeGadget", "ListIconGadget", "ListViewGadget", "ComboBoxGadget", "ImageGadget", "ButtonImageGadget",
                 "DateGadget", "CalendarGadget", "ExplorerComboGadget", "ExplorerListGadget", "ExplorerTreeGadget",
                 "ContainerGadget", "ScrollAreaGadget", "SplitterGadget", "MDIGadget", "CanvasGadget", "FrameGadget"  
               
               result$ +", " + *parse\flag$ 
         EndSelect
      EndIf
      
      
      result$+")" 
      
      *parse\Content\String$ = result$
   EndIf
   
   ProcedureReturn Len( result$ )
EndProcedure



;-
Procedure test_ParsePBFile(FileName.s)
   Protected i,Result, Texts.S, Text.S, Find.S, String.S, Count, Position, Index, Args$, Arg$
   
   If ReadFile(#File, FileName)
      Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_Extended    
      Protected Line, FindWindow, Text$, FunctionArgs$
      Protected Format=ReadStringFormat(#File)
      Protected Length = Lof(#File) 
      Protected *File = AllocateMemory(Length)
      
      
      If *File 
         ReadData(#File, *File, Length)
         *struct\Content\Text$ = PeekS(*File, Length, Format) ; "+#RegEx_Pattern_Function+~"
         
         
         ;If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|\\d|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:(\\w+)\\s*\\((\".*?\"|[^:]|.*?)\\))|(?:(\\w+)(|\\.\\w))\\s)", #PB_RegularExpression_Extended | Create_Reg_Flag) And
         If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
            CreateRegularExpression(#RegEx_Arguments, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
            CreateRegularExpression(#RegEx_Captions, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) And
            CreateRegularExpression(#RegEx_Arguments1, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
            CreateRegularExpression(#RegEx_Captions1, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) 
            
           Else
            Debug "Error creating #RegEx"
            End
         EndIf
         
         ClearDebugOutput()
         Debug CountRegularExpressionGroups(#RegEx_Function)
          
            If ExamineRegularExpression(#RegEx_Function, *struct\Content\Text$)
               While NextRegularExpressionMatch(#RegEx_Function)
                  
                  
                  If RegularExpressionGroup(#RegEx_Function, 1) = "" And RegularExpressionGroup(#RegEx_Function, 9) = ""
                     *struct\Type$=RegularExpressionGroup(#RegEx_Function, 7)
                     *struct\Args$ = Trim(RegularExpressionGroup(#RegEx_Function, 8))
                     
                 
                 ; Debug RegularExpressionGroup(#RegEx_Function, 7)
                    If RegularExpressionGroup(#RegEx_Function, 3)
                        *struct\Object$ = RegularExpressionGroup(#RegEx_Function, 3)
                     EndIf
                     
                     ; Если идентификатрор сгенерирован с #PB_Any то есть (Ident=PBFunction(#PB_Any))
                     If RegularExpressionGroup(#RegEx_Function, 3)
                        Protected Content_String$, Content_Length, Content_Position
                        *struct\Object$ = RegularExpressionGroup(#RegEx_Function, 3)
                        Content_String$ = RegularExpressionMatchString(#RegEx_Function)
                        Content_Length = RegularExpressionMatchLength(#RegEx_Function)
                        Content_Position = RegularExpressionMatchPosition(#RegEx_Function)
                     EndIf
                     
                     ; Debug ""+\Type$ +" <-> ("+ *struct\Args$ +") <-> "+ *struct\Object$
                     
                     If *struct\Type$
                        ; Debug "All - "+RegularExpressionMatchString(#RegEx_Function)
                        Select *struct\Type$
                           Case "OpenWindow", 
                                "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
                                "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
                                "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
                                "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
                                "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
                                "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
                                "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
                                "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
                              
                              AddElement(ParsePBObject()) 
                              ParsePBObject()\Type$ = *struct\Type$
                              ParsePBObject()\Content\String$ = Content_String$ + RegularExpressionMatchString(#RegEx_Function)
                              ParsePBObject()\Content\Length = Content_Length + RegularExpressionMatchLength(#RegEx_Function)
                              If Content_Position
                                 ParsePBObject()\Content\Position = Content_Position
                              Else
                                 ParsePBObject()\Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
                              EndIf
                              
                              ; Границы для добавления объектов
                              *struct\Content\Position=ParsePBObject()\Content\Position
                              *struct\Content\Length=ParsePBObject()\Content\Length
                              
                              If ExamineRegularExpression(#RegEx_Arguments, *struct\Args$) : Index=0
                                 While NextRegularExpressionMatch(#RegEx_Arguments)
                                    Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                                    
                                    If Arg$ : Index+1
                                       If (Index>5)
                                          Select *struct\Type$
                                             Case "OpenGLGadget","EditorGadget","CanvasGadget",
                                                  "ComboBoxGadget","ContainerGadget","ListViewGadget","TreeGadget"
                                                If Index=6 : Index+4 : EndIf
                                                
                                             Case "ScrollBarGadget","ScrollAreaGadget","ScintillaGadget"
                                                If Index=6 : Index+1 : EndIf
                                                
                                             Case "SplitterGadget"
                                                ;Debug Str(Index)+" "+Arg$
                                                Select Index 
                                                   Case 6,9 : Index+1
                                                EndSelect
                                                
                                             Case "TrackBarGadget","SpinGadget","ProgressBarGadget" ; TODO ?
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
                                                Select Asc(Arg$)
                                                   Case '0' To '9'
                                                      If *struct\Type$="OpenWindow"
                                                         *struct\Object$ = Arg$+"_Window"
                                                      Else
                                                         *struct\Object$ = Arg$+"_"+ReplaceString( *struct\Type$, "Gadget","")
                                                      EndIf
                                                   Default
                                                      *struct\Object$ = Arg$
                                                EndSelect
                                             Else
                                                state_id = 1 
                                             EndIf
                                             
                                             ParsePBObject()\Object$ = *struct\Object$
                                             ; Получаем класс объекта
                                             *struct\Class$ = *struct\Object$ 
                                             ; Удаляем имя родителя
                                             *struct\Class$ = ReplaceString( *struct\Class$, *struct\window$+"_", "")
                                             ; Сохраняем класс объекта
                                             ParsePBObject()\Class$ = *struct\Class$
                                             
                                             ; 
                                             state_class = Bool( *struct\Object$ <> *struct\Class$)
                                             
                                          Case 2 : ParsePBObject()\x$ = Arg$
                                             MacroCoordinate( *struct\x, Arg$)
                                             
                                          Case 3 : ParsePBObject()\y$ = Arg$
                                             MacroCoordinate( *struct\y, Arg$)
                                             
                                          Case 4 : ParsePBObject()\width$ = Arg$
                                             MacroCoordinate( *struct\width, Arg$)
                                             
                                          Case 5 : ParsePBObject()\height$ = Arg$
                                             MacroCoordinate( *struct\height, Arg$)
                                             
                                          Case 6 
                                             *struct\Caption$ = GetStr(Arg$)
                                             ParsePBObject()\Caption$ = *struct\Caption$
                                             
                                          Case 7 : ParsePBObject()\Param1$ = Arg$
                                             Select *struct\Type$ 
                                                Case "OpenWindow"      
                                                   *struct\Param1$ = get_argument_string(Arg$)
                                                   
                                                   ; Если идентификаторы окон цыфри
                                                   If Val( *struct\Param1$)
                                                      *struct\Param1$+"_Window"
                                                   Else
                                                      *struct\Param1$ = Arg$
                                                   EndIf
                                                   
                                                   *struct\Param1 = *struct\get( *struct\Param1$)\Object
                                                   
                                                   If IsWindow( *struct\Param1)
                                                      *struct\Param1 = WindowID( *struct\Param1)
                                                   EndIf
                                                   
                                                Case "SplitterGadget"      
                                                   *struct\Param1 = *struct\get(Arg$)\Object
                                                   
                                                Case "ImageGadget"      
                                                   Result = *struct\Img(GetStr(Arg$))\Object 
                                                   If IsImage(Result)
                                                      *struct\Param1 = ImageID(Result)
                                                   EndIf
                                                   
                                                Default
                                                   Select Asc(Arg$)
                                                      Case '0' To '9'
                                                         *struct\Param1 = Val(Arg$)
                                                      Default
                                                   EndSelect
                                             EndSelect
                                             
                                          Case 8 : ParsePBObject()\Param2$ = Arg$
                                             Select *struct\Type$ 
                                                Case "SplitterGadget"      
                                                   *struct\Param2 = *struct\get(Arg$)\Object
                                                   
                                                Default
                                                   Select Asc(Arg$)
                                                      Case '0' To '9'
                                                         *struct\Param2 = Val(Arg$)
                                                      Default
                                                   EndSelect
                                             EndSelect
                                             
                                          Case 9 : ParsePBObject()\Param3$ = Arg$
                                             *struct\Param3 = Val(Arg$)
                                             
                                          Case 10 
                                             ParsePBObject()\flag$ = Arg$
                                             *struct\flag = CO_Flag(Arg$)
                                             
                                       EndSelect
                                       
                                    EndIf
                                 Wend
                              EndIf
                              
                              ;
                              CO_Open()
                             
                              
                              ; code position
                              ; *struct\parent$ = *struct\get(Str(\parent))\Object$
                              ; Получаем последнюю позицию идентификаторов в файле
                              Protected RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])("+*struct\Object$+"(?:=-1)?)([^\s]\w+)?(?:\s+(\w+$))?")
                              If RegExID
                                 If ExamineRegularExpression(RegExID, *struct\Content\Text$)
                                    While NextRegularExpressionMatch(RegExID)
                                       *struct\get("Code")\Code("Code_Object")\Position = RegularExpressionMatchPosition(RegExID) + RegularExpressionMatchLength(RegExID)
                                       If *struct\Object$ = Chr('#')
                                          *struct\get("Code")\Code("Code_Object")\Position + Len(#CRLF$+"EndEnumeration")
                                       EndIf
                                       Break
                                    Wend
                                 EndIf
                                 
                                 FreeRegularExpression(RegExID)
                              EndIf
                              
                              ; Запоминаем последнюю позицию объекта
                              *struct\get( *struct\Object$ )\Code("Code_Function")\Position = *struct\Content\Position + *struct\Content\Length +Len(#CRLF$+Space(Indent))
                              *struct\get( *struct\parent$ )\Code("Code_Function")\Position = *struct\get( *struct\Object$ )\Code("Code_Function")\Position
                              
                              Select *struct\Type$
                                 Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
                                    *struct\get( *struct\parent$ )\Code("Code_Function")\Position + Len("CloseGadgetList()"+#CRLF$+Space(Indent))
                              EndSelect
                              
                              ;     Debug "               "+*struct\parent$
                              ;     Debug "               "+*struct\get(Str( *struct\parent))\Object$
                              
                              ; Записываем у родителя позицию конца добавления объекта
                              ; *struct\get(*struct\get(Str(*struct\parent))\Object$)\Code("Code_Function")\Position = *struct\Content\Position+*struct\Content\Length +Len(#CRLF$+Space(Indent))
                              ;   Debug "Load Code_Enumeration "+ *struct\get("Code")\Code("Code_Object")\Position
                              ;   Debug "Load Code_Object"+ *struct\get("Code")\Code("Code_Object")\Position
                              ;   Debug "Load Code_Object"+ *struct\get(*struct\window$)\Code("Code_Object")\Position
                              ;   Debug "  Load Code_Function "+ *struct\get(Str(*struct\parent))\Object$ +" "+ *struct\get(*struct\get(Str(*struct\parent))\Object$)\Code("Code_Function")\Position
                              ;   Debug "    Code_Object"+ *struct\get(*struct\get(Replace$)\window$)\Code("Code_Object")\Position
                              ;   Debug "    Code_Function"+ *struct\get(*struct\get(Replace$)\parent$)\Code("Code_Function")\Position
                              
                              
                              *struct\Object=-1
                              *struct\Object$=""
                              *struct\Param1 = 0
                              *struct\Param2 = 0
                              *struct\Param3 = 0
                              *struct\Caption$ = ""
                              *struct\flag = 0
                              
                           Case "UseGadgetList"
                              *struct\Param1$ = get_argument_string( *struct\Args$)
                              
                              ; Если идентификаторы окон цыфри
                              If Val( *struct\Param1$)
                                 *struct\Param1$+"_Window"
                              Else
                                 *struct\Param1$ = *struct\Args$
                              EndIf
                              
                              *struct\Param1 = *struct\get( *struct\Param1$ )\Object
                              
                              If IsWindow( *struct\Param1)
                                 ;                         *struct\get( *struct\Object$)\Object = *struct\get(Str( *struct\Param1))\window
                                 Protected UseGadgetList = UseGadgetList(WindowID( *struct\Param1))
                                 PushListPosition(ParsePBObject())
                                 ForEach ParsePBObject()
                                    If ParsePBObject()\Container=-1 
                                       If IsWindow(ParsePBObject()\Object) And 
                                          WindowID(ParsePBObject()\Object) = UseGadgetList
                                          *struct\get( *struct\Object$)\Object = ParsePBObject()\Object
                                       EndIf
                                    EndIf
                                 Next
                                 PopListPosition(ParsePBObject())
                                 UseGadgetList(UseGadgetList)
                                 
                              ElseIf IsGadget( *struct\Param1)
                                 PushListPosition(ParsePBObject())
                                 change_current_object_from_id( *struct\Param1)
                                 While PreviousElement(ParsePBObject())
                                    If ParsePBObject()\Container=-1 
                                       *struct\get( *struct\Object$)\Object = ParsePBObject()\Object
                                       Break
                                    EndIf
                                 Wend
                                 PopListPosition(ParsePBObject())
                                 
                              Else
                                 *struct\Param1 = *struct\get( *struct\Param1$)\Object
                              EndIf
                              
                              CO_Open()
                              
                           Case "CloseGadgetList"      : CO_Open() ; ; TODO
                              
                           Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"      
                              If ExamineRegularExpression(#RegEx_Arguments, *struct\Args$) : Index=0
                                 While NextRegularExpressionMatch(#RegEx_Arguments)
                                    Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                                    
                                    If Arg$ : Index+1
                                       Select Index
                                          Case 1 
                                             *struct\Object$ = Arg$
                                             If Val(Arg$)
                                                PushListPosition(ParsePBObject())
                                                ForEach ParsePBObject()
                                                   If Val(ParsePBObject()\Object$) = Val(Arg$)
                                                      *struct\Object$ = ParsePBObject()\Object$
                                                   EndIf
                                                Next
                                                PopListPosition(ParsePBObject())
                                             EndIf
                                             
                                             ;*struct\get(Str( *struct\parent))\Object$
                                             ;                                 *struct\Object$ = *struct\get(Str( *struct\parent))\Object$
                                             
                                             
                                          Case 2 : *struct\Param1 = Val(Arg$)  
                                          Case 3 : *struct\Caption$=GetStr(Arg$)
                                          Case 4 : *struct\Param2 = Val(Arg$)
                                          Case 5 : *struct\flag$ = Arg$
                                             *struct\flag = CO_Flag(Arg$)
                                             If Not *struct\flag
                                                Select Asc( *struct\flag$)
                                                   Case '0' To '9'
                                                   Default
                                                      *struct\flag = CO_Flag(GetVarValue(Arg$))
                                                EndSelect
                                             EndIf
                                       EndSelect
                                    EndIf
                                 Wend
                              EndIf
                              
                              ;Debug " g "+\Object$ +" "+ Str(*struct\get( *struct\Object$)\Object)
                              CO_Open()
                              
                              
                              *struct\Object =- 1
                              *struct\Object$ = ""
                              *struct\flag = 0
                              *struct\Param1 = 0
                              *struct\Param2 = 0
                              *struct\Param3 = 0
                              *struct\flag$ = ""
                              *struct\Param1$ = ""
                              *struct\Param2$ = ""
                              *struct\Param3$ = ""
                              *struct\Caption$ = ""
                              ;ClearStructure(*struct, ParseStruct)
                              ;                         FreeStructure(*struct)
                              ;                         *struct.ParseStruct = AllocateStructure(ParseStruct)
                              
                           Default
                              If ExamineRegularExpression(#RegEx_Arguments, *struct\Args$) : Index=0
                                 While NextRegularExpressionMatch(#RegEx_Arguments)
                                    Args$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                                    
                                    If Args$
                                       *struct\Args$ = Args$ 
                                       Index+1
                                       PC_Add(*struct, Index)
                                    EndIf
                                 Wend
                                 
                                 PC_Set(*struct)
                              EndIf
                              
                        EndSelect
                        
                     EndIf
                     
                  EndIf
               Wend
               
            Else
               Debug "Nothing to extract from: " + *struct\Content\Text$
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
            
            
         EndIf
      
      CloseFile(#File)
      Result = #True
   EndIf
   
   ProcedureReturn Result
EndProcedure

Procedure ParsePBFile(FileName.s)
   ProcedureReturn test_ParsePBFile(FileName.s)
   
   Protected i,Result, Texts.S, Text.S, Find.S, String.S, Count, Position, Index, Args$, Arg$
   
   If ReadFile(#File, FileName)
      Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_Extended    
      Protected Line, FindWindow, Text$, FunctionArgs$
      Protected Format=ReadStringFormat(#File)
      Protected Length = Lof(#File) 
      Protected *File = AllocateMemory(Length)
      
      
      If *File 
         ReadData(#File, *File, Length)
         *struct\Content\Text$ = PeekS(*File, Length, Format) ; "+#RegEx_Pattern_Function+~"
         
         ;If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|\\d|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:(\\w+)\\s*\\((\".*?\"|[^:]|.*?)\\))|(?:(\\w+)(|\\.\\w))\\s)", #PB_RegularExpression_Extended | Create_Reg_Flag) And
         If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|[0-9]|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:([A-Za-z_0-9]+)\\s*\\((\".*?\"|[^:]|.*)\\))|(?:(\\w+)(|\\.\\w))\\s)", Create_Reg_Flag) And
            CreateRegularExpression(#RegEx_Arguments, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
            CreateRegularExpression(#RegEx_Captions, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) And
            CreateRegularExpression(#RegEx_Arguments1, #RegEx_Pattern_Arguments, Create_Reg_Flag| #PB_RegularExpression_DotAll) And 
            CreateRegularExpression(#RegEx_Captions1, #RegEx_Pattern_Captions, Create_Reg_Flag| #PB_RegularExpression_DotAll) 
            
            
            If ExamineRegularExpression(#RegEx_Function, *struct\Content\Text$)
               While NextRegularExpressionMatch(#RegEx_Function)
                  
                  If RegularExpressionGroup(#RegEx_Function, 1) = "" And RegularExpressionGroup(#RegEx_Function, 9) = ""
                     *struct\Type$=RegularExpressionGroup(#RegEx_Function, 7)
                     *struct\Args$ = Trim(RegularExpressionGroup(#RegEx_Function, 8))
                     
                     If RegularExpressionGroup(#RegEx_Function, 3)
                        *struct\Object$ = RegularExpressionGroup(#RegEx_Function, 3)
                     EndIf
                     
                     ; Если идентификатрор сгенерирован с #PB_Any то есть (Ident=PBFunction(#PB_Any))
                     If RegularExpressionGroup(#RegEx_Function, 3)
                        Protected Content_String$, Content_Length, Content_Position
                        *struct\Object$ = RegularExpressionGroup(#RegEx_Function, 3)
                        Content_String$ = RegularExpressionMatchString(#RegEx_Function)
                        Content_Length = RegularExpressionMatchLength(#RegEx_Function)
                        Content_Position = RegularExpressionMatchPosition(#RegEx_Function)
                     EndIf
                     
                     ; Debug ""+\Type$ +" <-> ("+ *struct\Args$ +") <-> "+ *struct\Object$
                     
                     If *struct\Type$
                        ; Debug "All - "+RegularExpressionMatchString(#RegEx_Function)
                        Select *struct\Type$
                           Case "OpenWindow", 
                                "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
                                "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
                                "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
                                "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
                                "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
                                "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
                                "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
                                "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
                              
                              AddElement(ParsePBObject()) 
                              ParsePBObject()\Type$ = *struct\Type$
                              ParsePBObject()\Content\String$ = Content_String$ + RegularExpressionMatchString(#RegEx_Function)
                              ParsePBObject()\Content\Length = Content_Length + RegularExpressionMatchLength(#RegEx_Function)
                              If Content_Position
                                 ParsePBObject()\Content\Position = Content_Position
                              Else
                                 ParsePBObject()\Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
                              EndIf
                              
                              ; Границы для добавления объектов
                              *struct\Content\Position=ParsePBObject()\Content\Position
                              *struct\Content\Length=ParsePBObject()\Content\Length
                              
                              If ExamineRegularExpression(#RegEx_Arguments, *struct\Args$) : Index=0
                                 While NextRegularExpressionMatch(#RegEx_Arguments)
                                    Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                                    
                                    If Arg$ : Index+1
                                       If (Index>5)
                                          Select *struct\Type$
                                             Case "OpenGLGadget","EditorGadget","CanvasGadget",
                                                  "ComboBoxGadget","ContainerGadget","ListViewGadget","TreeGadget"
                                                If Index=6 : Index+4 : EndIf
                                                
                                             Case "ScrollBarGadget","ScrollAreaGadget","ScintillaGadget"
                                                If Index=6 : Index+1 : EndIf
                                                
                                             Case "SplitterGadget"
                                                ;Debug Str(Index)+" "+Arg$
                                                Select Index 
                                                   Case 6,9 : Index+1
                                                EndSelect
                                                
                                             Case "TrackBarGadget","SpinGadget","ProgressBarGadget" ; TODO ?
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
                                                Select Asc(Arg$)
                                                   Case '0' To '9'
                                                      If *struct\Type$="OpenWindow"
                                                         *struct\Object$ = Arg$+"_Window"
                                                      Else
                                                         *struct\Object$ = Arg$+"_"+ReplaceString( *struct\Type$, "Gadget","")
                                                      EndIf
                                                   Default
                                                      *struct\Object$ = Arg$
                                                EndSelect
                                             Else
                                                state_id = 1 
                                             EndIf
                                             
                                             ParsePBObject()\Object$ = *struct\Object$
                                             ; Получаем класс объекта
                                             *struct\Class$ = *struct\Object$ 
                                             ; Удаляем имя родителя
                                             *struct\Class$ = ReplaceString( *struct\Class$, *struct\window$+"_", "")
                                             ; Сохраняем класс объекта
                                             ParsePBObject()\Class$ = *struct\Class$
                                             
                                             ; 
                                             state_class = Bool( *struct\Object$ <> *struct\Class$)
                                             
                                          Case 2 : ParsePBObject()\x$ = Arg$
                                             MacroCoordinate( *struct\x, Arg$)
                                             
                                          Case 3 : ParsePBObject()\y$ = Arg$
                                             MacroCoordinate( *struct\y, Arg$)
                                             
                                          Case 4 : ParsePBObject()\width$ = Arg$
                                             MacroCoordinate( *struct\width, Arg$)
                                             
                                          Case 5 : ParsePBObject()\height$ = Arg$
                                             MacroCoordinate( *struct\height, Arg$)
                                             
                                          Case 6 
                                             *struct\Caption$ = GetStr(Arg$)
                                             ParsePBObject()\Caption$ = *struct\Caption$
                                             
                                          Case 7 : ParsePBObject()\Param1$ = Arg$
                                             Select *struct\Type$ 
                                                Case "OpenWindow"      
                                                   *struct\Param1$ = get_argument_string(Arg$)
                                                   
                                                   ; Если идентификаторы окон цыфри
                                                   If Val( *struct\Param1$)
                                                      *struct\Param1$+"_Window"
                                                   Else
                                                      *struct\Param1$ = Arg$
                                                   EndIf
                                                   
                                                   *struct\Param1 = *struct\get( *struct\Param1$)\Object
                                                   
                                                   If IsWindow( *struct\Param1)
                                                      *struct\Param1 = WindowID( *struct\Param1)
                                                   EndIf
                                                   
                                                Case "SplitterGadget"      
                                                   *struct\Param1 = *struct\get(Arg$)\Object
                                                   
                                                Case "ImageGadget"      
                                                   Result = *struct\Img(GetStr(Arg$))\Object 
                                                   If IsImage(Result)
                                                      *struct\Param1 = ImageID(Result)
                                                   EndIf
                                                   
                                                Default
                                                   Select Asc(Arg$)
                                                      Case '0' To '9'
                                                         *struct\Param1 = Val(Arg$)
                                                      Default
                                                   EndSelect
                                             EndSelect
                                             
                                          Case 8 : ParsePBObject()\Param2$ = Arg$
                                             Select *struct\Type$ 
                                                Case "SplitterGadget"      
                                                   *struct\Param2 = *struct\get(Arg$)\Object
                                                   
                                                Default
                                                   Select Asc(Arg$)
                                                      Case '0' To '9'
                                                         *struct\Param2 = Val(Arg$)
                                                      Default
                                                   EndSelect
                                             EndSelect
                                             
                                          Case 9 : ParsePBObject()\Param3$ = Arg$
                                             *struct\Param3 = Val(Arg$)
                                             
                                          Case 10 
                                             ParsePBObject()\flag$ = Arg$
                                             *struct\flag = CO_Flag(Arg$)
                                             
                                       EndSelect
                                       
                                    EndIf
                                 Wend
                              EndIf
                              
                              ;
                              CallFunctionFast( @CO_Open() )
                              
                              ; code position
                              ; *struct\parent$ = *struct\get(Str(\parent))\Object$
                              ; Получаем последнюю позицию идентификаторов в файле
                              Protected RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])("+*struct\Object$+"(?:=-1)?)([^\s]\w+)?(?:\s+(\w+$))?")
                              If RegExID
                                 If ExamineRegularExpression(RegExID, *struct\Content\Text$)
                                    While NextRegularExpressionMatch(RegExID)
                                       *struct\get("Code")\Code("Code_Object")\Position = RegularExpressionMatchPosition(RegExID) + RegularExpressionMatchLength(RegExID)
                                       If *struct\Object$ = Chr('#')
                                          *struct\get("Code")\Code("Code_Object")\Position + Len(#CRLF$+"EndEnumeration")
                                       EndIf
                                       Break
                                    Wend
                                 EndIf
                                 
                                 FreeRegularExpression(RegExID)
                              EndIf
                              
                              ; Запоминаем последнюю позицию объекта
                              *struct\get( *struct\Object$ )\Code("Code_Function")\Position = *struct\Content\Position + *struct\Content\Length +Len(#CRLF$+Space(Indent))
                              *struct\get( *struct\parent$ )\Code("Code_Function")\Position = *struct\get( *struct\Object$ )\Code("Code_Function")\Position
                              
                              Select *struct\Type$
                                 Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
                                    *struct\get( *struct\parent$ )\Code("Code_Function")\Position + Len("CloseGadgetList()"+#CRLF$+Space(Indent))
                              EndSelect
                              
                              ;     Debug "               "+*struct\parent$
                              ;     Debug "               "+*struct\get(Str( *struct\parent))\Object$
                              
                              ; Записываем у родителя позицию конца добавления объекта
                              ; *struct\get(*struct\get(Str(*struct\parent))\Object$)\Code("Code_Function")\Position = *struct\Content\Position+*struct\Content\Length +Len(#CRLF$+Space(Indent))
                              ;   Debug "Load Code_Enumeration "+ *struct\get("Code")\Code("Code_Object")\Position
                              ;   Debug "Load Code_Object"+ *struct\get("Code")\Code("Code_Object")\Position
                              ;   Debug "Load Code_Object"+ *struct\get(*struct\window$)\Code("Code_Object")\Position
                              ;   Debug "  Load Code_Function "+ *struct\get(Str(*struct\parent))\Object$ +" "+ *struct\get(*struct\get(Str(*struct\parent))\Object$)\Code("Code_Function")\Position
                              ;   Debug "    Code_Object"+ *struct\get(*struct\get(Replace$)\window$)\Code("Code_Object")\Position
                              ;   Debug "    Code_Function"+ *struct\get(*struct\get(Replace$)\parent$)\Code("Code_Function")\Position
                              
                              
                              *struct\Object=-1
                              *struct\Object$=""
                              *struct\Param1 = 0
                              *struct\Param2 = 0
                              *struct\Param3 = 0
                              *struct\Caption$ = ""
                              *struct\flag = 0
                              
                           Case "UseGadgetList"
                              *struct\Param1$ = get_argument_string( *struct\Args$)
                              
                              ; Если идентификаторы окон цыфри
                              If Val( *struct\Param1$)
                                 *struct\Param1$+"_Window"
                              Else
                                 *struct\Param1$ = *struct\Args$
                              EndIf
                              
                              *struct\Param1 = *struct\get( *struct\Param1$)\Object
                              
                              If IsWindow( *struct\Param1)
                                 ;                         *struct\get( *struct\Object$)\Object = *struct\get(Str( *struct\Param1))\window
                                 Protected UseGadgetList = UseGadgetList(WindowID( *struct\Param1))
                                 PushListPosition(ParsePBObject())
                                 ForEach ParsePBObject()
                                    If ParsePBObject()\Container=-1 
                                       If IsWindow(ParsePBObject()\Object) And 
                                          WindowID(ParsePBObject()\Object) = UseGadgetList
                                          *struct\get( *struct\Object$)\Object = ParsePBObject()\Object
                                       EndIf
                                    EndIf
                                 Next
                                 PopListPosition(ParsePBObject())
                                 UseGadgetList(UseGadgetList)
                                 
                              ElseIf IsGadget( *struct\Param1)
                                 PushListPosition(ParsePBObject())
                                 change_current_object_from_id( *struct\Param1)
                                 While PreviousElement(ParsePBObject())
                                    If ParsePBObject()\Container=-1 
                                       *struct\get( *struct\Object$)\Object = ParsePBObject()\Object
                                       Break
                                    EndIf
                                 Wend
                                 PopListPosition(ParsePBObject())
                                 
                              Else
                                 *struct\Param1 = *struct\get( *struct\Param1$)\Object
                              EndIf
                              
                              CallFunctionFast(@CO_Open())
                              
                           Case "CloseGadgetList"      : CallFunctionFast(@CO_Open()) ; ; TODO
                              
                           Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"      
                              If ExamineRegularExpression(#RegEx_Arguments, *struct\Args$) : Index=0
                                 While NextRegularExpressionMatch(#RegEx_Arguments)
                                    Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                                    
                                    If Arg$ : Index+1
                                       Select Index
                                          Case 1 
                                             *struct\Object$ = Arg$
                                             If Val(Arg$)
                                                PushListPosition(ParsePBObject())
                                                ForEach ParsePBObject()
                                                   If Val(ParsePBObject()\Object$) = Val(Arg$)
                                                      *struct\Object$ = ParsePBObject()\Object$
                                                   EndIf
                                                Next
                                                PopListPosition(ParsePBObject())
                                             EndIf
                                             
                                             ;*struct\get(Str( *struct\parent))\Object$
                                             ;                                 *struct\Object$ = *struct\get(Str( *struct\parent))\Object$
                                             
                                             
                                          Case 2 : *struct\Param1 = Val(Arg$)  
                                          Case 3 : *struct\Caption$=GetStr(Arg$)
                                          Case 4 : *struct\Param2 = Val(Arg$)
                                          Case 5 : *struct\flag$ = Arg$
                                             *struct\flag = CO_Flag(Arg$)
                                             If Not *struct\flag
                                                Select Asc( *struct\flag$)
                                                   Case '0' To '9'
                                                   Default
                                                      *struct\flag = CO_Flag(GetVarValue(Arg$))
                                                EndSelect
                                             EndIf
                                       EndSelect
                                    EndIf
                                 Wend
                              EndIf
                              
                              ;Debug " g "+\Object$ +" "+ Str(*struct\get( *struct\Object$)\Object)
                              CallFunctionFast(@CO_Open())
                              
                              
                              *struct\Object =- 1
                              *struct\Object$ = ""
                              *struct\flag = 0
                              *struct\Param1 = 0
                              *struct\Param2 = 0
                              *struct\Param3 = 0
                              *struct\flag$ = ""
                              *struct\Param1$ = ""
                              *struct\Param2$ = ""
                              *struct\Param3$ = ""
                              *struct\Caption$ = ""
                              ;ClearStructure(*struct, ParseStruct)
                              ;                         FreeStructure(*struct)
                              ;                         *struct.ParseStruct = AllocateStructure(ParseStruct)
                              
                           Default
                              If ExamineRegularExpression(#RegEx_Arguments, *struct\Args$) : Index=0
                                 While NextRegularExpressionMatch(#RegEx_Arguments)
                                    Args$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                                    
                                    If Args$
                                       *struct\Args$ = Args$ 
                                       Index+1
                                       PC_Add(*struct, Index)
                                    EndIf
                                 Wend
                                 
                                 PC_Set(*struct)
                              EndIf
                              
                        EndSelect
                        
                     EndIf
                     
                  EndIf
               Wend
               
            Else
               Debug "Nothing to extract from: " + *struct\Content\Text$
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
                                "textgadget",
                                "checkboxgadget",
                                "optiongadget",
                                "listviewgadget",
                                "framegadget",
                                "comboboxgadget",
                                "imagegadget",
                                "hyperlinkgadget",
                                "containergadget",
                                "listicongadget",
                                "ipaddressgadget",
                                "progressbargadget",
                                "scrollbargadget",
                                "scrollareagadget",
                                "trackbargadget",
                                ;                        "webgadget",
                              "buttonimagegadget",
"calendargadget",
"dategadget",
"editorgadget",
"explorerlistgadget",
"explorertreegadget",
"explorercombogadget",
"spingadget",
"treegadget",
"panelgadget",
"splittergadget",
"mdigadget",
"scintillagadget",
"shortcutgadget",
"canvasgadget",
"gadget"
                              
                              GadgetName=ULCase(ReplaceString(GadgetName, "gadget",""))
                              
                              GadgetName = ReplaceString(GadgetName, "box","Box")
                              GadgetName = ReplaceString(GadgetName, "link","Link")
                              GadgetName = ReplaceString(GadgetName, "bar","Bar")
                              GadgetName = ReplaceString(GadgetName, "area","Area")
                              GadgetName = ReplaceString(GadgetName, "Ipa","IPA")
                              
                              GadgetName = ReplaceString(GadgetName, "view","View")
                              GadgetName = ReplaceString(GadgetName, "icon","Icon")
                              GadgetName = ReplaceString(GadgetName, "image","Image")
                              GadgetName = ReplaceString(GadgetName, "combo","Combo")
                              GadgetName = ReplaceString(GadgetName, "list","List")
                              GadgetName = ReplaceString(GadgetName, "tree","Tree")
                              
                              AddGadgetItem(WE_Objects, -1, GadgetName, ImageID(GadgetImage))
                              SetGadgetItemData(WE_Objects, CountGadgetItems(WE_Objects)-1, GadgetImage)
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
Procedure inspector_get_pos(Gadget, Parent)
   Protected i, Position=-1 ; 
   
   ; Определяем позицию в списке
   If IsGadget(Parent) 
      Position = CountGadgetItems(Gadget)
      
      For i=0 To CountGadgetItems(Gadget)-1
         If Parent=GetGadgetItemData(Gadget, i) 
            *struct\SubLevel=GetGadgetItemAttribute(Gadget, i, #PB_Tree_SubLevel)+1
            Position=(i+1)
            Break
         EndIf
      Next 
      For i=Position To CountGadgetItems(Gadget)-1
         If *struct\SubLevel=<GetGadgetItemAttribute(Gadget, i, #PB_Tree_SubLevel)
            Position+1
         EndIf
      Next 
   ElseIf IsWindow(Parent)
      Position = CountGadgetItems(Gadget)
      *struct\SubLevel = 1
   EndIf
   
   ProcedureReturn Position
EndProcedure

Procedure inspector_add_pos(Gadget, Position=-1)
   Protected i, Img, ImageID
   
   Img = GetGadgetItemData(WE_Objects, GetGadgetState(WE_Objects))
   If IsImage(Img) : ImageID = ImageID(Img) : EndIf
   
   Macro generate_image(_class_)
      For I=0 To CountGadgetItems(WE_Objects)-1
         If _class_ = GetGadgetItemText(WE_Objects, I)+"Gadget"
            ImageID = ImageID(GetGadgetItemData(WE_Objects, I))
            Break
         EndIf
      Next  
   EndMacro
   
   If ImageID = 0
      ImageID = ImageID(img_form)
   EndIf
   
   ; Добавляем объекты к списку
   If Position=-1
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
         Position = CountGadgetItems(Gadget)
         generate_image(ParsePBObject()\Type$)
         AddGadgetItem (Gadget, -1, ParsePBObject()\Object$, ImageID, ParsePBObject()\SubLevel)
         SetGadgetItemData(Gadget, Position, ParsePBObject()\Object)
      Next
      PopListPosition(ParsePBObject())
   Else
      AddGadgetItem(Gadget, Position, ParsePBObject()\Object$, ImageID, ParsePBObject()\SubLevel)
      SetGadgetItemData(Gadget, Position, ParsePBObject()\Object)
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

Procedure _WE_Replace_ID(Gadget)
   Protected Object, i,Find$ = GetGadgetText(Gadget)
   Protected Replace$ = GetGadgetText(EventGadget())
   Protected RegExID, ParentClass$, len
   
   ; 
   If Replace$ And Find$ <> Replace$
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
         If ParsePBObject()\Object$ = Find$
            ; Включаем и имя родителя при формировании имени объекта
            If *struct\get(Str(ParsePBObject()\parent))\Object$ And 
               Not FindString(Replace$, *struct\get(Str(ParsePBObject()\parent))\Object$)
               Replace$ = *struct\get(Str(ParsePBObject()\parent))\Object$+"_"+Replace$
               SetGadgetText(EventGadget(), Replace$)
               Caret::SetPos(EventGadget(), Len(Replace$))
            EndIf
            
            ;
            If Find$=*struct\get(Find$)\window$
               *struct\get(Find$)\window$=Replace$
            EndIf
            If Find$=*struct\get(Find$)\parent$
               *struct\get(Find$)\parent$=Replace$
            EndIf
            
            *struct\get(ParsePBObject()\Object$)\Object$ = Replace$
            *struct\get(Str(ParsePBObject()\Object))\Object$ = Replace$
            
            ParsePBObject()\Class$ = ReplaceString(Replace$, *struct\get(Str(ParsePBObject()\parent))\Object$+"_", "")
            
            ; Меняем map ключ объекта
            CopyStructure(*struct\get(ParsePBObject()\Object$), *struct\get(Replace$), ObjectStruct)
            ; И удаляем старый
            DeleteMapElement(*struct\get(), ParsePBObject()\Object$)
            
            ParsePBObject()\Object$ = Replace$ 
            
            ; По умалчанию 
            If ParsePBObject()\Container
               If ParsePBObject()\Container =- 1
                  *struct\window$ = ParsePBObject()\Object$ 
               EndIf
               *struct\Container = ParsePBObject()\Container
               *struct\parent$ = ParsePBObject()\Object$
            EndIf
            ParsePBObject()\window$ = *struct\window$
            ParsePBObject()\parent$ = *struct\parent$
         Else
            ; Формируем имя объекта снова так как изменили имя родителя
            If *struct\get(Str(ParsePBObject()\parent))\Object$
               ParentClass$ = *struct\get(Str(ParsePBObject()\parent))\Object$
               
               *struct\get(ParsePBObject()\Object$)\Object$ = ParentClass$+"_"+ParsePBObject()\Class$
               *struct\get(Str(ParsePBObject()\Object))\Object$ = ParentClass$+"_"+ParsePBObject()\Class$
               
               ; Меняем map ключ объекта
               CopyStructure(*struct\get(ParsePBObject()\Object$), *struct\get(ParentClass$+"_"+ParsePBObject()\Class$), ObjectStruct)
               ; И удаляем старый
               DeleteMapElement(*struct\get(), ParsePBObject()\Object$)
               
               ParsePBObject()\Object$ = ParentClass$+"_"+ParsePBObject()\Class$ 
               Debug ParsePBObject()\Object$
               
               ; Обнавляем инспектор объектов
               For i=0 To CountGadgetItems(Gadget)-1
                  If ParsePBObject()\Object=GetGadgetItemData(Gadget, i) 
                     SetGadgetItemText(Gadget, i, ParsePBObject()\Object$)
                     Break
                  EndIf
               Next 
            EndIf
         EndIf
      Next
      PopListPosition(ParsePBObject())  
      
      ; Здесь обнавляем контент функции
      PC_Update()
      
      ; Здесь множественная замена
      RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+Trim(Find$, "#")+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
      
      If RegExID
         Protected NbFound, String$, Dim Result$(0) 
         ; Разница между словами
         len = (Len(Replace$)-Len(Find$))
         
         ; Делаем разницу столько раз сколько слов заменено
         String$ = Mid(*struct\Content\Text$, 1, *struct\get("Code")\Code("Code_Object")\Position)
         NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
         *struct\get("Code")\Code("Code_Object")\Position + NbFound
         
         ; Делаем разницу столько раз сколько слов заменено
         String$ = Mid(*struct\Content\Text$, 1, *struct\get("Code")\Code("Code_Object_Gadget")\Position)
         NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
         *struct\get("Code")\Code("Code_Object_Gadget")\Position + NbFound
         
         ; Делаем разницу столько раз сколько слов заменено
         String$ = Mid(*struct\Content\Text$, 1, *struct\get("Code")\Code("Code_Object")\Position)
         NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
         *struct\get("Code")\Code("Code_Object")\Position + NbFound
         
         ; Делаем разницу столько раз сколько слов заменено
         String$ = Mid(*struct\Content\Text$, 1, *struct\get("Code")\Code("Code_Enumeration_Gadget")\Position)
         NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
         *struct\get("Code")\Code("Code_Enumeration_Gadget")\Position + NbFound
         
         ; Делаем разницу столько раз сколько слов заменено
         String$ = Mid(*struct\Content\Text$, 1, *struct\get(Replace$)\Code("Code_Function")\Position)
         NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
         
         PushListPosition(ParsePBObject())
         ForEach ParsePBObject()
            If ParsePBObject()\Container 
               *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position + NbFound
            EndIf
         Next
         PopListPosition(ParsePBObject())
         
         ; Заменям слова в файле
         If ExamineRegularExpression(RegExID, *struct\Content\Text$)
            While NextRegularExpressionMatch(RegExID)
               *struct\Content\Text$ = ReplaceRegularExpression(RegExID, *struct\Content\Text$, Trim(Replace$, "#"))
               Break
            Wend
         EndIf
         
         FreeRegularExpression(RegExID)
      EndIf
      
      ;     Debug "    Code_Object"+ *struct\get(*struct\get(Replace$)\window$)\Code("Code_Object")\Position
      ;     Debug "    Code_Function"+ *struct\get(*struct\get(Replace$)\parent$)\Code("Code_Function")\Position
      SetGadgetText(Gadget, Replace$)
      
      WE_Code_Show(*struct\Content\Text$)
   EndIf
EndProcedure

Procedure WE_Replace_ID(Gadget)
   Protected Object, i,Find$ = GetGadgetText(Gadget)
   Protected Replace$ = GetGadgetText(EventGadget())
   Protected RegExID, ParentClass$, len
   
   ; 
   If Replace$ And Find$ <> Replace$
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
         If ParsePBObject()\Object$ = Find$
            If state_class
               ; Включаем и имя родителя при формировании имени объекта
               If *struct\get(Str(ParsePBObject()\parent))\Object$ And 
                  Not FindString(Replace$, *struct\get(Str(ParsePBObject()\parent))\Object$)
                  Replace$ = *struct\get(Str(ParsePBObject()\parent))\Object$+"_"+Replace$
                  SetGadgetText(EventGadget(), Replace$)
                  Caret::SetPos(EventGadget(), Len(Replace$))
               EndIf
            EndIf
            
            ;
            If Find$=*struct\get(Find$)\window$
               *struct\get(Find$)\window$=Replace$
            EndIf
            If Find$=*struct\get(Find$)\parent$
               *struct\get(Find$)\parent$=Replace$
            EndIf
            
            *struct\get(ParsePBObject()\Object$)\Object$ = Replace$
            *struct\get(Str(ParsePBObject()\Object))\Object$ = Replace$
            
            ParsePBObject()\Class$ = ReplaceString(Replace$, *struct\get(Str(ParsePBObject()\parent))\Object$+"_", "")
            
            ; Меняем map ключ объекта
            CopyStructure(*struct\get(ParsePBObject()\Object$), *struct\get(Replace$), ObjectStruct)
            ; И удаляем старый
            DeleteMapElement(*struct\get(), ParsePBObject()\Object$)
            
            ParsePBObject()\Object$ = Replace$ 
            
            ; По умалчанию 
            If ParsePBObject()\Container
               If ParsePBObject()\Container =- 1
                  *struct\window$ = ParsePBObject()\Object$ 
               EndIf
               *struct\Container = ParsePBObject()\Container
               *struct\parent$ = ParsePBObject()\Object$
            EndIf
            ParsePBObject()\window$ = *struct\window$
            ParsePBObject()\parent$ = *struct\parent$
         Else
            ; Формируем имя объекта снова так как изменили имя родителя
            If *struct\get(Str(ParsePBObject()\parent))\Object$
               If state_class
                  ParentClass$ = *struct\get(Str(ParsePBObject()\parent))\Object$+"_"
               EndIf
               
               *struct\get(ParsePBObject()\Object$)\Object$ = ParentClass$+ParsePBObject()\Class$
               *struct\get(Str(ParsePBObject()\Object))\Object$ = ParentClass$+ParsePBObject()\Class$
               
               ; Меняем map ключ объекта
               CopyStructure(*struct\get(ParsePBObject()\Object$), *struct\get(ParentClass$+ParsePBObject()\Class$), ObjectStruct)
               ; И удаляем старый
               DeleteMapElement(*struct\get(), ParsePBObject()\Object$)
               
               ParsePBObject()\Object$ = ParentClass$+ParsePBObject()\Class$ 
               Debug ParsePBObject()\Object$
               
               ; Обнавляем инспектор объектов
               For i=0 To CountGadgetItems(Gadget)-1
                  If ParsePBObject()\Object=GetGadgetItemData(Gadget, i) 
                     SetGadgetItemText(Gadget, i, ParsePBObject()\Object$)
                     Break
                  EndIf
               Next 
            EndIf
         EndIf
      Next
      PopListPosition(ParsePBObject())  
      
      ; TODO Если закинуть на форму два объекта и редактировать идентификатор то не правильно определяет позицию
      
      ; Здесь обнавляем контент функции
      PC_Update()
      
      ; Здесь множественная замена
      RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+Trim(Find$, "#")+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
      
      If RegExID
         Protected NbFound, String$, Dim Result$(0) 
         ; Разница между словами
         len = (Len(Replace$)-Len(Find$))
         
         ; Делаем разницу столько раз сколько слов заменено
         String$ = Mid(*struct\Content\Text$, 1, *struct\get("Code")\Code("Code_Object")\Position)
         NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
         *struct\get("Code")\Code("Code_Object")\Position + NbFound
         
         ; Делаем разницу столько раз сколько слов заменено
         String$ = Mid(*struct\Content\Text$, 1, *struct\get(Replace$)\Code("Code_Function")\Position)
         NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
         
         ;Debug String$
         Debug "  g "+Replace$ +" "+ NbFound +" "+ len
         
         PushListPosition(ParsePBObject())
         ForEach ParsePBObject()
            If ParsePBObject()\Container 
               *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position + NbFound
            EndIf
         Next
         PopListPosition(ParsePBObject())
         
         ;       ; Заменям слова в файле
         If ExamineRegularExpression(RegExID, *struct\Content\Text$)
            While NextRegularExpressionMatch(RegExID)
               *struct\Content\Text$ = ReplaceRegularExpression(RegExID, *struct\Content\Text$, Trim(Replace$, "#"))
               Break
            Wend
         EndIf
         
         FreeRegularExpression(RegExID)
      EndIf
      
      ;     Debug "    Code_Object"+ *struct\get(*struct\get(Replace$)\window$)\Code("Code_Object")\Position
      ;     Debug "    Code_Function"+ *struct\get(*struct\get(Replace$)\parent$)\Code("Code_Function")\Position
      SetGadgetText(Gadget, Replace$)
      
      WE_Code_Show(*struct\Content\Text$)
   EndIf
EndProcedure

Procedure WE_OpenFile(Path$) ; Открытие файла
   If Path$
      Debug "Открываю файл '"+Path$+"'"
      
      ; Начинаем перебырать файл
      If ParsePBFile(Path$)
         
         inspector_add_pos(WE_Selecting)
         
         CodeShow=1
         WE_Code_Show(*struct\Content\Text$)
         
      EndIf
      
      *struct\Content\File$=Path$
      Debug "..успешно"
   EndIf 
EndProcedure

Procedure WE_SaveFile(Path$) ; Процедура сохранения файла
   Protected result$
   
   If Path$
      *struct\Content\File$=Path$
      ClearDebugOutput()
      Debug "Сохраняю файл '"+Path$+"'"
      
      Protected Object
      Protected len, Length, Position
      Protected Space$, Text$
      
      len = 0
      
      PushListPosition(ParsePBObject())
      With ParsePBObject()
         ForEach ParsePBObject()
            ;         Object = ParsePBObject()\Object ; *struct\get(ParsePBObject()\Object$)\Object
            ;         
            ;         If IsWindow(Object)
            ;           \x$ = Str(WindowX(Object))
            ;           \y$ = Str(WindowY(Object))
            ;           \width$ = Str(WindowWidth(Object))
            ;           \height$ = Str(WindowHeight(Object))
            ;          ; \Caption$ = GetWindowTitle(Object)
            ;         EndIf
            ;         If IsGadget(Object)
            ;           \x$ = Str(GadgetX(Object))
            ;           \y$ = Str(GadgetY(Object))
            ;           \width$ = Str(GadgetWidth(Object))
            ;           \height$ = Str(GadgetHeight(Object))
            ;          ; \Caption$ = GetGadgetText(Object)
            ;         EndIf
            
            result$ = PC_Content(ParsePBObject())
            ;Debug result$
            PC_Change(0, result$) 
         Next
      EndWith
      PopListPosition(ParsePBObject())
      
      
      ; PC_Update()
      ;Debug *struct\Content\Text$
      
      ;     If CreateFile(#File, *struct\Content\File$, #PB_UTF8)
      ;       WriteStringFormat(#File, #PB_UTF8)
      ;       WriteString(#File, *struct\Content\Text$, #PB_UTF8)
      ;       CloseFile(#File)
      ;       
      ;       Debug "..успешно"
      ;     Else
      ;       MessageRequester("Information","may not create the file!")
      ;     EndIf
   EndIf
   
   ProcedureReturn Bool(*struct\Content\File$)
EndProcedure

;-
Procedure WE_Open(ParentID=0, Flag.i=#PB_Window_SystemMenu)
   If Not IsWindow(WE)
      WE = 55
      OpenWindow(55, 100, 100, 900, 600, "(WE) - Редактор объектов", Flag, ParentID)
      StickyWindow(WE, #True)
      
      WE_Menu_0 = CreateMenu(#PB_Any, WindowID(WE))
      If WE_Menu_0
         MenuTitle("Project")
         MenuItem(WE_Menu_New, "New"         +Chr(9)+"Ctrl+N")
         MenuItem(WE_Menu_Open, "Open"       +Chr(9)+"Ctrl+O")
         MenuItem(WE_Menu_Save, "Save"       +Chr(9)+"Ctrl+S")
         MenuItem(WE_Menu_Save_as, "Save as" +Chr(9)+"Ctrl+A")
         MenuBar()
         MenuItem(WE_Menu_Settings, "Preferences..."      )
         MenuBar()
         MenuItem(WE_Menu_Code, "Code"       +Chr(9)+"Ctrl+C")
         MenuItem(WE_Menu_Quit, "Quit"     +Chr(9)+"Ctrl+Q")
      EndIf
      
      WE_Selecting = TreeGadget(#PB_Any, 5, 5, 315, 145);, #PB_Tree_AlwaysShowSelection)
      WE_Panel_0 = PanelGadget(#PB_Any, 5, 159, 315, 261)
      
      AddGadgetItem(WE_Panel_0, -1, "Objects", ImageID(img_add_objects))
      WE_Objects = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
      ;EnableGadgetDrop(WE_Objects, #PB_Drop_Text, #PB_Drag_Copy)
      
      AddGadgetItem(WE_Panel_0, -1, "Properties", ImageID(img_edit))
      
      WE_Properties = Properties::Gadget( #PB_Any, 315, 261 )
      Properties_ID = Properties::AddItem( WE_Properties, "ID:", #PB_GadgetType_String | #PB_GadgetType_CheckBox )
      Properties_Caption = Properties::AddItem( WE_Properties, "Text:", #PB_GadgetType_String )
      Properties::AddItem( WE_Properties, "Disable:False|True", #PB_GadgetType_ComboBox )
      Properties::AddItem( WE_Properties, "Hide:False|True", #PB_GadgetType_ComboBox )
      
      Properties::AddItem( WE_Properties, "Layouts:", #False )
      Properties_X = Properties::AddItem( WE_Properties, "X:", #PB_GadgetType_Spin )
      Properties_Y = Properties::AddItem( WE_Properties, "Y:", #PB_GadgetType_Spin )
      Properties_Width = Properties::AddItem( WE_Properties, "Width:", #PB_GadgetType_Spin )
      Properties_Height = Properties::AddItem( WE_Properties, "Height:", #PB_GadgetType_Spin )
      
      Properties::AddItem( WE_Properties, "Other:", #False )
      Properties_Flag = Properties::AddItem( WE_Properties, "Flag:", #PB_GadgetType_Tree|#PB_GadgetType_Button )
      Properties::AddItem( WE_Properties, "Font:", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties_Image = Properties::AddItem( WE_Properties, "Image:", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( WE_Properties, "Puth", #PB_GadgetType_String|#PB_GadgetType_Button )
      Properties::AddItem( WE_Properties, "Color:", #PB_GadgetType_String|#PB_GadgetType_Button )
      
      ; ;     UseModule Properties
      ; ;     WE_Properties = Gadget( 0,0,315, 261 )
      ; ;     
      ; ;     Add( WE_Properties, "Main:" )
      ; ;     Properties_ID = Add( WE_Properties, "ID:", #Type_String | #Type_CheckBox )
      ; ;     Properties_Caption = Add( WE_Properties, "Text:", #Type_String )
      ; ;     Add( WE_Properties, "Disable:False|True", #Type_ComboBox )
      ; ;     Add( WE_Properties, "Hide:False|True", #Type_ComboBox )
      ; ;     
      ; ;     Add( WE_Properties, "Layouts:" )
      ; ;     Properties_Dock = Add( WE_Properties, "Dock:None|Left|Top|Right|Bottom|Full", #Type_ComboBox )
      ; ;     Properties_Align = Add( WE_Properties, "Align:Left|Top|Right|Bottom", #Type_Tree|#Type_Button )
      ; ;     Properties_X = Add( WE_Properties, "X:", #Type_Spin )
      ; ;     Properties_Y = Add( WE_Properties, "Y:", #Type_Spin )
      ; ;     Properties_Width = Add( WE_Properties, "Width:", #Type_Spin )
      ; ;     Properties_Height = Add( WE_Properties, "Height:", #Type_Spin )
      ; ;     
      ; ;     Add( WE_Properties, "Other:" )
      ; ;     Properties_Flag = Add( WE_Properties, "Flag:", #Type_Tree|#Type_Button )
      ; ;     Add( WE_Properties, "Font:", #Type_String|#Type_Button )
      ; ;     Properties_Image = Add( WE_Properties, "Image:", #Type_String|#Type_Button )
      ; ;     Add( WE_Properties, "Puth", #Type_String|#Type_Button )
      ; ;     Add( WE_Properties, "Color:", #Type_String|#Type_Button )
      ; ;     
      ; ;     UnuseModule Properties
      
      ; 
      AddGadgetItem(WE_Panel_0, -1, "Events")
      CloseGadgetList()
      
      WE_Splitter_0 = SplitterGadget(#PB_Any, 5, 5, 900-10, 600-MenuHeight()-10, WE_Selecting, WE_Panel_0, #PB_Splitter_FirstFixed)
      SetGadgetState(WE_Splitter_0, 165)
      
      WE_Panel_1 = PanelGadget(#PB_Any, 5, 159, 315, 261)
      
      ;     AddGadgetItem(WE_Panel_1, -1, "Form", ImageID(img_objects))
      ;     CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ;       WE_ScrollArea_0 = MDIGadget(#PB_Any, 0, 0, 150, 150, 0, 0)
      ;       UseGadgetList(WindowID(WE)) ; вернёмся к списку гаджетов главного окна
      ;       
      ;     CompilerElse 
      ;       WE_ScrollArea_0 = ScrollAreaGadget(#PB_Any, 0, 0, 150, 150, 900, 800)
      ;       SetGadgetColor(WE_ScrollArea_0, #PB_Gadget_BackColor, $BEBEBE)
      ;       CloseGadgetList()
      ;     CompilerEndIf
      
      AddGadgetItem(WE_Panel_1, -1, "Code", ImageID(img_code))
      ;     CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      ;       WE_Scintilla_0 = Scintilla::Gadget(#PB_Any, 0, 0, 420, 600, 0, "x86_scintilla.dll", "x86_SyntaxHilighting.dll")
      ;     CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
      ;       WE_Scintilla_0 = Scintilla::Gadget(#PB_Any, 0, 0, 420, 600, 0, "x64_scintilla.dll", "x64_SyntaxHilighting.dll")
      ;     CompilerEndIf
      ; InitScintilla()
      WE_Scintilla_0 = ScintillaGadget(#PB_Any, 0, 0, 420, 600, 0)
      CloseGadgetList()
      
      WE_Splitter_1 = SplitterGadget(#PB_Any, 5, 5, 900-10, 600-MenuHeight()-10, WE_Panel_1, WE_Splitter_0, #PB_Splitter_SecondFixed|#PB_Splitter_Vertical)
      SetGadgetState(WE_Splitter_1, 900-300)
      
      LoadControls()
      WE_Panel_0_Size()
      WE_Panel_1_Size()
      
      ;;;WE_OpenFile("Ссылкодел.pb")
      
      ;     BindEvent(#PB_Event_Menu, @WE_Events(), WE)
      ;     BindEvent(#PB_Event_Gadget, @WE_Events(), WE)
      BindEvent(#PB_Event_SizeWindow, @WE_Resize(), WE)
      
      BindGadgetEvent(WE_Panel_0, @WE_Panel_0_Size(), #PB_EventType_Resize)
      BindGadgetEvent(WE_Panel_1, @WE_Panel_1_Size(), #PB_EventType_Resize)
   EndIf
   
   ProcedureReturn WE
EndProcedure


Procedure WE_Panel_0_Size()
   Protected GadgetWidth = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemWidth)
   Protected GadgetHeight = GetGadgetAttribute(WE_Panel_0, #PB_Panel_ItemHeight)
   
   Select GetGadgetItemText(WE_Panel_0, GetGadgetState(WE_Panel_0))
      Case "Properties" : ResizeGadget(WE_Properties, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
      Case "Objects"  : ResizeGadget(WE_Objects, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
   EndSelect
EndProcedure

Procedure WE_Panel_1_Size()
   Protected GadgetWidth = GetGadgetAttribute(WE_Panel_1, #PB_Panel_ItemWidth)
   Protected GadgetHeight = GetGadgetAttribute(WE_Panel_1, #PB_Panel_ItemHeight)
   
   Select GetGadgetItemText(WE_Panel_1, GetGadgetState(WE_Panel_1))
      Case "Code" : ResizeGadget(WE_Scintilla_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
      Case "Form" 
         If IsGadget(WE_ScrollArea_0)
            ResizeGadget(WE_ScrollArea_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
         Else
            ResizeGadget(WE_Scintilla_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
         EndIf
   EndSelect
EndProcedure

Procedure WE_Resize()
   Protected WindowWidth = WindowWidth(WE)
   Protected WindowHeight = WindowHeight(WE)-MenuHeight()
   
   ResizeGadget(WE_Splitter_1, 5, 5, WindowWidth - 10, WindowHeight - 10)
   WE_Panel_1_Size()
   WE_Panel_0_Size()
EndProcedure

Procedure WE_Close()
   Protected Result = #PB_Event_CloseWindow
   
   If *struct\Content\Text$
      Select MessageRequester("WE", "Файл не был сохранен. Сохранить его сейчас?", #PB_MessageRequester_YesNo|#PB_MessageRequester_Warning) 
         Case #PB_MessageRequester_Yes
            ProcedureReturn PostEvent(#PB_Event_Menu, WE, WE_Menu_Save_as, #PB_All, #PB_Event_CloseWindow)
            
         Case #PB_MessageRequester_Cancel
            ProcedureReturn #False
      EndSelect
   EndIf
   
   ProcedureReturn Result
EndProcedure

Procedure WE_Events(Event)
   Protected I, File$, SubItem, UseGadgetList
   Protected IsContainer.b, Object, Parent=-1
   
   Select Event 
         ;- Close(Event)
      Case #PB_Event_CloseWindow
         
         ProcedureReturn WE_Close()
         
         ;- Gadget(Event)
      Case #PB_Event_Gadget 
         Select EventGadget()
            Case WE_Panel_0
               
               If EventType() = #PB_EventType_Change
                  Object = GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting))
                  
                  If GetGadgetText(EventGadget())="Events"
                     ;WE_SaveFile("Test_4.pb")
                     Debug ""
                     PushListPosition(ParsePBObject())
                     ForEach ParsePBObject()
                        Debug ParsePBObject()\Object$ +" "+ *struct\get(ParsePBObject()\Object$)\Code("Code_Function")\Position 
                        
                        Debug ParsePBObject()\Content\String$
                        Debug ParsePBObject()\Content\Text$
                        
                        Debug "  Code_Object" + *struct\get("Code")\Code("Code_Object")\Position
                        Debug "  Code_Function" + *struct\get(*struct\get(Str(ParsePBObject()\parent))\Object$)\Code("Code_Function")\Position
                        
                     Next
                     PopListPosition(ParsePBObject())
                  EndIf
               EndIf
               
            Case Properties_Image
               
               Select EventType()
                  Case #PB_EventType_LeftClick     
                     W_IH_Open(WindowID(EventWindow()), #PB_Window_SystemMenu|#PB_Window_WindowCentered)
                     
               EndSelect
               
            Case Properties_Flag,
                 Properties_Caption,
                 Properties_X,
                 Properties_Y,
                 Properties_Width,
                 Properties_Height
               
               Select EventType()
                  Case #PB_EventType_Change     
                     Object = GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting))
                     
                     CO_Update(Object, EventGadget())
                     
               EndSelect
               
            Case Properties_ID
               
               Select EventType()
                  Case #PB_EventType_StatusChange
                     If change_current_object_from_class(GetGadgetText(WE_Selecting))
                        ;Debug GetGadgetText(WE_Selecting)
                        Debug ParsePBObject()\Object$  
                        ;PC_Destroy()
                        ;                 PC_Change(Indent)
                        
                        ;{ Remove string
                        ; Это значить удаляем строки
                        ; Для этого ищем идентификатор 
                        ; (перечисление через два пробела) (переменые через длину "Global ") 
                        Protected Identific$
                        If Asc(ParsePBObject()\Object$)='#'
                           Identific$ = #CRLF$+Space(Len("  "))+ParsePBObject()\Object$
                        Else
                           Identific$ = ","+#CRLF$+Space(Len("Global "))+ParsePBObject()\Object$+"=-1"
                        EndIf
                        
                        Protected RegExID = CreateRegularExpression(#PB_Any, Identific$)
                        Protected delete_len = Len(Identific$)
                        
                        If RegExID
                           *struct\get("Code")\Code("Code_Object")\Position - delete_len
                           *struct\Content\Text$ = ReplaceRegularExpression(RegExID, *struct\Content\Text$, "")
                           FreeRegularExpression(RegExID)
                        EndIf
                        ;}
                        
                        WE_Code_Show(*struct\Content\Text$)
                     EndIf
                     WE_Replace_ID(WE_Selecting)
                     
                     ;               ; Меняем map ключ объекта
                     ;               CopyStructure(*struct\get(GetGadgetText(WE_Selecting)), *struct\get(GetGadgetText(Properties_ID)), ObjectStruct)
                     ;               ; И удаляем старый
                     ;               DeleteMapElement(*struct\get(), GetGadgetText(WE_Selecting))
                     ;               SetGadgetText(WE_Selecting, GetGadgetText(Properties_ID))
                     ;     
                     ;               If change_current_object_from_class(GetGadgetText(Properties_ID))
                     ;                 ParsePBObject()\Object$ = GetGadgetText(Properties_ID)
                     ;                 Debug ParsePBObject()\Object$  
                     ;               EndIf
                     
                  Case #PB_EventType_Change      
                     ;Case #PB_EventType_LostFocus
                     Debug 88888888888888
                     WE_Replace_ID(WE_Selecting)
                     
               EndSelect
               
            Case WE_Selecting
               
               Select EventType()
                  Case #PB_EventType_RightClick    
                     Object = GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting))
                     
                     Transformation::DisplayMenu(Object)
                     
                  Case #PB_EventType_Change     
                     Object = GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting))
                     
                     CO_Change(Object)
                     
               EndSelect
               
            Case WE_Objects
               
               Select EventType()
                  Case #PB_EventType_DragStart
                     DragText(GetGadgetItemText(WE_Objects, GetGadgetState(WE_Objects)))
                     
                  Case #PB_EventType_LeftClick
                     DragText = GetGadgetItemText(WE_Objects, GetGadgetState(WE_Objects))
                     
               EndSelect
               
         EndSelect
         
         ;- Menu(Event) 
      Case #PB_Event_Menu
         
         Select EventMenu()
            Case WE_Menu_Settings
               Preferences_Open(WindowID(EventWindow()), #PB_Window_WindowCentered)
               ;           SetGadgetState(Preferences_Container_0_CheckBox_0, state_id)
               ;           SetGadgetState(Preferences_Container_0_CheckBox_1, state_caption)
               ;           SetGadgetState(Preferences_Container_0_CheckBox_2, state_class)
               
            Case WE_Menu_Quit
               End
               
            Case WE_Menu_Delete ;- Event(_WE_Menu_Delete_) 
                                ; Debug EventGadget()
               CO_Free(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
               
            Case WE_Menu_Open ;- Event(_WE_Menu_Open_) 
               WE_OpenFile(OpenFileRequester("Выберите файл с описанием окон", *struct\Content\File$, "Все файлы|*", 0))
               
            Case WE_Menu_Save_as ;- Event(_WE_Menu_Save_as_) 
               If Not WE_SaveFile("Test_0.pb") ; SaveFileRequester("Сохранить файл как ..", *struct\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
                  MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
               EndIf
               ProcedureReturn EventData()
               
            Case WE_Menu_Save ;- Event(_WE_Menu_Save_) 
               If Not WE_SaveFile(*struct\Content\File$)
                  If Not WE_SaveFile(SaveFileRequester("Сохранить файл как ..", *struct\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
                     MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
                  EndIf
               EndIf
               
            Case WE_Menu_New ;- Event(_WE_Menu_New_)
               CO_Create("Window",30,30, WE_ScrollArea_0)
               ;CO_Create("Window",30,30)
               
               ;           WE_OpenFile("Window_0.pb")
               
               
               SetGadgetState(WE_Panel_0, 0)
               
               
         EndSelect
         
   EndSelect
   
   ProcedureReturn Event
EndProcedure

;- 
CompilerIf #PB_Compiler_IsMainFile
   ; Инициализация окна редактора
   WE_Open(#False, #PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
   
   If CountProgramParameters()=1 
      WE_OpenFile(ProgramParameter(0))
   EndIf
   
   
   WE_OpenFile("C:\Users\user\Documents\GitHub\widget\IDE\test\open\splitter.pb")
   
   While IsWindow(WE)
      Define Event = WaitWindowEvent()
      
      Select EventWindow()
            ; Editor 
         Case WE
            If WE_Events( Event ) = #PB_Event_CloseWindow
               CloseWindow(WE)
               Break
            EndIf
            
            ; Settings helper  
         Case Preferences
            If Preferences_Events( Event ) = #PB_Event_CloseWindow
               ;           state_id = GetGadgetState(Preferences_Container_0_CheckBox_0)
               ;           state_caption = GetGadgetState(Preferences_Container_0_CheckBox_1)
               ;           state_class = GetGadgetState(Preferences_Container_0_CheckBox_2)
               
               CloseWindow(Preferences)
            EndIf
            
            ; Image helper 
         Case W_IH
            If W_IH_Events( Event ) = #PB_Event_CloseWindow
               
               CloseWindow(W_IH)
            EndIf
            
            ; Splitter helper 
         Case W_SH
            If W_SH_Events( Event ) = #PB_Event_CloseWindow
               DisableWindow(WE, #False)
               DisableWindow(W_SH_Parent, #False)
               
               Define Gadget1.String, Gadget2.String, Flag.String
               If W_SH_Return(@Gadget1, @Gadget2, @Flag)
                  ;           Debug "Gadget1 "+Gadget1\s
                  ;           Debug "Gadget2 "+Gadget2\s
                  If Not get_object_id(Gadget1\s)
                     CO_Create(Gadget1\s, W_SH_MouseX, W_SH_MouseY, W_SH_Object)
                     Define First$ = *struct\Object$
                  EndIf
                  If Not get_object_id(Gadget2\s)
                     CO_Create(Gadget2\s, W_SH_MouseX, W_SH_MouseY, W_SH_Object)
                     Define Second$ = *struct\Object$
                  EndIf
                  
                  *struct\Param1$ = First$
                  *struct\Param2$ = Second$
                  *struct\flag$ = Flag\s
                  CO_Create("splitter", W_SH_MouseX, W_SH_MouseY, W_SH_Object)
                  
               EndIf
               
               CloseWindow(W_SH)
            EndIf
            
      EndSelect
   Wend
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 569
; FirstLine = 593
; Folding = ---------------------------------------------4---f4v8-------------------------
; EnableXP