



Enumeration File
  #File
EndEnumeration

Enumeration RegularExpression
  #Regex_Comments
  #Regex_Exception
  
  #RegEx_FindFunction
  #RegEx_FindFields
  #Regex_FindProcedure

  #PP_RegEx_String
EndEnumeration

CreateRegularExpression(#Regex_Exception, ~"\".*?;.*?\"")
CreateRegularExpression(#Regex_Comments, ";.*")



FilePath$=OpenFileRequester("Выберите файл с комментариями", "", "Файлы PureBasic (*.pb;*.pbf)|*.pb;*.pbf|Все файлы|*", 0)
If FilePath$ And ReadFile(#File, FilePath$)
  Debug "Открывается файл: "+FilePath$
  
  Format=ReadStringFormat(#File)
  ByteLength = Lof(#File)
  *File = AllocateMemory(ByteLength)
  If *File : ReadData(#File, *File, ByteLength)
    FileContent$=PeekS(*File, ByteLength, Format)
    FreeMemory(*File)
  EndIf
  
  ; FileContent$ - Содержимое файла
  
  
  
  
  ClearContent$=FileContent$
  
  If ExamineRegularExpression(#Regex_Exception, ClearContent$)
    While NextRegularExpressionMatch(#Regex_Exception)
      
      Exception$=RegularExpressionMatchString(#Regex_Exception)
      Position=RegularExpressionMatchPosition(#Regex_Exception)
      Length=RegularExpressionMatchLength(#Regex_Exception)
      
      ClearContent$=ReplaceString(ClearContent$, Exception$, ~"\""+Space(Length-2)+~"\"", #PB_String_CaseSensitive  , Position, 1)
      
    Wend
  EndIf
  
  If ExamineRegularExpression(#Regex_Comments, ClearContent$)
    While NextRegularExpressionMatch(#Regex_Comments)
      
      Comment$=RegularExpressionMatchString(#Regex_Comments)
      Position=RegularExpressionMatchPosition(#Regex_Comments)
      Length=RegularExpressionMatchLength(#Regex_Comments)
      
      ClearContent$=ReplaceString(ClearContent$, Comment$, Space(Length), #PB_String_CaseSensitive  , Position, 1)
      
    Wend
  EndIf
  
  
  Debug "Символов в исходном файле: "+Len(FileContent$)
  Debug "Символов в очищенном файле: "+Len(ClearContent$)
  
  
  Debug "Файл после чистки"
  Debug "=====  Начало  ==============="
  Debug ClearContent$
  Debug "=====  Конец  ==============="
  
  
EndIf




; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 75
; FirstLine = 28
; EnableXP
; CompileSourceDirectory