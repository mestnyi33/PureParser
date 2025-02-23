CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ Window element functions
Global Window_0=-1, Window_0_Image_0=-1, Window_0_Button_0=-1, Window_0_Button_1=-1, Window_0_Button_2=-1
Global Window_0_OpenFile$, Window_0_0_Image=-1, Event_Element=-1, Properties_Image=-1, Properties_ImageBg=-1

Procedure CFE_Helper_Buttons_Events(Event.q, EventElement)
  Protected CheckedElement = *CreateElement\CheckedElement
  
  Select Event
    Case #_Event_Close
      CloseWindowElement(EventWindowElement())
      
    Case #_Event_LeftClick
      Select EventElement
        Case Window_0_Button_2
          CloseWindowElement(EventWindowElement())
          
        Case Window_0_Button_1 
          Window_0_0_Image = GetElementState(Window_0_Image_0)
          
          Select Event_Element ; IsWindowElement(*CreateElement\CheckedElement)
            Case Properties_ImageBg
              SetElementBackGroundImage(CheckedElement, Window_0_0_Image)
              
            Case Properties_Image
              If ElementWidth(CheckedElement) <> ImageWidth(Window_0_0_Image) And Not IsContainerElement(CheckedElement)
                
                If MessageRequester("Сообщение","Хотите изменить размер элемента?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
                  SetElementText(CheckedElement, "")
                  ResizeElement(CheckedElement, #PB_Ignore, #PB_Ignore, ImageWidth(Window_0_0_Image)+8+1, ImageHeight(Window_0_0_Image)+8+1)
                EndIf
                
              EndIf
              
              SetElementImage(CheckedElement, Window_0_0_Image)
          EndSelect
          
          SetElementText(Event_Element, Window_0_OpenFile$)
          *CreateElement\ImagePuch(Str(Window_0_0_Image)) = Window_0_OpenFile$
          
          CloseWindowElement(EventWindowElement())
          
        Case Window_0_Button_0
          Protected StandardFile$ = "C:\Users\mestnyi\Google Диск\SyncFolder()\Module()\"  
          Protected Pattern$ = "Image (png;bmp)|*.png;*.gif;*.bmp|All files (*.*)|*.*"
          Protected Pattern = 0    ; use the first of the three possible patterns as standard
          Window_0_OpenFile$ = OpenFileRequester("Please choose file to load", StandardFile$, Pattern$, Pattern)
          Protected img = LoadImage(#PB_Any, Window_0_OpenFile$)
          
          
          UsePNGImageDecoder()
          If img
            SetElementState(Window_0_Image_0, img)
          EndIf
          
      EndSelect
  EndSelect
  
EndProcedure

Procedure CFE_Helper_Image(Parent =- 1, *Image.Integer=0, *Puth.String=0, WindowID = #False, Flag.q = #_Flag_ScreenCentered)
  Protected Element, X,Y,Width=346,Height=176, View
  Flag.q | #_Flag_SystemMenu|#_Flag_SizeGadget
  
  ;Element = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore,200,300, "Image editor",Flag, Parent) 
  Event_Element = EventElement()
  
  ; AlignmentElement(Element, Flag)
  If ((Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
    X = (ElementWidth(0)-Width)/2 
    Y = (ElementHeight(0)-Height)/2
    
  ElseIf ((Flag & #_Flag_WindowCentered) = #_Flag_WindowCentered)
    If IsElement(Parent)
      X = (ElementWidth(Parent)-Width)/2 
      Y = (ElementHeight(Parent)-Height)/2
    EndIf
  EndIf
  
  Window_0 = OpenWindowElement(#PB_Any, X,Y, Width, Height, "Редактор изображения", Flag|#_Flag_Invisible)
  StickyWindowElement(Window_0, #True)
  
  Window_0_Image_0 = ImageElement(#PB_Any, 5, 5, 231, 166);, #_Flag_Image_Center)
  Window_0_Button_0 = ButtonElement(#PB_Any, 240, 5, 101, 21, "Загрузить")
  Window_0_Button_1 = ButtonElement(#PB_Any, 240, 125, 101, 21, "Применить")
  Window_0_Button_2 = ButtonElement(#PB_Any, 240, 150, 101, 21, "Отмена")
  
  BindEventElement(@CFE_Helper_Buttons_Events(), Window_0)
  ;WaitWindowEventClose(Window_0)
  ;Debug 444444444
  If *Image
    *Image\i = Window_0_0_Image
  EndIf
  
  ; BindGadgetElementEvent(e, @ButtonElementEvent(), #_Event_LeftClick)
  HideElement(Window_0, #False)
  CloseElementList()
  
  ProcedureReturn Element
EndProcedure

;}

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65, "Demo WindowElement()") 
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  Define gImage 
  CFE_Helper_Image(Window)
  Debug gImage
  
  WaitWindowEventClose(Window)
CompilerEndIf


; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 3
; FirstLine = 84
; Folding = ---
; EnableXP