CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ Text element functions
Procedure TextElement( Element, X,Y,Width,Height, Text$ = "", Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_Text, Element, X,Y,Width,Height,Text$, #PB_Default,#PB_Default,#PB_Default, Flag)
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    If Radius : \This()\Radius = Radius : EndIf
    PopListPosition(\This())         
  EndWith
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure
;}

;-
; Text element example
CompilerIf #PB_Compiler_IsMainFile
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65, "Demo TextElement()") 
  If CreateToolBarElement(#PB_Any, Window, #PB_ToolBar_Large|#PB_ToolBar_InlineText)
    ToolBarElementStandardButton(0, #PB_ToolBarIcon_New)
    ToolBarElementStandardButton(1, #PB_ToolBarIcon_Open, 0, "Open" )
    ToolBarElementStandardButton(2, #PB_ToolBarIcon_Save)
    ToolBarElementSeparator()
    
    ToolBarElementStandardButton(3, #PB_ToolBarIcon_Print)
    ToolBarElementStandardButton(4, #PB_ToolBarIcon_PrintPreview)
    ToolBarElementStandardButton(5, #PB_ToolBarIcon_Find)
    ToolBarElementStandardButton(6, #PB_ToolBarIcon_Replace)
  EndIf
  
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  Global Text$ = "строка_1"+Chr(10)+
                  "строка__2"+Chr(10)+
                  "строка___3 эта"+Chr(10)+; длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
                  "строка_4"+#CRLF$
  
  SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality)))
  TextGadget(#PB_Any, 10+1,40+h+1,200,90, Text$) : TextGadget(#PB_Any, 10+1,10+h+1,200,25, "aligment left")
  TextElement(#PB_Any, 220,40,200,90, Text$) : TextElement(#PB_Any, 220,10,200,25, "aligment left")
  
  TextGadget(#PB_Any, 10+1,65+60+40+h+1,200,90, Text$, #SS_CENTER) : TextGadget(#PB_Any, 10+1,65+60+10+h+1,200,25, "aligment center", #PB_Text_Center|#PB_Text_Border)
  TextElement(#PB_Any, 220,65+60+40,200,90, Text$, #_Flag_Text_Center) : TextElement(#PB_Any, 220,65+60+10,200,25, "aligment center", #_Flag_Text_Center|#_Flag_Double)
  
  TextGadget(#PB_Any, 10+1,130+120+40+h+1,200,90, Text$, #SS_RIGHT) : TextGadget(#PB_Any, 10+1,130+120+10+h+1,200,25, "aligment right", #PB_Text_Right)
  TextElement(#PB_Any, 220,130+120+40,200,90, Text$, #_Flag_Text_Right) : TextElement(#PB_Any, 220,130+120+10,200,25, "aligment right", #_Flag_Text_Right)
  
  Define g = TextGadget(#PB_Any, 10+1,195+180+40+h+1,200,90, Text$)
  Define e = TextElement(#PB_Any, 220,195+180+40,200,90, Text$)
  
  DisableGadget(g, #True) : DisableGadget(TextGadget(#PB_Any, 10+1,195+180+10+h+1,200,25, "aligment right"), #True)
  DisableElement(e, #True) : DisableElement(TextElement(#PB_Any, 220,195+180+10,200,25, "aligment right"), #True)
  
  ;BindGadgetElementEvent(e, @TextElementEvent())
  WaitWindowEventClose(Window)
CompilerEndIf

