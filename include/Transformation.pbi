;- Include: Transformation
; http://www.purebasic.fr/english/viewtopic.php?f=12&t=64700
; http://forums.purebasic.com/german/viewtopic.php?f=8&t=29423&sid=c3d8ea4c76dac2b34b9a49b639f06911

DeclareModule Transformation
  EnableExplicit
  
  #Alles = 9
  #Arrows = 9
  
  #MenuItem_Delete = 61001
  #MenuItem_Block = 61002
  
  EnumerationBinary 1
    #Anchor_Position
    #Anchor_Horizontally
    #Anchor_Vertically
  EndEnumeration
  
  #Anchor_Size = #Anchor_Horizontally|#Anchor_Vertically
  #Anchor_All  = #Anchor_Position|#Anchor_Horizontally|#Anchor_Vertically
  Global PopupMenu
  
  Declare Count()
  Declare Object()
  Declare Is(Gadget.i)
  Declare PopupMenu(Object.i)
  Declare Change(Object.i)
  Declare Gadget(Gadget.i)
  Declare Update(Object.i)
  Declare Free(Object.i)
  Declare Create(Object.i, Parent.i, Window.i=-1, Item.i=0, Grid.i=1, Flags.i=#Anchor_All)
  
  
EndDeclareModule

Module Transformation
  Structure DataBuffer
    ID.i[#Alles+1]
  EndStructure
  
  Structure Transformation Extends DataBuffer
    Window.i
    Object.i
    Parent.i
    Item.i
    
    Grid.i
    Pos.i
    Size.i
  EndStructure
  
  Global ChangedObject =- 1
  Global NewMap Index.i()
  Global NewList AnChor.Transformation()
  
  Global PopupMenuCallObject
  Declare CallBack()
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Procedure GadgetsClipCallBack( GadgetID, lParam )
      If GadgetID
        Protected Gadget = GetProp_( GadgetID, "PB_ID" )
        
        If GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS = #False 
          SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS|#WS_CLIPCHILDREN )
          
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
                
                ; Для панел гаджета темный фон убирать
              Case #PB_GadgetType_Panel 
                If Not IsGadget( Gadget ) And (GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
                  SetWindowLongPtr_(GadgetID, #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID, #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
                EndIf
                
            EndSelect
            
            ;             If (GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) & #WS_EX_TRANSPARENT) = #False
            ;               SetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE, GetWindowLongPtr_(GadgetID( Gadget ), #GWL_EXSTYLE) | #WS_EX_TRANSPARENT)
            ;             EndIf
          EndIf
          
          
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
      If Not (GetWindowLongPtr_(WindowID, #GWL_STYLE)&#WS_CLIPCHILDREN)
        SetWindowLongPtr_( WindowID, #GWL_STYLE, GetWindowLongPtr_( WindowID, #GWL_STYLE )|#WS_CLIPCHILDREN )
      EndIf
      EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
    CompilerEndIf
  EndProcedure
  
  Macro Clip(_gadget_)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        If IsGadget(_gadget_)
          Define ___ClipMacroGadgetHeight___ = GadgetHeight( _gadget_ )
        EndIf
        SetWindowLongPtr_( GadgetID( _gadget_ ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( _gadget_ ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
        If ___ClipMacroGadgetHeight___ And GadgetType( _gadget_ ) = #PB_GadgetType_ComboBox
          ResizeGadget( _gadget_, #PB_Ignore, #PB_Ignore, #PB_Ignore, ___ClipMacroGadgetHeight___ )
        EndIf
        SetWindowPos_( GadgetID( _gadget_ ), #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
    CompilerEndSelect
  EndMacro
  
  Macro Move(This, Coordinate=#PB_Gadget_ContainerCoordinate)
    ; Transformation resize
    If IsGadget(This\Object)
      If This\ID[1] : ResizeGadget(This\ID[1], GadgetX(This\Object, Coordinate)-This\Size+This\Pos, GadgetY(This\Object, Coordinate)+(GadgetHeight(This\Object)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[2] : ResizeGadget(This\ID[2], GadgetX(This\Object, Coordinate)+(GadgetWidth(This\Object)-This\Size)/2, GadgetY(This\Object, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[3] : ResizeGadget(This\ID[3], GadgetX(This\Object, Coordinate)+GadgetWidth(This\Object)-This\Pos, GadgetY(This\Object, Coordinate)+(GadgetHeight(This\Object)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[4] : ResizeGadget(This\ID[4], GadgetX(This\Object, Coordinate)+(GadgetWidth(This\Object)-This\Size)/2, GadgetY(This\Object, Coordinate)+GadgetHeight(This\Object)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[5] : ResizeGadget(This\ID[5], GadgetX(This\Object, Coordinate)-This\Size+This\Pos, GadgetY(This\Object, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[6] : ResizeGadget(This\ID[6], GadgetX(This\Object, Coordinate)+GadgetWidth(This\Object)-This\Pos, GadgetY(This\Object, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[7] : ResizeGadget(This\ID[7], GadgetX(This\Object, Coordinate)+GadgetWidth(This\Object)-This\Pos, GadgetY(This\Object, Coordinate)+GadgetHeight(This\Object)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[8] : ResizeGadget(This\ID[8], GadgetX(This\Object, Coordinate)-This\Size+This\Pos, GadgetY(This\Object, Coordinate)+GadgetHeight(This\Object)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[#Arrows] : ResizeGadget(This\ID[#Arrows], GadgetX(This\Object, Coordinate)+(This\Pos+2), GadgetY(This\Object, Coordinate)-This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    ElseIf IsWindow(This\Object)
      If This\ID[1] : ResizeGadget(This\ID[1], -This\Size+This\Pos, (WindowHeight(This\Object)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[2] : ResizeGadget(This\ID[2], (WindowWidth(This\Object)-This\Size)/2, -This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[3] : ResizeGadget(This\ID[3], WindowWidth(This\Object)-This\Pos, (WindowHeight(This\Object)-This\Size)/2, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[4] : ResizeGadget(This\ID[4], (WindowWidth(This\Object)-This\Size)/2, WindowHeight(This\Object)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[5] : ResizeGadget(This\ID[5], -This\Size+This\Pos, -This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[6] : ResizeGadget(This\ID[6], WindowWidth(This\Object)-This\Pos, -This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[7] : ResizeGadget(This\ID[7], WindowWidth(This\Object)-This\Pos, WindowHeight(This\Object)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[8] : ResizeGadget(This\ID[8], -This\Size+This\Pos, WindowHeight(This\Object)-This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
      If This\ID[#Arrows] : ResizeGadget(This\ID[#Arrows], (This\Pos+2), -This\Size+This\Pos, #PB_Ignore, #PB_Ignore) : EndIf
    EndIf
  EndMacro
  
  Macro Delete()
    For I = 1 To #Alles
      If AnChor()\ID[I]
        FreeGadget(AnChor()\ID[I])
      EndIf
    Next
    
    DeleteMapElement(Index(), Str(AnChor()\Object))
    DeleteElement(AnChor())
  EndMacro
  
  Procedure PopupMenu(Object.i)
    Protected I.i, Result, Window
    
    With AnChor()
      If Is(Object)
        PopupMenuCallObject = Object
        Window = \Window
      ElseIf Bool(IsGadget(Object)|IsWindow(Object))
        PushListPosition(AnChor())
        ForEach AnChor()
          If \Object = Object
            PopupMenuCallObject = \ID[#Arrows]
            Window = \Window
            Break
          EndIf
        Next
        PopListPosition(AnChor())
      EndIf
    EndWith
    
    If IsWindow(Window)
      DisplayPopupMenu(PopupMenu, WindowID(Window))
    EndIf
    
    ProcedureReturn PopupMenu
  EndProcedure
  
  Procedure Points(Window=-1, Steps=6, BoxColor=0, PlotColor=0)
    Static ID
    Protected hDC, x,y
    
    If Not ID
      Steps-1
      ExamineDesktops()
      ID=CanvasGadget(#PB_Any,0,0,DesktopWidth(0), DesktopHeight(0))
      HideGadget(ID, 1)
      
      If PlotColor=0 :PlotColor=RGB(1,1,1) :EndIf
      If BoxColor=0 :BoxColor=RGB(236,236,236) :EndIf
      
      If StartDrawing(CanvasOutput(ID))
        Box(0, 0, OutputWidth(), OutputHeight(), BoxColor)
        
        For x = 0 To OutputWidth()-1
          For y = 0 To OutputHeight()-1
            Plot(x,y,PlotColor)
            y+Steps
          Next
          x+Steps
        Next
        StopDrawing()
      EndIf
     
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Windows
          SetWindowLongPtr_( GadgetID( ID ), #GWL_STYLE, GetWindowLongPtr_( GadgetID( ID ), #GWL_STYLE )|#WS_CLIPSIBLINGS )
      CompilerEndSelect
      BindGadgetEvent(ID, @Callback())
      HideGadget(ID, 0)
    EndIf
    
    ProcedureReturn ID
  EndProcedure
  
  Procedure Lines(Gadget.i=-1, Parent.i=-1, Item.i=0, distance=0)
    Static reset_gadget=-1
    Static left_in=-1, right_in=-1, top_in=-1, bottom_in=-1
    Static left_gadget=-1,right_gadget=-1,top_gadget=-1,bottom_gadget=-1
    
    Static left_cross_in=-1, right_cross_in=-1, top_cross_in=-1, bottom_cross_in=-1
    Static left_cross_gadget=-1,right_cross_gadget=-1,top_cross_gadget=-1,bottom_cross_gadget=-1
    
    Protected ls=1, top_x1,left_y2,top_x2,left_y1,bottom_x1,right_y2,bottom_x2,right_y1
    Protected checked_x1,checked_y1,checked_x2,checked_y2, relative_x1,relative_y1,relative_x2,relative_y2
    
    Macro Show_line(show_gadget, show_in, _gadget_, _parent_=-1, _item_=-1, show_state=0, show_x=0,show_y=0,show_width=0,show_height=0, _color_=$0000FF)
      If show_state
        If IsGadget(show_gadget) 
          If show_in <> _gadget_ : show_in = _gadget_ : EndIf
          ResizeGadget(show_gadget, show_x,show_y,show_width,show_height)
        Else
          show_in = _gadget_
          If IsGadget(_parent_) : OpenGadgetList(_parent_, _item_) : EndIf
          ;show_gadget = TextGadget(#PB_Any, show_x,show_y,show_width,show_height,"")
          show_gadget = ContainerGadget(#PB_Any, show_x,show_y,show_width,show_height) : CloseGadgetList()
          ;show_gadget = CanvasGadget(#PB_Any, show_x,show_y,show_width,show_height)
          If show_gadget : SetGadgetColor(show_gadget, #PB_Gadget_BackColor, _color_) : EndIf
          If IsGadget(_parent_) : CloseGadgetList() : EndIf
          Clip(show_gadget)
        EndIf
      Else
        If show_in = _gadget_
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
          If Bool(IsGadget(\Object) And \Object <> Gadget And \Parent = Parent And \Item = Item)   
            relative_x1 = GadgetX(\Object)
            relative_y1 = GadgetY(\Object)
            relative_x2 = relative_x1+GadgetWidth(\Object)
            relative_y2 = relative_y1+GadgetHeight(\Object)
            
            ;Left_line
            If checked_x1 = relative_x1
              If left_y1 > relative_y1 : left_y1 = relative_y1 : EndIf
              If left_y2 < relative_y2 : left_y2 = relative_y2 : EndIf
              
              Show_line(left_gadget, left_in, \Object, \Parent, \Item, #True, checked_x1,left_y1,ls,left_y2-left_y1, $0000FF)
            Else
              Show_line(left_gadget, left_in, \Object)
            EndIf
            
            ;Right_line
            If checked_x2 = relative_x2
              If right_y1 > relative_y1 : right_y1 = relative_y1 : EndIf
              If right_y2 < relative_y2 : right_y2 = relative_y2 : EndIf
              
              Show_line(right_gadget, right_in, \Object, \Parent, \Item, #True, checked_x2-ls,right_y1,ls,right_y2-right_y1, $0000FF)
            Else 
              Show_line(right_gadget, right_in, \Object)
            EndIf
            
            ;Top_line
            If checked_y1 = relative_y1 
              If top_x1 > relative_x1 : top_x1 = relative_x1 : EndIf
              If top_x2 < relative_x2 : top_x2 = relative_x2: EndIf
              
              Show_line(top_gadget, top_in, \Object, \Parent, \Item, #True, top_x1,checked_y1,top_x2-top_x1,ls, $FF0000)
            Else
              Show_line(top_gadget, top_in, \Object)
            EndIf
            
            ;Bottom_line
            If checked_y2 = relative_y2 
              If bottom_x1 > relative_x1 : bottom_x1 = relative_x1 : EndIf
              If bottom_x2 < relative_x2 : bottom_x2 = relative_x2: EndIf
              
              Show_line(bottom_gadget, bottom_in, \Object, \Parent, \Item, #True, bottom_x1,checked_y2-ls,bottom_x2-bottom_x1,ls, $FF0000)
            Else
              Show_line(bottom_gadget, bottom_in, \Object)
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
    ProcedureReturn ChangedObject
  EndProcedure
  
  Procedure Is(Gadget.i)
    ProcedureReturn Index(Str(Gadget))
  EndProcedure
  
  Procedure Gadget(Gadget.i)
    Protected I.i
    
    If ListSize(AnChor())
      ForEach AnChor()
        If AnChor()\Object = Gadget
          For I = 1 To #Alles
            If I = Is(Gadget)
              ProcedureReturn AnChor()\ID[I]
            EndIf
          Next
        EndIf
      Next
    EndIf
    
  EndProcedure
  
  Procedure Hide(Object.i, State.b)
    Protected I.i
    
    If ListSize(AnChor())
      PushListPosition(AnChor())
      If Bool(IsGadget(Object)|IsWindow(Object)) 
        ForEach AnChor()
          If AnChor()\Object = Object
            For I = 1 To 8
              If IsGadget(AnChor()\ID[I])
                HideGadget(AnChor()\ID[I], State)
              EndIf
            Next
          EndIf
        Next
      Else
        ForEach AnChor()
          For I = 1 To 8
            If IsGadget(AnChor()\ID[I])
              HideGadget(AnChor()\ID[I], State)
            EndIf
          Next
        Next
      EndIf
      PopListPosition(AnChor())
    EndIf
    
  EndProcedure
  
  Procedure Disable(Object.i, State.b)
    Protected I.i
            
    If ListSize(AnChor())
      PushListPosition(AnChor())
      If Bool(IsGadget(Object)|IsWindow(Object)) 
        ForEach AnChor()
          If AnChor()\Object = Object
            For I = 1 To 8;#Arrows
              If AnChor()\ID[I]
                DisableGadget(AnChor()\ID[I], State)
              EndIf
            Next
          EndIf
        Next
      Else
        ForEach AnChor()
          For I = 1 To 8;#Arrows
            If IsGadget(AnChor()\ID[I])
              DisableGadget(AnChor()\ID[I], State)
            EndIf
          Next
        Next
      EndIf
      PopListPosition(AnChor())
    EndIf
    
  EndProcedure
  
  Procedure Update(Object.i)
    If ListSize(AnChor()) 
      ForEach AnChor()
        If AnChor()\Object = Object
          Lines(AnChor()\Object, AnChor()\Parent, AnChor()\Item, AnChor()\Grid)
          Move(AnChor())
        EndIf
      Next
    EndIf
  EndProcedure
  
  Procedure Change(Object.i) ; 
    If ListSize(AnChor()) 
      If Bool(IsGadget(Object))
        With AnChor()
          ForEach AnChor()
            If \Object = Object
              Hide(#PB_Default, #True)
              Hide(\Object, #False)
              Move(AnChor())
              Lines(\Object, \Parent, \Item, \Grid)
              Break
            EndIf
          Next
        EndWith
      ElseIf IsWindow(Object)
        Lines() ; Reset show all lines
        Hide(#PB_Default, #True)
        Hide(Object, #False)
      EndIf
    EndIf
  EndProcedure
  
  
  Procedure CallBack()
    Static Click
    Protected Change.b
    Protected *This.Transformation
    Static left_x1.i, left_x2.i, top_y1.i, top_y2.i
    Static Selected.b, X.i, Y.i, OffsetX.i, OffsetY.i
    Static ObjectX0.i, ObjectX1.i, ObjectY0.i, ObjectY1.i, ObjectWidth.i, ObjectHeight.i
    Protected iX.i=#PB_Ignore,iY.i=#PB_Ignore,iWidth.i=#PB_Ignore,iHeight.i=#PB_Ignore
        
    Macro SetCoordinate(This)
      If top_y1<>iY : top_y1=iY : Change=3 : EndIf
      If left_x1<>iX : left_x1=iX : Change=1 : EndIf
      If left_x2<>iWidth : left_x2=iWidth : Change=2 : EndIf
      If top_y2<>iHeight : top_y2=iHeight : Change=4 : EndIf
      
      If Change
        If IsGadget(This\Object)
          ResizeGadget(This\Object, iX,iY,iWidth,iHeight)
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            UpdateWindow_(GetAncestor_( GadgetID( This\Object ), #GA_ROOT ))
          CompilerEndIf 
        ElseIf IsWindow(This\Object)
          ResizeWindow(This\Object, iX,iY,iWidth,iHeight)
        EndIf
        Lines(This\Object, This\Parent, This\Item, This\Grid)
        Move(This)
      EndIf
    EndMacro
    
    Macro GetCoordinate(This)
      OffsetX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
      OffsetY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
      
      If IsGadget(This\Object)
        ObjectX0 = GadgetX(This\Object)
        ObjectY0 = GadgetY(This\Object)
        ObjectWidth = GadgetWidth(This\Object)
        ObjectHeight = GadgetHeight(This\Object)
      ElseIf IsWindow(This\Object)
        ObjectX0 = WindowX(This\Object, #PB_Window_FrameCoordinate)
        ObjectY0 = WindowY(This\Object, #PB_Window_FrameCoordinate)
        ObjectWidth = WindowWidth(This\Object, #PB_Window_InnerCoordinate)
        ObjectHeight = WindowHeight(This\Object, #PB_Window_InnerCoordinate)
        OffsetX+(WindowX(This\Object, #PB_Window_InnerCoordinate)-WindowX(This\Object, #PB_Window_FrameCoordinate))
        OffsetY+(WindowY(This\Object, #PB_Window_InnerCoordinate)-WindowY(This\Object, #PB_Window_FrameCoordinate))
      EndIf
      
      ObjectX1 = ObjectX0 + ObjectWidth
      ObjectY1 = ObjectY0 + ObjectHeight
    EndMacro
    
    Select Event()
      Case #PB_Event_LeftClick
        If ChangedObject<>EventWindow() 
          ChangedObject=EventWindow()
          Hide(#PB_Default, #True)
          Hide(ChangedObject, #False)
          Lines() ; Reset show all lines
          PostEvent(#PB_Event_Gadget, ChangedObject, #PB_Ignore, #PB_EventType_StatusChange)
        EndIf
        
      Case #PB_Event_Menu
        *This = GetGadgetData(PopupMenuCallObject)
        If *This
          With *This
            Select EventMenu()
              Case #MenuItem_Block : Click!1
                If Click
                  Disable(\Object, #True)
                  UnbindGadgetEvent(PopupMenuCallObject, @CallBack())
                  BindGadgetEvent(PopupMenuCallObject, @CallBack(), #PB_EventType_RightClick)
                  SetGadgetAttribute(PopupMenuCallObject, #PB_Canvas_Cursor, #PB_Cursor_Default)
                Else
                  Disable(\Object, #False)
                  UnbindGadgetEvent(PopupMenuCallObject, @CallBack(), #PB_EventType_RightClick)
                  BindGadgetEvent(PopupMenuCallObject, @CallBack())
                  SetGadgetAttribute(PopupMenuCallObject, #PB_Canvas_Cursor, #PB_Cursor_Hand)
                EndIf
                
              Case #MenuItem_Delete : Free(\Object)
                PostEvent(#PB_Event_Gadget, \Window, \Object, #PB_EventType_CloseItem)
                
            EndSelect
          EndWith
        EndIf
        
      Case #PB_Event_Gadget
        *This = GetGadgetData(EventGadget())
        With *This
          Select EventType()
            Case #PB_EventType_MouseEnter
              If Is(EventGadget()) And StartDrawing(CanvasOutput(EventGadget()))
                Box(0, 0, OutputWidth(), OutputHeight(), $000000)
                Box(1, 1, OutputWidth()-2, OutputHeight()-2, $4DFF00)
                StopDrawing()
              EndIf
              
              
            Case #PB_EventType_MouseLeave
              If Is(EventGadget()) And StartDrawing(CanvasOutput(EventGadget()))
                Box(0, 0, OutputWidth(), OutputHeight(), $000000)
                Box(1, 1, OutputWidth()-2, OutputHeight()-2, $FFFFFF)
                StopDrawing()
              EndIf
              
              
            Case #PB_EventType_LeftClick
              If Not *This
                PostEvent(#PB_Event_LeftClick, EventWindow(), #PB_Ignore, EventGadget())
              EndIf
              
            Case #PB_EventType_RightClick
              If *This And \ID[#Arrows] = EventGadget()
                PopupMenu(EventGadget())
              EndIf
              
            Case #PB_EventType_KeyUp
              Selected = #False
              
            Case #PB_EventType_KeyDown
              If IsGadget(\ID[#Arrows]) 
                GetCoordinate(*This)
                Selected = #True
                
                Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Key)
                  Case #PB_Shortcut_Left
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift 
                        If \ID[1] 
                          iWidth = Match(ObjectWidth-\Grid, \Grid)
                        EndIf
                      Case #PB_Canvas_Control
;                       Debug ObjectX0
;                         iX = ObjectX0-10;\Grid ; 
;                       Debug iX
                        iX = Match(ObjectX0-\Grid, \Grid)
                    Default
                          Selected = #False
                    
                    EndSelect
                    
                  Case #PB_Shortcut_Up
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift 
                        If \ID[2] 
                          iHeight = Match(ObjectHeight-\Grid, \Grid) 
                        EndIf
                      Case #PB_Canvas_Control : iY = Match(ObjectY0-\Grid, \Grid)
                      Default
                         Selected = #False
                     
                    EndSelect
                    
                  Case #PB_Shortcut_Right
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift   
                        If \ID[3] 
                          iWidth = Match(ObjectWidth+\Grid, \Grid)
                        EndIf
                      Case #PB_Canvas_Control : iX = Match(ObjectX0+\Grid, \Grid)
                      Default
                        Selected = #False
                      
                    EndSelect
                    
                  Case #PB_Shortcut_Down
                    Select GetGadgetAttribute(\ID[#Arrows], #PB_Canvas_Modifiers)
                      Case #PB_Canvas_Shift   
                        If \ID[4] 
                          iHeight = Match(ObjectHeight+\Grid, \Grid)
                        EndIf
                      Case #PB_Canvas_Control : iY = Match(ObjectY0+\Grid, \Grid)
                      Default
                      Selected = #False
                      
                    EndSelect
                    
                EndSelect
                
                If Selected
                  SetCoordinate(*This)
                EndIf
              EndIf
              
            Case #PB_EventType_LeftButtonDown
              If *This
                GetCoordinate(*This)
                Selected = #True
                
                If \ID[#Arrows] = EventGadget()
                  If GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) = #PB_Cursor_Hand
                    SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Arrows)
                  EndIf
                  
                  If ChangedObject<>\Object : ChangedObject=\Object 
                    Hide(#PB_Default, #True)
                    PostEvent(#PB_Event_Gadget, EventWindow(), \Object, #PB_EventType_StatusChange, EventGadget())
                  EndIf
                  
                  Lines(\Object, \Parent, \Item, \Grid)
                  Hide(\Object, #False)
                EndIf
              Else
                ; PostEvent(#PB_Event_LeftButtonDown, EventWindow(), #PB_Ignore)
                PostEvent(#PB_Event_Gadget, EventWindow(), #PB_Ignore, #PB_EventType_LeftButtonDown, EventGadget()) 
              EndIf
              
            Case #PB_EventType_LeftButtonUp
              If *This
                Selected = #False
                If GetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor) = #PB_Cursor_Arrows
                  SetGadgetAttribute(EventGadget(), #PB_Canvas_Cursor, #PB_Cursor_Hand)
                EndIf  
                If EventGadget() <> \ID[#Arrows] : SetActiveGadget(\ID[#Arrows]) : EndIf
              Else
                ; PostEvent(#PB_Event_LeftButtonUp, EventWindow(), #PB_Ignore)
                PostEvent(#PB_Event_Gadget, EventWindow(), #PB_Ignore, #PB_EventType_LeftButtonUp, EventGadget())
              EndIf
              
            Case #PB_EventType_MouseMove
              If *This And Selected ; And GetGadgetAttribute(EventGadget(), #PB_Canvas_Buttons) 
                If IsGadget(\Object)
                  X = DesktopMouseX()-(GadgetX(\Object, #PB_Gadget_ScreenCoordinate)-GadgetX(\Object, #PB_Gadget_ContainerCoordinate))-OffsetX
                  Y = DesktopMouseY()-(GadgetY(\Object, #PB_Gadget_ScreenCoordinate)-GadgetY(\Object, #PB_Gadget_ContainerCoordinate))-OffsetY
                ElseIf IsWindow(\Object)
                  X = DesktopMouseX()-OffsetX
                  Y = DesktopMouseY()-OffsetY
                EndIf
                
                ; Object resize
                Select EventGadget()
                  Case \ID[1]
                    iX=Match(X+(\Size-\Pos), \Grid, ObjectX1)
                    iWidth=ObjectX1-Match(X+(\Size-\Pos), \Grid, ObjectX1)
                    
                  Case \ID[2] 
                    iY=Match(Y+(\Size-\Pos), \Grid, ObjectY1)
                    iHeight=ObjectY1-Match(Y+(\Size-\Pos), \Grid, ObjectY1)
                    
                  Case \ID[3] 
                    iWidth=Match(X+\Pos, \Grid)-ObjectX0+Bool(\Grid>1)
                    
                  Case \ID[4] 
                    iHeight=Match(Y+\Pos, \Grid)-ObjectY0+Bool(\Grid>1)
                    
                  Case \ID[5]
                    iX=Match(X+(\Size-\Pos), \Grid, ObjectX1)
                    iY=Match(Y+(\Size-\Pos), \Grid, ObjectY1)
                    iWidth=ObjectX1-Match(X+(\Size-\Pos), \Grid, ObjectX1)
                    iHeight=ObjectY1-Match(Y+(\Size-\Pos), \Grid, ObjectY1)
                    
                  Case \ID[6] 
                    iY=Match(Y+(\Size-\Pos), \Grid, ObjectY1)
                    iWidth=Match(X+\Pos, \Grid)-ObjectX0+Bool(\Grid>1)
                    iHeight=ObjectY1-Match(Y+(\Size-\Pos), \Grid, ObjectY1)
                    
                  Case \ID[7] 
                    iWidth=Match(X+\Pos, \Grid)-ObjectX0+Bool(\Grid>1)
                    iHeight=Match(Y+\Pos, \Grid)-ObjectY0+Bool(\Grid>1)
                    
                  Case \ID[8] 
                    iX=Match(X+(\Size-\Pos), \Grid, ObjectX1)
                    iHeight=Match(Y+\Pos, \Grid)-ObjectY0+Bool(\Grid>1)
                    iWidth=ObjectX1-Match(X+(\Size-\Pos), \Grid, ObjectX1)
                    
                  Case \ID[#Arrows] 
                    iX=Match((X-\Pos-2), \Grid)
                    iY=Match(Y+(\Size-\Pos), \Grid)
                    
                EndSelect
                
                SetCoordinate(*This)
              Else
                ; PostEvent(#PB_Event_MouseMove, EventWindow(), #PB_Ignore)
                PostEvent(#PB_Event_Gadget, EventWindow(), #PB_Ignore, #PB_EventType_MouseMove, EventGadget())
              EndIf
          EndSelect
        EndWith
    EndSelect
    
  EndProcedure
  
  Procedure Create(Object.i, Parent.i, Window.i=-1, Item.i=0, Grid.i=1, Flags.i=#Anchor_All)
    Static ParentGrid=1
    If Grid<1 : Grid=1 : EndIf
    Protected *This.Transformation
    Protected *Flags.DataBuffer = ?FlagsBuffer
    Protected *Cursors.DataBuffer = ?CursorsBuffer
    Protected ID.i, I.i, UseGadgetList.i
    
    If IsGadget(Parent)
      OpenGadgetList(Parent, Item)
    ElseIf IsWindow(Parent)
      UseGadgetList = UseGadgetList(WindowID(Parent))
    EndIf
    
    If Bool(IsGadget(Object)|IsWindow(Object))
      ForEach AnChor()
        If AnChor()\Object = Object
          Delete()
        EndIf
      Next
      
      *This = AddElement(AnChor())
      If *This
        With *This
          \Object = Object
          If IsWindow(Object)
            If Not IsWindow(Window)
              \Window = Object
            EndIf
          Else
            \Window = Window
          EndIf
          \Parent = Parent
          \Item = Item
          \Size = 5
             
          If Not PopupMenu
            PopupMenu = CreatePopupImageMenu(#PB_Any)
            
            If PopupMenu
              MenuItem(#MenuItem_Block, "Block"          ) ; +Chr(9)+"Ctrl+B"
              MenuItem(#MenuItem_Delete, "Delete") ; +Chr(9)+"Ctrl+D"
            EndIf
            
            UnbindEvent(#PB_Event_Menu, @CallBack(), Object)
            BindEvent(#PB_Event_Menu, @CallBack(), Object)
          EndIf
          
          If IsGadget(Object)
            \Pos = 3
            \Grid = ParentGrid
          
            Select GadgetType(Object)
              Case #PB_GadgetType_Panel, 
                   #PB_GadgetType_Container, 
                   #PB_GadgetType_ScrollArea
               ParentGrid = Grid
            EndSelect
            
            ResizeGadget(Object, 
                         Match(GadgetX(Object), \Grid),
                         Match(GadgetY(Object), \Grid),
                         Match(GadgetWidth(Object), \Grid)+Bool(\Grid>1), 
                         Match(GadgetHeight(Object), \Grid)+Bool(\Grid>1))
            
          ElseIf IsWindow(Object)
            ParentGrid = Grid
            \Grid = ParentGrid
            \Pos = \Size
            ResizeWindow(Object,
                         Match(WindowX(Object), \Grid),
                         Match(WindowY(Object), \Grid), 
                         Match(WindowWidth(Object), \Grid)+Bool(\Grid>1), 
                         Match(WindowHeight(Object), \Grid)+Bool(\Grid>1))
            
              ; Точки в окне
            CompilerIf #PB_Compiler_OS = #PB_OS_Windows
              Points(Object, Grid)
            CompilerEndIf 
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
          
          If IsWindow(Object) : Hide(Object, #False) : EndIf
          
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            UpdateWindow_(UseGadgetList(0))
          CompilerEndIf 
          
          UnbindEvent(#PB_Event_LeftClick, @CallBack(), \Window)
          BindEvent(#PB_Event_LeftClick, @CallBack(), \Window)
        EndWith
      EndIf
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
 
  Procedure Free(Object.i)
    Protected I.i, Container.b
    
    If ListSize(AnChor())
      
      If IsGadget(Object)
        Select GadgetType(Object)
          Case #PB_GadgetType_Panel, 
               #PB_GadgetType_Container, 
               #PB_GadgetType_ScrollArea
            Container = #True  
        EndSelect
      ElseIf IsWindow(Object)
        Container = #True 
      EndIf
      
      If Container
        ForEach AnChor()
          If AnChor()\Parent = Object 
            If IsGadget(Object)
              Select GadgetType(AnChor()\Object)
                Case #PB_GadgetType_Panel,
                     #PB_GadgetType_Container, 
                     #PB_GadgetType_ScrollArea
                  Free(AnChor()\Object)
                Default
                  Delete()
              EndSelect
            Else
              Delete()
            EndIf
          EndIf
        Next
      EndIf
      
      ForEach AnChor()
        If AnChor()\Object = Object
          Delete()
          Break
        EndIf
      Next
      
      Lines() ; Reset show all lines
    EndIf
    
  EndProcedure
EndModule

;- Example
CompilerIf #PB_Compiler_IsMainFile
  UseModule Transformation
  
  Enumeration
    #Window
    #Transformation
    #EditorGadget
    #PanelGadget
    #ContainerGadget2
    #ButtonGadget
    #ImageGadget
    #TrackBarGadget
    #SpinGadget
    #ImageGadget1
  EndEnumeration
  
  Global Gadget =- 1
  
  Procedure OpenWindow_0()
    OpenWindow(#Window, 0, 0, 600, 400, "WindowTitle", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
    EditorGadget(#EditorGadget, 50, 100, 200, 50, #PB_Editor_WordWrap) : SetGadgetText(#EditorGadget, "Grumpy wizards make toxic brew for the evil Queen and Jack.")
    
    PanelGadget(#PanelGadget, 20, 200, 250, 175)
    AddGadgetItem(#PanelGadget,-1,"Panel_1")
    ContainerGadget(#ContainerGadget2, 10, 10, 200, 125, #PB_Container_Flat)
    ButtonGadget(#ButtonGadget, 10, 10, 200, 25, "Hallo Welt!", #PB_Button_MultiLine)
    CloseGadgetList()
    AddGadgetItem(#PanelGadget,-1,"Panel_2")
    ImageGadget(#ImageGadget, 10, 10, 40, 40, 0, #PB_Image_Border)
    CloseGadgetList()
    
    TrackBarGadget(#TrackBarGadget, 350, 100, 200, 25, 0, 100) : SetGadgetState(#TrackBarGadget, 70)
    SpinGadget(#SpinGadget, 350, 180, 200, 25, 0, 100, #PB_Spin_Numeric) : SetGadgetState(#SpinGadget, 70)
    ImageGadget(#ImageGadget1, 350, 250, 200, 25, 0)
    
    If LoadImage(0, #PB_Compiler_Home + "Examples\Sources\Data\GeeBee2.bmp")    ; Измените 2-й параметр на путь/имя файла вашего изображения.
      SetGadgetState(#ImageGadget, ImageID(0))
      SetGadgetState(#ImageGadget1, ImageID(0))
    EndIf
    
    ButtonGadget(#Transformation, 20, 20, 150, 25, "Enable Transformation", #PB_Button_Toggle)
    SetGadgetData(#ImageGadget1, 999)
  EndProcedure
  
  OpenWindow_0()
  ;OpenGadgetList(#PanelGadget)
  Repeat
    
    Select WaitWindowEvent()
        
      Case #PB_Event_CloseWindow
        End
        
      Case #PB_Event_Repaint
        
      Case #PB_Event_Gadget
;         If IsGadget(EventGadget())
;           Select EventType()
;             Case #PB_EventType_Change
;               Debug EventGadget()
;               
;             Case #PB_EventType_LeftButtonDown
;               Debug "Is anchor "+Is(EventGadget());+" "+Object()
;               Gadget = EventGadget()
;               Define OffsetX = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseX)
;               Define OffsetY = GetGadgetAttribute(EventGadget(), #PB_Canvas_MouseY)
;             Case #PB_EventType_LeftButtonUp
;               Gadget =- 1
;             Case #PB_EventType_MouseMove
;               If IsGadget(Gadget) And Not Is(Gadget)
;                 Define X = DesktopMouseX()-(GadgetX(Gadget, #PB_Gadget_ScreenCoordinate)-GadgetX(Gadget, #PB_Gadget_WindowCoordinate))-OffsetX
;                 Define Y = DesktopMouseY()-(GadgetY(Gadget, #PB_Gadget_ScreenCoordinate)-GadgetY(Gadget, #PB_Gadget_WindowCoordinate))-OffsetY
;                 ResizeGadget(Gadget,X,Y,#PB_Ignore,#PB_Ignore)
;                 Update(Gadget)
;               EndIf               
;           EndSelect
;         EndIf
         
        Select EventGadget()
          Case #Transformation
            Select GetGadgetState(#Transformation)
              Case #False
                SetGadgetText(#Transformation, "Enable Transformation")
                Free(#Window)
                Free(#EditorGadget)
                Free(#ButtonGadget)
                Free(#TrackBarGadget)
                Free(#SpinGadget)
                Free(#ImageGadget1)
                Free(#PanelGadget)
                Free(#ContainerGadget2)
              Case #True
                SetGadgetText(#Transformation, "Disable Transformation")
                ; Create(#Window, 5, #Anchor_Position)
                Create(#Window, #Window, #Window, 0, 5, #Anchor_All)
                Create(#EditorGadget, #Window, #Window, 0, 5, #Anchor_All)
                ;                 OpenGadgetList(#ContainerGadget2)
                Create(#ButtonGadget, #ContainerGadget2, #Window, 0, 1, #Anchor_All)
                ;                 CloseGadgetList()
                Create(#TrackBarGadget, #Window, #Window, 0,1, #Anchor_Position|#Anchor_Horizontally)
                Create(#SpinGadget, #Window, #Window, 0,1, #Anchor_Position)
                Create(#ImageGadget1, #Window, #Window, 0,1, #Anchor_All)
                Create(#PanelGadget, #Window, #Window, 0,1, #Anchor_All)
                ;                 OpenGadgetList(#PanelGadget)
                Create(#ContainerGadget2, #PanelGadget, #Window, 0,10, #Anchor_All)
                Create(#ImageGadget, #PanelGadget, #Window, 1,1, #Anchor_All)
                ;                 CloseGadgetList()
            EndSelect
        EndSelect
        
    EndSelect
    
  ForEver
CompilerEndIf
