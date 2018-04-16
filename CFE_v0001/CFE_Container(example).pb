CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
  
  #E_Container_BorderLess  = #_Flag_BorderLess   ; Without any border (Default).
  #E_Container_Flat        = #_Flag_Flat         ; Flat frame.
  #E_Container_Raised      = #_Flag_Raised       ; Raised frame.
  #E_Container_Single      = #_Flag_Single       ; Single sunken frame.
  #E_Container_Double      = #_Flag_Double       ; Double sunken frame.
  #E_Container_Transparent = #_Flag_Transparent  ; Back color
CompilerEndIf


;{ Container element functions

Procedure.q SetContainerElementFlag(Flag.q)
  Protected Result.q = Flag
  ; 0 - #PB_Container_BorderLess          ; Without any border (Default).
  ; 1 - #PB_Container_Flat                ; Flat frame.
  ; 2 - #PB_Container_Raised              ; Raised frame.
  ; 4 - #PB_Container_Single              ; Single sunken frame.
  ; 8 - #PB_Container_Double              ; Double sunken frame.
  ; 16 - Flag | #PB_Container_Transparent ; Back color
  
; ; ;   Select Flag
; ; ;     Case #PB_Container_BorderLess 
; ; ;       Result = #_Flag_BorderLess
; ; ;     Default
; ; ;       If ((Flag & #PB_Container_Flat) = #PB_Container_Flat)
; ; ;         Result = #_Flag_Flat
; ; ;       ElseIf ((Flag & #PB_Container_Single) = #PB_Container_Single)
; ; ;         Result = #_Flag_Single
; ; ;       ElseIf ((Flag & #PB_Container_Double) = #PB_Container_Double)
; ; ;         Result = #_Flag_Double
; ; ;       ElseIf ((Flag & #PB_Container_Raised) = #PB_Container_Raised)
; ; ;         Result = #_Flag_Raised
; ; ;       EndIf
; ; ;   EndSelect
; ; ;   
; ; ;   If ((Flag & #PB_Container_Transparent) = #PB_Container_Transparent)
; ; ;     Result | #_Flag_Transparent 
; ; ;   EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetContainerElementFlag(Flag.q)
  Protected Result.q = Flag
  
; ; ;   If ((Flag & #_Flag_BorderLess) = #_Flag_BorderLess)
; ; ;     Result = #PB_Container_BorderLess
; ; ;   ElseIf ((Flag & #_Flag_Flat) = #_Flag_Flat)
; ; ;     Result = #PB_Container_Flat
; ; ;   ElseIf ((Flag & #_Flag_Single) = #_Flag_Single)
; ; ;     Result = #PB_Container_Single
; ; ;   ElseIf ((Flag & #_Flag_Double) = #_Flag_Double)
; ; ;     Result = #PB_Container_Double
; ; ;   ElseIf ((Flag & #_Flag_Raised) = #_Flag_Raised)
; ; ;     Result = #PB_Container_Raised
; ; ;   EndIf
; ; ;   
; ; ;   If ((Flag & #_Flag_Transparent) = #_Flag_Transparent)
; ; ;     Result | #PB_Container_Transparent
; ; ;   EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure ContainerElement(Element, X,Y,Width,Height, Flag.q = #_Flag_Flat, Parent =- 1)
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement(#_Type_Container, Element, X,Y,Width,Height,"",
                           #PB_Default,#PB_Default,#PB_Default, SetContainerElementFlag(Flag))
  
;   SelectElement(*CreateElement\This(), Element(Element))
;   Debug *CreateElement\This()\bSize
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; Container element example
CompilerIf #PB_Compiler_IsMainFile
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65, "Demo StringElement()") 
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  
  ContainerGadget(#PB_Any, 10+1,10+h+1,200,90, #PB_Container_BorderLess) : CloseGadgetList()
  ContainerElement(#PB_Any, 220,10,200,90, #_Flag_BorderLess) : CloseElementList()
  
  ContainerGadget(#PB_Any, 10+1,65+30+10+h+1,200,90, #PB_Container_Flat) : CloseGadgetList()
  ContainerElement(#PB_Any, 220,65+30+10,200,90, #_Flag_Flat) : CloseElementList() 
  
  ContainerGadget(#PB_Any, 10+1,130+60+10+h+1,200,90, #PB_Container_Single) : CloseGadgetList() 
  ContainerElement(#PB_Any, 220,130+60+10,200,90, #_Flag_Single) : CloseElementList() ; |#_Flag_Transparent
  
  ContainerGadget(#PB_Any, 10+1,105+180+10+h+1,200,90, #PB_Container_Double) : CloseGadgetList()
  ContainerElement(#PB_Any, 220,105+180+10,200,90, #_Flag_Double) : CloseElementList()
  
  Define g=ContainerGadget(#PB_Any, 10+1,200+180+10+h+1,200,90, #PB_Container_Raised) : CloseGadgetList()
  Define e=ContainerElement(#PB_Any, 220,200+180+10,200,90, #_Flag_Raised) : CloseElementList()
  
  DisableGadget(g, #True)
  DisableElement(e, #True)
  
  Debug "element flag: "+GetElementFlag(e)
  Debug "gadget element flag: "+GetGadgetElementFlag(e)
  
  ;BindGadgetElementEvent(e, @StringElementEvent())
  WaitWindowEventClose(Window)
CompilerEndIf

