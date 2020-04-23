EnableExplicit

;############################################################################################################################
;                             Automatic resizing of gadgets - pf shadoko - 2016
;
;   operation:
;   Instructions: OpenWindow, ButtonGadget, TextGadget, ..., CloseGadgetList
;   must be used With the suffix 'R'
;   2 additional parameters: rx And ry match the type of resizing:
;   rx / ry = 0: no change
;   rx / ry = 1: modification of the x / y position
;   rx / ry = 2: changing the width / height
;   rx / ry = 3: proportional positioning
;  (rx / ry = 4: proportional positioning one side) proportional stretching on the (right&bottom) side
;  (rx / ry = 5: proportional positioning of the other side) proportional position on the (left&top) side
;############################################################################################################################

Structure Struct
  g.i             ;gadgetID
  Map Glist.s()   ;list of contained gadgets  (for containers)
  X.w:  Y.w       ;position of origin
  dx.w: dy.w      ;dimension of origin
  rx.b : ry.b     ;type of resize
EndStructure

Global Dim GadgetCont.s(256), GadgetConti
Global NewMap RS.Struct()

Procedure Resize(c, nx, ny, n_w, n_h, t.s="G")
  Protected.w ox1,oy1, ox2,oy2, x1,y1, x2,y2
  Protected gi.Struct, o.Struct,  adx,ady,  r.f,d.w 
  
;   Macro ResizeD(t, v1, V2, oV1, oV2, adV, ndV)
;     d = ndV - adV
;     r = ndV / adV
;     Select t
;       Case 0: v1 = oV1:       V2 = oV2
;       Case 1: v1 = oV1 + d:   V2 = oV2 + d
;       Case 2: v1 = oV1:       V2 = oV2 + d
;       Case 3: v1 = oV1 * r:   V2 = oV2 * r
;       Case 4: v1 = oV1:       V2 = oV2 * r
;       Case 5: v1 = oV1 * r:   V2 = oV2 + d
;     EndSelect
;   EndMacro
  
  
      
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
    
  gi=RS(t+Str(c))
  
  ForEach gi\Glist()
    With RS(gi\Glist())
    If (\rx Or \ry)
      ox1 = \x
      ox2 = ox1 + \dx
      
      oy1 = \y
      oy2 = oy1 + \dy
      
      ResizeD (\rx, x1, x2, ox1, ox2, gi\dx, n_w)
      ResizeD (\ry, y1, y2, oy1, oy2, gi\dy, n_h)
      
      Resize (\g, x1, y1, x2 - x1, y2 - y1)
    EndIf
  EndWith
Next
  
  If t="G"
    ResizeGadget(c,nx, ny, n_w, n_h)
  EndIf
EndProcedure

Procedure Register(n,rx.b,ry.b)
  Static Parent.S
  Protected gi.Struct, tg.s
  
  With gi
    \g=n
    \rx=rx
    \ry=ry
    
    If IsGadget(\g) 
      tg="G"+Str(\g)
      RS(Parent.S)\Glist(tg)=tg
      
      \x = GadgetX(\g)
      \y = GadgetY(\g)
      \dx = GadgetWidth(\g)
      \dy = GadgetHeight(\g)
      
      Select GadgetType(\g) 
        Case #PB_GadgetType_Panel,
             #PB_GadgetType_Container,
             #PB_GadgetType_ScrollArea
          Parent.S = tg
      EndSelect
      
    Else 
      tg="W"+Str(\g)
      \x = WindowX(\g)
      \y = WindowY(\g)
      \dx = WindowWidth(\g)
      \dy = WindowHeight(\g)
      Parent.S = tg
      
    EndIf
    
    RS(tg)=gi
    
    ProcedureReturn \g
  EndWith
EndProcedure


;--------------------------------- window
Procedure WindowResizeEvent()
  Protected n=EventWindow()
  Resize(n,0,0,WindowWidth(n), WindowHeight(n),"W")
