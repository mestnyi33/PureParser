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
XIncludeFile "include/Img.pbi"
XIncludeFile "include/Constant.pbi"
XIncludeFile "include/Caret.pbi"
XIncludeFile "include/Disable.pbi"
XIncludeFile "include/Resize.pbi"
XIncludeFile "include/Hide.pbi"
XIncludeFile "include/Flag.pbi"
XIncludeFile "include/Properties.pbi"
XIncludeFile "include/Transformation.pbi"

; helpers
XIncludeFile "include/Helper/Splitter.pbi"
XIncludeFile "include/Helper/Image.pbi"

XIncludeFile "include/Scintilla.pbi"
Global WE_Code=-1, CodeShow.b


;-
;- GLOBAL
Global MainWindow=-1
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

Macro change_current_object_from_class(_class_)
  ChangeCurrentElement(ParsePBObject(), *This\get(_class_)\Adress)
EndMacro

Macro change_current_object_from_id(_object_)
  change_current_object_from_class(Str(_object_))
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
  *This\get(Str(_object_))\Class\Argument$
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

Structure ContentStruct
  File$
  Text$    ; Содержимое файла 
  String$  ; Строка к примеру: "OpenWindow(#Window_0, x, y, width, height, "Window_0", #PB_Window_SystemMenu)"
  Position.i  ; Положение Content-a в исходном файле
  Length.i    ; длинна Content-a в исходном файле
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

Procedure WE_Code_Show(Text$)
  Scintilla::SetText(WE_Scintilla_0, Text$)
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
Structure WindowImageStruct
  x.i
  y.i
  ID.i[5]
EndStructure

Structure WindowStruct
  Title$
  Flag.i
  Parent.i
  Gadget.i
  Ico.i
  Img.WindowImageStruct
EndStructure

Procedure wg(Object.i) ; Ok
  If IsGadget(Object)
    Protected *wg.WindowStruct = GetGadgetData(Object)
    If *wg And GadgetType(Object) = #PB_GadgetType_Canvas  
      ProcedureReturn *wg\Gadget
    Else
      ProcedureReturn Object
    EndIf
  EndIf
  ProcedureReturn Object
EndProcedure

