;-{ Scintilla
DeclareModule Scintilla
  EnableExplicit
  
  Declare SetText(Gadget, Text.S)
  Declare Gadget( Gadget,X,Y,Width,Height, *CallBack=0, Scintilla.S="scintilla.dll", SyntaxHilighting.S=#PB_Compiler_Home+"SDK\Syntax Highlighting\SyntaxHilighting.dll" )
EndDeclareModule

Module Scintilla
  Enumeration
    #SYNTAX_Text
    #SYNTAX_Keyword  
    #SYNTAX_Comment
    #SYNTAX_Constant
    #SYNTAX_String
    #SYNTAX_Function
    #SYNTAX_Asm
    #SYNTAX_Operator
    #SYNTAX_Structure
    #SYNTAX_Number
    #SYNTAX_Pointer
    #SYNTAX_Separator
    #SYNTAX_Label  
    #SYNTAX_Module
  EndEnumeration
  
  Prototype SyntaxHighlight(*Buffer, Length, *Callback, Asm); Define protype for the dll function
  Global SyntaxHighlight.SyntaxHighlight
  Global ScintillaGadget
  
  Procedure SetText(Gadget, Text.S)
    Static ScintillaText.S
    
    CompilerIf #PB_Compiler_Unicode
      ScintillaText = Space(StringByteLength(Text, #PB_UTF8))
      PokeS(@ScintillaText, Text, -1, #PB_UTF8)
      ScintillaSendMessage(Gadget, #SCI_SETCODEPAGE, #SC_CP_UTF8)
    CompilerElse
      ScintillaText = Text
    CompilerEndIf
    
    ScintillaSendMessage(Gadget, #SCI_SETTEXT, 0, @ScintillaText)
  EndProcedure
  
  Procedure ColorCallback(*Buffer, Length, Color)
    ScintillaSendMessage(ScintillaGadget, #SCI_SETSTYLING, Length, Color)
  EndProcedure
  
  Procedure ScintillaCallback(Gadget, *scinotify.SCNotification)
    Protected LastStyled, Range.TEXTRANGE
    ; This event indicates that new coloring is needed. The #SCI_GETENDSTYLED message and *scinotify\position indicate the range to color
; ;     If *scinotify\nmhdr\code = #SCN_STYLENEEDED
; ;       ScintillaGadget = Gadget 
; ;       
; ;       ; calculate the range to color
; ;       ; always start coloring at the line start 
; ;       LastStyled = ScintillaSendMessage(Gadget, #SCI_GETENDSTYLED)
; ;       Range\chrg\cpMin = ScintillaSendMessage(Gadget, #SCI_POSITIONFROMLINE,
; ;                                               ScintillaSendMessage(Gadget, #SCI_LINEFROMPOSITION, LastStyled))
; ;       Range\chrg\cpMax = *scinotify\position
; ;       Range\lpstrText = AllocateMemory(Range\chrg\cpMax - Range\chrg\cpMin + 1)
; ;       
; ;       If Range\lpstrText
; ;         ; retrieve the text range
; ;         ScintillaSendMessage(Gadget, #SCI_GETTEXTRANGE, 0, @Range)   
; ;         
; ;         ; start coloring
; ;         ScintillaSendMessage(Gadget, #SCI_STARTSTYLING, Range\chrg\cpMin, $FF)   
; ;         
; ;         ; call the parser function in the dllRange\lpstrText
; ;         ; the callback above will apply the colors to the returned tokens      
; ;         SyntaxHighlight(Range\lpstrText, Range\chrg\cpMax - Range\chrg\cpMin, @ColorCallback(), #False)      
; ;         
; ;         FreeMemory(Range\lpstrText)
; ;       EndIf
; ;       
; ;     EndIf  
  EndProcedure
  
  Procedure Gadget( Gadget,X,Y,Width,Height, *CallBack=0, Scintilla.S="scintilla.dll", SyntaxHilighting.S=#PB_Compiler_Home+"SDK\Syntax Highlighting\SyntaxHilighting.dll")
    Protected *FontName, Syntax, GadgetID
    
    If InitScintilla(Scintilla) 
      If Not *CallBack : *CallBack=@ScintillaCallback() : EndIf
        
        ; create window and gadget
        GadgetID=ScintillaGadget(Gadget,X,Y,Width,Height, *CallBack) 
        If Gadget=#PB_Any : Gadget=GadgetID : EndIf
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
           Syntax = OpenLibrary(#PB_Any, SyntaxHilighting)
           If Syntax 
              ; get the syntax parser function
              SyntaxHighlight = GetFunction(Syntax, "SyntaxHighlight")
              
              ; Important: tell the gadget to send the #SCN_STYLENEEDED notification to the callback if coloring is needed
              ScintillaSendMessage(Gadget, #SCI_SETLEXER, #SCLEX_CONTAINER)
              
              ; Enable line numbers
              ScintillaSendMessage(Gadget, #SCI_SETMARGINTYPEN, #True, #SC_MARGIN_NUMBER)
              
              ; Set common style info
              *FontName = AllocateMemory(StringByteLength("Consolas", #PB_Ascii) + 1)
              If *FontName
                 PokeS(*FontName, "Consolas", -1, #PB_Ascii)
                 ScintillaSendMessage(Gadget, #SCI_STYLESETFONT, #STYLE_DEFAULT, *FontName)    
                 FreeMemory(*FontName)
              EndIf  
              
              ScintillaSendMessage(Gadget, #SCI_STYLESETSIZE, #STYLE_DEFAULT, 10) 
              ScintillaSendMessage(Gadget, #SCI_STYLESETBACK, #SCI_STYLESETFORE, 0)
              ScintillaSendMessage(Gadget, #SCI_STYLESETBACK, #STYLE_DEFAULT, $DFFFFF)
              ScintillaSendMessage(Gadget, #SCI_STYLECLEARALL)
              
              ; Set individual colors
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Text, 0)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Keyword, $666600)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Comment, $AAAA00)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Constant, $724B92)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_String, $FF8000)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Function, $666600)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Asm, $DFFFFF)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Operator, $8000FF)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Structure, $0080FF)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Number, $8080FF)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Pointer, $FF0080)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Separator, $FF0000)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Label, $C864FF)
              ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Module, $433740)
              ScintillaSendMessage(Gadget, #SCI_STYLESETBOLD, #SYNTAX_Keyword, #True)
              
              ;                     ScintillaSendMessage(Gadget, #SCI_SETMARGINTYPEN, 0, #SC_MARGIN_NUMBER) ; Добавляем поле автонумерации
              ;                     ScintillaSendMessage(Gadget, #SCI_SETMARGINWIDTHN, 0, 60 )     ; AntoNumWidth Ширина поля автонумерации
              ;                     ScintillaSendMessage(Gadget, #SCI_STYLESETFORE,#STYLE_LINENUMBER,$6D8E91) ; ColorFontNumber Цвет цифр автонумерации
              ;                     ScintillaSendMessage(Gadget, #SCI_STYLESETBACK,#STYLE_LINENUMBER,$CFDADB) ; ColorBackNumber Цвет фона области автонумерации
              
           Else
              MessageRequester("Ошибка", SyntaxHilighting+#CRLF$+"чтении SyntaxHilighting.dll")
           EndIf
           
        CompilerEndIf
     Else
        MessageRequester("Ошибка", Scintilla+#CRLF$+"инициализации scintilla")
    EndIf
    
    ProcedureReturn GadgetID
  EndProcedure
EndModule ;}

CompilerIf #PB_Compiler_IsMainFile
  ;{
  Text$ = "EnableExplicit"+#CRLF$+
          ""+#CRLF$+
          "Global Window_0=-1"+#CRLF$+
          ""+#CRLF$+
          "Declare Window_0_Events()"+#CRLF$+
          ""+#CRLF$+
          "Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)"+#CRLF$+
          "  If Not IsWindow(Window_0)"+#CRLF$+
          ~"    Window_0 = OpenWindow(#PB_Any,230,230,240,200,\"Window_0\", Flag)"+#CRLF$+  
          "    "+#CRLF$+    
          "    BindEvent(#PB_Event_Gadget, @Window_0_Events(), Window_0)"+#CRLF$+
          "  EndIf"+#CRLF$+
          ""+#CRLF$+  
          "  ProcedureReturn Window_0"+#CRLF$+
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
          "  While IsWindow(Window_0)"+#CRLF$+
          "    Select WaitWindowEvent()"+#CRLF$+
          "      Case #PB_Event_CloseWindow"+#CRLF$+
          "        If IsWindow(EventWindow())"+#CRLF$+
          "          CloseWindow(EventWindow())"+#CRLF$+
          "        Else"+#CRLF$+
          "          CloseWindow(Window_0)"+#CRLF$+
          "        EndIf"+#CRLF$+
          "    EndSelect"+#CRLF$+
          "  Wend"+#CRLF$+
          "CompilerEndIf"
  ;}
  
  If OpenWindow(0, 0, 0, 320, 390, "ScintillaGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    Scintilla::Gadget(0, 10, 10, 300, 370)
    Scintilla::SetText(0, Text$)
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.04 LTS - C Backend (MacOS X - x64)
; CursorPosition = 90
; FirstLine = 83
; Folding = ---
; EnableXP