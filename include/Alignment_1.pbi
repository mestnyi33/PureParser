CompilerIf #PB_Compiler_IsMainFile
  CompilerIf Not Defined(Constant, #PB_Module)
    DeclareModule Constant
      Enumeration #PB_EventType_FirstCustomValue
        #PB_EventType_Move
        #PB_EventType_Size
      EndEnumeration
    EndDeclareModule
    
    Module Constant
    EndModule 
    
    UseModule Constant
  CompilerEndIf
CompilerEndIf

DeclareModule Alignment
  ;############################################################################################################################
  ;   Module: Alignment
  ;   info: Automatic resizing of gadgets - pf shadoko - 2016 
  ;   Update by mestnyi - 2017
  ;
  ;   Additional parameters: rx And ry match the type of resizing:
  ;   rx / ry = 0: no change
  ;   rx / ry = 1: modification of the x / y position
  ;   rx / ry = 2: changing the width / height size
  ;   rx / ry = 3: modification of the x / y position center
  ;   rx / ry = 6: proportional positioning
  ;   rx / ry = 4: proportional positioning one side)
  ;   rx / ry = 5: proportional positioning of the other side)
  ;   rx / ry = 11: proportional modification of the x / y position
  ;   rx / ry = 22: proportional changing the width / height size
  ;   auto = 1 docking gadget
  ;
  ;   To use:
  ;   - Include this source file.
  ;   - Call Register ONCE for EACH Gadget to be resized, specifying side locks.
  ;############################################################################################################################
  EnableExplicit
  
  #Aligment_Full = 5  
  EnumerationBinary 8
    #Aligment_Left   
    #Aligment_Top    
    #Aligment_Right  
    #Aligment_Bottom 
    #Aligment_Center
    #Aligment_Client
    #Aligment_MoveProportional
    #Aligment_SizeProportional
  EndEnumeration
  
  Structure Struct
    auto.b
    g.i : p.i            ;gadgetID
    rx.b : ry.b          ;type of resize
    x.w : y.w            ;position of origin
    w.w : h.w            ;dimension of origin
    _g.i                 ; default
    _x.w : _y.w          ;position of default
    _w.w : _h.w          ;dimension of default
    Map Glist.s()        ;list of contained gadgets  (for containers)
  EndStructure
  
  Declare GetAdress(g)
  Declare Value(g)
  Declare.s String(g)
  Declare Dock(g,mode.b)
  Declare Align(g,mode.w)
  Declare UnRegister(g)
  Declare Register(g, rx.b,ry.b, auto.b=0)
EndDeclareModule

