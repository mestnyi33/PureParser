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

;-
;- GLOBAL
Global MainWindow=-1
Global Window_0=-1, 
       Window_0_Menu_0, 
       Window_0_Tree_0, 
       Window_0_Tree_1, 
       Window_0_Panel_0,
       Window_0_Splitter_0

Global Window_0_Properties
Global Properties_ID 
Global Properties_Image 
Global Properties_Color 
Global Properties_Puch
Global Properties_Flag

Global Window_0_Menu_0_New=1,
       Window_0_Menu_0_Open=2,
       Window_0_Menu_0_Save=3,
       Window_0_Menu_0_Save_as=4,
       Window_0_Menu_0_Close=5

;-
;- DECLARE
Declare Window_Event()
Declare Window_0_Resize_Event()
Declare Window_0_Panel_0_Resize_Event()
Declare$ GetObjectClass(Object)

;-
;- MACRO
Macro ULCase(String)
  InsertString(UCase(Left(String,1)), LCase(Right(String,Len(String)-1)), 2)
EndMacro

Macro GetVarValue(StrToFind)
  Trim(GetRegExString("(?:(\w+)\s*\(.*)?"+StrToFind+"[\.\w]*\s*=\s*([\#\w\|\s]+$|[\#\w\|\s]+)", 2), #CR$)
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

Macro ChangeCurrentObject(ChangeCurrentObjectID)
  ChangeCurrentElement(ParsePBGadget(), *This\Object(ChangeCurrentObjectID)\Index)
EndMacro

Macro ReplaceMapKey(FindReplaceMapKey, ReplaceMapKey)
  Define ReplaceMapData_ID = *This\Object(FindReplaceMapKey)\ID\Argument
  Define ReplaceMapData_Index = *This\Object(FindReplaceMapKey)\Index
  DeleteMapElement(*This\Object(), FindReplaceMapKey)
  AddMapElement(*This\Object(), ReplaceMapKey) 
  *This\Object()\ID\Argument = ReplaceMapData_ID
  *This\Object()\Index = ReplaceMapData_Index
  ChangeCurrentElement(ParsePBGadget(), ReplaceMapData_Index)
EndMacro

Macro ObjectParent(Object)
  *This\Parent(Str(Object)))
EndMacro

;-
;- INCLUDE
DeclareModule Constant
  Enumeration #PB_Event_FirstCustomValue
    #Event_Create
    #Event_Down
    #Event_Up
  EndEnumeration
  EndDeclareModule : Module Constant : EndModule

XIncludeFile "Transformation.pbi"
XIncludeFile "Properties.pbi"




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


Structure Argument
  Argument.i 
  Argument$
EndStructure

Structure FONT
  ID.Argument
  Name$
  Height.i
  Style.i
EndStructure

Structure IMG
  ID.Argument
  Name$
EndStructure

Structure Object
  ID.Argument 
  Index.i
EndStructure

Structure ParsePBGadget
  ID.Argument 
  Type.Argument
  X.Argument 
  Y.Argument
  Width.Argument
  Height.Argument
  Caption.Argument
  Param1.Argument
  Param2.Argument
  Param3.Argument
  Flag.Argument
  
  
  Window.i
  MouseX.i
  MouseY.i
  
  
  Map Class$() ; Получить класс объекта
  Map Object.Object() ; Получить идентификатор объекта
  Map Parent.i()      ; Получить родитель объекта
  
  Map Font.FONT()
  Map Img.IMG()
  
  Content$            ; Содержимое. К примеру: "OpenWindow(#Butler_Window_Settings, x, y, width, height, "Настройки", #PB_Window_SystemMenu)"
  Position.i          ; Положение Content-a в исходном файле
  Length.i            ; длинна Content-a в исходном файле
  SubLevel.i
  
  Args$
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

