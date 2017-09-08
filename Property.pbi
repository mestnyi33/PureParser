CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "Transformation.pbi"
CompilerEndIf

;- Window_Property
Enumeration Window
  #Property = 5
EndEnumeration

Enumeration Gadget
  #Property_Method_Container
  #Property_Method_Gadget
  #Property_Method_Any
  #Property_Method_Enum
  #Property_Method_Caption
  #Property_Method_Event
  #Property_Method_Type
  
  #Property_Method_X
  #Property_Method_Y
  #Property_Method_Width
  #Property_Method_Heght
  
  #Property_Method_Flag
  #Property_Method_Hide
  #Property_Method_Disable
  
  #Property_Event_Gadget
  #Property_Event_LeftClick
  #Property_Event_LeftDblClick
  #Property_Event_LeftDown
  #Property_Event_LeftUp
  #Property_Event_RightClick
  #Property_Event_RightDblClick
  #Property_Event_RightDown
  #Property_Event_RightUp
  #Property_Event_MouseEnter
  #Property_Event_MouseLeave
  #Property_Event_MouseMove
EndEnumeration

;- Property_Include
;{ - PropertyGadget
Structure StructurePropertyGadget
  Gadget.i
  PropertyGadget.i
  InfoGadget.i
  GadgetType.i
  StringGadget.i
  CheckBoxGadget.i
  InfoText.S
  InfoFont.i
  BackColor.i
EndStructure
Global Dim ArrayPropertyGadget.StructurePropertyGadget(0)

Procedure Property_Info_Repaint(Gadget,Text.S,Font, BackColor = 0)
  StartDrawing(CanvasOutput(Gadget))
  DrawingMode(#PB_2DDrawing_Transparent)
  Box(0, 0, OutputWidth(), OutputHeight(), 0);RGB(Random(255), Random(255), Random(255)))
  Box(1, 1, OutputWidth()-2, OutputHeight()-2, BackColor);RGB(239, 239, 239))
                                                         ;Debug ""+Str(OutputWidth())+" - "+Str(TextWidth(Text.S))
  DrawingFont(FontID(Font))
  DrawText(OutputWidth()-TextWidth(Text.S),(OutputHeight()-TextHeight(Text.S))/2-2,Text.S,0)
  StopDrawing()
EndProcedure

Procedure.S Property_GetGadgetText( Gadget )
  Protected I :For i = 0 To ArraySize(ArrayPropertyGadget())
    If ArrayPropertyGadget(i)\Gadget = Gadget
      ProcedureReturn GetGadgetText( ArrayPropertyGadget(i)\StringGadget )
    EndIf
  Next
  ProcedureReturn GetGadgetText( Gadget )
EndProcedure ;:Macro GetGadgetText( Gadget ) :Property_GetGadgetText( Gadget ) :EndMacro

Procedure Property_SetGadgetText( Gadget, Text.S )
  Protected I :For i = 0 To ArraySize(ArrayPropertyGadget())
    If ArrayPropertyGadget(i)\Gadget = Gadget
      ProcedureReturn SetGadgetText( ArrayPropertyGadget(i)\StringGadget, Text.S )
    EndIf
  Next
  ProcedureReturn SetGadgetText( Gadget, Text.S )
  EndProcedure :Macro SetGadgetText( Gadget, Text ) :Property_SetGadgetText( Gadget, Text ) :EndMacro

