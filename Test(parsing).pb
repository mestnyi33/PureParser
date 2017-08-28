EnableExplicit

#File = 0

Enumeration RegularExpression
  #RegEx_FindFunction
  #RegEx_FindArguments
  #Regex_FindProcedure
  #RegEx_FindVar
EndEnumeration


Procedure.S ParsePBFile(FileName.s)
  Protected i,result.S, Texts.S, Text.S, Find.S, String.S, Position, Count, Index
  
  If ReadFile(#File, FileName)
    Protected Create_Reg_Flag = #PB_RegularExpression_NoCase | #PB_RegularExpression_MultiLine | #PB_RegularExpression_DotAll    
    Protected Line, FindWindow, Function$, FunctionArgs$
    Protected Format=ReadStringFormat(#File)
    Protected StringPosition, StringLength
    Protected Length = Lof(#File) 
    Protected File$, Type$, Args$, Arg$
    Protected *File = AllocateMemory(Length)
    
    If *File 
      ReadData(#File, *File, Length)
      File$ = PeekS(*File, Length, Format)
      
      If CreateRegularExpression(#Regex_FindProcedure, "[^;]Procedure.*?EndProcedure", Create_Reg_Flag) And
         CreateRegularExpression(#RegEx_FindFunction, "(\w+)\s*\((.*?)\)(?=\s*(;|:|$))", Create_Reg_Flag) And
         CreateRegularExpression(#RegEx_FindArguments, "[^,]+", Create_Reg_Flag)
        
        If ExamineRegularExpression(#Regex_FindProcedure, File$)
          While NextRegularExpressionMatch(#Regex_FindProcedure)
            Function$=RegularExpressionMatchString(#Regex_FindProcedure)
            ;Debug Function$
            
            If ExamineRegularExpression(#RegEx_FindFunction, Function$)
              While NextRegularExpressionMatch(#RegEx_FindFunction)
                With *This
                  Type$=RegularExpressionGroup(#RegEx_FindFunction, 1)
                  Args$=RegularExpressionGroup(#RegEx_FindFunction, 2)
                  
                  Select Type$
                    Case "OpenWindow", ; FindString(\Type$, "Gadget"),-1,#PB_String_NoCase) ;
                         "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
                         "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
                         "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
                         "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
                         "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
                         "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
                         "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
                         "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
                      
                      StringPosition = RegularExpressionMatchPosition(#Regex_FindProcedure)+RegularExpressionMatchPosition(#RegEx_FindFunction) -2 
                      StringLength = RegularExpressionMatchLength(#RegEx_FindFunction)
                      ;                         Debug "Position - "+Position
                      ;                         Debug "Length - "+Length
                      Count = 0
                      Texts =  Chr(10)+ Type$
                      
                      
                      If ExamineRegularExpression(#RegEx_FindArguments, Args$)
                        While NextRegularExpressionMatch(#RegEx_FindArguments)
                          Arg$ = RegularExpressionMatchString(#RegEx_FindArguments)
                          
                        Wend
                      EndIf
                      
                      
                      
                    Case "CloseGadgetList", "UseGadgetList"       
                    Case "AddGadgetItem"       
                    Case "OpenGadgetList"      
                      
                    Default
                      Text = RegularExpressionMatchString(#RegEx_FindFunction)
                      
                      
                  EndSelect
                  
                EndWith
              Wend
              
            EndIf
            
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
  
  Define File$=OpenFileRequester("Выберите файл с описанием окон", "", "Все файлы|*", 0)
  
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