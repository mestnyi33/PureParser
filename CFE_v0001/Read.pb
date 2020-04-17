; Должен находить pb функции
;-
EnableExplicit

Global Window_0

Global Editor_0, Editor_1, Editor_2, Check,Open,Run,Save

Procedure.S FindFunction(ReadString$) ; Ok
  Protected Finds.S, Type.S
  Restore Types
  Read$ Type.S
  
  While Type.S 
    If FindString(ReadString$, Type.S+"(") 
      Finds.S = "Find >> "+ReadString$
    EndIf
    
    If Finds.S
      Break
    EndIf
    
    Read$ Type.S
  Wend
  
  ProcedureReturn Finds.S
  
  DataSection
    Types: 
    Data$ "OpenWindow"
    Data$ "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
          "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
          "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
          "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
          "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
          "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
          "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
          "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
    Data$ ""
  EndDataSection
EndProcedure

Procedure.S Parse( ReadString.S ) ;Ok
  Protected I
  Protected Count.I
  Protected String.S
  
  Protected Name.S
  Protected Type.S
  Protected X.S
  Protected Y.S
  Protected Width.S
  Protected Height.S
  Protected Caption.S
  Protected Param1.S
  Protected Param2.S
  Protected Param3.S
  Protected Flag.S
  Protected CountString.I
  ReadString.S = Trim( ReadString.S )
  
  ;
;   If FindString( StringField( ReadString.S, 1, Chr(',') ), Chr(')'))
;     Type.S = StringField( ReadString.S, (1), Chr('('))
;   Else
;     Type.S = StringField( ReadString.S, CountString( StringField( ReadString.S, 1, Chr(',') ), Chr('(')), Chr('('))
;   EndIf
  Type.S = StringField( ReadString.S, (1), Chr('('))
  Type.S = StringField( Type.S, (2), Chr('='))
  
  ;Handle.S = Trim(StringField(Type.S, 1, Chr('='))) ; 
  ;Type.S = Trim(StringField(Type.S, 2, Chr('='))) ; делает одно и тоже
  String.S = Trim(StringField( ReadString.S, (2), Chr('(')), Chr(')'))
  
  
  ; Если только одна закрывающая скобка
  X.S = StringField( String.S, 2, ",")
  Y.S = StringField( String.S, 3, ",")
  
  Width.S = StringField( String.S, 4, ",")
  If Width.S = StringField( Width.S, 1, "(")
  Else
    Width.S + ")"
  EndIf
  
  Height.S = StringField( String.S, 5, ",")
  If Height.S = StringField( Height.S, 1, "(")
  Else
    Height.S + ")"
  EndIf
  
  Caption.S = StringField( String.S, 6, ",")
  Flag.S = StringField( String.S, 7, ",")
  
  If CountString(Caption.S, Chr('"')) = 0
    Flag.S = Caption.S
    Caption.S = ""
  EndIf
  
  
  
  ProcedureReturn Chr(10)+ 
Type.S + Chr(10)+
; ID.S + Chr(10)+ 
  X.S + Chr(10)+ 
        Y.S +Chr(10)+ 
        Width.S +Chr(10)+ 
        Height.S +Chr(10)+ 
        Caption.S +Chr(10)+
        Param1.S +Chr(10)+
        Param2.S +Chr(10)+ 
        Param3.S +Chr(10)+ 
        Flag.S +Chr(10) 
  
EndProcedure


Procedure$ LoadFromFile(File$)
  Protected Texts.S
  Protected StringFormat, Line, Text.S, Position, Length, Find.S, String.S
  
  If ReadFile(0, File$)
    CompilerIf #PB_Compiler_Unicode
      StringFormat = ReadStringFormat( 0 ) ; Определение кодировки файла (Ascii, UTF8 или Unicode).
    CompilerElse
      StringFormat = #PB_Ascii
    CompilerEndIf 
    
    While Eof(0) = 0 : Line + 1
      Text.S = ReadString(0)
      Position = Loc( 0 )
      Length = StringByteLength( Text.S, StringFormat)
      
      Texts.S + Str(Line)+" "+Text.S + #LF$
      
      Find.S = FindFunction(Text.S)
      
      If Find.S
        String.S = Find.S +Chr(10)+Chr(10)+ Str(Line) +Chr(10)+ Str(Position) +Chr(10)+ Str(Length)
        AddGadgetItem(Editor_2, -1, Parse( Text.S ))
      EndIf
    Wend
    
    AddGadgetItem(Editor_2, -1, Chr(10)+Str(Line))
    ;
    
    CloseFile(0)
    
  Else
    MessageRequester("Information","Couldn't open the file! "+File$ )
  EndIf
  
  ProcedureReturn Texts.S