Module Alignment
  UseModule Constant
  
  Global NewMap RS.Struct()
  
  Procedure.s K(g)
    Protected k.s
    
    If IsGadget(g) 
      k.s = "G"+Str(g)
    ElseIf IsWindow(g)  
      k.s = "W"+Str(g)
    EndIf
    
    ProcedureReturn k.s ; FindMapElement(RS(), k.s)
  EndProcedure
  
  Procedure GetAdress(g)
    ProcedureReturn FindMapElement(RS(), K(g))
  EndProcedure
  
  Procedure Dock(g,mode.b)
    Protected rx,ry
    
    If mode = 1 : rx=0 : ry=2 : EndIf ; "Left" 
    If mode = 2 : rx=2 : ry=0 : EndIf ; "Top" 
    If mode = 3 : rx=1 : ry=2 : EndIf ; "Right" 
    If mode = 4 : rx=2 : ry=1 : EndIf ; "Bottom"
    If mode = 5 : rx=2 : ry=2 : EndIf ; "Full" 
    
    ProcedureReturn Register(g,rx,ry,#True)
  EndProcedure
  
  Procedure Align(g,mode.w)
    Protected.b rx,ry,mx,my,auto
    
    If mode = 1 : rx=0 : ry=2 : auto=1
    ElseIf mode = 2 : rx=2 : ry=0 : auto=1
    ElseIf mode = 3 : rx=1 : ry=2 : auto=1
    ElseIf mode = 4 : rx=2 : ry=1 : auto=1
    ElseIf ((mode&#Aligment_Full)=#Aligment_Full) : auto=1
      If ((mode&#Aligment_Left)=#Aligment_Left)
        rx=0 : ry=2
      ElseIf ((mode&#Aligment_Top)=#Aligment_Top)
        rx=2 : ry=0
      ElseIf ((mode&#Aligment_Right)=#Aligment_Right)
        rx=1 : ry=2
      ElseIf ((mode&#Aligment_Bottom)=#Aligment_Bottom)
        rx=2 : ry=1
      Else
        rx=2 : ry=2
      EndIf
    Else
      If ((mode&#Aligment_Center)=#Aligment_Center)
        rx=3 : ry=3
        mx=3 : my=3
      ElseIf ((mode&#Aligment_SizeProportional)=#Aligment_SizeProportional)
        rx=4 : ry=4
        mx=4 : my=4
      Else
        mx=0 : my=1
      EndIf
      If ((mode&#Aligment_Left)=#Aligment_Left)
        rx=0 : ry=my
      EndIf
      If ((mode&#Aligment_Top)=#Aligment_Top)
        rx=mx : ry=0
      EndIf
      If ((mode&#Aligment_Right)=#Aligment_Right)
        rx=1 : ry=mx
      EndIf
      If ((mode&#Aligment_Bottom)=#Aligment_Bottom)
        rx=my : ry=1
      EndIf
      If ((mode&#Aligment_Client)=#Aligment_Client)
        rx=2 : ry=2
      EndIf
    EndIf 
    
    ProcedureReturn Register(g,rx,ry,auto)
  EndProcedure

  Procedure.s String(g)
    Protected Result.s = "None"
    
    With RS()
      If GetAdress(g) 
        If \auto  ; Dock
          If \rx=0 And \ry=2 : Result = "Left" : EndIf
          If \rx=2 And \ry=0 : Result = "Top" : EndIf 
          If \rx=1 And \ry=2 : Result = "Right" : EndIf
          If \rx=2 And \ry=1 : Result = "Bottom" : EndIf
          If \rx=2 And \ry=2 : Result = "Full" : EndIf
        EndIf
      EndIf
      
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  Procedure Value(g)
    Protected Result
    
    With RS()
      If GetAdress(g) 
        If \auto  ; Dock
          If \rx=0 And \ry=2 : Result = 1 : EndIf ; "Left" 
          If \rx=2 And \ry=0 : Result = 2 : EndIf ; "Top" 
          If \rx=1 And \ry=2 : Result = 3 : EndIf ; "Right" 
          If \rx=2 And \ry=1 : Result = 4 : EndIf ; "Bottom"
          If \rx=2 And \ry=2 : Result = 5 : EndIf ; "Full" 
        EndIf
      EndIf
      
      ProcedureReturn Result
    EndWith
  EndProcedure
  
  
  
  Procedure Resize(*p.Struct, pw, ph)
    Protected r.f 
    Protected.w d,x1,y1,x2,y2
    Protected.w x,y,w,h
    
    Macro ResizeD(t, v1, V2, oV1, oV2, adV, ndV)
      d = ndV - adV
      r = ndV / adV 
      Select t
        Case 0  : v1 = oV1          : V2 = oV2
        Case 1  : v1 = oV1 + d      : V2 = oV2 + d     ; right & bottom
        Case 11 : v1 = oV1 + (d/r)  : V2 = oV2 + (d/r) ; proportional
        Case 2  : v1 = oV1          : V2 = oV2 + d  
        Case 22 : v1 = oV1          : V2 = oV2 + (d/r) ; proportional
        Case 3  : v1 = oV1 + d/2    : V2 = oV2 + d/2   ; center (right & bottom)
          
        Case 4  : v1 = oV1          : V2 = oV2 * r ; oV1+((oV2-oV1) * r)
        Case 5  : v1 = oV1 * r      : V2 = oV2 + d
        Case 6  : v1 = oV1 * r      : V2 = oV2 * r
      EndSelect
    EndMacro
    
    ForEach *p\Glist() 
      With RS(*p\Glist())
        If Bool(\rx Or \ry)
          ResizeD (\rx, x1, x2, \x, (\x+\w), *p\w, pw)
          ResizeD (\ry, y1, y2, \y, (\y+\h), *p\h, ph)
          
          If IsGadget(\g)
            ResizeGadget(\g, x1, y1, x2-x1, y2-y1)
            If x<>x1 Or y<>y1 : x=x1 : y=y1 : PostEvent(#PB_Event_Gadget, EventWindow(), \g, #PB_EventType_Move) : EndIf
            If w<>(x2-x1) Or h<>(y2-y1) : w=(x2-x1) : h=(y2-y1) : PostEvent(#PB_Event_Gadget, EventWindow(), \g, #PB_EventType_Size) : EndIf
          EndIf
        EndIf
      EndWith
    Next
    
  EndProcedure
  
  Procedure CallBack()
    Protected p=EventGadget(), iw, ih
    
    If IsGadget(p) 
      Select GadgetType(p) 
        Case #PB_GadgetType_ScrollArea
          iw = GetGadgetAttribute(p, #PB_ScrollArea_InnerWidth)
          ih = GetGadgetAttribute(p, #PB_ScrollArea_InnerHeight)
        Default
          iw = GadgetWidth(p)
          ih = GadgetHeight(p)
      EndSelect
      Resize(RS("G"+Str(p)), iw, ih)
    Else : p = EventWindow()
      Resize(RS("W"+Str(p)), WindowWidth(p), WindowHeight(p))
    EndIf
  EndProcedure
  
  Procedure AutoDock(*g.Struct, RS_w, RS_h, RS_gap_x=0, RS_gap_y=0)
    Protected p.s,Parent,Left,Top,Right,Bottom,RS_gap_w,RS_gap_h
    
    If MapSize(RS())
      RS_gap_w = RS_gap_x ; GadgetWidth(RS()\g)
      RS_gap_h = RS_gap_y ; GadgetHeight(RS()\g)
      
      If Not MapSize(*g\Glist())
        PushMapPosition(RS())
        With RS()
          ; top & bottom
          ForEach RS()
            If IsGadget(\g) And *g\g=\g
              If (\ry=0 And \rx=2) ; \Dock & #PB_Align_Top = #PB_Align_Top  
                \x = (RS_gap_x+Left)
                \y = (RS_gap_y+Top)
                \w = (RS_w-(RS_gap_x+RS_gap_w))
                ResizeGadget(\g, \x, \y, \w, #PB_Ignore) 
                Top + \h 
              EndIf
              
              If (\ry=1 And \rx=2) ; \Dock & #PB_Align_Bottom = #PB_Align_Bottom  
                Bottom + \h 
                \x = (RS_gap_x+Left)
                \y = ((RS_h-Bottom)-RS_gap_y)
                \w = ((RS_w-(Right+Left))-(RS_gap_x+RS_gap_w))
                ResizeGadget(\g, \x, \y, \w, #PB_Ignore) 
              EndIf
            EndIf
          Next 
          ; left & right
          ForEach RS()
            If IsGadget(\g) And *g\g=\g
              If (\rx=0 And \ry=2) ; \Dock & #PB_Align_Left = #PB_Align_Left
                \x = (RS_gap_x+Left)
                \y = (RS_gap_y+Top)
                \h = ((RS_h-(Top+Bottom))-(RS_gap_y+RS_gap_h))
                ResizeGadget(\g, \x, \y, #PB_Ignore, \h) 
                Left + \w  
              EndIf
              
              If (\rx=1 And \ry=2) ; \Dock & #PB_Align_Right = #PB_Align_Right 
                Right + \w
                \x = ((RS_w-Right)-RS_gap_x)
                \y = (RS_gap_y+Top)
                \h = ((RS_h-(Top+Bottom))-(RS_gap_y+RS_gap_h))
                ResizeGadget(\g, \x, \y, #PB_Ignore, \h) 
              EndIf
            EndIf
          Next 
          ; center
          ForEach RS()
            If IsGadget(\g) And *g\g=\g
              If (\rx=2 And \ry=2) ; (\Dock & #PB_Align_Full) = #PB_Align_Full
                \x = (RS_gap_x+Left)
                \y = (RS_gap_y+Top)
                \w = ((RS_w-(Right+Left))-(RS_gap_x+RS_gap_w))
                \h = ((RS_h-(Top+Bottom))-(RS_gap_y+RS_gap_h))
                ResizeGadget(\g,\x,\y,\w,\h) 
              EndIf
            EndIf
          Next 
        EndWith
        PopMapPosition(RS())
      EndIf 
      
      PushMapPosition(RS())
      With RS(*g\Glist())
        ; top & bottom
        ForEach *g\Glist()
          If IsGadget(\g) And *g\g<>\g 
            If (\ry=0 And \rx=2) ; \Dock & #PB_Align_Top = #PB_Align_Top  
              \x = (RS_gap_x+Left)
              \y = (RS_gap_y+Top)
              \w = (RS_w-(RS_gap_x+RS_gap_w))
              ResizeGadget(\g, \x, \y, \w, #PB_Ignore) 
              Top + \h 
            EndIf
            If (\ry=1 And \rx=2) ; \Dock & #PB_Align_Bottom = #PB_Align_Bottom  
              Bottom + \h 
              \x = (RS_gap_x+Left)
              \y = ((RS_h-Bottom)-RS_gap_y)
              \w = ((RS_w-(Right+Left))-(RS_gap_x+RS_gap_w))
              ResizeGadget(\g, \x, \y, \w, #PB_Ignore) 
            EndIf
          EndIf
        Next 
        ; left & right
        ForEach *g\Glist()
          If IsGadget(\g) And *g\g<>\g 
            If (\rx=0 And \ry=2) ; \Dock & #PB_Align_Left = #PB_Align_Left
              \x = (RS_gap_x+Left)
              \y = (RS_gap_y+Top)
              \h = ((RS_h-(Top+Bottom))-(RS_gap_y+RS_gap_h))
              ResizeGadget(\g, \x, \y, #PB_Ignore, \h) 
              Left + \w  
            EndIf
            If (\rx=1 And \ry=2) ; \Dock & #PB_Align_Right = #PB_Align_Right 
              Right + \w
              \x = ((RS_w-Right)-RS_gap_x)
              \y = (RS_gap_y+Top)
              \h = ((RS_h-(Top+Bottom))-(RS_gap_y+RS_gap_h))
              ResizeGadget(\g, \x, \y, #PB_Ignore, \h) 
            EndIf
          EndIf
        Next 
        ; center
        ForEach *g\Glist()
          If IsGadget(\g) And *g\g<>\g And (\rx=2 And \ry=2) ; (\Dock & #PB_Align_Full) = #PB_Align_Full
            \x = (RS_gap_x+Left)
            \y = (RS_gap_y+Top)
            \w = ((RS_w-(Right+Left))-(RS_gap_x+RS_gap_w))
            \h = ((RS_h-(Top+Bottom))-(RS_gap_y+RS_gap_h))
            ResizeGadget(\g,\x,\y,\w,\h) 
          EndIf
        Next 
      EndWith
      PopMapPosition(RS())
      
    EndIf
  EndProcedure
  
  Procedure Register(g, rx.b,ry.b, Auto.b=0)
    Static w=-1, k.s
    Protected gi.Struct, tg.s, iw,ih
    Protected *g.Struct = RS(k.s), p=Val(Trim(Trim(k.s, "G"), "W"))
    
    With gi
      Macro Coordinate(_type_, _g_)
        _g_\x = _type_#X(_g_\g)
        _g_\w = _type_#Width(_g_\g)
        _g_\y = _type_#Y(_g_\g)
        _g_\h = _type_#Height(_g_\g)
        
        If *g\_g<>_g_\g 
          *g\_g = _g_\g
          *g\_x = _g_\x
          *g\_y = _g_\y
          *g\_w = _g_\w
          *g\_h = _g_\h
        ElseIf Auto
          _g_\x = *g\_x
          _g_\w = *g\_w
          _g_\y = *g\_y
          _g_\h = *g\_h
          Resize#_type_(_g_\g, _g_\x, _g_\y, _g_\w, _g_\h)
        EndIf
      EndMacro
      
      \g=g : \rx=rx : \ry=ry : \p=p : \auto = Auto
      
      If IsGadget(\g)
        tg="G"+Str(\g)
        Coordinate(Gadget,gi)
        RS(k.s)\Glist(tg)=tg
        
        Select GadgetType(\g) 
          Case #PB_GadgetType_Container, #PB_GadgetType_Panel, #PB_GadgetType_ScrollArea
            If Bool((k.s <> tg) Or Not (\rx And \ry))
              UnbindGadgetEvent(\g, @CallBack(), #PB_EventType_Resize)
              If Bool(\rx Or \ry) 
                ;PostEvent(#PB_Event_Gadget, w, \g, #PB_EventType_Resize)
                BindGadgetEvent(\g, @CallBack(), #PB_EventType_Resize)
                k.s = tg
              EndIf
            EndIf
        EndSelect
       
      ElseIf IsWindow(\g)  
        tg="W"+Str(\g)
        Coordinate(Window,gi)
        UnbindEvent(#PB_Event_SizeWindow, @CallBack(), \g)
        ;PostEvent(#PB_Event_SizeWindow, \g, #PB_Ignore)
        If Bool(\rx Or \ry) : BindEvent(#PB_Event_SizeWindow, @CallBack(), \g) : EndIf
        k.s = tg
        w = \g
      Else
        \g = ExamineDesktops()-1
        tg="D"+Str(\g)
        \x = DesktopX(\g)
        \y = DesktopY(\g)
        \w = DesktopWidth(\g)
        \h = DesktopHeight(\g)
        k.s = tg
      EndIf
    EndWith
    
    If FindMapElement(RS(), tg)
      With RS()
        \rx=rx : \ry=ry : \auto = Auto
        If IsGadget(\g) 
          Coordinate(Gadget,RS()) 
        ElseIf IsWindow(\g) 
          Coordinate(Window,RS()) 
        EndIf
        
        ; При изменении привязки гаджета
        ; обнавляем координати родителя так как 
        ; они могли быть изменени пользователем
        PushMapPosition(RS())
        If FindMapElement(RS(), k)
          If IsGadget(\g) 
            \x = GadgetX(\g)
            \w = GadgetWidth(\g)
            \y = GadgetY(\g)
            \h = GadgetHeight(\g)
          ElseIf IsWindow(\g) 
            \x = WindowX(\g)
            \w = WindowWidth(\g)
            \y = WindowY(\g)
            \h = WindowHeight(\g)
          EndIf
        EndIf
        PopMapPosition(RS())
      EndWith
    Else
      RS(tg)=gi
    EndIf
    
    If Auto
      If IsGadget(p)
        Select GadgetType(p) 
          Case #PB_GadgetType_Container
            iw = GadgetWidth(p)-2
            ih = GadgetHeight(p)-2
          Case #PB_GadgetType_Panel
            iw = GetGadgetAttribute(p, #PB_Panel_ItemWidth)
            ih = GetGadgetAttribute(p, #PB_Panel_ItemHeight)
          Case #PB_GadgetType_ScrollArea
            iw = GetGadgetAttribute(p, #PB_ScrollArea_InnerWidth)
            ih = GetGadgetAttribute(p, #PB_ScrollArea_InnerHeight)
        EndSelect
      ElseIf IsWindow(p)
        iw = WindowWidth(p)
        ih = WindowHeight(p)
      Else
        iw = DesktopWidth(p)-380 ; bug
        ih = DesktopHeight(p)-250; bug
      EndIf   
      
      AutoDock(RS(k), iw, ih)
      
      With RS()
        PushMapPosition(RS())
        FindMapElement(RS(), tg)
        If IsGadget(\g)
          If \x<>*g\_x Or \y<>*g\_y : PostEvent(#PB_Event_Gadget, w, \g, #PB_EventType_Move) : EndIf
          If \w<>*g\_w Or \h<>*g\_h : PostEvent(#PB_Event_Gadget, w, \g, #PB_EventType_Size) : EndIf
        EndIf
        PopMapPosition(RS())
      EndWith
    EndIf
    
    ProcedureReturn gi
  EndProcedure
  
  Procedure UnRegister(g)
    Protected *g.Struct = Register(g,0,0,0)
    ProcedureReturn DeleteMapElement(RS(), Str(*g))
  EndProcedure
EndModule


;-
;- Alignment_Use - Use resizing Parent
CompilerIf #PB_Compiler_IsMainFile
  
  UseModule Alignment
  
  Procedure ResizeDemos()
    Select EventType()
      Case #PB_EventType_Move
        Debug "PB_EventType_Move "+EventGadget() +" "+ Alignment::Value(EventGadget())
      Case #PB_EventType_Size
        Debug "PB_EventType_Size "+EventGadget() +" "+ Alignment::Value(EventGadget())
    EndSelect
  EndProcedure
  
  Procedure ScrollAreaEvents()
    If IsGadget(100) And GetGadgetAttribute(100, #PB_ScrollArea_InnerWidth)<>GadgetWidth(100) Or 
       GetGadgetAttribute(100, #PB_ScrollArea_InnerHeight)<>GadgetHeight(100) 
      
      
      SetGadgetAttribute(100, #PB_ScrollArea_InnerWidth, GadgetWidth(100))
      SetGadgetAttribute(100, #PB_ScrollArea_InnerHeight, GadgetHeight(100) )
    EndIf
  EndProcedure
  
  Procedure Demos(RS_window, In = 0, Mode = 0, X=0, Y=0, w=120, h=25 )
    OpenWindow(RS_window,#PB_Ignore,#PB_Ignore,390,300,"",#PB_Window_SystemMenu|#PB_Window_SizeGadget)
    WindowBounds(RS_window, WindowWidth(RS_window), WindowHeight(RS_window), #PB_Ignore, #PB_Ignore)
    
    ;       RS_Init(RS_window)
    
    ;Macro ButtonGadget : FrameGadget : EndMacro
    Register(RS_window,2,2) ; set parent
    Protected Width = WindowWidth(RS_window)
    Protected Height = WindowHeight(RS_window)
    Protected oy=5,ot = 5, ox=5
    
    
    If in =1
      oy = 16
      ox=16
      SetWindowTitle(RS_window, "gadgets in container")
      ContainerGadget(RS_window, 5, 5,WindowWidth(RS_window)-10,WindowHeight(RS_window)-10,#PB_Container_Flat )
    ElseIf in =2
      oy = 41
      ox=23
      SetWindowTitle(RS_window, "gadgets in Panel")
      PanelGadget(RS_window, 5, 5,WindowWidth(RS_window)-10,WindowHeight(RS_window)-10 ) :AddGadgetItem(RS_window,-1,"Panel1")
    ElseIf in =3
      oy = 16
      ox=16
      SetWindowTitle(RS_window, "gadgets in ScrollArea")
      ScrollAreaGadget(RS_window, 5, 5,WindowWidth(RS_window)-10,WindowHeight(RS_window)-10,400,300,0,#PB_ScrollArea_Flat )
      BindEvent(#PB_Event_SizeWindow, @ScrollAreaEvents(), RS_window)                                                                                                                               ;
    ElseIf in =4
      FrameGadget(RS_window, 5, 5,WindowWidth(RS_window)-10,WindowHeight(RS_window)-10,"Frame",#PB_Frame_Flat )
    Else
      SetWindowTitle(RS_window, "gadgets in window")
    EndIf
    
    If in
      Register(RS_window, 2,2)
    EndIf
    
    If Mode = 0
      SetWindowTitle(RS_window, "Demo align "+GetWindowTitle(RS_window))
      ; Align 
      ButtonGadget(RS_window+1, ot, (Height-h)/2, w, h,"left_center "+Str(RS_window+1))                     :Register(RS_window+1, 0,3) ;#PB_Align_Left   |#PB_Align_Center)
      ButtonGadget(RS_window+2, (Width-(ox-ot)-w)/2, ot, w, h,"top_center "+Str(RS_window+2))               :Register(RS_window+2, 3,0) ;#PB_Align_Top    |#PB_Align_Center)
      ButtonGadget(RS_window+3, (Width-w)-ox, (Height-h)/2, w, h,"right_center "+Str(RS_window+3))          :Register(RS_window+3, 1,3) ;#PB_Align_Right  |#PB_Align_Center)
      ButtonGadget(RS_window+4, (Width-(ox-ot)-w)/2, (Height-h)-oy, w, h,"bottom_center "+Str(RS_window+4)) :Register(RS_window+4, 3,1) ;#PB_Align_Bottom |#PB_Align_Center)
      ButtonGadget(RS_window+5, (Width-(ox-ot)-w)/2, (Height-h)/2, w, h,"center "+Str(RS_window+5))         :Register(RS_window+5, 3,3) ;#PB_Align_Center )
                                                                                                                                        ;       
      ButtonGadget(RS_window+6, ot, ot, w, h,"left_top "+Str(RS_window+6))                                  :Register(RS_window+6, 0,0) ;#PB_Align_Top)
      ButtonGadget(RS_window+7, (Width-w)-ox, ot, w, h,"right_top "+Str(RS_window+7))                       :Register(RS_window+7, 1,0) ;#PB_Align_Right)
      ButtonGadget(RS_window+8, (Width-w)-ox, (Height-h)-oy, w, h,"right_bottom "+Str(RS_window+8))         :Register(RS_window+8, 1,1) ;#PB_Align_Bottom)
      ButtonGadget(RS_window+9, ot, (Height-h)-oy, w, h,"left_bottom "+Str(RS_window+9))                    :Register(RS_window+9, 0,1) ;#PB_Align_Left)
      
    ElseIf Mode = 1
      SetWindowTitle(RS_window, "Demo auto dock "+GetWindowTitle(RS_window))
      ; Auto Dock
      ButtonGadget(RS_window+1, 0, 0, w, h,"left_full "+Str(RS_window+1))                                   :Register(RS_window+1, 0,2,1) ; #PB_Align_Left   |#PB_Align_Full)
      ButtonGadget(RS_window+3, 0, 0, w, h,"right_full "+Str(RS_window+3))                                  :Register(RS_window+3, 1,2,1) ; #PB_Align_Right  |#PB_Align_Full)
      ButtonGadget(RS_window+2, 0, 0, w, h,"top_full "+Str(RS_window+2))                                    :Register(RS_window+2, 2,0,1) ; #PB_Align_Top    |#PB_Align_Full)
      ButtonGadget(RS_window+4, 0, 0, w, h,"bottom_full "+Str(RS_window+4))                                 :Register(RS_window+4, 2,1,1) ; #PB_Align_Bottom |#PB_Align_Full)
      ButtonGadget(RS_window+14, 0, 0, w, h*2,"14bottom_full "+Str(RS_window+14))                           :Register(RS_window+14, 2,1,1); #PB_Align_Bottom |#PB_Align_Full)
      ButtonGadget(RS_window+5, 0, 0, w, h,"full")                                                          :Register(RS_window+5, 2,2,1) ; #PB_Align_Full   )
      
    Else
      SetWindowTitle(RS_window, "Demo dock "+GetWindowTitle(RS_window))
      ; Dock
      ButtonGadget(RS_window+1, ot, h+ot, w, Height-oy-h*2-(h+10)-ot,"left_full "+Str(RS_window+1))              :Register(RS_window+1, 0,2)  ; #PB_Align_Left   |#PB_Align_Full)
      ButtonGadget(RS_window+3, (Width-w)-oy, h+ot, w, Height-oy-h*2-(h+10)-ot,"right_full "+Str(RS_window+3))   :Register(RS_window+3, 1,2)  ; #PB_Align_Right  |#PB_Align_Full)
      ButtonGadget(RS_window+2, ot, ot, Width-oy-ot, h,"top_full "+Str(RS_window+2))                             :Register(RS_window+2, 2,0)  ; #PB_Align_Top    |#PB_Align_Full)
      ButtonGadget(RS_window+4, ot, (Height-h)-oy, Width-oy-ot, h,"bottom_full "+Str(RS_window+4))               :Register(RS_window+4, 2,1)  ; #PB_Align_Bottom |#PB_Align_Full)
      ButtonGadget(RS_window+14, ot, (Height-h-(h+10))-oy, Width-oy-ot, h+10,"14bottom_full "+Str(RS_window+14)) :Register(RS_window+14, 2,1) ; #PB_Align_Bottom |#PB_Align_Full)
      ButtonGadget(RS_window+5, w+ot, h+ot, Width-oy-w*2-ot, Height-oy-h*2-(h+10)-ot,"full")                     :Register(RS_window+5, 2,2)  ; #PB_Align_Full   )
      
    EndIf
    
    If in And in < 4 : CloseGadgetList() : EndIf
    
    ; BindEvent(#PB_Event_SizeWindow, @ScrollAreaEvents(), RS_window)                                                                                                                               ;
    ; BindEvent(#PB_Event_Gadget, @ResizeDemos(), RS_window)
  EndProcedure   
  
  ; ;Demos(100,0,1,5,5)
      Demos(130,0,0,5,5)
  ; ; ;   ; container
  Demos(160,1,1,5,5)
  ; ;   ;   Demos(190,1,0,5,5)
  ; ;   ;; panel
  ; ;   ;Demos(250,2,1)
  ; ;   Demos(280,2)
  ; ;   ;     ; scrollarea
  ; ;   ;     Demos(310,3,1)
  ; ;        Demos(340,3)
  
  
  
  OpenWindow(10, 0, 0, 552, 250, "Resize gadget",#PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
  ;PanelGadget(2, 120, 20, 250, 130) : AddGadgetItem(2, -1,"Panel")
  ContainerGadget(20, 120, 20, 300, 180,#PB_Container_Flat)
  ButtonGadget(21, 10, 10, 80, 20, "l", #PB_Button_Toggle)
  ButtonGadget(22, 10, 60, 80, 20, "t", #PB_Button_Toggle)
  ButtonGadget(23, 10, 10, 80, 20, "r", #PB_Button_Toggle)
  ButtonGadget(24, 10, 60, 80, 20, "b", #PB_Button_Toggle)
  ButtonGadget(25, 210, 150, 80, 20, "c", #PB_Button_Toggle)
  ButtonGadget(26, 10, 60, 80, 20, "bb", #PB_Button_Toggle)
  CloseGadgetList()
  
  ; ;   Register(#PB_Default,2,2)
  ; ;   Register(10,1,2,1)
  Register(10,2,2)
  
  ;  Register(20,3,3)
  ;  Register(20,2,2)
  ;  Register(20,3,2)
  ;  Register(20,4,2)
  
  
  Register(20,2,2)
  
;   Register(21,0,2,1)
;   ;   Register(20,2,2)
;   Register(22,2,0,1)
;   ;Register(20,2,2)
;   Register(23,1,2,1)
;   ;Register(20,2,2)
;   Register(24,2,1,1)
;   ;Register(20,2,2)
;   Register(26,2,1,1)
;   ;Register(20,2,2)
  Align(25,#Aligment_Right|#Aligment_Center) ; 2,2,1)#Aligment_Center|
  
  ;   ; demo unregistr
  ;   Register(26,0,0,1) 
  ;   Register(20,2,2)
  
  BindEvent(#PB_Event_Gadget, @ResizeDemos(), 10)
  ; dock
  ; 0,2 = left
  ; 1,2 = right
  ; 2,0 = top
  ; 2,1 = bottom
  ;############################################################################################################################
  ;                                                 Exemple
  ;############################################################################################################################
  ;   OpenWindow(1110, 0, 0, 512, 200, "Resize gadget",#PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
  ;   ButtonGadget(1113, 10, 170, 80, 20, "Button / 3", #PB_Button_Toggle)
  ;   Dock("Top", 1113,1110)
  ;   ButtonGadget(1114, 10, 170, 80, 20, "Button / 4", #PB_Button_Toggle)
  ;   Dock("Right", 1114,1110)
  ;   ButtonGadget(1115, 10, 170, 80, 20, "Button / 5", #PB_Button_Toggle)
  ;   Dock("Right", 1115,1110)
  ;   ButtonGadget(1119, 10, 170, 80, 20, "Button / 5", #PB_Button_Toggle)
  ;   Dock("Bottom", 1119,1110)
  ;   
  CreateImage(0,200,60):StartDrawing(ImageOutput(0)):Define i:For i=0 To 200:Circle(100,30,200-i,(i+50)*$010101):Next:StopDrawing()
  
  OpenWindow(0, 0, 0, 512, 200, "Resize gadget",#PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
  WindowBounds(0, WindowWidth(0), WindowHeight(0), #PB_Ignore, #PB_Ignore)
  
  TextGadget(1, 10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized",#PB_Text_Center)
  ButtonImageGadget(3, 10, 70, 200, 60, ImageID(0))
  EditorGadget(2, 10,  140, 200, 20) : SetGadgetText(2,"Editor")
  ButtonGadget(4, 10, 170, 490, 20, "Button / toggle", #PB_Button_Toggle)
  TextGadget(5,220,10,190,20,"Text",#PB_Text_Center) : SetGadgetColor(5, #PB_Gadget_BackColor, $00FFFF)
  ContainerGadget(6, 220, 30, 190, 100,#PB_Container_Single) : SetGadgetColor(6, #PB_Gadget_BackColor, $cccccc) 
  EditorGadget(7, 10,  10, 170, 50) : SetGadgetText(7,"Editor")
  ButtonGadget(8, 10, 70, 80, 20, "Button") 
  ButtonGadget(9, 100, 70, 80, 20, "Button") 
  CloseGadgetList() 
  StringGadget(10, 220,  140, 190, 20, "String")
  ButtonGadget(11, 420,  10, 80, 80, "Bouton")
  CheckBoxGadget(12, 420,  90, 200, 20, "CheckBox")
  CheckBoxGadget(13, 420,  110, 200, 20, "CheckBox")
  CheckBoxGadget(14, 420,  130, 200, 20, "CheckBox")
  CheckBoxGadget(15, 420,  150, 200, 20, "CheckBox")
  
  Register(0,2,2)
  ; UnRegister(0)
  
  Register(2,0,2)
  Register(4,2,1)
  Register(5,2,0)
  Register(6,2,2)
  Register(7,2,2)
  Register(8,4,1)
  Register(9,5,1)
  Register(10,2,1)
  Register(11,1,2)
  Register(12,1,1)
  Register(13,1,1)
  Register(14,1,1)
  Register(15,1,1)
  
  
  Define direction = 1
  Define Width, Height
  
  Repeat
    gEvent= WaitWindowEvent()
    
    Select gEvent
      Case #PB_Event_CloseWindow
        gQuit= #True
        
      Case #PB_Event_Timer
        If Width < 512
          direction = 1
        ElseIf Width > 650
          direction =- 1
        EndIf
        ;         
        Width + direction
        Height + direction
        
        ResizeWindow(0, #PB_Ignore, #PB_Ignore, Width, Height)
       
      Case #PB_Event_Gadget
        
        Select EventGadget()
          Case 4
            Width = WindowWidth(0)
            Height = WindowHeight(0)
            
            If GetGadgetState(4)
              AddWindowTimer(0, 1, 100)
            Else
              RemoveWindowTimer(0, 1)
            EndIf
        EndSelect
        
    EndSelect
    
  Until gQuit
;   Repeat
;     
;     Select WaitWindowEvent() 
;       Case #PB_Event_CloseWindow
;         If WindowID(EventWindow()) = UseGadgetList(0)
;           End
;         Else
;           CloseWindow(EventWindow())
;           ;                         RS_Free(EventWindow())
;         EndIf
;     EndSelect
;     
;   ForEver
  ;                 UnuseModule RS_gadget
  
CompilerEndIf

; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -----------------
; EnableXP