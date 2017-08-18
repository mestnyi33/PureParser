EnableExplicit
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
  Protected *Element.Object=AddElement(Object())
  If *Element : ObjectID+1
    With *Element
      \ObjectID   = ObjectID
      \ParentID   = ParentID
      \ObjectType = ObjectType
      \Position   = Position
      \Length     = Length
      \Content    = Content$
    EndWith
    
    Protected Result=ObjectID
  EndIf
  
  ProcedureReturn Result
EndProcedure

#ObjectType_OpenWindow="OpenWindow"
#ObjectType_ButtonGadget="ButtonGadget"
#ObjectType_ButtonImageGadget="ButtonImageGadget"
#ObjectType_CalendarGadget="CalendarGadget"
#ObjectType_CanvasGadget="CanvasGadget"
#ObjectType_CheckBoxGadget="CheckBoxGadget"
#ObjectType_ComboBoxGadget="ComboBoxGadget"
#ObjectType_ContainerGadget="ContainerGadget"
#ObjectType_DateGadget="DateGadget"
#ObjectType_EditorGadget="EditorGadget"
#ObjectType_ExplorerComboGadget="ExplorerComboGadget"
#ObjectType_ExplorerListGadget="ExplorerListGadget"
#ObjectType_ExplorerTreeGadget="ExplorerTreeGadget"
#ObjectType_FrameGadget="FrameGadget"
#ObjectType_HyperLinkGadget="HyperLinkGadget"
#ObjectType_IPAddressGadget="IPAddressGadget"
#ObjectType_ImageGadget="ImageGadget"
#ObjectType_ListIconGadget="ListIconGadget"
#ObjectType_ListViewGadget="ListViewGadget"
#ObjectType_MDIGadget="MDIGadget"
#ObjectType_OpenGLGadget="OpenGLGadget"
#ObjectType_OptionGadget="OptionGadget"
#ObjectType_PanelGadget="PanelGadget"
#ObjectType_ProgressBarGadget="ProgressBarGadget"
#ObjectType_ScrollAreaGadget="ScrollAreaGadget"
#ObjectType_ScrollBarGadget="ScrollBarGadget"
#ObjectType_ShortcutGadget="ShortcutGadget"
#ObjectType_SpinGadget="SpinGadget"
#ObjectType_SplitterGadget="SplitterGadget"
#ObjectType_StringGadget="StringGadget"
#ObjectType_TextGadget="TextGadget"
#ObjectType_TrackBarGadget="TrackBarGadget"
#ObjectType_TreeGadget="TreeGadget"
#ObjectType_WebGadget="WebGadget"


; После того как все списки заполнены, можно переходить к их визуальному представлению в редакторе





;- Парсинг

; Здесь собраны процедуры парсинга

Enumeration RegularExpression
  #RegEx_FindFunction
  #RegEx_FindFields
  #Regex_FindProcedure
EndEnumeration


CreateRegularExpression(#Regex_FindProcedure, "(?<=Procedure).*?(?=EndProcedure)", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
; CreateRegularExpression(#Regex_FindProcedure, "^\s*?Procedure.*?EndProcedure", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)

CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?)\)", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
; CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?)\)(?=\s*($|:))?", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
CreateRegularExpression(#RegEx_FindFields, "[^,]+", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)



; Обработка функций


Prototype Parser(Position, Length, Content$)
Structure ParserElement
  Parser.Parser
EndStructure

Global NewMap ParserElement.ParserElement()

Procedure ParseObject(ObjectType$, Position, Length, Content$)
  Shared ParserElement()
  If FindMapElement(ParserElement(), ObjectType$)
    ParserElement(ObjectType$)\Parser(Position, Length, Content$)
  EndIf
EndProcedure




; Обработчики

Global CurrentParent=0

Procedure Parser(Position, Length, Content$)
  Shared CurrentParent
  
  Select MapKey(ParserElement())
    Case #ObjectType_OpenWindow
      CurrentParent = AddObject(MapKey(ParserElement()), CurrentParent, Position, Length, Content$)
    Default
      AddObject(MapKey(ParserElement()), CurrentParent, Position, Length, Content$)
  EndSelect
  
EndProcedure

AddMapElement(ParserElement(), #ObjectType_OpenWindow)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ButtonGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ButtonImageGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_CalendarGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_CanvasGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_CheckBoxGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ComboBoxGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ContainerGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_DateGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_EditorGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ExplorerComboGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ExplorerListGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ExplorerTreeGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_FrameGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_HyperLinkGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_IPAddressGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ImageGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ListIconGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ListViewGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_MDIGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_OpenGLGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_OptionGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_PanelGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ProgressBarGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ScrollAreaGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ScrollBarGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_ShortcutGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_SpinGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_SplitterGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_StringGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_TextGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_TrackBarGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_TreeGadget)
ParserElement()\Parser=@Parser()

AddMapElement(ParserElement(), #ObjectType_WebGadget)
ParserElement()\Parser=@Parser()






;- Начало работы программы

; Формально, отсюда программа начинает своё выполнение


Define FilePath$=ProgramParameter() ; Путь к файлу.
CompilerIf #PB_Compiler_Debugger
  If Not Len(FilePath$)
    FilePath$=OpenFileRequester("Выберите файл с описанием окон", "", "Файлы PureBasic (*.pb;*.pbf)|*.pb;*.pbf|Все файлы|*", 0)
  EndIf
CompilerEndIf



Enumeration File
  #File
EndEnumeration

If ReadFile(#File, FilePath$)
  
  Define Format=ReadStringFormat(#File)
  Define ByteLength = Lof(#File)
  Define *File = AllocateMemory(ByteLength)
  If *File : ReadData(#File, *File, ByteLength)
    Define FileContent$=PeekS(*File, ByteLength, Format)
    FreeMemory(*File)
  EndIf
  
  ; FileContent$ - Содержимое файла
  
  If ExamineRegularExpression(#Regex_FindProcedure, FileContent$)
    While NextRegularExpressionMatch(#Regex_FindProcedure)
      
      Define Function$=RegularExpressionMatchString(#Regex_FindProcedure)
      
      If ExamineRegularExpression(#RegEx_FindFunction, Function$)
        While NextRegularExpressionMatch(#RegEx_FindFunction)
          
          Define Content$=RegularExpressionMatchString(#RegEx_FindFunction)
          Define Position=(RegularExpressionMatchPosition(#Regex_FindProcedure)-1)+(RegularExpressionMatchPosition(#RegEx_FindFunction)-1)
          Define Length=RegularExpressionMatchLength(#Regex_FindProcedure)
          
          Define ObjectType$=RegularExpressionGroup(#RegEx_FindFunction, 1)
          
          
          ParseObject(ObjectType$, Position, Length, Content$)
          
        Wend
      EndIf
    Wend
  EndIf
  
  
EndIf



;- Вывод результатов

ForEach Object()
  Debug Str(Object()\ObjectID)+")"+Chr(9)+Object()\ObjectType+Chr(9)+"Parent{"+Object()\ParentID+"} "+Chr(9)+Object()\Content
Next
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 495
; FirstLine = 437
; Folding = -------
; EnableUnicode
; EnableXP