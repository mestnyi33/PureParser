CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "CFE.pbi"
CompilerEndIf

EnumerationBinary #PB_Menu_ModernLook
  #PB_Menu_Image
EndEnumeration




CompilerIf #PB_Compiler_IsMainFile
  Global Desktop_0
  Global Desktop_0_Menu
  Global Desktop_0_ToolBar
  
  Global Desktop_0_Window_0
  Global Desktop_0_Window_0_Menu
  Global Desktop_0_Window_0_ToolBar
  Global Desktop_0_Window_0_Button_0
  Global Desktop_0_Window_0_Button_1
  
  Global Desktop_0_Window_1
  Global Desktop_0_Window_1_Menu
  Global Desktop_0_Window_1_ToolBar
  Global Desktop_0_Window_1_Button_0
  Global Desktop_0_Window_1_Button_1
  
  Global Desktop_0_Window_2
  Global Desktop_0_Window_2_Menu
  Global Desktop_0_Window_2_ToolBar
  Global Desktop_0_Window_2_Button_Hide
  Global Desktop_0_Window_2_Button_Disable
  Global Desktop_0_Window_2_Button_Bind
  
  Global Desktop_0_Window_4
  Global Desktop_0_Window_4_Menu
  Global Desktop_0_Window_4_ToolBar
  Global Desktop_0_Window_4_Button_0
  Global Desktop_0_Window_4_Button_1
  
  Global PopupMenuElement
  
  Desktop_0 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 800,600);, "2")
  
