EnableExplicit

CompilerIf #PB_Compiler_IsMainFile
  Structure StructureGadget
    Gadget.i        ;Identifiant gadget lors de la création
    Enum$           ;Enumeration
    Gadget1$
    Gadget2$
  EndStructure
  
  Global Dim ArrayWindow.StructureGadget(0)
  Global Dim ArrayGadget.StructureGadget(0) 
  Global Dim ArrayContainer.StructureGadget(0) 
  
  Procedure$ GadgetName( Type )
    Select Type
      Case #PB_GadgetType_Unknown        :ProcedureReturn "CreateGadget"
      Case #PB_GadgetType_Button         :ProcedureReturn "ButtonGadget"
      Case #PB_GadgetType_String         :ProcedureReturn "StringGadget"
      Case #PB_GadgetType_Text           :ProcedureReturn "TextGadget"
      Case #PB_GadgetType_CheckBox       :ProcedureReturn "CheckBoxGadget"
      Case #PB_GadgetType_Option         :ProcedureReturn "OptionGadget"
      Case #PB_GadgetType_ListView       :ProcedureReturn "ListViewGadget"
      Case #PB_GadgetType_Frame          :ProcedureReturn "FrameGadget"
      Case #PB_GadgetType_ComboBox       :ProcedureReturn "ComboBoxGadget"
      Case #PB_GadgetType_Image          :ProcedureReturn "ImageGadget"
      Case #PB_GadgetType_HyperLink      :ProcedureReturn "HyperLinkGadget"
      Case #PB_GadgetType_Container      :ProcedureReturn "ContainerGadget"
      Case #PB_GadgetType_ListIcon       :ProcedureReturn "ListIconGadget"
      Case #PB_GadgetType_IPAddress      :ProcedureReturn "IPAddressGadget"
      Case #PB_GadgetType_ProgressBar    :ProcedureReturn "ProgressBarGadget"
      Case #PB_GadgetType_ScrollBar      :ProcedureReturn "ScrollBarGadget"
      Case #PB_GadgetType_ScrollArea     :ProcedureReturn "ScrollAreaGadget"
      Case #PB_GadgetType_TrackBar       :ProcedureReturn "TrackBarGadget"
      Case #PB_GadgetType_Web            :ProcedureReturn "WebGadget"
      Case #PB_GadgetType_ButtonImage    :ProcedureReturn "ButtonImageGadget"
      Case #PB_GadgetType_Calendar       :ProcedureReturn "CalendarGadget"
      Case #PB_GadgetType_Date           :ProcedureReturn "DateGadget"
      Case #PB_GadgetType_Editor         :ProcedureReturn "EditorGadget"
      Case #PB_GadgetType_ExplorerList   :ProcedureReturn "ExplorerListGadget"
      Case #PB_GadgetType_ExplorerTree   :ProcedureReturn "ExplorerTreeGadget"
      Case #PB_GadgetType_ExplorerCombo  :ProcedureReturn "ExplorerComboGadget"
      Case #PB_GadgetType_Spin           :ProcedureReturn "SpinGadget"
      Case #PB_GadgetType_Tree           :ProcedureReturn "TreeGadget"
      Case #PB_GadgetType_Panel          :ProcedureReturn "PanelGadget"
      Case #PB_GadgetType_Splitter       :ProcedureReturn "SplitterGadget"
      Case #PB_GadgetType_MDI           
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          ProcedureReturn "MDIGadget"
        CompilerEndIf
      Case #PB_GadgetType_Scintilla      :ProcedureReturn "ScintillaGadget"
      Case #PB_GadgetType_Shortcut       :ProcedureReturn "ShortcutGadget"
      Case #PB_GadgetType_Canvas         :ProcedureReturn "CanvasGadget"
    EndSelect
    ProcedureReturn ""
  EndProcedure
  
CompilerEndIf

Global Window_0=-1, 
       Window_SH_Text_G1=-1, 
       Window_SH_Text_G2=-1, 
       Window_SH_ComboBox_G1=-1, 
       Window_SH_ComboBox_G2=-1, 
       Window_SH_ListIcon_Flag=-1, 
       Window_SH_Container_Line=-1, 
       Window_SH_Button_Cancel=-1, 
       Window_SH_Button_Ok=-1

Declare Window_SH_Events()

Procedure Window_SH_LoadGadget( *Gadget1=-1, *Gadget2=-1, *Flag=0 )
; Возвращает 1 если на форме есть гаджеты, перед добавлением сплиттера
; Возвращает -1 если на форме нет гаджеты, перед добавлением сплиттера
  Protected I, Flag, Flag$, Gadget1, Gadget2
  ClearGadgetItems(Window_SH_ComboBox_G1)
  ClearGadgetItems(Window_SH_ComboBox_G2)
  
