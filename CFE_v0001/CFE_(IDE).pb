;-
XIncludeFile "CFE.pbi"
Declare CFE_Helper_Image(Parent =- 1, *Image.Integer=0, *Puth.String=0, WindowID = #False, Flag.q = #_Flag_ScreenCentered)
XIncludeFile "CFE_Helper_Image.pbi"

Structure Copyies
  Element.i
  Parent$
  Window$
  
  FontID$
  IageID$
  
  Type$
  Class$
  X$
  Y$
  Width$
  Height$
  Caption$
  Param1$
  Param2$
  Param3$
  Flag$
EndStructure

Global NewMap Copyies.Copyies()


Procedure UpdateElementFlag(Panel, pElement)
  Protected i, j, Buffer$, Parent, Element
  ; Каковы возможные флаги для выбранного гаджета?
  ;Buffer$=MGadget(Gadgets(GetGadgetData(IDGadget))\IdModel)\Flag$
  ClearGadgetItems(pElement)
  For i=1 To CountString(Buffer$,",")+1
    If Trim(StringField(Buffer$,i,","))<>""
      AddGadgetItem(pElement, -1, StringField(Buffer$,i,","))
    EndIf
  Next
  
  While EnumerateElement(@Parent, Panel, 0)
    Buffer$ +"Global "+ GetElementEvents(Parent)+"=-1"
    
    While EnumerateElement(@Element, ElementID(Parent))
      If Buffer$ : Buffer$+", " : EndIf : Buffer$ +GetElementEvents(Element)+"=-1"
    Wend
    
    Buffer$ +#CRLF$
  Wend
  
  ; Какие флаги будут использоваться для выбранного гаджета?
  ;Buffer$=Gadgets(GetGadgetData(IDGadget))\Flag$
  For i=1 To CountString(Buffer$,"|")+1
    For j=0 To CountGadgetItems(pElement)-1
      If GetGadgetItemText(pElement,j)=StringField(Buffer$,i,"|")
        SetGadgetItemState(pElement, j, #PB_ListIcon_Checked)
      EndIf
    Next
  Next
EndProcedure

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
;   Directory$ = GetCurrentDirectory()+"images/" ; "";
;   Protected ZipFile$ = Directory$ + "images.zip"
  
  
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
; Рисунок фона окна
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


;-
;- PROGRAMMS
Define i

;- ENUMERATIONS
#Title$ = "IDE"

Enumeration FormMenuItem 1
  #IDE_MenuItem_New
  #IDE_MenuItem_Save
  #IDE_MenuItem_Open
  #IDE_MenuItem_Form_Code
  
  #IDE_MenuItem_Undo
  #IDE_MenuItem_Redo
  
  #IDE_MenuItem_Cut
  #IDE_MenuItem_Copy
  #IDE_MenuItem_Paste
  #IDE_MenuItem_Delete
  
  #IDE_MenuItem_First
  #IDE_MenuItem_Prev
  #IDE_MenuItem_Next
  #IDE_MenuItem_Last
  
  #IDE_MenuItem_Preferences
  #IDE_MenuItem_Quit
EndEnumeration


;- GLOBALS
Global IDE_Scintilla_Gadget=-1
Global DragElementType=0, IDE_PopupMenu=-1, IDE_EditPopupMenu=-1

Global IDE=-1, IDE_Menu_0=-1, IDE_Toolbar_0=-1, IDE_cp=-1, IDE_pp=-1
Global IDE_Splitter_0=-1, IDE_Splitter_4=-1, IDE_List_0=-1, IDE_Scintilla_0=-1, IDE_Canvas_0

Global IDE_sProperties=-1, IDE_Properties=-1, IDE_iProperties=-1
Global IDE_sElements=-1, IDE_Elements=-1, IDE_iElements=-1
Global IDE_sEvents=-1, IDE_Events=-1, IDE_iEvents=-1

Global Properties_Element=-1, Properties_ID=-1,
       Properties_AlignText=-1, Properties_AlignImage=-1, Properties_AlignElement=-1,
       Properties_Caption=-1, Properties_ToolTip=-1, Properties_IsEnum=-1,
       Properties_X=-1, Properties_Y=-1, Properties_Width=-1, Properties_Height=-1,
       Properties_Hide=-1, Properties_Enable=-1, Properties_Sticky=-1,
       Properties_Flag=-1, Properties_Image=-1, Properties_ImageBg=-1,
       Properties_Data=-1, Properties_State=-1,
       Properties_BackColor=-1, Properties_FontColor=-1, Properties_Font=-1

Global Events_Bind=-1, Events_LeftClick=-1, Events_RightClick=-1, Events_LeftDown=-1, Events_LeftUp=-1

Global img_point = Mosaic(Steps, 0,0,800,600)



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

Macro NextChild(Element);, *ID.Integer)
  *CreateElement\This() : If (IsChildElement(*CreateElement\This()\Element, Element) = 0 Or *CreateElement\This()\Element = Element) : Continue : EndIf
EndMacro

Procedure GeneratePBCode(Panel)
  Protected Type
  Protected Count
  Protected Image
  Protected Parent
  Protected Element
  Protected ParentClass$, Class$,Code$, FormWindow$, FormGadget$, Gadgets$, Windows$, Events$, Functions$
  Static JPEGPlugin$, JPEG2000Plugin$, PNGPlugin$, TGAPlugin$, TIFFPlugin$
  
  With *CreateElement
    ; is element
    If IsElementChildrens(Panel, 0)
      Code$ + "EnableExplicit" +#CRLF$+#CRLF$
      
      While EnumerateElement(@Element, ElementID(Panel), 0)
        Image = GetElementImage(Element)
        
        ;UseIMAGEDecoder
        If IsImage(Image)
          Select ImageFormat(Image)
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
          
          Code$ +"LoadImage("+Image+", "+#DQUOTE$+\ImagePuch(Str(Image))+#DQUOTE$+")"+#CRLF$
        EndIf
        
      Wend
      
      Code$ + "Define Event" + #CRLF$+#CRLF$
      
      ; global var enumeration
      While EnumerateElement(@Parent, Panel, 0)
        Class$ = GetElementClass(Parent)
        If Trim(Class$, "#") = Class$
          Code$ +"Global "+ Class$+"=-1"+#CRLF$
        Else
          FormWindow$ +Class$+ #CRLF$
        EndIf
      Wend
      
      If FormWindow$
        Code$ +"Enumeration FormWindow"+ #CRLF$
        Code$ +"  "+ FormWindow$
        Code$ +"EndEnumeration"+ #CRLF$
      EndIf
      
      Code$ +#CRLF$
      
      While EnumerateElement(@Parent, Panel, 0)
        While EnumerateElement(@Element, ElementID(Parent))
          Class$ = GetElementClass(Element)
          If Trim(Class$, "#") = Class$
            Code$ +"Global "+ GetElementClass(Element)+"=-1"+#CRLF$
          Else
            FormGadget$ +Class$+ #CRLF$
          EndIf
        Wend
      Wend
      
      If FormGadget$
        Code$ +"Enumeration FormGadget"+ #CRLF$
        Code$ +"  "+ FormGadget$
        Code$ +"EndEnumeration"+ #CRLF$
      EndIf
      
      Code$ +#CRLF$
      
      While EnumerateElement(@Parent, Panel, 0)
        While EnumerateElement(@Element, ElementID(Parent))
          Class$ = Trim(GetElementClass(Element), "#")
          Events$ = GetElementEvents(Element)
          If Events$
            Code$ + Code::Code_Event_Procedure(0, Class$+"_", "#PB_Event_Gadget", "") 
          EndIf
          ;           If Trim(Class$, "#") = Class$
          ;             Code$ +"Global "+ GetElementClass(Element)+"=-1"+#CRLF$
          ;           Else
          ;             FormGadget$ +Class$+ #CRLF$
          ;           EndIf
        Wend
      Wend
      
      While EnumerateElement(@Element, Panel, 0)
        Events$ = GetElementEvents(Element)
          If Events$
          Code$ + Code::Code_Event_Procedure(0, GetElementClass(Element)+"_", Events$, "") 
        EndIf
      Wend
      
      
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Parent\Item = 0
          Element = \This()\Element
          ParentClass$ = Trim(\This()\Class$, "#")
          
          Code$ +"Procedure Open_"+ ParentClass$+"()"+#CRLF$
          PushListPosition(\This())
          ForEach \This()
            If IsChildElement(\This()\Element, Element)
              Class$ = Trim(\This()\Class$, "#")
              Code$ +"  "
              
              ; Type 
              If \This()\Class$ = Class$
                Code$ + Class$ + " = "
                
                Select \This()\Type 
                  Case #_Type_Window
                    Code$ +"Open"+ElementClass(\This()\Type)+"(#PB_Any, "
                  Default
                    Code$ + ElementClass(\This()\Type)+"Gadget(#PB_Any, "
                EndSelect
              Else
                Select \This()\Type 
                  Case #_Type_Window
                    Code$ +"Open"+ElementClass(\This()\Type)+"("+\This()\Class$+", "
                  Default
                    Code$ + ElementClass(\This()\Type)+"Gadget("+\This()\Class$+", "
                EndSelect
              EndIf
              
              ; Coordinate
              Select \This()\Type 
                Case #_Type_Window
                  Code$ + Str(\This()\FrameCoordinate\X)+", "+
                          Str(\This()\FrameCoordinate\Y)+", "+
                          Str(\This()\FrameCoordinate\Width-(\This()\bSize)*2)+", "+
                          Str(\This()\FrameCoordinate\Height-(\This()\bSize)*2-\This()\CaptionHeight)
                  
                Default
                  Code$ + Str(\This()\ContainerCoordinate\X+(\This()\bSize-\This()\BorderSize))+", "+
                          Str(\This()\ContainerCoordinate\Y+(\This()\bSize-\This()\BorderSize))+", "+
                          Str(\This()\FrameCoordinate\Width-(\This()\bSize-\This()\BorderSize)*2)+", "+
                          Str(\This()\FrameCoordinate\Height-(\This()\bSize-\This()\BorderSize)*2)
              EndSelect
              
              ; Caption
              Select \This()\Type
                Case #_Type_Window, #_Type_Button, #_Type_String, #_Type_Text, #_Type_CheckBox, #_Type_Option, #_Type_Frame, 
                     #_Type_HyperLink, #_Type_ListIcon, #_Type_Web, #_Type_Date, #_Type_ExplorerList, #_Type_ExplorerTree, #_Type_ExplorerCombo
                  
                  Code$ +", "+Chr('"')+ GetElementText(\This()\Element) +Chr('"')
              EndSelect
              
              ; Param1
              Select \This()\Type
                ;Case #_Type_MDI : Code$ +", "+ \This()\SubMenu
                Case #_Type_Spin : Code$ +", "+ \This()\Spin\Min
                Case #_Type_Splitter : Code$ +", "+ \This()\Splitter\FirstElement
                Case #_Type_Image, #_Type_ButtonImage 
                  If IsImage(\This()\Img\Image)
                    Code$ +", ImageID("+ \This()\Img\Image+")"
                  Else
                    Code$ +", 0"
                  EndIf
                Case #_Type_ListIcon : Code$ +", "+ \This()\FirstColumWidth
                Case #_Type_HyperLink : Code$ +", "+ \This()\BackColor
                Case #_Type_ProgressBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\Min 
                Case #_Type_TrackBar : Code$ +", "+ \This()\Scroll\Min
                Case #_Type_Date : Code$ +", "+ \This()\Date
                Case #_Type_Calendar : Code$ +", "+ \This()\Date
                Case #_Type_Scintilla : Code$ +", "+ \This()\CallBack
                Case #_Type_Shortcut : Code$ +", "+ \This()\Shortcut
              EndSelect
              
              ; Param2
              Select \This()\Type
                ;Case #_Type_MDI : Code$ +", "+ \This()\FirstMenuItem
                Case #_Type_Spin : Code$ +", "+ \This()\Spin\Max
                Case #_Type_TrackBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_ProgressBar : Code$ +", "+ \This()\Scroll\Max
                Case #_Type_Splitter : Code$ +", "+ \This()\Splitter\SecondElement
              EndSelect
              
              ; Param3
              Select \This()\Type
                Case #_Type_ScrollBar : Code$ +", "+ \This()\Scroll\PageLength
                Case #_Type_ScrollArea : Code$ +", "+ \This()\Scroll\ScrollStep
              EndSelect
              
              ; Flags
              Select \This()\Type
                Case #_Type_Panel, #_Type_Web, #_Type_IPAddress, #_Type_Option, #_Type_Scintilla, #_Type_Shortcut
                Default
                  If Trim(\This()\Flags$, "|")
                    Code$ +", "+ Trim(\This()\Flags$, "|")
                  EndIf
              EndSelect
              
              Code$ +")"+ #CRLF$
              
            EndIf
          Next
          PopListPosition(\This())
          
          If \StickyWindow = Element
            Code$ +"  StickyWindow("+ParentClass$+", #True)"+#CRLF$
          EndIf
          
          Code$ + #CRLF$
          
          PushListPosition(\This())
          ForEach \This()
            If IsChildElement(\This()\Element, Element)
              Class$ = Trim(\This()\Class$, "#")
              
              If \This()\HideState 
                Code$ +"  HideGadget("+Class$+", #True)"+#CRLF$
              EndIf
              If \This()\DisableState
                Code$ +"  DisableGadget("+Class$+", #True)"+#CRLF$
              EndIf
              If \This()\ToolTip\String$
                Code$ +"  GadgetToolTip("+Class$+", "+#DQUOTE$+\This()\ToolTip\String$+#DQUOTE$+")"+#CRLF$
              EndIf
              If \This()\FontColorState
                Code$ +"  SetGadgetAttribute("+Class$+", #PB_Gadget_FrontColor, $"+Hex(\This()\FontColor)+")"+#CRLF$
              EndIf
              If \This()\BackColorState
                Code$ +"  SetGadgetAttribute("+Class$+", #PB_Gadget_BackColor, $"+Hex(\This()\BackColor)+")"+#CRLF$
              EndIf
              
;               Events$ = \This()\Events$
;               Gadgets$ + ElementClass(\This()\Type)
;               
;               If Events$
;                 Code$ +Code::Code_BindGadgetEvent(3, Events$, 0);Gadgets$)
;               EndIf
            EndIf
          Next
          PopListPosition(\This())
          
          Select \This()\Type 
            Case #_Type_Window
              If \This()\Events$
                Code$ +Code::Code_BindEvent(3, "#PB_Event_"+\This()\Events$, ParentClass$+"_")
              EndIf
            Default
          EndSelect
          Code$ +"EndProcedure"+#CRLF$+#CRLF$
          
        EndIf
      Next
      PopListPosition(\This())
      
      PushListPosition(\This())
      ForEach \This()
        If \This()\Parent\Element = Panel And \This()\Parent\Item = 0
          Element = \This()\Element
          
          Code$ +"CompilerIf #PB_Compiler_IsMainFile"+#CRLF$
          Code$ +"  Open_"+ Trim(\This()\Class$, "#")+"()"+#CRLF$+#CRLF$
          
          Code$ +"  While IsWindow("+ GetElementClass(Element)+")"+#CRLF$
          Code$ +"    Event = WaitWindowEvent()"+#CRLF$+#CRLF$
          Code$ +"    Select Event"+#CRLF$
          Code$ +"       Case #PB_Event_CloseWindow"+#CRLF$
          Code$ +"         CloseWindow(EventWindow())"+#CRLF$
          Code$ +"    EndSelect"+#CRLF$+#CRLF$
          Code$ +"    Select EventWindow()"+#CRLF$
          
          PushListPosition(\This())
          ForEach \This()
            If \This()\Parent\Element = Panel And \This()\Parent\Item = 0
              Element = \This()\Element
              Code$ +"      Case "+\This()\Class$+#CRLF$
              ; If Code$ : Code$+", " : EndIf : Code$ +\This()\Class$+"=-1"
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
      
      If IsGadget(IDE_Scintilla_Gadget)
        ScintillaSendMessage(IDE_Scintilla_Gadget, #SCI_SETTEXT, 0, UTF8(Code$))
      Else
        SetElementText(IDE_Scintilla_0,Code$)
      EndIf
      

      
      
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
  Protected *Element, EnumerateElement
  ;   
  
  With *CreateElement
    If \MultiSelect
      PushListPosition(\This())
      ForEach \This()
        If \This()\EditingMode
          If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
            
            RemoveElement(\This()\Element)
            
          EndIf
        EndIf
      Next
      PopListPosition(\This())
      
    Else
      FreeElement(Element)
      ;RemoveElement(Element)
    EndIf
  EndWith
  
  ;   ClearElementItems(Properties_Element)
  ;   While EnumerateElement(@EnumerateElement, IDE_cp, 0)
  ;     AddGadgetElementItem(Properties_Element, #PB_Any, ElementClass(ElementType(EnumerateElement))+" ("+Str(EnumerateElement)+")")
  ;   Wend
EndProcedure

Procedure AddNewElement(Type, Parent, Item, Reset.b)
  Protected Element =- 1, X = #PB_Ignore, Y = #PB_Ignore, Width, Height
  
  If Type
    If Parent = EventElement()
      If Not IsContainerElement(Parent)
        Parent = GetElementParent(Parent)
      EndIf
      
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
        Width = 350
        Height = 250
        
      Default
        Width = 130
        Height = 25
        
    EndSelect
    
    With *CreateElement\Selector
      \Color = $E23A2B
      
      If \right>5 And \bottom>5
        X = \left
        Y = \top
        Width = \right+Steps
        Height = \bottom+Steps
      EndIf
      
      \left = 0 : \top = 0 : \right = 0 : \bottom = 0
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
        SetElementImage(Element, GetIcon("elements", "_"))
        
        BindEventElement(@NewElementEvents(), Element, #PB_All)
      Default
        
    EndSelect
    
    SetElementFlags(Element, GetPBFlags(GetElementFlag(Element)))
    
    If IsContainerElement(Element) : CloseElementList() : EndIf
  EndIf 
  
  If IsWindowElement(Element)
    IDE_PopupMenu = CreatePopupMenuElement()
    
    OpenSubMenuElement("Z-Order")
      MenuElementItem(#IDE_MenuItem_First, "First")
      MenuElementItem(#IDE_MenuItem_Prev, "Prev")
      MenuElementItem(#IDE_MenuItem_Next, "Next")
      MenuElementItem(#IDE_MenuItem_Last, "Last")
    CloseSubMenuElement()
    
    MenuElementBar()
    
    MenuElementItem(#IDE_MenuItem_Cut, "Cut", GetButtonIcon(#PB_ToolBarIcon_Cut) )
    MenuElementItem(#IDE_MenuItem_Copy, "Copy", GetButtonIcon(#PB_ToolBarIcon_Copy) )
    MenuElementItem(#IDE_MenuItem_Paste, "Paste", GetButtonIcon(#PB_ToolBarIcon_Paste) )
    MenuElementItem(#IDE_MenuItem_Delete, "Delete", GetButtonIcon(#PB_ToolBarIcon_Delete) )
    
    MenuElementBar()
    
    MenuElementItem(#IDE_MenuItem_Preferences, "Preferences")
    
  EndIf
  
  
  If Reset 
    ResetNewElement() 
  EndIf
  ProcedureReturn Element
EndProcedure


Procedure NewElementEvents(Event.q, EventElement)
  Protected FontColor, BackColor
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
      FontColor = GetElementAttribute(EventElement, #_Attribute_FontColor)
      BackColor = GetElementAttribute(EventElement, #_Attribute_BackColor)
      
      If Trim(GetElementClass(EventElement), "#") = GetElementClass(EventElement)
        SetElementState(Properties_IsEnum, 1)
      Else
        SetElementState(Properties_IsEnum, 0)
      EndIf
      
         
      SetElementText(Properties_Caption, GetElementText(EventElement))
      SetElementState(Properties_Element, GetElementData(EventElement))
      SetElementState(Properties_Enable, Bool(Not IsDisableElement(EventElement)))
      SetElementText(Properties_ID, GetElementClass(EventElement)+" ("+Str(EventElement)+")")
      
      SetElementText(Properties_FontColor, "$"+Hex(FontColor))      
      SetElementText(Properties_BackColor, "$"+Hex(BackColor))      
      
      If IsWindowElement(EventElement)
        DisableElement(Properties_Sticky, #False)
        DisableElement(Properties_ToolTip, #True)
      Else
        DisableElement(Properties_Sticky, #True)
        DisableElement(Properties_ToolTip, #False)
        SetElementText(Properties_ToolTip, GetElementToolTip(EventElement))
      EndIf    
      
      SetPropertiesComboBoxText(Properties_Flag, ReadPBFlags(ElementType(EventElement))); GetElementFlagClass(ElementType(EventElement)))
      
      Protected i,j, Buffer$
;       For j=0 To CountElementItems(Properties_Flag)-1
;         Buffer$ +"|"+ GetElementItemText(Properties_Flag, j)
;       Next
      Buffer$ = GetElementFlags(EventElement)
      For i=1 To CountString(Buffer$,"|")+1
        For j=0 To CountElementItems(Properties_Flag)-1
          If GetElementItemText(Properties_Flag, j)=StringField(Buffer$, i, "|")
            SetElementItemState(Properties_Flag, j, #PB_ListIcon_Checked)
          EndIf
        Next
      Next
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
  
  ; Create drag element
  If IsContainerElement(CheckedElement)
    Static StartX,StartY,LastX,LastY
    Protected Left, Top, Right, Bottom, Sb = 1 ; 
            
    With *CreateElement
      Select Event 
        Case #_Event_LeftButtonUp
          If Not DragElementType
            PushListPosition(\This())
            ForEach \This()
              If (\This()\Parent\Element = EventElement)
                Left = (\This()\ContainerCoordinate\X+(\This()\bSize-\This()\BorderSize))
                Top = (\This()\ContainerCoordinate\Y+(\This()\bSize-\This()\BorderSize))
                Right = (\This()\ContainerCoordinate\X+\This()\FrameCoordinate\Width-\This()\BorderSize*2)
                Bottom = (\This()\ContainerCoordinate\Y+\This()\FrameCoordinate\Height-\This()\BorderSize*2)
                
                If (Right > \Selector\left+Sb) And (Bottom > \Selector\Top+Sb) And
                   Left < ((\Selector\left+\Selector\Right-Sb*2)) And Top < ((\Selector\Top+\Selector\Bottom-Sb*2))
                  
                  \MultiSelect = #True
                  \This()\Flag | #_Flag_Anchors
                  PushListPosition(\This())
                  ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
                  \This()\Flag &~ #_Flag_Anchors
                  PopListPosition(\This())
                  
                EndIf
              EndIf
            Next
            PopListPosition(\This())
            
            \Selector\left = 0 
            \Selector\top = 0 
            \Selector\right = 0 
            \Selector\bottom = 0
          EndIf
          
        Case #_Event_LeftButtonDown
          StartX = Steps(\MouseX,Steps)+2
          StartY = Steps(\MouseY,Steps)+2
          
        Case #_Event_MouseMove 
          If \Buttons And \SideDirection = 0
            PushListPosition(\This())
            ChangeCurrentElement(\This(), ElementID(EventElement))
            
            SetCursorElement(#PB_Cursor_Cross)
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
              Else
                DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter)
                CustomFilterCallback(@DrawFilterCallback()) 
              EndIf
              
              Box(StartX,StartY,LastX,LastY, \Selector\Color)
              
              EndDrawing()
            EndIf
            
            PopListPosition(\This())
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
  Type.S = StringField( Type.S, (2), Chr('='))
  
  ;Handle.S = Trim(StringField(Type.S, 1, Chr('='))) ; 
  ;Type.S = Trim(StringField(Type.S, 2, Chr('=')))
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
  
  SetElementText(Element, Trim(Trim(Caption.S),Chr('"')))
  
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
  ProcedureReturn 
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
;     Debug  i
;     Debug ReadText
    ;     Find.S = IsFindFunctions(ReadText.S)
    ;     Parse(Find.S)
  Next
  
EndProcedure
; GeneratePBForm(0)



Procedure IDE_Scintilla_0_Events(Event.q, EventElement)
  Static Hide = 1
  
  Select Event
    Case #_Event_Size
      Select EventElement
        Case IDE_Scintilla_0
          If Not Hide
            ResizeGadget(IDE_Scintilla_Gadget, 
                         ElementX(EventElement, #_Element_ScreenCoordinate),
                         ElementY(EventElement, #_Element_ScreenCoordinate),
                         ElementWidth(EventElement), ElementHeight(EventElement))
          EndIf
      EndSelect
      
    Case #_Event_Change
      Select EventElement
        Case IDE_cp
          Select GetElementState(IDE_cp)
            Case 0,2 : HideGadget(IDE_Scintilla_Gadget, 1) : Hide=1
            Case 1 : HideGadget(IDE_Scintilla_Gadget, 0) : Hide=0
          EndSelect
          
      EndSelect
  EndSelect
  
  ProcedureReturn #True
EndProcedure

;-
Procedure IDE_Properties_Events(Event.q, EventElement)
  Protected Element, FontColor, BackColor, Item
  Protected CheckedElement = CheckedElement()
  
  ; Then resize panels resize splitters
  Select Event 
    Case #_Event_Change, #_Event_Size
      Select EventElement
        Case IDE_pp
          Element = GetElementItemData(EventElement, GetElementState(EventElement))
          If Element
            ResizeElement(Element, #PB_Ignore, #PB_Ignore, ElementWidth(EventElement), ElementHeight(EventElement))
          EndIf
      EndSelect
  EndSelect
  
  ; Events
  Select Event
    Case #_Event_LeftDoubleClick ; "При двойном клике на событие будем переходить к коду"
      If IsElement(CheckedElement)
        Select EventElement 
          Case Events_LeftClick,
               Events_RightClick,
               Events_LeftDown,
               Events_LeftUp
            
            Select EventElement 
              Case Events_LeftClick
                Item = AddGadgetElementItem(EventElement, 0, GetElementClass(CheckedElement)+"_LeftClick_Event")
                SetElementState(EventElement, Item)
                
                SetElementEvents(CheckedElement, "LeftClick")
                
              Case Events_RightClick
                Item = AddGadgetElementItem(EventElement, 0, GetElementClass(CheckedElement)+"_RightClick_Event")
                SetElementState(EventElement, Item)
                
                SetElementEvents(CheckedElement, "RightClick")
              
            EndSelect
            
            SetElementState(IDE_cp, 1)
            Debug "GetElementClass "+GetElementEvents(CheckedElement) ; GetElementClass(CheckedElement)
        EndSelect
      EndIf
      
    Case #_Event_LeftClick
      Select EventElement 
        Case IDE_Elements 
          DragElementType = Type(GetElementItemText(IDE_Elements)) 
          *CreateElement\DragElementType = DragElementType
          SetElementCustomCursor(GetElementItemImage(IDE_Elements))
          
        Case Properties_Image
          CFE_Helper_Image(IDE_cp,0,0,0,#_Flag_WindowCentered)
          
        Case Properties_ImageBg
          CFE_Helper_Image(IDE_cp,0,0,0,#_Flag_ScreenCentered)
          
        Case Properties_FontColor
          FontColor = ColorRequester(GetElementAttribute(CheckedElement, #_Attribute_FontColor))
          SetElementAttribute(CheckedElement, #_Attribute_FontColor, BackColor)
          SetElementText(EventElement, "$"+Hex(FontColor))      
          
        Case Properties_BackColor
          BackColor = ColorRequester(GetElementAttribute(CheckedElement, #_Attribute_BackColor))
          SetElementAttribute(CheckedElement, #_Attribute_BackColor, BackColor)
          SetElementText(EventElement, "$"+Hex(BackColor))      
          
        Case Properties_Font
          FontRequester("Arial", 8, #PB_FontRequester_Effects )
          SetElementText(EventElement, "("+SelectedFontSize()+") "+SelectedFontName())      
          SetElementFont(CheckedElement, FontID(LoadFont(#PB_Any, SelectedFontName(), SelectedFontSize(), SelectedFontStyle())))
          
      EndSelect
      
    Case #_Event_Change
      Select EventElement 
        Case IDE_pp
          Select GetElementState(IDE_pp)
            Case 0 : SetActiveElement(IDE_Properties)
            Case 1 : SetActiveElement(IDE_Events)
            Case 2 : SetActiveElement(IDE_Elements)
          EndSelect
          
        Case Properties_Flag
          Protected j, Buffer$, Flags$
          SetElementFlags(CheckedElement, "")
          
          For j=0 To CountElementItems(EventElement)-1
            Buffer$ = GetElementItemText(EventElement,j)
            RemoveElementFlag(CheckedElement, Flag(Buffer$))
            If GetElementItemState(EventElement, j)
              SetElementFlags(CheckedElement, Buffer$)
            EndIf
          Next
          
          SetElementFlag(CheckedElement, Flag(GetElementFlags(CheckedElement)))
          
        Case Properties_IsEnum 
          If GetElementState(EventElement)
            SetElementClass(CheckedElement, Trim(GetElementClass(CheckedElement), "#"))
          Else
            SetElementClass(CheckedElement, "#"+GetElementClass(CheckedElement))
          EndIf
          
          SetActiveElement(CheckedElement)
          SetForegroundWindowElement(CheckedElement)
          
        Case Properties_Hide : HideElement(CheckedElement, Bool(GetElementState(EventElement)=0))
        Case Properties_Enable : DisableElement(CheckedElement, Bool(GetElementState(EventElement)=0))
        Case Properties_Sticky : StickyWindowElement(CheckedElement, Bool(GetElementState(EventElement)=0))
        Case Properties_ToolTip : SetElementToolTip(CheckedElement, GetElementText(EventElement))
        Case Properties_Caption : SetElementText(CheckedElement, GetElementText(EventElement))
          
        Case Properties_Element 
          CheckedElement = CheckedElement(GetElementItemData(EventElement, GetElementState(EventElement)))
          SetAnchors(CheckedElement)
          SetActiveElement(CheckedElement)
          SetForegroundWindowElement(CheckedElement)
          
        Case Properties_X,Properties_Y,Properties_Width,Properties_Height
          SetElementState(EventElement, Val(GetElementText(EventElement)))
         
          ResizeElement(CheckedElement, 
                        GetElementState(Properties_X),
                        GetElementState(Properties_Y),
                        GetElementState(Properties_Width), 
                        GetElementState(Properties_Height))
;           ResizeElement(CheckedElement, 
;                         GetElementState(Properties_X)-3,
;                         GetElementState(Properties_Y)-3,
;                         GetElementState(Properties_Width)+6+GetElementAttribute(CheckedElement, #_Attribute_BorderSize)*2, 
;                         GetElementState(Properties_Height)+6+GetElementAttribute(CheckedElement, #_Attribute_BorderSize)*2+GetElementAttribute(CheckedElement, #_Attribute_CaptionHeight))
          
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
  Static RunProgram, CopyElement
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
          
        Case #IDE_MenuItem_Copy
          With *CreateElement
            If IsElement(EventElement)
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(EventElement))
              ChangeCurrentElement(\This(), ElementID(\This()\Linked\Parent))
              
              If \MultiSelect
                PushListPosition(\This())
                ForEach \This()
                  If \This()\EditingMode
                    If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
                      Copyies(Str(\This()\Element))\Class$ = \This()\Class$
                      Copyies(Str(\This()\Element))\Type$ = Str(\This()\Type)
                      Copyies(Str(\This()\Element))\Window$ = Str(\This()\Window)
                      Copyies(Str(\This()\Element))\Parent$ = Str(\This()\Parent\Element)
                      Copyies(Str(\This()\Element))\X$ = Str(\This()\ContainerCoordinate\X) 
                      Copyies(Str(\This()\Element))\Y$ = Str(\This()\ContainerCoordinate\Y) 
                      Copyies(Str(\This()\Element))\Width$ = Str(\This()\FrameCoordinate\Width) 
                      Copyies(Str(\This()\Element))\Height$ = Str(\This()\FrameCoordinate\Height)
                      Copyies(Str(\This()\Element))\Caption$ = \This()\Text\String$
                      
                      Copyies(Str(\This()\Element))\Param1$ = Str(\This()\Param1)
                      Copyies(Str(\This()\Element))\Param2$ = Str(\This()\Param2)
                      Copyies(Str(\This()\Element))\Param3$ = Str(\This()\Param3)
                      
                      Copyies(Str(\This()\Element))\Flag$ = Str(\This()\Flag)
                      
                      Protected Parent = \This()\Element
                      If \This()\Childrens
                        PushListPosition(\This())
                        ForEach \This()
                          If \This()\EditingMode And IsChildElement(\This()\Element, Parent)
                            
                            Copyies(Str(\This()\Element))\Class$ = \This()\Class$
                            Copyies(Str(\This()\Element))\Type$ = Str(\This()\Type)
                            Copyies(Str(\This()\Element))\Window$ = Str(\This()\Window)
                            Copyies(Str(\This()\Element))\Parent$ = Str(\This()\Parent\Element)
                            Copyies(Str(\This()\Element))\X$ = Str(\This()\ContainerCoordinate\X) 
                            Copyies(Str(\This()\Element))\Y$ = Str(\This()\ContainerCoordinate\Y) 
                            Copyies(Str(\This()\Element))\Width$ = Str(\This()\FrameCoordinate\Width) 
                            Copyies(Str(\This()\Element))\Height$ = Str(\This()\FrameCoordinate\Height)
                            Copyies(Str(\This()\Element))\Caption$ = \This()\Text\String$
                            
                            Copyies(Str(\This()\Element))\Param1$ = Str(\This()\Param1)
                            Copyies(Str(\This()\Element))\Param2$ = Str(\This()\Param2)
                            Copyies(Str(\This()\Element))\Param3$ = Str(\This()\Param3)
                            
                            Copyies(Str(\This()\Element))\Flag$ = Str(\This()\Flag)
                            
                          EndIf
                        Next
                        PopListPosition(\This())
                        
                      EndIf
                    EndIf
                  EndIf
                Next
                PopListPosition(\This())
              Else
                Copyies(Str(\This()\Element))\Class$ = \This()\Class$
                Copyies(Str(\This()\Element))\Type$ = Str(\This()\Type)
                Copyies(Str(\This()\Element))\Window$ = Str(\This()\Window)
                Copyies(Str(\This()\Element))\Parent$ = Str(\This()\Parent\Element)
                Copyies(Str(\This()\Element))\X$ = Str(\This()\ContainerCoordinate\X) 
                Copyies(Str(\This()\Element))\Y$ = Str(\This()\ContainerCoordinate\Y) 
                Copyies(Str(\This()\Element))\Width$ = Str(\This()\FrameCoordinate\Width) 
                Copyies(Str(\This()\Element))\Height$ = Str(\This()\FrameCoordinate\Height)
                Copyies(Str(\This()\Element))\Caption$ = \This()\Text\String$
                
                Copyies(Str(\This()\Element))\Param1$ = Str(\This()\Param1)
                Copyies(Str(\This()\Element))\Param2$ = Str(\This()\Param2)
                Copyies(Str(\This()\Element))\Param3$ = Str(\This()\Param3)
                
                Copyies(Str(\This()\Element))\Flag$ = Str(\This()\Flag)
              EndIf
              PopListPosition(\This())
            EndIf
          EndWith
          
        Case #IDE_MenuItem_Paste
          With *CreateElement
            If MapSize(Copyies())
              SetAnchors(EventElement)
              OpenElementList(EventElement)
              ForEach Copyies()
                CreateElement(Val(Copyies()\Type$), #PB_Any,
                              Val(Copyies()\X$), 
                              Val(Copyies()\Y$)+Val(Copyies()\Height$), 
                              Val(Copyies()\Width$), 
                              Val(Copyies()\Height$),
                              Copyies()\Caption$, -1,-1,-1,Val(Copyies()\Flag$)|#_Flag_Anchors)
                
              Next
              ;CloseElementList()
            EndIf
          
          EndWith
  
              
        Case #IDE_MenuItem_Quit   : End
          
      EndSelect
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure IDE_Events(Event.q, EventElement)
  Static RunProgram
  Protected Element, ElementCreate, CheckType
  Protected CheckedElement = CheckedElement()
  Protected Type = ElementType(CheckedElement)
  
  IDE_Menu_Events(Event, EventElement)
  
  ; Then resize panels resize splitters
  Select Event 
    Case #_Event_Change, #_Event_Size
      Select EventElement
        Case IDE
          ResizeElement(IDE_Splitter_4, #PB_Ignore, #PB_Ignore, ElementWidth(EventElement), ElementHeight(EventElement))
        
        Case IDE_cp
          Element = GetElementItemData(EventElement, GetElementState(EventElement))
          If Element
            ResizeElement(Element, #PB_Ignore, #PB_Ignore, ElementWidth(EventElement), ElementHeight(EventElement))
          EndIf
      EndSelect
  EndSelect
  
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
          Else
            DisableElement(IDE_ToolBar_0, 1)
          EndIf
          
          Select GetElementItemText(EventElement) 
            Case "Form" : GeneratePBForm(EventElement)
            Case "Code" : GeneratePBCode(EventElement)
            Case "V_Code"
              ;AddGadgetElementItem(IDE_Canvas_0,-1,"Button",png, #_Flag_Border|#_Flag_Image_Left|#_Flag_Text_Center)
              
          EndSelect
          
;           Select GetElementState(EventElement) ; EventElementItem()
;             Case 0 : GeneratePBForm(EventElement)
;             Case 1 : GeneratePBCode(EventElement)
; ;             Case 2 
; ;               AddGadgetElementItem(IDE_Canvas_0,-1,"Button",png, #_Flag_Border|#_Flag_Image_Left|#_Flag_Text_Center)
;           EndSelect
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
      
      ; Debug "IDE_Events() "+EventElement+" "+EventClass(Event)+" "+Str(GetElementParent(EventElement))
      
  EndSelect
  
  
  ProcedureReturn #True
EndProcedure


;-
CompilerIf #PB_Compiler_IsMainFile
  Define  Time = ElapsedMilliseconds()
  
  Procedure IDE_Menu_Create()
    
    IDE_Menu_0 = CreateMenuElement(#PB_Any,IDE)
    
    If IDE_Menu_0
      MenuElementTitle("File")
      MenuElementItem(#IDE_MenuItem_Open,"Open"   +Chr(9)+"  Ctrl+O", GetButtonIcon(#PB_ToolBarIcon_Open))
      MenuElementItem(#IDE_MenuItem_Save,"Save"   +Chr(9)+"  Ctrl+S", GetButtonIcon(#PB_ToolBarIcon_Save))
      MenuElementBar()
      MenuElementItem(#IDE_MenuItem_Quit,"Quit")
      
      MenuElementTitle("Edit")
      MenuElementTitle("Project")
      MenuElementTitle("Form")
      MenuElementItem(#IDE_MenuItem_New,"New", GetButtonIcon(#PB_ToolBarIcon_New))
    EndIf
    
    IDE_Toolbar_0 = CreateToolbarElement(#PB_Any, IDE);, #_Flag_Small)
    
    If IDE_Toolbar_0
      ToolBarElementButton( #IDE_MenuItem_New, GetIcon("add_form"), 0, #PB_ToolBarIcon_Add,"New", "Создать новую форму")
      ToolBarElementButton( #IDE_MenuItem_Delete, -1, 0, #PB_ToolBarIcon_Delete,"Delete", "Удалить выбраную форму")
      ToolBarElementSeparator()
      ToolBarElementButton( #IDE_MenuItem_First, GetIcon("move_first"), 0, -1,"First", "Переместить на задний план")
      ToolBarElementButton( #IDE_MenuItem_Next, GetIcon("move_next"), 0, -1,"Next", "Переместить на один вперед")
      ToolBarElementButton( #IDE_MenuItem_Prev, GetIcon("move_prev"), 0, -1,"Prev", "Переместить на один назад")
      ToolBarElementButton( #IDE_MenuItem_Last, GetIcon("move_last"), 0, -1,"Last", "Переместить на передний план")
      ToolBarElementSeparator()
    EndIf
    
    IDE_EditPopupMenu = CreatePopupMenuElement()
    
    If IDE_EditPopupMenu
      MenuElementItem(1001, "Cut", GetButtonIcon(#PB_ToolBarIcon_Cut) )
      MenuElementItem(1002, "Copy", GetButtonIcon(#PB_ToolBarIcon_Copy) )
      MenuElementItem(1003, "Paste", GetButtonIcon(#PB_ToolBarIcon_Paste) )
      MenuElementItem(1004, "Delete", GetButtonIcon(#PB_ToolBarIcon_Delete) )
    EndIf
    
  EndProcedure
  
  Procedure IDE_Create(Width,Height)
    IDE = OpenWindowElement(#PB_Any, 30,30, Width,Height, "Designer", #_Flag_MinimizeGadget|#_Flag_MaximizeGadget|#_Flag_ScreenCentered);|#_Flag_Invisible)
    
    IDE_Menu_Create()
    
    ;{ - (form & code)
    IDE_cp = PanelElement(#PB_Any,0,0,0,0, #_Flag_Transparent)                                                               ;
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
    
    ;   If InitScintilla()
    ;     IDE_Scintilla_Gadget = ScintillaGadget(#PB_Any,0,0,0,0,0)
    ;     
    ;     BindGadgetElementEvent(IDE_cp, @IDE_Scintilla_0_Events(), #_Event_Change)
    ;     BindGadgetElementEvent(IDE_Scintilla_0, @IDE_Scintilla_0_Events(), #_Event_Size)
    ;   EndIf
    
    Define ei=AddGadgetElementItem(IDE_cp, -1, "V_Code")
    IDE_Canvas_0 = CreateElement(#_Type_Canvas, #PB_Any,0,0,0,0,"Canvas",-1,-1,-1,#_Flag_BorderLess)   
    SetElementBackGroundImage(IDE_Canvas_0, img_point)
    SetElementItemData(IDE_cp, ei, IDE_Canvas_0)
    
    CloseElementList()
    
    IDE_List_0 = EditorElement(#PB_Any, 0,0,0,0, "List_0")
    IDE_Splitter_0 = SplitterElement(#PB_Any, 0,0,0,0, IDE_cp,IDE_List_0, #_Flag_Separator_Circle|#_Flag_SecondFixed)
    ;}
    
    ;{ - (elements & properties)
    IDE_pp = PanelElement(#PB_Any,0,0,0,0, #_Flag_BorderLess|#_Flag_Transparent) 
    ;
    Define ei=AddPanelElementItem(IDE_pp, #PB_Any, "Properties", GetButtonIcon(#PB_ToolBarIcon_Print))
    IDE_Properties = PropertiesElement(#PB_Any,0,0,0,0)            
    Properties_IsEnum = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Enumeration True|False")
    Properties_Element = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Elements")
    Properties_ID = AddPropertiesElementItem(IDE_Properties, #PB_Any, "String ID") : DisableElement(Properties_ID, #True)
    Properties_Caption = AddPropertiesElementItem(IDE_Properties, #PB_Any, "String Caption")
    
    Properties_ToolTip = AddPropertiesElementItem(IDE_Properties, #PB_Any, "String ToolTip")
    
    ;   Properties_AlignText = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox AlignText None|Center|Right")
    ;   Properties_AlignImage = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox AlignImage ")
    Properties_AlignElement = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox AlignElement ")
    
    Properties_Image = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Button Image Puch_to_image")
    Properties_ImageBg = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Button BgImage Puch_to_background_Image")
    
    Properties_X = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin X 0|100")
    Properties_Y = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin Y 0|200")
    Properties_Width = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin Width 0|100")
    Properties_Height = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Spin Height 0|200")
    
    Properties_Data = AddPropertiesElementItem(IDE_Properties, #PB_Any, "String Data ")
    Properties_Font = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Button Font ")
    Properties_FontColor = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Button FontColor ")
    Properties_BackColor = AddPropertiesElementItem(IDE_Properties, #PB_Any, "Button BackColor ")
    Properties_State = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox State Normal|Maximized|Minimized")
    Properties_Sticky = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Sticky True|False")
    Properties_Hide = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Hide True|False")
    Properties_Enable = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Disable True|False")
    Properties_Flag = AddPropertiesElementItem(IDE_Properties, #PB_Any, "ComboBox Flag", -1, #PB_ListIcon_CheckBoxes)
    
    IDE_iProperties = TextElement(#PB_Any,0,0,0,0,"Text") 
    
    IDE_sProperties = SplitterElement(#PB_Any, 0,0,0,0, IDE_Properties,IDE_iProperties, #_Flag_Separator_Circle|#_Flag_SecondFixed);|#_Flag_AlignFull)
    SetElementItemData(IDE_pp, ei, IDE_sProperties)
    
    ;
    Define ei=AddPanelElementItem(IDE_pp, #PB_Any, "Events", GetIcon("lightning"));GetButtonIcon(#PB_ToolBarIcon_Properties))
    IDE_Events = PropertiesElement(#PB_Any,0,0,0,0)            
    Events_Bind = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox BindEvent True|False")
    Events_LeftClick = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox LeftClick", #PB_Default, #PB_ComboBox_Editable)
    Events_RightClick = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox RightClick", #PB_Default, #PB_ComboBox_Editable)
    Events_LeftDown = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox LeftDown", #PB_Default, #PB_ComboBox_Editable)
    Events_LeftUp = AddPropertiesElementItem(IDE_Events, #PB_Any, "ComboBox LeftUp", #PB_Default, #PB_ComboBox_Editable)
    
    IDE_iEvents = ButtonElement(#PB_Any, 0,0,0,0, "72ButtonElement")
    IDE_sEvents = SplitterElement(#PB_Any, 0,0,0,0, IDE_Events,IDE_iEvents, #_Flag_Separator_Circle|#_Flag_SecondFixed);|#_Flag_AlignFull)
    
    SetElementItemData(IDE_pp, ei, IDE_sEvents)
    
    ;
    Define ei=AddPanelElementItem(IDE_pp, #PB_Any, "Elements", GetIcon("elements"));;LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
    IDE_Elements = ListViewElement(#PB_Any,0,0,0,0) 
    LoadGadgetImage(IDE_Elements, GetCurrentDirectory()+"Themes/")
    SetElementState(IDE_Elements,0)
    ; ElementToolTip(IDE_Elements)
    
    IDE_iElements = TextElement(#PB_Any,0,0,0,0,"Text", #_Flag_Flat)   
    
    IDE_sElements = SplitterElement(#PB_Any, 0,0,0,0, IDE_Elements,IDE_iElements, #_Flag_Separator_Circle|#_Flag_SecondFixed);|#_Flag_AlignFull)
    SetElementItemData(IDE_pp, ei, IDE_sElements)
    
    CloseElementList()
    
    ; ;   With *CreateElement
    ; ;     PushListPosition(\This()) 
    ; ;     ChangeCurrentElement(\This(), ElementID( IDE_cp ))
    ; ;     ChangeCurrentElement(\This()\Items(), ItemID( ListSize(\This()\Items())-1 ))
    ; ;     Define IDE_vElements = ButtonImageElement(#PB_Any, \This()\Items()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\Width+5,3,20,20, LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
    ; ;     PopListPosition(\This())
    ; ;   EndWith
    
    IDE_Splitter_4 = SplitterElement(#PB_Any, 0,0,Width,Height, IDE_Splitter_0,IDE_pp, #_Flag_Vertical|#_Flag_Separator_Circle|#_Flag_SecondFixed)
    
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
    BindEventElement(@IDE_Events(), IDE, #PB_All)
    
    
    ;HideElement(IDE, #False)
  EndProcedure
  
  IDE_Create(900,600)
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf
  WaitWindowEventClose(IDE)
  End
  
CompilerEndIf

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 1067
; FirstLine = 1036
; Folding = --------------------------------
; EnableXP
; Executable = CFE(IDE)