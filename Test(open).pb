EnableExplicit

XIncludeFile "Transformation.pbi"

Procedure OpenPBObject(Type$, ID$="", X=0,Y=0,Width=0,Height=0, Flag=0, Caption$="", Param1=0, Param2=0, Param3=0)
  Protected ID=-1
  Static ParentID, Parent=-1, Item
  
  Select Type$
    Case "OpenWindow"          : ID = OpenWindow          (#PB_Any, X,Y,Width,Height, Caption$, Flag|#PB_Window_SizeGadget) 
    Case "ButtonGadget"        : ID = ButtonGadget        (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "StringGadget"        : ID = StringGadget        (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "TextGadget"          : ID = TextGadget          (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "CheckBoxGadget"      : ID = CheckBoxGadget      (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "OptionGadget"        : ID = OptionGadget        (#PB_Any, X,Y,Width,Height, Caption$)
    Case "ListViewGadget"      : ID = ListViewGadget      (#PB_Any, X,Y,Width,Height, Flag)
    Case "FrameGadget"         : ID = FrameGadget         (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ComboBoxGadget"      : ID = ComboBoxGadget      (#PB_Any, X,Y,Width,Height, Flag)
    Case "ImageGadget"         : ID = ImageGadget         (#PB_Any, X,Y,Width,Height, Param1,Flag)
    Case "HyperLinkGadget"     : ID = HyperLinkGadget     (#PB_Any, X,Y,Width,Height, Caption$,Param1,Flag)
    Case "ContainerGadget"     : ID = ContainerGadget     (#PB_Any, X,Y,Width,Height, Flag)
    Case "ListIconGadget"      : ID = ListIconGadget      (#PB_Any, X,Y,Width,Height, Caption$, Param1, Flag)
    Case "IPAddressGadget"     : ID = IPAddressGadget     (#PB_Any, X,Y,Width,Height)
    Case "ProgressBarGadget"   : ID = ProgressBarGadget   (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "ScrollBarGadget"     : ID = ScrollBarGadget     (#PB_Any, X,Y,Width,Height, Param1, Param2, Param3, Flag)
    Case "ScrollAreaGadget"    : ID = ScrollAreaGadget    (#PB_Any, X,Y,Width,Height, Param1, Param2, Param3, Flag) 
    Case "TrackBarGadget"      : ID = TrackBarGadget      (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "WebGadget"           : ID = WebGadget           (#PB_Any, X,Y,Width,Height, Caption$)
    Case "ButtonImageGadget"   : ID = ButtonImageGadget   (#PB_Any, X,Y,Width,Height, Param1, Flag)
    Case "CalendarGadget"      : ID = CalendarGadget      (#PB_Any, X,Y,Width,Height, Param1, Flag)
    Case "DateGadget"          : ID = DateGadget          (#PB_Any, X,Y,Width,Height, Caption$, Param1, Flag)
    Case "EditorGadget"        : ID = EditorGadget        (#PB_Any, X,Y,Width,Height, Flag)
    Case "ExplorerListGadget"  : ID = ExplorerListGadget  (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ExplorerTreeGadget"  : ID = ExplorerTreeGadget  (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "ExplorerComboGadget" : ID = ExplorerComboGadget (#PB_Any, X,Y,Width,Height, Caption$, Flag)
    Case "SpinGadget"          : ID = SpinGadget          (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
    Case "TreeGadget"          : ID = TreeGadget          (#PB_Any, X,Y,Width,Height, Flag)
    Case "PanelGadget"         : ID = PanelGadget         (#PB_Any, X,Y,Width,Height) 
    Case "SplitterGadget"      
      If IsGadget(Param1) And IsGadget(Param2)
        ID = SplitterGadget      (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag)
      EndIf
    Case "MDIGadget"          
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        ID = MDIGadget           (#PB_Any, X,Y,Width,Height, Param1, Param2, Flag) 
      CompilerEndIf
    Case "ScintillaGadget"     : ID = ScintillaGadget     (#PB_Any, X,Y,Width,Height, Param1)
    Case "ShortcutGadget"      : ID = ShortcutGadget      (#PB_Any, X,Y,Width,Height, Param1)
    Case "CanvasGadget"        : ID = CanvasGadget        (#PB_Any, X,Y,Width,Height, Flag)
  EndSelect
  
  Select Type$
    Case "OpenWindow"          
      Parent = ID
      ParentID = WindowID(ID)
      
    Case "ContainerGadget", "ScrollAreaGadget", "PanelGadget"
      SetGadgetData(ID, Parent)
      Parent = ID
      ParentID = GadgetID(ID)
      
    Case "UseGadgetList"       : UseGadgetList( ParentID )
    Case "CloseGadgetList"     
      If IsGadget(Parent)
        CloseGadgetList() 
        Parent = GetGadgetData(Parent)
      EndIf
    Case "AddGadgetItem"       : AddGadgetItem( Parent, #PB_Any, Caption$, Param1, Flag)
    Case "OpenGadgetList"      
      ; Тут будет сложнее
      ; Потому что он не следует за вызовом гаджета
      ; Из за этого надо перебырать все объекты
      ; и проверят ID$ если похожи получить ID
      ; OpenGadgetList( ID, Param1 )
  EndSelect
  
  If IsGadget(ID)
    Protected OpenList, GetParent
    
    If IsGadget(Parent)
      GetParent = GetGadgetData(Parent)
    EndIf
    
    If ID = Parent
      If IsWindow(GetParent)
        CloseGadgetList() ; Bug PB
        UseGadgetList(WindowID(GetParent))
      EndIf
      If IsGadget(GetParent) 
        OpenList = OpenGadgetList(GetParent, Item) 
      EndIf
    EndIf
    
    Transformation::Enable(ID, 5)
    
    If ID = Parent
      If IsWindow(GetParent) 
        OpenGadgetList(ID, Item) 
      EndIf
      If OpenList 
        CloseGadgetList() 
      EndIf
    EndIf
  EndIf
  
  If Type$ = "AddGadgetItem"  
    Item + 1
  EndIf
  
  ProcedureReturn ID
EndProcedure

UsePNGImageDecoder()
LoadImage(0, #PB_Compiler_Home + "examples/sources/Data/world.png")

; test 1
Define Window_0 = OpenPBObject("OpenWindow","0", 0, 100, 310, 325, #PB_Window_SystemMenu)
OpenPBObject("ContainerGadget","1", 10, 50, 290, 265, #PB_Container_Flat)
OpenPBObject("ButtonGadget","2", 10, 10, 85, 35, 0, "Button")
OpenPBObject("ContainerGadget","3", 10, 55, 265, 200, #PB_Container_Single)
OpenPBObject("StringGadget","4", 10, 10, 150, 35)
OpenPBObject("PanelGadget","5", 10, 55, 245, 140)
OpenPBObject("AddGadgetItem","5", 0,0,0,0,0, "Item_0")
OpenPBObject("AddGadgetItem","5", 0,0,0,0,0, "Item_1", ImageID(0))
OpenPBObject("ButtonGadget","6", -10, 10, 85, 35, 0, "Button")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("ButtonGadget","7", 190, 10, 85, 35, 0, "Button")
OpenPBObject("CloseGadgetList")

; TODO Это еще не реализовано
OpenPBObject("OpenGadgetList","5", 0,0,0,0,0, "", 0)
OpenPBObject("ButtonGadget","8", -10, 30, 85, 35, 0, "Button")
OpenPBObject("CloseGadgetList")

OpenPBObject("ButtonGadget","9", 110, 10, 85, 35, 0, "Button")

; test 2
Define Window_0 = OpenPBObject("OpenWindow","10", 330, 100, 595, 395, #PB_Window_SystemMenu, "")

OpenPBObject("ContainerGadget","10", 10, 10, 275, 235, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor", #PB_Gadget_BackColor,RGB(192,192,192))
OpenPBObject("ButtonGadget","11", 5, 5, 90, 40, 0, "Button_0")
OpenPBObject("ButtonGadget","12", 5, 50, 90, 40, 0, "Button_1")
OpenPBObject("SpinGadget","13", 190, 5, 80, 30, 0, "", 0, 0)
OpenPBObject("SpinGadget","14", 190, 40, 80, 30, 0, "", 0, 0)
OpenPBObject("SpinGadget","15", 190, 75, 80, 30, 0, "", 0, 0)
OpenPBObject("CloseGadgetList")

OpenPBObject("ContainerGadget","16", 290, 10, 300, 235, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor", #PB_Gadget_BackColor,RGB(64,128,128))
OpenPBObject("OptionGadget","17", 10, 10, 80, 15, 0, "Опция 1")
OpenPBObject("OptionGadget","18", 10, 35, 65, 15, 0, "Опция 2")
OpenPBObject("OptionGadget","19", 10, 60, 65, 20, 0, "Опция 3")
OpenPBObject("ContainerGadget","20", 130, 10, 160, 215, #PB_Container_Single)
;   OpenPBObject("SetGadgetColor", #PB_Gadget_BackColor,RGB(255,128,255))
OpenPBObject("TextGadget","21", 5, 5, 65, 20, 0, "Текст")
OpenPBObject("StringGadget","22", 75, 5, 75, 20, 0, "")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")

OpenPBObject("ContainerGadget","23", 10, 250, 580, 140, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_3, #PB_Gadget_BackColor,RGB(128,128,64))
OpenPBObject("ContainerGadget","24", 130, 5, 445, 130, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_4, #PB_Gadget_BackColor,RGB(255,128,0))
OpenPBObject("ButtonGadget","25", 5, 5, 105, 120, 0, "Уровень 2")
OpenPBObject("ContainerGadget","26", 115, 5, 325, 120, #PB_Container_Flat)
OpenPBObject("ButtonGadget","27", 5, 5, 95, 110, 0, "Уровень 3")
OpenPBObject("ContainerGadget","28", 105, 5, 215, 110, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_6, #PB_Gadget_BackColor,RGB(0,0,255))
OpenPBObject("ButtonGadget","29", 5, 5, 90, 100, 0, "Уровень 4")
OpenPBObject("ContainerGadget","30", 100, 5, 110, 100, #PB_Container_Flat)
;   OpenPBObject("SetGadgetColor(#Container_7, #PB_Gadget_BackColor,RGB(255,255,255))
OpenPBObject("ButtonGadget","31", 5, 5, 100, 40, 0, "Уровень 5")
OpenPBObject("TextGadget","32", 5, 50, 100, 20, 0, "Текст у5 1")
OpenPBObject("TextGadget","33", 5, 75, 100, 20, 0, "Текст у5 2")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("CloseGadgetList")
OpenPBObject("ButtonGadget","34", 5, 5, 120, 130, 0, "Уровень 1")
OpenPBObject("CloseGadgetList")

While IsWindow( Window_0 )
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow 
      CloseWindow( EventWindow() )
  EndSelect
Wend