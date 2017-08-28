;- Абстрактные представления

; Здесь собраны структурные представления о строении формы

Structure Object      ; Объектами будут все функции которые попадутся парсеру
  ObjectID.i          ; Идентификатор объекта
  ParentID.i          ; Идентификатор его родителя
  ObjectType.s        ; Тип. Он совпадает с названием процедуры, и он же позволит Редактору правильно его отобразить
  Position.i          ; Положение в исходном файле
  Length.i            ; длинна в исходном файле
  
  Content.s           ; Содержимое. К примеру: "OpenWindow(#Butler_Window_Settings, x, y, width, height, "Настройки", #PB_Window_SystemMenu)"
                      ; Редактор будет работать только с этой строкой. Именно эта строка в момент сохранения будет записана в исходный файл на место Position/Length
EndStructure

NewList Object.Object()       ; Список объектов


Procedure AddObject(ObjectType.s, ParentID, Position, Length, Content$)                           ; Процедура добавляет новый объект
  Static ObjectID
  
  Shared Object()
  *Element.Object=AddElement(Object())
  If *Element : ObjectID+1
    With *Element
      \ObjectID   = ObjectID
      \ParentID   = ParentID
      \ObjectType = ObjectType
      \Position   = Position
      \Length     = Length
      \Content    = Content$
    EndWith
    
    Result=ObjectID
  EndIf
  
  ProcedureReturn Result
EndProcedure


; После того как все списки заполнены, можно переходить к их визуальному представлению в редакторе





;- Парсинг

; Здесь собраны процедуры парсинга

Enumeration RegularExpression
  #Regex_Comments
  #Regex_Exception
  
  #RegEx_FindFunction
  #RegEx_FindFields
  #Regex_FindProcedure
EndEnumeration


