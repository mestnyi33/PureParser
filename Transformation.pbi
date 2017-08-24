;- Include: Transformation

DeclareModule Transformation
  
  EnumerationBinary 1
    #Anchors_Position
    #Anchors_Horizontally
    #Anchors_Vertically
  EndEnumeration
  
  #Anchors_Size = #Anchors_Horizontally|#Anchors_Vertically
  #Anchors_All  = #Anchors_Position|#Anchors_Horizontally|#Anchors_Vertically
  
  Declare Disable(Gadget.i)
  Declare Enable(Gadget.i, Flags.i=#Anchors_All, Grid.i=1)
  
EndDeclareModule

Module Transformation
  EnableExplicit
  
  Structure AnChor
    Gadget.i
    ID.i[10]
    Grid.i
    Pos.i
    Size.i
  EndStructure
  
  Structure DataBuffer
    ID.i[10]
  EndStructure
  
  Global NewList AnChor.AnChor()
  
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
      EnumChildWindows_( GetAncestor_( WindowID, #GA_ROOT ), @GadgetsClipCallBack(), 0 )
    CompilerEndIf
  EndProcedure
  
  Macro MoveAnchors(This)
    ; anchors resize
    If This\ID[1] : ResizeGadget(This\ID[1], GadgetX(This\Gadget)-This\Size+This\Pos, GadgetY(This\Gadget)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[2] : ResizeGadget(This\ID[2], GadgetX(This\Gadget)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[3] : ResizeGadget(This\ID[3], GadgetX(This\Gadget)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[4] : ResizeGadget(This\ID[4], GadgetX(This\Gadget)-This\Size+This\Pos, GadgetY(This\Gadget)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[5] : ResizeGadget(This\ID[5], GadgetX(This\Gadget)+This\Size, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[6] : ResizeGadget(This\ID[6], GadgetX(This\Gadget)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[7] : ResizeGadget(This\ID[7], GadgetX(This\Gadget)-This\Size+This\Pos, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[8] : ResizeGadget(This\ID[8], GadgetX(This\Gadget)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[9] : ResizeGadget(This\ID[9], GadgetX(This\Gadget)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  EndMacro
  
  Procedure.i GridMatch(Value.i, Grid.i, Max.i=$7FFFFFFF)
    Value = Round((Value/Grid), #PB_Round_Nearest) * Grid
    If (Value>Max) : Value=Max : EndIf
    ProcedureReturn Value
  EndProcedure
  
  Procedure Callback()
    Static Selected.i, X.i, Y.i, OffsetX.i, OffsetY.i, GadgetX0.i, GadgetX1.i, GadgetY0.i, GadgetY1.i
    Protected *Anchor.AnChor = GetGadgetData(EventGadget())
    
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
          
        Case #PB_EventType_LeftButtonUp
          Selected = #False
        Case #PB_EventType_MouseMove
          If Selected
            X = WindowMouseX(GetActiveWindow())-OffsetX
            Y = WindowMouseY(GetActiveWindow())-OffsetY
            
            ; gadget resize
            Select EventGadget()
              Case \ID[1] : ResizeGadget(\Gadget, GridMatch(X+\Size, \Grid, GadgetX1), #PB_Ignore, GadgetX1-GridMatch(X+\Size, \Grid, GadgetX1), GridMatch(Y, \Grid)-GadgetY0)
              Case \ID[2] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, GridMatch(Y, \Grid)-GadgetY0)
              Case \ID[3] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, GridMatch(X, \Grid)-GadgetX0, GridMatch(Y, \Grid)-GadgetY0)
              Case \ID[4] : ResizeGadget(\Gadget, GridMatch(X+\Size, \Grid, GadgetX1), #PB_Ignore, GadgetX1-GridMatch(X+\Size, \Grid, GadgetX1), #PB_Ignore)
              Case \ID[5] : ResizeGadget(\Gadget, GridMatch(X-\Size, \Grid), GridMatch(Y+\Size, \Grid), #PB_Ignore, #PB_Ignore)
              Case \ID[6] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, GridMatch(X, \Grid)-GadgetX0, #PB_Ignore)
              Case \ID[7] : ResizeGadget(\Gadget, GridMatch(X+\Size, \Grid, GadgetX1), GridMatch(Y+\Size, \Grid, GadgetY1), GadgetX1-GridMatch(X+\Size, \Grid, GadgetX1), GadgetY1-GridMatch(Y+\Size, \Grid, GadgetY1))
              Case \ID[8] : ResizeGadget(\Gadget, #PB_Ignore, GridMatch(Y+\Size, \Grid, GadgetY1), #PB_Ignore, GadgetY1-GridMatch(Y+\Size, \Grid, GadgetY1))
              Case \ID[9] : ResizeGadget(\Gadget, #PB_Ignore, GridMatch(Y+\Size, \Grid, GadgetY1), GridMatch(X, \Grid)-GadgetX0, GadgetY1-GridMatch(Y+\Size, \Grid, GadgetY1))
            EndSelect
            
            MoveAnchors(*Anchor)
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
  
  Procedure Enable(Gadget.i, Flags.i=#Anchors_All, Grid.i=1)
    Protected ID.i, I.i
    Protected *Anchor.AnChor
    Protected *Cursors.DataBuffer = ?Cursors
    Protected *Flags.DataBuffer = ?Flags
    
    Disable(Gadget)
    
    *Anchor = AddElement(AnChor())
    *Anchor\Gadget = Gadget
    *Anchor\Grid = Grid
    *Anchor\Pos = 3
    *AnChor\Size = 5
        
    For I = 1 To 9
      If Flags & *Flags\ID[I] = *Flags\ID[I]
        If I=5
          ID = CanvasGadget(#PB_Any, 0,0, *Anchor\Size*2, *Anchor\Size)
        Else
          ID = CanvasGadget(#PB_Any, 0,0, *Anchor\Size, *Anchor\Size)
        EndIf
        
        *Anchor\ID[I] = ID
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
    
    MoveAnchors(*Anchor)
    
    ClipGadgets(GadgetID(ID))
    
    DataSection
      Cursors:
      Data.i 0, #PB_Cursor_LeftDownRightUp, #PB_Cursor_UpDown, #PB_Cursor_LeftUpRightDown, #PB_Cursor_LeftRight
      Data.i #PB_Cursor_Arrows, #PB_Cursor_LeftRight, #PB_Cursor_LeftUpRightDown, #PB_Cursor_UpDown, #PB_Cursor_LeftDownRightUp
      
      Flags:
      Data.i 0, #Anchors_Size, #Anchors_Vertically, #Anchors_Size, #Anchors_Horizontally
      Data.i #Anchors_Position, #Anchors_Horizontally, #Anchors_Size, #Anchors_Vertically, #Anchors_Size
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
    #ButtonGadget
    #TrackBarGadget
    #SpinGadget
  EndEnumeration
  
  OpenWindow(#Window, 0, 0, 600, 400, "WindowTitle", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
  EditorGadget(#EditorGadget, 50, 100, 200, 50, #PB_Editor_WordWrap) : SetGadgetText(#EditorGadget, "Grumpy wizards make toxic brew for the evil Queen and Jack.")
  ButtonGadget(#ButtonGadget, 50, 250, 200, 25, "Hallo Welt!", #PB_Button_MultiLine)
  TrackBarGadget(#TrackBarGadget, 350, 100, 200, 25, 0, 100) : SetGadgetState(#TrackBarGadget, 70)
  SpinGadget(#SpinGadget, 350, 250, 200, 25, 0, 100, #PB_Spin_Numeric) : SetGadgetState(#SpinGadget, 70)
  
  ButtonGadget(#Transformation, 20, 20, 150, 25, "Enable Transformation", #PB_Button_Toggle)
  
  Repeat
    
    Select WaitWindowEvent()
        
      Case #PB_Event_CloseWindow
        End
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Transformation
            Select GetGadgetState(#Transformation)
              Case #False
                SetGadgetText(#Transformation, "Enable Transformation")
                Disable(#EditorGadget)
                Disable(#ButtonGadget)
                Disable(#TrackBarGadget)
                Disable(#SpinGadget)
              Case #True
                SetGadgetText(#Transformation, "Disable Transformation")
                Enable(#EditorGadget, #Anchors_All, 5)
                Enable(#ButtonGadget, #Anchors_All)
                Enable(#TrackBarGadget, #Anchors_Position|#Anchors_Horizontally)
                Enable(#SpinGadget, #Anchors_Position)
            EndSelect
        EndSelect
        
    EndSelect
    
  ForEver
CompilerEndIf