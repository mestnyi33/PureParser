;- Include: Transformation
; http://www.purebasic.fr/english/viewtopic.php?f=12&t=64700
; http://forums.purebasic.com/german/viewtopic.php?f=8&t=29423&sid=c3d8ea4c76dac2b34b9a49b639f06911

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
  Declare Is(Gadget.i)
  Declare Change(Object.i)
  Declare Gadget(Gadget.i)
  Declare Update(Gadget.i)
  Declare Disable(Gadget.i)
  Declare Enable(Gadget.i, Parent.i, Grid.i=1, Flags.i=#Anchor_All, Item=0)
  
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
    If This\ID[#Arrows] : ResizeGadget(This\ID[#Arrows], GadgetX(This\Gadget, Coordinate)+(This\Pos+2), GadgetY(This\Gadget, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
  EndMacro
  
  Procedure Lines(Gadget.i=-1, Parent.i=-1, Item.i=0, distance=0)
    Static reset_gadget=-1
    Static left_in=-1, right_in=-1, top_in=-1, bottom_in=-1
    Static left_gadget=-1,right_gadget=-1,top_gadget=-1,bottom_gadget=-1
    
    Static left_cross_in=-1, right_cross_in=-1, top_cross_in=-1, bottom_cross_in=-1
    Static left_cross_gadget=-1,right_cross_gadget=-1,top_cross_gadget=-1,bottom_cross_gadget=-1
    
    Protected ls=1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    Macro Show_line(show_gadget, show_in, Gadget, show_state=0, show_x=0,show_y=0,show_width=0,show_height=0, Color=$0000FF)
      If show_state
        If IsGadget(show_gadget) 
          If show_in <> Gadget : show_in = Gadget : EndIf
          ResizeGadget(show_gadget, show_x,show_y,show_width,show_height)
        Else
          show_in = Gadget
          ;show_gadget = TextGadget(#PB_Any, show_x,show_y,show_width,show_height,"")
          show_gadget = ContainerGadget(#PB_Any, show_x,show_y,show_width,show_height) : CloseGadgetList()
          SetGadgetColor(show_gadget, #PB_Gadget_BackColor, Color)
          Clip(show_gadget)
        EndIf
      Else
        If show_in = Gadget
          If IsGadget(show_gadget) : FreeGadget(show_gadget) : EndIf
          show_in =- 1
        EndIf
      EndIf
    EndMacro
    
    ; Reset show all line
    If reset_gadget <> Gadget
      Show_line(top_gadget, top_in, top_in)
      Show_line(left_gadget, left_in, left_in)
      Show_line(right_gadget, right_in, right_in)
      Show_line(bottom_gadget, bottom_in, bottom_in)
      
      Show_line(top_cross_gadget, top_cross_in, top_cross_in)
      Show_line(left_cross_gadget, left_cross_in, left_cross_in)
      Show_line(right_cross_gadget, right_cross_in, right_cross_in)
      Show_line(bottom_cross_gadget, bottom_cross_in, bottom_cross_in)
      reset_gadget = Gadget
    EndIf
    
    With AnChor()
      If IsGadget(Gadget)
        checked_x1 = GadgetX(Gadget)
        checked_y1 = GadgetY(Gadget)
        checked_x2 = checked_x1+GadgetWidth(Gadget)
        checked_y2 = checked_y1+GadgetHeight(Gadget)
        
        top_x1 = checked_x1 : top_x2 = checked_x2
        left_y1 = checked_y1 : left_y2 = checked_y2 
        right_y1 = checked_y1 : right_y2 = checked_y2
        bottom_x1 = checked_x1 : bottom_x2 = checked_x2
        
        PushListPosition(AnChor())
        ForEach AnChor()
          If Bool(\Gadget <> Gadget And \Parent = Parent And \Item = Item)   
            relative_x1 = GadgetX(\Gadget)
            relative_y1 = GadgetY(\Gadget)
            relative_x2 = relative_x1+GadgetWidth(\Gadget)
            relative_y2 = relative_y1+GadgetHeight(\Gadget)
            
            ;Left_line
            If checked_x1 = relative_x1
              If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
              If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
              
              Show_line(left_gadget, left_in, \Gadget, #True, checked_x1,left_y1,ls,left_y2-left_y1, $0000FF)
            ElseIf checked_y1 <> relative_y1
              Show_line(left_gadget, left_in, \Gadget)
            EndIf
            
            ;Right_line
            If checked_x2 = relative_x2
              If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
              If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
              
              Show_line(right_gadget, right_in, \Gadget, #True, checked_x2-ls,right_y1,ls,right_y2-right_y1, $0000FF)
            ElseIf checked_y2 <> relative_y2 
              Show_line(right_gadget, right_in, \Gadget)
            EndIf
            
            ;Top_line
            If checked_y1 = relative_y1 
              If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
              If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
              
              Show_line(top_gadget, top_in, \Gadget, #True, top_x1,checked_y1,top_x2-top_x1,ls, $FF0000)
            ElseIf checked_x1 <> relative_x1
              Show_line(top_gadget, top_in, \Gadget)
            EndIf
            
            ;Bottom_line
            If checked_y2 = relative_y2 
              If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
              If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
              
              Show_line(bottom_gadget, bottom_in, \Gadget, #True, bottom_x1,checked_y2-ls,bottom_x2-bottom_x1,ls, $FF0000)
            ElseIf checked_x2 <> relative_x2
              Show_line(bottom_gadget, bottom_in, \Gadget)
            EndIf
            
            
            ;Left_cross
            If checked_x1 = relative_x2+distance And 
               (checked_y2 >= relative_y1 And checked_y1 =< relative_y2)
              left_y1 = relative_y1+((checked_y2-relative_y1))/2-ls ; relative_y1+((checked_y2-(checked_y2-checked_y1)/2)-(relative_y1-(relative_y2-relative_y1)/2))/2-ls
              
              Show_line(left_cross_gadget, left_cross_in, \Gadget, #True, relative_x2,left_y1,checked_x1-relative_x2,ls*2, $0094FE)
            ElseIf checked_y1 <> relative_y1
              Show_line(left_cross_gadget, left_cross_in, \Gadget)
            EndIf
            
            ;Right_cross
            If checked_x2 = relative_x1-distance And 
               (checked_y2 >= relative_y1 And checked_y1 =< relative_y2)
              right_y1 = relative_y1+(checked_y2-relative_y1)/2-ls
              
              Show_line(right_cross_gadget, right_cross_in, \Gadget, #True, checked_x2, right_y1, relative_x1-checked_x2, ls*2, $0094FE)
            ElseIf checked_y2 <> relative_y2
              Show_line(right_cross_gadget, right_cross_in, \Gadget)
            EndIf
            
            ;Top_cross
            If checked_y1 = relative_y2+distance And 
               (checked_x2 >= relative_x1 And checked_x1 =< relative_x2) 
              top_x1 = relative_x1+(checked_x2-relative_x1)/2-ls
              
              Show_line(top_cross_gadget, top_cross_in, \Gadget, #True, top_x1, relative_y2,ls*2,checked_y1-relative_y2, $FE00E1)
            ElseIf checked_x1 <> relative_x1
              Show_line(top_cross_gadget, top_cross_in, \Gadget)
            EndIf
            
            ;Bottom_cross
            If checked_y2 = relative_y1-distance And 
               (checked_x2 >= relative_x1 And checked_x1 =< relative_x2)
              bottom_x1 = relative_x1+(checked_x2-relative_x1)/2-ls
              
              Show_line(bottom_cross_gadget, bottom_cross_in, \Gadget, #True, bottom_x1, checked_y2, ls*2,relative_y1-checked_y2, $FE00E1)
            ElseIf checked_x2 <> relative_x2
              Show_line(bottom_cross_gadget, bottom_cross_in, \Gadget)
            EndIf
            
          EndIf
        Next
        PopListPosition(AnChor())
        
      EndIf
    EndWith
  EndProcedure
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    Value = Round((Value/Grid), #PB_Round_Nearest) * Grid
    If (Value>Max) : Value=Max : EndIf
    ProcedureReturn Value
  EndProcedure
  
  Procedure Count() 
    ProcedureReturn #Alles
  EndProcedure
  
  Procedure Object()
    ProcedureReturn ActivateObject
  EndProcedure
  
  Procedure Is(Gadget.i)
    ProcedureReturn Index(Str(Gadget))
  EndProcedure
  
  Procedure Gadget(Gadget.i)
    Protected I.i
    
    If ListSize(AnChor())
      ForEach AnChor()
        If AnChor()\Gadget = Gadget
          For I = 1 To #Alles
            If I = Is(Gadget)
              ProcedureReturn AnChor()\ID[I]
            EndIf
          Next
        EndIf
      Next
    EndIf
    
  EndProcedure
  
  Procedure Hide(Gadget.i, State.b)
    Protected I.i
    
    If ListSize(AnChor())
      PushListPosition(AnChor())
      If IsGadget(Gadget) 
        ForEach AnChor()
          If AnChor()\Gadget = Gadget
            For I = 1 To 8
              If AnChor()\ID[I]
                HideGadget(AnChor()\ID[I], State)
              EndIf
            Next
          EndIf
        Next
      Else
        ForEach AnChor()
          For I = 1 To 8
            If AnChor()\ID[I]
              HideGadget(AnChor()\ID[I], State)
            EndIf
          Next
        Next
      EndIf
      PopListPosition(AnChor())
    EndIf
    
  EndProcedure
  
  Procedure Update(Gadget.i)
    If ListSize(AnChor()) 
      ForEach AnChor()
        If AnChor()\Gadget = Gadget
          Lines(AnChor()\Gadget, AnChor()\Parent, AnChor()\Item, AnChor()\Grid)
          Move(AnChor())
        EndIf
      Next
    EndIf
  EndProcedure
  
  Procedure Change(Object.i) ; 
    If ListSize(AnChor()) 
      If IsGadget(Object)
        ForEach AnChor()
          With AnChor()
            If \Gadget = Object
              Hide(#PB_Default, #True)
              Hide(\Gadget, #False)
              Lines(\Gadget, \Parent, \Item, \Grid)
              Move(AnChor())
            EndIf
          EndWith
        Next
      ElseIf IsWindow(Object)
        Lines() ; Reset show all lines
        Hide(#PB_Default, #True)
      EndIf
    EndIf
  EndProcedure
  
  
  Procedure sel_top(Gadget.i, Parent.i, Item.i, change.b=0, distance=0)
    Protected ls=1
    
    Static left_in=-1, right_in=-1, top_in=-1, bottom_in=-1
    Static left_gadget=-1,right_gadget=-1,top_gadget=-1,bottom_gadget=-1
    
    Static left_cross_in=-1, right_cross_in=-1, top_cross_in=-1, bottom_cross_in=-1
    Static left_cross_gadget=-1,right_cross_gadget=-1,top_cross_gadget=-1,bottom_cross_gadget=-1
    
    Protected top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    
    With AnChor()
      If IsGadget(Gadget)
        checked_x1 = GadgetX(Gadget)
        checked_y1 = GadgetY(Gadget)
        checked_x2 = checked_x1+GadgetWidth(Gadget)
        checked_y2 = checked_y1+GadgetHeight(Gadget)
        
        ;If change = 0 
        top_x1 = checked_x1 : top_x2 = checked_x2 : bottom_x1 = checked_x1 : bottom_x2 = checked_x2
        left_y1 = checked_y1 : left_y2 = checked_y2 : right_y1 = checked_y1 : right_y2 = checked_y2
        
        PushListPosition(AnChor())
        ForEach AnChor()
          If Bool(\Gadget <> Gadget And \Parent = Parent And \Item = Item)   
            relative_x1 = GadgetX(\Gadget)
            relative_y1 = GadgetY(\Gadget)
            relative_x2 = relative_x1+GadgetWidth(\Gadget)
            relative_y2 = relative_y1+GadgetHeight(\Gadget)
            
            If checked_y1 >= relative_y2
              PostEvent(#PB_Event_Gadget, EventWindow(), \ID[#Arrows], #PB_EventType_LeftButtonDown)
              PostEvent(#PB_Event_Gadget, EventWindow(), \ID[#Arrows], #PB_EventType_LeftButtonUp)
            EndIf
          EndIf
        Next
        PopListPosition(AnChor())
        
        ;EndIf
      EndIf
    EndWith
  EndProcedure
  
  Procedure sel_bottom(Gadget.i, Parent.i, Item.i, change.b=0, distance=0)
    Protected ls=1
    
    Static left_in=-1, right_in=-1, top_in=-1, bottom_in=-1
    Static left_gadget=-1,right_gadget=-1,top_gadget=-1,bottom_gadget=-1
    
    Static left_cross_in=-1, right_cross_in=-1, top_cross_in=-1, bottom_cross_in=-1
    Static left_cross_gadget=-1,right_cross_gadget=-1,top_cross_gadget=-1,bottom_cross_gadget=-1
    
    Protected top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    
    With AnChor()
      If IsGadget(Gadget)
        checked_x1 = GadgetX(Gadget)
        checked_y1 = GadgetY(Gadget)
        checked_x2 = checked_x1+GadgetWidth(Gadget)
        checked_y2 = checked_y1+GadgetHeight(Gadget)
        
        ;If change = 0 
        top_x1 = checked_x1 : top_x2 = checked_x2 : bottom_x1 = checked_x1 : bottom_x2 = checked_x2
        left_y1 = checked_y1 : left_y2 = checked_y2 : right_y1 = checked_y1 : right_y2 = checked_y2
        
        PushListPosition(AnChor())
        ForEach AnChor()
          If Bool(\Gadget <> Gadget And \Parent = Parent And \Item = Item)   
            relative_x1 = GadgetX(\Gadget)
            relative_y1 = GadgetY(\Gadget)
            relative_x2 = relative_x1+GadgetWidth(\Gadget)
            relative_y2 = relative_y1+GadgetHeight(\Gadget)
            
            ;If top_x1
            If checked_y2 =< relative_y1
              PostEvent(#PB_Event_Gadget, EventWindow(), \ID[#Arrows], #PB_EventType_LeftButtonDown)
              PostEvent(#PB_Event_Gadget, EventWindow(), \ID[#Arrows], #PB_EventType_LeftButtonUp)
            EndIf
          EndIf
        Next
        PopListPosition(AnChor())
        
        ;EndIf
      EndIf
    EndWith
  EndProcedure
  
  
  Procedure CallBack()
    
    Select Event()
      Case #PB_Event_LeftClick ; #PB_Event_ActivateWindow, 
        Hide(#PB_Default, #True)
        Lines() ; Reset show all lines
        ActivateObject = EventWindow()
        PostEvent(#PB_Event_Gadget, EventWindow(), #PB_Ignore, #PB_EventType_StatusChange);, \Gadget) ; EventGadget())
                 
      Case #PB_Event_Gadget
        Protected change.b
        Static left_x1.i, left_x2.i, top_y1.i, top_y2.i
        Static Selected.b, X.i, Y.i, OffsetX.i, OffsetY.i
        Static GadgetX0.i, GadgetX1.i, GadgetY0.i, GadgetY1.i
        Protected *This.Transformation = GetGadgetData(EventGadget())
        Protected iX.i=#PB_Ignore,iY.i=#PB_Ignore,iWidth.i=#PB_Ignore,iHeight.i=#PB_Ignore
        
        With *This
          Select EventType()
            Case #PB_EventType_KeyDown
              GadgetX0 = GadgetX(\Gadget)
              GadgetY0 = GadgetY(\Gadget)
              
              If IsGadget(\ID[#Arrows]) 
                Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Key)
                  Case #PB_Shortcut_Left
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift 
                        If \ID[1] 
                          iWidth = Match(GadgetWidth(\Gadget)-\Grid, \Grid)
                        EndIf
                      Case #PB_Canvas_Control : iX = Match(GadgetX0-\Grid, \Grid)
                      Default
                        
                    EndSelect
                    
                  Case #PB_Shortcut_Up
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift 
                        If \ID[2] 
                          iHeight = Match(GadgetHeight(\Gadget)-\Grid, \Grid) 
                        EndIf
                      Case #PB_Canvas_Control : iY = Match(GadgetY0-\Grid, \Grid)
                      Default
                        sel_top(\Gadget, \Parent, \Item, change, \Grid)
                        
                    EndSelect
                    
                  Case #PB_Shortcut_Right
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift   
                        If \ID[3] 
                          iWidth = Match(GadgetWidth(\Gadget)+\Grid, \Grid)
                        EndIf
                      Case #PB_Canvas_Control : iX = Match(GadgetX0+\Grid, \Grid)
                      Default
                        
                    EndSelect
                    
                  Case #PB_Shortcut_Down
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift   
                        If \ID[4] 
                          iHeight = Match(GadgetHeight(\Gadget)+\Grid, \Grid)
                        EndIf
                      Case #PB_Canvas_Control : iY = Match(GadgetY0+\Grid, \Grid)
                      Default
                        sel_bottom(\Gadget, \Parent, \Item, change, \Grid)
                        
                    EndSelect
                    
                EndSelect
                
                If left_x1<>iX : left_x1=iX : change=1 : EndIf
                If left_x2<>iWidth : left_x2=iWidth : change=2 : EndIf
                If top_y1<>iY : top_y1=iY : change=3 : EndIf
                If top_y2<>iHeight : top_y2=iHeight : change=4 : EndIf
                
                If change
                  ResizeGadget(\Gadget, iX,iY,iWidth,iHeight)
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    UpdateWindow_(GetAncestor_( GadgetID( \Gadget ), #GA_ROOT ))
                  CompilerEndIf 
                  Lines(\Gadget, \Parent, \Item, \Grid)
                  Move(*This)
                EndIf
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              Selected = #True
              GadgetX0 = GadgetX(\Gadget)
              GadgetY0 = GadgetY(\Gadget)
              GadgetX1 = GadgetX0 + GadgetWidth(\Gadget)
              GadgetY1 = GadgetY0 + GadgetHeight(\Gadget)
              OffsetX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
              OffsetY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
              
              If \ID[#Arrows] = EventGadget()
                If GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) = #PB_Cursor_Hand
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Arrows)
                EndIf
                
                If ActivateObject <> \Gadget 
                  ActivateObject = \Gadget 
                  Hide(#PB_Default, #True)
                  PostEvent(#PB_Event_Gadget, EventWindow(), \Gadget, #PB_EventType_StatusChange, *This) ; EventGadget())
                EndIf
                
                Lines(\Gadget, \Parent, \Item, \Grid)
                Hide(\Gadget, #False)
              EndIf
              
            Case #PB_EventType_LeftButtonUp
              Selected = #False
              If GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) = #PB_Cursor_Arrows
                SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Hand)
              EndIf  
              If EventGadget() <> \ID[#Arrows] : SetActiveGadget(\ID[#Arrows]) : EndIf
              
            Case #PB_EventType_MouseMove
              If Selected ; And GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons) 
                X = DesktopMouseX()-(GadgetX(\Gadget, #PB_Gadget_ScreenCoordinate)-GadgetX(\Gadget, #PB_Gadget_ContainerCoordinate))-OffsetX
                Y = DesktopMouseY()-(GadgetY(\Gadget, #PB_Gadget_ScreenCoordinate)-GadgetY(\Gadget, #PB_Gadget_ContainerCoordinate))-OffsetY
                
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
                    iHeight=Match(Y+\Pos, \Grid)-GadgetY0
                    iWidth=GadgetX1-Match(X+(\Size-\Pos), \Grid, GadgetX1)
                    
                  Case \ID[#Arrows] 
                    iX=Match((X-\Pos-2), \Grid)
                    iY=Match(Y+(\Size-\Pos), \Grid)
                    
                EndSelect
                
                If left_x1<>iX : left_x1=iX : change=1 : EndIf
                If left_x2<>iWidth : left_x2=iWidth : change=2 : EndIf
                If top_y1<>iY : top_y1=iY : change=3 : EndIf
                If top_y2<>iHeight : top_y2=iHeight : change=4 : EndIf
                
                If change
                  ResizeGadget(\Gadget, iX,iY,iWidth,iHeight)
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    UpdateWindow_(GetAncestor_( GadgetID( \Gadget ), #GA_ROOT ))
                  CompilerEndIf 
                  Lines(\Gadget, \Parent, \Item, \Grid)
                  Move(*This)
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
  
  Procedure Enable(Gadget.i, Parent.i, Grid.i=1, Flags.i=#Anchor_All, Item=0)
    Protected ID.i, I.i, UseGadgetList.i
    Protected *This.Transformation
    Protected *Cursors.DataBuffer = ?CursorsBuffer
    Protected *Flags.DataBuffer = ?FlagsBuffer
    
    If IsGadget(Parent)
      OpenGadgetList(Parent)
    ElseIf IsWindow(Parent)
      UseGadgetList = UseGadgetList(WindowID(Parent))
    EndIf
            
    If IsGadget(Gadget)
      Disable(Gadget)
      
      *This = AddElement(AnChor())
      
      With *This
        \Window = GetActiveWindow()
        \Parent = Parent
        \Gadget = Gadget
        \Item = Item
        \Grid = Grid
        \Size = 5
        
        If IsGadget(Parent) And 
           GadgetType(Parent) = #PB_GadgetType_Splitter
          \Pos = 10
        Else
          \Pos = 3
        EndIf
        
        For I = 1 To #Alles
          If Flags & *Flags\ID[I] = *Flags\ID[I]
            If (I=#Arrows)
              ID = CanvasGadget(#PB_Any, 0,0, \Size*2, \Size, #PB_Canvas_Keyboard) : HideGadget(ID, #True)
            Else
              ID = CanvasGadget(#PB_Any, 0,0, \Size, \Size) : HideGadget(ID, #True)
            EndIf
            
            \ID[I] = ID
            Index(Str(ID)) = I
            SetGadgetData(ID, *This)
            SetGadgetAttribute(ID, #PB_Canvas_Cursor, *Cursors\ID[I])
            
            If StartDrawing(CanvasOutput(ID))
              Box(0, 0, OutputWidth(), OutputHeight(), $000000)
              Box(1, 1, OutputWidth()-2, OutputHeight()-2, $FFFFFF)
              StopDrawing()
            EndIf
            
            BindGadgetEvent(ID, @Callback())
          EndIf
        Next
        
        Move(*This)
        ClipGadgets(UseGadgetList(0))
        HideGadget(\ID[#Arrows], #False)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          UpdateWindow_(UseGadgetList(0))
        CompilerEndIf 
        
        UnbindEvent(#PB_Event_LeftClick, @CallBack(), \Window)
        BindEvent(#PB_Event_LeftClick, @CallBack(), \Window)
      EndWith
    EndIf
    
    If IsGadget(Parent)
      CloseGadgetList()
    ElseIf IsWindow(Parent)
      UseGadgetList(UseGadgetList)
    EndIf
    
    DataSection
      CursorsBuffer:
      Data.i 0
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftRight
      Data.i #PB_Cursor_UpDown
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_LeftUpRightDown
      Data.i #PB_Cursor_LeftDownRightUp
      Data.i #PB_Cursor_Hand ;  #PB_Cursor_Arrows
      
      FlagsBuffer:
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
          Case #PB_EventType_Change
            Debug EventGadget()
            
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
                Enable(#EditorGadget, #Window, 5, #Anchor_All)
;                 OpenGadgetList(#ContainerGadget2)
                Enable(#ButtonGadget, #ContainerGadget2, 1, #Anchor_All, #ContainerGadget2)
;                 CloseGadgetList()
                Enable(#TrackBarGadget, #Window, 1, #Anchor_Position|#Anchor_Horizontally)
                Enable(#SpinGadget, #Window, 1, #Anchor_Position)
                Enable(#CanvasGadget, #Window, 1, #Anchor_All)
                Enable(#ContainerGadget, #Window, 1, #Anchor_All)
;                 OpenGadgetList(#ContainerGadget)
                Enable(#ContainerGadget2, #ContainerGadget, 10, #Anchor_All, #ContainerGadget)
;                 CloseGadgetList()
            EndSelect
        EndSelect
        
    EndSelect
    
  ForEver
CompilerEndIf
