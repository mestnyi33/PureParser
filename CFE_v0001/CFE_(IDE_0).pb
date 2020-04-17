;-
XIncludeFile "CFE.pbi"
Declare CFE_Helper_Image(Parent =- 1, *Image.Integer=0, *Puth.String=0, WindowID = #False, Flag.q = #_Flag_ScreenCentered)
XIncludeFile "CFE_Helper_Image.pbi"

Declare NewElementEvents(Event.q, EventElement)

Procedure.S IsFindFunctions(ReadString$) ; Ok
  Protected Finds.S, Type.S
  Restore Types
  Read$ Type.S
  
  While Type.S 
    If FindString(ReadString$, Type.S+"(") 
      Finds.S = "Find >> "+ReadString$
    EndIf
    
    If Finds.S
      Break
    EndIf
    Read$ Type.S
  Wend
  
  ProcedureReturn Finds.S
  
  DataSection
    Types: 
    Data$ "OpenWindow"
    Data$ "ButtonGadget","StringGadget","TextGadget","CheckBoxGadget",
          "OptionGadget","ListViewGadget","FrameGadget","ComboBoxGadget",
          "ImageGadget","HyperLinkGadget","ContainerGadget","ListIconGadget",
          "IPAddressGadget","ProgressBarGadget","ScrollBarGadget","ScrollAreaGadget",
          "TrackBarGadget","WebGadget","ButtonImageGadget","CalendarGadget",
          "DateGadget","EditorGadget","ExplorerListGadget","ExplorerTreeGadget",
          "ExplorerComboGadget","SpinGadget","TreeGadget","PanelGadget",
          "SplitterGadget","MDIGadget","ScintillaGadget","ShortcutGadget","CanvasGadget"
    Data$ ""
  EndDataSection
EndProcedure



Procedure LoadGadgetImage(Gadget, Directory$)
  Protected ZipFile$ = Directory$ + "SilkTheme.zip"
  
  If FileSize(ZipFile$) < 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
    CompilerElse
      ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
    CompilerEndIf
    If FileSize(ZipFile$) < 1
      MessageRequester("Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
      End
    EndIf
  EndIf
  
  If FileSize(ZipFile$) > 0
    UsePNGImageDecoder()
    
    CompilerIf #PB_Compiler_Version > 522
      UseZipPacker()
    CompilerEndIf
    
    Protected PackEntryName.s, ImageSize, *Image, Image, ZipFile
    ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
    
    If ZipFile  
      If ExaminePack(ZipFile)
        While NextPackEntry(ZipFile)
          
          PackEntryName.S = PackEntryName(ZipFile)
          ImageSize = PackEntrySize(ZipFile)
          If ImageSize
            *Image = AllocateMemory(ImageSize)
          UncompressPackMemory(ZipFile, *Image, ImageSize)
          Image = CatchImage(#PB_Any, *Image, ImageSize)
          PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
          If PackEntryName.S="application_form" 
            PackEntryName.S="vd_windowgadget"
          EndIf
          
          PackEntryName.S = ReplaceString(PackEntryName.S,"page_white_edit","vd_scintillagadget")   ;vd_scintillagadget.png not found. Use page_white_edit.png instead
                
          Select PackEntryType(ZipFile)
            Case #PB_Packer_File
              If Image
                If FindString(Left(PackEntryName.S, 3), "vd_")
                  PackEntryName.S = ReplaceString(PackEntryName.S,"vd_"," ")
                  PackEntryName.S = Trim(ReplaceString(PackEntryName.S,"gadget",""))
                  
                  Protected Left.S = UCase(Left(PackEntryName.S,1))
                  Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
                  PackEntryName.S = " "+Left.S+Right.S
                  
                  If FindString(LCase(PackEntryName.S), "cursor")
                    
                    ;SetGadgetAttribute(Gadget, #PB_Button_Image, Image)
                    AddGadgetElementItem(Gadget, 0, PackEntryName.S, Image)
                  Else
                    AddGadgetElementItem(Gadget, -1, PackEntryName.S, Image)
                  EndIf
                EndIf
              EndIf    
          EndSelect
          
          FreeMemory(*Image)
          EndIf
        Wend  
      EndIf
      
      ClosePack(ZipFile)
    EndIf
  EndIf
EndProcedure


;-
;- PROGRAMM

#Title$ = "IDE"

Enumeration Elements
  #InspectorWindow
  #InspectorProperties
  #InspectorElements
  #InspectorEvents
  
EndEnumeration

Enumeration MenuItem 1
  #IDE_MenuItem_New
  #IDE_MenuItem_Save
  #IDE_MenuItem_Open
  #IDE_MenuItem_Delete
  #IDE_MenuItem_Form_Code
  
  
  #IDE_MenuItem_Undo
  #IDE_MenuItem_Redo
  
  #IDE_MenuItem_First
  #IDE_MenuItem_Prev
  #IDE_MenuItem_Next
  #IDE_MenuItem_Last
  
  
  
  #IDE_MenuItem_Quit
EndEnumeration



Global DragElementType=0, IDE_PopupMenu=-1, IDE_EditPopupMenu=-1

Global IDE=-1, IDE_Menu_0=-1, IDE_Toolbar_0=-1, IDE_cp=-1, IDE_pp=-1
Global IDE_Splitter_0=-1, IDE_Splitter_4=-1, IDE_List_0=-1, IDE_Scintilla_0=-1, IDE_Canvas_0

Global IDE_sProperties=-1, IDE_Properties=-1, IDE_iProperties=-1
Global IDE_sElements=-1, IDE_Elements=-1, IDE_iElements=-1
Global IDE_sEvents=-1, IDE_Events=-1, IDE_iEvents=-1

Global Properties_Element=-1, Properties_Caption=-1, Properties_ToolTip=-1, Properties_ID=-1, Properties_X=-1, Properties_Y=-1,
       Properties_Width=-1, Properties_Height=-1, Properties_Flag=-1, Properties_Enable=-1, Properties_Puch=-1

Global Events_LeftClick=-1, Events_RightClick=-1, Events_LeftDown=-1, Events_LeftUp=-1
;-
Procedure.S CreateType_PB(Type)
  Protected Result.S
  
  Select Type
    Case #_Type_Window : Result = "OpenWindow"
    Case #_Type_Button : Result = "ButtonGadget"
    Case #_Type_ButtonImage : Result = "ButtonImageGadget"
  EndSelect
  
  ProcedureReturn Result
EndProcedure

Procedure GeneratePBCode(Panel)
  Protected Type
  Protected Count
  Protected Parent
  Protected Element
  Protected Class$,Code$
  
  With *CreateElement
    ; is element
    If IsElementChildrens(Panel, 0)
      Code$ + "EnableExplicit" +#CRLF$+#CRLF$
      Code$ + "Define Event" +#CRLF$
      
      ; global var enumeration
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Item\State = 0
          Element = \This()\Element
          
          Code$ +"Global "+ GetElementClass(Element)+"=-1"
          PushListPosition(\This())
          ForEach \This()
            If IsChildElement(\This()\Element, Element) And \This()\Element <> Element
              If Code$ : Code$+", " : EndIf : Code$ +GetElementClass(\This()\Element)+"=-1"
            EndIf
          Next
          PopListPosition(\This())
          Code$ +#CRLF$
          
        EndIf
      Next
      PopListPosition(\This())
      
      Code$ +#CRLF$
      
      ;     While EnumerateElement(@Element, Panel, 0)
      ;       Class$ + GetElementClass(Element)+"|"
      ;     Wend
      ;     Code$ + Code::Code_Event_Procedure(0, Class$, GetClassElementEvents(Type), "") 
      ; 
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Item\State = 0
          Element = \This()\Element
          
          Code$ +"Procedure Open_"+ GetElementClass(Element)+"()"+#CRLF$
          PushListPosition(\This())
          ForEach \This()
            If IsChildElement(\This()\Element, Element)
              Code$ +"  "+ GetElementClass(\This()\Element)+" = "
              
              Select \This()\Type 
                Case #_Type_Window
                  Code$ +"Open"+ElementClass(\This()\Type)+"(#PB_Any, "+
                         Str(\This()\FrameCoordinate\X)+", "+
                         Str(\This()\FrameCoordinate\Y)+", "+
                         Str(\This()\FrameCoordinate\Width-(\This()\bSize)*2)+", "+
                         Str(\This()\FrameCoordinate\Height-(\This()\bSize)*2-\This()\CaptionHeight)
                  
                Default
                  Code$ + ElementClass(\This()\Type)+"Gadget(#PB_Any, "+
                          Str(\This()\ContainerCoordinate\X+(\This()\bSize-\This()\BorderSize))+", "+
                          Str(\This()\ContainerCoordinate\Y+(\This()\bSize-\This()\BorderSize))+", "+
                          Str(\This()\FrameCoordinate\Width-(\This()\bSize-\This()\BorderSize)*2)+", "+
                          Str(\This()\FrameCoordinate\Height-(\This()\bSize-\This()\BorderSize)*2)
              EndSelect
              
              
              ; Caption
              Select \This()\Type
                Case #_Type_Window, #_Type_Button, #_Type_String, 
                     #_Type_Text, #_Type_CheckBox, #_Type_Option,
                     #_Type_Frame, #_Type_HyperLink, #_Type_ListIcon,
                     #_Type_Web, #_Type_Date, #_Type_ExplorerList,
                     #_Type_ExplorerTree, #_Type_ExplorerCombo
                  
                  Protected ElementText$ = GetElementText(\This()\Element)
                  If ElementText$
                    Code$ +", "+Chr('"')+ ElementText$ +Chr('"')
                  EndIf
              EndSelect
              
              ; Param1
              Select \This()\Type
                Case #_Type_Spin : Code$ +", "+ \This()\Spin\Min
                Case #_Type_Splitter : Code$ +", "+ \This()\Splitter\FirstElement
                Case #_Type_TrackBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_Image, #_Type_ButtonImage 
                  If IsImage(\This()\Img\Image)
                    Code$ +", ImageID("+ \This()\Img\Image+")"
                  Else
                    Code$ +", 0"
                  EndIf
                Case #_Type_HyperLink : Code$ +", "+ \This()\BackColor
                  ; Case #_Type_ListIcon : Code$ +", "+ \This()\FirstColumWidth
                Case #_Type_ProgressBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\Min 
                  ; Case #_Type_Date, #_Type_Calendar : Code$ +", "+ \This()\Date
                Case #_Type_MDI
                  ; Case #_Type_Scintilla : Code$ +", "+ \This()\CallBack
                  ; Case #_Type_Shortcut : Code$ +", "+ \This()\Shortcut
              EndSelect
              
              ; Param2
              Select \This()\Type
                Case #_Type_ProgressBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_TrackBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_Spin : Code$ +", "+ \This()\Spin\Max
                Case #_Type_Splitter : Code$ +", "+ \This()\Splitter\SecondElement
                Case #_Type_MDI 
              EndSelect
              
              ; Param3
              Select \This()\Type
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\PageLength
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\ScrollStep
              EndSelect
              
              
              If \This()\Flag
                Protected Flag$ ;= Trim(GetElementClass(\This()\Flag, \This()\Type))
                If Flag$
                  Code$ +", "+ Flag$
                EndIf
              EndIf
              
              Code$ +")"+ #CRLF$
              
            EndIf
          Next
          PopListPosition(\This())
          Code$ +"EndProcedure"+#CRLF$+#CRLF$
          
        EndIf
      Next
      PopListPosition(\This())
      
      
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Item\State = 0
          Element = \This()\Element
          
          Code$ +"CompilerIf #PB_Compiler_IsMainFile"+#CRLF$
          Code$ +"  Open_"+ GetElementClass(Element)+"()"+#CRLF$+#CRLF$
          
          Code$ +"  While IsWindow("+ GetElementClass(Element)+")"+#CRLF$
          Code$ +"    Event = WaitWindowEvent()"+#CRLF$+#CRLF$
          Code$ +"    Select Event"+#CRLF$
          Code$ +"       Case #PB_Event_CloseWindow"+#CRLF$
          Code$ +"         CloseWindow(EventWindow())"+#CRLF$
          Code$ +"    EndSelect"+#CRLF$+#CRLF$
          Code$ +"    Select EventWindow()"+#CRLF$
          
          PushListPosition(\This())
          ForEach \This()
            If \This()\Parent\Element = Panel And \This()\Item\State = 0
              Element = \This()\Element
              Code$ +"      Case "+GetElementClass(\This()\Element)+#CRLF$
              ; If Code$ : Code$+", " : EndIf : Code$ +GetElementClass(\This()\Element)+"=-1"
            EndIf
          Next
          PopListPosition(\This())
          
          Code$ +"    EndSelect"+#CRLF$
          Code$ +"  Wend"+#CRLF$+#CRLF$
          Code$ +"  End"+#CRLF$
          Code$ +"CompilerEndIf"+#CRLF$
          
        EndIf
      Next
      PopListPosition(\This())
      
      Code$ + #CRLF$ + #CRLF$
      
;       SetClipboardText(Code$)
      SetElementText(IDE_Scintilla_0,Code$)
      
      
      
; ;       Debug GetCurrentDirectory()
; ;       Protected Name$ = ElementClass(CheckType)+"_"+Str(CountElementType(CheckType))
; ;       Debug #PB_Compiler_Home+"Compilers\pbcompiler";Name$  ;           Puth$ = GetCurrentDirectory() +"Create_Code_Example\"
; ;                                                     ;           Debug GetPathPart(Puth$)
; ;                                                     ;CLI> pbcompiler "C:\Project\Source\DLLSource.pb" /EXEChr(34)++Chr(34)
; ;                                                     ;RunProgram(#PB_Compiler_Home+"/Compilers/pbcompiler", Puth$+ " /QUIET /XP /UNICODE /ADMINISTRATOR /EXE "+ArrayWindow(0)\Name$+".exe" , GetPathPart(Puth$), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
; ;       RunProgram(#PB_Compiler_Home+"Compilers\pbcompiler", "/QUIET /XP /ADMINISTRATOR "+""+Name$+".pb /EXE "+Name$+".exe", GetCurrentDirectory(), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
; ;       RunProgram("C:\"+Name$+".exe")
      
    EndIf
    
  EndWith
  
  
EndProcedure

Procedure _GeneratePBCode(Panel)
  Protected Type
  Protected Count
  Protected Parent
  Protected Element
  Protected Class$,Code$
  Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
         
  With *CreateElement
    ; is element
    If IsElementChildrens(Panel, 0)
      Code$ + "EnableExplicit" +#CRLF$+#CRLF$
      
      PushListPosition(\This())
      ForEach \This()
        
        ;UseIMAGEDecoder
        If IsImage(\This()\Img\Image)
          Select ImageFormat(\This()\Img\Image)
            Case #PB_ImagePlugin_JPEG
              If JPEGPlugin$ <> "UseJPEGImageDecoder()"
                JPEGPlugin$ = "UseJPEGImageDecoder()"
                Code$ +"UseJPEGImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_JPEG2000
              If JPEG2000Plugin$ <> "UseJPEG2000ImageDecoder()"
                JPEG2000Plugin$ = "UseJPEG2000ImageDecoder()"
                Code$ +"UseJPEG2000ImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_PNG
              If PNGPlugin$ <> "UsePNGImageDecoder()"
                PNGPlugin$ = "UsePNGImageDecoder()"
                Code$ +"UsePNGImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_TGA
              If TGAPlugin$ <> "UseTGAImageDecoder()"
                TGAPlugin$ = "UseTGAImageDecoder()"
                Code$ +"UseTGAImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_TIFF
              If TIFFPlugin$ <> "UseTIFFImageDecoder()"
                TIFFPlugin$ = "UseTIFFImageDecoder()"
                Code$ +"UseTIFFImageDecoder()"+ #CRLF$
              EndIf
            Case #PB_ImagePlugin_BMP
             
            Case #PB_ImagePlugin_ICON
              
          EndSelect
          
          Code$ +"LoadImage("+\This()\Img\Image+", "+#DQUOTE$+\ImagePuch(Str(\This()\Img\Image))+#DQUOTE$+")"+#CRLF$
        EndIf
        
      Next
      PopListPosition(\This())
      
      Code$ + "Define Event" +#CRLF$
      
      ; global var enumeration
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Item\State = 0
          Element = \This()\Element
          
          Code$ +"Global "+ GetElementClass(Element)+"=-1"
          PushListPosition(\This())
          ForEach \This() 
            If (IsChildElement(\This()\Element, Element) = 0 Or \This()\Element = Element) : Continue : EndIf
            If Code$ : Code$+", " : EndIf : Code$ +GetElementClass(\This()\Element)+"=-1"
          Next
          PopListPosition(\This())
          Code$ +#CRLF$
          
          Debug GetElementEvents(Element)
        EndIf
      Next
      PopListPosition(\This())
      
      Code$ +#CRLF$
      
      ;     While EnumerateElement(@Element, Panel, 0)
      ;       Class$ + GetElementClass(Element)+"|"
      ;     Wend
      
      ; Code$ + Code::Code_Event_Procedure(0, Class$, GetClassElementEvents(Type), "") 
      ; 
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Item\State = 0
          Element = \This()\Element
          
          Code$ +"Procedure Open_"+ GetElementClass(Element)+"()"+#CRLF$
          PushListPosition(\This())
          ForEach \This()
            If IsChildElement(\This()\Element, Element)
              Code$ +"  "+ GetElementClass(\This()\Element)+" = "
              
              Select \This()\Type 
                Case #_Type_Window
                  Code$ +"Open"+ElementClass(\This()\Type)+"(#PB_Any, "+
                         Str(\This()\FrameCoordinate\X)+", "+
                         Str(\This()\FrameCoordinate\Y)+", "+
                         Str(\This()\FrameCoordinate\Width-(\This()\bSize)*2)+", "+
                         Str(\This()\FrameCoordinate\Height-(\This()\bSize)*2-\This()\CaptionHeight)
                  
                Default
                  Code$ + ElementClass(\This()\Type)+"Gadget(#PB_Any, "+
                          Str(\This()\ContainerCoordinate\X+(\This()\bSize-\This()\BorderSize))+", "+
                          Str(\This()\ContainerCoordinate\Y+(\This()\bSize-\This()\BorderSize))+", "+
                          Str(\This()\FrameCoordinate\Width-(\This()\bSize-\This()\BorderSize)*2)+", "+
                          Str(\This()\FrameCoordinate\Height-(\This()\bSize-\This()\BorderSize)*2)
              EndSelect
              
              
              ; Caption
              Select \This()\Type
                Case #_Type_Window, #_Type_Button, #_Type_String, 
                     #_Type_Text, #_Type_CheckBox, #_Type_Option,
                     #_Type_Frame, #_Type_HyperLink, #_Type_ListIcon,
                     #_Type_Web, #_Type_Date, #_Type_ExplorerList,
                     #_Type_ExplorerTree, #_Type_ExplorerCombo
                  
                  Protected ElementText$ = GetElementText(\This()\Element)
                  If ElementText$
                    Code$ +", "+Chr('"')+ ElementText$ +Chr('"')
                  EndIf
              EndSelect
              
              ; Param1
              Select \This()\Type
                Case #_Type_Spin : Code$ +", "+ \This()\Spin\Min
                Case #_Type_Splitter : Code$ +", "+ \This()\Splitter\FirstElement
                Case #_Type_TrackBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_Image, #_Type_ButtonImage 
                  If IsImage(\This()\Img\Image)
                    Code$ +", ImageID("+ \This()\Img\Image+")"
                  Else
                    Code$ +", 0"
                  EndIf
                Case #_Type_HyperLink : Code$ +", "+ \This()\BackColor
                  ; Case #_Type_ListIcon : Code$ +", "+ \This()\FirstColumWidth
                Case #_Type_ProgressBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\Min 
                  ; Case #_Type_Date, #_Type_Calendar : Code$ +", "+ \This()\Date
                Case #_Type_MDI
                  ; Case #_Type_Scintilla : Code$ +", "+ \This()\CallBack
                  ; Case #_Type_Shortcut : Code$ +", "+ \This()\Shortcut
              EndSelect
              
              ; Param2
              Select \This()\Type
                Case #_Type_ProgressBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_TrackBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_Spin : Code$ +", "+ \This()\Spin\Max
                Case #_Type_Splitter : Code$ +", "+ \This()\Splitter\SecondElement
                Case #_Type_MDI 
              EndSelect
              
              ; Param3
              Select \This()\Type
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\PageLength
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\ScrollStep
              EndSelect
              
              
              If \This()\Flag
                Protected Flag$ ;= Trim(GetNewElementFlagClass(\This()\Flag, \This()\Type))
                If Flag$
                  Code$ +", "+ Flag$
                EndIf
              EndIf
              
              Code$ +")"+ #CRLF$
              
            EndIf
          Next
          PopListPosition(\This())
          
          If \StickyWindow = Element
            Code$ +"  StickyWindow("+GetElementClass(\This()\Element)+", #True)"+#CRLF$
          EndIf
          
          Code$ + #CRLF$
          
          PushListPosition(\This())
          ForEach \This()
            If IsChildElement(\This()\Element, Element)
              
              If \This()\ToolTip\String$
                Code$ +"  GadgetToolTip("+GetElementClass(\This()\Element)+", "+#DQUOTE$+\This()\ToolTip\String$+#DQUOTE$+")"+#CRLF$
              EndIf
              If IsImage(\This()\Img\Image)
              ;  Code$ +"  SetGadgetState("+GetElementClass(\This()\Element)+", ImageID("+\This()\Img\Image+"))"+#CRLF$
              EndIf
              If \This()\FontColorState
                Code$ +"  SetGadgetAttribute("+GetElementClass(\This()\Element)+", #PB_Gadget_FrontColor, $"+Hex(\This()\FontColor)+")"+#CRLF$
              EndIf
              If \This()\BackColorState
                Code$ +"  SetGadgetAttribute("+GetElementClass(\This()\Element)+", #PB_Gadget_BackColor, $"+Hex(\This()\BackColor)+")"+#CRLF$
              EndIf
              If \This()\DisableState
                Code$ +"  DisableGadget("+GetElementClass(\This()\Element)+", #True)"+#CRLF$
              EndIf
              If \This()\HideState 
                Code$ +"  HideGadget("+GetElementClass(\This()\Element)+", #True)"+#CRLF$
              EndIf
              
      
            EndIf
          Next
          PopListPosition(\This())
          
          Code$ +"EndProcedure"+#CRLF$+#CRLF$
          
        EndIf
      Next
      PopListPosition(\This())
      
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Item\State = 0
          Element = \This()\Element
          
          Code$ +"CompilerIf #PB_Compiler_IsMainFile"+#CRLF$
          Code$ +"  Open_"+ GetElementClass(Element)+"()"+#CRLF$+#CRLF$
          
          Code$ +"  While IsWindow("+ GetElementClass(Element)+")"+#CRLF$
          Code$ +"    Event = WaitWindowEvent()"+#CRLF$+#CRLF$
          Code$ +"    Select Event"+#CRLF$
          Code$ +"       Case #PB_Event_CloseWindow"+#CRLF$
          Code$ +"         CloseWindow(EventWindow())"+#CRLF$
          Code$ +"    EndSelect"+#CRLF$+#CRLF$
          Code$ +"    Select EventWindow()"+#CRLF$
          
          PushListPosition(\This())
          ForEach \This()
            If \This()\Parent\Element = Panel And \This()\Item\State = 0
              Element = \This()\Element
              Code$ +"      Case "+GetElementClass(\This()\Element)+#CRLF$
              ; If Code$ : Code$+", " : EndIf : Code$ +GetElementClass(\This()\Element)+"=-1"
            EndIf
          Next
          PopListPosition(\This())
          
          Code$ +"    EndSelect"+#CRLF$
          Code$ +"  Wend"+#CRLF$+#CRLF$
          Code$ +"  End"+#CRLF$
          Code$ +"CompilerEndIf"+#CRLF$
          
        EndIf
      Next
      PopListPosition(\This())
      
      Code$ + #CRLF$ + #CRLF$
      
;       SetClipboardText(Code$)
      SetElementText(IDE_Scintilla_0,Code$)
      
      
      
; ;       Debug GetCurrentDirectory()
; ;       Protected Name$ = ElementClass(CheckType)+"_"+Str(CountElementType(CheckType))
; ;       Debug #PB_Compiler_Home+"Compilers\pbcompiler";Name$  ;           Puth$ = GetCurrentDirectory() +"Create_Code_Example\"
; ;                                                     ;           Debug GetPathPart(Puth$)
; ;                                                     ;CLI> pbcompiler "C:\Project\Source\DLLSource.pb" /EXEChr(34)++Chr(34)
; ;                                                     ;RunProgram(#PB_Compiler_Home+"/Compilers/pbcompiler", Puth$+ " /QUIET /XP /UNICODE /ADMINISTRATOR /EXE "+ArrayWindow(0)\Name$+".exe" , GetPathPart(Puth$), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
; ;       RunProgram(#PB_Compiler_Home+"Compilers\pbcompiler", "/QUIET /XP /ADMINISTRATOR "+""+Name$+".pb /EXE "+Name$+".exe", GetCurrentDirectory(), #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
; ;       RunProgram("C:\"+Name$+".exe")
      
    EndIf
    
  EndWith
  
  
EndProcedure


;-
; Рисунок фона окна
Procedure Mosaic(Steps, InnerX=0,InnerY=0,InnerWidth=100,InnerHeight=100)
  Protected Img_X, Img_Y, Image =- 1 : Steps - 1
  Image = CreateImage(#PB_Any,InnerWidth-1,InnerHeight-1,32,#PB_2DDrawing_Transparent)
  
  If IsImage(Image) And StartDrawing(ImageOutput(Image))
    DrawingMode(#PB_2DDrawing_AllChannels)
    Box(0,0,OutputWidth(),OutputHeight(),RGBA(0,0,0,0)) ; Прозрачный фон
    
    For Img_X = (InnerX) To (InnerX + InnerWidth)-Steps
      For Img_Y = (InnerY) To (InnerY + InnerHeight)-Steps
        
        Plot(Img_X,Img_Y,RGBA(0,0,0,255))
        
        Img_Y+Steps
      Next
      
      Img_X+Steps
    Next 
    
    StopDrawing()
  EndIf
  
  ProcedureReturn Image
EndProcedure

Procedure.S Help(Class.S)
  Protected Result.S
  
  Select Type(Class.S)
    Case 0
      Result.S = "Элемент не выбран"
      
    Case #_Type_Date
      Result.S = "Первая строка"+#CRLF$+
                 "Вторая строка"
      
    Case #_Type_Window
      Result.S = "Это окно (Window)"
      
    Case #_Type_Button
      Result.S = "Это кнопка (Button)"
      
    Case #_Type_ButtonImage
      Result.S = "Это кнопка картинка (ButtonImage)"
      
      ;     Case #_Type_Calendar
      ;       Result.S = "Это календарь (Calendar)"
      
      ;     Case #_Type_Canvas
      ;       Result.S = "Это холст для рисования (Canvas)"
      
    Case #_Type_CheckBox
      Result.S = "Это переключатель (CheckBox)"
      
    Case #_Type_Container
      Result.S = "Это контейнер для других элементов (Container)"
      
    Case #_Type_ComboBox
      Result.S = "Это выподающий список (ComboBox)"
      
    Case #_Type_Editor
      Result.S = "1строка 2строка 3строка 4строка 5строка 6строка 7строка 8строка 9строка 10строка 11строка 12строка 13строка 14строка 15строка 16строка 17строка 18строка 19строка 20строка 21строка"
      
    Default
      Result.S = "Еще не реализованно еееееееееееееееееееееееееееееее"
      
  EndSelect
  
  ProcedureReturn Result.S
EndProcedure

Define i
Global img_point = Mosaic(Steps, 0,0,800,600)



;-
Procedure FilterCallback(X, Y, SourceColor, TargetColor)
  Static z
  Protected Color, Dot=4, line = 10
  
  If (z%(Line+Dot*2+1))<line Or (z%(Line+Dot*2+1))=line+Dot
    Color = SourceColor
  Else
    Color = TargetColor
  EndIf
  
  z+1
  ProcedureReturn Color
EndProcedure

Procedure CreateNewElement(Element) ; Then create new element
  Protected Item, State
  
  Item = AddGadgetElementItem(Properties_Element, #PB_Any, ElementClass(ElementType(Element))+" ("+GetElementClass(Element)+")") 
  SetElementItemData(Properties_Element, Item, Element)
  SetElementData(Element, Item)
  
  State = GetElementState(IDE_Elements) : If State = 0 : State = 1 : EndIf
  AddGadgetElementItem(IDE_Canvas_0, #PB_Any, "", GetElementItemImage(IDE_Elements, State))
EndProcedure

Procedure ResetNewElement()
  SetElementState(IDE_Elements, 0)
  SetElementText(IDE_iElements, Help(GetElementItemText(IDE_Elements)))
  DragElementType = 0
  *CreateElement\DragElementType = 0
    SetElementCustomCursor()
      
EndProcedure

Procedure DeleteNewElement(Element)
  Protected EnumerateElement
  ;   
  FreeElement(Element)
  
;   ClearElementItems(Properties_Element)
;   While EnumerateElement(@EnumerateElement, IDE_cp, 0)
;     AddGadgetElementItem(Properties_Element, #PB_Any, ElementClass(ElementType(EnumerateElement))+" ("+Str(EnumerateElement)+")")
;   Wend
EndProcedure

Procedure AddNewElement(Type, Parent, Item, Reset.b)
  Protected Element =- 1, X = #PB_Ignore, Y = #PB_Ignore, Width, Height
  
  If Type
    If Parent = EventElement()
      X = ElementMouseX(Parent)-4
      Y = ElementMouseY(Parent)-4
    EndIf
    
    CompilerIf #PB_Compiler_IsIncludeFile
      X = 10
      Y = 10
    CompilerEndIf
    
    SetAnchors(#PB_Default) ; Reset anchors
    If IsElement(Parent) : OpenElementList(Parent, Item) : EndIf
    
    Select Type 
      Case #_Type_Container, #_Type_ScrollArea, #_Type_Panel, 
           #_Type_Splitter, #_Type_ListView, #_Type_ListIcon, #_Type_Image 
        Width = 220
        Height = 140
        
      Case #_Type_Window
        Width = 300
        Height = 150
        
      Default
        Width = 130
        Height = 25
        
    EndSelect
    
    With *CreateElement\Selector
      If \right And \bottom
        X = \left
        Y = \top
        Width = \right
        Height = \bottom
        \left = 0 : \top = 0 : \right = 0 : \bottom = 0
      EndIf
    EndWith 
    
    Element = CreateElement(Type, #PB_Any, X,Y,Width,Height, "", #PB_Default,#PB_Default,#PB_Default, #_Flag_AnchorsGadget)
    ;SetElementFont(Element, FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality)))
    
    Select Type 
      Case #_Type_Container, #_Type_ScrollArea, #_Type_Panel, #_Type_Splitter
        img_point = Mosaic(Steps, 0,0,800,600)
        SetElementBackGroundImage(Element, img_point)
        
      Case #_Type_Window
        img_point = Mosaic(Steps, 0,0,800,600)
        SetElementBackGroundImage(Element, img_point)
        
        BindEventElement(@NewElementEvents(), Element, #PB_All)
      Default
        
    EndSelect
    
    
    If IsContainerElement(Element) : CloseElementList() : EndIf
  EndIf 
  
    If IsWindowElement(Element)
        IDE_PopupMenu = CreatePopupMenuElement()
        
        OpenSubMenuElement("Z-Order")
          MenuElementItem(0, "First")
          MenuElementItem(1, "Prev")
          MenuElementItem(2, "Next")
          MenuElementItem(3, "Last")
        CloseSubMenuElement()
        
        MenuElementBar()
        
        MenuElementItem(4, "Cut", GetButtonIcon(#PB_ToolBarIcon_Cut) )
        MenuElementItem(5, "Copy", GetButtonIcon(#PB_ToolBarIcon_Copy) )
        MenuElementItem(6, "Paste", GetButtonIcon(#PB_ToolBarIcon_Paste) )
        MenuElementItem(7, "Delete", GetButtonIcon(#PB_ToolBarIcon_Delete) )
        
        MenuElementBar()
        
        MenuElementItem(100, "Preferences")
        
      EndIf
      
    
  If Reset 
    ResetNewElement() 
  EndIf
  ProcedureReturn Element
EndProcedure


Procedure NewElementEvents(Event.q, EventElement)
  Protected ElementType, Item, X,Y,Width,Height, CheckedElement = CheckedElement()
  
  ; then create element
  Select Event
    Case #_Event_Create 
      CreateNewElement(EventElement)
      
    Case #_Event_Free
      RemoveElementItem(Properties_Element, GetElementData(EventElement))
      
    Case #_Event_Close
      CloseWindowElement(EventElement)
      
    Case #_Event_MouseEnter ; Move
      If DragElementType
        SetElementCustomCursor(GetElementItemImage(IDE_Elements))
      EndIf

  EndSelect
  
  ; Elements popup menu
  Select Event
    Case #_Event_RightButtonUp ; : DisplayElement = EventElement
      DisplayPopupMenuElement(IDE_PopupMenu, EventElement)  ; now display the popup-menu
      
    Case #_Event_Menu
      Debug "EventMenuElement "+EventMenuElement()
      Select EventMenuElement()
        Case 0 : SetElementPosition(CheckedElement, #_Element_PositionFirst)
        Case 1 : SetElementPosition(CheckedElement, #_Element_PositionPrev)
        Case 2 : SetElementPosition(CheckedElement, #_Element_PositionNext)
        Case 3 : SetElementPosition(CheckedElement, #_Element_PositionLast)
          
        Case 4 : CutElement(CheckedElement) ; Cut
        Case 5 : CopyElement(CheckedElement); Copy
        Case 6 : PasteElement(CheckedElement) ; Paste
        Case 7 : FreeElement(CheckedElement)  ; Delete
          
      EndSelect 
      
  EndSelect
  
  
  Select Event ; then focus or down element change properties
    Case #_Event_Create, #_Event_Focus, #_Event_LeftButtonDown
      SetElementText(Properties_Caption, GetElementText(EventElement))
      SetElementState(Properties_Element, GetElementData(EventElement))
      SetElementState(Properties_Enable, Bool(Not IsDisableElement(EventElement)))
      SetElementText(Properties_ID, Str(EventElement)+" ("+GetElementClass(EventElement)+")")
      
      ;SetPropertiesComboBoxText(Properties_Flag, GetElementFlagClass(ElementType(EventElement)))
      
  EndSelect
  
  Select Event ; then move element change properties
    Case #_Event_Create, #_Event_Focus, #_Event_Move, #_Event_LeftButtonDown
      SetElementState(Properties_X, ElementX(EventElement))
      SetElementState(Properties_Y, ElementY(EventElement))
  EndSelect
  
  Select Event ; then size element change properties
    Case #_Event_Create, #_Event_Focus, #_Event_Size, #_Event_LeftButtonDown
      SetElementState(Properties_Width, ElementWidth(EventElement))
      SetElementState(Properties_Height, ElementHeight(EventElement))
  EndSelect
  
  If IsContainerElement(CheckedElement)
    Static StartX,StartY,LastX,LastY
      
    With *CreateElement
      Select Event ; Create drag element
        Case #_Event_Drawing
          ;         With *CreateElement
          ;           DrawingMode(#PB_2DDrawing_Outlined)
          ;           Box(\Selector\left,\Selector\top,\Selector\right,\Selector\bottom, RGB(5, 5, 5))
          ;         EndWith
          
; ;         Case #_Event_LeftButtonUp
; ;           PushListPosition(\This())
; ;           ForEach \This()
; ;             If \This()\Parent\Element = EventElement And 
; ;                \This()\FrameCoordinate\X > \Selector\left
; ;               SetAnchors(\This()\Element, #False)
; ;             EndIf
; ;           Next
; ;           PopListPosition(\This())
          
        Case #_Event_LeftButtonDown
          ; SetElementCustomCursor()
          StartX = Steps(\MouseX,Steps)-2
          StartY = Steps(\MouseY,Steps)-2
          
        Case #_Event_MouseMove 
          If \Buttons And \SideDirection = 0
            SetElementCursor(#PB_Cursor_Cross)
            LastX = Steps(\MouseX-StartX,Steps)+1
            LastY = Steps(\MouseY-StartY,Steps)+1
            
            If StartX > (StartX+LastX)
              \Selector\left = (StartX+LastX)-(\This()\InnerCoordinate\X-\This()\BorderSize)
            Else
              \Selector\left = StartX-(\This()\InnerCoordinate\X-\This()\BorderSize) 
            EndIf
            
            If StartY > (StartY+LastY)
              \Selector\top = (StartY+LastY)-(\This()\InnerCoordinate\Y-\This()\BorderSize)
            Else
              \Selector\top = StartY-(\This()\InnerCoordinate\Y-\This()\BorderSize)
            EndIf
            
            \Selector\right = Abs(LastX)
            \Selector\bottom = Abs(LastY)
            
            If BeginDrawing()
              UpdateDrawingContent()
              
              If DragElementType
                DrawingMode(#PB_2DDrawing_Outlined)
                Box(StartX,StartY,LastX,LastY, $E23A2B)
              Else
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter)
                CustomFilterCallback(@FilterCallback())
                Box(StartX,StartY,LastX,LastY, $E23A2B)
              EndIf
              
              ;Box(\Selector\left,\Selector\top,\Selector\right,\Selector\bottom, RGB(5, 5, 5))
              ;PostEventElement(#_Event_Drawing, EventElement, EventElementItem(), EventElementData())
              
              EndDrawing()
            EndIf
          EndIf
      EndSelect
    EndWith
  EndIf
  
  Select Event ; Create drag element
    Case #_Event_KeyUp
      ResetNewElement()
      
    Case #_Event_LeftButtonUp
      If DragElementType
         AddNewElement(DragElementType, EventElement, 0, Bool((ElementEventModifiersKey() & #PB_Canvas_Shift) = 0))
      EndIf
      
    Case #_Event_LeftDoubleClick : Debug "LeftDoubleClick"
      ElementType = ElementType(EventElement)
      
      Select ElementType 
        Case #_Type_Window
          ;SetElementText(IDE_Scintilla_0, Code::Code_Event_Procedure(0, ElementClass(ElementType)+"_"+Str(EventElement)+"_", "Create", ""))
        Case #_Type_Button
          Item = AddGadgetElementItem(Events_LeftClick, #PB_Any, GetElementClass(CheckedElement)+"_LeftClick_Event")
          SetElementState(EventElement, Item)
          
        Default
          ;SetElementText(IDE_Scintilla_0, Code::Code_Event_Procedure(0, ElementClass(ElementType)+"_"+Str(EventElement)+"_", EventClass(Event), ""))
      EndSelect
      
      SetElementState(IDE_pp, 1) ; IDE_Events
      SetElementState(IDE_cp, 1) ; IDE_Code
      
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure.S Parse( ReadString.S ) ;Ok
  Protected I
  Protected Count.I
  Protected String.S
  
  Protected Name.S
  Protected Type.S
  Protected X.S
  Protected Y.S
  Protected Width.S
  Protected Height.S
  Protected Caption.S
  Protected Param1.S
  Protected Param2.S
  Protected Param3.S
  Protected Flag.S
  Protected CountString.I
  ReadString.S = Trim( ReadString.S )
  
  ;
  Type.S = StringField( ReadString.S, (1), Chr('('))
  
  ;Handle.S = Trim(StringField(Type.S, 1, Chr('='))) ; 
  Type.S = Trim(StringField(Type.S, 2, Chr('=')))
  String.S = Trim(StringField( ReadString.S, (2), Chr('(')), Chr(')'))
  
  
  ; Если только одна закрывающая скобка
  X.S = StringField( String.S, 2, ",")
  Y.S = StringField( String.S, 3, ",")
  
  Width.S = StringField( String.S, 4, ",")
  If Width.S = StringField( Width.S, 1, "(")
  Else
    Width.S + ")"
  EndIf
  
  Height.S = StringField( String.S, 5, ",")
  If Height.S = StringField( Height.S, 1, "(")
  Else
    Height.S + ")"
  EndIf
  
  Caption.S = StringField( String.S, 6, ",")
  Flag.S = StringField( String.S, 7, ",")
  
  If CountString(Caption.S, Chr('"')) = 0
    Flag.S = Caption.S
    Caption.S = ""
  EndIf
  
  Static Parent =- 1
  Protected Element
  
  If Parent =- 1 
    Parent = IDE_cp 
    X.S = "#PB_Ignore"
    Y.S = "#PB_Ignore"
  EndIf
  
  Element = AddNewElement(Type(Type), Parent, 0, 0)
  
  If IsContainerElement(Element)
    Protected CaptionHeight = GetElementAttribute(Element, #_Attribute_CaptionHeight)
    If CaptionHeight
      Protected b = 2
      Protected x1 = 30
      Protected y1 = 30
    EndIf
    
    Parent = Element
  EndIf
  
  If Val(Width) >0
    ResizeElement(Element, Val(X)-3+x1,Val(Y)-3+y1,Val(Width)+7+b,Val(Height)+7+CaptionHeight+b)
  EndIf
  
  ProcedureReturn Chr(10)+ Type.S + Chr(10)+
                           ; ID.S + Chr(10)+ 
  X.S + Chr(10)+Y.S +Chr(10)+Width.S +Chr(10)+Height.S +Chr(10)+Caption.S +Chr(10)+Param1.S +Chr(10)+Param2.S +Chr(10)+Param3.S +Chr(10)+Flag.S +Chr(10) 
  
EndProcedure


Procedure$ LoadFromFile(File$)
  Protected Count, Text.S, Find.S
  
  If ReadFile(0, File$)
    While Eof(0) = 0 : Count + 1
      Text.S = ReadString(0)
      
      Find.S = IsFindFunctions(Text.S)
      Parse(Find.S)
      ;Debug Str(Count) +" "+ 
    Wend
    
    CloseFile(0)
  Else
    MessageRequester("Information","Couldn't open the file!")
  EndIf
EndProcedure 

Procedure GeneratePBForm(Panel)
  Protected i, ReadText.S, Find.S, Text.S = GetElementText(IDE_Scintilla_0)
;   Text.S = "111"+#LF$+ 
;            "222"+#LF$+
;            "333"+#LF$+
;            "444"+#LF$+
;            "555"
  
  Protected f=0,ff
  For i=0 To CountString(Text, #LF$)-1
    ;ff+f
    f=FindString(Text, #LF$, f+Len(#LF$))
    ReadText.S = Mid(Text,ff+Len(#LF$),f)
    ff=Len(Left(Text,f))
    Debug  i
     Debug ReadText
;     Find.S = IsFindFunctions(ReadText.S)
;     Parse(Find.S)
  Next
  
EndProcedure
; GeneratePBForm(0)

;-
Procedure IDE_Properties_Events(Event.q, EventElement)
  Protected CheckedElement = CheckedElement()
  ;   Protected Event.q = ElementEvent()
  ;   Protected EventElement = EventElement()
  
  Select Event
    Case #_Event_LeftClick
      Select EventElement 
        Case IDE_Elements : DragElementType = Type(GetElementItemText(IDE_Elements)) 
          *CreateElement\DragElementType = DragElementType
          SetElementCustomCursor(GetElementItemImage(IDE_Elements))
      
        Case Properties_Puch
          CFE_Helper_Image(IDE_cp)
          
      EndSelect
      
    Case #_Event_LeftDoubleClick ; "При двойном клике на событие будем переходить к коду"
      If IsElement(CheckedElement)
        Select EventElement 
          Case Events_LeftClick, Events_RightClick,Events_LeftDown,Events_LeftUp
            SetElementState(IDE_cp, 1)
            
            Select EventElement 
              Case Events_LeftClick
                Protected Item = AddGadgetElementItem(EventElement, #PB_Any, GetElementClass(CheckedElement)+"_LeftClick_Event")
                SetElementState(EventElement, Item)
            EndSelect
            
            Debug GetElementClass(CheckedElement)
        EndSelect
      EndIf
      
    Case #_Event_Change ;: Debug "Change IDE_pp"
      Select EventElement 
        Case IDE_pp
          Select GetElementState(IDE_pp)
            Case 0 : SetActiveElement(IDE_Properties)
            Case 1 : SetActiveElement(IDE_Events)
            Case 2 : SetActiveElement(IDE_Elements)
          EndSelect
          
        Case Properties_Flag
          SetElementFlag(CheckedElement, Flag(GetElementText(Properties_Flag)))
          Debug Flag(GetElementText(Properties_Flag))
          
        Case Properties_Element
          ;SetElementFlag(CheckedElement, Flag(GetElementText(Properties_Flag)))
          ;Debug GetElementState(Properties_Element)
          *CreateElement\CheckedElement = GetElementItemData(Properties_Element, GetElementState(Properties_Element))
          CheckedElement = CheckedElement()
          SetActiveElement(CheckedElement)
          SetForegroundWindowElement(CheckedElement)
          SetAnchors(CheckedElement)
          
        Case Properties_Caption
          SetElementText(CheckedElement, GetElementText(Properties_Caption))
          
        Case Properties_Enable
          DisableElement(CheckedElement, Bool(GetElementState(Properties_Enable)=0))
          
        Case Properties_X,Properties_Y,Properties_Width,Properties_Height
          ResizeElement(CheckedElement, 
                        GetElementState(Properties_X)-3,
                        GetElementState(Properties_Y)-3,
                        GetElementState(Properties_Width)+6+GetElementAttribute(CheckedElement, #_Attribute_BorderSize)*2, 
                        GetElementState(Properties_Height)+6+GetElementAttribute(CheckedElement, #_Attribute_BorderSize)*2+GetElementAttribute(CheckedElement, #_Attribute_CaptionHeight))
          
      EndSelect
      
    Case #_Event_MouseMove
      
      
      Select EventElement 
        Case IDE_pp
          Static iState, EnterItem =- 1 : iState = GetElementState(EventElement)
          
          If EnterItem<>EventElementItem() : EnterItem=EventElementItem()
            If EventElementItem() =- 1
              SetElementState(EventElement, iState)
            Else
              SetElementState(EventElement, EventElementItem())
            EndIf
          EndIf
          
        Case IDE_Elements
          SetElementText(IDE_iElements, Help(GetElementItemText(IDE_Elements)))
          
      EndSelect
      
    Case #_Event_MouseLeave
      Select EventElement 
        Case IDE_Elements
          SetElementText(IDE_iElements, Help(GetElementItemText(IDE_Elements, GetElementState(IDE_Elements))))
          
      EndSelect
      
    Default
      ;Debug "IDE_Properties_Events() "+EventElement+" "+EventClass(Event)+" "+Str(GetElementParent(EventElement))
      
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure IDE_Menu_Events(Event.q, EventElement)
  ;     Protected Event.q = ElementEvent()
  ;     Protected EventElement = EventElement()
  Static RunProgram
  Protected ElementCreate, CheckType
  Protected CheckedElement = CheckedElement()
  Protected Type = ElementType(CheckedElement)
  
  Select Event
    Case #_Event_Menu
      Select EventElementItem() 
        Case 1001
          If GetElementText(IDE_Scintilla_0)
            SetClipboardText(GetElementText(IDE_Scintilla_0))
            SetElementText(IDE_Scintilla_0,"")
          EndIf
          
        Case 1002
          SetClipboardText(GetElementText(IDE_Scintilla_0))
          
        Case 1003
          SetElementText(IDE_Scintilla_0, GetClipboardText())
          
        Case 1004
          SetElementText(IDE_Scintilla_0,"")
          
        
        Case #IDE_MenuItem_Form_Code
        Case #IDE_MenuItem_Save
        Case #IDE_MenuItem_Open
          Protected StandardFile$ = "C:\Users\mestnyi\Google Диск\SyncFolder()\Module()\"   ; set initial file+path to display
                                                                                            ; With next string we will set the search patterns ("|" as separator) for file displaying:
                                                                                            ;  1st: "Text (*.txt)" as name, ".txt" and ".bat" as allowed extension
                                                                                            ;  2nd: "PureBasic (*.pb)" as name, ".pb" as allowed extension
                                                                                            ;  3rd: "All files (*.*) as name, "*.*" as allowed extension, valid for all files
          Protected Pattern$ = "PureBasic (*.pb)|*.pb;*.pbi;*.pbf|All files (*.*)|*.*"
          Protected Pattern = 0    ; use the first of the three possible patterns as standard
          Protected File$ = OpenFileRequester("Please choose file to load", StandardFile$, Pattern$, Pattern)
          LoadFromFile(File$)
          
        Case #IDE_MenuItem_New    
          AddNewElement(#_Type_Window, IDE_cp, 0, #True)
          
        Case #IDE_MenuItem_Delete : DeleteNewElement(CheckedElement)
          
        Case #IDE_MenuItem_First  : SetElementPosition(CheckedElement, #_Element_PositionFirst)
        Case #IDE_MenuItem_Prev   : SetElementPosition(CheckedElement, #_Element_PositionPrev)
        Case #IDE_MenuItem_Next   : SetElementPosition(CheckedElement, #_Element_PositionNext)
        Case #IDE_MenuItem_Last   : SetElementPosition(CheckedElement, #_Element_PositionLast)
          
        Case #IDE_MenuItem_Quit   : End
          
      EndSelect
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure IDE_Easy_Events(Event.q, EventElement)
  ;     Protected Event.q = ElementEvent()
  ;     Protected EventElement = EventElement()
  Static RunProgram
  Protected ElementCreate, CheckType
  Protected CheckedElement = CheckedElement()
  Protected Type = ElementType(CheckedElement)
  
  IDE_Menu_Events(Event, EventElement)
  
  Select Event
    Case #_Event_RightClick
      Select EventElement
        Case IDE_Scintilla_0
           DisplayPopupMenuElement(IDE_EditPopupMenu, EventElement) 
      EndSelect
      
      ; IDE_Panel
    Case #_Event_Change 
      Select EventElement
        Case IDE_cp
          If EventElementItem() = 0
            DisableElement(IDE_ToolBar_0, 0)
            ;DisableToolBarElementButton(IDE_ToolBar_0, #PB_All, 0)
          Else
            DisableElement(IDE_ToolBar_0, 1)
            ;DisableToolBarElementButton(IDE_ToolBar_0, #PB_All, 1)
          EndIf
          
          Select GetElementItemText(EventElement()) ; EventElementItem() 
            Case "Form" : GeneratePBForm(EventElement())
              
            Case "Code" : GeneratePBCode(EventElement())
              
            Case "V_Code"
              ;AddGadgetElementItem(IDE_Canvas_0,-1,"Button",png, #_Flag_Border|#_Flag_Image_Left|#_Flag_Text_Center)
              
          EndSelect
          
      EndSelect
      
      ;       ; IDE_Panel
      ;     Case #_Event_LeftButtonUp
      ;       If DragElementType 
      ;         Select EventElement
      ;           Case IDE_cp
      ;             Select GetElementItemText(EventElement());EventElementItem() 
      ;               Case "Form"
      ;                 ElementCreate = AddNewElement(DragElementType, IDE_cp, 0, Bool((ElementEventModifiersKey() & #PB_Canvas_Shift) = 0))
      ;             EndSelect
      ;             
      ;           Case IDE_Canvas_0
      ;             ;ElementCreate = AddNewElement(DragElementType, CheckedElement, 0)
      ;             ;DragElementType = 0
      ;             
      ;         EndSelect
      ;       EndIf
      
    Default
      
      ; Debug "IDE_Easy_Events() "+EventElement+" "+EventClass(Event)+" "+Str(GetElementParent(EventElement))
      
  EndSelect
  
  
  ProcedureReturn #True
EndProcedure

Procedure GetIcon(Icon$, Remove$="") 
  Protected ButtonID =- 1
  UsePNGImageDecoder()
  
  Protected Directory$ = GetCurrentDirectory()+"images/" ; "";
  Protected ZipFile$ = Directory$ + "images.zip"
  
  If FileSize(ZipFile$) < 1
    CompilerIf #PB_Compiler_OS = #PB_OS_Windows
      ZipFile$ = #PB_Compiler_Home+"images\images.zip"
    CompilerElse
      ZipFile$ = #PB_Compiler_Home+"images/images.zip"
    CompilerEndIf
    If FileSize(ZipFile$) < 1
      MessageRequester("Designer Error", "images\images.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
      End
    EndIf
  EndIf
  
  If FileSize(ZipFile$) > 0
    UsePNGImageDecoder()
    
    CompilerIf #PB_Compiler_Version > 522
      UseZipPacker()
    CompilerEndIf
    
    Protected PackEntryName.s, ImageSize, *Image, ZipFile;, Image
    ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
    
    If ZipFile  
      If ExaminePack(ZipFile)
        While NextPackEntry(ZipFile)
          
          PackEntryName.S = PackEntryName(ZipFile)
          
          PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
          
          Select PackEntryType(ZipFile)
            Case #PB_Packer_File
              
              Protected Left.S = UCase(Left(PackEntryName.S,1))
              Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
              PackEntryName.S = " "+Left.S+Right.S
              
              If FindString(LCase(PackEntryName.S), Icon$) And FindString(LCase(PackEntryName.S), Remove$) = 0
                ImageSize = PackEntrySize(ZipFile)
                *Image = AllocateMemory(ImageSize)
                UncompressPackMemory(ZipFile, *Image, ImageSize)
                ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                FreeMemory(*Image)
                Break
              EndIf
              
              
          EndSelect
          
        Wend  
      EndIf
      
      ClosePack(ZipFile)
    EndIf
  EndIf
  
  ProcedureReturn ButtonID 
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Define IDE_Width = 900
  Define IDE_Height = 600
  
  Procedure Properties_Size_Events(Event.q, EventElement)
    Protected State 
    Protected iWidth = ElementWidth(EventElement)
    Protected iHeight = ElementHeight(EventElement)
    Protected Element = GetElementItemData(EventElement, GetElementState(EventElement))
    
    If Element
      Select Event 
        Case #_Event_Change, #_Event_Size
          ResizeElement(Element, #PB_Ignore, #PB_Ignore, iWidth, iHeight)
          
          ;           State = GetElementState(Element)
          ;           ; Debug "GetElementState "+State
          ;           If State > 0
          ;             SetElementState(Element, State+3)
          ;           ElseIf State = 0
          ;             SetElementState(Element, iHeight/2)
          ;           EndIf
      EndSelect
    EndIf
    
    ProcedureReturn #True
  EndProcedure
  
  IDE = OpenWindowElement(#PB_Any, 30,30, IDE_Width,IDE_Height, "Designer")
  
  ;{ - (menu & toolbar)
  IDE_Menu_0 = CreateMenuElement(#PB_Any,IDE)
  MenuElementTitle("File")
  MenuElementItem(#IDE_MenuItem_Open,"Open"   +Chr(9)+"  Ctrl+O", GetButtonIcon(#PB_ToolBarIcon_Open))
  MenuElementItem(#IDE_MenuItem_Save,"Save"   +Chr(9)+"  Ctrl+S", GetButtonIcon(#PB_ToolBarIcon_Save))
  MenuElementBar()
  MenuElementItem(#IDE_MenuItem_Quit,"Quit")
  
  MenuElementTitle("Edit")
  MenuElementTitle("Project")
  MenuElementTitle("Form")
  MenuElementItem(#IDE_MenuItem_New,"New", GetIcon("add_form"))
  
  ;BindMenuElementEvent(ToolBarElement(), 1, @ToolBarButtonEvent())
  
  
  ;BindMenuElementEvent(ToolBarElement(), #IDE_MenuItem_New, @IDE_Menu_Events())
  IDE_EditPopupMenu = CreatePopupMenuElement()
  
  MenuElementItem(1001, "Cut", GetButtonIcon(#PB_ToolBarIcon_Cut) )
  MenuElementItem(1002, "Copy", GetButtonIcon(#PB_ToolBarIcon_Copy) )
  MenuElementItem(1003, "Paste", GetButtonIcon(#PB_ToolBarIcon_Paste) )
  MenuElementItem(1004, "Delete", GetButtonIcon(#PB_ToolBarIcon_Delete) )
  ;}
  
  ;{ - (form & code)
  IDE_cp = PanelElement(#PB_Any,0,0,0,0, #_Flag_Transparent)  
  IDE_Toolbar_0 = CreateToolbarElement(#PB_Any,IDE_cp)
  ;ToolBarElementButton( 0, -1, 0, #PB_ToolBarIcon_Add,"", "Элементы для добавления")
  
  ToolBarElementButton( #IDE_MenuItem_New, GetIcon("add_form"), 0, #PB_ToolBarIcon_Add,"", "Создать новую форму")
  ToolBarElementButton( #IDE_MenuItem_Delete, -1, 0, #PB_ToolBarIcon_Delete,"", "Удалить выбраную форму")
  ToolBarElementSeparator()
  ToolBarElementButton( #IDE_MenuItem_First, GetIcon("move_first"), 0, -1,"", "Переместить на задний план")
  ToolBarElementButton( #IDE_MenuItem_Next, GetIcon("move_next"), 0, -1,"", "Переместить на один вперед")
  ToolBarElementButton( #IDE_MenuItem_Prev, GetIcon("move_prev"), 0, -1,"", "Переместить на один назад")
  ToolBarElementButton( #IDE_MenuItem_Last, GetIcon("move_last"), 0, -1,"", "Переместить на передний план")
  ToolBarElementSeparator()
  
  ;
  Define ei=AddPanelElementItem(IDE_cp, #PB_Any, "Form", GetIcon("elements", "_"))
  ;   Define e311 = ScrollAreaElement(#PB_Any,0,0,0,0,200,100,1, #_Flag_AlignFull)
  ;Define f=ButtonElement(#PB_Any, 30,30, 100,50, "Window_0", #_Flag_AnchorsGadget) 
  ;OpenWindowElement(#PB_Any, 30,30, 200,100, "Window_0",0,IDE_cp) : CloseElementList()
  
  ;   CloseElementList()
  ;   SetElementItemData(IDE_cp, ei, e311)
  SetElementItemData(IDE_cp, ei, #PB_Default)
  
  Define ei=AddPanelElementItem(IDE_cp, #PB_Any, "Code", GetIcon("page_white_code")) 
  IDE_Scintilla_0 = EditorElement(#PB_Any,0,0,0,0,"Text")   
  SetElementItemData(IDE_cp, ei, IDE_Scintilla_0)
  
  Define ei=AddGadgetElementItem(IDE_cp, -1, "V_Code")
  IDE_Canvas_0 = CreateElement(#_Type_Canvas, #PB_Any,0,0,0,0,"Canvas",-1,-1,-1,#_Flag_BorderLess)   
  SetElementBackGroundImage(IDE_Canvas_0, img_point)
  SetElementItemData(IDE_cp, ei, IDE_Canvas_0)
  
  BindGadgetElementEvent(IDE_cp, @Properties_Size_Events(), #_Event_Size|#_Event_Change);|#_Event_Create)
  CloseElementList()
  
  With *CreateElement
    PushListPosition(\This()) 
    ChangeCurrentElement(\This(), ElementID( IDE_cp ))
    ;\This()\ToolBarHeight = 0
    
    ChangeCurrentElement(\This()\Items(), ItemID( ListSize(\This()\Items())-1 ))
    ;SetElementFlag(IDE_Toolbar_0, #_Flag_Border)
    ResizeElement(IDE_Toolbar_0, \This()\Items()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\Width+5, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    ;\This()\Items()\Y = -60
    
    PopListPosition(\This())
    ;ResizeElement(IDE_cp, #PB_Ignore, 0, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  EndWith
  
  
  IDE_List_0 = EditorElement(#PB_Any, 0,0,0,0, "List_0")
  IDE_Splitter_0 = SplitterElement(#PB_Any, 0,0,0,0, IDE_cp,IDE_List_0, #_Flag_Separator_Circle)
  ;}
  
  ;{ - (elements & properties)
  IDE_pp = PanelElement(#PB_Any,0,0,0,0, #_Flag_BorderLess|#_Flag_Transparent) 
  ;
  Define ei=AddPanelElementItem(IDE_pp, #PB_Any, "Properties", GetButtonIcon(#PB_ToolBarIcon_New))
  IDE_Properties = PropertiesElement(#PB_Any,0,0,0,0)            
  Properties_Element = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Elements")
  Properties_ID = AddPropertiesElementItem(IDE_Properties, #PB_Any, "String ID")
  ;AddPropertiesElementItem(IDE_Properties, #PB_Any, "")
  Properties_Caption = AddPropertiesElementItem(IDE_Properties, #PB_Any, "String Caption")
  Properties_ToolTip = AddPropertiesElementItem(IDE_Properties, #PB_Any, "String ToolTip")
  Properties_X = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin X 0|100")
  Properties_Y = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin Y 0|200")
  Properties_Width = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin Width 0|100")
  Properties_Height = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin Height 0|200")
  
  ;AddPropertiesElementItem(IDE_Properties, #PB_Any, "-Поведение-")
  Properties_Puch = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Button Puch Указать_путь_к_изображению")
  
  Properties_Enable = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Disable True|False")
  Properties_Flag = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Flag #_Event_Close|#_Event_Size|#_Event_Move")
  
  IDE_iProperties = TextElement(#PB_Any,0,0,0,0,"Text") 
  
  IDE_sProperties = SplitterElement(#PB_Any, 0,0,0,0, IDE_Properties,IDE_iProperties, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  SetElementItemData(IDE_pp, ei, IDE_sProperties)
  
  ;
  Define ei=AddPanelElementItem(IDE_pp, #PB_Any, "Events", GetIcon("lightning"))
  IDE_Events = PropertiesElement(#PB_Any,0,0,0,0)            
  Events_LeftClick = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox LeftClick", #PB_Default, #PB_ComboBox_Editable)
  Events_RightClick = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox RightClick", #PB_Default, #PB_ComboBox_Editable)
  Events_LeftDown = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox LeftDown", #PB_Default, #PB_ComboBox_Editable)
  Events_LeftUp = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox LeftUp", #PB_Default, #PB_ComboBox_Editable)
  
  IDE_iEvents = ButtonElement(#PB_Any, 0,0,0,0, "72ButtonElement")
  IDE_sEvents = SplitterElement(#PB_Any, 0,0,0,0, IDE_Events,IDE_iEvents, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  
  SetElementItemData(IDE_pp, ei, IDE_sEvents)
  
  ;
  Define ei=AddPanelElementItem(IDE_pp, #PB_Any, "Elements", GetIcon("elements"))
  IDE_Elements = ListViewElement(#PB_Any,0,0,0,0) 
  LoadGadgetImage(IDE_Elements, GetCurrentDirectory()+"Themes/")
  SetElementState(IDE_Elements,0)
  ; ElementToolTip(IDE_Elements)
  
  IDE_iElements = TextElement(#PB_Any,0,0,0,0,"Text", #_Flag_Flat)   
  
  IDE_sElements = SplitterElement(#PB_Any, 0,0,0,0, IDE_Elements,IDE_iElements, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  SetElementItemData(IDE_pp, ei, IDE_sElements)
  
  BindGadgetElementEvent(IDE_pp, @Properties_Size_Events(), #_Event_Size|#_Event_Change);|#_Event_Create)
  CloseElementList()
  
  IDE_Splitter_4 = SplitterElement(#PB_Any, 0,0,IDE_Width,IDE_Height, IDE_Splitter_0,IDE_pp, #_Flag_Vertical|#_Flag_Separator_Circle)
  
  SetElementAttribute(IDE_sElements, #PB_Splitter_FirstMinimumSize, 200)
  SetElementAttribute(IDE_sElements, #PB_Splitter_SecondMinimumSize, 20)
  
  SetElementAttribute(IDE_sProperties, #PB_Splitter_FirstMinimumSize, 200)
  SetElementAttribute(IDE_sProperties, #PB_Splitter_SecondMinimumSize, 20)
  
  SetElementAttribute(IDE_sEvents, #PB_Splitter_FirstMinimumSize, 200)
  SetElementAttribute(IDE_sEvents, #PB_Splitter_SecondMinimumSize, 20)
  
  SetElementState(IDE_Splitter_0,ElementHeight(IDE_Splitter_4)-60)
  SetElementState(IDE_sElements,ElementHeight(GetElementParent(IDE_sElements))-60)
  SetElementState(IDE_sProperties,ElementHeight(GetElementParent(IDE_sProperties))-60)
  SetElementState(IDE_sEvents,ElementHeight(GetElementParent(IDE_sEvents))-60)
  SetElementState(IDE_Splitter_4,ElementWidth(IDE_Splitter_4)-300)
  ;}
  
  If CreateStatusBarElement(#PB_Any, IDE)
    AddStatusBarElementField(190)
    AddStatusBarElementField(#PB_Ignore) ; automatically resize this field
    
    StatusBarElementText(StatusBarElement(), 0, "Area normal")
    StatusBarElementText(StatusBarElement(), 1, "StatusBar")
  EndIf
  
  
   AddNewElement(#_Type_Window, IDE_cp, 0, #True)
      
;     Define File$ = "CFE_Read_Test(variab).pb"
;     If File$
;       Define Load$ = LoadFromFile(File$)
; ;       ClearGadgetItems(Editor_0)
; ;       AddGadgetItem(Editor_0,-1,Load$)
;     EndIf 
  
  BindEventElement(@IDE_Properties_Events(), IDE, #PB_All) 
  BindEventElement(@IDE_Easy_Events(), IDE, #PB_All)
  
  WaitWindowEventClose(IDE)
  End
  
CompilerEndIf
