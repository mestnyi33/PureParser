CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  EnumerationBinary (#PB_Window_BorderLess<<1)
    #PB_Window_Transparent 
  EndEnumeration
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ About element functions

Procedure AboutElementCallBack(Event.q, EventElement)
  With *CreateElement
    
    Select Event
      Case #_Event_Close
        DisableElement(GetElementData(EventWindowElement()), #False)
        CloseWindowElement(EventWindowElement())
        
      Case #_Event_LeftClick
        If GetElementData(EventElement) And (EventElement <> EventWindowElement())
          Select PeekS(GetElementData(EventElement))
            Case "Ok" 
              DisableElement(GetElementData(EventWindowElement()), #False)
              CloseWindowElement(EventWindowElement())
          EndSelect
        EndIf
        
      Case #_Event_Create
        If IsElement(EventElement) 
          PushListPosition(\This())
          SelectElement(\This(), Element(EventElement)) : \This()\Show = #True
          PopListPosition(\This())
        EndIf
        
    EndSelect
    
  EndWith
  
  ProcedureReturn 1
EndProcedure

Procedure AboutElement(Window=-1, Title.S="About...")
  Protected Element =- 1
  Protected OpenElementList = OpenElementList(0)
  
  With *CreateElement
    Define  CaptionHeight = GetElementAttribute(Window, #_Element_CaptionHeight)
    
    Element = OpenWindowElement(#PB_Any, (ElementWidth(Window)-300)/2,(ElementHeight(Window)-250+CaptionHeight)/2,300,250, Title, 0)
    StickyWindowElement(Element, #True)
    SetElementData(Element, Window)
    DisableElement(Window, #True)
    
    Protected logo = LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/PureBasicLogo.bmp")
    If IsImage(logo) : ResizeImage(logo, 280,50) : EndIf
    
    ImageElement(#PB_All, 5, 5, 290, 60, logo, #_Flag_Image_Center)
    TextElement(#PB_All, 5, 5+65, 290, 240-30-65, "Это попитка написать"+Chr(10)+
                                                  " визуальный конструктор"+Chr(10)+
                                                  " для Purebasic."+Chr(10)+
                                                  " Автор под ником: mestnyi.", #_Flag_Text_Center)
    
    SetElementData(ButtonElement(#PB_All, (ElementWidth(Element)-130)/2, ElementHeight(Element, #_Element_InnerCoordinate)-30, 130, 25, "Ok"), @"Ok")
    BindEventElement(@AboutElementCallBack(), Element)
  EndWith
  
  OpenElementList(OpenElementList)
  ProcedureReturn Element
EndProcedure
;}

;-
; About element example
CompilerIf #PB_Compiler_IsMainFile
  
  Procedure MenuItemEvent(Event.q, EventElement)
    Select EventElementItem()
      Case 1 : AboutElement(EventWindowElement())
      Case 2 : CloseWindowElement(EventWindowElement())
    EndSelect
  EndProcedure
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284, "Demo AboutElement()") 
  Define  h = GetElementAttribute(Window, #_Element_CaptionHeight)
  
  If CreateMenuElement(#PB_Any)
    MenuElementTitle("Menu")
    MenuElementItem(1, "About")
    MenuElementBar()
    MenuElementItem(2, "Quit")
    
    BindMenuElementEvent(MenuElement(), 1, @MenuItemEvent())
  EndIf
   
  ;AboutElement(Window)
  
  WaitWindowEventClose(Window)
CompilerEndIf

