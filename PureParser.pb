;- Абстрактные представления

; Здесь собраны структурные представления о строении формы

Structure Object      ; Объектами могут быть окна и гаджеты
  ObjectID.i
  ParentID.i
  ObjectType.s
EndStructure 

Structure Field       ; Полями могут быть любые аргументы в обьектах
  FieldID.i
  ObjectID.i
  FieldType.s
  Position.i
  Length.i
  Content.s
EndStructure

NewList Object.Object()       ; Список объектов
NewList Field.Field()         ; Список полей

Procedure AddObject(ObjectType.s, ParentID)                           ; Процедура добавляет новый объект
  Static ObjectID
  
  Shared Object()
  *Element.Object=AddElement(Object())
  If *Element : ObjectID+1
    With *Element
      \ObjectID=ObjectID
      \ParentID=ParentID
      \ObjectType=ObjectType
    EndWith
    
    Result=ObjectID
  EndIf
  
  ProcedureReturn Result
EndProcedure
Procedure AddField(ObjectID, FieldType.s, Position, Length, Content$) ; Процедура добавляет новое поле
  Static FieldID
  
  Shared Field()
  *Element.Field=AddElement(Field())
  If *Element : FieldID+1
    With *Element
      \FieldID=FieldID
      \ObjectID=ObjectID
      \FieldType=FieldType
      \Position=Position
      \Length=Length
      \Content=Content$
    EndWith
    
    Result=FieldID
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


CreateRegularExpression(#Regex_FindProcedure, "Procedure.*?EndProcedure", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?)\)(?=\s*($|:))", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)
CreateRegularExpression(#RegEx_FindFields, "[^,]+", #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll)





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
          
          FunctionName$=RegularExpressionGroup(#RegEx_FindFunction, 1)
          FunctionArgs$=RegularExpressionGroup(#RegEx_FindFunction, 2)
          
          
          Select FunctionName$
            Case "OpenWindow", "ButtonGadget", "ButtonImageGadget", "CalendarGadget", "CanvasGadget", "CheckBoxGadget", "ComboBoxGadget", "ContainerGadget", "DateGadget", "EditorGadget", "ExplorerComboGadget", "ExplorerListGadget", "ExplorerTreeGadget", "FrameGadget", "HyperLinkGadget", "IPAddressGadget", "ImageGadget", "ListIconGadget", "ListViewGadget", "MDIGadget", "OpenGLGadget", "OptionGadget", "PanelGadget", "ProgressBarGadget", "ScrollAreaGadget", "ScrollBarGadget", "ShortcutGadget", "SpinGadget", "SplitterGadget", "StringGadget", "TextGadget", "TrackBarGadget", "TreeGadget", "WebGadget"
              
              If FunctionName$="OpenWindow"
                ParentID=0
              EndIf
              
              ObjectID=AddObject(FunctionName$, ParentID)
              
              If FunctionName$="OpenWindow"
                ParentID=ObjectID
              EndIf
              
              If ExamineRegularExpression(#RegEx_FindFields, FunctionArgs$)
                While NextRegularExpressionMatch(#RegEx_FindFields)
                  
                  Position=(RegularExpressionMatchPosition(#Regex_FindProcedure)-1)+(RegularExpressionMatchPosition(#RegEx_FindFunction)-1)+(RegularExpressionGroupPosition(#RegEx_FindFunction, 2))+(RegularExpressionMatchPosition(#RegEx_FindFields)-1)
                  
                  Length=RegularExpressionMatchLength(#RegEx_FindFields)
                  
                  AddField(ObjectID, "", Position, Length, RegularExpressionMatchString(#RegEx_FindFields))
                  
                Wend
              EndIf
              
          EndSelect
        Wend
      EndIf
    Wend
  EndIf
  
  
EndIf





;- Вывод результатов

ForEach Object()
  Debug Str(Object()\ObjectID)+")"+Chr(9)+Object()\ObjectType+Chr(9)+"Parent{"+Object()\ParentID+"}"
Next

ForEach Field()
  Debug Str(Field()\FieldID)+")"+Chr(9)+"{"+Field()\Content+"}"+Chr(9)+" ["+Str(Field()\Position)+", "+Str(Field()\Length)+"]"
Next




; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; CursorPosition = 158
; FirstLine = 40
; Folding = 9
; EnableUnicode
; EnableXP