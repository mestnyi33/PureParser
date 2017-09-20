﻿;- Include: Transformation
; http://www.purebasic.fr/english/viewtopic.php?f=12&t=64700

DeclareModule Transformation
  EnableExplicit
  
  #Alles = 9
  #Arrows = 9
  
  EnumerationBinary 1
    #Anchor_Position
    #Anchor_Horizontally
    #Anchor_Vertically
  EndEnumeration
  
  #Anchor_Size = #Anchor_Horizontally|#Anchor_Vertically
  #Anchor_All  = #Anchor_Position|#Anchor_Horizontally|#Anchor_Vertically
  
  Declare Count()
  Declare Object()
  Declare Get(Index.i)
  Declare Is(Gadget.i)
  Declare Update(Gadget.i)
  Declare Disable(Gadget.i)
  Declare Enable(Gadget.i, Grid.i=1, Flags.i=#Anchor_All, Parent=-1)
  
EndDeclareModule

Module Transformation
  Structure DataBuffer
    ID.i[10]
  EndStructure
  
  Structure Transformation Extends DataBuffer
    Gadget.i
    Grid.i
    Pos.i
    Size.i
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
                
              Case #PB_GadgetType_Frame; , #PB_GadgetType_Image
                If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
                ; Из-за бага когда устанавливаешь фоновый рисунок (например точки на кантейнер)
              Case #PB_GadgetType_Container 
                ; SetGadgetColor( Gadget, #PB_Gadget_BackColor, GetSysColor_( #COLOR_BTNFACE ))
                
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
    If This\ID[#Arrows] : ResizeGadget(This\ID[#Arrows], GadgetX(This\Gadget)+This\Size+This\Pos, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
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
  
  Procedure Get(Index.i)
    ProcedureReturn AnChor()\ID[Index]
  EndProcedure
  
  Procedure Count()
    ProcedureReturn #Alles
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
         For I = 1 To #Alles
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
          For I = 1 To #Alles
            If AnChor()\ID[I]
              FreeGadget(AnChor()\ID[I])
            EndIf
          Next
          
          DeleteElement(AnChor())
        EndIf
      Next
    EndIf
    
  EndProcedure
  
  Procedure Enable(Gadget.i, Grid.i=1, Flags.i=#Anchor_All, Parent=-1)
    Protected ID.i, I.i
    Protected *Anchor.Transformation
    Protected *Cursors.DataBuffer = ?Cursors
    Protected *Flags.DataBuffer = ?Flags
    
    If IsGadget(Gadget)
      Disable(Gadget)
      
      *Anchor = AddElement(AnChor())
      
      With *AnChor
        \Gadget = Gadget
        \Grid = Grid
        If IsGadget(Parent)
          \Pos = 10
        Else
          \Pos = 3
        EndIf
        \Size = 6
        
        For I = 1 To #Alles
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
        
        If IsGadget(Parent)
          For I=1 To #Alles
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              SetParent_(GadgetID(\ID[I]), GadgetID(Parent))
            CompilerEndIf 
          Next
        EndIf
      EndWith
    EndIf
    
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



;- Example
CompilerIf #PB_Compiler_IsMainFile
  UseModule Transformation
  
  Enumeration
    #Window
    #Transformation
    #EditorGadget
    #ContainerGadget
    #ContainerGadget2
    #ButtonGadget
    #TrackBarGadget
    #SpinGadget
    #CanvasGadget
  EndEnumeration
  
  Global Gadget =- 1
  
  Procedure OpenWindow_0()
    OpenWindow(#Window, 0, 0, 600, 400, "WindowTitle", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
    EditorGadget(#EditorGadget, 50, 100, 200, 50, #PB_Editor_WordWrap) : SetGadgetText(#EditorGadget, "Grumpy wizards make toxic brew for the evil Queen and Jack.")
    
    ContainerGadget(#ContainerGadget, 50, 250, 200, 125, #PB_Container_Flat)
    ContainerGadget(#ContainerGadget2, 10, 10, 200, 125, #PB_Container_Flat)
    ButtonGadget(#ButtonGadget, 10, 10, 200, 25, "Hallo Welt!", #PB_Button_MultiLine)
    CloseGadgetList()
    CloseGadgetList()
    
    TrackBarGadget(#TrackBarGadget, 350, 100, 200, 25, 0, 100) : SetGadgetState(#TrackBarGadget, 70)
    SpinGadget(#SpinGadget, 350, 180, 200, 25, 0, 100, #PB_Spin_Numeric) : SetGadgetState(#SpinGadget, 70)
    CanvasGadget(#CanvasGadget, 350, 250, 200, 25)
    
    ButtonGadget(#Transformation, 20, 20, 150, 25, "Enable Transformation", #PB_Button_Toggle)
    SetGadgetData(#CanvasGadget, 999)
  EndProcedure
  
  OpenWindow_0()
  ;OpenGadgetList(#ContainerGadget)
  Repeat
    
    Select WaitWindowEvent()
        
      Case #PB_Event_CloseWindow
        End
        
      Case #PB_Event_Repaint
        
      Case #PB_Event_Gadget
        Select EventType()
          Case #PB_EventType_LeftButtonDown
            Debug "Is anchor "+Is(EventGadget())+" "+Object()
            Gadget = EventGadget()
            Define OffsetX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
            Define OffsetY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
          Case #PB_EventType_LeftButtonUp
            Gadget =- 1
          Case #PB_EventType_MouseMove
            If IsGadget(Gadget) And Not Is(Gadget)
              Define X = DesktopMouseX()-(GadgetX(Gadget, #PB_Gadget_ScreenCoordinate)-GadgetX(Gadget, #PB_Gadget_WindowCoordinate))-OffsetX
              Define Y = DesktopMouseY()-(GadgetY(Gadget, #PB_Gadget_ScreenCoordinate)-GadgetY(Gadget, #PB_Gadget_WindowCoordinate))-OffsetY
              ResizeGadget(Gadget,X,Y,#PB_Ignore,#PB_Ignore)
              Update(Gadget)
            EndIf               
        EndSelect
        
        Select EventGadget()
          Case #Transformation
            Select GetGadgetState(#Transformation)
              Case #False
                SetGadgetText(#Transformation, "Enable Transformation")
                Disable(#EditorGadget)
                Disable(#ButtonGadget)
                Disable(#TrackBarGadget)
                Disable(#SpinGadget)
                Disable(#CanvasGadget)
                Disable(#ContainerGadget)
                Disable(#ContainerGadget2)
              Case #True
                SetGadgetText(#Transformation, "Disable Transformation")
                ; Enable(#Window, 5, #Anchor_Position)
                Enable(#EditorGadget, 5, #Anchor_All)
                OpenGadgetList(#ContainerGadget2)
                  Enable(#ButtonGadget, 1, #Anchor_All)
                CloseGadgetList()
                Enable(#TrackBarGadget, 1, #Anchor_Position|#Anchor_Horizontally)
                Enable(#SpinGadget, 1, #Anchor_Position)
                Enable(#CanvasGadget, 1, #Anchor_All)
                Enable(#ContainerGadget, 1, #Anchor_All)
                OpenGadgetList(#ContainerGadget)
                  Enable(#ContainerGadget2, 10, #Anchor_All)
                CloseGadgetList()
            EndSelect
        EndSelect
        
    EndSelect
    
  ForEver
CompilerEndIf