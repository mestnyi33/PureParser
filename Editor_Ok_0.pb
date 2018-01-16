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
EnableExplicit

;-
;- INCLUDE
XIncludeFile "include/Img.pbi"
XIncludeFile "include/Constant.pbi"
XIncludeFile "include/Caret.pbi"
XIncludeFile "include/Disable.pbi"
XIncludeFile "include/Resize.pbi"
XIncludeFile "include/Hide.pbi"
XIncludeFile "include/Flag.pbi"
XIncludeFile "include/Properties.pbi"
XIncludeFile "include/Transformation.pbi"
XIncludeFile "include/wg.pbi"

; helpers
XIncludeFile "include/Helper/Splitter.pbi"
XIncludeFile "include/Helper/Image.pbi"

XIncludeFile "include/Scintilla.pbi"
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
       WE_Menu_Code=7

;-
;- DECLARE
Declare WE_Events(Event)
Declare WE_Resize()
Declare WE_Panel_0_Size()
Declare WE_Panel_1_Size()
Declare WE_Position_Selecting(Gadget, Parent)
Declare WE_Update_Selecting(Gadget, Position=-1)
Declare WE_Open(ParentID=0, Flag.i=#PB_Window_SystemMenu)

Declare$ GetObjectClass(Object)
Declare PC_Free(Object.i)

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

;-
Macro is_object(_object_)
  Bool(IsGadget(_object_) | IsWindow(_object_))
EndMacro

Macro get_object_id(_class_)
  *This\get(_class_)\Object\Argument
EndMacro

Macro get_object_class(_object_)
  *This\get(Str(_object_))\Class\Argument$
EndMacro

Macro get_object_type(_object_)
  *This\get(Str(_object_))\Type\Argument$
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

Macro get_object_count(_object_)
  *This\get(Str(get_object_parent(_object_))+"_"+get_object_type(_object_))\Count
EndMacro

Macro get_argument_string(_string_)
  GetArguments(_string_, #RegEx_Pattern_Function, 2)
EndMacro

Macro change_current_object_from_class(_class_)
  ChangeCurrentElement(ParsePBObject(), *This\get(_class_)\Adress)
EndMacro

Macro change_current_object_from_id(_object_)
  change_current_object_from_class(Str(_object_))
EndMacro


; Macro is_container(Object)
;   *This\get(Str(Object))\container)
; EndMacro

;-
;- STRUCTURE
Structure ArgumentStruct
  Argument.i 
  Argument$
  DefArgument$
EndStructure

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
  
  Type.ArgumentStruct   ; Type\Argument$ = OpenWindow;ButtonGadget;TextGadget
  Class.ArgumentStruct  ; Class\Argument$ = Window_0;Button_0;Text_0
  Object.ArgumentStruct ; Object\Argument$ = Window_0;Window_0_Button_0;Window_0_Text_0
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

Structure ParseStruct Extends ObjectStruct
  Item.i
  SubLevel.i ; 
  Container.i
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
  ;Map Code.ContentStruct()
  
  Args$
EndStructure

Structure ThisStruct Extends ParseStruct
  Map get.ObjectStruct()
EndStructure

Global NewList ParsePBObject.ParseStruct() 
Global *This.ThisStruct = AllocateStructure(ThisStruct)
;
*This\Index=-1
; *This\Item=-1

Global Indent = 2
#Window$ = "W_"   
#Gadget$ = "G_"   

;-
;- ENUMERATION
;#RegEx_Pattern_Others1 = ~"[\\^\\;\\/\\|\\!\\*\\w\\s\\.\\-\\+\\~\\#\\&\\$\\\\]"
#RegEx_Pattern_Quotes = ~"(?:\"(.*?)\")" ; - Находит Кавычки
#RegEx_Pattern_Others = ~"(?:[\\s\\^\\|\\!\\~\\&\\$])" ; Находим остальное
#RegEx_Pattern_Match = ~"(?:([\\/])|([\\*])|([\\-])|([\\+]))" ; Находит (*-+/)
;#RegEx_Pattern_Function = ~"(?:(\\w*)\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
#RegEx_Pattern_Function = ~"(?:(\\b[A-Za-z_]\\w+)?\\s*\\(((?>[^()]|(?R))*)\\))" ; - Находит функции
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
Procedure WE_Code_Show(Text$)
  Scintilla::SetText(WE_Scintilla_0, Text$)
EndProcedure


Procedure$ GetStr1(String$)
  Protected Result$, Object, Index, Value.f, Param1, Param2, Param3, Param1$
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
            Object = (*This\get(RegularExpressionGroup(#RegEx_Captions1, 3))\Object\Argument)
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
            Object = (*This\get(RegularExpressionGroup(#RegEx_Captions, 3))\Object\Argument)
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
;- PARSER_CODE
Procedure PC_Add(*This.ParseStruct, Index)
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

Procedure PC_Set(*ThisParse.ParseStruct)
  Protected Result, I, Object
  
  With *ThisParse ; 
    Object = *This\get(\Object\Argument$)\Object\Argument
    
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
    
    If IsWindow(Object)
      Select \Type\Argument$
        Case "SetActiveWindow"         : SetActiveWindow(Object)
        Case "HideWindow"              : HideWindow(Object, \Param1\Argument)
        Case "DisableWindow"           : DisableWindow(Object, \Param1\Argument)
      EndSelect
    EndIf
    
    If IsGadget(Object)
      Select \Type\Argument$
        Case "SetActiveGadget"         : SetActiveGadget(Object)
        Case "HideGadget"              : HideGadget(Object, \Param1\Argument)
        Case "DisableGadget"           : DisableGadget(Object, \Param1\Argument)
        Case "SetGadgetText"           : SetGadgetText(Object, \Param1\Argument$)
        Case "SetGadgetColor"          : SetGadgetColor(Object, \Param1\Argument, \Param2\Argument)
          
        Case "SetGadgetFont"
          Protected Font = \Font(\Param1\Argument$)\Object\Argument
          If IsFont(Font)
            SetGadgetFont(Object, FontID(Font))
          EndIf
          
        Case "SetGadgetState"
          Protected Img = \Img(\Param1\Argument$)\Object\Argument
          If IsImage(Img)
            SetGadgetState(Object, ImageID(Img))
          EndIf
          
        Case "ResizeGadget"
          ResizeGadget(Object, \X\Argument, \Y\Argument, \Width\Argument, \Height\Argument)
          Transformation::Update(Object)
          
      EndSelect
    EndIf
  EndWith
  
EndProcedure



Procedure$ PC_Content() ; Ok
  Protected ID$, Handle$, Result$
  
  With ParsePBObject()
    If Asc(\Object\Argument$) = '#'
      ID$ = \Object\Argument$
    Else
      Handle$ = \Object\Argument$+" = "
      ID$ = "#PB_Any"
    EndIf
    
    Select \Type\Argument$
        Case "OpenWindow", "WindowGadget" : Result$ = Handle$+"OpenWindow("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                            : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ButtonGadget"        : Result$ = Handle$+"ButtonGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                 : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "StringGadget"        : Result$ = Handle$+"StringGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                 : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "TextGadget"          : Result$ = Handle$+"TextGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                   : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "CheckBoxGadget"      : Result$ = Handle$+"CheckBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                               : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
      Case "OptionGadget"        : Result$ = Handle$+"OptionGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ListViewGadget"      : Result$ = Handle$+"ListViewGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                        : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "FrameGadget"         : Result$ = Handle$+"FrameGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                  : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ComboBoxGadget"      : Result$ = Handle$+"ComboBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                        : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ImageGadget"         : Result$ = Handle$+"ImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                                                   : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "HyperLinkGadget"     : Result$ = Handle$+"HyperLinkGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                                       : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ContainerGadget"     : Result$ = Handle$+"ContainerGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                       : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ListIconGadget"      : Result$ = Handle$+"ListIconGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                                        : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
      Case "IPAddressGadget"     : Result$ = Handle$+"IPAddressGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$
        Case "ProgressBarGadget"   : Result$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                      : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollBarGadget"     : Result$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$+", "+\Param3\Argument$                                                 : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollAreaGadget"    : Result$ = Handle$+"ScrollAreaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$    : If \Param3\Argument$ : Result$ +", "+\Param3\Argument$ : EndIf : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf 
        Case "TrackBarGadget"      : Result$ = Handle$+"TrackBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                         : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
      Case "WebGadget"           : Result$ = Handle$+"WebGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ButtonImageGadget"   : Result$ = Handle$+"ButtonImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                                             : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "CalendarGadget"      : Result$ = Handle$+"CalendarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                     : If \Param1\Argument$ : Result$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "DateGadget"          : Result$ = Handle$+"DateGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                : If \Param1\Argument$ : Result$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "EditorGadget"        : Result$ = Handle$+"EditorGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                          : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerListGadget"  : Result$ = Handle$+"ExplorerListGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                           : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerTreeGadget"  : Result$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                           : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerComboGadget" : Result$ = Handle$+"ExplorerComboGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                          : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "SpinGadget"          : Result$ = Handle$+"SpinGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                             : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "TreeGadget"          : Result$ = Handle$+"TreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                            : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
      Case "PanelGadget"         : Result$ = Handle$+"PanelGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$ 
        Case "SplitterGadget"      : Result$ = Handle$+"SplitterGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                         : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
        Case "MDIGadget"           : Result$ = Handle$+"MDIGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                                              : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf 
      Case "ScintillaGadget"     : Result$ = Handle$+"ScintillaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
      Case "ShortcutGadget"      : Result$ = Handle$+"ShortcutGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
        Case "CanvasGadget"        : Result$ = Handle$+"CanvasGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                                                          : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
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
      ; Это значить меняем строки
      Identific$ = \Content\String$
      delete_len = \Content\Length
      \Content\String$ = Replace$
      \Content\Length = Len( Replace$ )
      delete_len-\Content\Length
    Else
      ;{ Remove string
      ; Это значить удаляем строки
      ; Для этого ищем идентификатор 
      ; TODO Пока надо укаать явно отступ в коде 
      ; (перечисление через два пробела) (переменые через длину "Global ") 
      If Asc(\Object\Argument$)='#'
        Identific$ = #CRLF$+Space(Len("  "))+\Object\Argument$
      Else
        Identific$ = ","+#CRLF$+Space(Len("Global "))+\Object\Argument$+"=-1"
      EndIf
      
      RegExID = CreateRegularExpression(#PB_Any, Identific$)
      delete_len = Len(Identific$)
      
      If RegExID
        *This\get("Code")\Code("Code_Object")\Position - delete_len
        *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, "")
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
          *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position - delete_len
        EndIf
      Next
      PopListPosition(ParsePBObject())
      
      *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Replace$)
      FreeRegularExpression(RegExID)
    EndIf
  EndWith
  
EndProcedure

Procedure PC_Destroy()
  With ParsePBObject()
    PC_Change(Indent)
    
;
;     *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count-1 
;     If *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count =< 0
;       DeleteMapElement(*This\get(), Str(\Parent\Argument)+"_"+\Type\Argument$)
;     EndIf
    
    DeleteMapElement(*This\get(), \Object\Argument$)
    DeleteMapElement(*This\get(), Str(\Object\Argument))
    DeleteElement(ParsePBObject())
    
  EndWith
EndProcedure

Procedure PC_Free(Object.i)
  
  If ListSize(ParsePBObject())
    With ParsePBObject()
      ; Если есть дети, работаем над детми
      If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
        If \Container
          ForEach ParsePBObject()
            If \Parent\Argument = Object 
              If \Container
                PC_Free(\Object\Argument)
                
              Else
                PC_Destroy()
                
              EndIf
            EndIf
          Next
        EndIf
      EndIf
      
      ; Удаляем строки объекта из кода 
      If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
        PC_Destroy()
      EndIf
    EndWith  
  EndIf
  
EndProcedure

Macro PC_Update(_object_=-1)
  PushListPosition(ParsePBObject())
  ForEach ParsePBObject() 
    PC_Change(Indent, PC_Content()) 
  Next
  PopListPosition(ParsePBObject())
  
  WE_Code_Show(*This\Content\Text$)
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
        String$ = GetArguments(*This\Content\Text$, "(?:(\w+)\s*\(.*)?"+String$+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2)
        
        Flag$+String$+"|"
    EndSelect
  Next
  
  ProcedureReturn Flag::Value(Trim(Flag$, "|"))
EndProcedure

Procedure CO_Init(Object.i)
  PushListPosition(ParsePBObject())
  Protected *Adress = *This\get(Str(Object))\Adress
  If *Adress And ChangeCurrentElement(ParsePBObject(), *Adress)
    With ParsePBObject()
      Transformation::Create(wgParent(Object), \Parent\Argument, \Window\Argument, \Item, 5)
      If IsGadget(Object) And GadgetType(Object) = #PB_GadgetType_Splitter
        Transformation::Free(GetGadgetAttribute(Object, #PB_Splitter_FirstGadget))
        Transformation::Free(GetGadgetAttribute(Object, #PB_Splitter_SecondGadget))
      EndIf
      Properties::Init(Object, \Object\Argument$, \Flag\Argument$)
    EndWith
  EndIf
  PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Change(Object.i)
  PushListPosition(ParsePBObject())
  
  Protected *Adress = *This\get(Str(Object))\Adress
  If *Adress And ChangeCurrentElement(ParsePBObject(), *Adress)
    With ParsePBObject()
      Properties::Init(Object, \Object\Argument$, \Flag\Argument$)
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
  
  WE_Code_Show(*This\Content\Text$)
  
EndProcedure

Procedure CO_Update(Object, Gadget)
  
  PushListPosition(ParsePBObject())
  If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
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
          \Caption\Argument$ = GetGadgetText(Gadget)
        Case Properties_X       
          \X\Argument$ = GetGadgetText(Gadget)
        Case Properties_Y       
          \Y\Argument$ = GetGadgetText(Gadget)
        Case Properties_Width   
          \Width\Argument$ = GetGadgetText(Gadget)
        Case Properties_Height  
          \Height\Argument$ = GetGadgetText(Gadget)
        Case Properties_Flag    
          \Flag\Argument$ = GetGadgetText(Gadget)
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
      
    Case #PB_Event_WindowDrop, #PB_Event_GadgetDrop
      If EventDropText() = "Splitter"
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
            GadgetList(ListIndex(ParsePBObject())) = ParsePBObject()\Object\Argument$
          EndIf
        Next
        PopListPosition(ParsePBObject())
        W_SH_Load(GadgetList())
        
      Else
        CO_Create(ReplaceString(EventDropText(), "gadget", ""),
                  WindowMouseX(EventWindow()), WindowMouseY(EventWindow()), Object)
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
      *This\get("Code")\Code("Code_Object")\Position = 16
    EndIf
    
    If Asc(\Object\Argument$)='#'
      Select ListSize(ParsePBObject()) 
        Case 1, 2
          Select ListSize(ParsePBObject()) 
            Case 1 : Variable$ = #CRLF$+"Enumeration Window"
            Case 2 : Variable$ = #CRLF$+#CRLF$+"Enumeration Gadget"
          EndSelect
          
          Variable$ + #CRLF$+"EndEnumeration"
          VariableLength = Len(Variable$)
          
          *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, 
                                             *This\get("Code")\Code("Code_Object")\Position) 
          *This\get("Code")\Code("Code_Object")\Position + VariableLength
          
          If VariableLength
            PushListPosition(ParsePBObject())
            ForEach ParsePBObject()
              If ParsePBObject()\Container 
                *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position + VariableLength
              EndIf
            Next
            PopListPosition(ParsePBObject())
          EndIf
      EndSelect
      
      Variable$ = #CRLF$+Space(Indent)+\Object\Argument$
      
    Else
      If \Type\Argument$ = "OpenWindow"
        If ListSize(ParsePBObject()) = 1
          Variable$ = #CRLF$+"Global "+\Object\Argument$+"=-1"
        Else
          Variable$ = #CRLF$+#CRLF$+"Global "+\Object\Argument$+"=-1"
        EndIf
      Else
        Variable$ = ","+#CRLF$+Space(Len("Global "))+\Object\Argument$+"=-1"
      EndIf
    EndIf
    
    VariableLength = Len(Variable$)
    
    Debug "  Code_Object" + *This\get("Code")\Code("Code_Object")\Position
    If Asc(\Object\Argument$)='#'
      *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, 
                                         *This\get("Code")\Code("Code_Object")\Position - Len(#CRLF$+"EndEnumeration")) 
    Else
      *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, 
                                         *This\get("Code")\Code("Code_Object")\Position) 
    EndIf
    
    *This\get("Code")\Code("Code_Object")\Position + VariableLength
    
    If ListSize(ParsePBObject()) = 1
      If Asc(\Object\Argument$)='#'
        *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Function")\Position = 297+*This\get("Code")\Code("Code_Object")\Position
      Else
        *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Function")\Position = 290+*This\get("Code")\Code("Code_Object")\Position
      EndIf
    EndIf
    
    Debug "  Insert Code_Function" + *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Function")\Position
    \Content\Position = *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Function")\Position + VariableLength
    
    If VariableLength
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position + VariableLength
        EndIf
      Next
      PopListPosition(ParsePBObject())
    EndIf
    
    \Content\String$ = PC_Content()
    \Content\Length = Len(\Content\String$)
    
    *This\Content\Length = \Content\Length
    *This\Content\Position = \Content\Position
    
    *This\Content\Text$ = InsertString(*This\Content\Text$, \Content\String$+#CRLF$+Space(Indent), \Content\Position) 
    
    
    ; У окна меняем последную позицию.
    *This\get(*This\Window\Argument$)\Code("Code_Function")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
    
    ; 
    ; Сохряняем у объект-а последную позицию.
    *This\get(\Object\Argument$)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
    
    If *This\Container
      Debug \Object\Argument$ +" "+ *This\get(\Object\Argument$)\Code("Code_Function")\Position 
      
      Select *This\Type\Argument$
        Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
          ; 
          *This\Content\Text$ = InsertString(*This\Content\Text$, "CloseGadgetList()"+#CRLF$+Space(Indent), *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))) 
          *This\Content\Position+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
          ; У окна меняем последную позицию.
          *This\get(*This\Window\Argument$)\Code("Code_Function")\Position + Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
      EndSelect
      
    Else
      If IsGadget(Parent)
        PushListPosition(ParsePBObject())
        ForEach ParsePBObject()
          ; Проверяем позицию объекта в генерируемом коде
          ; Если расположен ниже (то есть позиция больше), то добавляем длину текущего объекта
          If *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position>*This\Content\Position
            *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
          EndIf
        Next
        PopListPosition(ParsePBObject())
      EndIf
    EndIf
    
    ; Записываем у родителя позицию конца добавления объекта
    *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
  EndWith
EndProcedure

Procedure CO_Create(Type$, X, Y, Parent=-1)
  Protected GadgetList
  Protected Object, Position
  Protected Buffer.s, BuffType$, i.i, j.i
  
  Protected Constant.s
  If GetGadgetText(Properties_ID)="#"
    Constant = "#"
  Else
    Constant = ""
  EndIf
 
  
  With *This
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
      \Parent\Argument =- 1
    EndIf
    
    Select Type$
      Case "WindowGadget" : \Type\Argument$ = "WindowGadget"
      Case "Window" : \Type\Argument$ = "OpenWindow"
      Case "Menu", "ToolBar" : \Type\Argument$ = Type$
      Default 
        \Type\Argument$=Type$ + "Gadget"
;         \Type\Argument$=ULCase(Type$) + "Gadget"
;         
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "box","Box")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "link","Link")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "bar","Bar")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "area","Area")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "Ipa","IPA")
;         
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "view","View")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "icon","Icon")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "image","Image")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "combo","Combo")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "list","List")
;         \Type\Argument$ = ReplaceString(\Type\Argument$, "tree","Tree")
    EndSelect
    
    Protected *ThisParse.ParseStruct = AddElement(ParsePBObject())
    If  *ThisParse
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
                ParsePBObject()\Type\Argument$=Buffer
                
                If Buffer = "OpenWindow"
                  \Class\Argument$=Constant+ReplaceString(Buffer, "Open","")+"_"
                ElseIf Buffer = "WindowGadget"
                  \Class\Argument$=Constant+ReplaceString(Buffer, "Gadget","")+"_"
                Else
                  \Class\Argument$=ReplaceString(Buffer, "Gadget","")+"_"
                EndIf
                
              Case 2 : ParsePBObject()\Width\Argument$=Buffer
              Case 3 : ParsePBObject()\Height\Argument$=Buffer
              Case 4 : ParsePBObject()\Param1\Argument$=Buffer
              Case 5 : ParsePBObject()\Param2\Argument$=Buffer
              Case 6 : ParsePBObject()\Param3\Argument$=Buffer
              Case 7 : ParsePBObject()\Flag\Argument$=Buffer
            EndSelect
          EndIf
        Next  
        BuffType$ = ""
      Next  
      
      If \Flag\Argument$
        ParsePBObject()\Flag\Argument$ = \Flag\Argument$
      EndIf
      
      \Flag\Argument=CO_Flag(ParsePBObject()\Flag\Argument$)
      \Class\Argument$+\get(Str(Parent)+"_"+\Type\Argument$)\Count
      \Caption\Argument$ = \Class\Argument$
      
      ; Формируем имя объекта
      ParsePBObject()\Class\Argument$ = \Class\Argument$
      If \get(Str(Parent))\Object\Argument$
        \Object\Argument$ = \get(Str(Parent))\Object\Argument$+"_"+\Class\Argument$
        ;\Object\Argument$ = #Gadget$+Trim(Trim(Trim(Trim(\get(Str(Parent))\Object\Argument$, "W"), "_"), "G"), "_")+"_"+\Class\Argument$
      Else
        \Object\Argument$ = \Class\Argument$
        ;\Object\Argument$ = #Window$+\Class\Argument$
        ParsePBObject()\Flag\Argument$="Flag"
      EndIf
      
      \X\Argument = X
      \Y\Argument = Y
      \Width\Argument = Val(ParsePBObject()\Width\Argument$)
      \Height\Argument = Val(ParsePBObject()\Height\Argument$)
      
      ParsePBObject()\X\Argument$ = Str(\X\Argument)
      ParsePBObject()\Y\Argument$ = Str(\Y\Argument)
      ParsePBObject()\Type\Argument$ = \Type\Argument$
      ParsePBObject()\Object\Argument$ = \Object\Argument$
      ParsePBObject()\Caption\Argument$ = \Caption\Argument$
      
      If \Type\Argument$ = "SplitterGadget"      
        \Param1\Argument = *This\get(\Param1\Argument$)\Object\Argument
        \Param2\Argument = *This\get(\Param2\Argument$)\Object\Argument
      EndIf
      
      ParsePBObject()\Param1\Argument$ = \Param1\Argument$
      ParsePBObject()\Param2\Argument$ = \Param2\Argument$
      ParsePBObject()\Param3\Argument$ = \Param3\Argument$
      ParsePBObject()\Param1\Argument = \Param1\Argument
      ParsePBObject()\Param2\Argument = \Param2\Argument
      ParsePBObject()\Param3\Argument = \Param3\Argument
      
      ; Сначала определять кто есть кто.
      Select \Type\Argument$
        Case "OpenWindow" 
          \Container =- 1 
          \Window\Argument$ = \Object\Argument$ 
          \Parent\Argument$ = \Object\Argument$
        Case "PanelGadget" 
          \Container = #PB_GadgetType_Panel
          \Parent\Argument$ = \Object\Argument$
        Case "ContainerGadget" 
          \Container = #PB_GadgetType_Container
          \Parent\Argument$ = \Object\Argument$
        Case "ScrollAreaGadget" 
          \Container = #PB_GadgetType_ScrollArea
          \Parent\Argument$ = \Object\Argument$
        Case "CanvasGadget"
          If ((\Flag\Argument&#PB_Canvas_Container)=#PB_Canvas_Container) 
            \Container = #PB_GadgetType_Canvas
            \Parent\Argument$ = \Object\Argument$
          EndIf
        Default
          \Container = #PB_GadgetType_Unknown
      EndSelect
      
      ; Загружаем выходной код
      If \Content\Text$=""
        Restore Content
        Read.s Buffer
        \Content\Text$ = Buffer
        
;         \get("Code")\Code("Code_Object")\Position = 16
;         
;         Protected Variable$, VariableLength
;         ;{
;         If Asc(\Object\Argument$)='#'
;           Variable$ = #CRLF$+"Enumeration Window"
;           Variable$ + #CRLF$+"EndEnumeration"
;           VariableLength = Len(Variable$)
;         Else
;           Variable$ = #CRLF$+"Global "
;           VariableLength = Len(Variable$)
;         EndIf
;         
;         *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, 
;                                            *This\get("Code")\Code("Code_Object")\Position) 
;         *This\get("Code")\Code("Code_Object")\Position + VariableLength
;         ;}
;         
;         \get(\get(Str(Parent))\Object\Argument$)\Code("Code_Function")\Position = 326+VariableLength
      EndIf
      
      CO_Insert(Parent) 
      \Parent\Argument = Parent
    EndIf
    
    Position = WE_Position_Selecting(WE_Selecting, Parent)
    
    Object=CallFunctionFast(@CO_Open())
    
    If IsGadget(Object)
      ;       Select \Type\Argument
      ;         Case #PB_GadgetType_Panel
      ;           ;OpenGadgetList(Object, 0)
      ;           AddGadgetItem(Object, -1, \Object\Argument$)
      ;       EndSelect
      
      Select GadgetType(Object)
        Case #PB_GadgetType_Panel, 
             #PB_GadgetType_Container, 
             #PB_GadgetType_ScrollArea
          CloseGadgetList()
      EndSelect
    EndIf
    
    WE_Update_Selecting(WE_Selecting, Position)
    
    
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
  Protected GetParent, OpenGadgetList, Object=-1
  Static AddGadget
  
  With *This
    ;
    Select \Type\Argument$
      Case "OpenWindow" : \Type\Argument =- 1  : \Window\Argument =- 1  
        If IsGadget(WE_ScrollArea_0)
          Select GadgetType(WE_ScrollArea_0)
            Case #PB_GadgetType_ScrollArea
              \Type\Argument$ = "WindowGadget"
              \X\Argument = 20
              \Y\Argument = 20+25
              \Parent\Argument = WE_ScrollArea_0
              OpenGadgetList(WE_ScrollArea_0)
              
              \Object\Argument = WindowGadget(#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument);, \Param1\Argument)
              \Flag\Argument | #PB_Canvas_Container
            Case #PB_GadgetType_MDI ; , \Flag\Argument, \Param1\Argument)
              \X\Argument = 20
              \Y\Argument = 20
              \Object\Argument = AddGadgetItem(WE_ScrollArea_0, #PB_Any, \Caption\Argument$, 0, \Flag\Argument) : ResizeWindow(\Object\Argument, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument)
              
          EndSelect
        Else
          \Object\Argument = OpenWindow          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument, \Param1\Argument)
       EndIf
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
        Debug "Splitter FirstGadget "+\Param1\Argument
        Debug "Splitter SecondGadget "+\Param2\Argument
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
      If \Object\Argument$=""
        \Object\Argument$=Str(\Object\Argument)
        ParsePBObject()\Object\Argument$=\Object\Argument$
      EndIf
      
      ParsePBObject()\Type\Argument = \Type\Argument
      ParsePBObject()\Object\Argument = \Object\Argument
      
      If ParsePBObject()\Parent\Argument<>\Parent\Argument
        If \get(Str(\Parent\Argument))\Object\Argument$
          \Parent\Argument$ = \get(Str(\Parent\Argument))\Object\Argument$
        EndIf
        ParsePBObject()\Parent\Argument=\Parent\Argument
        ParsePBObject()\Parent\Argument$=\Parent\Argument$
      EndIf
      If ParsePBObject()\Window\Argument<>\Window\Argument
        If \get(Str(\Window\Argument))\Object\Argument$
          \Window\Argument$ = \get(Str(\Window\Argument))\Object\Argument$
        EndIf
        ParsePBObject()\Window\Argument=\Window\Argument
        ParsePBObject()\Window\Argument$=\Window\Argument$
      EndIf
      
      ; TODO -----------------------------------------
      If IsWindow(\Object\Argument)
        \Parent\Argument =- 1
      EndIf
      
      Macro Init_object_data(_object_, _object_key_)
        If FindMapElement(*This\get(), _object_key_)
          *This\get(_object_key_)\Index=ListIndex(ParsePBObject())
          *This\get(_object_key_)\Adress=@ParsePBObject()
          
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
          *This\get()\Index=ListIndex(ParsePBObject())
          *This\get()\Adress=@ParsePBObject()
          
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
        \get()\Index=ListIndex(ParsePBObject())
        \get()\Adress=@ParsePBObject()
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
      Case "WindowGadget" : \Window\Argument = EventWindow() : \Parent\Argument = \Object\Argument : \Container = \Type\Argument : \SubLevel = 1
      Case "OpenWindow" : \Window\Argument = \Object\Argument : \Parent\Argument = \Object\Argument : \Container = \Type\Argument : \SubLevel = 1
      Case "ContainerGadget", "ScrollAreaGadget" : \Parent\Argument = \Object\Argument : \Container = \Type\Argument : \SubLevel + 1
      Case "PanelGadget" : \Parent\Argument = \Object\Argument : \Container = \Type\Argument : \SubLevel + 1 
        If IsGadget(\Parent\Argument) 
          \Item = GetGadgetData(\Parent\Argument) 
        EndIf
        
      Case "CanvasGadget"
        If ((\Flag\Argument & #PB_Canvas_Container)=#PB_Canvas_Container)
          \Parent\Argument = \Object\Argument : \SubLevel + 1
          \Container = \Type\Argument
        EndIf
        
      Case "UseGadgetList" 
        Debug "UseGadgetList( " + \Param1\Argument$ +" )"
        Debug "  "+*This\get(Str(\Param1\Argument))\Object\Argument$
        If IsWindow(\Param1\Argument) 
          \SubLevel = 1
          \Window\Argument = \Param1\Argument
          \Parent\Argument = \Window\Argument
          Debug "    " + GetWindowTitle(\Parent\Argument)
          UseGadgetList( WindowID(\Parent\Argument) )
        ElseIf IsGadget(\Param1\Argument) 
          Debug "    " + wgTitle(\Param1\Argument)
          \Parent\Argument = \Param1\Argument
          OpenGadgetList(\Parent\Argument)
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
        
      Default
        \Container = #PB_GadgetType_Unknown
        
    EndSelect
    
    ;
    If IsGadget(\Parent\Argument)
      GetParent = \get(Str(\Parent\Argument))\Parent\Argument
    ElseIf IsWindow(\Parent\Argument)
      \SubLevel = 1
    EndIf
    
    ;
    If IsGadget(\Object\Argument)
      ; Если объект контейнер, то есть (Panel;ScrollArea;Container;Canvas)
      If \Container
        ParsePBObject()\Container = \Container
        ParsePBObject()\SubLevel = \SubLevel - 1
        EnableGadgetDrop(\Object\Argument, #PB_Drop_Text, #PB_Drag_Copy)
        BindEvent(#PB_Event_GadgetDrop, @CO_Events(), \Window\Argument, \Object\Argument)
        
        If \Type\Argument$ = "WindowGadget"
          BindEvent(#PB_Event_Gadget, @CO_Events(), \Window\Argument)
        EndIf
      Else
        ParsePBObject()\SubLevel = \SubLevel
      EndIf
      
      ; Итем родителя для создания в нем гаджетов
      If \Item : ParsePBObject()\Item=\Item-1 : EndIf
      
      ; Открываем гаджет лист на том родителе где создан данный объект.
      If \Object\Argument = \Parent\Argument
        If IsWindow(GetParent) : CloseGadgetList() : UseGadgetList(WindowID(GetParent)) : EndIf
        If IsGadget(GetParent) : OpenGadgetList = OpenGadgetList(GetParent, ParsePBObject()\Item) : EndIf
      EndIf
      
      ;       Transformation::Create(ParsePBObject()\Object\Argument, ParsePBObject()\Window\Argument, ParsePBObject()\Parent\Argument, ParsePBObject()\Item, 5)
      ;        Transformation::Create(ParsePBObject()\Object\Argument, ParsePBObject()\Parent\Argument, -1, 0, 5)
      ;       ButtonGadget(-1,0,0,160,20,Str(Random(5))+" "+\Parent\Argument$+"-"+Str(\Parent\Argument))
      ;       CallFunctionFast(@CO_Events())
      
      ; Посылаем сообщение, что создали гаджет.
      If \Type\Argument$ = "WindowGadget"
        ParsePBObject()\Window\Argument = \Window\Argument
        PostEvent(#PB_Event_Gadget, \Window\Argument, \Object\Argument, #PB_EventType_Create, \Object\Argument)
      Else
        PostEvent(#PB_Event_Gadget, \Window\Argument, \Object\Argument, #PB_EventType_Create, \Parent\Argument)
      EndIf
      
      ; Закрываем ранее открытий гаджет лист.
      If \Object\Argument = \Parent\Argument
        If IsWindow(GetParent) : OpenGadgetList(\Parent\Argument) : EndIf
        If OpenGadgetList : CloseGadgetList() : EndIf
      EndIf
    EndIf
    
    ;
    If IsWindow(\Object\Argument)
      StickyWindow(\Object\Argument, #True)
      ParsePBObject()\Container = \Container
      ;       Transformation::Create(ParsePBObject()\Object\Argument, ParsePBObject()\Window\Argument, ParsePBObject()\Parent\Argument, ParsePBObject()\Item, 5)
      PostEvent(#PB_Event_Gadget, \Object\Argument, #PB_Ignore, #PB_EventType_Create)
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
          Case "OpenWindow", "WindowGadget"          : \Content\String$ = Handle$+"OpenWindow("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                   : If \Flag\Argument$ : \Content\String$ +", "+\Flag\Argument$ : EndIf
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
Procedure$ GetItemText(String$)
  Protected Result$, Object, Index, Value.f, Param1, Param2, Param3, Param1$
  Protected operand$, val$
  
  With *This
    If ExamineRegularExpression(#RegEx_Captions, String$)
      While NextRegularExpressionMatch(#RegEx_Captions)
        If RegularExpressionMatchString(#RegEx_Captions)
          If RegularExpressionGroup(#RegEx_Captions, 2)
            Object = get_object_id(RegularExpressionGroup(#RegEx_Captions, 3))
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
              
            Case "LCase"          : Result$+LCase(GetStr1(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "Space"          : Result$+Space(Val(RegularExpressionGroup(#RegEx_Captions, 3)))
            Case "GetWindowTitle" : Result$+GetWindowTitle(Object)
            Default               
              Result$+RegularExpressionGroup(#RegEx_Captions, 1) ; То что между кавичкамы
          EndSelect
        EndIf
      Wend
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure
Declare$ SetPBFunction(Type$, ID$)

Procedure AddPBFunction(Arg$, Index)
  Protected Result, I
  
  Macro MacroCaption(MacroValue, MacroArg) ; 
    MacroValue = GetStr(MacroArg) 
    If GetVarValue(MacroArg)
      MacroValue = GetItemText(MacroValue)
    EndIf
  EndMacro


  With ParsePBObject()
    Select \Type\Argument$
      Case "OpenWindow", "ResizeWindow","ResizeGadget",
           "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
           "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
           "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
           "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
           "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
           "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
           "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
           "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget" 
        
        If AddElement(ParsePBObject()) 
          ParsePBObject()\Type\Argument$ = \Type\Argument$
          ParsePBObject()\Content\String$ = \Content\String$ + RegularExpressionMatchString(#RegEx_Function)
          ParsePBObject()\Content\Length = \Content\Length + RegularExpressionMatchLength(#RegEx_Function)
          If \Content\Position
            ParsePBObject()\Content\Position = \Content\Position
          Else
            ParsePBObject()\Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
          EndIf
          
          ; Границы для добавления объектов
          \Content\Position=ParsePBObject()\Content\Position
          \Content\Length=ParsePBObject()\Content\Length
        EndIf
        
        Select Index
          Case 1
            \Object\DefArgument$ = Arg$
            \Object\Argument = #PB_Any
            ; В общем если ид не равен минус один
            If Bool(Arg$<>"#PB_Default" And 
                    Arg$<>"#PB_All" And
                    Arg$<>"#PB_Any" And 
                    Asc(Arg$)<>'-')
              *This\Object\Argument$ = Arg$ 
            EndIf
            \Object\Argument$ = *This\Object\Argument$
            
          Case 2 
            \X\DefArgument$ = Arg$
            If "#PB_Ignore"=Arg$ 
              \X\Argument = #PB_Ignore
            Else
              MacroCoordinate(\X\Argument, Arg$)
            EndIf
            \X\Argument$ = Str(\X\Argument)
            
          Case 3 
            \Y\DefArgument$ = Arg$
            If "#PB_Ignore"=Arg$ 
              \Y\Argument = #PB_Ignore
            Else
              MacroCoordinate(\Y\Argument, Arg$)
            EndIf
            \Y\Argument$ = Str(\Y\Argument)
            
          Case 4 
            \Width\DefArgument$ = Arg$
            If "#PB_Ignore"=Arg$ 
              \Width\Argument = #PB_Ignore
            Else
              MacroCoordinate(\Width\Argument, Arg$)
            EndIf
            \Width\Argument$ = Str(\Width\Argument)
            
          Case 5 
            \Height\DefArgument$ = Arg$
            If "#PB_Ignore"=Arg$ 
              \Height\Argument = #PB_Ignore
            Else
              MacroCoordinate(\Height\Argument, Arg$)
            EndIf
            \Height\Argument$ = Str(\Height\Argument)
            
          Case 6 
            \Caption\DefArgument$ = Arg$
            MacroCaption(\Caption\Argument$, Arg$)
            
          Case 7 
            \Param1\DefArgument$ = Arg$
            Select \Type\Argument$ 
              Case "SplitterGadget"      
                \Param1\Argument = get_object_id(Arg$)
                
              Case "ImageGadget", "ButtonImageGadget"     
                \Param1\DefArgument$=Arg$
                \Param1\Argument$=GetStr(Arg$)
                
                \Param1\Argument = get_object_id(\Param1\Argument$)
                If IsImage(\Param1\Argument)
                  \Param1\Argument = ImageID(\Param1\Argument)
                EndIf
                
              Default
                \Param1\Argument = Val(Arg$)
            EndSelect
            \Param1\Argument$ = Str(\Param1\Argument)
            
          Case 8 
            \Param2\DefArgument$ = Arg$
            Select \Type\Argument$ 
              Case "SplitterGadget"      
                \Param2\Argument = get_object_id(Arg$)
              Default
                \Param2\Argument = Val(Arg$)
            EndSelect
            \Param2\Argument$ = Str(\Param2\Argument)
            
          Case 9 
            \Param3\DefArgument$ = Arg$
            \Param3\Argument = Val(Arg$)
            
          Case 10 
            \Flag\DefArgument$ = Arg$
            \Flag\Argument = CO_Flag(Arg$)
            \Flag\Argument$ = Arg$
        EndSelect
        
      Case "GetGadgetState",        ; param = 1
           "GetGadgetText",
           "IsGadget",
           "GadgetID",
           "GadgetType",
           "CanvasOutput",
           "ClearGadgetItems",
           "CountGadgetItems",
           "FreeGadget",
           "GetGadgetData",
           "GetGadgetFont",
           "UseGadgetList",
           "SetActiveGadget",
           "SetGadgetText",         ; param$ = 1
           "GadgetToolTip",
           "SetGadgetFont",         ; param = 1
           "SetGadgetState", 
           "GadgetHeight",
           "GadgetItemID",
           "GadgetWidth",
           "GadgetX",
           "GadgetY",
           "CanvasVectorOutput",
           "DisableGadget",
           "HideGadget",
           "OpenGadgetList",
           "RemoveGadgetColumn",
           "RemoveGadgetItem",
           "SetGadgetData",
           "SetGadgetFont",
           "SetGadgetState",
           "GetGadgetAttribute",
           "GetGadgetColor",
           "GetGadgetItemData",
           "GetGadgetItemState",
           "SetGadgetAttribute",     ; param = 2
           "SetGadgetColor",
           "SetGadgetItemData",
           "SetGadgetItemImage",
           "SetGadgetItemState",
           "GetGadgetItemText",
           "BindGadgetEvent",
           "UnbindGadgetEvent",
           "SetGadgetItemText",      ; param$ = 3 param = 4
           "AddGadgetColumn",
           "GetGadgetItemAttribute", ; param = 4
           "GetGadgetItemColor",
           "AddGadgetItem",          ; param$ = 3 param = 5
           "SetGadgetItemAttribute", ; param = 5
           "SetGadgetItemColor",
           "LoadImage",              ;
           "LoadFont"
        
        Select Index
          Case 1 
            \Object\Argument$ = Arg$
            \Object\Argument = #PB_Any
          Case 2 
            \Param1\DefArgument$ = Arg$
            
            Select \Type\Argument$
              Case "Str","Space","Chr","Hex","Bin","StrD","StrF","StrU","RGB","RGBA"
                \Param1\Argument = Val(Arg$)
                
              Case "EscapeString","Len","ReverseString","LCase","UCase","Asc","Val","ValD","ValF",
                   "LTrim","Trim","RTrim","CountString","FindString","InsertString","Left","Right",
                   "UnescapeString","StringByteLength","ReadPreferenceLong","RSet","LSet","StringField","Mid"
                \Param1\Argument$ = Arg$
                
            EndSelect
            
            Select \Type\Argument$
              Case "HideWindow",
                   "HideGadget", 
                   "DisableWindow",
                   "DisableGadget",
                   "StickyWindow"           ; param = 1
                
                Select Arg$
                  Case "#True"  : \Param1\Argument = #True
                  Case "#False" : \Param1\Argument = #False
                  Default
                    \Param1\Argument = Val(Arg$)
                EndSelect
                
              Case "SetGadgetText",         ; param$ = 1
                   "GadgetToolTip",
                   "LoadImage",
                   "LoadFont",
                   "SetGadgetState",
                   "SetGadgetFont"
                   
                \Param1\Argument$ = GetStr(Arg$)
                
              Case "SetGadgetAttribute", 
                   "GetGadgetAttribute", 
                   "SetGadgetColor",
                   "GetGadgetColor"
                
                Select Arg$
                    ; SetGadgetAttribute
                  Case "#PB_Button_Image"           : \Param1\Argument = #PB_Button_Image
                  Case "#PB_Button_PressedImage"    : \Param1\Argument = #PB_Button_PressedImage
                  Case "#PB_Calendar_Minimum"       : \Param1\Argument = #PB_Calendar_Minimum 
                  Case "#PB_Calendar_Maximum"       : \Param1\Argument = #PB_Calendar_Maximum
                  Case "#PB_Date_Minimum"           : \Param1\Argument = #PB_Date_Minimum 
                  Case "#PB_Date_Maximum"           : \Param1\Argument = #PB_Date_Maximum 
                  Case "#PB_Editor_ReadOnly"        : \Param1\Argument = #PB_Editor_ReadOnly
                  Case "#PB_Editor_WordWrap"        : \Param1\Argument = #PB_Editor_WordWrap
                  Case "#PB_Explorer_ColumnWidth"   : \Param1\Argument = #PB_Explorer_ColumnWidth
                  Case "#PB_ListIcon_ColumnWidth"   : \Param1\Argument = #PB_ListIcon_ColumnWidth 
                  Case "#PB_MDI_Image"              : \Param1\Argument = #PB_MDI_Image     
                  Case "#PB_MDI_TileImage"          : \Param1\Argument = #PB_MDI_TileImage
                    ; SetGadgetColor 
                  Case "#PB_Gadget_FrontColor"      : \Param1\Argument = #PB_Gadget_FrontColor      ; Цвет текста гаджета
                  Case "#PB_Gadget_BackColor"       : \Param1\Argument = #PB_Gadget_BackColor       ; Фон гаджета
                  Case "#PB_Gadget_LineColor"       : \Param1\Argument = #PB_Gadget_LineColor       ; Цвет линий сетки
                  Case "#PB_Gadget_TitleFrontColor" : \Param1\Argument = #PB_Gadget_TitleFrontColor ; Цвет текста в заголовке    (для гаджета CalendarGadget())
                  Case "#PB_Gadget_TitleBackColor"  : \Param1\Argument = #PB_Gadget_TitleBackColor  ; Цвет фона в заголовке 	 (для гаджета CalendarGadget())
                  Case "#PB_Gadget_GrayTextColor"   : \Param1\Argument = #PB_Gadget_GrayTextColor   ; Цвет для серого текста     (для гаджета CalendarGadget())
                EndSelect
                
              Default
                \Param1\Argument = Val(Arg$)
                If \Type\Argument$="SetWindowColor"
                  Result = GetVal(Arg$)
                  If Result
                    \Param1\Argument = Result
                  EndIf
                EndIf
            EndSelect
            
          Case 3 
            \Param2\DefArgument$ = Arg$
            
            Select \Type\Argument$
              Case "Str","Space","Chr","Hex","Bin","StrD","StrF","StrU","RGB","RGBA",
                   "Left","Right","UnescapeString","StringByteLength","ReadPreferenceLong",
                   "RSet","LSet","StringField","Mid"
                
                \Param2\Argument = Val(Arg$)
                
              Case "EscapeString","Len","ReverseString","LCase","UCase","Asc","Val","ValD","ValF",
                   "LTrim","Trim","RTrim","CountString","FindString","InsertString"
                \Param2\Argument$ = Arg$
            EndSelect
            
            Select \Type\Argument$
              Case "SetGadgetItemText",     ; param$ = 2 param = 4
                   "AddGadgetColumn",
                   "SetGadgetAttribute",
                   "AddGadgetItem"          ; param$ = 2 param = 5
                
                If \Type\Argument$ = "AddGadgetItem"
                  \Param2\Argument$=GetItemText(Arg$)
                Else
                  \Param2\Argument$=GetStr(Arg$)
                EndIf
                
              Case "SetGadgetItemAttribute", 
                   "GetGadgetItemAttribute"
                   
                Select Arg$
                    ; GetGadgetItemAttribute
                  Case "#PB_Explorer_ColumnWidth"    : \Param2\Argument = #PB_Explorer_ColumnWidth
                  Case "#PB_ListIcon_ColumnWidth"    : \Param2\Argument = #PB_ListIcon_ColumnWidth
                  Case "#PB_Tree_SubLevel"           : \Param2\Argument = #PB_Tree_SubLevel 
                EndSelect
                
              Default
                \Param2\Argument = Val(Arg$)
                
                If \Type\Argument$="SetGadgetColor"
                  Result = GetVal(Arg$)
                  If Result
                    \Param2\Argument = Result
                  EndIf
                EndIf
            EndSelect
            
          Case 4 
            \Param3\DefArgument$ = Arg$
            
            Select \Type\Argument$
              Case "RSet","LSet","StringField"
                \Param3\Argument$ = Arg$
                
              Case "Str","Space","Chr","Hex","Bin","StrD","StrF","StrU","RGB","RGBA",
                   "EscapeString","Len","ReverseString","LCase","UCase","Asc","Val","ValD","ValF",
                   "LTrim","Trim","RTrim","CountString","FindString","InsertString","Left","Right",
                   "UnescapeString","StringByteLength","ReadPreferenceLong","Mid"
                \Param3\Argument = Val(Arg$)
            EndSelect
            
            If \Type\Argument$="LoadFont"
              \Param3\Argument = CO_Flag(Arg$)
            Else
              \Param3\Argument = Val(Arg$)
            EndIf
            
          Case 5 
            \Flag\DefArgument$ = Arg$
            If \Type\Argument$ = "MDIGadget"
              \Flag\Argument = CO_Flag(Arg$)
              \Flag\Argument$ = Arg$
            Else
              \Flag\Argument=Val(Arg$)
            EndIf
        EndSelect
        
;         If \Type\Argument$="LoadFont"
;           Debug \Param1\Argument$
;           Debug \Param2\Argument
;           Debug \Param3\Argument
;         EndIf
    EndSelect
    
    If \Type\Argument$="ResizeGadget" And Index = 2
      Debug "x - "+\X\DefArgument$
      
      *This\Object\Argument$ = \Object\Argument$
      *This\Type\Argument$ = \Type\Argument$
      ;\Object\Argument$ = "#Window_0_Button_3"
      \Type\Argument$ = "GadgetX"
      AddPBFunction("#Window_0_Button_3", 1)
      \X\Argument = Val(SetPBFunction(\Type\Argument$, \Object\Argument$))
      \Object\Argument$ = *This\Object\Argument$
      \Type\Argument$ = *This\Type\Argument$
;       \X\Argument = Val(Examine_("GadgetX",\X\DefArgument$))
      ;\X\Argument = get_object_id(\X\DefArgument$) ; GadgetX(ID("#Window_0_Button_3"))
      
    EndIf
            
  EndWith
  
EndProcedure

Procedure$ SetPBFunction(Type$, ID$)
  Protected Result$, I, Object=-1
  
  With ParsePBObject()
    Object = get_object_id(ID$)
    
    Select Type$
      Case "UsePNGImageDecoder"      : UsePNGImageDecoder()
      Case "UsePNGImageEncoder"      : UsePNGImageEncoder()
      Case "UseJPEGImageDecoder"     : UseJPEGImageDecoder()
      Case "UseJPEG2000ImageEncoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEG2000ImageDecoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEGImageEncoder"     : UseJPEGImageEncoder()
      Case "UseGIFImageDecoder"      : UseGIFImageDecoder()
      Case "UseTGAImageDecoder"      : UseTGAImageDecoder()
      Case "UseTIFFImageDecoder"     : UseTIFFImageDecoder()
        
      Case "Str"                     : Result$ = Str(\Param1\Argument)
      Case "Space"                   : Result$ = Space(\Param1\Argument)
      Case "Chr"                     : Result$ = Chr(\Param1\Argument)
        
      Case "Hex"                     : Result$ = Hex(\Param1\Argument,\Param2\Argument)
      Case "Bin"                     : Result$ = Bin(\Param1\Argument,\Param2\Argument)
      Case "StrD"                    : Result$ = StrD(\Param1\Argument,\Param2\Argument)
      Case "StrF"                    : Result$ = StrF(\Param1\Argument,\Param2\Argument)
      Case "StrU"                    : Result$ = StrU(\Param1\Argument,\Param2\Argument)
      Case "RGB"                     : Result$ = Str(RGB(\Param1\Argument, \Param2\Argument, \Param3\Argument))
      Case "RGBA"                    : Result$ = Str(RGBA(\Param1\Argument, \Param2\Argument, \Param3\Argument, \Flag\Argument))
        
      Case "EscapeString"            : Result$ = EscapeString(\Param1\Argument$)
      Case "Len"                     : Result$ = Str(Len(\Param1\Argument$))
      Case "ReverseString"           : Result$ = ReverseString(\Param1\Argument$)
      Case "LCase"                   : Result$ = LCase(\Param1\Argument$)
      Case "UCase"                   : Result$ = UCase(\Param1\Argument$)
      Case "Asc"                     : Result$ = Str(Asc(\Param1\Argument$))
      Case "Val"                     : Result$ = Str(Val(\Param1\Argument$))
      Case "ValD"                    : Result$ = StrD(ValD(\Param1\Argument$), Len(StringField(\Param1\Argument$, 2, ".")))
      Case "ValF"                    : Result$ = StrF(ValF(\Param1\Argument$), Len(StringField(\Param1\Argument$, 2, ".")))
      
      ;Case "RemoveString"            : Result$ = RemoveString(\Param1\Argument$)
      ;Case "ReplaceString"           : Result$ = ReplaceString(\Param1\Argument$)
        
      Case "LTrim"                   : Result$ = LTrim(\Param1\Argument$,\Param2\Argument$)
      Case "Trim"                    : Result$ = Trim(\Param1\Argument$,\Param2\Argument$)
      Case "RTrim"                   : Result$ = RTrim(\Param1\Argument$,\Param2\Argument$)
      Case "CountString"             : Result$ = Str(CountString(\Param1\Argument$,\Param2\Argument$))
      Case "FindString"              : Result$ = Str(FindString(\Param1\Argument$,\Param2\Argument$,\Param3\Argument,\Flag\Argument))
      Case "InsertString"            : Result$ = InsertString(\Param1\Argument$,\Param2\Argument$,\Param3\Argument)
        
      Case "Left"                    : Result$ = Left(\Param1\Argument$,\Param2\Argument)
      Case "Right"                   : Result$ = Right(\Param1\Argument$,\Param2\Argument)
      Case "UnescapeString"          : Result$ = UnescapeString(\Param1\Argument$,\Param2\Argument)
      Case "StringByteLength"        : Result$ = Str(StringByteLength(\Param1\Argument$,\Param2\Argument))
      Case "ReadPreferenceLong"      : Result$ = Str(ReadPreferenceLong(\Param1\Argument$, \Param2\Argument))
        
      Case "RSet"                    : Result$ = RSet(\Param1\Argument$,\Param2\Argument,\Param3\Argument$)
      Case "LSet"                    : Result$ = LSet(\Param1\Argument$,\Param2\Argument,\Param3\Argument$)
      Case "StringField"             : Result$ = StringField(\Param1\Argument$,\Param2\Argument,\Param3\Argument$)
        
      Case "Mid"                     : Result$ = Mid(\Param1\Argument$,\Param2\Argument,\Param3\Argument)
      
      Case "WindowEvent"             : Result$ = Str(WindowEvent())
      Case "GetActiveWindow"         : Result$ = Str(GetActiveWindow())
      Case "GetActiveGadget"         : Result$ = Str(GetActiveGadget())
      Case "EventData"               : Result$ = Str(EventData())
      Case "EventGadget"             : Result$ = Str(EventGadget())
      Case "EventMenu"               : Result$ = Str(EventMenu())
      Case "EventTimer"              : Result$ = Str(EventTimer())
      Case "EventType"               : Result$ = Str(EventType())
      Case "EventWindow"             : Result$ = Str(EventWindow())
      Case "EventlParam"             : Result$ = Str(EventlParam())
      Case "EventwParam"             : Result$ = Str(EventwParam())     

      Case "LoadImage"               : \Object\Argument=LoadImage(#PB_Any, \Param1\Argument$)
      Case "LoadFont"                : \Object\Argument=LoadFont(#PB_Any,\Param1\Argument$,\Param2\Argument,\Param3\Argument)
      Case "SetGadgetFont"           : \Object\Argument= get_object_id(\Param1\Argument$)
        If IsFont(\Object\Argument)           : \Param1\Argument=FontID(\Object\Argument) : EndIf
      Case "SetGadgetState"          : \Object\Argument= get_object_id(\Param1\Argument$) 
        If IsImage(\Object\Argument)          : \Param1\Argument=ImageID(\Object\Argument) : EndIf
      Case "SetGadgetAttribute"      : \Object\Argument= get_object_id(\Param2\Argument$) 
        If IsImage(\Object\Argument)          : \Param2\Argument=ImageID(\Object\Argument) : EndIf
        
      Case "OpenWindow", "OpenGadgetList", "CloseGadgetList",
           "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
           "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
           "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
           "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
           "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
           "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
           "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
           "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
        
        \Object\Argument = CO_Open()
        
    EndSelect
    
    ;
    If \Object\Argument And Not \Type\Argument And Not Object
      AddMapElement(*This\get(), \Object\Argument$) 
      *This\get()\Object\Argument=\Object\Argument
      *This\get()\Index=@ParsePBObject()
    EndIf 
    
    If IsWindow(Object)
      Select Type$
        Case "PostEvent"              : PostEvent(\Param1\Argument,Object,\Param2\Argument,\Param3\Argument,\Flag\Argument)
        Case "UnbindEvent"            : UnbindEvent(\Param1\Argument,\Param2\Argument,Object,\Param3\Argument,\Flag\Argument)
        Case "BindEvent"              : BindEvent(\Param1\Argument,\Param2\Argument,Object,\Param3\Argument,\Flag\Argument)
        Case "WindowBounds"           : WindowBounds(Object,\Param1\Argument,\Param2\Argument,\Param3\Argument,\Flag\Argument)
          
        Case "IsWindow"               : Result$ = Str(IsWindow(Object))
        Case "WindowID"               : Result$ = Str(WindowID(Object))
        Case "CloseWindow"            : CloseWindow(Object)
        Case "WindowMouseX"           : Result$ = Str(WindowMouseX(Object))
        Case "WindowMouseY"           : Result$ = Str(WindowMouseY(Object))
        Case "WindowOutput"           : Result$ = Str(WindowOutput(Object))
        Case "GetWindowData"          : Result$ = Str(GetWindowData(Object))
        Case "GetWindowColor"         : Result$ = Str(GetWindowColor(Object))
        Case "GetWindowState"         : Result$ = Str(GetWindowState(Object))
        Case "GetWindowTitle"         : Result$ = GetWindowTitle(Object)
        Case "SetActiveWindow"        : SetActiveWindow(Object)
        Case "WindowX"                : Result$ = Str(WindowX(Object, \Param1\Argument))
        Case "WindowY"                : Result$ = Str(WindowY(Object, \Param1\Argument))
        Case "HideWindow"             : HideWindow(Object, \Param1\Argument)
        Case "WaitWindowEvent"        : Result$ = Str(WaitWindowEvent(\Param1\Argument))
        Case "StickyWindow"           : StickyWindow(Object, \Param1\Argument)
        Case "DisableWindow"          : DisableWindow(Object, \Param1\Argument)
        Case "SetWindowColor"         : SetWindowColor(Object, \Param1\Argument)
        Case "WindowWidth"            : Result$ = Str(WindowWidth(Object, \Param1\Argument))
        Case "WindowHeight"           : Result$ = Str(WindowHeight(Object, \Param1\Argument))
        Case "SetWindowData"          : SetWindowData(Object, \Param1\Argument)
        Case "SetWindowState"         : SetWindowState(Object, \Param1\Argument)
        Case "SetWindowTitle"         : SetWindowTitle(Object, \Param1\Argument$)
        Case "RemoveWindowTimer"      : RemoveWindowTimer(Object, \Param1\Argument)
        Case "WindowVectorOutput"     : Result$ = Str(WindowVectorOutput(Object, \Param1\Argument))
        Case "SmartWindowRefresh"     : SmartWindowRefresh(Object, \Param1\Argument)
        Case "SetWindowCallback"      : SetWindowCallback(\Param1\Argument, Object)
        Case "RemoveKeyboardShortcut" : RemoveKeyboardShortcut(Object, \Param1\Argument)
        Case "AddWindowTimer"         : AddWindowTimer(Object, \Param1\Argument, \Param2\Argument)
        Case "AddKeyboardShortcut"    : AddKeyboardShortcut(Object, \Param1\Argument, \Param2\Argument)
        Case "ResizeWindow"           : ResizeWindow(Object, \X\Argument, \Y\Argument, \Width\Argument, \Height\Argument)
      EndSelect
    EndIf
    
    If IsGadget(Object)
      Select Type$
        Case "SetActiveGadget"        : SetActiveGadget(Object)
        Case "GetGadgetState"         : Result$ = Str(GetGadgetState(Object))
        Case "GetGadgetText"          : Result$ = GetGadgetText(Object)
        Case "IsGadget"               : Result$ = Str(IsGadget(Object))
        Case "GadgetID"               : Result$ = Str(GadgetID(Object))
        Case "GadgetType"             : Result$ = Str(GadgetType(Object))
        Case "CanvasOutput"           : Result$ = Str(CanvasOutput(Object))
        Case "ClearGadgetItems"       : ClearGadgetItems(Object)
        Case "CountGadgetItems"       : Result$ = Str(CountGadgetItems(Object))
        Case "FreeGadget"             : FreeGadget(Object)
        Case "GetGadgetData"          : Result$ = Str(GetGadgetData(Object))
        Case "GetGadgetFont"          : Result$ = Str(GetGadgetFont(Object))
        Case "UseGadgetList"          : Result$ = Str(UseGadgetList(\Param1\Argument))
          
        Case "GadgetToolTip"          : GadgetToolTip(Object,\Param1\Argument$)
        Case "GadgetItemID"           : Result$ = Str(GadgetItemID(Object,\Param1\Argument))
        Case "GadgetHeight"           : Result$ = Str(GadgetHeight(Object,\Param1\Argument))
        Case "GadgetWidth"            : Result$ = Str(GadgetWidth(Object,\Param1\Argument))
        Case "GadgetX"                : Result$ = Str(GadgetX(Object,\Param1\Argument))
        Case "GadgetY"                : Result$ = Str(GadgetY(Object,\Param1\Argument))
        Case "CanvasVectorOutput"     : Result$ = Str(CanvasVectorOutput(Object,\Param1\Argument))
        Case "DisableGadget"          : DisableGadget(Object,\Param1\Argument)
        Case "HideGadget"             : HideGadget(Object,\Param1\Argument)
        Case "OpenGadgetList"         : OpenGadgetList(Object,\Param1\Argument)
        Case "RemoveGadgetColumn"     : RemoveGadgetColumn(Object,\Param1\Argument)
        Case "RemoveGadgetItem"       : RemoveGadgetItem(Object,\Param1\Argument)
        Case "SetGadgetData"          : SetGadgetData(Object,\Param1\Argument)
        Case "SetGadgetFont"          : SetGadgetFont(Object,\Param1\Argument)
        Case "SetGadgetState"         : SetGadgetState(Object,\Param1\Argument)
        Case "SetGadgetText"          : SetGadgetText(Object,\Param1\Argument$)
        Case "GetGadgetAttribute"     : Result$ = Str(GetGadgetAttribute(Object,\Param1\Argument))
        Case "GetGadgetColor"         : Result$ = Str(GetGadgetColor(Object,\Param1\Argument))
        Case "GetGadgetItemData"      : Result$ = Str(GetGadgetItemData(Object,\Param1\Argument))
        Case "GetGadgetItemState"     : Result$ = Str(GetGadgetItemState(Object,\Param1\Argument))
          
        Case "SetGadgetAttribute"     : SetGadgetAttribute(Object,\Param1\Argument,\Param2\Argument)
        Case "SetGadgetColor"         : SetGadgetColor(Object,\Param1\Argument,\Param2\Argument)
        Case "SetGadgetItemData"      : SetGadgetItemData(Object,\Param1\Argument,\Param2\Argument)
        Case "SetGadgetItemImage"     : SetGadgetItemImage(Object,\Param1\Argument,\Param2\Argument)
        Case "SetGadgetItemState"     : SetGadgetItemState(Object,\Param1\Argument,\Param2\Argument)
        Case "GetGadgetItemText"      : Result$ = GetGadgetItemText(Object,\Param1\Argument,\Param2\Argument)
        Case "BindGadgetEvent"        : BindGadgetEvent(Object,\Param1\Argument,\Param2\Argument)
        Case "UnbindGadgetEvent"      : UnbindGadgetEvent(Object,\Param1\Argument,\Param2\Argument)
          
        Case "SetGadgetItemText"      : SetGadgetItemText(Object,\Param1\Argument,\Param2\Argument$,\Param3\Argument)
        Case "GetGadgetItemAttribute" : Result$ = Str(GetGadgetItemAttribute(Object,\Param1\Argument,\Param2\Argument,\Param3\Argument))
        Case "GetGadgetItemColor"     : Result$ = Str(GetGadgetItemColor(Object,\Param1\Argument,\Param2\Argument,\Param3\Argument))
        Case "AddGadgetColumn"        : Result$ = Str(AddGadgetColumn(Object,\Param1\Argument,\Param2\Argument$,\Param3\Argument))
          
        Case "SetGadgetItemAttribute" : SetGadgetItemAttribute(Object,\Param1\Argument,\Param2\Argument,\Param3\Argument,\Flag\Argument)
        Case "SetGadgetItemColor"     : SetGadgetItemColor(Object,\Param1\Argument,\Param2\Argument,\Param3\Argument,\Flag\Argument)
        Case "AddGadgetItem"          : Result$ = Str(AddGadgetItem(Object,\Param1\Argument,\Param2\Argument$,\Param3\Argument,\Flag\Argument))
        Case "ResizeGadget"           : ResizeGadget(Object, \X\Argument, \Y\Argument, \Width\Argument, \Height\Argument)
          Transformation::Update(Object)
          
      EndSelect
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure

Procedure CodePosition(Indent)
  Protected RegExID
  
  With *This
    ; Сначала определять кто есть кто.
    Select \Type\Argument$
      Case "OpenWindow" 
        \Container =- 1 
        \Window\Argument$ = \Object\Argument$ 
        \Parent\Argument$ = \Object\Argument$
      Case "PanelGadget" 
        \Container = #PB_GadgetType_Panel
        \Parent\Argument$ = \Object\Argument$
      Case "ContainerGadget" 
        \Container = #PB_GadgetType_Container
        \Parent\Argument$ = \Object\Argument$
      Case "ScrollAreaGadget" 
        \Container = #PB_GadgetType_ScrollArea
        \Parent\Argument$ = \Object\Argument$
      Case "CanvasGadget"
        If ((\Flag\Argument&#PB_Canvas_Container)=#PB_Canvas_Container)
          \Container = #PB_GadgetType_Canvas
          \Parent\Argument$ = \Object\Argument$
        EndIf
      Default
        \Container = #PB_GadgetType_Unknown
    EndSelect
    
    ; Получаем последнюю позицию идентификаторов в файле
    RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])("+\Object\Argument$+"(?:=-1)?)([^\s]\w+)?(?:\s+(\w+$))?")
    If RegExID
      If ExamineRegularExpression(RegExID, \Content\Text$)
        While NextRegularExpressionMatch(RegExID)
          \get("Code")\Code("Code_Object")\Position = RegularExpressionMatchPosition(RegExID)+
                                                      RegularExpressionMatchLength(RegExID)
          If Asc(\Object\Argument$) = '#'
            \get("Code")\Code("Code_Object")\Position + Len(#CRLF$+"EndEnumeration")
          EndIf
          Break
        Wend
      EndIf
      
      FreeRegularExpression(RegExID)
    EndIf
    
    ; Запоминаем последнюю позицию объекта
    \get(\Object\Argument$)\Code("Code_Function")\Position = \Content\Position+\Content\Length +Len(#CRLF$+Space(Indent))
    If \Container
      Select \Type\Argument$
        Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
          \get(\Window\Argument$)\Code("Code_Function")\Position = \Content\Position+\Content\Length +Len(#CRLF$+Space(Indent))+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
      EndSelect
    Else
      \get(\Window\Argument$)\Code("Code_Function")\Position = \Content\Position+\Content\Length +Len(#CRLF$+Space(Indent))
    EndIf
  EndWith
EndProcedure

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
      
      ;If CreateRegularExpression(#RegEx_Function, ~"(?:((?:;|\\d|\\.\\s|\\.\\w\\w).*)|(?:(?:(\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*)|(?:(?:\\w+\\(.*\\)|(?:(\\w+)(|\\.\\w+)))\\s*=\\s*(?:\\w\\s*\\(.*\\))))|(?:(\\w+)\\s*\\((\".*?\"|[^:]|.*?)\\))|(?:(\\w+)(|\\.\\w))\\s)", #PB_RegularExpression_Extended | Create_Reg_Flag) And
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
                  Protected Content_String$, Content_Length, Content_Position
                  \Object\Argument$ = RegularExpressionGroup(#RegEx_Function, 3)
                  Content_String$ = RegularExpressionMatchString(#RegEx_Function)
                  Content_Length = RegularExpressionMatchLength(#RegEx_Function)
                  Content_Position = RegularExpressionMatchPosition(#RegEx_Function)
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
                      
                      AddElement(ParsePBObject()) 
                      ParsePBObject()\Type\Argument$ = \Type\Argument$
                      ParsePBObject()\Content\String$ = Content_String$ + RegularExpressionMatchString(#RegEx_Function)
                      ParsePBObject()\Content\Length = Content_Length + RegularExpressionMatchLength(#RegEx_Function)
                      If Content_Position
                        ParsePBObject()\Content\Position = Content_Position
                      Else
                        ParsePBObject()\Content\Position = RegularExpressionMatchPosition(#RegEx_Function)
                      EndIf
                      
                      ; Границы для добавления объектов
                      \Content\Position=ParsePBObject()\Content\Position
                      \Content\Length=ParsePBObject()\Content\Length
                      
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
                                ParsePBObject()\Object\Argument$ = \Object\Argument$
                                
                                ; Получаем класс объекта
                                \Class\Argument$ = \Object\Argument$ 
                                ; Удаляем имя родителя
                                \Class\Argument$ = ReplaceString(\Class\Argument$, \Window\Argument$+"_", "")
                                ; Сохраняем класс объекта
                                ParsePBObject()\Class\Argument$ = \Class\Argument$
                                
                              Case 2 : ParsePBObject()\X\Argument$ = Arg$
                                MacroCoordinate(\X\Argument, Arg$)
                                
                              Case 3 : ParsePBObject()\Y\Argument$ = Arg$
                                MacroCoordinate(\Y\Argument, Arg$)
                                
                              Case 4 : ParsePBObject()\Width\Argument$ = Arg$
                                MacroCoordinate(\Width\Argument, Arg$)
                                
                              Case 5 : ParsePBObject()\Height\Argument$ = Arg$
                                MacroCoordinate(\Height\Argument, Arg$)
                                
                              Case 6 
                                \Caption\Argument$ = GetStr(Arg$)
                                ParsePBObject()\Caption\Argument$ = \Caption\Argument$
                                
                              Case 7 : ParsePBObject()\Param1\Argument$ = Arg$
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
                                    
                                    If IsWindow(\Param1\Argument)
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
                                
                              Case 8 : ParsePBObject()\Param2\Argument$ = Arg$
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
                                
                              Case 9 : ParsePBObject()\Param3\Argument$ = Arg$
                                \Param3\Argument = Val(Arg$)
                                
                              Case 10 
                               ParsePBObject()\Flag\Argument$ = Arg$
                               \Flag\Argument = CO_Flag(Arg$)
                              
                            EndSelect
                            
                          EndIf
                        Wend
                      EndIf
                      
                      CodePosition(Indent)
                      
                      ; Записываем у родителя позицию конца добавления объекта
                      ; *This\get(*This\get(Str(*This\Parent\Argument))\Object\Argument$)\Code("Code_Function")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                      ;   Debug "Load Code_Enumeration"+ *This\get("Code")\Code("Code_Object")\Position
                      Debug "Load Code_Object"+ *This\get("Code")\Code("Code_Object")\Position
                      ;Debug "Load Code_Object"+ *This\get(*This\Window\Argument$)\Code("Code_Object")\Position
                      Debug "  Load Code_Function "+ *This\get(Str(*This\Parent\Argument))\Object\Argument$ +" "+ *This\get(*This\get(Str(*This\Parent\Argument))\Object\Argument$)\Code("Code_Function")\Position
                      ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Window\Argument$)\Code("Code_Object")\Position
                      ;     Debug "    Code_Function"+ *This\get(*This\get(Replace$)\Parent\Argument$)\Code("Code_Function")\Position
                      
                      
                      
                      
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
                      
                      If IsWindow(\Param1\Argument)
                        ;                         *This\get(\Object\Argument$)\Object\Argument = *This\get(Str(\Param1\Argument))\Window\Argument
                        Protected UseGadgetList = UseGadgetList(WindowID(\Param1\Argument))
                        PushListPosition(ParsePBObject())
                        ForEach ParsePBObject()
                          If ParsePBObject()\Container=-1 
                            If IsWindow(ParsePBObject()\Object\Argument) And 
                               WindowID(ParsePBObject()\Object\Argument) = UseGadgetList
                              *This\get(\Object\Argument$)\Object\Argument = ParsePBObject()\Object\Argument
                            EndIf
                          EndIf
                        Next
                        PopListPosition(ParsePBObject())
                        UseGadgetList(UseGadgetList)
                        
                      ElseIf IsGadget(\Param1\Argument)
                        PushListPosition(ParsePBObject())
                        change_current_object_from_id(\Param1\Argument)
                        While PreviousElement(ParsePBObject())
                          If ParsePBObject()\Container=-1 
                            *This\get(\Object\Argument$)\Object\Argument = ParsePBObject()\Object\Argument
                            Break
                          EndIf
                        Wend
                        PopListPosition(ParsePBObject())
                        
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
                                  PushListPosition(ParsePBObject())
                                  ForEach ParsePBObject()
                                    If Val(ParsePBObject()\Object\Argument$) = Val(Arg$)
                                      \Object\Argument$ = ParsePBObject()\Object\Argument$
                                    EndIf
                                  Next
                                  PopListPosition(ParsePBObject())
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
                            PC_Add(*This, Index)
                          EndIf
                        Wend
                        
                        PC_Set(*This)
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
Procedure WE_Position_Selecting(Gadget, Parent)
  Protected i, Position=-1 ; 
  
  ; Определяем позицию в списке
  If IsGadget(Parent) 
    Position = CountGadgetItems(Gadget)
    
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

Procedure WE_Update_Selecting(Gadget, Position=-1)
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
      generate_image(ParsePBObject()\Type\Argument$)
      AddGadgetItem (Gadget, -1, ParsePBObject()\Object\Argument$, ImageID, ParsePBObject()\SubLevel)
      SetGadgetItemData(Gadget, Position, ParsePBObject()\Object\Argument)
    Next
    PopListPosition(ParsePBObject())
  Else
    AddGadgetItem(Gadget, Position, ParsePBObject()\Object\Argument$, ImageID, ParsePBObject()\SubLevel)
    SetGadgetItemData(Gadget, Position, ParsePBObject()\Object\Argument)
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
      If ParsePBObject()\Object\Argument$ = Find$
        ; Включаем и имя родителя при формировании имени объекта
        If *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$ And 
           Not FindString(Replace$, *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$)
          Replace$ = *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$+"_"+Replace$
          SetGadgetText(EventGadget(), Replace$)
          Caret::SetPos(EventGadget(), Len(Replace$))
        EndIf
        
        ;
        If Find$=*This\get(Find$)\Window\Argument$
          *This\get(Find$)\Window\Argument$=Replace$
        EndIf
        If Find$=*This\get(Find$)\Parent\Argument$
          *This\get(Find$)\Parent\Argument$=Replace$
        EndIf
        
        *This\get(ParsePBObject()\Object\Argument$)\Object\Argument$ = Replace$
        *This\get(Str(ParsePBObject()\Object\Argument))\Object\Argument$ = Replace$
        
        ParsePBObject()\Class\Argument$ = ReplaceString(Replace$, *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$+"_", "")
        
        ; Меняем map ключ объекта
        CopyStructure(*This\get(ParsePBObject()\Object\Argument$), *This\get(Replace$), ObjectStruct)
        ; И удаляем старый
        DeleteMapElement(*This\get(), ParsePBObject()\Object\Argument$)
        
        ParsePBObject()\Object\Argument$ = Replace$ 
        
        ; По умалчанию 
        If ParsePBObject()\Container
          If ParsePBObject()\Container =- 1
            *This\Window\Argument$ = ParsePBObject()\Object\Argument$ 
          EndIf
          *This\Container = ParsePBObject()\Container
          *This\Parent\Argument$ = ParsePBObject()\Object\Argument$
        EndIf
        ParsePBObject()\Window\Argument$ = *This\Window\Argument$
        ParsePBObject()\Parent\Argument$ = *This\Parent\Argument$
      Else
        ; Формируем имя объекта снова так как изменили имя родителя
        If *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$
          ParentClass$ = *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$
          
          *This\get(ParsePBObject()\Object\Argument$)\Object\Argument$ = ParentClass$+"_"+ParsePBObject()\Class\Argument$
          *This\get(Str(ParsePBObject()\Object\Argument))\Object\Argument$ = ParentClass$+"_"+ParsePBObject()\Class\Argument$
          
          ; Меняем map ключ объекта
          CopyStructure(*This\get(ParsePBObject()\Object\Argument$), *This\get(ParentClass$+"_"+ParsePBObject()\Class\Argument$), ObjectStruct)
          ; И удаляем старый
          DeleteMapElement(*This\get(), ParsePBObject()\Object\Argument$)
          
          ParsePBObject()\Object\Argument$ = ParentClass$+"_"+ParsePBObject()\Class\Argument$ 
          Debug ParsePBObject()\Object\Argument$
          
          ; Обнавляем инспектор объектов
          For i=0 To CountGadgetItems(Gadget)-1
            If ParsePBObject()\Object\Argument=GetGadgetItemData(Gadget, i) 
              SetGadgetItemText(Gadget, i, ParsePBObject()\Object\Argument$)
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
      String$ = Mid(*This\Content\Text$, 1, *This\get("Code")\Code("Code_Object")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get("Code")\Code("Code_Object")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get("Code")\Code("Code_Object_Gadget")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get("Code")\Code("Code_Object_Gadget")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get("Code")\Code("Code_Object")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get("Code")\Code("Code_Object")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get("Code")\Code("Code_Enumeration_Gadget")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get("Code")\Code("Code_Enumeration_Gadget")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Function")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position + NbFound
        EndIf
      Next
      PopListPosition(ParsePBObject())
      
      ; Заменям слова в файле
      If ExamineRegularExpression(RegExID, *This\Content\Text$)
        While NextRegularExpressionMatch(RegExID)
          *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Trim(Replace$, "#"))
          Break
        Wend
      EndIf
      
      FreeRegularExpression(RegExID)
    EndIf
    
    ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Window\Argument$)\Code("Code_Object")\Position
    ;     Debug "    Code_Function"+ *This\get(*This\get(Replace$)\Parent\Argument$)\Code("Code_Function")\Position
    SetGadgetText(Gadget, Replace$)
    
    WE_Code_Show(*This\Content\Text$)
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
      If ParsePBObject()\Object\Argument$ = Find$
        ; Включаем и имя родителя при формировании имени объекта
        If *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$ And 
           Not FindString(Replace$, *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$)
          Replace$ = *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$+"_"+Replace$
          SetGadgetText(EventGadget(), Replace$)
          Caret::SetPos(EventGadget(), Len(Replace$))
        EndIf
        
        ;
        If Find$=*This\get(Find$)\Window\Argument$
          *This\get(Find$)\Window\Argument$=Replace$
        EndIf
        If Find$=*This\get(Find$)\Parent\Argument$
          *This\get(Find$)\Parent\Argument$=Replace$
        EndIf
        
        *This\get(ParsePBObject()\Object\Argument$)\Object\Argument$ = Replace$
        *This\get(Str(ParsePBObject()\Object\Argument))\Object\Argument$ = Replace$
        
        ParsePBObject()\Class\Argument$ = ReplaceString(Replace$, *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$+"_", "")
        
        ; Меняем map ключ объекта
        CopyStructure(*This\get(ParsePBObject()\Object\Argument$), *This\get(Replace$), ObjectStruct)
        ; И удаляем старый
        DeleteMapElement(*This\get(), ParsePBObject()\Object\Argument$)
        
        ParsePBObject()\Object\Argument$ = Replace$ 
        
        ; По умалчанию 
        If ParsePBObject()\Container
          If ParsePBObject()\Container =- 1
            *This\Window\Argument$ = ParsePBObject()\Object\Argument$ 
          EndIf
          *This\Container = ParsePBObject()\Container
          *This\Parent\Argument$ = ParsePBObject()\Object\Argument$
        EndIf
        ParsePBObject()\Window\Argument$ = *This\Window\Argument$
        ParsePBObject()\Parent\Argument$ = *This\Parent\Argument$
      Else
        ; Формируем имя объекта снова так как изменили имя родителя
        If *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$
          ParentClass$ = *This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$
          
          *This\get(ParsePBObject()\Object\Argument$)\Object\Argument$ = ParentClass$+"_"+ParsePBObject()\Class\Argument$
          *This\get(Str(ParsePBObject()\Object\Argument))\Object\Argument$ = ParentClass$+"_"+ParsePBObject()\Class\Argument$
          
          ; Меняем map ключ объекта
          CopyStructure(*This\get(ParsePBObject()\Object\Argument$), *This\get(ParentClass$+"_"+ParsePBObject()\Class\Argument$), ObjectStruct)
          ; И удаляем старый
          DeleteMapElement(*This\get(), ParsePBObject()\Object\Argument$)
          
          ParsePBObject()\Object\Argument$ = ParentClass$+"_"+ParsePBObject()\Class\Argument$ 
          Debug ParsePBObject()\Object\Argument$
          
          ; Обнавляем инспектор объектов
          For i=0 To CountGadgetItems(Gadget)-1
            If ParsePBObject()\Object\Argument=GetGadgetItemData(Gadget, i) 
              SetGadgetItemText(Gadget, i, ParsePBObject()\Object\Argument$)
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
      String$ = Mid(*This\Content\Text$, 1, *This\get("Code")\Code("Code_Object")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get("Code")\Code("Code_Object")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Function")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      
      ;Debug String$
      Debug "  g "+Replace$ +" "+ NbFound +" "+ len
      
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position + NbFound
        EndIf
      Next
      PopListPosition(ParsePBObject())
      
;       ; Заменям слова в файле
      If ExamineRegularExpression(RegExID, *This\Content\Text$)
        While NextRegularExpressionMatch(RegExID)
          *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Trim(Replace$, "#"))
          Break
        Wend
      EndIf
      
      FreeRegularExpression(RegExID)
    EndIf
    
    ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Window\Argument$)\Code("Code_Object")\Position
    ;     Debug "    Code_Function"+ *This\get(*This\get(Replace$)\Parent\Argument$)\Code("Code_Function")\Position
    SetGadgetText(Gadget, Replace$)
    
    WE_Code_Show(*This\Content\Text$)
  EndIf
EndProcedure

Procedure WE_OpenFile(Path$) ; Открытие файла
  If Path$
    Debug "Открываю файл '"+Path$+"'"
    
    ; Начинаем перебырать файл
    If ParsePBFile(Path$)
      
      WE_Update_Selecting(WE_Selecting)
      
      CodeShow=1
      WE_Code_Show(*This\Content\Text$)
      
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
    
    PushListPosition(ParsePBObject())
    With ParsePBObject()
      ForEach ParsePBObject()
        Object = ParsePBObject()\Object\Argument ; *This\get(ParsePBObject()\Object\Argument$)\Object\Argument
        
        If IsWindow(Object)
          \X\Argument$ = Str(WindowX(Object))
          \Y\Argument$ = Str(WindowY(Object))
          \Width\Argument$ = Str(WindowWidth(Object))
          \Height\Argument$ = Str(WindowHeight(Object))
          \Caption\Argument$ = GetWindowTitle(Object)
        EndIf
        If IsGadget(Object)
          \X\Argument$ = Str(GadgetX(Object))
          \Y\Argument$ = Str(GadgetY(Object))
          \Width\Argument$ = Str(GadgetWidth(Object))
          \Height\Argument$ = Str(GadgetHeight(Object))
          \Caption\Argument$ = GetGadgetText(Object)
        EndIf
        
      Next
    EndWith
     PopListPosition(ParsePBObject())
       
    
     PC_Update()
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
Procedure WE_Open(ParentID=0, Flag.i=#PB_Window_SystemMenu)
  If Not IsWindow(WE)
    WE = OpenWindow(#PB_Any, 100, 100, 900, 600, "(WE) - Редактор объектов", Flag, ParentID)
    StickyWindow(WE, #True)
    
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
    
    WE_Selecting = TreeGadget(#PB_Any, 5, 5, 315, 145, #PB_Tree_AlwaysShowSelection)
    WE_Panel_0 = PanelGadget(#PB_Any, 5, 159, 315, 261)
    
    AddGadgetItem(WE_Panel_0, -1, "Objects", ImageID(img_add_objects))
    WE_Objects = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
    EnableGadgetDrop(WE_Objects, #PB_Drop_Text, #PB_Drag_Copy)
    
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
    
    ; 
    AddGadgetItem(WE_Panel_0, -1, "Events")
    CloseGadgetList()
    
    WE_Splitter_0 = SplitterGadget(#PB_Any, 5, 5, 900-10, 600-MenuHeight()-10, WE_Selecting, WE_Panel_0, #PB_Splitter_FirstFixed)
    SetGadgetState(WE_Splitter_0, 165)
    
    WE_Panel_1 = PanelGadget(#PB_Any, 5, 159, 315, 261)
    
    AddGadgetItem(WE_Panel_1, -1, "Form", ImageID(img_objects))
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      WE_ScrollArea_0 = MDIGadget(#PB_Any, 0, 0, 150, 150, 0, 0)
      UseGadgetList(WindowID(WE)) ; вернёмся к списку гаджетов главного окна
      
    CompilerElse 
      WE_ScrollArea_0 = ScrollAreaGadget(#PB_Any, 0, 0, 150, 150, 900, 800)
      SetGadgetColor(WE_ScrollArea_0, #PB_Gadget_BackColor, $BEBEBE)
      CloseGadgetList()
    CompilerEndIf
    
    AddGadgetItem(WE_Panel_1, -1, "Code", ImageID(img_code))
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
      WE_Scintilla_0 = Scintilla::Gadget(#PB_Any, 0, 0, 420, 600, 0, "x86_scintilla.dll", "x86_SyntaxHilighting.dll")
    CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
      WE_Scintilla_0 = Scintilla::Gadget(#PB_Any, 0, 0, 420, 600, 0, "x64_scintilla.dll", "x64_SyntaxHilighting.dll")
    CompilerEndIf
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
    Case "Properties" : Properties::Size(GadgetWidth, GadgetHeight)
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
  
  If *This\Content\Text$
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
    Case #PB_Event_CloseWindow ;- Close(Event)
      
      ProcedureReturn WE_Close()
      ;-
    Case #PB_Event_Gadget ;- Gadget(Event)
      Object = GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting))
              
      Select EventGadget()
        Case WE_Panel_0
          
          If EventType() = #PB_EventType_Change
            If GetGadgetText(EventGadget())="Events"
              ;WE_SaveFile("Test_4.pb")
              Debug ""
              PushListPosition(ParsePBObject())
              ForEach ParsePBObject()
                Debug ParsePBObject()\Object\Argument$ +" "+ *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Function")\Position 
                
                Debug ParsePBObject()\Content\String$
                Debug ParsePBObject()\Content\Text$
                
                Debug "  Code_Object" + *This\get("Code")\Code("Code_Object")\Position
                Debug "  Code_Function" + *This\get(*This\get(Str(ParsePBObject()\Parent\Argument))\Object\Argument$)\Code("Code_Function")\Position
                
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
              CO_Update(Object, EventGadget())
              
          EndSelect
          
        Case Properties_ID
          
          Select EventType()
            Case #PB_EventType_Change      
              ;Case #PB_EventType_LostFocus
              WE_Replace_ID(WE_Selecting)
              
          EndSelect
          
        Case WE_Selecting
          
          Select EventType()
            Case #PB_EventType_RightClick    
              Transformation::DisplayMenu(Object)
              
            Case #PB_EventType_Change     
              CO_Change(Object)
              
          EndSelect
          
        Case WE_Objects
          
          Select EventType()
            Case #PB_EventType_DragStart
              DragText(GetGadgetItemText(WE_Objects, GetGadgetState(WE_Objects)))
          EndSelect
          
      EndSelect
      
      ;-  
    Case #PB_Event_Menu ;- Menu(Event)
      
      Select EventMenu()
        Case WE_Menu_Quit
          End
          
        Case WE_Menu_Delete ;- Event(_WE_Menu_Delete_) 
                            ; Debug EventGadget()
          CO_Free(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
          
        Case WE_Menu_Open ;- Event(_WE_Menu_Open_) 
          WE_OpenFile(OpenFileRequester("Выберите файл с описанием окон", *This\Content\File$, "Все файлы|*", 0))
          
        Case WE_Menu_Save_as ;- Event(_WE_Menu_Save_as_) 
          If Not WE_SaveFile("Test_0.pb") ; SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
            MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
          EndIf
          ProcedureReturn EventData()
          
        Case WE_Menu_Save ;- Event(_WE_Menu_Save_) 
          If Not WE_SaveFile(*This\Content\File$)
            If Not WE_SaveFile(SaveFileRequester("Сохранить файл как ..", *This\Content\File$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0))
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
  
  While IsWindow(WE)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case WE ; Editor
        If WE_Events( Event ) = #PB_Event_CloseWindow
          CloseWindow(WE)
          Break
        EndIf
        
      Case W_IH ; Image helper
        If W_IH_Events( Event ) = #PB_Event_CloseWindow
          
          CloseWindow(W_IH)
        EndIf
        
      Case W_SH ; Splitter helper
        If W_SH_Events( Event ) = #PB_Event_CloseWindow
          DisableWindow(WE, #False)
          DisableWindow(W_SH_Parent, #False)
          
          Define Gadget1.String, Gadget2.String, Flag.String
          If W_SH_Return(@Gadget1, @Gadget2, @Flag)
            ;           Debug "Gadget1 "+Gadget1\s
            ;           Debug "Gadget2 "+Gadget2\s
            If Not get_object_id(Gadget1\s)
              CO_Create(Gadget1\s, W_SH_MouseX, W_SH_MouseY, W_SH_Object)
              Define First$ = *This\Object\Argument$
            EndIf
            If Not get_object_id(Gadget2\s)
              CO_Create(Gadget2\s, W_SH_MouseX, W_SH_MouseY, W_SH_Object)
              Define Second$ = *This\Object\Argument$
            EndIf
            
            *This\Param1\Argument$ = First$
            *This\Param2\Argument$ = Second$
            *This\Flag\Argument$ = Flag\s
            CO_Create("splitter", W_SH_MouseX, W_SH_MouseY, W_SH_Object)
            
          EndIf
          
          CloseWindow(W_SH)
        EndIf
        
    EndSelect
  Wend
CompilerEndIf

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 701
; FirstLine = 606
; Folding = --------------w+-----------------------------------------------------------
; EnableXP