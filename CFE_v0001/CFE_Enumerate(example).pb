CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
CompilerEndIf

Procedure _EnumerateElement(*ID.Integer, Parent =- 1, Item =- 1, NestedElements.b = #True) ; Ok
  Static Element=-1, StartEnumerate
  If Element =- 1 : Element = Parent : EndIf
  Protected Result, *Parent = ElementID(Parent)
  
  With *CreateElement
    If Element = Parent
      If (Not StartEnumerate) 
        If *Parent
          ChangeCurrentElement(\This(), *Parent)
          If (Not \This()\IsContainer) : ProcedureReturn 0 : EndIf
        Else
          Result = FirstElement(\This())
        EndIf
      EndIf
      
    Else
      If StartEnumerate
        ;Debug " StartEnumerate" 
        PushListPosition(\This())
        ChangeCurrentElement(\This(), *Parent)
      Else
        ;Debug " StopEnumerate"  
        PopListPosition(\This())
      EndIf
      
      Element = Parent
    EndIf
    
    Result = NextElement(\This())
    
    If *Parent 
      If NestedElements
        If Not IsChildElement(\This()\Element, Parent)
          While Result
            Result = NextElement(\This())
            
            If IsChildElement(\This()\Element, Parent) 
              If Item =- 1
                Break
              Else
                If \This()\Item\State = Item
                  Break
                EndIf
              EndIf
            EndIf
          Wend
        EndIf
      Else
        If \This()\Parent\Element <> Parent 
          While Result
            Result = NextElement(\This())
            
            If \This()\Parent\Element = Parent 
              If Item =- 1
                Break
              Else
                If \This()\Item\State = Item
                  Break
                EndIf
              EndIf
            EndIf
          Wend
        EndIf
      EndIf
    EndIf
    
    StartEnumerate = Result
    
    If *ID
      PokeI(*ID, PeekI(@\This()\Element))
    Else
      ProcedureReturn 0
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


; EnumerateElement
CompilerIf #PB_Compiler_IsMainFile
  
  Define i, iID=-1, ID=-1
  Define w = OpenWindowElement(1, 0,0, 432,284+4*65, "Demo WindowElement()") 
  Define  Time = ElapsedMilliseconds()
  
  For i=2 To 5
    ButtonElement  (i, 10, i*30, 130, 30,"Button_"+Str(i))
  Next
  
  If CreatePopupMenuElement(#PB_Any)
    OpenSubMenuElement("Z-Order")
      MenuElementItem(0, "First")
    CloseSubMenuElement()
  EndIf
  
  OpenWindowElement(10, 150,100, 260,120, "Demo 10",#_Flag_AnchorGadget,w) 
  
  For i=11 To 15
    ButtonElement  (i, 10, i*20-210, 80, 20,"Button_"+Str(i))
  Next
  
    ContainerElement(16,100,10,150,110, #_Flag_AnchorGadget)
  
    For i=17 To 20
      ButtonElement  (i, 10, i*20-320, 80, 20,"Button_"+Str(i))
    Next
    
    CloseElementList()
  CloseElementList()
  
  If CreatePopupMenuElement(#PB_Any)
    OpenSubMenuElement("Z-Order")
      MenuElementItem(0, "First")
    CloseSubMenuElement()
  EndIf
 
  For i=6 To 9
    ButtonElement  (i, 10, i*30, 130, 30,"Button_"+Str(i))
  Next
   
  While EnumerateElement(@ID, ElementID(1))
    Debug "1-"+ID
    
    While EnumerateElement(@iID, ElementID(ID))
      ;If (IsChildElement(IID, ID) = 0) : Continue : EndIf
      Debug "   "+Str(ID)+"-"+iID
      
    Wend
  Wend
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf

  WaitWindowEventClose(w)
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  
  Define i, iID=-1, ID=-1
  Define w = OpenWindowElement(1, 0,0, 432,284+4*65, "Demo WindowElement()") 
  Define  Time = ElapsedMilliseconds()
  
  For i=2 To 5
    ButtonElement  (i, 10, i*30, 130, 30,"Button_"+Str(i))
  Next
  
  If CreatePopupMenuElement(#PB_Any)
    OpenSubMenuElement("Z-Order")
      MenuElementItem(0, "First")
    CloseSubMenuElement()
  EndIf
  
  OpenWindowElement(10, 150,100, 260,120, "Demo 10",#_Flag_AnchorGadget,w) 
  
  For i=11 To 15
    ButtonElement  (i, 10, i*20-11*20+10, 80, 20,"Button_"+Str(i))
  Next
  
    ContainerElement(16,100,10,150,110, #_Flag_AnchorGadget)
  
    For i=17 To 20
      ButtonElement  (i, 10, i*20-17*20+10, 80, 20,"Button_"+Str(i))
    Next
    
    CloseElementList()
  CloseElementList()
  
  If CreatePopupMenuElement(#PB_Any)
    OpenSubMenuElement("Z-Order")
      MenuElementItem(0, "First")
    CloseSubMenuElement()
  EndIf
 
  For i=6 To 9
    ButtonElement  (i, 10, i*30, 130, 30,"Button_"+Str(i))
  Next
  
  PanelElement(21,150,280,250,160, #_Flag_AnchorGadget)
  AddPanelElementItem(21, -1, "Panel_21_1")
  
  For i=22 To 25
    ButtonElement  (i, 10, i*20-22*20+10, 80, 20,"Button_"+Str(i))
  Next
  
  ContainerElement(26,100,10,150,110, #_Flag_AnchorGadget)
  
    For i=27 To 30
      ButtonElement  (i, 10, i*20-27*20+10, 80, 20,"Button_"+Str(i))
    Next
    
    CloseElementList()
    
    AddPanelElementItem(21, -1, "Panel_21_2")
  ContainerElement(31,100,10,150,110, #_Flag_AnchorGadget)
  
    For i=32 To 35
      ButtonElement  (i, 10, i*20-32*20+10, 80, 20,"Button_"+Str(i))
    Next
    
    CloseElementList()
   CloseElementList()
  
  While EnumerateElement(@ID, ElementID(1))
    Debug "1-"+ID
    
    While EnumerateElement(@iID, ElementID(ID))
      ;If (IsChildElement(IID, ID) = 0) : Continue : EndIf
      Debug "   "+Str(ID)+"-"+iID
      
    Wend
  Wend
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf

  WaitWindowEventClose(w)
CompilerEndIf

CompilerIf #PB_Compiler_IsMainFile
  
  Define i, iID=-1, ID=-1
  Define w = OpenWindowElement(1, 0,0, 432,284+4*65, "") 
  
  OpenWindowElement(1, 30,30, 300,300, "Demo WindowElement()", #_Flag_AnchorGadget) 
  Define  Time = ElapsedMilliseconds()
  
 
  For i=2 To 2
    ButtonElement  (i, 10, i*20-2*20+10, 80, 20,"Button_"+Str(i), #_Flag_AnchorGadget)
  Next
  
    ContainerElement(3,100,10,150,110, #_Flag_AnchorGadget)
  
    For i=4 To 4
      ButtonElement  (i, 10, i*20-4*20+10, 80, 20,"Button_"+Str(i), #_Flag_AnchorGadget)
    Next
    
    CloseElementList()
  CloseElementList()
  
  Global Code$
  
  While EnumerateElement(@ID, (0))
    Debug "1-"+ID
    Code$ +"Global "+ GetElementClass(ID)+"=-1"
    
    While EnumerateElement(@iID, ElementID(ID))
      ;If (IsChildElement(IID, ID) = 0) : Continue : EndIf
      Debug "   "+Str(ID)+"-"+iID
      If Code$ : Code$+", " : EndIf : Code$ +GetElementClass(iID)+"=-1"
      
    Wend
    
    Code$ +#CRLF$
  Wend
  
  Debug Code$
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf

  WaitWindowEventClose(w)
CompilerEndIf



