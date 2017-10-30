;{
Text$ = "EnableExplicit"+#CRLF$+
        ""+#CRLF$+
        "Global #Window_0=-1"+#CRLF$+
        ""+#CRLF$+
        "Declare Window_0_Events()"+#CRLF$+
        ""+#CRLF$+
        "Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)"+#CRLF$+
        "  If Not IsWindow(#Window_0)"+#CRLF$+
        ~"    #Window_0 = OpenWindow(#PB_Any,230,230,240,200,\"#Window_0\", Flag)"+#CRLF$+  
        "    "+#CRLF$+    
        "    BindEvent(#PB_Event_Gadget, @Window_0_Events(), #Window_0)"+#CRLF$+
        "  EndIf"+#CRLF$+
        ""+#CRLF$+  
        "  ProcedureReturn #Window_0"+#CRLF$+
        "EndProcedure"+#CRLF$+
        ""+#CRLF$+
        "Procedure Window_0_Events()"+#CRLF$+
        "  Select Event()"+#CRLF$+
        "    Case #PB_Event_Gadget"+#CRLF$+
        "      Select EventType()"+#CRLF$+
        "        Case #PB_EventType_LeftClick"+#CRLF$+
        "          Select EventGadget()"+#CRLF$+
        ""+#CRLF$+            
        "          EndSelect"+#CRLF$+
        "      EndSelect"+#CRLF$+
        "  EndSelect"+#CRLF$+
        "EndProcedure"+#CRLF$+
        ""+#CRLF$+
        ""+#CRLF$+
        "CompilerIf #PB_Compiler_IsMainFile"+#CRLF$+
        "  Window_0_Open()"+#CRLF$+
        ""+#CRLF$+  
        "  While IsWindow(#Window_0)"+#CRLF$+
        "    Select WaitWindowEvent()"+#CRLF$+
        "      Case #PB_Event_CloseWindow"+#CRLF$+
        "        If IsWindow(EventWindow())"+#CRLF$+
        "          CloseWindow(EventWindow())"+#CRLF$+
        "        Else"+#CRLF$+
        "          CloseWindow(#Window_0)"+#CRLF$+
        "        EndIf"+#CRLF$+
        "    EndSelect"+#CRLF$+
        "  Wend"+#CRLF$+
        "CompilerEndIf"
;}

; This expression matches a color setting string (with value red, green or blue)
; The colors are grouped with() and the color value is extracted in case of a match
; (?>[^\w])(#Window_0)(?!\w|\s*\")
; \b(#Window_0)(?!\w|\s*\")
; \b(#Window_0)\b(?!\s*\")

If CreateRegularExpression(0, "(?<!\w)("+"#Window_0"+~")(?!\\w|\\s*\")") ; "([^\w])("+"#Window_0"+~")([^\\w])|\"\\s*\\w+\\s*\"")
  If ExamineRegularExpression(0, Text$)
    While NextRegularExpressionMatch(0)
      Debug "match "+RegularExpressionMatchString(0)
      Text$=ReplaceRegularExpression(0, Text$, "Window_0")
      Break
    Wend
  EndIf
Else
  Debug RegularExpressionError()
EndIf

Debug Text$