EndProcedure



;############################################################################################################################
;                                                 Exemple
;############################################################################################################################


CreateImage(0,200,60):StartDrawing(ImageOutput(0)):Define i:For i=0 To 200:Circle(100,30,200-i,(i+50)*$010101):Next:StopDrawing()

OpenWindow(0, 0, 0, 512, 200, "Resize gadget",#PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
Register(0,2,2)
BindEvent(#PB_Event_SizeWindow,@WindowResizeEvent(), 0)


TextGadget(1, 10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized",#PB_Text_Center)
ButtonImageGadget(3, 10, 70, 200, 60, ImageID(0))
EditorGadget(2, 10,  140, 200, 20):SetGadgetText(2,"Editor")
ButtonGadget(4, 10, 170, 490, 20, "Button / toggle", #PB_Button_Toggle)
TextGadget(5,220,10,190,20,"Text",#PB_Text_Center):SetGadgetColor(5, #PB_Gadget_BackColor, $00FFFF)
ContainerGadget(6, 220, 30, 190, 100,#PB_Container_Single):SetGadgetColor(6, #PB_Gadget_BackColor, $cccccc) 
  EditorGadget(7, 10,  10, 170, 50):SetGadgetText(7,"Editor")
  ButtonGadget(8, 10, 70, 80, 20, "Button") 
  ButtonGadget(9, 100, 70, 80, 20, "Button") 
CloseGadgetList() 
StringGadget(10, 220,  140, 190, 20, "String")
ButtonGadget(11, 420,  10, 80, 80, "Bouton")
CheckBoxGadget(12, 420,  90, 200, 20, "CheckBox")
CheckBoxGadget(13, 420,  110, 200, 20, "CheckBox")
CheckBoxGadget(14, 420,  130, 200, 20, "CheckBox")
CheckBoxGadget(15, 420,  150, 200, 20, "CheckBox")

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

OpenWindow(110, 0, 0, 512, 200, "Resize gadget",#PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
Register(110,2,2)
BindEvent(#PB_Event_SizeWindow,@WindowResizeEvent(), 110)


TextGadget(111, 10,  10, 200, 50, "Resize the window, the gadgets will be automatically resized",#PB_Text_Center)
ButtonImageGadget(113, 10, 70, 200, 60, ImageID(0))
EditorGadget(112, 10,  140, 200, 20):SetGadgetText(112,"Editor")
ButtonGadget(114, 10, 170, 490, 20, "Button / toggle", #PB_Button_Toggle)
TextGadget(115,220,10,190,20,"Text",#PB_Text_Center):SetGadgetColor(115, #PB_Gadget_BackColor, $00FFFF)
ContainerGadget(116, 220, 30, 190, 100,#PB_Container_Single):SetGadgetColor(116, #PB_Gadget_BackColor, $cccccc) 
  EditorGadget(117, 10,  10, 170, 50):SetGadgetText(117,"Editor")
  ButtonGadget(118, 10, 70, 80, 20, "Button") 
  ButtonGadget(119, 100, 70, 80, 20, "Button") 
CloseGadgetList() 
StringGadget(1110, 220,  140, 190, 20, "String")
ButtonGadget(1111, 420,  10, 80, 80, "Bouton")
CheckBoxGadget(1112, 420,  90, 200, 20, "CheckBox")
CheckBoxGadget(1113, 420,  110, 200, 20, "CheckBox")
CheckBoxGadget(1114, 420,  130, 200, 20, "CheckBox")
CheckBoxGadget(1115, 420,  150, 200, 20, "CheckBox")

Register(112,0,2)
Register(114,2,1)
Register(115,2,0)
Register(116,2,2)
Register(117,2,2)
Register(118,4,1)
Register(119,5,1)
Register(1110,2,1)
Register(1111,1,2)
Register(1112,1,1)
Register(1113,1,1)
Register(1114,1,1)
Register(1115,1,1)




Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = --
; EnableXP