EndProcedure 

CompilerIf #PB_Compiler_IsMainFile
  ;-
  Procedure Window_0_Event_Gadget()
    Static Time
    Protected Load$,Title$,File$,Pattern$,Pattern
    
    Select EventGadget()
        ;-OpenEvent
      Case Open
        Time = ElapsedMilliseconds()
        ;{ 
        Title$="Open PureBasic project"
        File$ = "test1.pb"
        Pattern$ = "PureBasic (*.pb*)|*.pb*"
        Pattern = 0
        
        File$ = OpenFileRequester(Title$,File$,Pattern$,Pattern)
        If File$
          Load$ = LoadFromFile(File$)
          ClearGadgetItems(Editor_0)
          AddGadgetItem(Editor_0,-1,Load$)
        EndIf 
        ;}
        Time = ElapsedMilliseconds() - Time
        
        SetWindowTitle(EventWindow(), Str(Time))
        
        ;-RunEvent
      Case Run  
        
        ;-SaveEvent
      Case Save  
        Title$="test1.pb/save"
        File$ = "test1.pb"
        Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*"
        Pattern = 0
        
        File$ = SaveFileRequester(Title$,File$,Pattern$,Pattern)
        If File$
          Protected a
          If CreateFile(0, File$)         ; we create a new text file...
            For a=1 To 10
              If a =  5
                WriteStringN(0, "Line "+Str(a))  ; we write 10 lines (each with 'end of line' character)
              EndIf
            Next
            
            
            CloseFile(0)                       ; close the previously opened file and store the written data this way
          Else
            MessageRequester("Information","may not create the file!")
          EndIf
          
          
        EndIf 
        
        ;-CheckEvent
      Case Check  
        If EventType() = #PB_EventType_Change
          Protected ID$ = StringField(GetGadgetItemText(Check,GetGadgetState(Check)),1,":")
          Protected Type = FindString(StringField(GetGadgetItemText(Check,GetGadgetState(Check)),3,":"),"OpenWindow")
          Protected ID = Val(ID$)
          
          Debug ID
          If Type
            If IsWindow(ID)
              SetActiveWindow(ID)
            EndIf
          Else
            If IsGadget(ID)
              SetActiveGadget(ID)
            EndIf
          EndIf
        EndIf
    EndSelect
  EndProcedure
  
  Procedure Window_0_Event_Size()
    Protected Window = EventWindow()
    Protected WindowWidth, WindowHeight
    WindowWidth = WindowWidth(Window)
    WindowHeight = WindowHeight(Window)/3-15
    ResizeGadget(Editor_0, 6, 6, WindowWidth - 12, WindowHeight)
    ResizeGadget(Editor_1, 6, GadgetY(Editor_0)+GadgetHeight(Editor_0)+3, WindowWidth - 12, GadgetHeight(Editor_0))
    ResizeGadget(Editor_2, 6, GadgetY(Editor_1)+GadgetHeight(Editor_1)+3, WindowWidth - 12, GadgetHeight(Editor_1))
    
    ResizeGadget(Save, WindowWidth-240, (WindowHeight*3)+17, #PB_Ignore,#PB_Ignore)
    ResizeGadget(Run, WindowWidth-160, (WindowHeight*3)+17, #PB_Ignore,#PB_Ignore)
    ResizeGadget(Open, WindowWidth-80, (WindowHeight*3)+17, #PB_Ignore,#PB_Ignore)
    
    ResizeGadget(Check, #PB_Ignore, (WindowHeight*3)+17, GadgetX(Save)-12,#PB_Ignore)
  EndProcedure
  
  Procedure Window_0_Open(X = 0, Y = 0, Width = 966, Height = 530)
    Protected Flags  = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget |
                       #PB_Window_SizeGadget | #PB_Window_Invisible |
                       #PB_Window_ScreenCentered
    
    Window_0 = OpenWindow(#PB_Any, X, Y, Width, Height, "", Flags)
    ResizeWindow(Window_0,#PB_Ignore,WindowY(Window_0)<<1-35,#PB_Ignore,#PB_Ignore)
    SendMessage_(WindowID(Window_0), #WM_SETICON, 0, ExtractIcon_(0,"shell32.dll",2))
    ;       StickyWindow(Window_0,#True)
    
    Editor_0 = EditorGadget(#PB_Any, 6, 6, 354, 138)
    Editor_1 = EditorGadget(#PB_Any, 6, 150, 354, 102)
    Editor_2 = ListIconGadget(#PB_Any, 6, 150, 354, 88,"Text.S",180)
    ;   AddGadgetColumn(Editor_2, 1, "Count.S", 80)
    ;   AddGadgetColumn(Editor_2, 2, "Line.S", 80)
    ;   
    ;   AddGadgetColumn(Editor_2, 3, "Position.S", 80)
    ;   AddGadgetColumn(Editor_2, 4, "Lentgh.S", 80)
    
    ;   AddGadgetColumn(Editor_2, 5, "Param1.S", 80)
    ;   AddGadgetColumn(Editor_2, 6, "Param2.S", 80)
    ;   
    ;   AddGadgetColumn(Editor_2, 7, "Param3.S", 80)
    ;   AddGadgetColumn(Editor_2, 8, "Line.S", 80)
    ;   
    ;   AddGadgetColumn(Editor_2, 9, "Text.S", 80)
    ;   AddGadgetColumn(Editor_2, 10, "Line.S", 80)
    ;   
    AddGadgetColumn(Editor_2, 11, "Type.S", 130)
    ;AddGadgetColumn(Editor_2, 12, "ID.S", 80)
    AddGadgetColumn(Editor_2, 13, "X", 40)
    AddGadgetColumn(Editor_2, 14, "Y", 40)
    AddGadgetColumn(Editor_2, 15, "Width", 50)
    AddGadgetColumn(Editor_2, 16, "Height", 50)
    AddGadgetColumn(Editor_2, 17, "Caption.S", 80)
    AddGadgetColumn(Editor_2, 18, "Param1.S", 60)
    AddGadgetColumn(Editor_2, 19, "Param2.S", 60)
    AddGadgetColumn(Editor_2, 20, "Param3.S", 60)
    ;AddGadgetColumn(Editor_2, 21, "Flag", 80)
    AddGadgetColumn(Editor_2, 22, "Flag.S", 180)
    
    Save = ButtonGadget(#PB_Any, Width-240, 258, 75, 25,"Save")
    Run = ButtonGadget(#PB_Any, Width-160, 258, 75, 25,"Run")
    Open = ButtonGadget(#PB_Any, Width-80, 258, 75, 25,"Open")
    
    Check = ComboBoxGadget(#PB_Any, 6, 258, GadgetX(Save)-12, 24)
    
    
    BindEvent(#PB_Event_SizeWindow, @Window_0_Event_Size(),Window_0)
    BindEvent(#PB_Event_Gadget, @Window_0_Event_Gadget(),Window_0)
    HideWindow(Window_0,#False)
    ProcedureReturn Window_0
  EndProcedure
  
  ;-
  Window_0 = Window_0_Open()
  
  Define File$ = "Form\1.pbf"
  ;Define File$ = "Form\2.pbf"
  ;Define File$ = "CFE_Read_Test(const).pbf"
  ;Define File$ = "CFE_Read_Test(variab).pbf"
  If File$
    Define Load$ = LoadFromFile(File$)
    ClearGadgetItems(Editor_0)
    AddGadgetItem(Editor_0,-1,Load$)
  EndIf 
  
  While IsWindow( Window_0 )
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow 
        CloseWindow( EventWindow() )
    EndSelect
  Wend
  
  End 
CompilerEndIf