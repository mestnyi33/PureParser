EnableExplicit

#File = 0

Enumeration RegularExpression
  #RegEx_FindFunction
  #RegEx_FindArguments
  #Regex_FindComment
  #Regex_FindUnComment
  #RegEx_FindVar
EndEnumeration


Procedure.S ParsePBFile(FileName.s)
  Protected i,result.S, Texts.S, Text.S, Find.S, String.S, Position, Count, Index
  
  If ReadFile(#File, FileName)
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_DotAll | #PB_RegularExpression_MultiLine   
    Protected Line, FindWindow, Function$, FunctionArgs$
    Protected Format=ReadStringFormat(#File)
    Protected StringPosition, StringLength
    Protected Length = Lof(#File) 
    Protected File$, Type$, Args$, Arg$
    Protected *File = AllocateMemory(Length)
    
    If *File 
      ReadData(#File, *File, Length)
      File$ = PeekS(*File, Length, Format)
      
 ;     If CreateRegularExpression(#RegEx_FindFunction, "(?=^\s*;.*?$)", Create_Reg_Flag) ; "(\w+)\s*\((.*?)\)(?=\s*(;|:|$))", Create_Reg_Flag) And
      If CreateRegularExpression(#RegEx_FindFunction, "[^;].*?(\(.*?\))", Create_Reg_Flag) ; "(\w+)\s*\((.*?)\)(?=\s*(;|:|$))", Create_Reg_Flag) And
;      If CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?),(.*?),(.*?)\)", Create_Reg_Flag) ; "(\w+)\s*\((.*?)\)(?=\s*(;|:|$))", Create_Reg_Flag) And
;        If CreateRegularExpression(#Regex_FindComment, "^\s*;.*?$", Create_Reg_Flag) And
;          CreateRegularExpression(#RegEx_FindArguments, "[^,]+", Create_Reg_Flag)
        
        If ExamineRegularExpression(#RegEx_FindFunction, File$)
          While NextRegularExpressionMatch(#RegEx_FindFunction)
            Function$=RegularExpressionMatchString(#RegEx_FindFunction)
            Debug Function$
; ;             Debug "1 - "+RegularExpressionGroup(#RegEx_FindFunction, 1)
; ;             Debug "2 - "+RegularExpressionGroup(#RegEx_FindFunction, 2)
; ; ;             Debug "3 - "+RegularExpressionGroup(#RegEx_FindFunction, 3)
; ; ;             Debug "4 - "+RegularExpressionGroup(#RegEx_FindFunction, 4)
; ;             
            
          Wend
        EndIf
        
      EndIf
    EndIf
    
    CloseFile(#File)
    
  EndIf
  
  ;Debug result
  ProcedureReturn result.S
EndProcedure



CompilerIf #PB_Compiler_IsMainFile
  Global Window_0 =  OpenWindow(#PB_Any, 0, 0, 100, 100, "WindowTitle", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
  
  Define File$="Test(parser).pb";OpenFileRequester("Выберите файл с описанием окон", "", "Все файлы|*", 0) ; 
  
  If File$
    Define Load$ = ParsePBFile(File$)
  EndIf 
  
  While IsWindow( Window_0 )
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow 
        CloseWindow( EventWindow() )
    EndSelect
  Wend
  
  End 
CompilerEndIf 