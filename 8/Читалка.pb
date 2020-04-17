CreateRegularExpression(0, ~"Case\\s*?(#PB_GadgetType_\\S+).*?;\\{.*?;}", #PB_RegularExpression_DotAll|#PB_RegularExpression_MultiLine|#PB_RegularExpression_NoCase)
CreateRegularExpression(1, ~"\"([^|]+)\\|?\"", #PB_RegularExpression_NoCase)

Structure Flags
  GadgetType.s
  List Flags1.s()
  
EndStructure


NewList Flags.Flags()

If ReadFile(0, "A.pb", #PB_UTF8)
  Length = Lof(0)                            ; get the length of opened file
  *MemoryID = AllocateMemory(Length)         ; allocate the needed memory
  If *MemoryID
    bytes = ReadData(0, *MemoryID, Length)   ; read all data into the memory block
    
    
    File$=PeekS(*MemoryID, Length, #PB_UTF8)
    
    If ExamineRegularExpression(0, File$)
      While NextRegularExpressionMatch(0)

        
        Gadget$=RegularExpressionMatchString(0)
        
        AddElement(Flags())
        
        Flags()\GadgetType=RegularExpressionGroup(0, 1)
        
        
        If ExamineRegularExpression(1, Gadget$)
          While NextRegularExpressionMatch(1)

            
            AddElement(Flags()\Flags1())
            
            Flags()\Flags1()=RegularExpressionGroup(1, 1)
            
            
          Wend
        EndIf
        
        
        
        
      Wend
    EndIf
    
  EndIf
  CloseFile(0)
EndIf


GetGadget$=#CRLF$
SetGadget$=#CRLF$
RemoveGadget$=#CRLF$

ForEach Flags()
  
  GetGadget$+#CRLF$
  GetGadget$+"Case "+Flags()\GadgetType+#CRLF$
  
  SetGadget$+#CRLF$
  SetGadget$+"Case "+Flags()\GadgetType+#CRLF$
  
  RemoveGadget$+#CRLF$
  RemoveGadget$+"Case "+Flags()\GadgetType+#CRLF$
  
  ForEach Flags()\Flags1()
    GetGadget$+"  If IsFlag(Flags, #BS_RIGHT )"+#CRLF$
    GetGadget$+"    Flag|"+Flags()\Flags1()+#CRLF$
    GetGadget$+"  EndIf"+#CRLF$
    
    SetGadget$+"  If IsFlag(Flags,"+Flags()\Flags1()+")"+#CRLF$
    SetGadget$+"    SetStyle(Handle, (#BS_RIGHT))"+#CRLF$
    SetGadget$+"  EndIf"+#CRLF$
    
    RemoveGadget$+"  If IsFlag(Flags,"+Flags()\Flags1()+")"+#CRLF$
    RemoveGadget$+"    RemoveStyle(Handle, (#BS_RIGHT))"+#CRLF$
    RemoveGadget$+"  EndIf"+#CRLF$
    
  Next
  
  
Next





Debug "GetGadget"
Debug ";{"
Debug GetGadget$
Debug ";}"
Debug ""

Debug "SetGadget"
Debug ";{"
Debug SetGadget$
Debug ";}"
Debug ""

Debug "RemoveGadget"
Debug ";{"
Debug RemoveGadget$
Debug ";}"
Debug ""




; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 75
; FirstLine = 34
; EnableXP
; CompileSourceDirectory