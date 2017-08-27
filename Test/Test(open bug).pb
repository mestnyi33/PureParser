EnableExplicit
; FIXME
;- Include: Transformation
; http://www.purebasic.fr/english/viewtopic.php?f=12&t=64700

DeclareModule Transformation
  EnableExplicit
  
  #Arrows = 9
  
  EnumerationBinary 1
    #Anchor_Position
    #Anchor_Horizontally
    #Anchor_Vertically
  EndEnumeration
  
  #Anchor_Size = #Anchor_Horizontally|#Anchor_Vertically
  #Anchor_All  = #Anchor_Position|#Anchor_Horizontally|#Anchor_Vertically
  
  Declare Is(Gadget.i)
  Declare Object()
  Declare Update(Gadget.i)
  Declare Disable(Gadget.i)
  Declare Enable(Gadget.i, Grid.i=1, Flags.i=#Anchor_All)
  
EndDeclareModule

Module Transformation
  Structure Transformation
    Gadget.i
    ID.i[10]
    Grid.i
    Pos.i
    Size.i
  EndStructure
  
  Structure DataBuffer
    ID.i[10]
  EndStructure
  
  Global ActivateObject =- 1
  Global NewList AnChor.Transformation()
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure GadgetsClipCallBack( GadgetID, lParam )
      If GadgetID
        Protected Gadget = GetProp_( GadgetID, "PB_ID" )
        
        If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
          If IsGadget( Gadget ) 
            Select GadgetType( Gadget )
              Case #PB_GadgetType_ComboBox
                Protected Height = GadgetHeight( Gadget )
                
              Case #PB_GadgetType_Text
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) & #SS_NOTIFY) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_STYLE) | #SS_NOTIFY)
                EndIf
                
              Case #PB_GadgetType_Frame, #PB_GadgetType_Image
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
                ; Из-за бага когда устанавливаешь фоновый рисунок (например точки на кантейнер)
              Case #PB_GadgetType_Container 
                SetGadgetColor( Gadget, #PB_Gadget_BackColor, GetSysColor_( #COLOR_BTNFACE ))
                
                ; Для панел гаджета темный фон убирать
              Case #PB_GadgetType_Panel 
                If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                ; SetClassLongPtr_(GadgetID, #GCL_HBRBACKGROUND, GetStockObject_(#NULL_BRUSH))
                
            EndSelect
            
            ;             If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
            ;               SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
            ;             EndIf
          EndIf
          
          SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
          
          If Height
            ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height )
          EndIf
          
          SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
        EndIf
        
      EndIf
      
      ProcedureReturn GadgetID
    EndProcedure
  CompilerEndIf
  
  Procedure ClipGadgets( WindowID )
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      WindowID = GetAncestor_( WindowID, #GA_ROOT )
      SetWindowLongPtr_( WindowID, #GWL_STYLE, GetWindowLongPtr_( WindowID, #GWL_STYLE )|#WS_CLIPCHILDREN )
      EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
    CompilerEndIf
  EndProcedure
  
  Macro MoveTransformation(This)
    ; Transformation resize
    If This\ID[1] : ResizeGadget(This\ID[1], GadgetX(This\Gadget)-This\Size+This\Pos, GadgetY(This\Gadget)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[2] : ResizeGadget(This\ID[2], GadgetX(This\Gadget)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[3] : ResizeGadget(This\ID[3], GadgetX(This\Gadget)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[4] : ResizeGadget(This\ID[4], GadgetX(This\Gadget)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[5] : ResizeGadget(This\ID[5], GadgetX(This\Gadget)-This\Size+This\Pos, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[6] : ResizeGadget(This\ID[6], GadgetX(This\Gadget)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[7] : ResizeGadget(This\ID[7], GadgetX(This\Gadget)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[8] : ResizeGadget(This\ID[8], GadgetX(This\Gadget)-This\Size+This\Pos, GadgetY(This\Gadget)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[#Arrows] : ResizeGadget(This\ID[#Arrows], GadgetX(This\Gadget)+This\Size, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  EndMacro
  
  ;   Macro MoveTransformation(This)
  ;     ; Transformation resize
  ;     If This\ID[1] : ResizeGadget(This\ID[1], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)-This\Size+This\Pos, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[2] : ResizeGadget(This\ID[2], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[3] : ResizeGadget(This\ID[3], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[4] : ResizeGadget(This\ID[4], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[5] : ResizeGadget(This\ID[5], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)-This\Size+This\Pos, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[6] : ResizeGadget(This\ID[6], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[7] : ResizeGadget(This\ID[7], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[8] : ResizeGadget(This\ID[8], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)-This\Size+This\Pos, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  ;     If This\ID[#Arrows] : ResizeGadget(This\ID[#Arrows], GadgetX(This\Gadget, #PB_Gadget_WindowCoordinate)+This\Size, GadgetY(This\Gadget, #PB_Gadget_WindowCoordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  ;   EndMacro
  
  Procedure Object()
    ProcedureReturn ActivateObject
  EndProcedure
  
  Procedure Update(Gadget)
    ForEach AnChor()
      If AnChor()\Gadget = Gadget
        MoveTransformation(AnChor())
      EndIf
    Next
  EndProcedure
  
  Procedure Is(Gadget.i)
    Protected I
    
    If ListSize(AnChor()) 
      ForEach AnChor()
        If AnChor() = GetGadgetData(Gadget)
          For I = 1 To 9
            If AnChor()\ID[I] = Gadget
              ProcedureReturn I
            EndIf
          Next
        EndIf
      Next
    EndIf
  EndProcedure
  
  Procedure.i GridMatch(Value.i, Grid.i, Max.i=$7FFFFFFF)
    Value = Round((Value/Grid), #PB_Round_Nearest) * Grid
    If (Value>Max) : Value=Max : EndIf
    ProcedureReturn Value
  EndProcedure
  
  Procedure FormCallBack()
    Select Event()
      Case #PB_Event_ActivateWindow, #PB_Event_LeftClick
        ActivateObject = EventWindow()
    EndSelect
  EndProcedure
  
  Procedure Callback()
    Static Selected.i, X.i, Y.i, OffsetX.i, OffsetY.i, GadgetX0.i, GadgetX1.i, GadgetY0.i, GadgetY1.i
    Protected *Anchor.Transformation = GetGadgetData(EventGadget())
    
    With *Anchor
      Select EventType()
        Case #PB_EventType_LeftButtonDown
          Selected = #True
          GadgetX0 = GadgetX(\Gadget)
          GadgetY0 = GadgetY(\Gadget)
          GadgetX1 = GadgetX0 + GadgetWidth(\Gadget)
          GadgetY1 = GadgetY0 + GadgetHeight(\Gadget)
          OffsetX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
          OffsetY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
          ActivateObject = \Gadget
          
        Case #PB_EventType_LeftButtonUp
          Selected = #False
        Case #PB_EventType_MouseMove
          If Selected
            X = DesktopMouseX()-(GadgetX(\Gadget, #PB_Gadget_ScreenCoordinate)-GadgetX(\Gadget, #PB_Gadget_ContainerCoordinate))-OffsetX
            Y = DesktopMouseY()-(GadgetY(\Gadget, #PB_Gadget_ScreenCoordinate)-GadgetY(\Gadget, #PB_Gadget_ContainerCoordinate))-OffsetY
            
            ; gadget resize
            Select EventGadget()
              Case \ID[1] : ResizeGadget(\Gadget, GridMatch(X+(\Size-\Pos), \Grid, GadgetX1), #PB_Ignore, GadgetX1-GridMatch(X+(\Size-\Pos), \Grid, GadgetX1), #PB_Ignore)
              Case \ID[2] : ResizeGadget(\Gadget, #PB_Ignore, GridMatch(Y+(\Size-\Pos), \Grid, GadgetY1), #PB_Ignore, GadgetY1-GridMatch(Y+(\Size-\Pos), \Grid, GadgetY1))
              Case \ID[3] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, GridMatch(X+(\Size-\Pos), \Grid)-GadgetX0, #PB_Ignore)
              Case \ID[4] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, GridMatch(Y+(\Size-\Pos), \Grid)-GadgetY0)
              Case \ID[5] : ResizeGadget(\Gadget, GridMatch(X+(\Size-\Pos), \Grid, GadgetX1), GridMatch(Y+(\Size-\Pos), \Grid, GadgetY1), GadgetX1-GridMatch(X+(\Size-\Pos), \Grid, GadgetX1), GadgetY1-GridMatch(Y+(\Size-\Pos), \Grid, GadgetY1))
              Case \ID[6] : ResizeGadget(\Gadget, #PB_Ignore, GridMatch(Y+(\Size-\Pos), \Grid, GadgetY1), GridMatch(X+(\Size-\Pos), \Grid)-GadgetX0, GadgetY1-GridMatch(Y+(\Size-\Pos), \Grid, GadgetY1))
              Case \ID[7] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, GridMatch(X+(\Size-\Pos), \Grid)-GadgetX0, GridMatch(Y+(\Size-\Pos), \Grid)-GadgetY0)
              Case \ID[8] : ResizeGadget(\Gadget, GridMatch(X+(\Size-\Pos), \Grid, GadgetX1), #PB_Ignore, GadgetX1-GridMatch(X+(\Size-\Pos), \Grid, GadgetX1), GridMatch(Y+(\Size-\Pos), \Grid)-GadgetY0)
              Case \ID[#Arrows] : ResizeGadget(\Gadget, GridMatch(X-\Size, \Grid), GridMatch(Y+(\Size-\Pos), \Grid), #PB_Ignore, #PB_Ignore)
            EndSelect
            
            MoveTransformation(*Anchor)
            
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              UpdateWindow_(WindowID(GetActiveWindow()))
            CompilerEndIf 
          EndIf
      EndSelect
    EndWith
  EndProcedure
  
  Procedure Disable(Gadget.i)
    Protected I.i
    
    If ListSize(AnChor())
      ForEach AnChor()
        If AnChor()\Gadget = Gadget
          For I = 1 To 9
            If AnChor()\ID[I]
              FreeGadget(AnChor()\ID[I])
            EndIf
          Next
          
          DeleteElement(AnChor())
        EndIf
      Next
    EndIf
    
  EndProcedure
  
  Procedure Enable(Gadget.i, Grid.i=1, Flags.i=#Anchor_All)
    Protected ID.i, I.i
    Protected *Anchor.Transformation
    Protected *Cursors.DataBuffer = ?Cursors
    Protected *Flags.DataBuffer = ?Flags
    
    Disable(Gadget)
    
    *Anchor = AddElement(AnChor())
    
    With *AnChor
      \Gadget = Gadget
      \Grid = Grid
      \Pos = 3
      \Size = 6
      
      For I = 1 To 9
        If Flags & *Flags\ID[I] = *Flags\ID[I]
          If (I=#Arrows)
            ID = CanvasGadget(#PB_Any, 0,0, \Size*2, \Size) 
          Else
            ID = CanvasGadget(#PB_Any, 0,0, \Size, \Size)
          EndIf
          
          \ID[I] = ID
          SetGadgetData(ID, *Anchor)
          SetGadgetAttribute(ID, #PB_Canvas_Cursor, *Cursors\ID[I])
          
          If StartDrawing(CanvasOutput(ID))
            Box(0, 0, OutputWidth(), OutputHeight(), $000000)
            Box(1, 1, OutputWidth()-2, OutputHeight()-2, $FFFFFF)
            StopDrawing()
          EndIf
          
          BindGadgetEvent(ID, @Callback())
        EndIf
      Next
      
      MoveTransformation(*Anchor)
      ClipGadgets(UseGadgetList(0))
      
      UnbindEvent(#PB_Event_ActivateWindow, @FormCallBack())
      BindEvent(#PB_Event_ActivateWindow, @FormCallBack())
      UnbindEvent(#PB_Event_LeftClick, @FormCallBack())
      BindEvent(#PB_Event_LeftClick, @FormCallBack())
      
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        UpdateWindow_(UseGadgetList(0))
      CompilerEndIf 
    EndWith
    
    DataSection
      Cursors:
      Data.i 0
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_Arrows
      
      Flags:
      Data.i 0
      Data.i #Anchor_Horizontally
      Data.i #Anchor_Vertically
      Data.i #Anchor_Horizontally
      Data.i #Anchor_Vertically
      Data.i #Anchor_Size
      Data.i #Anchor_Size
      Data.i #Anchor_Size
      Data.i #Anchor_Size
      Data.i #Anchor_Position
    EndDataSection
  EndProcedure
  
EndModule



Procedure OpenPBObject(Type$, X=0,Y=0,Width=0,Height=0, Flag=0, Caption$="", Param1=0, Param2=0, Param3=0)
  Protected ID=-1
  Static ParentID, Parent=-1
  
  Select Type$
    Case "OpenWindow"          : ID = OpenWindow          (#PB_Any, X,Y,Width,Height, Caption$, Flag|#PB_Window_SizeGadget) 
    Case "ButtonGadget"        : ID = ButtonGadget        (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "StringGadget"        : ID = StringGadget        (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "TextGadget"          : ID = TextGadget          (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "CheckBoxGadget"      : ID = CheckBoxGadget      (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "OptionGadget"        : ID = OptionGadget        (#PB_Any, X,Y,Width,Height, Caption$)
    Case "ListViewGadget"      : ID = ListViewGadget      (#PB_Any, X,Y,Width,Height, Flag)
    Case "FrameGadget"         : ID = FrameGadget         (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ComboBoxGadget"      : ID = ComboBoxGadget      (#PB_Any, X,Y,Width,Height, Flag)
    Case "ImageGadget"         : ID = ImageGadget         (#PB_Any, X,Y,Width,Height, Param1,Flag)
    Case "HyperLinkGadget"     : ID = HyperLinkGadget     (#PB_Any, X,Y,Width,Height, Caption$,Param1,Flag)
    Case "ContainerGadget"     : ID = ContainerGadget     (#PB_Any, X,Y,Width,Height, Flag)
    Case "ListIconGadget"      : ID = ListIconGadget      (#PB_Any, X,Y,Width,Height, Caption$, Param1, Flag)
    Case "IPAddressGadget"     : ID = IPAddressGadget     (#PB_Any, X,Y,Width,Height)
    Case "ProgressBarGadget"   : ID = ProgressBarGadget   (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "ScrollBarGadget"     : ID = ScrollBarGadget     (#PB_Any, X,Y,Width,Height, Param1, Param2, Param3, Flag)
    Case "ScrollAreaGadget"    : ID = ScrollAreaGadget    (#PB_Any, X,Y,Width,Height, Param1, Param2, Param3, Flag) 
    Case "TrackBarGadget"      : ID = TrackBarGadget      (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "WebGadget"           : ID = WebGadget           (#PB_Any, X,Y,Width,Height, Caption$)
    Case "ButtonImageGadget"   : ID = ButtonImageGadget   (#PB_Any, X,Y,Width,Height, Param1, Flag)
    Case "CalendarGadget"      : ID = CalendarGadget      (#PB_Any, X,Y,Width,Height, Param1, Flag)
    Case "DateGadget"          : ID = DateGadget          (#PB_Any, X,Y,Width,Height, Caption$, Param1, Flag)
    Case "EditorGadget"        : ID = EditorGadget        (#PB_Any, X,Y,Width,Height, Flag)
    Case "ExplorerListGadget"  : ID = ExplorerListGadget  (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ExplorerTreeGadget"  : ID = ExplorerTreeGadget  (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ExplorerComboGadget" : ID = ExplorerComboGadget (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "SpinGadget"          : ID = SpinGadget          (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "TreeGadget"          : ID = TreeGadget          (#PB_Any, X,Y,Width,Height, Flag)
    Case "PanelGadget"         : ID = PanelGadget         (#PB_Any, X,Y,Width,Height) 
    Case "SplitterGadget"      
      If IsGadget(Param1) And IsGadget(Param2)
        ID = SplitterGadget      (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
      EndIf
    Case "MDIGadget"          
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ID = MDIGadget           (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag) 
      CompilerEndIf
    Case "ScintillaGadget"     : ID = ScintillaGadget     (#PB_Any, X,Y,Width,Height, Param1)
    Case "ShortcutGadget"      : ID = ShortcutGadget      (#PB_Any, X,Y,Width,Height, Param1)
    Case "CanvasGadget"        : ID = CanvasGadget        (#PB_Any, X,Y,Width,Height, Flag)
  EndSelect
  
  Select Type$
    Case "OpenWindow"          
      Parent = ID
      ParentID = WindowID(ID)
      Debug "w - "+ID
      
    Case "ContainerGadget", "ScrollAreaGadget", "PanelGadget"
      SetGadgetData(ID, Parent)
      Parent = ID
      ParentID = GadgetID(ID)
      Debug "g - "+ID
      
    Case "UseGadgetList"       : UseGadgetList( ParentID )
    Case "CloseGadgetList"     
      Debug 99999
      CloseGadgetList() 
      Parent = GetGadgetData(Parent)
    Case "AddGadgetItem"       : AddGadgetItem( Parent, #PB_Any, Caption$, Param1, Flag)
    Case "OpenGadgetList"      : OpenGadgetList( Parent, Param1 )
  EndSelect
  
  
  If IsGadget(ID)
    Protected OpenList, GetParent = GetGadgetData(Parent)
    
    If ID = Parent
      If IsWindow(GetParent)
        CloseGadgetList() ; Bug PB
        UseGadgetList(WindowID(GetParent))
      EndIf
      If IsGadget(GetParent) 
        OpenList = OpenGadgetList(GetParent) 
      EndIf
    EndIf
    
    Transformation::Enable(ID, 5)
    
    If ID = Parent
      If IsWindow(GetParent) 
        OpenGadgetList(ID) 
      EndIf
      If OpenList 
        CloseGadgetList() 
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn ID
EndProcedure

; test 2
Define Window_0 = OpenPBObject("OpenWindow", 330, 100, 595, 395, #PB_Window_SystemMenu, "")

OpenPBObject("ContainerGadget", 10, 10, 275, 235, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor", #PB_Gadget_BackColor,RGB(192,192,192))
OpenPBObject("ButtonGadget", 5, 5, 90, 40, 0, "Button_0")
OpenPBObject("ButtonGadget", 5, 50, 90, 40, 0, "Button_1")
OpenPBObject("SpinGadget", 190, 5, 80, 30, 0, "", 0, 0)
OpenPBObject("SpinGadget", 190, 40, 80, 30, 0, "", 0, 0)
OpenPBObject("SpinGadget", 190, 75, 80, 30, 0, "", 0, 0)
OpenPBObject("CloseGadgetList")

OpenPBObject("ContainerGadget", 290, 10, 300, 235, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor", #PB_Gadget_BackColor,RGB(64,128,128))
OpenPBObject("OptionGadget", 10, 10, 80, 15, 0, "Опция 1")
OpenPBObject("OptionGadget", 10, 35, 65, 15, 0, "Опция 2")
OpenPBObject("OptionGadget", 10, 60, 65, 20, 0, "Опция 3")
OpenPBObject("ContainerGadget", 130, 10, 160, 215, #PB_Container_Single)
;   OpenPBObject("SetGadgetColor", #PB_Gadget_BackColor,RGB(255,128,255))
OpenPBObject("TextGadget", 5, 5, 65, 20, 0, "Текст")
OpenPBObject("StringGadget", 75, 5, 75, 20, 0, "")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")

OpenPBObject("ContainerGadget", 10, 250, 580, 140, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_3, #PB_Gadget_BackColor,RGB(128,128,64))
OpenPBObject("ContainerGadget", 130, 5, 445, 130, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_4, #PB_Gadget_BackColor,RGB(255,128,0))
OpenPBObject("ButtonGadget", 5, 5, 105, 120, 0, "Уровень 2")
OpenPBObject("ContainerGadget", 115, 5, 325, 120, #PB_Container_Flat)
OpenPBObject("ButtonGadget", 5, 5, 95, 110, 0, "Уровень 3")
OpenPBObject("ContainerGadget", 105, 5, 215, 110, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_6, #PB_Gadget_BackColor,RGB(0,0,255))
OpenPBObject("ButtonGadget", 5, 5, 90, 100, 0, "Уровень 4")
OpenPBObject("ContainerGadget", 100, 5, 110, 100, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_7, #PB_Gadget_BackColor,RGB(255,255,255))
OpenPBObject("ButtonGadget", 5, 5, 100, 40, 0, "Уровень 5")
OpenPBObject("TextGadget", 5, 50, 100, 20, 0, "Текст у5 1")
OpenPBObject("TextGadget", 5, 75, 100, 20, 0, "Текст у5 2")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("ButtonGadget", 5, 5, 120, 130, 0, "Уровень 1")
OpenPBObject("CloseGadgetList")

; OpenPBObject("ContainerGadget", 10, 10, 275, 235, #PB_Container_Flat)
; OpenPBObject("CloseGadgetList")
; 
; OpenPBObject("ContainerGadget", 290, 10, 300, 235, #PB_Container_Flat)
; OpenPBObject("ContainerGadget", 130, 10, 160, 215, #PB_Container_Single)
; OpenPBObject("CloseGadgetList")
; OpenPBObject("CloseGadgetList")
; 
; 
; OpenPBObject("ContainerGadget", 10, 250, 580, 140, #PB_Container_Flat)
; OpenPBObject("CloseGadgetList")

While IsWindow( Window_0 )
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow 
      CloseWindow( EventWindow() )
  EndSelect
Wend