Runtime Procedure$ GetObjectClass(Object)
  ProcedureReturn *This\Class$(Str(Object))
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
            ID = (\Object(RegularExpressionGroup(#RegEx_Captions1, 3))\ID\Argument)
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
            ID = (\Object(RegularExpressionGroup(#RegEx_Captions, 3))\ID\Argument)
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
    Select \Type\Argument$
      Case "HideWindow", "HideGadget", 
           "DisableWindow", "DisableGadget"
        Select Index
          Case 1 : \ID\Argument$ = \Args$
          Case 2 : \Param1\Argument$ = \Args$
        EndSelect
        
        Select \Param1\Argument$
          Case "#True" : \ID\Argument = #True
          Case "#False" : \Param1\Argument = #False
          Default
            \Param1\Argument = Val(\Param1\Argument$)
        EndSelect
        
      Case "LoadFont"
        Select Index
          Case 1 : \ID\Argument$ = \Args$
          Case 2 : \Param1\Argument$ = \Args$
          Case 3 : \Param2\Argument$ = \Args$
          Case 4 : \Param3\Argument$ = \Args$
        EndSelect
        
      Case "LoadImage", 
           "SetGadgetFont", 
           "SetGadgetState",
           "SetGadgetText"
        Select Index
          Case 1 : \ID\Argument$ = \Args$
          Case 2 : \Param1\Argument$=GetStr(\Args$)
        EndSelect
        
      Case "ResizeGadget"
        Select Index
          Case 1 : \ID\Argument$ = \Args$
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
          Case 1 : \ID\Argument$ = \Args$
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

Procedure SetPBFunction(*This.ParsePBGadget)
  Protected Result, I, ID
  
  With *This
    ID = \Object(\ID\Argument$)\ID\Argument
    
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
        AddMapElement(\Font(), \ID\Argument$) 
        
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
        
        \Font()\ID\Argument=LoadFont(#PB_Any,\Font()\Name$,\Font()\Height,\Font()\Style)
        
      Case "LoadImage"
        AddMapElement(\Img(), \ID\Argument$) 
        \Img()\Name$=\Param1\Argument$
        \Img()\ID\Argument=LoadImage(#PB_Any, \Img()\Name$)
        
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
          Protected Font = \Font(\Param1\Argument$)\ID\Argument
          If IsFont(Font)
            SetGadgetFont(ID, FontID(Font))
          EndIf
          
        Case "SetGadgetState"
          Protected Img = \Img(\Param1\Argument$)\ID\Argument
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
Declare CreateObject(Type$)
Declare OpenPBObject(*This.ParsePBGadget)

Procedure CreatePBObject_Events()
  Protected Object =- 1
  
  Select Event()
    Case Constant::#Event_Create
      If IsGadget(EventGadget())
        Object = EventGadget()
      ElseIf IsWindow(EventWindow())
        Object = EventWindow()
      EndIf
      
      ;Transformation::Enable(EventGadget(), 5)
      PushListPosition(ParsePBGadget())
      ForEach ParsePBGadget()
        If Object = ParsePBGadget()\ID\Argument
          Properties::UpdateProperties(Object, ParsePBGadget()\ID\Argument$, ParsePBGadget()\Flag\Argument$)
        EndIf
      Next
      PopListPosition(ParsePBGadget())
      
      
    Case #PB_Event_WindowDrop
      Static SubLevel
      Protected OpenGadgetList, GetParent
      Protected Result = EventGadget()
      Protected Parent = *This\Parent(Str(Result))
      
      *This\MouseX = WindowMouseX(EventWindow())
      *This\MouseY = WindowMouseY(EventWindow())
      Debug Result
      ;       If IsGadget(Result)
      ;         If IsGadget(Parent)
      ;           GetParent = *This\Parent(Str(Parent))
      ;         EndIf
      ;         
      ;         If Result = Parent
      ;           If IsWindow(GetParent)
      ;             CloseGadgetList() ; Bug PB
      ;             UseGadgetList(WindowID(GetParent))
      ;           EndIf
      ;           If IsGadget(GetParent) 
      ;             OpenGadgetList = OpenGadgetList(GetParent) 
      ;             SubLevel + 1
      ;           EndIf
      ;         EndIf
      ;         
      ; CreateObject(ReplaceString(EventDropText(), "gadget", ""))
      ;         
      ;         If Result = Parent
      ;           If IsWindow(GetParent) 
      ;             OpenGadgetList(Result) 
      ;           EndIf
      ;           If OpenGadgetList 
      ;             CloseGadgetList() 
      ;             SubLevel - 1
      ;           EndIf
      ;         EndIf
      ;         
      ;         ; Debug \ID\Argument$ +" "+ Str(SubLevel) 
      ;         Select GadgetType(Result)
      ;           Case #PB_GadgetType_Container, #PB_GadgetType_Panel, #PB_GadgetType_ScrollArea
      ;             ParsePBGadget()\SubLevel = SubLevel-1
      ;           Default
      ;             ParsePBGadget()\SubLevel = SubLevel
      ;         EndSelect
      ;         
      ;       EndIf
      ;       
  EndSelect
EndProcedure

Procedure CreatePBObject(Type$)
  With *This
    \ID\Argument$= Type$
    
    Select Type$
      Case "Window" 
        \Type\Argument$ = "OpenWindow"
      Case "Menu", "ToolBar"
        \Type\Argument$ = Type$
      Default
        \Type\Argument$=ULCase(Type$) + "Gadget"
    EndSelect
    
    Protected Buffer.s, i.i, j.i, BuffType$
    \Caption\Argument$=\ID\Argument$
    
    AddElement(ParsePBGadget()) 
    ParsePBGadget()\ID\Argument$ = \ID\Argument$
    ParsePBGadget()\Type\Argument$ = \Type\Argument$
    ;ParsePBGadget()\Flag\Argument$ = "#PB_Window_SystemMenu|#PB_Window_ScreenCentered"
    
    Restore Model 
    
    For i=1 To 13
      For j=1 To 10 ; argument count
        Read.s Buffer
        
        Select j
          Case 1  
            If \Type\Argument$=Buffer
              BuffType$ = Buffer
            EndIf
        EndSelect
        
        If BuffType$ = \Type\Argument$
          Select j
            Case 1  : ParsePBGadget()\Type\Argument$=Buffer
            Case 2  : ParsePBGadget()\Width\Argument$=Buffer
            Case 3  : ParsePBGadget()\Height\Argument$=Buffer
            Case 4  : ParsePBGadget()\Caption\Argument$=Buffer
            Case 5  : ParsePBGadget()\Param1\Argument$=Buffer
            Case 6  : ParsePBGadget()\Param2\Argument$=Buffer
            Case 7  : ParsePBGadget()\Param3\Argument$=Buffer
            Case 8  : ParsePBGadget()\Flag\Argument$=Buffer
          EndSelect
        EndIf
      Next  
      BuffType$ = ""
    Next  
    
    \X\Argument = \MouseX
    \Y\Argument = \MouseY
    \Width\Argument = Val(ParsePBGadget()\Width\Argument$)
    \Height\Argument = Val(ParsePBGadget()\Height\Argument$)
    
    \Flag\Argument=OpenPBObjectFlag(ParsePBGadget()\Flag\Argument$)
    Protected Object=CallFunctionFast(@OpenPBObject(), *This)
    
    If IsWindow(Object)
      EnableWindowDrop(Object, #PB_Drop_Text, #PB_Drag_Copy)
      BindEvent(#PB_Event_WindowDrop, @CreatePBObject_Events(), Object)
    EndIf
    
    ;     If IsGadget(Object)
    ;       Select GadgetType(Object)
    ;         Case #PB_GadgetType_Container, #PB_GadgetType_Panel, #PB_GadgetType_ScrollArea
    ;           
    ;           EnableGadgetDrop(Object, #PB_Drop_Text, #PB_Drag_Copy)
    ;           BindEvent(#PB_Event_GadgetDrop, @CreateObject_Events(), \Window, Object)
    ;       EndSelect
    ;     EndIf
    
    AddGadgetItem(Window_0_Tree_0, -1, \ID\Argument$, 0, ParsePBGadget()\SubLevel)
  EndWith
  
  
  DataSection
    Model:
    Data.s "OpenWindow","300","200","Text","Window_0","0","0","1","0",
           "#PB_Window_SystemMenu,"+
           "#PB_Window_MinimizeGadget,"+
           "#PB_Window_MaximizeGadget,"+
           "#PB_Window_SizeGadget,"+
           "#PB_Window_Invisible,"+
           "#PB_Window_TitleBar,"+
           "#PB_Window_BorderLess,"+
           "#PB_Window_Tool,"+
           "#PB_Window_ScreenCentered,"+
           "#PB_Window_WindowCentered,"+
           "#PB_Window_Maximize,"+
           "#PB_Window_Minimize,"+
           "#PB_Window_NoGadgets"
    
    Data.s "ButtonGadget","80","20","Text","Button_","0","0","1","0",
           "#PB_Button_Right,"+
           "#PB_Button_Left,"+
           "#PB_Button_Default,"+
           "#PB_Button_MultiLine,"+
           "#PB_Button_Toggle"
    
    Data.s "CheckBoxGadget","80","20","Text","CheckBox_","0","0","1","0",
           "#PB_CheckBox_Right,"+
           "#PB_CheckBox_Center,"+
           "#PB_CheckBox_ThreeState"
    
    Data.s "ComboBoxGadget","100","20","","Combo_","0","0","1","0",
           "#PB_ComboBox_Editable,"+
           "#PB_ComboBox_LowerCase,"+
           "#PB_ComboBox_UpperCase,"+
           "#PB_ComboBox_Image"
    
    Data.s "EditorGadget","150","200","","Editor_","0","0","1","0",
           "#PB_Editor_ReadOnly"
    
    Data.s "FrameGadget","180","150","Texte","Frame_","1","0","1","0",
           "#PB_Frame3D_Single,"+
           "#PB_Frame3D_Double,"+
           "#PB_Frame3D_Flat"
    
    Data.s "ListIconGadget","180","180","","ListIcon_","0","1","1","0",
           "#PB_ListIcon_CheckBoxes,"+
           "#PB_ListIcon_MultiSelect,"+
           "#PB_ListIcon_GridLines,"+
           "#PB_ListIcon_FullRowSelect,"+
           "#PB_ListIcon_HeaderDragDrop,"+
           "#PB_ListIcon_AlwaysShowSelection"
    
    Data.s "ListViewGadget","150","150","","ListView_","0","0","1","0",
           "#PB_ListView_MultiSelect,"+
           "#PB_ListView_ClickSelect"
    
    Data.s "OptionGadget","80","20","Texte","Option_","0","0","1","0",""
    
    Data.s "StringGadget","80","20","Texte","String_","0","0","1","0",
           "#PB_String_Password,"+
           "#PB_String_ReadOnly,"+
           "#PB_String_Numeric,"+
           "#PB_String_LowerCase,"+
           "#PB_String_UpperCase,"+
           "#PB_String_BorderLess"
    
    Data.s "TextGadget","80","20","Text","Text_","1","0","0","0",
           "#PB_Text_Center,"+
           "#PB_Text_Right,"+
           "#PB_Text_Border"
    
    Data.s "CanvasGadget", "150", "150","","Canvas_", "0","0","1","0",
           "#PB_Canvas_Border,"+
           "#PB_Canvas_ClipMouse,"+
           "#PB_Canvas_Keyboard,"+
           "#PB_Canvas_DrawFocus,"+
           "#PB_Canvas_Container"
    
    Data.s "ImageGadget" , "150", "150","","Image_", "0","0","1","0",
           "#PB_Image_Border,"+
           "#PB_Image_Raised" 
    
  EndDataSection
  
EndProcedure

Procedure OpenPBObject(*This.ParsePBGadget) ; Ok
  Static Parent=-1, SubLevel
  Protected OpenGadgetList, GetParent, Object=-1
  
  With *This
    Select \Type\Argument$
      Case "OpenWindow"          : Object = OpenWindow          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument|#PB_Window_SizeGadget) 
      Case "ButtonGadget"        : Object = ButtonGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "StringGadget"        : Object = StringGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "TextGadget"          : Object = TextGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "CheckBoxGadget"      : Object = CheckBoxGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "OptionGadget"        : Object = OptionGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$)
      Case "ListViewGadget"      : Object = ListViewGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "FrameGadget"         : Object = FrameGadget         (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "ComboBoxGadget"      : Object = ComboBoxGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "ImageGadget"         : Object = ImageGadget         (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Flag\Argument)
      Case "HyperLinkGadget"     : Object = HyperLinkGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Param1\Argument, \Flag\Argument)
      Case "ContainerGadget"     : Object = ContainerGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "ListIconGadget"      : Object = ListIconGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Param1\Argument, \Flag\Argument)
      Case "IPAddressGadget"     : Object = IPAddressGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument)
      Case "ProgressBarGadget"   : Object = ProgressBarGadget   (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
      Case "ScrollBarGadget"     : Object = ScrollBarGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Param3\Argument, \Flag\Argument)
      Case "ScrollAreaGadget"    : Object = ScrollAreaGadget    (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Param3\Argument, \Flag\Argument) 
      Case "TrackBarGadget"      : Object = TrackBarGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
      Case "WebGadget"           : Object = WebGadget           (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$)
      Case "ButtonImageGadget"   : Object = ButtonImageGadget   (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Flag\Argument)
      Case "CalendarGadget"      : Object = CalendarGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Flag\Argument)
      Case "DateGadget"          : Object = DateGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Param1\Argument, \Flag\Argument)
      Case "EditorGadget"        : Object = EditorGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "ExplorerListGadget"  : Object = ExplorerListGadget  (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "ExplorerTreeGadget"  : Object = ExplorerTreeGadget  (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "ExplorerComboGadget" : Object = ExplorerComboGadget (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Caption\Argument$, \Flag\Argument)
      Case "SpinGadget"          : Object = SpinGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
      Case "TreeGadget"          : Object = TreeGadget          (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
      Case "PanelGadget"         : Object = PanelGadget         (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument) 
      Case "SplitterGadget"      
        Debug "Splitter FirstGadget "+\Param1\Argument
        Debug "Splitter SecondGadget "+\Param2\Argument
        If IsGadget(\Param1\Argument) And IsGadget(\Param2\Argument)
          Object = SplitterGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument)
        EndIf
      Case "MDIGadget"          
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          Object = MDIGadget           (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument, \Param2\Argument, \Flag\Argument) 
        CompilerEndIf
      Case "ScintillaGadget"     : Object = ScintillaGadget     (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument)
      Case "ShortcutGadget"      : Object = ShortcutGadget      (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Param1\Argument)
      Case "CanvasGadget"        : Object = CanvasGadget        (#PB_Any, \X\Argument,\Y\Argument,\Width\Argument,\Height\Argument, \Flag\Argument)
    EndSelect
    
    If IsWindow(Object)
      AddMapElement(\Object(), \ID\Argument$) 
      \Object()\ID\Argument=Object
      \Object()\Index=@ParsePBGadget()
      
      AddMapElement(\Class$(), Str(Object)) : \Class$()=\ID\Argument$
    ElseIf IsGadget(Object)
      AddMapElement(\Object(), \ID\Argument$) 
      \Object()\ID\Argument=Object
      \Object()\Index=@ParsePBGadget()
      
      AddMapElement(\Class$(), Str(Object)) : \Class$()=\ID\Argument$
      AddMapElement(\Parent(), Str(Object)) : \Parent()=Parent
    EndIf
    
    
    Select \Type\Argument$
      Case "OpenWindow" : \Window = Object : Parent = Object : SubLevel = 1
      Case "UseGadgetList" : UseGadgetList( WindowID(Parent) )
      Case "ContainerGadget", "ScrollAreaGadget", "PanelGadget" :  Parent = Object : SubLevel + 1
      Case "CloseGadgetList" 
        If IsGadget(Parent) : CloseGadgetList() : Parent = \Parent(Str(Parent)) : EndIf
        
      Case "AddGadgetColumn"       
        AddGadgetColumn( \Object(\ID\Argument$)\ID\Argument, \Param1\Argument, \Caption\Argument$, \Param2\Argument)
      Case "AddGadgetItem"   
        If IsGadget(\Object(\ID\Argument$)\ID\Argument)
          AddGadgetItem( \Object(\ID\Argument$)\ID\Argument, \Param1\Argument, \Caption\Argument$, \Param2\Argument, \Flag\Argument)
        Else
          Debug " add gadget column "+\ID\Argument$
        EndIf
        
      Case "OpenGadgetList"      
        Parent = \Object(\ID\Argument$)\ID\Argument
        
        If IsGadget(Parent)
          OpenGadgetList( Parent, \Param1\Argument )
        EndIf
    EndSelect
    
    If IsGadget(Object)
      ParsePBGadget()\ID\Argument = Object
      
      If IsGadget(Parent)
        GetParent = \Parent(Str(Parent))
      EndIf
      
      If Object = Parent
        If IsWindow(GetParent)
          CloseGadgetList() ; Bug PB
          UseGadgetList(WindowID(GetParent))
        EndIf
        If IsGadget(GetParent) 
          OpenGadgetList = OpenGadgetList(GetParent) 
          SubLevel + 1
        EndIf
      EndIf
      
      ; 
      PostEvent(Constant::#Event_Create, \Window, Object, #PB_All, \Parent(Str(Object)))
      
      If GadgetType(Object) = #PB_GadgetType_Splitter
        Transformation::Disable(GetGadgetAttribute(Object, #PB_Splitter_FirstGadget))
        Transformation::Disable(GetGadgetAttribute(Object, #PB_Splitter_SecondGadget))
      EndIf
      
      If Object = Parent
        If IsWindow(GetParent) 
          OpenGadgetList(Object) 
        EndIf
        If OpenGadgetList 
          CloseGadgetList() 
          SubLevel - 1
        EndIf
      EndIf
      
      Select GadgetType(Object)
        Case #PB_GadgetType_Container, 
             #PB_GadgetType_Panel, 
             #PB_GadgetType_ScrollArea
          ParsePBGadget()\SubLevel = SubLevel-1
        Default
          ParsePBGadget()\SubLevel = SubLevel
      EndSelect
    EndIf
      
    If IsWindow(Object)
      ParsePBGadget()\ID\Argument = Object
      EnableWindowDrop(Object, #PB_Drop_Text, #PB_Drag_Copy)
      PostEvent(Constant::#Event_Create, Object, #PB_All)
      BindEvent(#PB_Event_WindowDrop, @CreatePBObject_Events(), Object)
    EndIf
    
    BindEvent(Constant::#Event_Create, @CreatePBObject_Events(), \Parent(Str(Object)), Object)
    
  EndWith
  
  ProcedureReturn Object
EndProcedure

Procedure SavePBObject(*This.ParsePBGadget) ; Ok
  Protected Result, ID$, Handle$

  With *This
    
    Protected Result$
    Protected i
    
    Debug "\Content$: "+\Content$
    For i=2 To 5
      
      
      Result$ = Trim(Trim(StringField(\Content$, i, ","), ")"))
      Debug "Result$: "+Result$
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
    
    
    
    
    If Asc(\ID\Argument$) = 35 ; '#'
      ID$ = \ID\Argument$
    Else
      Handle$ = \ID\Argument$+" = "
      ID$ = "#PB_Any"
    EndIf
    
    
    Select \Type\Argument$
        Case "OpenWindow"          : \Content$ = Handle$+"OpenWindow("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ButtonGadget"        : \Content$ = Handle$+"ButtonGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "StringGadget"        : \Content$ = Handle$+"StringGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "TextGadget"          : \Content$ = Handle$+"TextGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "CheckBoxGadget"      : \Content$ = Handle$+"CheckBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
      Case "OptionGadget"        : \Content$ = Handle$+"OptionGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ListViewGadget"      : \Content$ = Handle$+"ListViewGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "FrameGadget"         : \Content$ = Handle$+"FrameGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ComboBoxGadget"      : \Content$ = Handle$+"ComboBoxGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ImageGadget"         : \Content$ = Handle$+"ImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                 : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "HyperLinkGadget"     : \Content$ = Handle$+"HyperLinkGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                  : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ContainerGadget"     : \Content$ = Handle$+"ContainerGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ListIconGadget"      : \Content$ = Handle$+"ListIconGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)+", "+\Param1\Argument$                                  : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
      Case "IPAddressGadget"     : \Content$ = Handle$+"IPAddressGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$
        Case "ProgressBarGadget"   : \Content$ = Handle$+"ProgressBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollBarGadget"     : \Content$ = Handle$+"ScrollBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$+", "+\Param3\Argument$                                     : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ScrollAreaGadget"    : \Content$ = Handle$+"ScrollAreaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$    : If \Param3\Argument$ : \Content$ +", "+\Param3\Argument$ : EndIf : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf 
        Case "TrackBarGadget"      : \Content$ = Handle$+"TrackBarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
      Case "WebGadget"           : \Content$ = Handle$+"WebGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)
        Case "ButtonImageGadget"   : \Content$ = Handle$+"ButtonImageGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$                                                                 : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "CalendarGadget"      : \Content$ = Handle$+"CalendarGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                 : If \Param1\Argument$ : \Content$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "DateGadget"          : \Content$ = Handle$+"DateGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34) : If \Param1\Argument$ : \Content$ +", "+\Param1\Argument$ : EndIf : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "EditorGadget"        : \Content$ = Handle$+"EditorGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerListGadget"  : \Content$ = Handle$+"ExplorerListGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerTreeGadget"  : \Content$ = Handle$+"ExplorerTreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "ExplorerComboGadget" : \Content$ = Handle$+"ExplorerComboGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ Chr(34)+\Caption\Argument$+Chr(34)                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "SpinGadget"          : \Content$ = Handle$+"SpinGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "TreeGadget"          : \Content$ = Handle$+"TreeGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
      Case "PanelGadget"         : \Content$ = Handle$+"PanelGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$ 
        Case "SplitterGadget"      : \Content$ = Handle$+"SplitterGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
        Case "MDIGadget"           : \Content$ = Handle$+"MDIGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$+", "+\Param2\Argument$                                                   : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf 
      Case "ScintillaGadget"     : \Content$ = Handle$+"ScintillaGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
      Case "ShortcutGadget"      : \Content$ = Handle$+"ShortcutGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$+", "+ \Param1\Argument$
        Case "CanvasGadget"        : \Content$ = Handle$+"CanvasGadget("+ID$+", "+\X\Argument$+", "+\Y\Argument$+", "+\Width\Argument$+", "+\Height\Argument$                                                                                : If \Flag\Argument$ : \Content$ +", "+\Flag\Argument$ : EndIf
    EndSelect
    
    \Content$+")"
    Result = Len(\Content$)
  EndWith
  
  ProcedureReturn Result
EndProcedure



;-
Procedure ParsePBFile(FileName.s)
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
                \Type\Argument$=RegularExpressionGroup(#RegEx_Function, 7)
                \Args$=Trim(RegularExpressionGroup(#RegEx_Function, 8))
                
                If RegularExpressionGroup(#RegEx_Function, 3)
                  \ID\Argument$ = RegularExpressionGroup(#RegEx_Function, 3)
                EndIf
                
                If RegularExpressionGroup(#RegEx_Function, 3)
                  Protected Content1$ = RegularExpressionMatchString(#RegEx_Function)
                  Protected Length1 = RegularExpressionMatchLength(#RegEx_Function)
                  Protected Position1 = RegularExpressionMatchPosition(#RegEx_Function)
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
                      ParsePBGadget()\Content$ = Content1$ + RegularExpressionMatchString(#RegEx_Function)
                      ParsePBGadget()\Length = Length1 + RegularExpressionMatchLength(#RegEx_Function)
                      ParsePBGadget()\Position = Position1;RegularExpressionMatchPosition(#RegEx_Function)
                      
                      ; Debug ""
                      ; Debug Position1
                      ; Debug ParsePBGadget()\Position
                      
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
                                If "#PB_Any" <> Arg$ And
                                   "#PB_All" <> Arg$ And 
                                   45 <> Asc(Arg$) ; - (-1;- 1)
                                  \ID\Argument$ = Arg$
                                EndIf
                                ParsePBGadget()\ID\Argument$ = \ID\Argument$
                                
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
                                  Case "SplitterGadget"      
                                    \Param1\Argument = \Object(Arg$)\ID\Argument
                                    
                                  Case "ImageGadget"      
                                    Result = \Img(GetStr(Arg$))\ID\Argument 
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
                                    \Param2\Argument = \Object(Arg$)\ID\Argument
                                    
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
                                    \Flag\Argument = OpenPBObjectFlag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    If \Flag\Argument = 0
                                      Arg$ = GetVarValue(Arg$)
                                      \Flag\Argument = Val(Arg$)
                                    EndIf
                                    If \Flag\Argument = 0
                                      \Flag\Argument = OpenPBObjectFlag(Arg$) ; Если строка такого рода "#Flag_0|#Flag_1"
                                    EndIf
                                EndSelect
                                ParsePBGadget()\Flag\Argument$ = Arg$
                            EndSelect
                            
                          EndIf
                        Wend
                      EndIf
                      
                      Protected win = CallFunctionFast(@OpenPBObject(), *This)
                      
                      \ID\Argument=-1
                      \ID\Argument$=""
                      \Param1\Argument = 0
                      \Param2\Argument = 0
                      \Param3\Argument = 0
                      \Caption\Argument$ = ""
                      \Flag\Argument = 0
                      
                    Case "CloseGadgetList"      : CallFunctionFast(@OpenPBObject(), *This) ; , "UseGadgetList" ; TODO
                      
                    Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"      
                      If ExamineRegularExpression(#RegEx_Arguments, \Args$) : Index=0
                        While NextRegularExpressionMatch(#RegEx_Arguments)
                          Arg$ = Trim(RegularExpressionMatchString(#RegEx_Arguments))
                          
                          If Arg$ : Index+1
                            Select Index
                              Case 1 : \ID\Argument$ = Arg$
                              Case 2 : \Param1\Argument = Val(Arg$)     ; 
                              Case 3 : \Caption\Argument$=GetStr(Arg$)
                              Case 4 : \Param2\Argument = Val(Arg$)
                              Case 5 : \Flag\Argument$ = Arg$
                                \Flag\Argument = OpenPBObjectFlag(Arg$)
                                If Not \Flag\Argument
                                  Select Asc(\Flag\Argument$)
                                    Case '0' To '9'
                                    Default
                                      \Flag\Argument = OpenPBObjectFlag(GetVarValue(Arg$))
                                  EndSelect
                                EndIf
                            EndSelect
                          EndIf
                        Wend
                      EndIf
                      
                      CallFunctionFast(@OpenPBObject(), *This)
                      
                      
                      \ID\Argument =- 1
                      \ID\Argument$ = ""
                      \Flag\Argument = 0
                      \Param1\Argument = 0
                      \Param2\Argument = 0
                      \Param3\Argument = 0
                      \Flag\Argument$ = ""
                      \Param1\Argument$ = ""
                      \Param2\Argument$ = ""
                      \Param3\Argument$ = ""
                      \Caption\Argument$ = ""
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


;-
;- PI Редактора

Procedure Editor_Open(Path$) ; Открытие файла
  Protected Result
  Debug "Открываю файл '"+Path$+"'"
  
  If Path$
    ParsePBFile(Path$)
    
    Protected Object, IsContainer
    PushListPosition(ParsePBGadget())
    ForEach ParsePBGadget()
      Object = *This\Object(ParsePBGadget()\ID\Argument$)\ID\Argument
      
      If IsGadget(Object) 
        Select GadgetType(Object)
          Case #PB_GadgetType_Container, #PB_GadgetType_Panel, #PB_GadgetType_ScrollArea
            IsContainer = #True
        EndSelect
      EndIf
      
      AddGadgetItem (Window_0_Tree_0, -1, ParsePBGadget()\ID\Argument$, 0, ParsePBGadget()\SubLevel)
    Next
    PopListPosition(ParsePBGadget())
    
    SetGadgetItemState(Window_0_Tree_0, 0, #PB_Tree_Expanded|#PB_Tree_Selected)
    
    Result=#True
    Debug "..успешно"
  EndIf 
  
  ProcedureReturn Result
EndProcedure


Procedure Editor_Save(Path$) ; Процедура сохранения файла
  Protected Result
  
  Debug "Сохраняю файл '"+Path$+"'"
  
  Protected Object
  Protected len, Length, Position
  Protected Space$, Content$
  
  len = 0
  
  PushListPosition(ParsePBGadget())
  ForEach ParsePBGadget()
    Object = ParsePBGadget()\ID\Argument ; *This\Object(ParsePBGadget()\ID\Argument$)\ID\Argument
    
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
      Content$ = \Content$
      Length = SavePBObject(ParsePBGadget())
      
      If (Length>\Length)
        Position = \Position
        This_File$ = InsertString(This_File$, Space(Length), 1+(\Position+\Length+len))
        \Length = Length
        \Position + Len
        len + Length
      Else
        \Content$ + Space(\Length-Length)
      EndIf
      
      This_File$=ReplaceString(This_File$, Content$, \Content$, #PB_String_CaseSensitive, Position, 1)
    Next
  EndWith
  PopListPosition(ParsePBGadget())
  
  
  If CreateFile(#File, Path$, #PB_UTF8)
    WriteStringFormat(#File, #PB_UTF8)
    WriteString(#File, This_File$, #PB_UTF8)
    CloseFile(#File)
    Result=#True
    Debug "..успешно"
  EndIf
  
  ProcedureReturn Result
EndProcedure









;-
;- UI Окна редактора

Define CurrentFile$ ; Путь к текущему файлу.


Procedure EditorWindow_Open() 
  Shared CurrentFile$
  
  Protected File$
  File$=OpenFileRequester("Выберите файл с описанием окон", CurrentFile$, "Все файлы|*", 0)
  If File$
    If Editor_Open(File$)
      CurrentFile$=File$
    Else
      MessageRequester("Ошибка", "Не удалось открыть файл.", #PB_MessageRequester_Error)
    EndIf
  EndIf 
  
EndProcedure


Procedure EditorWindow_SaveAs()
  Shared CurrentFile$
  
  Protected File$
  File$ = SaveFileRequester("Сохранить файл как ..", CurrentFile$, "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*", 0)
  If File$
    If Editor_Save(File$)
      CurrentFile$=File$
    Else
      MessageRequester("Ошибка","Не удалось сохранить файл.", #PB_MessageRequester_Error)
    EndIf
  EndIf
  
EndProcedure

Procedure EditorWindow_Save()
  Shared CurrentFile$
  If Not (CurrentFile$ And Editor_Save(CurrentFile$))
    EditorWindow_SaveAs()
  EndIf
EndProcedure



;-

Declare OpenWindow_Editor(Flag.i=#PB_Window_SystemMenu, ParentID=0)
Declare CloseWindow_Editor()

Procedure OpenWindow_Editor(Flag.i=#PB_Window_SystemMenu, ParentID=0)
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
    
    AddGadgetItem(Window_0_Panel_0, -1, "Objects")
    Window_0_Tree_1 = TreeGadget(#PB_Any, 0, 0, 205, 180, #PB_Tree_NoLines | #PB_Tree_NoButtons)
    EnableGadgetDrop(Window_0_Tree_1, #PB_Drop_Text, #PB_Drag_Copy)
    
    AddGadgetItem(Window_0_Panel_0, -1, "Properties")
    Window_0_Properties = Properties::Gadget( #PB_Any, 225, 261 )
    Properties_ID = Properties::AddItem( Window_0_Properties, "ID:", #PB_GadgetType_String )
    Properties::AddItem( Window_0_Properties, "Text:", #PB_GadgetType_String )
    Properties::AddItem( Window_0_Properties, "Disable:False|True", #PB_GadgetType_ComboBox )
    Properties::AddItem( Window_0_Properties, "Hide:False|True", #PB_GadgetType_ComboBox )
    
    Properties::AddItem( Window_0_Properties, "Layouts:", #False )
    Properties::AddItem( Window_0_Properties, "X:", #PB_GadgetType_Spin )
    Properties::AddItem( Window_0_Properties, "Y:", #PB_GadgetType_Spin )
    Properties::AddItem( Window_0_Properties, "Width:", #PB_GadgetType_Spin )
    Properties::AddItem( Window_0_Properties, "Height:", #PB_GadgetType_Spin )
    
    Properties::AddItem( Window_0_Properties, "Other:", #False )
    Properties_Flag = Properties::AddItem( Window_0_Properties, "Flag:", #PB_GadgetType_Tree|#PB_GadgetType_Button )
    Properties::AddItem( Window_0_Properties, "Font:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties_Image = Properties::AddItem( Window_0_Properties, "Image:", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( Window_0_Properties, "Puth", #PB_GadgetType_String|#PB_GadgetType_Button )
    Properties::AddItem( Window_0_Properties, "Color:", #PB_GadgetType_String|#PB_GadgetType_Button )
    
    AddGadgetItem(Window_0_Panel_0, -1, "Events")
    
    CloseGadgetList()
    
    Window_0_Splitter_0 = SplitterGadget(#PB_Any, 5, 5, 230-10, 600-MenuHeight()-10, Window_0_Tree_0, Window_0_Panel_0, #PB_Splitter_FirstFixed)
    SetGadgetState(Window_0_Splitter_0, 145)
    
    LoadControls()
    Window_0_Panel_0_Resize_Event()
    
    BindEvent(#PB_Event_Menu, @Window_Event(), Window_0)
    BindEvent(#PB_Event_Gadget, @Window_Event(), Window_0)
    BindEvent(#PB_Event_SizeWindow, @Window_0_Resize_Event(), Window_0)
    BindEvent(#PB_Event_Gadget, @Window_0_Panel_0_Resize_Event(), Window_0, Window_0_Panel_0, #PB_EventType_Resize)
    
    
    
    BindMenuEvent(Window_0_Menu_0, Window_0_Menu_0_Open, @EditorWindow_Open())
    BindMenuEvent(Window_0_Menu_0, Window_0_Menu_0_Save_as, @EditorWindow_SaveAs())
    BindMenuEvent(Window_0_Menu_0, Window_0_Menu_0_Save, @EditorWindow_Save())
    
  EndIf
  
  ProcedureReturn Window_0
EndProcedure

Procedure CloseWindow_Editor()
  If IsWindow(Window_0)
    UnbindEvent(#PB_Event_Menu, @Window_Event(), Window_0)
    UnbindEvent(#PB_Event_Gadget, @Window_Event(), Window_0)
    UnbindEvent(#PB_Event_SizeWindow, @Window_0_Resize_Event(), Window_0)
    UnbindEvent(#PB_Event_Gadget, @Window_0_Panel_0_Resize_Event(), Window_0, Window_0_Panel_0, #PB_EventType_Resize)
    
    UnbindMenuEvent(Window_0_Menu_0, Window_0_Menu_0_Open, @EditorWindow_Open())
    UnbindMenuEvent(Window_0_Menu_0, Window_0_Menu_0_Save_as, @EditorWindow_SaveAs())
    UnbindMenuEvent(Window_0_Menu_0, Window_0_Menu_0_Save, @EditorWindow_Save())
    
    CloseWindow(Window_0)
  EndIf
EndProcedure


Procedure Window_0_Panel_0_Resize_Event()
  Protected GadgetWidth = GetGadgetAttribute(Window_0_Panel_0, #PB_Panel_ItemWidth)
  Protected GadgetHeight = GetGadgetAttribute(Window_0_Panel_0, #PB_Panel_ItemHeight)
  
  Select GetGadgetItemText(Window_0_Panel_0, GetGadgetState(Window_0_Panel_0))
    Case "Properties" : Properties::Size(GadgetWidth, GadgetHeight)
    Case "Objects"  : ResizeGadget(Window_0_Tree_1, #PB_Ignore, #PB_Ignore, GadgetWidth, GadgetHeight)
  EndSelect
EndProcedure

Procedure Window_0_Resize_Event()
  Protected WindowWidth = WindowWidth(Window_0)
  Protected WindowHeight = WindowHeight(Window_0)-MenuHeight()
  ResizeGadget(Window_0_Splitter_0, 5, 5, WindowWidth - 10, WindowHeight - 10)
  Window_0_Panel_0_Resize_Event()
EndProcedure






Procedure Window_Event()
  Protected I, File$, SubItem, UseGadgetList
  Protected IsContainer.b, Object, Parent=-1
  
  Select Event()
    Case #PB_Event_Gadget
      Select EventGadget()
        Case Properties_ID
          Select EventType()
            Case #PB_EventType_Change      
              PushListPosition(ParsePBGadget())
              With ParsePBGadget()
                ForEach ParsePBGadget()
                  If \ID\Argument$ = GetGadgetText(Window_0_Tree_0)
                    \ID\Argument$ = GetGadgetText(EventGadget())
                  EndIf
                Next
              EndWith
              PopListPosition(ParsePBGadget())  
              
              ReplaceMapKey(GetGadgetText(Window_0_Tree_0), GetGadgetText(EventGadget()))
              ;Trim(GetRegExString("[^\w]("+Window_0_Button_0+")[^\w]", 1), #CR$)
              ;Debug *This\Object(GetGadgetText(EventGadget()))\Index
              
              Debug ParsePBGadget()\Content$
              
              
              Protected Result$, Group=1, _Pattern$ = "[^\w]("+GetGadgetText(Window_0_Tree_0)+")[^\w]"
              Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
              Protected RegExID = CreateRegularExpression(#PB_Any, _Pattern$, Create_Reg_Flag)
              
              If RegExID
                If ExamineRegularExpression(RegExID, This_File$)
                  While NextRegularExpressionMatch(RegExID)
                    If Group
                      Result$ = RegularExpressionGroup(RegExID, Group)
                      ParsePBGadget()\Content$ = ReplaceRegularExpression(RegExID, ParsePBGadget()\Content$, GetGadgetText(EventGadget()))
                      This_File$ = ReplaceRegularExpression(RegExID, This_File$, GetGadgetText(EventGadget()))
                    Else
                      Result$ = RegularExpressionMatchString(RegExID)
                    EndIf
                  Wend
                EndIf
                
                FreeRegularExpression(RegExID)
              EndIf
              
              
              SetGadgetText(Window_0_Tree_0, GetGadgetText(EventGadget()))
              
          EndSelect
          
        Case Properties_Flag ; Ok
          Select EventType()
            Case #PB_EventType_LostFocus   
              PushListPosition(ParsePBGadget())
              ForEach ParsePBGadget()
                If ParsePBGadget()\ID\Argument$ = GetGadgetText(Window_0_Tree_0)
                  ParsePBGadget()\Flag\Argument$ = Properties::GetCheckedText(EventGadget()) 
                  Break
                EndIf
              Next
              PopListPosition(ParsePBGadget())
              
          EndSelect
          
        Case Window_0_Tree_0 ; Ok
          Select EventType()
            Case #PB_EventType_Change      
              If GetGadgetState(Window_0_Panel_0) <> 1 ; Properties
                SetGadgetState(Window_0_Panel_0, 1)    ; Для удобства выбираем вкладку свойства
              EndIf
              
              PushListPosition(ParsePBGadget())
              With ParsePBGadget()
                ForEach ParsePBGadget() 
                  Transformation::Disable(\ID\Argument) 
                Next
                ForEach ParsePBGadget()
                  If GetGadgetText(Window_0_Tree_0) = \ID\Argument$
                    Parent = *This\Parent(Str(\ID\Argument))
                    Properties::UpdateProperties(\ID\Argument, \ID\Argument$, \Flag\Argument$)
                    
                    If IsGadget(Parent)
                      OpenGadgetList(Parent)
                      Transformation::Enable(\ID\Argument, 5)
                      CloseGadgetList()
                    ElseIf IsWindow(Parent)
                      UseGadgetList = UseGadgetList(WindowID(Parent))
                      Transformation::Enable(\ID\Argument, 5)
                      UseGadgetList(UseGadgetList)
                    EndIf
                    
                    If IsGadget(\ID\Argument)
                      SetActiveGadget(\ID\Argument)
                    ElseIf IsWindow(\ID\Argument)
                      SetActiveWindow(\ID\Argument)
                    EndIf
                    Break
                  EndIf
                Next
              EndWith
              PopListPosition(ParsePBGadget())
              
          EndSelect
          
        Case Window_0_Tree_1 ; Ok
          Select EventType()
            Case #PB_EventType_DragStart
              DragText(GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget())))
          EndSelect
      EndSelect
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case Window_0_Menu_0_New ;- New file
                                 ; CreateObject("Window")
          If ParsePBFile("Window_0.pb")
            
            PushListPosition(ParsePBGadget())
            ForEach ParsePBGadget()
              AddGadgetItem (Window_0_Tree_0, -1, ParsePBGadget()\ID\Argument$, 0, ParsePBGadget()\SubLevel)
            Next
            PopListPosition(ParsePBGadget())
            
            SetGadgetItemState(Window_0_Tree_0, 0, #PB_Tree_Expanded|#PB_Tree_Selected)
          EndIf
          
          SetGadgetState(Window_0_Panel_0, 0)
          

          
      EndSelect
  EndSelect
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  MainWindow = OpenWindow_Editor(#PB_Window_SystemMenu|
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

; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 1799
; FirstLine = 1847
; Folding = -------
; EnableXP
; CompileSourceDirectory