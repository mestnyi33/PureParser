CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "CFE.pbi"
CompilerEndIf

;{ - StringElement
;-
Procedure StringElement( Element, X,Y,Width,Height, Text.S = "", Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_String, Element, X,Y,Width,Height,Text, #PB_Default,#PB_Default,#PB_Default, Flag|#_Flag_Editable|#_Flag_Border);|#_Flag_Text_Center|#_Flag_Text_Left  )
  SetElementText( Element, Text )
  
  If Radius
    With *CreateElement
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      \This()\Radius = Radius
      ;\This()\FrameColor = $858585;$A0A0A0
      ;\This()\bSize = 4
      ;ResizeElement(\This()\Element, \This()\FrameCoordinate\X, \This()\FrameCoordinate\Y, \This()\FrameCoordinate\Width, \This()\FrameCoordinate\Height, #PB_Ignore)
      PopListPosition(\This())
    EndWith
  EndIf
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure
;}

;-
; String element example
CompilerIf #PB_Compiler_IsMainFile
  Procedure StringElementEvent(Event.q, EventElement)
    Debug EventClass(ElementEvent())
  EndProcedure
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 430,255, "Demo StringElement()") 
  
  Define  t = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality)))
  Define g = StringGadget(#PB_Any, 10+1,40+t+1,200,25, "String") : TextGadget(#PB_Any, 10+1,10+t+1,200,25, "aligment left")
  Define e = StringElement(#PB_Any, 220,40,200,25, "String") : TextElement(#PB_Any, 220,10,200,25, "aligment left")
  
  StringGadget(#PB_Any, 10+1,60+40+t+1,200,25, "String", #SS_CENTER) : TextGadget(#PB_Any, 10+1,60+10+t+1,200,25, "aligment center", #PB_Text_Center)
  StringElement(#PB_Any, 220,60+40,200,25, "String", #_Flag_Text_Center) : TextElement(#PB_Any, 220,60+10,200,25, "aligment center", #_Flag_Text_Center)
  
  StringGadget(#PB_Any, 10+1,120+40+t+1,200,25, "String", #SS_RIGHT) : TextGadget(#PB_Any, 10+1,120+10+t+1,200,25, "aligment right", #PB_Text_Right)
  StringElement(#PB_Any, 220,120+40,200,25, "String", #_Flag_Text_Right) : TextElement(#PB_Any, 220,120+10,200,25, "aligment right", #_Flag_Text_Right)
  
  DisableGadget(StringGadget(#PB_Any, 10+1,180+40+t+1,200,25, "String"), #True) : DisableGadget(TextGadget(#PB_Any, 10+1,180+10+t+1,200,25, "aligment right"), #True)
  DisableElement(StringElement(#PB_Any, 220,180+40,200,25, "String"), #True) : DisableElement(TextElement(#PB_Any, 220,180+10,200,25, "aligment right"), #True)
  
  BindGadgetElementEvent(e, @StringElementEvent(), #_Event_Change);, #_Event_Focus|#_Event_LostFocus)
  WaitWindowEventClose(Window)
CompilerEndIf

