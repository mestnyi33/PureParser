CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ Editor element functions


Procedure EditorElement( Element, X,Y,Width,Height, Text$ = "", Flag = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_Editor, Element, X,Y,Width,Height,Text$, #PB_Default,#PB_Default,#PB_Default, Flag|#_Flag_Flat|#_Flag_Editable|#_Flag_MultiLine|#_Flag_Text_Top )
  SetElementText( Element, Text$ )
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure
;}

;-
; Editor element example
CompilerIf #PB_Compiler_IsMainFile
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65, "Demo StringElement()") 
  If CreateToolBarElement(#PB_Any, Window, #PB_ToolBar_Large)
    ToolBarElementStandardButton(0, #PB_ToolBarIcon_New)
    ToolBarElementStandardButton(1, #PB_ToolBarIcon_Open, 0, "Open" )
    ToolBarElementStandardButton(2, #PB_ToolBarIcon_Save)
    ToolBarElementSeparator()
    
    ToolBarElementStandardButton(3, #PB_ToolBarIcon_Print)
    ToolBarElementStandardButton(4, #PB_ToolBarIcon_PrintPreview)
    ToolBarElementStandardButton(5, #PB_ToolBarIcon_Find)
    ToolBarElementStandardButton(6, #PB_ToolBarIcon_Replace)
  EndIf
  
  Define  h = GetElementAttribute(Window, #_Element_CaptionHeight)
  
  Global Text.S = "строка_1"+Chr(10)+
                  "строка__2"+Chr(10)+
                  "строка___3 эта"+Chr(10)+; длиняя строка оказалась ну, очень длиной, поэтому будем его переносить"+Chr(10)+
                  "строка_4"+#CRLF$
  
  SetGadgetFont(#PB_Default, FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality)))
  AddGadgetItem(EditorGadget(#PB_Any, 10+1,40+h+1,200,90), -1, Text) : TextGadget(#PB_Any, 10+1,10+h+1,200,25, "aligment left")
  EditorElement(#PB_Any, 220,40,200,90, Text) : TextElement(#PB_Any, 220,10,200,25, "aligment left")
  
  AddGadgetItem(EditorGadget(#PB_Any, 10+1,65+60+40+h+1,200,90, #SS_CENTER), -1, Text) : TextGadget(#PB_Any, 10+1,65+60+10+h+1,200,25, "aligment center", #PB_Text_Center)
  EditorElement(#PB_Any, 220,65+60+40,200,90, Text, #_Flag_Text_Center) : TextElement(#PB_Any, 220,65+60+10,200,25, "aligment center", #_Flag_Text_Center)
  
  AddGadgetItem(EditorGadget(#PB_Any, 10+1,130+120+40+h+1,200,90, #SS_RIGHT), -1, Text) : TextGadget(#PB_Any, 10+1,130+120+10+h+1,200,25, "aligment right", #PB_Text_Right)
  EditorElement(#PB_Any, 220,130+120+40,200,90, Text, #_Flag_Text_Right) : TextElement(#PB_Any, 220,130+120+10,200,25, "aligment right", #_Flag_Text_Right)
  Define g=EditorGadget(#PB_Any, 10+1,195+180+40+h+1,200,90) : AddGadgetItem(g, -1, Text)
  
  DisableGadget(g, #True) : DisableGadget(TextGadget(#PB_Any, 10+1,195+180+10+h+1,200,25, "aligment right"), #True)
  DisableElement(EditorElement(#PB_Any, 220,195+180+40,200,90, Text), #True) : DisableElement(TextElement(#PB_Any, 220,195+180+10,200,25, "aligment right"), #True)
  
  ;BindGadgetElementEvent(e, @StringElementEvent())
  WaitWindowEventClose(Window)
CompilerEndIf