;   For i = 0 To ArraySize(ArrayGadget())
;     If ParentID And ParentID = ArrayGadget(i)\ParentID
;       AddGadgetItem(Window_SH_ComboBox_G1,-1,ArrayGadget(i)\Enum$)
;         SetGadgetItemData(Window_SH_ComboBox_G1, i, ArrayGadget(i)\Gadget)
;       AddGadgetItem(Window_SH_ComboBox_G2,-1,ArrayGadget(i)\Enum$)
;         SetGadgetItemData(Window_SH_ComboBox_G2, i, ArrayGadget(i)\Gadget)
;     EndIf
;   Next
  
  ; Если загрузили оба гаджета то выходим, иначе дагружаем
  If GetGadgetItemText(Window_SH_ComboBox_G1, 1) And 
     GetGadgetItemText(Window_SH_ComboBox_G2, 1)
    ProcedureReturn 1
  Else
    For i = 1 To 33
      AddGadgetItem(Window_SH_ComboBox_G1,-1,GadgetName(i))
      AddGadgetItem(Window_SH_ComboBox_G2,-1,GadgetName(i))
    Next
    ProcedureReturn -1
  EndIf
  
  
   ; Получаем выбранные гаджети
;             If GetGadgetText( Window_SH_ComboBox_G1 ) And GetGadgetText( Window_SH_ComboBox_G2 )
;               Gadget1 = GetGadgetItemData(Window_SH_ComboBox_G1, GetGadgetState(Window_SH_ComboBox_G1))
;               Gadget2 = GetGadgetItemData(Window_SH_ComboBox_G2, GetGadgetState(Window_SH_ComboBox_G2))
;             Else
;               Gadget1 = -1
;               Gadget2 = -1
;             EndIf
;             
;             For i = 0 To ArraySize(ArrayGadget())
;               Select ArrayGadget(i)\Enum$ 
;                 Case GetGadgetText( Window_SH_ComboBox_G1 ) :Gadget1 = ArrayGadget(i)\Gadget
;                 Case GetGadgetText( Window_SH_ComboBox_G2 ) :Gadget2 = ArrayGadget(i)\Gadget
;               EndSelect
;             Next
;             
            ; Собираем строку
            For i = 0 To CountGadgetItems( Window_SH_ListIcon_Flag ) - (1)
              If GetGadgetItemState( Window_SH_ListIcon_Flag, i )
                If Flag$ 
                  Flag$ = Flag$  +"|"+ Trim( GetGadgetItemText( Window_SH_ListIcon_Flag, i))
                Else 
                  Flag$ = Trim( GetGadgetItemText( Window_SH_ListIcon_Flag, i )) 
                EndIf
              EndIf
            Next
            
            ; Разбираем строку
            For i = 1 To CountString( Flag$, "|") + (1)
              Select Trim( StringField( Flag$, i, "|")) 
                Case "Splitter_Vertical"    :Flag = Flag | #PB_Splitter_Vertical
                Case "Splitter_Separator"   :Flag = Flag | #PB_Splitter_Separator
                Case "Splitter_FirstFixed"  :Flag = Flag | #PB_Splitter_FirstFixed
                Case "Splitter_SecondFixed" :Flag = Flag | #PB_Splitter_SecondFixed
              EndSelect
            Next
            
            If *Gadget1
              PokeI( *Gadget1, PeekI( @Gadget1 ) )
            EndIf
            If *Gadget2
              PokeI( *Gadget2, PeekI( @Gadget2 ) )
            EndIf
            If *Flag
              PokeI( *Flag, PeekI( @Flag ) )
            EndIf
          
            If Gadget1 >=0 And Gadget2 >=0
;               PostEvent( #PB_Event_CloseWindow, Window, #PB_Any ) 
              ProcedureReturn #PB_GadgetType_Splitter
            Else
              Debug *Flag
;               MessageRequester(GetWindowTitle( Window ),"Пока не реализованно!!!")
            EndIf
EndProcedure

Procedure Window_SH_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 570, 320, 386, 206, "SplitterHelper", Flag)
    Window_SH_Text_G1 = TextGadget(#PB_Any, 10, 15, 81, 16, "Gadget_1:", #PB_Text_Right)                                                                                                                                                                                                                                                                                   
    Window_SH_Text_G2 = TextGadget(#PB_Any, 10, 40, 81, 16, "Gadget_2:", #PB_Text_Right)                                                                                                                                                                                                                                                                                   
    Window_SH_ComboBox_G1 = ComboBoxGadget(#PB_Any, 95, 10, 281, 21)
    Window_SH_ComboBox_G2 = ComboBoxGadget(#PB_Any, 95, 35, 281, 21)
    Window_SH_ListIcon_Flag = ListIconGadget(#PB_Any, 10, 65, 366, 101, "Flags", 362, #PB_ListIcon_CheckBoxes)               
    AddGadgetItem(Window_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_Vertical" )
    AddGadgetItem(Window_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_Separator" )
    AddGadgetItem(Window_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_FirstFixed" )
    AddGadgetItem(Window_SH_ListIcon_Flag, #PB_Any, "#PB_Splitter_SecondFixed" )
    Window_SH_Container_Line = ContainerGadget(#PB_Any, 10, 170, 366, 1, #PB_Container_Flat)  
    CloseGadgetList()
    Window_SH_Button_Cancel = ButtonGadget(#PB_Any, 10, 175, 81, 21, "Cancel")   
    Window_SH_Button_Ok = ButtonGadget(#PB_Any, 295, 175, 81, 21, "Ok")      
    
    BindEvent(#PB_Event_Gadget, @Window_SH_Events(), Window_0)
  EndIf

  ProcedureReturn Window_0
EndProcedure

Procedure Window_SH_Events()
  Select Event()
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
             
          EndSelect
      EndSelect
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Window_SH_Open()
  Window_SH_LoadGadget( )
    
  While IsWindow(Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf