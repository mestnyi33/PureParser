Procedure AddPBFunction(*Function.FUNCTION_STRUCT, Arg$, Index)
  Protected Result, I
  
  With *Function
    Select \Type\Get$
      Case "OpenWindow", 
           "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
           "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
           "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
           "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
           "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
           "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
           "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
           "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
        Select Index
          Case 1
            \ID\Def$ = Arg$
            \ID\Get = #PB_Any
            If Bool(Arg$<>"#PB_Any" And Arg$<>"#PB_All" And 
                    Arg$<>"#PB_Default" And Asc(Arg$)<>'-')
              *This\ID\Get$ = Arg$ 
            EndIf
            \ID\Get$ = *This\ID\Get$
            
          Case 2 
            \X\Def$ = Arg$
            MacroCoordinate(\X\Get, Arg$)
            \X\Get$ = Str(\X\Get)
            
          Case 3 
            \Y\Def$ = Arg$
            MacroCoordinate(\Y\Get, Arg$)
            \Y\Get$ = Str(\Y\Get)
            
          Case 4 
            \Width\Def$ = Arg$
            MacroCoordinate(\Width\Get, Arg$)
            \Width\Get$ = Str(\Width\Get)
            
          Case 5 
            \Height\Def$ = Arg$
            MacroCoordinate(\Height\Get, Arg$)
            \Height\Get$ = Str(\Height\Get)
            
          Case 6 
            \Caption\Def$ = Arg$
            MacroCaption(\Caption\Get$, Arg$)
            
          Case 7 
            \Param1\Def$ = Arg$
            Select \Type\Get$ 
              Case "SplitterGadget"      
                \Param1\Get = ID(Arg$)
                
              Case "ImageGadget", "ButtonImageGadget"     
                \Param1\Def$=Arg$
                \Param1\Get$=GetStr(Arg$)
                
                Result = ID(\Param1\Get$) 
                If IsImage(Result)
                  \Param1\Get = ImageID(Result)
                EndIf
                
              Default
                \Param1\Get = Val(Arg$)
            EndSelect
            \Param1\Get$ = Str(\Param1\Get)
            
          Case 8 
            \Param2\Def$ = Arg$
            Select \Type\Get$ 
              Case "SplitterGadget"      
                \Param2\Get = ID(Arg$)
              Default
                \Param2\Get = Val(Arg$)
            EndSelect
            \Param2\Get$ = Str(\Param2\Get)
            
          Case 9 
            \Param3\Def$ = Arg$
            \Param3\Get = Val(Arg$)
            
          Case 10 
            \Flag\Def$ = Arg$
            MacroFlag(\Flag\Get, Arg$)
            \Flag\Get$ = Arg$
        EndSelect
        
      Case "LoadFont"
        Select Index
          Case 1 
            \ID\Get$ = Arg$
            \ID\Get = #PB_Any
          Case 2 
            \Param1\Def$ = Arg$
            \Param1\Get$ = GetStr(Arg$)
          Case 3 
            \Param2\Def$ = Arg$
            \Param2\Get = Val(Arg$)
          Case 4 
            \Flag\Def$ = Arg$
            MacroFlag(\Flag\Get, Arg$)
        EndSelect
        
      Case "LoadImage",
           "SetGadgetText", 
           "SetGadgetFont", 
           "SetGadgetState"
        Select Index
          Case 1 
            \ID\Get = #PB_Any
            \ID\Get$ = Arg$
          Case 2 
            \Param1\Def$=Arg$
            \Param1\Get$=GetStr(Arg$)
        EndSelect
        
      Case "SetGadgetAttribute",
           "SetGadgetItemData",
           "SetGadgetItemImage",
           "SetGadgetItemState",
           "GetGadgetItemText",
           "BindGadgetEvent",
           "UnbindGadgetEvent"
        Select Index
          Case 1 
            \ID\Get = #PB_Any
            \ID\Get$ = Arg$
          Case 2
            \Param1\Def$=Arg$
            Select Arg$
                ; SetGadgetAttribute
              Case "#PB_Button_Image"           : \Param1\Get = #PB_Button_Image
              Case "#PB_Button_PressedImage"    : \Param1\Get = #PB_Button_PressedImage
              Case "#PB_Calendar_Minimum"       : \Param1\Get = #PB_Calendar_Minimum 
              Case "#PB_Calendar_Maximum"       : \Param1\Get = #PB_Calendar_Maximum
              Case "#PB_Date_Minimum"           : \Param1\Get = #PB_Date_Minimum 
              Case "#PB_Date_Maximum"           : \Param1\Get = #PB_Date_Maximum 
              Case "#PB_Editor_ReadOnly"        : \Param1\Get = #PB_Editor_ReadOnly
              Case "#PB_Editor_WordWrap"        : \Param1\Get = #PB_Editor_WordWrap
              Case "#PB_Explorer_ColumnWidth"   : \Param1\Get = #PB_Explorer_ColumnWidth
              Case "#PB_ListIcon_ColumnWidth"   : \Param1\Get = #PB_ListIcon_ColumnWidth 
              Case "#PB_MDI_Image"              : \Param1\Get = #PB_MDI_Image     
              Case "#PB_MDI_TileImage"          : \Param1\Get = #PB_MDI_TileImage
            EndSelect
          Case 3 
            \Param2\Def$=Arg$
            \Param2\Get$=GetStr(Arg$)
            
            
        EndSelect
        
      Case "SetGadgetColor"
        Select Index
          Case 1 
            \ID\Get = #PB_Any
            \ID\Get$ = Arg$
          Case 2
            \Param1\Def$=Arg$
            Select Arg$
                ; SetGadgetColor 
              Case "#PB_Gadget_FrontColor"      : \Param1\Get = #PB_Gadget_FrontColor      ; Цвет текста гаджета
              Case "#PB_Gadget_BackColor"       : \Param1\Get = #PB_Gadget_BackColor       ; Фон гаджета
              Case "#PB_Gadget_LineColor"       : \Param1\Get = #PB_Gadget_LineColor       ; Цвет линий сетки
              Case "#PB_Gadget_TitleFrontColor" : \Param1\Get = #PB_Gadget_TitleFrontColor ; Цвет текста в заголовке    (для гаджета CalendarGadget())
              Case "#PB_Gadget_TitleBackColor"  : \Param1\Get = #PB_Gadget_TitleBackColor  ; Цвет фона в заголовке 	 (для гаджета CalendarGadget())
              Case "#PB_Gadget_GrayTextColor"   : \Param1\Get = #PB_Gadget_GrayTextColor   ; Цвет для серого текста     (для гаджета CalendarGadget())
            EndSelect
          Case 3 
            \Param2\Def$=Arg$
            
            If \Type\Get$="SetGadgetColor"
              \Param2\Get = Val(Arg$)
              Result = GetVal(Arg$)
              If Result
                \Param2\Get = Result
              EndIf
            EndIf
            
            
        EndSelect
        
      Case "HideWindow",
           "HideGadget", 
           "DisableWindow",
           "DisableGadget",
           "StickyWindow"
        Select Index
          Case 1 : \ID\Get$ = Arg$
          Case 2 
            \Param1\Def$ = Arg$
            Select \Param1\Def$
              Case "#True" : \Param1\Get = #True
              Case "#False" : \Param1\Get = #False
              Default
                \Param1\Get = Val(\Param1\Def$)
            EndSelect
            \Param1\Get$ = Str(\Param1\Get)
        EndSelect
        
      Case "SetWindowColor"          
        Select Index
          Case 1 : \ID\Get$ = Arg$
          Case 2 
            \Param1\Def$ = Arg$
            \Param1\Get = Val(Arg$)
            Result = GetVal(Arg$)
            If Result
              \Param1\Get = Result
            EndIf
            \Param1\Get$ = Str(\Param1\Get)
        EndSelect
        
      Case "AddGadgetItem", "AddGadgetColumn", "OpenGadgetList"     
        Select Index
          Case 1 : \ID\Get$ = Arg$
          Case 2 
            \Param1\Def$ = Arg$    ; 
            \Param1\Get = Val(Arg$); 
          Case 3 
            \Param2\Def$=Arg$
            If \Type\Get$ = "AddGadgetItem"
              \Param2\Get$=GetItemText(Arg$)
            Else
              \Param2\Get$=GetStr(Arg$)
            EndIf
          Case 4 
            \Param3\Def$ = Arg$    ; 
            \Param3\Get = Val(Arg$)
          Case 5 ; TODO 
            \Flag\Def$ = Arg$
            If \Type\Get$ = "MDIGadget"
              MacroFlag(\Flag\Get, Arg$)
              \Flag\Get$ = Arg$
            Else
              \Flag\Get=Val(Arg$)
            EndIf
        EndSelect
        
      Case "ResizeWindow", "ResizeGadget"
        Select Index
          Case 1 : \ID\Get$ = Arg$
          Case 2 
            If "#PB_Ignore"=Arg$ 
              \X\Get = #PB_Ignore
            Else
              \X\Get = Val(Arg$)
            EndIf
            
          Case 3 
            If "#PB_Ignore"=Arg$ 
              \Y\Get = #PB_Ignore
            Else
              \Y\Get = Val(Arg$)
            EndIf
            
          Case 4 
            If "#PB_Ignore"=Arg$ 
              \Width\Get = #PB_Ignore
            Else
              \Width\Get = Val(Arg$)
            EndIf
            
          Case 5 
            If "#PB_Ignore"=Arg$ 
              \Height\Get = #PB_Ignore
            Else
              \Height\Get = Val(Arg$)
            EndIf
            
        EndSelect
        
    EndSelect
    
  EndWith
  