Procedure WindowContentUpdate(Gadget)
  Protected x,y, Steps=4, w, h, BackColor
  
  w=GadgetWidth(Gadget)
  h=GadgetHeight(Gadget)
  
  If StartDrawing(CanvasOutput(Gadget))
    ;     If w > OutputWidth()
    ;       w = OutputWidth()
    ;     EndIf
    ;     If h > OutputHeight()
    ;       h = OutputHeight()
    ;     EndIf
    
    ;     Box(0, 0, w, h, $000000)
    ;     Box(1, 1, w-2, h-2, $E6E6E6)
    CompilerIf #PB_Compiler_OS  = #PB_OS_Windows
      BackColor = GetSysColor_( #COLOR_BTNFACE )
    CompilerElse
      BackColor = $D0D0D0
    CompilerEndIf
    
    Box(0, 0, w, h, BackColor)
    
    For x = 0 To OutputWidth()-1
      For y = 0 To OutputHeight()-1
        Plot(x,y,$000000)
        y+Steps
      Next
      x+Steps
    Next
    
    StopDrawing()
  EndIf
EndProcedure

Procedure WindowUpdate(*wg.WindowStruct)
  Protected x,y, Steps=4
  Protected w=GadgetWidth(*wg\Parent)
  Protected h=GadgetHeight(*wg\Parent)
  Protected Alpha = 128 
  
  If StartDrawing(CanvasOutput(*wg\Parent))
    Box(0, 0, OutputWidth(), OutputHeight(), $E6E6E6)
    ;Box(OutputWidth()-25, 5, 20, 15, $4A4C4D)
    DrawingMode(#PB_2DDrawing_Gradient)
    BackColor($FCECDA)
    FrontColor($FCE0C4)
    LinearGradient(0, 0, 0, 30)
    
    DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
    Box(0, 0, w, h, $FBE8C7 | $80000000)
    BackColor(#PB_Default)
    FrontColor(#PB_Default)
    
    DrawingMode(#PB_2DDrawing_Outlined)
    Box(0, 0, w, h, $6C6C6D)
    Box(4, 20+4, w-8, h-8-20, $999999)
    DrawingMode(#PB_2DDrawing_Transparent)
    DrawText(5+1, 3, *wg\Title$, $000000);PeekS(GetGadgetData(CaptionGadget)), $000000)
                                         ; Draw images
                                         ;If *wg\Flag&#PB_Window_SystemMenu And 
    If IsImage(*wg\Img\id[4])
      DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
      Box(w-30-7-4, 2, 26+4+4, 16, $3030FF | $80000000)
      
      DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
      Box(w-30-7-4, 2, 26+4+4, 16, $A9A9FF | $80000000)
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawAlphaImage(ImageID(*wg\Img\id[4]), w-24-8, 2, Alpha) ; 
    EndIf
    StopDrawing()
  EndIf
EndProcedure

Procedure wgCallBack()
  Protected w,h,Steps=4,Gadget = EventGadget()
  Protected *wg.WindowStruct = GetGadgetData(Gadget)
  w=GadgetWidth(Gadget)
  h=GadgetHeight(Gadget)
  
  Select EventType()
    Case #PB_EventType_Move
      ;       ResizeGadget(*wg\Gadget, GadgetX(Gadget), GadgetY(Gadget)-GadgetHeight(*wg\Gadget), #PB_Ignore, #PB_Ignore)
      ;       ResizeGadget(*wg\Gadget, #PB_Ignore, #PB_Ignore, GadgetWidth(Gadget), #PB_Ignore)
      
    Case #PB_EventType_Size
      ResizeGadget(*wg\Gadget, #PB_Ignore, #PB_Ignore, GadgetWidth(Gadget)-10, GadgetHeight(Gadget)-20-10)
      WindowContentUpdate(*wg\Gadget)
      WindowUpdate(*wg)
      
  EndSelect
EndProcedure

Procedure WindowGadget(Gadget, X,Y,Width,Height, Title$="", Flag=0)
  Protected *wg.WindowStruct = AllocateStructure(WindowStruct)
  With *wg
    \Flag = Flag
    \Title$ = Title$  
    \Img\id[4] = img_close
    
    \Parent = CanvasGadget(#PB_Any, x-5,y-20-5, Width+10,Height+20+10, #PB_Canvas_Container|#WS_CLIPSIBLINGS) 
    \Gadget = CanvasGadget(Gadget, 5,25,Width,Height, #PB_Canvas_Container) : CloseGadgetList() : If IsGadget(Gadget) : \Gadget = Gadget : EndIf
    CloseGadgetList()
    
    Resize::Gadget(\Gadget)
    Resize::Gadget(\Parent)
    
    SetGadgetData(\Parent, *wg)
    ;SetGadgetData(\Gadget, \Parent)
    
    WindowUpdate(*wg)
    WindowContentUpdate(\Gadget)
    BindGadgetEvent(\Parent, @wgCallBack())
    
    OpenGadgetList(\Gadget)
    ProcedureReturn \Parent;\Gadget
  EndWith
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

Procedure$ PC_Replace() ; Ok
  Protected ID$, Handle$, Result$
  
  With ParsePBObject()
    If Asc(\Object\Argument$) = '#'
      ID$ = \Object\Argument$
    Else
      Handle$ = \Object\Argument$+" = "
      ID$ = "#PB_Any"
    EndIf
    
    Select \Type\Argument$
        Case "OpenWindow", "WindowGadget"          : Result$ = Handle$+"OpenWindow("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                                                   : If \Flag\Argument$ : Result$ +", "+\Flag\Argument$ : EndIf
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

Procedure PC_Save(Indent, Replace$="")
  Protected RegExID, Identific$, delete_len
    
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
      ; Это значить удаляем строки
      ; Для этого ищем идентификатор 
      Identific$ = ","+#CRLF$+Space(Len("Global.i "))+\Object\Argument$+"=-1"
      RegExID = CreateRegularExpression(#PB_Any, Identific$)
      delete_len = Len(Identific$)
      
      If RegExID
        If ExamineRegularExpression(RegExID, *This\Content\Text$)
          While NextRegularExpressionMatch(RegExID)
            *This\get(*This\Window\Argument$)\Code("Code_Global")\Position = RegularExpressionMatchPosition(RegExID)
            Break
          Wend
        EndIf
        
        *This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, "")
        FreeRegularExpression(RegExID)
      EndIf
      
      ; Ищем строки функции
      Identific$ = #CRLF$+Space(Indent)+\Content\String$
      If \Container
        Identific$ = Identific$+#CRLF$+Space(Indent)+"CloseGadgetList()"
      EndIf
      delete_len = Len(Identific$)+delete_len
    EndIf
    
;     Debug "-> "+Identific$
;     Debug " -> "+Replace$
    
    Identific$ = ReplaceString(Identific$, "(", "\(")
    Identific$ = ReplaceString(Identific$, ")", "\)")
    RegExID = CreateRegularExpression(#PB_Any, Identific$)
    
    If RegExID
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Object")\Position - delete_len
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
    PC_Save(Indent)
    
    *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count-1 
    If *This\get(Str(\Parent\Argument)+"_"+\Type\Argument$)\Count =< 0
      DeleteMapElement(*This\get(), Str(\Parent\Argument)+"_"+\Type\Argument$)
    EndIf
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

;-
;- CREATE_OBJECT
Declare CO_Create(Type$, X, Y, Parent=-1)
Declare CO_Open()

Macro CO_Flag(Flag) ; Ok
  Properties::GetPBFlag(Flag)
EndMacro

Procedure CO_Init(Object.i)
  PushListPosition(ParsePBObject())
  Protected *Adress = *This\get(Str(Object))\Adress
  If *Adress And ChangeCurrentElement(ParsePBObject(), *Adress)
    With ParsePBObject()
      Transformation::Create(Object, \Parent\Argument, \Window\Argument, \Item, 5)
      If IsGadget(Object) And GadgetType(Object) = #PB_GadgetType_Splitter
        Transformation::Free(GetGadgetAttribute(Object, #PB_Splitter_FirstGadget))
        Transformation::Free(GetGadgetAttribute(Object, #PB_Splitter_SecondGadget))
      EndIf
      Properties::Init(Object, \Object\Argument$, \Flag\Argument$)
      Transformation::Change(Object)
    EndWith
  EndIf
  PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Update(Object.i)
  PushListPosition(ParsePBObject())
  Protected *Adress = *This\get(Str(Object))\Adress
  If *Adress And ChangeCurrentElement(ParsePBObject(), *Adress)
    With ParsePBObject()
      ParsePBObject()\Flag\Argument$ = Properties::GetCheckedText(Properties_Flag) 
    EndWith
  EndIf
  PopListPosition(ParsePBObject())
EndProcedure

Procedure CO_Change(Object.i)
  PushListPosition(ParsePBObject())
  Protected *Adress = *This\get(Str(Object))\Adress
  If *Adress And ChangeCurrentElement(ParsePBObject(), *Adress)
    With ParsePBObject()
      Properties::Init(\Object\Argument, \Object\Argument$, \Flag\Argument$)
      Transformation::Change(\Object\Argument)
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
          ; При выборе гаджета обнавляем испектор
          For I=0 To CountGadgetItems(WE_Selecting)-1
            If Object = GetGadgetItemData(WE_Selecting, I) 
              SetGadgetState(WE_Selecting, I)
              CO_Change(Object)
              Break
            EndIf
          Next  
          
          PushListPosition(ParsePBObject())
          If ChangeCurrentElement(ParsePBObject(), *This\get(Str(Object))\Adress)
            With ParsePBObject()
              ;\Object\Argument$ = GetGadgetText(Properties_ID) 
              \X\Argument$ = GetGadgetText(Properties_X) 
              \Y\Argument$ = GetGadgetText(Properties_Y) 
              \Width\Argument$ = GetGadgetText(Properties_Width) 
              \Height\Argument$ = GetGadgetText(Properties_Height) 
              \Caption\Argument$ = GetGadgetText(Properties_Caption) 
              \Flag\Argument$ = GetGadgetText(Properties_Flag) 
              
              PC_Save(Indent, PC_Replace())
            EndWith
          EndIf
          PopListPosition(ParsePBObject())
          
          WE_Code_Show(*This\Content\Text$)
          
          Debug GetGadgetText(Properties_Width)
          
;           PushListPosition(ParsePBObject())
;           ForEach ParsePBObject()
;             PC_Save(Indent, PC_Replace(ParsePBObject()))
;           Next
;           PopListPosition(ParsePBObject())
      EndSelect
      
    Case #PB_Event_WindowDrop, #PB_Event_GadgetDrop
      If EventDropText() = "splittergadget"
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

Procedure CO_Insert(*Parse.ParseStruct, Parent)
  Protected ID$, Handle$
  CodeShow = 1
  
  With *Parse
    
    ; 
    Protected Variable$, VariableLength
    
    If \Type\Argument$ = "OpenWindow" Or \Type\Argument$ = "WindowGadget"
      Variable$ = #CRLF$+"Global.i "+\Object\Argument$+"=-1"
    Else
      Variable$ = ","+#CRLF$+Space(Len("Global.i "))+\Object\Argument$+"=-1"
    EndIf
    VariableLength = Len(Variable$)
    
    Debug "  Code_Global" + *This\get(*This\Window\Argument$)\Code("Code_Global")\Position
    *This\Content\Text$ = InsertString(*This\Content\Text$, Variable$, *This\get(*This\Window\Argument$)\Code("Code_Global")\Position) 
    *This\get(*This\Window\Argument$)\Code("Code_Global")\Position + VariableLength
    
    Debug "  Code_Object" + *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Object")\Position
    \Content\Position = *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Object")\Position  + VariableLength
    
    If VariableLength
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Object")\Position + VariableLength
        EndIf
      Next
      PopListPosition(ParsePBObject())
    EndIf
    
    \Content\String$ = PC_Replace()
    \Content\Length = Len(\Content\String$)
    
    *This\Content\Length = \Content\Length
    *This\Content\Position = \Content\Position
    *This\Content\Text$ = InsertString(*This\Content\Text$, \Content\String$+#CRLF$+Space(Indent), \Content\Position) 
    
    
    ; У окна меняем последную позицию.
    *This\get(*This\Window\Argument$)\Code("Code_Object")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
    
    ; 
    If *This\Container
      ; Сохряняем у объект-а последную позицию.
      *This\get(\Object\Argument$)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
      Debug \Object\Argument$ +" "+ *This\get(\Object\Argument$)\Code("Code_Object")\Position 
      
      Select *This\Type\Argument$
        Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
          ; 
          *This\Content\Text$ = InsertString(*This\Content\Text$, "CloseGadgetList()"+#CRLF$+Space(Indent), *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))) 
          *This\Content\Position+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
          ; У окна меняем последную позицию.
          *This\get(*This\Window\Argument$)\Code("Code_Object")\Position + Len("CloseGadgetList()"+#CRLF$+Space(Indent))
          
      EndSelect
      
    Else
      If IsGadget(Parent)
        PushListPosition(ParsePBObject())
        ForEach ParsePBObject()
          Select ParsePBObject()\Container
            Case #PB_GadgetType_Panel, #PB_GadgetType_Container, #PB_GadgetType_ScrollArea, #PB_GadgetType_Canvas
              ; Проверяем позицию родителя в генерируемом коде
              If *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Object")\Position>*This\Content\Position
                ; У родителя меняем последную позицию.
                *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Object")\Position + (*This\Content\Length + Len(#CRLF$+Space(Indent)))
              EndIf
          EndSelect
        Next
        PopListPosition(ParsePBObject())
      EndIf
      
    EndIf
    
    ; Записываем у родителя позицию конца добавления объекта
    *This\get(*This\get(Str(Parent))\Object\Argument$)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length+Len(#CRLF$+Space(Indent))
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
      Case "WindowGadget" : \Type\Argument$ = "WindowGadget"
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
                  \Class\Argument$=ReplaceString(Buffer, "Open","")+"_"
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
        Case "OpenWindow", "WindowGadget" 
          \Container =- 1 
          \Window\Argument$ = \Object\Argument$ 
          \Parent\Argument$ = \Object\Argument$
        Case "PanelGadget" : \Container = #PB_GadgetType_Panel
          \Parent\Argument$ = \Object\Argument$
        Case "ContainerGadget" : \Container = #PB_GadgetType_Container
          \Parent\Argument$ = \Object\Argument$
        Case "ScrollAreaGadget" : \Container = #PB_GadgetType_ScrollArea
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
        \get(\Window\Argument$)\Code("Code_Global")\Position = 16
        \get(\get(Str(Parent))\Object\Argument$)\Code("Code_Object")\Position = 249+75+2
      EndIf
      
      CO_Insert(*ThisParse, Parent) 
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
      
      Select \Type\Argument ; GadgetType(Object)
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
    Data.s "WindowGadget","300","200","ParentID","0","0", "#PB_Window_SystemMenu"
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
      Case "WindowGadget"          : \Type\Argument =- 1  : \Window\Argument =- 1  
        \Flag\Argument = #PB_Canvas_Container
        \Object\Argument = WindowGadget(#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument);, \Param1\Argument)
      Case "OpenWindow"          : \Type\Argument =- 1  : \Window\Argument =- 1  : \Object\Argument = OpenWindow          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument, \Param1\Argument)
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
      Case "WindowGadget" 
        \Window\Argument = EventWindow() 
        \Parent\Argument = wg(\Object\Argument)
        \Container = \Type\Argument : \SubLevel = 1
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
        
        If \Type\Argument$ = "WindowGadget"
          EnableGadgetDrop(\Parent\Argument, #PB_Drop_Text, #PB_Drag_Copy)
          BindEvent(#PB_Event_GadgetDrop, @CO_Events(), \Window\Argument, \Parent\Argument)
          BindEvent(#PB_Event_Gadget, @CO_Events(), \Window\Argument)
        Else
          EnableGadgetDrop(\Object\Argument, #PB_Drop_Text, #PB_Drag_Copy)
          BindEvent(#PB_Event_GadgetDrop, @CO_Events(), \Window\Argument, \Object\Argument)
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
      PostEvent(#PB_Event_Gadget, \Window\Argument, \Object\Argument, #PB_EventType_Create, \Parent\Argument)
      
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
                  If \Type\Argument$ = "OpenWindow"
                    \Type\Argument$ = "WindowGadget"
                    OpenGadgetList(WE_ScrollArea_0)
                  EndIf
                  
                  Select \Type\Argument$
                    Case "OpenWindow","WindowGadget", 
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
                                  
                                Case "OpenWindow", "WindowGadget"
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
                                    ElseIf \Type\Argument$="WindowGadget"
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
                                
                              Case 6 : ParsePBObject()\Caption\Argument$ = Arg$
                                \Caption\Argument$ = GetStr(Arg$) 
                                
                              Case 7 : ParsePBObject()\Param1\Argument$ = Arg$
                                Select \Type\Argument$ 
                                  Case "OpenWindow", "WindowGadget"      
                                    \Param1\Argument$ = get_argument_string(Arg$)
                                    
                                    ; Если идентификаторы окон цыфри
                                    If Val(\Param1\Argument$)
                                      \Param1\Argument$+"_Window"
                                    ElseIf Val(\Param1\Argument$)
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
                                ParsePBObject()\Flag\Argument$ = Arg$
                            EndSelect
                            
                          EndIf
                        Wend
                      EndIf
                      
                      If \Type\Argument$ = "WindowGadget"
                        \X\Argument = 30
                        \Y\Argument = 30
                        *This\Parent\Argument = WE_ScrollArea_0
                      EndIf
                      
                      ; Сначала определять кто есть кто.
                      Select *This\Type\Argument$
                        Case "WindowGadget" 
                          *This\Container =- 1 
                          *This\Window\Argument$ = *This\Object\Argument$
                          *This\Parent\Argument$ = *This\Object\Argument$
                        Case "OpenWindow" 
                          *This\Container =- 1 
                          *This\Window\Argument$ = *This\Object\Argument$ 
                          *This\Parent\Argument$ = *This\Object\Argument$
                        Case "PanelGadget" : *This\Container = #PB_GadgetType_Panel
                          *This\Parent\Argument$ = *This\Object\Argument$
                        Case "ContainerGadget" : *This\Container = #PB_GadgetType_Container
                          *This\Parent\Argument$ = *This\Object\Argument$
                        Case "ScrollAreaGadget" : *This\Container = #PB_GadgetType_ScrollArea
                          *This\Parent\Argument$ = *This\Object\Argument$
                        Case "CanvasGadget"
                          If ((*This\Flag\Argument&#PB_Canvas_Container)=#PB_Canvas_Container)
                            *This\Container = #PB_GadgetType_Canvas
                            *This\Parent\Argument$ = *This\Object\Argument$
                          EndIf
                        Default
                          *This\Container = #PB_GadgetType_Unknown
                      EndSelect
                      
                      ; ;                       ; Первый вариант
                      ; ;                       ; Ищем Declare и затем отходим на 4 шага (на две концы сторки)
                      ; ;                       Protected RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+"Declare"+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
                      ; ;                       
                      ; ;                       If RegExID
                      ; ; ;                      ; Получаем позицию идентификаторов в файле
                      ; ;                         If ExamineRegularExpression(RegExID, *This\Content\Text$)
                      ; ;                           While NextRegularExpressionMatch(RegExID)
                      ; ;                            *This\get(*This\Window\Argument$)\Code("Code_Global")\Position = RegularExpressionMatchPosition(RegExID)-Len(#CRLF$)*2 ;*This\Content\Text$ = ReplaceRegularExpression(RegExID, *This\Content\Text$, Trim(Replace$, "#"))
                      ; ;                             Break
                      ; ;                           Wend
                      ; ;                         EndIf
                      ; ;                         
                      ; ;                         FreeRegularExpression(RegExID)
                      ; ;                       EndIf
                      
                      ; Второй вариант
                      ; Ищем идентификатор и затем добавлаем его длину
                      Protected Identific$ = *This\Object\Argument$+"=-1"
                      Protected RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+Identific$+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
                      
                      If RegExID
                        ;                      ; Получаем позицию идентификаторов в файле
                        If ExamineRegularExpression(RegExID, *This\Content\Text$)
                          While NextRegularExpressionMatch(RegExID)
                            *This\get(*This\Window\Argument$)\Code("Code_Global")\Position = RegularExpressionMatchPosition(RegExID)+Len(Identific$)
                            Break
                          Wend
                        EndIf
                        
                        FreeRegularExpression(RegExID)
                      EndIf
                      Debug *This\get(*This\Window\Argument$)\Code("Code_Global")\Position
                      
                      ; Запоминаем последнюю позицию
                      If *This\Container
                        *This\get(*This\Object\Argument$)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                        
                        Select *This\Type\Argument$
                          Case "PanelGadget", "ContainerGadget", "ScrollAreaGadget", "CanvasGadget"
                            *This\get(*This\Window\Argument$)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))+Len("CloseGadgetList()"+#CRLF$+Space(Indent))
                        EndSelect
                      Else
                        *This\get(*This\Window\Argument$)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                      EndIf
                      
                      ; ; ;                       ; Записываем у родителя позицию конца добавления объекта
                      ; ; ;                      ; *This\get(*This\get(Str(*This\Parent\Argument))\Object\Argument$)\Code("Code_Object")\Position = *This\Content\Position+*This\Content\Length +Len(#CRLF$+Space(Indent))
                      ; ; ;                       Debug "Load Code_Global"+ *This\get(Str(*This\Window\Argument))\Object\Argument$ +" "+ *This\get(*This\get(Str(*This\Window\Argument))\Object\Argument$)\Code("Code_Global")\Position
                      ; ; ;                       Debug "w Code_Object"+ *This\Window\Argument$ +" "+ *This\get(*This\Window\Argument$)\Code("Code_Object")\Position
                      ; ; ;                       Debug "Load Code_Object"+ *This\get(Str(*This\Parent\Argument))\Object\Argument$ +" "+ *This\get(*This\get(Str(*This\Parent\Argument))\Object\Argument$)\Code("Code_Object")\Position
                      ; ; ;                       ;     Debug "    Code_Global"+ *This\get(*This\get(Replace$)\Window\Argument$)\Code("Code_Global")\Position
                      ; ; ;                       ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Parent\Argument$)\Code("Code_Object")\Position
                      
                      
                      
                      
                      
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
                    AddGadgetItem(WE_Objects, -1, GadgetName, ImageID(GadgetImage))
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
  Protected i
  
  ; Добавляем объекты к списку
  If Position=-1
    PushListPosition(ParsePBObject())
    ForEach ParsePBObject()
      Position = CountGadgetItems(Gadget)
      AddGadgetItem (Gadget, -1, ParsePBObject()\Object\Argument$, 0, ParsePBObject()\SubLevel)
      SetGadgetItemData(Gadget, Position, ParsePBObject()\Object\Argument)
    Next
    PopListPosition(ParsePBObject())
  Else
    AddGadgetItem(Gadget, Position, ParsePBObject()\Object\Argument$, 0, ParsePBObject()\SubLevel)
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
    
    ; 
    RegExID = CreateRegularExpression(#PB_Any, "(?<![\w\.\\])"+Trim(Find$, "#")+"(?=[_]|(?![\w\.\\]|\s*"+~"\"))")
    
    If RegExID
      Protected NbFound, String$, Dim Result$(0) 
      ; Разница между словами
      len = (Len(Replace$)-Len(Find$))
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Global")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      *This\get(*This\Window\Argument$)\Code("Code_Global")\Position + NbFound
      
      ; Делаем разницу столько раз сколько слов заменено
      String$ = Mid(*This\Content\Text$, 1, *This\get(Replace$)\Code("Code_Object")\Position)
      NbFound = len*ExtractRegularExpression(RegExID, String$, Result$())
      
      PushListPosition(ParsePBObject())
      ForEach ParsePBObject()
        If ParsePBObject()\Container 
          *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Object")\Position + NbFound
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
    
    ;     Debug "    Code_Global"+ *This\get(*This\get(Replace$)\Window\Argument$)\Code("Code_Global")\Position
    ;     Debug "    Code_Object"+ *This\get(*This\get(Replace$)\Parent\Argument$)\Code("Code_Object")\Position
    
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
  
  ForEach ParsePBObject()
    PC_Save(Indent, PC_Replace())
  Next
  
;     With ParsePBObject()
;       ForEach ParsePBObject()
;         ;         If \Content\String$=""
;         ;           \Length = 53
;         ;           \Position = 409
;         ;           \Content\String$ = ~"OpenWindow(#Window_0, 230,230,240,200,\"Window_0\", Flag)"
;         ;         EndIf
;         
;         
;         Text$ = \Content\String$
;         Length = CO_Save(ParsePBObject())
;         
;         ;         If Text$= ""
;         ;           Text$=\Content\String$
;         ;           EndIf
;         
;         If (Length>\Content\Length)
;           Position = \Content\Position
;           *This\Content\Text$ = InsertString(*This\Content\Text$, Space(Length), 1+(\Content\Position+\Content\Length+len))
;           \Content\Length = Length
;           \Content\Position + Len
;           len + Length
;         Else
;           \Content\String$ + Space((\Content\Length-Length))
;         EndIf
;         
;         Debug ""+Str(Position)+" "+Str(Length)+" "+Text$+" "+\Object\Argument$
;         Debug "  "+Str(\Content\Position)+" "+Str(\Content\Length)+" "+\Content\String$+" "+\Object\Argument$
;         ;*This\Content\Text$=ReplaceString(*This\Content\Text$, Text$, \Content\String$, #PB_String_CaseSensitive, Position, 1)
;         ReplaceString(*This\Content\Text$, Text$, \Content\String$, #PB_String_InPlace, Position, 1)
;         ;Replace(\Content\String$, Text$, \Content\Position)
;       Next
;     EndWith
    PopListPosition(ParsePBObject())
     
    WE_Code_Show(*This\Content\Text$)
 Debug *This\Content\Text$
    
;     If CreateFile(#File, *This\Content\File$, #PB_UTF8)
;       WriteStringFormat(#File, #PB_UTF8)
;       WriteString(#File, *This\Content\Text$, #PB_UTF8)
;       CloseFile(#File)
;       
;       Debug "..успешно"
;     Else
;       MessageRequester("Information","may not create the file!")
;     EndIf
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
    
    AddGadgetItem(WE_Panel_0, -1, "Objects")
    WE_Objects = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
    EnableGadgetDrop(WE_Objects, #PB_Drop_Text, #PB_Drag_Copy)
    
    AddGadgetItem(WE_Panel_0, -1, "Properties")
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
    
    AddGadgetItem(WE_Panel_1, -1, "Form")
    WE_ScrollArea_0 = ScrollAreaGadget(#PB_Any, 0, 0, 150, 150, 900, 800)
    SetGadgetColor(WE_ScrollArea_0, #PB_Gadget_BackColor, $BEBEBE)
    CloseGadgetList()
    
    AddGadgetItem(WE_Panel_1, -1, "Code")
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
    Case "Form" : ResizeGadget(WE_ScrollArea_0, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
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
      
      Select EventGadget()
        Case WE_Panel_0
          
          If EventType() = #PB_EventType_Change
            If GetGadgetText(EventGadget())="Events"
              ;WE_SaveFile("Test_4.pb")
              Debug ""
              PushListPosition(ParsePBObject())
              ForEach ParsePBObject()
                ;Debug ParsePBObject()\Object\Argument$ +" "+ *This\get(ParsePBObject()\Object\Argument$)\Code("Code_Object")\Position 
                
                Debug ParsePBObject()\Content\String$
                Debug ParsePBObject()\Content\Text$
                
              Next
              PopListPosition(ParsePBObject())
            EndIf
          EndIf
          
        Case Properties_Image
          
          Select EventType()
            Case #PB_EventType_LeftClick     
              W_IH_Open(WindowID(EventWindow()), #PB_Window_SystemMenu|#PB_Window_WindowCentered)
              
          EndSelect
          
        Case Properties_ID
          
          Select EventType()
            Case #PB_EventType_Change      
              ;Case #PB_EventType_LostFocus
              WE_Replace_ID(WE_Selecting)
              
          EndSelect
          
        Case Properties_Flag 
          
          Select EventType()
            Case #PB_EventType_LostFocus   
              CO_Update(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
              
          EndSelect
          
        Case WE_Selecting
          
          Select EventType()
            Case #PB_EventType_RightClick    
              Transformation::DisplayMenu(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
              
            Case #PB_EventType_Change     
              CO_Change(GetGadgetItemData(WE_Selecting, GetGadgetState(WE_Selecting)))
              
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
          CO_Create("WindowGadget",30,30+20+30, WE_ScrollArea_0)
          ;CO_Create("Window",30,30)
          
          ;           WE_OpenFile("Window_0.pb")
          
          
          SetGadgetState(WE_Panel_0, 0)
          
          
      EndSelect
      
  EndSelect
  
  ProcedureReturn Event
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  ; Инициализация окна редактора
  MainWindow = WE_Open(0,#PB_Window_MinimizeGadget|#PB_Window_SizeGadget)
  
  If CountProgramParameters()=1 
    WE_OpenFile(ProgramParameter(0))
  EndIf
  
  While IsWindow(WE)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case WE
        If WE_Events( Event ) = #PB_Event_CloseWindow
          CloseWindow(WE)
          Break
        EndIf
        
      Case W_IH
        If W_IH_Events( Event ) = #PB_Event_CloseWindow
          
          CloseWindow(W_IH)
        EndIf
        
      Case W_SH
        If W_SH_Events( Event ) = #PB_Event_CloseWindow
          DisableWindow(WE, #False)
          DisableWindow(W_SH_Parent, #False)
          
          Define Gadget1.String, Gadget2.String, Flag.String
          If W_SH_Return(@Gadget1, @Gadget2, @Flag)
            ;           Debug "Gadget1 "+Gadget1\s
            ;           Debug "Gadget2 "+Gadget2\s
            If Not get_class_id(Gadget1\s)
              CO_Create(Gadget1\s, W_SH_MouseX, W_SH_MouseY, W_SH_Object)
              Define First$ = *This\Object\Argument$
            EndIf
            If Not get_class_id(Gadget2\s)
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