
Enumeration File
  #File
EndEnumeration

Enumeration RegularExpression
  #Regex_Word
  #Regex_Enumeration
EndEnumeration


CreateRegularExpression(#Regex_Word, "\w+")
CreateRegularExpression(#Regex_Enumeration, "Enumeration.*[]", #PB_RegularExpression_NoCase)


Structure Field
  ZoneID.i
  Position.i
  Length.i
EndStructure


NewMap Zone()
NewMap Field.Field()


FieldCounter.i=0
Procedure ScanField(CurrentZone)
  Shared Field()
  Shared FieldCounter
  
  FieldCounter+1
  CurrentField=FieldCounter
  
  Debug "  CurrentField="+Str(CurrentField)
  AddMapElement(Field(), Str(CurrentField))
  
  Field()\ZoneID=CurrentZone
  Field()\Position=RegularExpressionMatchPosition(#Regex_Word)
  
  While NextRegularExpressionMatch(#Regex_Word)
    
    Word$=RegularExpressionMatchString(#Regex_Word)
    
    Select LCase(Word$)
      Case "endenumeration"
        Field()\Length=RegularExpressionMatchPosition(#Regex_Word)-Field()\Position+RegularExpressionMatchLength(#Regex_Word)
        Break
        
        
      Default
        
        
    EndSelect
  Wend
EndProcedure




ZoneCounter.i=0
Procedure ScanZone()
  Shared Zone()
  Shared ZoneCounter
  
  ZoneCounter+1
  CurrentZone=ZoneCounter
  
  Debug "CurrentZone="+Str(CurrentZone)
  AddMapElement(Zone(), Str(CurrentZone))
  
  While NextRegularExpressionMatch(#Regex_Word)
    
    Word$=RegularExpressionMatchString(#Regex_Word)
    
    Select LCase(Word$)
      Case "enumeration"
        ScanField(CurrentZone)
        
        
      Case "procedure"
        ScanZone()
        
      Case "endprocedure"
        Break
        
    EndSelect
    
  Wend
  
EndProcedure





FilePath$=OpenFileRequester("Выберите файл с описанием окон", "", "Файлы PureBasic (*.pb;*.pbf)|*.pb;*.pbf|Все файлы|*", 0)
If ReadFile(#File, FilePath$)
  Debug "Открывается файл: "+FilePath$
  
  Format=ReadStringFormat(#File)
  ByteLength = Lof(#File)
  
  
  *File = AllocateMemory(ByteLength)
  If *File 
    ReadData(#File, *File, ByteLength)
    FileContent$=PeekS(*File, ByteLength, Format)
    FreeMemory(*File)
  EndIf
  
  
  If ExamineRegularExpression(#Regex_Word, FileContent$)
    ScanZone()

    Debug "Были найдены следующие области:"
    ForEach Field()
      Debug "======================================"
      Debug Mid(FileContent$, Field()\Position, Field()\Length)
      Debug "======================================"
    Next
    
  EndIf
EndIf


; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 95
; FirstLine = 77
; Folding = -
; EnableXP
; CompileSourceDirectory