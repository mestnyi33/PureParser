;- Include: Transformation
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
  ;Declare Object()
  Declare Is(Gadget.i)
  Declare Update(Gadget.i)
  Declare Disable(Gadget.i)
  Declare Enable(Gadget.i, Grid.i=1, Flags.i=#Anchor_All, Parent=-1, Item=0)
  
EndDeclareModule

Module Transformation
  Structure DataBuffer
    ID.i[#Alles+1]
  EndStructure
  
  Structure Transformation Extends DataBuffer
    Window.i
    Gadget.i
    Parent.i
    Item.i
    
    Grid.i
    Pos.i
    Size.i
  EndStructure
  
  Global ActivateObject =- 1
  Global NewMap Index.i()
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
  
  Macro Clip(Gadget)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Define ___ClipMacroGadgetHeight___ = GadgetHeight( Gadget )
        SetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( Gadget ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
        If ___ClipMacroGadgetHeight___ And GadgetType( Gadget ) = #PB_GadgetType_ComboBox
          ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, ___ClipMacroGadgetHeight___ )
        EndIf
        SetWindowPos_( GadgetID( Gadget ), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    CompilerEndSelect
  EndMacro
  
  Macro Move(This, Coordinate=#PB_Gadget_ContainerCoordinate)
    ; Transformation resize
    If This\ID[1] : ResizeGadget(This\ID[1], GadgetX(This\Gadget, Coordinate)-This\Size+This\Pos, GadgetY(This\Gadget, Coordinate)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[2] : ResizeGadget(This\ID[2], GadgetX(This\Gadget, Coordinate)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[3] : ResizeGadget(This\ID[3], GadgetX(This\Gadget, Coordinate)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget, Coordinate)+(GadgetHeight(This\Gadget)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[4] : ResizeGadget(This\ID[4], GadgetX(This\Gadget, Coordinate)+(GadgetWidth(This\Gadget)-This\Size)/2, GadgetY(This\Gadget, Coordinate)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[5] : ResizeGadget(This\ID[5], GadgetX(This\Gadget, Coordinate)-This\Size+This\Pos, GadgetY(This\Gadget, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[6] : ResizeGadget(This\ID[6], GadgetX(This\Gadget, Coordinate)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[7] : ResizeGadget(This\ID[7], GadgetX(This\Gadget, Coordinate)+GadgetWidth(This\Gadget)-This\Pos, GadgetY(This\Gadget, Coordinate)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[8] : ResizeGadget(This\ID[8], GadgetX(This\Gadget, Coordinate)-This\Size+This\Pos, GadgetY(This\Gadget, Coordinate)+GadgetHeight(This\Gadget)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    If This\ID[#Arrows] : ResizeGadget(This\ID[#Arrows], GadgetX(This\Gadget, Coordinate)+This\Size, GadgetY(This\Gadget, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  EndMacro
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    Value = Round((Value/Grid), #PB_Round_Nearest) * Grid
    If (Value>Max) : Value=Max : EndIf
    ProcedureReturn Value
  EndProcedure
  
  Procedure Is(Gadget.i)
    ProcedureReturn Index(Str(Gadget))
  EndProcedure
  
  Procedure Count() ; 
    ProcedureReturn #Alles
  EndProcedure
  
  Procedure Object()
    ProcedureReturn ActivateObject
  EndProcedure
  
  Procedure Update(Gadget.i)
    If ListSize(AnChor()) 
      ForEach AnChor()
        If AnChor()\Gadget = Gadget
          Move(AnChor())
        EndIf
      Next
    EndIf
  EndProcedure
  
  
  Procedure VerticalLineGadget(Gadget, x, y1, y2, Size, Color=#PB_Default)
    Protected Result
    
    Protected y, Height
    
    If y1<y2
      y=y1
      Height=y2-y1
    Else
      y=y2
      Height=y1-y2
    EndIf
    
    Size=1
    Result = ContainerGadget(Gadget, x,y,Size, Height)
    If Result
      CloseGadgetList()
      
      If Gadget=#PB_Any
        Gadget=Result
      EndIf
      
      SetGadgetColor(Gadget, #PB_Gadget_BackColor, Color)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  Procedure HorisontalLineGadget(Gadget, x1, x2, y, Size, Color=#PB_Default)
    Protected Result
    
    Protected x, Width
    
    If x1<x2
      x=x1
      Width=x2-x1
    Else
      x=x2
      Width=x1-x2
    EndIf
    
    Size=1
    Result = ContainerGadget(Gadget, x, y, Width, Size)
    If Result
      CloseGadgetList()
      
      If Gadget=#PB_Any
        Gadget=Result
      EndIf
      
      SetGadgetColor(Gadget, #PB_Gadget_BackColor, Color)
    EndIf
    
    ProcedureReturn Result
  EndProcedure
  
  
  
  Procedure Lines(Gadget.i, Parent.i, Item.i, change.b=0)
    Protected ls=1
    
    Static left_in=-1, right_in=-1, top_in=-1, bottom_in=-1
    Static left_gadget=-1,right_gadget=-1,top_gadget=-1,bottom_gadget=-1
    
    Static CrossLeft_in=-1, CrossRight_in=-1, CrossTop_in=-1, CrossBottom_in=-1
    Static Crossleft_gadget=-1,Crossright_gadget=-1,Crosstop_gadget=-1,Crossbottom_gadget=-1
    
    Protected top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    With AnChor()
      If IsGadget(Gadget)
        checked_x1 = GadgetX(Gadget)
        checked_y1 = GadgetY(Gadget)
        checked_x2 = checked_x1+GadgetWidth(Gadget)
        checked_y2 = checked_y1+GadgetHeight(Gadget)
        
        If change=0
          Static left_x1, left_x2, top_y1, top_y2
          If left_x1<>checked_x1 : left_x1=checked_x1 : change=1 : EndIf
          If left_x2<>checked_x2 : left_x2=checked_x2 : change=2 : EndIf
          If top_y1<>checked_y1 : top_y1=checked_y1 : change=3 : EndIf
          If top_y2<>checked_y2 : top_y2=checked_y2 : change=4 : EndIf
        EndIf
        
        If change 
          top_x1 = checked_x1 : top_x2 = checked_x2 : bottom_x1 = checked_x1 : bottom_x2 = checked_x2
          left_y1 = checked_y1 : left_y2 = checked_y2 : right_y1 = checked_y1 : right_y2 = checked_y2
          
          PushListPosition(AnChor())
          
          ForEach AnChor()
            If Bool(\Gadget <> Gadget And \Parent = Parent And \Item = Item)   
              relative_x1 = GadgetX(\Gadget)
              relative_y1 = GadgetY(\Gadget)
              relative_x2 = relative_x1+GadgetWidth(\Gadget)
              relative_y2 = relative_y1+GadgetHeight(\Gadget)
              
              ;Left
              If checked_x1 = relative_x1
                If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
                If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
                
                
                
                If IsGadget(left_gadget)
                  ResizeGadget(left_gadget, checked_x1,left_y1,ls,left_y2-left_y1)
                Else
                  left_in = \Gadget
                  ;left_gadget = TextGadget(#PB_Any, checked_x1,left_y1,ls,left_y2-left_y1,"")
                  left_gadget = VerticalLineGadget(#PB_Any, checked_x1, left_y1, left_y2, ls, $0000FF)
                  Clip(left_gadget)
                EndIf
              ElseIf checked_y1 <> relative_y1
                If left_in = \Gadget
                  If IsGadget(left_gadget) : FreeGadget(left_gadget) : EndIf
                  left_in =- 1
                EndIf
              EndIf
              
              ;Right
              If checked_x2 = relative_x2
                If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
                If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
                
                If IsGadget(right_gadget)
                  ResizeGadget(right_gadget, checked_x2-ls, right_y1, ls, right_y2-right_y1)
                Else
                  right_in = \Gadget
                  ;right_gadget = TextGadget(#PB_Any, checked_x2-ls, right_y1, ls, right_y2-right_y1,"") 
                  right_gadget = VerticalLineGadget(#PB_Any, checked_x2-ls, right_y1, right_y2, ls, $0000FF)
                  Clip(right_gadget)
                EndIf
              ElseIf checked_y2 <> relative_y2 
                If right_in = \Gadget
                  If IsGadget(right_gadget) : FreeGadget(right_gadget) : EndIf
                  right_in =- 1
                EndIf
              EndIf
              
              ;Top
              If checked_y1 = relative_y1 
                If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
                If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
                
                If IsGadget(top_gadget)
                  ResizeGadget(top_gadget, top_x1, checked_y1, top_x2-top_x1,ls)
                Else
                  top_in = \Gadget
                  ;top_gadget = TextGadget(#PB_Any, top_x1, checked_y1, top_x2-top_x1,ls,"")
                  top_gadget = HorisontalLineGadget(#PB_Any, top_x1, top_x2, checked_y1, ls, $FF0000)
                  Clip(top_gadget)
                EndIf
              ElseIf checked_x1 <> relative_x1
                If top_in = \Gadget
                  If IsGadget(top_gadget) : FreeGadget(top_gadget) : EndIf
                  top_in =- 1
                EndIf
              EndIf
              
              ;Bottom
              If checked_y2 = relative_y2 
                If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
                If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
                
                If IsGadget(bottom_gadget)
                  ResizeGadget(bottom_gadget, bottom_x1, checked_y2-ls, bottom_x2-bottom_x1,ls)
                Else
                  bottom_in = \Gadget
                  ;bottom_gadget = TextGadget(#PB_Any, bottom_x1, checked_y2-ls, bottom_x2-bottom_x1,ls,"")
                  bottom_gadget = HorisontalLineGadget(#PB_Any, bottom_x1, bottom_x2, checked_y2-ls, ls, $FF0000)
                  Clip(bottom_gadget)
                EndIf
              ElseIf checked_x2 <> relative_x2
                If bottom_in = \Gadget
                  If IsGadget(bottom_gadget) : FreeGadget(bottom_gadget) : EndIf
                  bottom_in =- 1
                EndIf
              EndIf
              
              

              
              ;CrossLeft
              If checked_x1 = relative_x2+5
                If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
                If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
                
                If IsGadget(Crossleft_gadget)
                  ResizeGadget(Crossleft_gadget, checked_x1,left_y1,ls,left_y2-left_y1)
                Else
                  CrossLeft_in = \Gadget
                  ;Crossleft_gadget = TextGadget(#PB_Any, checked_x1,left_y1,ls,left_y2-left_y1,"")
                  Crossleft_gadget = VerticalLineGadget(#PB_Any, checked_x1, left_y1, left_y2, ls, $0094FE)
                  Clip(Crossleft_gadget)
                EndIf
              ElseIf checked_y1 <> relative_y1
                If CrossLeft_in = \Gadget
                  If IsGadget(Crossleft_gadget) : FreeGadget(Crossleft_gadget) : EndIf
                  CrossLeft_in =- 1
                EndIf
              EndIf
              
              ;CrossRight
              If checked_x2 = relative_x1-5
                If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
                If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
                
                If IsGadget(Crossright_gadget)
                  ResizeGadget(Crossright_gadget, checked_x2-ls, right_y1, ls, right_y2-right_y1)
                Else
                  CrossRight_in = \Gadget
                  ;Crossright_gadget = TextGadget(#PB_Any, checked_x2-ls, right_y1, ls, right_y2-right_y1,"")
                  Crossright_gadget = VerticalLineGadget(#PB_Any, checked_x2-ls, right_y1, right_y2, ls, $0094FE)
                  Clip(Crossright_gadget)
                EndIf
              ElseIf checked_y2 <> relative_y2 
                If CrossRight_in = \Gadget
                  If IsGadget(Crossright_gadget) : FreeGadget(Crossright_gadget) : EndIf
                  CrossRight_in =- 1
                EndIf
              EndIf
              
              ;CrossTop
              If checked_y1 = relative_y2+5
                If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
                If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
                
                If IsGadget(Crosstop_gadget)
                  ResizeGadget(Crosstop_gadget, top_x1, checked_y1, top_x2-top_x1,ls)
                Else
                  CrossTop_in = \Gadget
                  ;Crosstop_gadget = TextGadget(#PB_Any, top_x1, checked_y1, top_x2-top_x1,ls,"")
                  Crosstop_gadget = HorisontalLineGadget(#PB_Any, top_x1, top_x2, checked_y1, ls, $FE00E1)
                  Clip(Crosstop_gadget)
                EndIf
              ElseIf checked_x1 <> relative_x1
                If CrossTop_in = \Gadget
                  If IsGadget(Crosstop_gadget) : FreeGadget(Crosstop_gadget) : EndIf
                  CrossTop_in =- 1
                EndIf
              EndIf
              
              ;CrossBottom
              If checked_y2 = relative_y1-5
                If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
                If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
                
                If IsGadget(Crossbottom_gadget)
                  ResizeGadget(Crossbottom_gadget, bottom_x1, checked_y2-ls, bottom_x2-bottom_x1,ls)
                Else
                  CrossBottom_in = \Gadget
                  ;Crossbottom_gadget = TextGadget(#PB_Any, bottom_x1, checked_y2-ls, bottom_x2-bottom_x1,ls,"")
                  Crossbottom_gadget = HorisontalLineGadget(#PB_Any, bottom_x1, bottom_x2, checked_y2-ls, ls, $FE00E1)
                  Clip(Crossbottom_gadget)
                EndIf
              ElseIf checked_x2 <> relative_x2
                If CrossBottom_in = \Gadget
                  If IsGadget(Crossbottom_gadget) : FreeGadget(Crossbottom_gadget) : EndIf
                  CrossBottom_in =- 1
                EndIf
              EndIf
              
              
              
              
              
              
            EndIf
          Next
          
          PopListPosition(AnChor())
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  
Procedure Callback()
    
    Select Event()
      Case #PB_Event_ActivateWindow, #PB_Event_LeftClick
        ActivateObject = EventWindow()
        
      Case #PB_Event_Gadget
        Static Selected.i, X.i, Y.i, OffsetX.i, OffsetY.i, GadgetX0.i, GadgetX1.i, GadgetY0.i, GadgetY1.i
        Protected iX=#PB_Ignore,iY=#PB_Ignore,iWidth=#PB_Ignore,iHeight=#PB_Ignore, *AnChor.Transformation = GetGadgetData(EventGadget())
        
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
                
                ;             Static tt
                ;             Protected t=ElapsedMilliseconds()
        ;                 ; gadget resize
;                 Select EventGadget()
;                   Case \ID[1] : ResizeGadget(\Gadget, Match(X+(\Size-\Pos), \Grid, GadgetX1), #PB_Ignore, GadgetX1-Match(X+(\Size-\Pos), \Grid, GadgetX1), #PB_Ignore)
;                   Case \ID[2] : ResizeGadget(\Gadget, #PB_Ignore, Match(Y+(\Size-\Pos), \Grid, GadgetY1), #PB_Ignore, GadgetY1-Match(Y+(\Size-\Pos), \Grid, GadgetY1))
;                   Case \ID[3] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, Match(X+\Pos, \Grid)-GadgetX0, #PB_Ignore)
;                   Case \ID[4] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Match(Y+\Pos, \Grid)-GadgetY0)
;                   Case \ID[5] : ResizeGadget(\Gadget, Match(X+(\Size-\Pos), \Grid, GadgetX1), Match(Y+(\Size-\Pos), \Grid, GadgetY1), GadgetX1-Match(X+(\Size-\Pos), \Grid, GadgetX1), GadgetY1-Match(Y+(\Size-\Pos), \Grid, GadgetY1))
;                   Case \ID[6] : ResizeGadget(\Gadget, #PB_Ignore, Match(Y+(\Size-\Pos), \Grid, GadgetY1), Match(X+\Pos, \Grid)-GadgetX0, GadgetY1-Match(Y+(\Size-\Pos), \Grid, GadgetY1))
;                   Case \ID[7] : ResizeGadget(\Gadget, #PB_Ignore, #PB_Ignore, Match(X+\Pos, \Grid)-GadgetX0, Match(Y+\Pos, \Grid)-GadgetY0)
;                   Case \ID[8] : ResizeGadget(\Gadget, Match(X+(\Size-\Pos), \Grid, GadgetX1), #PB_Ignore, GadgetX1-Match(X+(\Size-\Pos), \Grid, GadgetX1), Match(Y+\Pos, \Grid)-GadgetY0)
;                   Case \ID[#Arrows] : ResizeGadget(\Gadget, Match(X-\Size*2, \Grid), Match(Y+(\Size-\Pos), \Grid), #PB_Ignore, #PB_Ignore)
;                 EndSelect
;                 
;                 Move(*Anchor)
                
        
                ; gadget resize
                Select EventGadget()
                  Case \ID[1]
                    iX=Match(X+(\Size-\Pos), \Grid, GadgetX1)
                    iWidth=GadgetX1-Match(X+(\Size-\Pos), \Grid, GadgetX1)
                    
                  Case \ID[2] 
                    iY=Match(Y+(\Size-\Pos), \Grid, GadgetY1)
                    iHeight=GadgetY1-Match(Y+(\Size-\Pos), \Grid, GadgetY1)
                    
                  Case \ID[3] 
                    iWidth=Match(X+\Pos, \Grid)-GadgetX0
                    
                  Case \ID[4] 
                    iHeight=Match(Y+\Pos, \Grid)-GadgetY0
                    
                  Case \ID[5]
                    iX=Match(X+(\Size-\Pos), \Grid, GadgetX1)
                    iY=Match(Y+(\Size-\Pos), \Grid, GadgetY1)
                    iWidth=GadgetX1-Match(X+(\Size-\Pos), \Grid, GadgetX1)
                    iHeight=GadgetY1-Match(Y+(\Size-\Pos), \Grid, GadgetY1)
                    
                  Case \ID[6] 
                    iY=Match(Y+(\Size-\Pos), \Grid, GadgetY1)
                    iWidth=Match(X+\Pos, \Grid)-GadgetX0
                    iHeight=GadgetY1-Match(Y+(\Size-\Pos), \Grid, GadgetY1)
                    
                  Case \ID[7] 
                    iWidth=Match(X+\Pos, \Grid)-GadgetX0
                    iHeight=Match(Y+\Pos, \Grid)-GadgetY0
                    
                  Case \ID[8] 
                    iX=Match(X+(\Size-\Pos), \Grid, GadgetX1)
                    iWidth=GadgetX1-Match(X+(\Size-\Pos), \Grid, GadgetX1)
                    iHeight=Match(Y+\Pos, \Grid)-GadgetY0
                    
                  Case \ID[#Arrows] 
                    iX=Match(X-\Size*2, \Grid)
                    iY=Match(Y+(\Size-\Pos), \Grid)
                    
                EndSelect
                
                Protected change
                Static left_x1, left_x2, top_y1, top_y2
                If left_x1<>iX : left_x1=iX : change=1 : EndIf
                If left_x2<>iWidth : left_x2=iWidth : change=2 : EndIf
                If top_y1<>iY : top_y1=iY : change=3 : EndIf
                If top_y2<>iHeight : top_y2=iHeight : change=4 : EndIf
                
                If change
                  ResizeGadget(\Gadget, iX,iY,iWidth,iHeight)
                  Move(*Anchor)
                  Lines(\Gadget, \Parent, \Item, change)
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    UpdateWindow_(GetAncestor_( GadgetID( \Gadget ), #GA_ROOT ))
                  CompilerEndIf 
                EndIf
               
              EndIf
              
          EndSelect
        EndWith
    EndSelect
    
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
          
          DeleteMapElement(Index(), Str(Gadget))
          DeleteElement(AnChor())
        EndIf
      Next
    EndIf
    
  EndProcedure
  
  Global CanvasProc
  Procedure Enable(Gadget.i, Grid.i=1, Flags.i=#Anchor_All, Parent=-1, Item=0)
    Protected ID.i, I.i
    Protected *Anchor.Transformation
    Protected *Cursors.DataBuffer = ?Cursors
    Protected *Flags.DataBuffer = ?Flags
    
    If IsGadget(Gadget)
      Disable(Gadget)
      
      *Anchor = AddElement(AnChor())
      
      With *AnChor
        \Parent = Parent
        \Gadget = Gadget
        \Item = Item
        \Grid = Grid
        If IsGadget(Parent)
          \Pos = 10
        Else
          \Pos = 3
        EndIf
        \Size = 5
        
        For I = 1 To #Alles
          If Flags & *Flags\ID[I] = *Flags\ID[I]
            If (I=#Arrows)
              ID = CanvasGadget(#PB_Any, 0,0, \Size*2, \Size) 
            Else
              ID = CanvasGadget(#PB_Any, 0,0, \Size, \Size)
            EndIf
            
            \ID[I] = ID
            Index(Str(ID)) = I
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
        
        Move(*Anchor)
        ClipGadgets(UseGadgetList(0))
        
        UnbindEvent(#PB_Event_ActivateWindow, @CallBack())
        BindEvent(#PB_Event_ActivateWindow, @CallBack())
        UnbindEvent(#PB_Event_LeftClick, @CallBack())
        BindEvent(#PB_Event_LeftClick, @CallBack())
        
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
            Debug "Is anchor "+Is(EventGadget());+" "+Object()
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
                Enable(#ButtonGadget, 1, #Anchor_All, #ContainerGadget2)
                CloseGadgetList()
                Enable(#TrackBarGadget, 1, #Anchor_Position|#Anchor_Horizontally)
                Enable(#SpinGadget, 1, #Anchor_Position)
                Enable(#CanvasGadget, 1, #Anchor_All)
                Enable(#ContainerGadget, 1, #Anchor_All)
                OpenGadgetList(#ContainerGadget)
                Enable(#ContainerGadget2, 10, #Anchor_All, #ContainerGadget)
                CloseGadgetList()
            EndSelect
        EndSelect
        
    EndSelect
    
  ForEver
CompilerEndIf
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 220
; Folding = -----
; EnableXP
; CompileSourceDirectory