Procedure Property_String_Event( )
  Protected I :For i = 0 To ArraySize(ArrayPropertyGadget())
    If ArrayPropertyGadget(i)\StringGadget = EventGadget() And #PB_EventType_Change = EventType() And
       ArrayPropertyGadget(i)\StringGadget ! ArrayPropertyGadget(i)\Gadget ; Только если разные гаджеты
      
      PostEvent(#PB_Event_Gadget, EventWindow(), ArrayPropertyGadget(i)\Gadget, #PB_EventType_LeftClick)
    EndIf
  Next
EndProcedure

Procedure Property_Splitter_Event( ) ; Ok
  Protected PropertyGadget, InnerWidth, X,DX
  Static PropertySplitterGadget =-1, GadgetX, MouseX
  Select EventType()
    Case #PB_EventType_MouseEnter :SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_LeftRight)
      
    Case #PB_EventType_MouseLeave :SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Default)
    Case #PB_EventType_LeftButtonDown :PropertySplitterGadget = EventGadget() :GadgetX = WindowMouseX(EventWindow())-GadgetX(EventGadget())
    Case #PB_EventType_LeftButtonUp  
      If IsGadget(PropertySplitterGadget) 
        
        PropertySplitterGadget =-1
      EndIf
    Case #PB_EventType_MouseMove
      If IsGadget(PropertySplitterGadget) And GadgetX ! WindowMouseX(EventWindow())-GadgetX
        ResizeGadget(PropertySplitterGadget,WindowMouseX(EventWindow())-GadgetX,#PB_Ignore,#PB_Ignore,#PB_Ignore)
        
        If MouseX ! GadgetX(PropertySplitterGadget)
          X = GadgetX(PropertySplitterGadget)
          DX = GadgetX(PropertySplitterGadget) + GadgetWidth(PropertySplitterGadget)
          Protected I :For i = 0 To ArraySize(ArrayPropertyGadget())
            PropertyGadget = ArrayPropertyGadget(i)\PropertyGadget
            InnerWidth = GetGadgetAttribute( PropertyGadget, #PB_ScrollArea_InnerWidth )
            
            If PropertyGadget = GetGadgetData( PropertySplitterGadget )
              ResizeGadget(ArrayPropertyGadget(i)\InfoGadget, #PB_Ignore, #PB_Ignore, X-1, #PB_Ignore) 
              RedrawWindow_(GadgetID(ArrayPropertyGadget(i)\InfoGadget), 0, 0, #RDW_ALLCHILDREN|#RDW_UPDATENOW)
              Property_Info_Repaint(ArrayPropertyGadget(i)\InfoGadget,ArrayPropertyGadget(i)\InfoText,ArrayPropertyGadget(i)\InfoFont, ArrayPropertyGadget(i)\BackColor)
              
              If ArrayPropertyGadget(i)\GadgetType = #PB_GadgetType_Button
                ResizeGadget(ArrayPropertyGadget(i)\StringGadget, DX, #PB_Ignore, InnerWidth-Dx-18, #PB_Ignore)
                ResizeGadget(ArrayPropertyGadget(i)\Gadget, InnerWidth-18, #PB_Ignore, #PB_Ignore, #PB_Ignore)
              ElseIf ArrayPropertyGadget(i)\GadgetType = #PB_GadgetType_ButtonImage
                ResizeGadget(ArrayPropertyGadget(i)\Gadget, DX-1, #PB_Ignore, #PB_Ignore, #PB_Ignore)
                ResizeGadget(ArrayPropertyGadget(i)\StringGadget, DX+GadgetWidth(ArrayPropertyGadget(i)\Gadget)-1, #PB_Ignore, InnerWidth-(DX+GadgetWidth(ArrayPropertyGadget(i)\Gadget)), #PB_Ignore)
              Else
                ResizeGadget(ArrayPropertyGadget(i)\Gadget, DX, #PB_Ignore,(InnerWidth - DX), #PB_Ignore)
              EndIf
            EndIf
            RedrawWindow_(GadgetID(ArrayPropertyGadget(i)\Gadget), 0, 0, #RDW_ALLCHILDREN|#RDW_UPDATENOW)
          Next
          MouseX = X 
          RedrawWindow_(WindowID(EventWindow()), 0, 0, #RDW_ALLCHILDREN|#RDW_UPDATENOW)
        EndIf
        
      EndIf
  EndSelect
EndProcedure

Procedure Property_Info_Event( ) ; Ok
  Static Gadget, BackColor
  Protected I :For i = 0 To ArraySize(ArrayPropertyGadget())
    If ArrayPropertyGadget(i)\InfoGadget = EventGadget()
      Select EventType()
        Case #PB_EventType_MouseEnter 
          If BackColor = 0
            BackColor = ArrayPropertyGadget(i)\BackColor
          EndIf
          If Gadget ! EventGadget()
            Property_Info_Repaint(ArrayPropertyGadget(i)\InfoGadget,ArrayPropertyGadget(i)\InfoText,ArrayPropertyGadget(i)\InfoFont, $FFD2B6)
          EndIf
          
          If Not IsGadget(Gadget)
            SetActiveGadget(ArrayPropertyGadget(i)\Gadget)
          EndIf
          
        Case #PB_EventType_MouseLeave
          Property_Info_Repaint(ArrayPropertyGadget(i)\InfoGadget,ArrayPropertyGadget(i)\InfoText,ArrayPropertyGadget(i)\InfoFont, ArrayPropertyGadget(i)\BackColor)
          
        Case #PB_EventType_LeftButtonUp
          If Gadget ! EventGadget()
            If IsGadget(Gadget)
              Protected II :For ii = 0 To ArraySize(ArrayPropertyGadget())
                If ArrayPropertyGadget(ii)\InfoGadget = Gadget
                  ArrayPropertyGadget(ii)\BackColor = BackColor
                  Property_Info_Repaint(Gadget,ArrayPropertyGadget(ii)\InfoText,ArrayPropertyGadget(ii)\InfoFont, ArrayPropertyGadget(ii)\BackColor )
                EndIf
              Next
            EndIf
            ArrayPropertyGadget(i)\BackColor = $FFAA8B
            Property_Info_Repaint(ArrayPropertyGadget(i)\InfoGadget,ArrayPropertyGadget(i)\InfoText,ArrayPropertyGadget(i)\InfoFont, ArrayPropertyGadget(i)\BackColor )
            SetActiveGadget(ArrayPropertyGadget(i)\Gadget)
            Gadget = EventGadget()
          EndIf
      EndSelect
    EndIf
  Next
EndProcedure

Procedure Property_GadgetSize_Event( PropertyGadget, Width, Height )
  Protected Gadget, InnerWidth, X,DX
  Static PropertySplitterGadget =-1, GadgetX, MouseX
  If IsGadget( PropertyGadget )
    ResizeGadget(PropertyGadget, #PB_Ignore, #PB_Ignore, Width-GadgetX( PropertyGadget ), Height-GadgetY( PropertyGadget ))
    
    ; 
    If GetWindowLong_(GadgetID(PropertyGadget), #GWL_STYLE) & #WS_VSCROLL 
      SetGadgetAttribute(PropertyGadget, #PB_ScrollArea_InnerWidth, GadgetWidth( PropertyGadget )-19)
    Else
      SetGadgetAttribute(PropertyGadget, #PB_ScrollArea_InnerWidth, GadgetWidth( PropertyGadget )-1)
    EndIf
    
    ; 
    Protected I :For i = 0 To ArraySize(ArrayPropertyGadget())
      If ArrayPropertyGadget(i)\PropertyGadget = PropertyGadget
        InnerWidth = GetGadgetAttribute( PropertyGadget, #PB_ScrollArea_InnerWidth )
        If ArrayPropertyGadget(i)\GadgetType = #PB_GadgetType_Button
          ResizeGadget(ArrayPropertyGadget(i)\Gadget, InnerWidth-18, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ResizeGadget(ArrayPropertyGadget(i)\StringGadget, #PB_Ignore, #PB_Ignore, InnerWidth-GadgetX(ArrayPropertyGadget(i)\StringGadget)-18, #PB_Ignore)
        ElseIf ArrayPropertyGadget(i)\GadgetType = #PB_GadgetType_ButtonImage
          ResizeGadget(ArrayPropertyGadget(i)\Gadget, GadgetWidth(ArrayPropertyGadget(i)\InfoGadget)+3, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          ResizeGadget(ArrayPropertyGadget(i)\StringGadget, GadgetX(ArrayPropertyGadget(i)\Gadget) + GadgetWidth(ArrayPropertyGadget(i)\Gadget), #PB_Ignore, InnerWidth-(GadgetX(ArrayPropertyGadget(i)\StringGadget)), #PB_Ignore)
        Else
          If IsGadget(ArrayPropertyGadget(i)\Gadget)
            ResizeGadget(ArrayPropertyGadget(i)\Gadget, #PB_Ignore, #PB_Ignore, InnerWidth-GadgetX(ArrayPropertyGadget(i)\Gadget), #PB_Ignore)
          EndIf
        EndIf  
      EndIf
    Next
    RedrawWindow_(WindowID(EventWindow()), 0, 0, #RDW_ALLCHILDREN|#RDW_UPDATENOW)
    
  EndIf
EndProcedure


Procedure Property_Gadgets_Event( )
  ;     Select EventType()
  ;       Case #PB_EventType_LeftClick
  ;       Debug "EventGadget() "+Str(EventGadget())+" "+GetGadgetText(EventGadget())
  ;         SetGadgetText(EventGadget(), OpenFileRequester("",GetGadgetText(EventGadget()),"",0))
  ;     EndSelect
EndProcedure

Procedure PropertyGadget(Gadget, GadgetType, Caption.s, Text.s="", PropertyGadget =-1, X=0,Y=0,w=150,h=200,SplitterPos =70,ItemHeight=22, Flag = #PB_ScrollArea_BorderLess)
  Static Splitter =-1
  Static Property =-1
  Static Height,Width
  Static Count =0 :If PropertyGadget !-1 :Count = 0 :EndIf
  Protected GadgetID, Flags, Ot = 1
  Static I :ReDim ArrayPropertyGadget(i)
  
  If Count = 0
    Height = h
    Width = w
    ScrollAreaGadget(PropertyGadget,X,Y,Width,Height,Width-21, 0,0,Flag)
    Property = PropertyGadget
    Protected ParentID = GadgetID(Property)
    If FindWindowEx_( FindWindowEx_( ParentID, 0,0,0 ), 0,0,0 ) ; ScrollArea
      ParentID = FindWindowEx_( ParentID, 0,0,0 )
    EndIf
    SetWindowLongPtr_(ParentID, #GWL_STYLE, GetWindowLongPtr_(ParentID, #GWL_STYLE) | #WS_CLIPCHILDREN)
    SetWindowLongPtr_(ParentID, #GWL_EXSTYLE, GetWindowLongPtr_(ParentID, #GWL_EXSTYLE) | #WS_EX_COMPOSITED)
    
    Width = w-SplitterPos
    Height = ItemHeight+ot+1
    CloseGadgetList()
  EndIf
  
  If IsGadget(Property)
    OpenGadgetList(Property)
    If GadgetType & #PB_ComboBox_Editable = #PB_ComboBox_Editable
      Flags = #PB_ComboBox_Editable
    EndIf
    ;Courier Consolas
    Protected Size=(Height-19)-(Height-19)/3 -1-Ot
    Protected Font = LoadFont(#PB_Any,"Consolas",7+Size ) :X=SplitterPos+(Size*6)
    If Count = 0 :Splitter = CanvasGadget(#PB_Any, X-3, 0, 3, Height*Count+Height)
      If GetWindowLongPtr_( GadgetID( Splitter ), #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
        Define Height1 = GadgetHeight( Splitter ) 
        SetWindowLongPtr_( GadgetID( Splitter ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Splitter ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
        ResizeGadget( Splitter, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height1 )
      EndIf
      
      ;SetWindowPos_( GadgetID( Splitter ), #HWND_TOP, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      SetGadgetData(Splitter, Property)
      
      BindGadgetEvent(Splitter, @Property_Splitter_Event())
    Else
      ResizeGadget(Splitter, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height*Count+Height)
      StartDrawing(CanvasOutput(Splitter)) :Line(1, 0, 1, OutputHeight(),RGB(Random(255), Random(255), Random(255))) :StopDrawing()
      
      ResizeGadget( Property, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height*Count+Height)
      SetGadgetAttribute(Property, #PB_ScrollArea_InnerHeight, GadgetHeight(Property)+1)
    EndIf
    
    ;Protected InfoGadget = TextGadget(#PB_Any, 1, Height*Count+1+Ot, X-2-1, Height-2, Caption, #PB_Text_Right|#PB_Text_Border)
    Protected InfoGadget = CanvasGadget(#PB_Any, 1, Height*Count+1+Ot, X-2-1, Height-2);, Caption, #PB_Text_Right|#PB_Text_Border)
    
    If GadgetType & #PB_GadgetType_Spin = #PB_GadgetType_Spin
      GadgetID = SpinGadget(Gadget, X,Height*Count+Ot,Width,Height-Ot, -2000,2000, #PB_Spin_Numeric|Flags)
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SetWindowLongPtr_(GadgetID(Gadget), #GWL_STYLE, GetWindowLongPtr_(GadgetID(Gadget), #GWL_STYLE) | #ES_CENTER)
      CompilerEndIf
    ElseIf GadgetType & #PB_GadgetType_ComboBox = #PB_GadgetType_ComboBox
      GadgetID = ComboBoxGadget(Gadget, X,Height*Count+Ot,Width,Height-Ot,Flags)
    ElseIf GadgetType & #PB_GadgetType_String = #PB_GadgetType_String
      GadgetID = StringGadget(Gadget, X,Height*Count+Ot,Width,Height-Ot, Text,Flags) 
    EndIf 
    
    If Gadget =-1 :Gadget = GadgetID :EndIf
    
    If GadgetType & #PB_GadgetType_ComboBox = #PB_GadgetType_ComboBox
      Protected IC
      For IC=0 To CountString(Text,"|")
        If Trim(StringField(Text,IC+1,"|"))
          AddGadgetItem(Gadget,-1,Trim(StringField(Text,IC+1,"|")))
        EndIf
      Next
      SetGadgetState(Gadget, 0)
    EndIf
    
    SetGadgetFont(Gadget, FontID(Font)) 
    SetGadgetData(Gadget, InfoGadget)
    SetGadgetFont(InfoGadget, FontID(Font))
    
    ArrayPropertyGadget(i)\StringGadget = Gadget
    If GadgetType & #PB_GadgetType_CheckBox = #PB_GadgetType_CheckBox
      ;ResizeGadget(InfoGadget,16,#PB_Ignore,GadgetWidth(InfoGadget)-16,#PB_Ignore)
      ArrayPropertyGadget(i)\CheckBoxGadget = CheckBoxGadget(#PB_Any, 4, GadgetY(InfoGadget)+2, 15, 15, "")
      SetWindowPos_( GadgetID( ArrayPropertyGadget(i)\CheckBoxGadget ), #HWND_TOP, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      ;SetParent_(GadgetID(ArrayPropertyGadget(i)\CheckBoxGadget), GadgetID(InfoGadget))
      ArrayPropertyGadget(i)\Gadget = Gadget
    ElseIf GadgetType & #PB_GadgetType_ButtonImage = #PB_GadgetType_ButtonImage
      ResizeGadget(Gadget,X+(Height+1),#PB_Ignore,Width-(Height+1),#PB_Ignore)
      ArrayPropertyGadget(i)\Gadget = ButtonImageGadget(#PB_Any, X, GadgetY(Gadget)-1, Height+1, Height+1, 0)
      ArrayPropertyGadget(i)\GadgetType = #PB_GadgetType_ButtonImage
    ElseIf GadgetType & #PB_GadgetType_Button = #PB_GadgetType_Button
      ResizeGadget(Gadget,#PB_Ignore,#PB_Ignore,Width-Height+Height-18,#PB_Ignore)
      ArrayPropertyGadget(i)\Gadget = ButtonGadget(#PB_Any, X+GadgetWidth(Gadget), GadgetY(Gadget)-1, 19, Height+1, "...")
      ArrayPropertyGadget(i)\GadgetType = #PB_GadgetType_Button
    Else
      ArrayPropertyGadget(i)\Gadget = Gadget
    EndIf
    Protected BackColor = RGB(239, 239, 239)
    
    ArrayPropertyGadget(i)\PropertyGadget = Property
    ArrayPropertyGadget(i)\InfoGadget = InfoGadget
    ArrayPropertyGadget(i)\InfoText = Caption
    ArrayPropertyGadget(i)\InfoFont = Font
    ArrayPropertyGadget(i)\BackColor = BackColor
    
    ; BindGadgetEvent(ArrayPropertyGadget(i)\Gadget,@Property_Gadgets_Event())
    If GadgetType(Gadget) = #PB_GadgetType_Spin
      BindGadgetEvent(Gadget,@Property_Gadgets_Event(), #PB_EventType_Change)
    ElseIf GadgetType(Gadget) = #PB_GadgetType_String
      BindGadgetEvent(Gadget,@Property_String_Event(), #PB_EventType_Change)
      BindGadgetEvent(ArrayPropertyGadget(i)\Gadget,@Property_Gadgets_Event(), #PB_EventType_LeftClick)
    ElseIf GadgetType(Gadget) = #PB_GadgetType_ComboBox
      BindGadgetEvent(Gadget,@Property_Gadgets_Event(), #PB_EventType_Change)
    EndIf
    
    If IsGadget(Gadget) And GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
      Define Height1 = GadgetHeight( Gadget ) 
      SetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
      ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height1 )
    EndIf
    If IsGadget(InfoGadget) And GetWindowLongPtr_( GadgetID( InfoGadget ), #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
      Define Height1 = GadgetHeight( InfoGadget ) 
      SetWindowLongPtr_( GadgetID( InfoGadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( InfoGadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
      ResizeGadget( InfoGadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height1 )
    EndIf
    
    I+1
    ResizeGadget( InfoGadget, #PB_Ignore, #PB_Ignore, GadgetX(Splitter)-1, #PB_Ignore)
    ResizeGadget( Gadget, GadgetX(Splitter)+GadgetWidth(Splitter), #PB_Ignore, #PB_Ignore, #PB_Ignore)
    
    BindGadgetEvent(InfoGadget,@Property_Info_Event())
    Property_Info_Repaint(InfoGadget, Caption, Font, BackColor)
    
    CloseGadgetList()
  EndIf
  
  :Count = Count + 1 
  ProcedureReturn Gadget
EndProcedure
;}


Procedure Resize(Window, Gadget,X,Y,Width,Height, Steps)
  Protected StepX,StepY,GadgetX,GadgetY
  If Steps
    If IsGadget(Gadget)
      ;         GadgetX = GadgetX(Gadget)
      ;         GadgetY = GadgetY(Gadget)
      
      If GadgetX(Gadget) = X
        X = #PB_Ignore
      EndIf 
      If GadgetY(Gadget) = Y
        Y = #PB_Ignore
      EndIf 
      If GadgetWidth(Gadget) = Width
        Width = #PB_Ignore
      EndIf 
      If GadgetHeight(Gadget) = Height
        Height = #PB_Ignore
      EndIf 
    ElseIf IsWindow(Window)
      ;         GadgetX = WindowX(Window)
      ;         GadgetY = WindowY(Window)
      
      If WindowX(Window) = X
        X = #PB_Ignore
      EndIf 
      If WindowY(Window) = Y
        Y = #PB_Ignore
      EndIf 
      If WindowWidth(Window) = Width
        Width = #PB_Ignore
      EndIf 
      If WindowHeight(Window) = Height
        Height = #PB_Ignore
      EndIf 
    EndIf
    
    If X <> #PB_Ignore 
      StepX = (X % Steps) :If StepX = Steps : StepX = 0 : EndIf
      X - StepX
      If Width <> #PB_Ignore
        Width + StepX
      EndIf
    Else
      If Width <> #PB_Ignore
        Width - (Width % Steps) +1
      EndIf  
    EndIf
    If Y <> #PB_Ignore 
      StepY = (Y % Steps) :If StepY = Steps : StepY = 0 : EndIf
      Y - StepY
      If Height <> #PB_Ignore
        Height + StepY
      EndIf
    Else
      If Height <> #PB_Ignore
        Height - (Height % Steps) +1
      EndIf  
    EndIf
  EndIf 
  
  If IsGadget(Gadget)
    ResizeGadget(Gadget,X,Y,Width,Height)
  ElseIf IsWindow(Window)
    ResizeWindow(Window,X,Y,Width,Height)
  EndIf
EndProcedure


;- Property_Event
Procedure Property_Activate_Event()
  Protected Gadget = Transformation::Object() ;  Form::ActiveGadget()
  Protected Window = Gadget ; -1 ;  Form::ActiveWindow()
  
  If IsGadget( Gadget )
    SetGadgetText( #Property_Method_Enum, Str( Gadget ))
    SetGadgetState( #Property_Method_X, GadgetX( Gadget ))
    SetGadgetState( #Property_Method_Y, GadgetY( Gadget ))
    SetGadgetState( #Property_Method_Width, GadgetWidth( Gadget ))
    SetGadgetState( #Property_Method_Heght, GadgetHeight( Gadget ))
    SetGadgetText( #Property_Method_Caption, GetGadgetText( Gadget ))
    
  ElseIf IsWindow( Window )
    SetGadgetText( #Property_Method_Enum, Str( Window ))
    SetGadgetState( #Property_Method_X, WindowX( Window ))
    SetGadgetState( #Property_Method_Y, WindowY( Window ))
    SetGadgetState( #Property_Method_Width, WindowWidth( Window ))
    SetGadgetState( #Property_Method_Heght, WindowHeight( Window ))
    SetGadgetText( #Property_Method_Caption, GetWindowTitle( Window ))
    
  EndIf
EndProcedure

Procedure Property_MouseEnter_Event()
  SetActiveWindow(EventWindow())
EndProcedure

Procedure Property_MouseEnterGadget_Event()
  Debug 77
EndProcedure

Procedure Property_Deactivate_Event()
  
EndProcedure

Procedure Property_Close_Event( )
  CloseWindow( #Property )
EndProcedure 

Procedure Property_Size_Event( )
  Property_GadgetSize_Event(#Property_Method_Gadget, WindowWidth(EventWindow())-5, WindowHeight(EventWindow())-5)
EndProcedure 

Procedure Property_Gadget_Event( )
  Protected Gadget = Transformation::Object() ;  Form::ActiveGadget()
  Protected Window = Gadget ; -1 ;  Form::ActiveWindow()
  Protected Steps, Change
  ;   If IsGadget(Gadget)
  ;     Steps = Point::GetGadgetPointSize(Gadget)
  ;   ElseIf IsWindow(Window)
  ;     Steps = Point::GetWindowPointSize(Window)
  ;   EndIf
  Protected Point = Steps -1
  
  Select EventType()
    Case #PB_EventType_MouseEnter :SetActiveGadget(EventGadget())
  EndSelect
  
  Select EventGadget()
    Case #Property_Method_X,     ; "Выровнять по X"
         #Property_Method_Y,     ; "Выровнять по Y"
         #Property_Method_Width, ; "Выровнять по Width"
         #Property_Method_Heght  ; "Выровнять по Height"
      
      Select EventType()
        Case #PB_EventType_Up    :Change = #True :SetGadgetState(EventGadget(), GetGadgetState(EventGadget()) +(Point))
        Case #PB_EventType_Down  :Change = #True :SetGadgetState(EventGadget(), GetGadgetState(EventGadget()) -(Point))
      EndSelect
      
      If Change
        If IsGadget(Gadget)
          ResizeGadget( Gadget, 
                        GetGadgetState(#Property_Method_X), 
                        GetGadgetState(#Property_Method_Y),
                        GetGadgetState(#Property_Method_Width), 
                        GetGadgetState(#Property_Method_Heght))
        ElseIf IsWindow(Window)
          ResizeWindow( Window, 
                        GetGadgetState(#Property_Method_X), 
                        GetGadgetState(#Property_Method_Y),
                        GetGadgetState(#Property_Method_Width), 
                        GetGadgetState(#Property_Method_Heght))
        EndIf
        Transformation::Update(Gadget)
      EndIf
      
    Case #Property_Method_Caption ; "Изменять заголовок"
      Select EventType()
        Case #PB_EventType_Change
          If IsGadget(Gadget)
            SetGadgetText(Gadget, GetGadgetText(EventGadget()))
          ElseIf IsWindow(Window)
            SetWindowTitle(Window, GetGadgetText(EventGadget()))
          EndIf 
      EndSelect
      
    Case #Property_Method_Hide ; "Спрятать"
      Select EventType()
        Case #PB_EventType_Change
          If GetGadgetState( EventGadget() ) 
            HideWindow( Window, 1)
          Else
            HideWindow( Window, 0)
          EndIf
      EndSelect
      
    Case #Property_Method_Disable ; "Заблокировать "
      Select EventType()
        Case #PB_EventType_Change
          If GetGadgetState( EventGadget() ) 
            DisableWindow( Window, 1)
          Else
            DisableWindow( Window, 0)
          EndIf
      EndSelect
  EndSelect
  
EndProcedure


;- Property_Window
Procedure Property_Gadget( Window, Width, Height )
  PropertyGadget(#Property_Method_Any, #PB_GadgetType_ComboBox, "#PB_Any: ","#False", #Property_Method_Gadget, 5,5,200,90,60);,"#")
  PropertyGadget(#Property_Method_Enum, #PB_GadgetType_String|#PB_GadgetType_CheckBox, "ID: ")
  PropertyGadget(#Property_Method_Caption, #PB_GadgetType_String, "Text: ", "Text")
  PropertyGadget(#Property_Method_Flag, #PB_GadgetType_ComboBox, "Flag: ", "#PB_Flag_None")
  PropertyGadget(#Property_Method_Event, #PB_GadgetType_ComboBox, "Event: ", "#PB_Event_None")
  
  PropertyGadget(#Property_Method_X, #PB_GadgetType_Spin, "X: ")
  PropertyGadget(#Property_Method_Y, #PB_GadgetType_Spin, "Y: ")
  PropertyGadget(#Property_Method_Width, #PB_GadgetType_Spin, "Width: ")
  PropertyGadget(#Property_Method_Heght, #PB_GadgetType_Spin, "Height: ")
  
  PropertyGadget(#Property_Method_Hide, #PB_GadgetType_ComboBox, "Hide: ","#False|#True")
  PropertyGadget(#Property_Method_Disable, #PB_GadgetType_ComboBox, "Disable: ","#False|#True")
  PropertyGadget(#PB_Any, #PB_GadgetType_String|#PB_GadgetType_Button, "Puth: ", "C:\");,"#False|#True")
  PropertyGadget(#PB_Any, #PB_GadgetType_String|#PB_GadgetType_ButtonImage, "Icon: ")  ;,"#False|#True")
  
  BindEvent(#PB_Event_Gadget, @Property_Gadget_Event(),Window)
EndProcedure

Procedure Property_Window( Flag = #PB_Window_ScreenCentered, OwnerWindow =- 1, Width = 231, Height = 276 )
  Static Window = #Property
  Protected ParentID
  
  If IsWindow(OwnerWindow)
    ParentID = WindowID(OwnerWindow)
  EndIf
  
  If IsWindow( Window )
    If ((Flag & #PB_Window_Invisible) = #PB_Window_Invisible)
      HideWindow( Window, #True, Flag )
    Else
      If ((Flag & #PB_Window_NoActivate) = #PB_Window_NoActivate)
        CloseWindow( Window ) :Property_Window( Flag, OwnerWindow, Width, Height )
      Else
        HideWindow( Window, #False, Flag )
        SetActiveWindow(Window)
      EndIf
    EndIf
  Else
    OpenWindow( Window, 245, 144, Width, Height, "Property", #PB_Window_Invisible|#PB_Window_SizeGadget|#PB_Window_SystemMenu, ParentID )
    Property_Gadget( Window, Width, Height )
    
    ;None::Activate( Window ) ; Отключаем обработку в главном цикле
    ;BindEvent( Mouse::#PB_Event_Window, @Property_MouseEnter_Event(), Window ,Window, #PB_EventType_MouseEnter)
    ;Mouse::Activate( Window ) ; Активируем событие мыши для данного окна
    
    BindEvent( #PB_Event_ActivateWindow, @Property_Activate_Event(), Window )
    BindEvent( #PB_Event_DeactivateWindow, @Property_Deactivate_Event(), Window )
    BindEvent( #PB_Event_SizeWindow, @Property_Size_Event(), Window )
    BindEvent( #PB_Event_CloseWindow, @Property_Close_Event(), Window )
    
    ;
    If ((Flag & #PB_Window_Invisible) ! #PB_Window_Invisible)
      HideWindow( Window, #False, Flag )
    EndIf
  EndIf
  ProcedureReturn Window
EndProcedure

Runtime Procedure Property_Window_Show( OwnerWindow =- 1, Flag = #PB_Window_ScreenCentered )
  If Not Flag
    If OwnerWindow 
      Flag = #PB_Window_WindowCentered 
    Else 
      Flag = #PB_Window_ScreenCentered 
    EndIf
  EndIf
  Protected Window = Property_Window( Flag, OwnerWindow )
  
  ProcedureReturn Window
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Define Event
  Property_Window_Show( )
  
  While IsWindow( #Property )
    Event = WaitWindowEvent( )
  Wend
  
  End
CompilerEndIf