EndProcedure

Procedure SetPBFunction(*Function.FUNCTION_STRUCT)
  Protected Result, ID
  
  With *Function
    ID = ID(\ID\Get$)
    
    Select \Type\Get$
      Case "UsePNGImageDecoder"      : UsePNGImageDecoder()
      Case "UsePNGImageEncoder"      : UsePNGImageEncoder()
      Case "UseJPEGImageDecoder"     : UseJPEGImageDecoder()
      Case "UseJPEG2000ImageEncoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEG2000ImageDecoder" : UseJPEG2000ImageDecoder()
      Case "UseJPEGImageEncoder"     : UseJPEGImageEncoder()
      Case "UseGIFImageDecoder"      : UseGIFImageDecoder()
      Case "UseTGAImageDecoder"      : UseTGAImageDecoder()
      Case "UseTIFFImageDecoder"     : UseTIFFImageDecoder()
        
      Case "WindowEvent"             : \ID\Get=WindowEvent()
      Case "GetActiveWindow"         : \ID\Get=GetActiveWindow()
      Case "GetActiveGadget"         : \ID\Get=GetActiveGadget()
      Case "EventData"               : \ID\Get=EventData()
      Case "EventGadget"             : \ID\Get=EventGadget()
      Case "EventMenu"               : \ID\Get=EventMenu()
      Case "EventTimer"              : \ID\Get=EventTimer()
      Case "EventType"               : \ID\Get=EventType()
      Case "EventWindow"             : \ID\Get=EventWindow()
      Case "EventlParam"             : \ID\Get=EventlParam()
      Case "EventwParam"             : \ID\Get=EventwParam()     
        
      Case "LoadImage"               : \ID\Get=LoadImage(#PB_Any,\Param1\Get$)
      Case "LoadFont"                : \ID\Get=LoadFont(#PB_Any,\Param1\Get$,\Param2\Get,\Flag\Get)
      Case "SetGadgetFont"           : \ID\Get=ID(\Param1\Get$)
        If IsFont(\ID\Get)           : \Param1\Get=FontID(\ID\Get) : EndIf
      Case "SetGadgetState"          : \ID\Get=ID(\Param1\Get$) 
        If IsImage(\ID\Get)          : \Param1\Get=ImageID(\ID\Get) : EndIf
      Case "SetGadgetAttribute"      : \ID\Get=ID(\Param2\Get$)
        If IsImage(\ID\Get)          : \Param2\Get=ImageID(\ID\Get) : EndIf
        
      Case "OpenWindow", "OpenGadgetList", "CloseGadgetList",
           "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
           "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
           "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
           "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
           "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
           "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
           "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
           "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
        
        \ID\Get = OpenPBObject()
        
    EndSelect
    
    ;
    If \ID\Get And Not \Type\Get And Not ID
      AddMapElement(*This\Object(), \ID\Get$) 
      *This\Object()\ID\Get=\ID\Get
      *This\Object()\Index=@Function()
    EndIf 
    
    If IsWindow(ID)
      Select \Type\Get$
        Case "PostEvent"              : PostEvent(\Param1\Get,ID,\Param2\Get,\Param3\Get,\Flag\Get)
        Case "UnbindEvent"            : UnbindEvent(\Param1\Get,\Param2\Get,ID,\Param3\Get,\Flag\Get)
        Case "BindEvent"              : BindEvent(\Param1\Get,\Param2\Get,ID,\Param3\Get,\Flag\Get)
        Case "WindowBounds"           : WindowBounds(ID,\Param1\Get,\Param2\Get,\Param3\Get,\Flag\Get)
          
        Case "IsWindow"               : IsWindow(ID)
        Case "WindowID"               : WindowID(ID)
        Case "CloseWindow"            : CloseWindow(ID)
        Case "WindowMouseX"           : WindowMouseX(ID)
        Case "WindowMouseY"           : WindowMouseY(ID)
        Case "WindowOutput"           : WindowOutput(ID)
        Case "GetWindowData"          : GetWindowData(ID)
        Case "GetWindowColor"         : GetWindowColor(ID)
        Case "GetWindowState"         : GetWindowState(ID)
        Case "GetWindowTitle"         : GetWindowTitle(ID)
        Case "SetActiveWindow"        : SetActiveWindow(ID)
        Case "WindowX"                : WindowX(ID, \Param1\Get)
        Case "WindowY"                : WindowY(ID, \Param1\Get)
        Case "HideWindow"             : HideWindow(ID, \Param1\Get)
        Case "WaitWindowEvent"        : WaitWindowEvent(\Param1\Get)
        Case "StickyWindow"           : StickyWindow(ID, \Param1\Get)
        Case "DisableWindow"          : DisableWindow(ID, \Param1\Get)
        Case "SetWindowColor"         : SetWindowColor(ID, \Param1\Get)
        Case "WindowWidth"            : WindowWidth(ID, \Param1\Get)
        Case "WindowHeight"           : WindowHeight(ID, \Param1\Get)
        Case "SetWindowData"          : SetWindowData(ID, \Param1\Get)
        Case "SetWindowState"         : SetWindowState(ID, \Param1\Get)
        Case "SetWindowTitle"         : SetWindowTitle(ID, \Param1\Get$)
        Case "RemoveWindowTimer"      : RemoveWindowTimer(ID, \Param1\Get)
        Case "WindowVectorOutput"     : WindowVectorOutput(ID, \Param1\Get)
        Case "SmartWindowRefresh"     : SmartWindowRefresh(ID, \Param1\Get)
        Case "SetWindowCallback"      : SetWindowCallback(\Param1\Get, ID)
        Case "RemoveKeyboardShortcut" : RemoveKeyboardShortcut(ID, \Param1\Get)
        Case "AddWindowTimer"         : AddWindowTimer(ID, \Param1\Get, \Param2\Get)
        Case "AddKeyboardShortcut"    : AddKeyboardShortcut(ID, \Param1\Get, \Param2\Get)
        Case "ResizeWindow"           : ResizeWindow(ID, \X\Get, \Y\Get, \Width\Get, \Height\Get)
      EndSelect
    EndIf
    
    If IsGadget(ID)
      Select \Type\Get$
        Case "GetGadgetState"         : GetGadgetState(ID)
        Case "GetGadgetText"          : GetGadgetText(ID)
        Case "IsGadget"               : IsGadget(ID)
        Case "GadgetID"               : GadgetID(ID)
        Case "GadgetType"             : GadgetType(ID)
        Case "CanvasOutput"           : CanvasOutput(ID)
        Case "ClearGadgetItems"       : ClearGadgetItems(ID)
        Case "CountGadgetItems"       : CountGadgetItems(ID)
        Case "FreeGadget"             : FreeGadget(ID)
        Case "GetGadgetData"          : GetGadgetData(ID)
        Case "GetGadgetFont"          : GetGadgetFont(ID)
        Case "UseGadgetList"          : UseGadgetList(WindowID)
          
        Case "GadgetHeight"           : GadgetHeight(ID,\Param1\Get)
        Case "GadgetItemID"           : GadgetItemID(ID,\Param1\Get)
        Case "GadgetToolTip"          : GadgetToolTip(ID,\Param1\Get$)
        Case "GadgetWidth"            : GadgetWidth(ID,\Param1\Get)
        Case "GadgetX"                : GadgetX(ID,\Param1\Get)
        Case "GadgetY"                : GadgetY(ID,\Param1\Get)
        Case "SetActiveGadget"        : SetActiveGadget(ID)
        Case "CanvasVectorOutput"     : CanvasVectorOutput(ID,\Param1\Get)
        Case "DisableGadget"          : DisableGadget(ID,\Param1\Get)
        Case "HideGadget"             : HideGadget(ID,\Param1\Get)
        Case "OpenGadgetList"         : OpenGadgetList(ID,\Param1\Get)
        Case "RemoveGadgetColumn"     : RemoveGadgetColumn(ID,\Param1\Get)
        Case "RemoveGadgetItem"       : RemoveGadgetItem(ID,\Param1\Get)
        Case "SetGadgetData"          : SetGadgetData(ID,\Param1\Get)
        Case "SetGadgetFont"          : SetGadgetFont(ID,\Param1\Get)
        Case "SetGadgetState"         : SetGadgetState(ID,\Param1\Get)
        Case "SetGadgetText"          : SetGadgetText(ID,\Param1\Get$)
        Case "GetGadgetAttribute"     : GetGadgetAttribute(ID,\Param1\Get)
        Case "GetGadgetColor"         : GetGadgetColor(ID,\Param1\Get)
        Case "GetGadgetItemData"      : GetGadgetItemData(ID,\Param1\Get)
        Case "GetGadgetItemState"     : GetGadgetItemState(ID,\Param1\Get)
          
        Case "SetGadgetAttribute"     : SetGadgetAttribute(ID,\Param1\Get,\Param2\Get)
        Case "SetGadgetColor"         : SetGadgetColor(ID,\Param1\Get,\Param2\Get)
        Case "SetGadgetItemData"      : SetGadgetItemData(ID,\Param1\Get,\Param2\Get)
        Case "SetGadgetItemImage"     : SetGadgetItemImage(ID,\Param1\Get,\Param2\Get)
        Case "SetGadgetItemState"     : SetGadgetItemState(ID,\Param1\Get,\Param2\Get)
        Case "GetGadgetItemText"      : GetGadgetItemText(ID,\Param1\Get,\Param2\Get)
        Case "BindGadgetEvent"        : BindGadgetEvent(ID,\Param1\Get,\Param2\Get)
        Case "UnbindGadgetEvent"      : UnbindGadgetEvent(ID,\Param1\Get,\Param2\Get)
          
        Case "SetGadgetItemText"      : SetGadgetItemText(ID,\Param1\Get,\Param2\Get$,\Param3\Get)
        Case "GetGadgetItemAttribute" : GetGadgetItemAttribute(ID,\Param1\Get,\Param2\Get,\Param3\Get)
        Case "GetGadgetItemColor"     : GetGadgetItemColor(ID,\Param1\Get,\Param2\Get,\Param3\Get)
        Case "AddGadgetColumn"        : AddGadgetColumn(ID,\Param1\Get,\Param2\Get$,\Param3\Get)
          
        Case "SetGadgetItemAttribute" : SetGadgetItemAttribute(ID,\Param1\Get,\Param2\Get,\Param3\Get,\Flag\Get)
        Case "SetGadgetItemColor"     : SetGadgetItemColor(ID,\Param1\Get,\Param2\Get,\Param3\Get,\Flag\Get)
        Case "AddGadgetItem"          : AddGadgetItem(ID,\Param1\Get,\Param2\Get$,\Param3\Get,\Flag\Get)
        Case "ResizeGadget"           : ResizeGadget(ID, \X\Get, \Y\Get, \Width\Get, \Height\Get)
          Transformation::Update(ID)
          
      EndSelect
    EndIf
  EndWith
    
EndProcedure
