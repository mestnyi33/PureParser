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

NewMap ParserElement.ParserElement()

Procedure ParseObject(ObjectType$, Position, Length, Content$)
  Shared ParserElement()
  If FindMapElement(ParserElement(), ObjectType$)
    ParserElement(ObjectType$)\Parser(Position, Length, Content$)
  EndIf
EndProcedure



; Обработчики



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

#ObjectType_ButtonGadget="ButtonGadget"
Procedure Parser_ButtonGadget(Position, Length, Content$)
  CurrentParent=GetCurrentParent()

  AddObject(#ObjectType_ButtonGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ButtonGadget)
ParserElement()\Parser=@Parser_ButtonGadget()


#ObjectType_ContainerGadget="ContainerGadget"
Procedure Parser_ContainerGadget(Position, Length, Content$)
  CurrentParent=GetCurrentParent()
  
  Shared CurrentParent()
  AddElement(CurrentParent())
  
  
  CurrentParent()=AddObject(#ObjectType_ContainerGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ContainerGadget)
ParserElement()\Parser=@Parser_ContainerGadget()


#ObjectType_CloseGadgetList=""
Procedure Parser_CloseGadgetList(Position, Length, Content$)
  CurrentParent=GetCurrentParent()
  
  Shared CurrentParent()
  LastElement(CurrentParent())
  DeleteElement(CurrentParent())

  AddObject(#ObjectType_CloseGadgetList, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_CloseGadgetList)
ParserElement()\Parser=@Parser_CloseGadgetList()








;{
#ObjectType_ButtonImageGadget="ButtonImageGadget"
Procedure Parser_ButtonImageGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ButtonImageGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ButtonImageGadget)
ParserElement()\Parser=@Parser_ButtonImageGadget()

#ObjectType_CalendarGadget="CalendarGadget"
Procedure Parser_CalendarGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_CalendarGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_CalendarGadget)
ParserElement()\Parser=@Parser_CalendarGadget()

#ObjectType_CanvasGadget="CanvasGadget"
Procedure Parser_CanvasGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_CanvasGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_CanvasGadget)
ParserElement()\Parser=@Parser_CanvasGadget()

#ObjectType_CheckBoxGadget="CheckBoxGadget"
Procedure Parser_CheckBoxGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_CheckBoxGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_CheckBoxGadget)
ParserElement()\Parser=@Parser_CheckBoxGadget()

#ObjectType_ComboBoxGadget="ComboBoxGadget"
Procedure Parser_ComboBoxGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ComboBoxGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ComboBoxGadget)
ParserElement()\Parser=@Parser_ComboBoxGadget()



#ObjectType_DateGadget="DateGadget"
Procedure Parser_DateGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_DateGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_DateGadget)
ParserElement()\Parser=@Parser_DateGadget()

#ObjectType_EditorGadget="EditorGadget"
Procedure Parser_EditorGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_EditorGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_EditorGadget)
ParserElement()\Parser=@Parser_EditorGadget()

#ObjectType_ExplorerComboGadget="ExplorerComboGadget"
Procedure Parser_ExplorerComboGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ExplorerComboGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ExplorerComboGadget)
ParserElement()\Parser=@Parser_ExplorerComboGadget()

#ObjectType_ExplorerListGadget="ExplorerListGadget"
Procedure Parser_ExplorerListGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ExplorerListGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ExplorerListGadget)
ParserElement()\Parser=@Parser_ExplorerListGadget()

#ObjectType_ExplorerTreeGadget="ExplorerTreeGadget"
Procedure Parser_ExplorerTreeGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ExplorerTreeGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ExplorerTreeGadget)
ParserElement()\Parser=@Parser_ExplorerTreeGadget()

#ObjectType_FrameGadget="FrameGadget"
Procedure Parser_FrameGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_FrameGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_FrameGadget)
ParserElement()\Parser=@Parser_FrameGadget()

#ObjectType_HyperLinkGadget="HyperLinkGadget"
Procedure Parser_HyperLinkGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_HyperLinkGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_HyperLinkGadget)
ParserElement()\Parser=@Parser_HyperLinkGadget()

#ObjectType_IPAddressGadget="IPAddressGadget"
Procedure Parser_IPAddressGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_IPAddressGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_IPAddressGadget)
ParserElement()\Parser=@Parser_IPAddressGadget()

#ObjectType_ImageGadget="ImageGadget"
Procedure Parser_ImageGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ImageGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ImageGadget)
ParserElement()\Parser=@Parser_ImageGadget()

#ObjectType_ListIconGadget="ListIconGadget"
Procedure Parser_ListIconGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ListIconGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ListIconGadget)
ParserElement()\Parser=@Parser_ListIconGadget()