; If Not CreateRegularExpression(#Regex_Exception, ~"(?<=\").*;.*(?=\")", #PB_RegularExpression_NoCase)
;   Debug RegularExpressionError()
; EndIf

If Not CreateRegularExpression(#Regex_Comments, "^;.*?$", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine)
  Debug RegularExpressionError()
EndIf
; If Not CreateRegularExpression(#Regex_Comments, ~"(?<!\");(?!\").*$", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine)
;   Debug RegularExpressionError()
; EndIf


; CreateRegularExpression(#Regex_FindProcedure, "(?<=Procedure).*?(?=EndProcedure)", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
; CreateRegularExpression(#Regex_FindProcedure, "^\s*?Procedure.*?EndProcedure", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)

CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?)\)", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
; CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?)\)(?=\s*($|:))?", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
CreateRegularExpression(#RegEx_FindFields, "[^,]+", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)


; Обработка функций
Prototype Parser(Position, Length, Content$)
Structure ParserElement
  Parser.Parser
EndStructure

NewMap ParserElement.ParserElement()

Procedure ParseObject(ObjectType$, Position, Length, Content$)
  Shared ParserElement()
  If FindMapElement(ParserElement(), ObjectType$)
    ParserElement(ObjectType$)\Parser(Position, Length, Content$)
  EndIf
EndProcedure



; Обработчики

;{

NewList CurrentParent()

Procedure GetCurrentParent()
  Shared CurrentParent()
  LastElement(CurrentParent())
  ProcedureReturn CurrentParent()
EndProcedure
















#ObjectType_OpenWindow="OpenWindow"
Procedure Parser_OpenWindow(Position, Length, Content$)
  Shared CurrentParent()
  
  ClearList(CurrentParent())
  AddElement(CurrentParent())
  
  
  CurrentParent()=AddObject(#ObjectType_OpenWindow, ParentID, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_OpenWindow)
ParserElement()\Parser=@Parser_OpenWindow()




Procedure Parser_SimpleGadget(Position, Length, Content$)
  CurrentParent=GetCurrentParent()
  Shared ParserElement()
  
  AddObject(MapKey(ParserElement()), CurrentParent, Position, Length, Content$)
EndProcedure










#ObjectType_ContainerGadget="ContainerGadget"
Procedure Parser_ContainerGadget(Position, Length, Content$)
  CurrentParent=GetCurrentParent()
  
  Shared CurrentParent()
  AddElement(CurrentParent())
  
  CurrentParent()=AddObject(#ObjectType_ContainerGadget, CurrentParent, Position, Length, Content$)
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ContainerGadget)
ParserElement()\Parser=@Parser_ContainerGadget()


#ObjectType_CloseGadgetList="CloseGadgetList"
Procedure Parser_CloseGadgetList(Position, Length, Content$)
  CurrentParent=GetCurrentParent()
  
  Shared CurrentParent()
  LastElement(CurrentParent())
  DeleteElement(CurrentParent())

  AddObject(#ObjectType_CloseGadgetList, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_CloseGadgetList)
ParserElement()\Parser=@Parser_CloseGadgetList()





#ObjectType_ButtonGadget="ButtonGadget"
AddMapElement(ParserElement(), #ObjectType_ButtonGadget)
ParserElement()\Parser=@Parser_SimpleGadget()


#ObjectType_ButtonImageGadget="ButtonImageGadget"
AddMapElement(ParserElement(), #ObjectType_ButtonImageGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_CalendarGadget="CalendarGadget"
AddMapElement(ParserElement(), #ObjectType_CalendarGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_CanvasGadget="CanvasGadget"
AddMapElement(ParserElement(), #ObjectType_CanvasGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_CheckBoxGadget="CheckBoxGadget"
AddMapElement(ParserElement(), #ObjectType_CheckBoxGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ComboBoxGadget="ComboBoxGadget"
AddMapElement(ParserElement(), #ObjectType_ComboBoxGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_DateGadget="DateGadget"
AddMapElement(ParserElement(), #ObjectType_DateGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_EditorGadget="EditorGadget"
AddMapElement(ParserElement(), #ObjectType_EditorGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ExplorerComboGadget="ExplorerComboGadget"
AddMapElement(ParserElement(), #ObjectType_ExplorerComboGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ExplorerListGadget="ExplorerListGadget"
AddMapElement(ParserElement(), #ObjectType_ExplorerListGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ExplorerTreeGadget="ExplorerTreeGadget"
AddMapElement(ParserElement(), #ObjectType_ExplorerTreeGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_FrameGadget="FrameGadget"
AddMapElement(ParserElement(), #ObjectType_FrameGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_HyperLinkGadget="HyperLinkGadget"
AddMapElement(ParserElement(), #ObjectType_HyperLinkGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_IPAddressGadget="IPAddressGadget"
AddMapElement(ParserElement(), #ObjectType_IPAddressGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ImageGadget="ImageGadget"
AddMapElement(ParserElement(), #ObjectType_ImageGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ListIconGadget="ListIconGadget"
AddMapElement(ParserElement(), #ObjectType_ListIconGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ListViewGadget="ListViewGadget"
AddMapElement(ParserElement(), #ObjectType_ListViewGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_MDIGadget="MDIGadget"
AddMapElement(ParserElement(), #ObjectType_MDIGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_OpenGLGadget="OpenGLGadget"
AddMapElement(ParserElement(), #ObjectType_OpenGLGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_OptionGadget="OptionGadget"
AddMapElement(ParserElement(), #ObjectType_OptionGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_PanelGadget="PanelGadget"
AddMapElement(ParserElement(), #ObjectType_PanelGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ProgressBarGadget="ProgressBarGadget"
AddMapElement(ParserElement(), #ObjectType_ProgressBarGadget)
ParserElement()\Parser=@Parser_SimpleGadget()








#ObjectType_ScrollAreaGadget="ScrollAreaGadget"
Procedure Parser_ScrollAreaGadget(Position, Length, Content$)
  Shared CurrentParent
  
  Shared CurrentParent()
  AddElement(CurrentParent())
  
  CurrentParent()=AddObject(#ObjectType_ScrollAreaGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ScrollAreaGadget)
ParserElement()\Parser=@Parser_ScrollAreaGadget()






#ObjectType_ScrollBarGadget="ScrollBarGadget"
AddMapElement(ParserElement(), #ObjectType_ScrollBarGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_ShortcutGadget="ShortcutGadget"
AddMapElement(ParserElement(), #ObjectType_ShortcutGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_SpinGadget="SpinGadget"
AddMapElement(ParserElement(), #ObjectType_SpinGadget)
ParserElement()\Parser=@Parser_SimpleGadget()





#ObjectType_SplitterGadget="SplitterGadget"
Procedure Parser_SplitterGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_SplitterGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_SplitterGadget)
ParserElement()\Parser=@Parser_SplitterGadget()





#ObjectType_StringGadget="StringGadget"
AddMapElement(ParserElement(), #ObjectType_StringGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_TextGadget="TextGadget"
AddMapElement(ParserElement(), #ObjectType_TextGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_TrackBarGadget="TrackBarGadget"
AddMapElement(ParserElement(), #ObjectType_TrackBarGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_TreeGadget="TreeGadget"
AddMapElement(ParserElement(), #ObjectType_TreeGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

#ObjectType_WebGadget="WebGadget"
AddMapElement(ParserElement(), #ObjectType_WebGadget)
ParserElement()\Parser=@Parser_SimpleGadget()

;}



;- Начало работы программы

; Формально, отсюда программа начинает своё выполнение


FilePath$=ProgramParameter() ; Путь к файлу.
CompilerIf #PB_Compiler_Debugger
  If Not Len(FilePath$)
    FilePath$=OpenFileRequester("Выберите файл с описанием окон", "", "Файлы PureBasic (*.pb;*.pbf)|*.pb;*.pbf|Все файлы|*", 0)
  EndIf
CompilerEndIf



Enumeration File
  #File
EndEnumeration

If ReadFile(#File, FilePath$)
  Debug "Открывается файл: "+FilePath$
  
  Format=ReadStringFormat(#File)
  ByteLength = Lof(#File)
  *File = AllocateMemory(ByteLength)
  If *File : ReadData(#File, *File, ByteLength)
    FileContent$=PeekS(*File, ByteLength, Format)
    FreeMemory(*File)
  EndIf
  
  ; FileContent$ - Содержимое файла
  
  
  Enumeration RegularExpression
    #PP_RegEx_String
  EndEnumeration
  
  
 
  
  Debug "Файл до обработки ================="
  Debug FileContent$
  Debug "==================================="
  
;   FileContent$=ReplaceRegularExpression(#Regex_Exception, FileContent$, "")
;   
;   Debug "Удалены исключения ================="
;   Debug FileContent$
;   Debug "==================================="
  
;   FileContent$=ReplaceRegularExpression(#Regex_Comments, FileContent$, "")
;   
;   Debug "Файл после обработки =============="
;   Debug FileContent$
;   Debug "==================================="
  
  
;   CreateRegularExpression(#PP_RegEx_String, "(\w+)\s*\((.*?)\)", #PB_RegularExpression_NoCase|#PB_RegularExpression_MultiLine)
  
  
  If ExamineRegularExpression(#Regex_Comments, FileContent$)
    While NextRegularExpressionMatch(#Regex_Comments)
      I+1
      Content$=RegularExpressionMatchString(#Regex_Comments)
;       Debug Str(I)+Chr(9)+Content$
      
      
      Debug "Строка "+Str(I)+":"+Chr(9)+Content$;RegularExpressionGroup(#Regex_Comments, 1);+" Комментарий"+Chr(9)+RegularExpressionGroup(#Regex_Comments, 2)
      
      
;       Position=(RegularExpressionMatchPosition(#Regex_FindProcedure)-1)+(RegularExpressionMatchPosition(#RegEx_FindFunction)-1)
;       Length=RegularExpressionMatchLength(#Regex_FindProcedure)
      
;       ObjectType$=RegularExpressionGroup(#RegEx_FindFunction, 1)
      
      
;       ParseObject(ObjectType$, Position, Length, Content$)
      
    Wend
  EndIf
  
  
  
;   If ExamineRegularExpression(#PP_RegEx_String, FileContent$)
;     While NextRegularExpressionMatch(#PP_RegEx_String)
;       I+1
;       ;       Content$=RegularExpressionMatchString(#PP_RegEx_String)
;       ;       Debug Str(I)+Chr(9)+Content$
;       
;       
;       Debug "Строка "+Str(I)+":"+Chr(9)+RegularExpressionGroup(#PP_RegEx_String, 1);+" Комментарий"+Chr(9)+RegularExpressionGroup(#PP_RegEx_String, 2)
;       
;       
;       ;       Position=(RegularExpressionMatchPosition(#Regex_FindProcedure)-1)+(RegularExpressionMatchPosition(#RegEx_FindFunction)-1)
;       ;       Length=RegularExpressionMatchLength(#Regex_FindProcedure)
;       
;       ;       ObjectType$=RegularExpressionGroup(#RegEx_FindFunction, 1)
;       
;       
;       ;       ParseObject(ObjectType$, Position, Length, Content$)
;       
;     Wend
;   EndIf
  
;   If ExamineRegularExpression(#Regex_FindProcedure, FileContent$)
;     While NextRegularExpressionMatch(#Regex_FindProcedure)
;       
;       Function$=RegularExpressionMatchString(#Regex_FindProcedure)
;       
;       If ExamineRegularExpression(#RegEx_FindFunction, Function$)
;         While NextRegularExpressionMatch(#RegEx_FindFunction)
;           
;           Content$=RegularExpressionMatchString(#RegEx_FindFunction)
;           Position=(RegularExpressionMatchPosition(#Regex_FindProcedure)-1)+(RegularExpressionMatchPosition(#RegEx_FindFunction)-1)
;           Length=RegularExpressionMatchLength(#Regex_FindProcedure)
;           
;           ObjectType$=RegularExpressionGroup(#RegEx_FindFunction, 1)
;           
; 
;           ParseObject(ObjectType$, Position, Length, Content$)
; 
;         Wend
;       EndIf
;     Wend
;   EndIf
  
  
EndIf



;- Вывод результатов

ForEach Object()
  Debug Str(Object()\ObjectID)+")"+Chr(9)+Object()\ObjectType+Chr(9)+"Parent{"+Object()\ParentID+"} "+Chr(9)+Object()\Content
Next
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 422
; FirstLine = 118
; Folding = 7-
; EnableXP
; CommandLine = Test\Комментарии.pb
; CompileSourceDirectory
; EnableUnicode