;   Desktop_0_Menu = CreateMenuElement()
;   MenuElementTitle("File")
;   MenuElementTitle("Edit")
;   MenuElementTitle("Project")
;   MenuElementTitle("Form")
;   
;   Desktop_0_ToolBar = CreateToolBarElement()
;   ToolBarElementStandardButton(1, -1,0, "Open")
;   ToolBarElementStandardButton(2, -1,0, "Copy")
;   ToolBarElementStandardButton(3, -1,0, "Paste")
  
  Desktop_0_Window_0 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 200,150,"", #_Flag_SystemMenu)
  Desktop_0_Window_0_Menu = CreateMenuElement()
  MenuElementTitle("File")
  MenuElementTitle("Edit")
  ;MenuElementBar()
  MenuElementTitle("Project")
  MenuElementTitle("Form")
  MenuElementTitle("Compiler")
  
  Desktop_0_Window_0_Button_0 = ButtonElement(#PB_Any, 10,10, 100, 25,"Button_0")
  Desktop_0_Window_0_Button_1 = ButtonElement(#PB_Any, 10,150-35, 100, 25,"Button_1")
  CloseElementList()
  
; ; ;   Desktop_0_Window_1 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 200,150,"", #_Flag_SystemMenu)
; ; ;   Desktop_0_Window_1_ToolBar = CreateToolBarElement()
; ; ;   ToolBarElementStandardButton(1, -1,0, "Open")
; ; ;   ToolBarElementStandardButton(2, -1,0, "Copy")
; ; ;   ToolBarElementStandardButton(3, -1,0, "Paste")
; ; ;   
; ; ;   Desktop_0_Window_1_Button_0 = ButtonElement(#PB_Any, 10,10, 100, 25,"Button_0")
; ; ;   Desktop_0_Window_1_Button_1 = ButtonElement(#PB_Any, 10,150-35, 100, 25,"Button_1")
; ; ;   CloseElementList()
  
; ; ;   Desktop_0_Window_2 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 200,150,"", #_Flag_SystemMenu|#_Flag_ScreenCentered)
; ; ;   Desktop_0_Window_2_Button_Hide = ButtonElement(#PB_Any, 10,10, 100, 25,"hide = "+IsHideElement(Desktop_0_Window_0))
; ; ;   Desktop_0_Window_2_Button_Disable = ButtonElement(#PB_Any, 10,40, 100, 25,"disable = "+IsDisableElement(Desktop_0_Window_1))
; ; ;   
; ; ;   Desktop_0_Window_2_Button_Bind = ButtonElement(#PB_Any, 90,115, 100, 25,"bind = 0")
; ; ;   CloseElementList()
  
  SetElementText(Desktop_0_Window_0,"demo menu (Window_0)")
  SetElementText(Desktop_0_Window_1,"demo toolbar (Window_1)")
  SetElementText(Desktop_0_Window_2,"demo bind")
  
  
  
  Desktop_0_Window_4 = OpenWindowElement(#PB_Any, 0, 0, 550, 45, "ToolBar", #_Flag_SystemMenu|#_Flag_ScreenCentered)
  
  If Desktop_0_Window_4
    PopupMenuElement = CreatePopupMenuElement()
; ; ;     If PopupMenuElement
; ; ;       MenuElementItem(#PB_Any, "Item_1")
; ; ;       MenuElementItem(#PB_Any, "Item_2")
; ; ;       MenuElementItem(#PB_Any, "Item_3")
; ; ;     EndIf
    
    If CreateToolBarElement(#PB_Any, Desktop_0_Window_4, #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
      ToolBarElementStandardButton(0, #PB_ToolBarIcon_New)
      ToolBarElementStandardButton(1, #PB_ToolBarIcon_Open, 0, "Open" )
      ToolBarElementStandardButton(2, #PB_ToolBarIcon_Save)
      ToolBarElementSeparator()
      
      ToolBarElementStandardButton(3, #PB_ToolBarIcon_Print)
      ToolBarElementStandardButton(4, #PB_ToolBarIcon_PrintPreview)
      ToolBarElementStandardButton(5, #PB_ToolBarIcon_Find)
      ToolBarElementStandardButton(6, #PB_ToolBarIcon_Replace)
; ; ;       ToolBarElementSeparator()
      
; ; ;       ToolBarElementStandardButton(7, #PB_ToolBarIcon_Cut)
; ; ;       ToolBarElementStandardButton(8, #PB_ToolBarIcon_Copy)
; ; ;       ToolBarElementStandardButton(9, #PB_ToolBarIcon_Paste)
; ; ;       ToolBarElementStandardButton(10, #PB_ToolBarIcon_Undo)
; ; ;       ToolBarElementStandardButton(11, #PB_ToolBarIcon_Redo)
; ; ;       ToolBarElementSeparator()
      
; ; ;       ToolBarElementStandardButton(12, #PB_ToolBarIcon_Delete)
; ; ;       ToolBarElementStandardButton(13, #PB_ToolBarIcon_Properties)
; ; ;       ToolBarElementStandardButton(14, #PB_ToolBarIcon_Help)
; ; ;       ToolBarElementSeparator()
; ; ;       
; ; ;       ToolBarElementToolTip(ToolBarElement(), 0, "New document")
; ; ;       ToolBarElementToolTip(ToolBarElement(), 1, "Open file")
; ; ;       ToolBarElementToolTip(ToolBarElement(), 2, "Save file")
; ; ;       
      ToolBarElementButtonText(ToolBarElement(), 14, "Help")
    EndIf
    
    ButtonElement(#PB_Any,10,10,100,25,"Button")
    
    StickyWindowElement(Desktop_0_Window_4, 1)
    CloseElementList()
  EndIf
   
; ; ;   ;OpenElementList(Desktop_0_Window_2)
; ; ;   Desktop_0_Window_2_Menu = CreateMenuElement(#PB_Any, Desktop_0_Window_2)
; ; ;   MenuElementTitle("File")
; ; ;   MenuElementTitle("Edit")
; ; ;   MenuElementTitle("Project")
; ; ;   MenuElementTitle("Form")
; ; ;   
; ; ;   Desktop_0_Window_2_ToolBar = CreateToolBarElement(#PB_Any, Desktop_0_Window_2)
; ; ;   ToolBarElementButton(1, 0,0, 0, " text", "Пример демонстрирующий кнопку тульбара")
; ; ;   ToolBarElementButton(2, -1,0, #PB_ToolBarIcon_New)
; ; ;   ToolBarElementButton(3, -1,0, #PB_ToolBarIcon_Open, "Open", "Открыть файл")
; ; ;   ToolBarElementButton(4, -1,0, #PB_ToolBarIcon_Save, "Save")
; ; ;   ToolBarElementSeparator()
; ; ;   ToolBarElementButton(5, -1,0, 0, "Paste")
; ; ;   ;CloseElementList()
; ; ;   
; ; ;   Procedure Desktop_0_Window_2_Event()
; ; ;     Static HideState, DisableState
; ; ;     
; ; ;     Select ElementEvent()
; ; ;       Case #_Event_LeftClick
; ; ;         Select EventElement()
; ; ;           Case Desktop_0_Window_2_Button_Hide : HideState!1
; ; ;             SetElementText(Desktop_0_Window_2_Button_Hide,"hide = "+Str(HideState))
; ; ;             HideElement(Desktop_0_Window_0, HideState)
; ; ;             
; ; ;           Case Desktop_0_Window_2_Button_Disable : DisableState!1
; ; ;             SetElementText(Desktop_0_Window_2_Button_Disable,"disable = "+Str(DisableState))
; ; ;             DisableElement(Desktop_0_Window_1, DisableState)
; ; ;             
; ; ;         EndSelect
; ; ;     EndSelect
; ; ;     
; ; ;     ProcedureReturn #True
; ; ;   EndProcedure
; ; ;   
; ; ;   Procedure CallBack()
; ; ;     Static BindState
; ; ;     
; ; ;     Select ElementEvent()
; ; ;       Case #_Event_RightClick
; ; ;         Debug "RightClick"
; ; ;         DisplayPopupMenuElement(PopupMenuElement, EventWindowElement())
; ; ;         
; ; ;       Case #_Event_LeftClick
; ; ;         Select EventElement()
; ; ;           Case Desktop_0_Window_2_Button_Bind : BindState!1
; ; ;             SetElementText(Desktop_0_Window_2_Button_Bind,"bind = "+Str(BindState))
; ; ;             
; ; ;             If BindState
; ; ;               BindEventElement(@Desktop_0_Window_2_Event(), Desktop_0_Window_2)
; ; ;             Else
; ; ;               UnbindEventElement(@Desktop_0_Window_2_Event(), Desktop_0_Window_2)
; ; ;             EndIf
; ; ;             
; ; ;           Default
; ; ;             Debug Str(EventElement())+" - LeftClick"
; ; ;         EndSelect
; ; ;         
; ; ;     EndSelect
; ; ;     
; ; ;     ProcedureReturn #True
; ; ;   EndProcedure
; ; ;   
; ; ;   
; ; ;  BindEventElement(@CallBack())
  
  WaitWindowEventClose(Desktop_0)
CompilerEndIf