#ObjectType_ListViewGadget="ListViewGadget"
Procedure Parser_ListViewGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ListViewGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ListViewGadget)
ParserElement()\Parser=@Parser_ListViewGadget()

#ObjectType_MDIGadget="MDIGadget"
Procedure Parser_MDIGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_MDIGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_MDIGadget)
ParserElement()\Parser=@Parser_MDIGadget()

#ObjectType_OpenGLGadget="OpenGLGadget"
Procedure Parser_OpenGLGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_OpenGLGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_OpenGLGadget)
ParserElement()\Parser=@Parser_OpenGLGadget()

#ObjectType_OptionGadget="OptionGadget"
Procedure Parser_OptionGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_OptionGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_OptionGadget)
ParserElement()\Parser=@Parser_OptionGadget()

#ObjectType_PanelGadget="PanelGadget"
Procedure Parser_PanelGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_PanelGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_PanelGadget)
ParserElement()\Parser=@Parser_PanelGadget()

#ObjectType_ProgressBarGadget="ProgressBarGadget"
Procedure Parser_ProgressBarGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ProgressBarGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ProgressBarGadget)
ParserElement()\Parser=@Parser_ProgressBarGadget()

#ObjectType_ScrollAreaGadget="ScrollAreaGadget"
Procedure Parser_ScrollAreaGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ScrollAreaGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ScrollAreaGadget)
ParserElement()\Parser=@Parser_ScrollAreaGadget()

#ObjectType_ScrollBarGadget="ScrollBarGadget"
Procedure Parser_ScrollBarGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ScrollBarGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ScrollBarGadget)
ParserElement()\Parser=@Parser_ScrollBarGadget()

#ObjectType_ShortcutGadget="ShortcutGadget"
Procedure Parser_ShortcutGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_ShortcutGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_ShortcutGadget)
ParserElement()\Parser=@Parser_ShortcutGadget()

#ObjectType_SpinGadget="SpinGadget"
Procedure Parser_SpinGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_SpinGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_SpinGadget)
ParserElement()\Parser=@Parser_SpinGadget()

#ObjectType_SplitterGadget="SplitterGadget"
Procedure Parser_SplitterGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_SplitterGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_SplitterGadget)
ParserElement()\Parser=@Parser_SplitterGadget()

#ObjectType_StringGadget="StringGadget"
Procedure Parser_StringGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_StringGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_StringGadget)
ParserElement()\Parser=@Parser_StringGadget()

#ObjectType_TextGadget="TextGadget"
Procedure Parser_TextGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_TextGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_TextGadget)
ParserElement()\Parser=@Parser_TextGadget()

#ObjectType_TrackBarGadget="TrackBarGadget"
Procedure Parser_TrackBarGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_TrackBarGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_TrackBarGadget)
ParserElement()\Parser=@Parser_TrackBarGadget()

#ObjectType_TreeGadget="TreeGadget"
Procedure Parser_TreeGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_TreeGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_TreeGadget)
ParserElement()\Parser=@Parser_TreeGadget()

#ObjectType_WebGadget="WebGadget"
Procedure Parser_WebGadget(Position, Length, Content$)
  Shared CurrentParent

  AddObject(#ObjectType_WebGadget, CurrentParent, Position, Length, Content$)
  
EndProcedure
AddMapElement(ParserElement(), #ObjectType_WebGadget)
ParserElement()\Parser=@Parser_WebGadget()

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
  
  Format=ReadStringFormat(#File)
  ByteLength = Lof(#File)
  *File = AllocateMemory(ByteLength)
  If *File : ReadData(#File, *File, ByteLength)
    FileContent$=PeekS(*File, ByteLength, Format)
    FreeMemory(*File)
  EndIf
  
  ; FileContent$ - Содержимое файла
  
  If ExamineRegularExpression(#Regex_FindProcedure, FileContent$)
    While NextRegularExpressionMatch(#Regex_FindProcedure)
      
      Function$=RegularExpressionMatchString(#Regex_FindProcedure)
      
      If ExamineRegularExpression(#RegEx_FindFunction, Function$)
        While NextRegularExpressionMatch(#RegEx_FindFunction)
          
          Content$=RegularExpressionMatchString(#RegEx_FindFunction)
          Position=(RegularExpressionMatchPosition(#Regex_FindProcedure)-1)+(RegularExpressionMatchPosition(#RegEx_FindFunction)-1)
          Length=RegularExpressionMatchLength(#Regex_FindProcedure)
          
          ObjectType$=RegularExpressionGroup(#RegEx_FindFunction, 1)
          

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
; CursorPosition = 144
; FirstLine = 97
; Folding = -D-----
; EnableUnicode
; EnableXP