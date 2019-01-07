
;06.01.2017
; =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  = 
; Module:          CreateWidget.pbi
; DesignElements
; Author:          nic mestnyi
; Date:            09; 07; 16 
; Version:         1.5.1
; Target Compiler: PureBasic 5.2+
; Target OS:       All
; License:         Free, unrestricted, no warranty whatsoever
;                  Use at your own risk
; =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  = 

Global Demo

; Изменения 06; 01; 2017
; Функция 
; OS
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Procedure GadgetsClipCallBack( GadgetID, lParam )
    If GadgetID
      Protected Gadget = GetDlgCtrlID_( GadgetID )
      
      If ((GetWindowLongPtr_( GadgetID, #GWL_STYLE ) & #WS_CLIPSIBLINGS) = #False) 
        If IsGadget( Gadget ) 
          Select GadgetType( Gadget )
            Case #PB_GadgetType_ComboBox
              Protected Height = GadgetHeight( Gadget )
              
          EndSelect
        EndIf
        
        SetWindowLongPtr_( GadgetID, #GWL_STYLE, GetWindowLongPtr_( GadgetID, #GWL_STYLE ) | #WS_CLIPSIBLINGS | #WS_CLIPCHILDREN )
        
        If Height : ResizeGadget( Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height ) : EndIf
        
        SetWindowPos_( GadgetID, #GW_HWNDFIRST, 0,0,0,0, #SWP_NOMOVE|#SWP_NOSIZE )
      EndIf
      
    EndIf
    
    ProcedureReturn GadgetID
  EndProcedure
CompilerEndIf

Procedure ClipGadgets( WindowID )
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    EnumChildWindows_( WindowID, @GadgetsClipCallBack(), 0 )
  CompilerEndIf
EndProcedure

#PB_ToolBarIcon_Add = 1<<16

; If LoadFont(0, "Arial", 9)
;   SetElementFont(#PB_Default, FontID(0))   ; Set the loaded Arial 16 font as new standard
; EndIf

#ANY = 0

CompilerIf (#PB_Compiler_IsMainFile)
  EnableExplicit
CompilerEndIf

UsePNGImageDecoder()
Global Up = CatchImage(#PB_Any, ?up, 1150)
Global Down = CatchImage(#PB_Any, ?Down, 582)
Global ico = CatchImage(#PB_Any, ?i, 1150)
Global png = CatchImage(#PB_Any, ?p, 582)

Global min = CatchImage(#PB_Any, ?minimize, 131)
Global max = CatchImage(#PB_Any, ?maximize, 204)
Global mxd = CatchImage(#PB_Any, ?maximized, 241)
Global cls = CatchImage(#PB_Any, ?close, 223)



Global Image = CreateImage(#PB_Any,5,5);,32,#PB_2DDrawing_Transparent)

LoadImage(5, #PB_Compiler_Home + "examples/sources/Data/world.png")
CatchImage(0, ?p, 582)
CatchImage(1, ?minimize, 131)
CatchImage(2, ?maximize, 204)
CatchImage(3, ?maximized, 241)
CatchImage(4, ?close, 223)

Global OpenList =- 1, CloseList =- 1, ElementMenu



DataSection
  minimize:
  Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
  Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$00,$4A,$49,$44,$41
  Data.b $54,$78,$DA,$ED,$CF,$31,$0A,$00,$20,$0C,$03,$40,$2B,$38,$76,$F1,$07,$EE,$D5,$FF
  Data.b $FF,$4E,$33,$14,$04,$29,$A2,$B8,$38,$34,$70,$53,$68,$A0,$C1,$E3,$F9,$32,$04,$F1
  Data.b $10,$59,$C7,$FD,$10,$43,$5A,$07,$E2,$C5,$40,$01,$B6,$06,$58,$4B,$81,$0A,$CD,$20
  Data.b $60,$0E,$10,$24,$2D,$F2,$D6,$7C,$E1,$3D,$03,$D5,$61,$16,$C4,$CD,$6D,$97,$D8,$00
  Data.b $00,$00,$00,$49,$45,$4E,$44,$AE,$42,$60,$82
  minimizeend:
EndDataSection

DataSection
  maximize:
  Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
  Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$00,$93,$49,$44,$41
  Data.b $54,$78,$DA,$CD,$D2,$B1,$0E,$82,$40,$10,$84,$61,$59,$A0,$80,$82,$80,$86,$D8,$28
  Data.b $14,$14,$24,$14,$60,$7C,$FF,$52,$E3,$23,$F8,$38,$E7,$5F,$6C,$61,$36,$7B,$39,$13
  Data.b $1B,$36,$F9,$AA,$99,$0C,$14,$77,$D8,$E5,$65,$90,$04,$3A,$FE,$BD,$11,$12,$9E,$A8
  Data.b $91,$7B,$5F,$0E,$3F,$BA,$A0,$B6,$03,$A2,$E1,$82,$1B,$36,$AC,$C6,$5D,$3B,$33,$DA
  Data.b $D8,$C0,$84,$11,$3D,$8E,$46,$FF,$D5,$E9,$62,$03,$23,$4E,$28,$21,$46,$09,$ED,$C4
  Data.b $FF,$60,$D0,$50,$10,$ED,$EC,$7F,$A0,$43,$01,$31,$8A,$D4,$C0,$03,$21,$E1,$85,$2B
  Data.b $1A,$EF,$21,$55,$38,$6B,$61,$F0,$68,$46,$87,$AE,$73,$B9,$06,$0D,$5A,$8F,$66,$95
  Data.b $76,$FF,$BF,$0F,$21,$2E,$31,$D6,$FF,$2F,$53,$8C,$00,$00,$00,$00,$49,$45,$4E,$44
  Data.b $AE,$42,$60,$82
  maximizeend:
EndDataSection

DataSection
  maximized:
  Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
  Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$00,$B8,$49,$44,$41
  Data.b $54,$78,$DA,$CD,$91,$41,$0A,$C2,$30,$14,$44,$6D,$48,$41,$B1,$52,$95,$AE,$2C,$4D
  Data.b $44,$45,$04,$51,$14,$BC,$FF,$AE,$E8,$11,$BC,$4D,$9D,$C5,$84,$48,$18,$9A,$85,$1B
  Data.b $3F,$BC,$4D,$33,$79,$64,$7E,$27,$7F,$35,$05,$31,$23,$30,$A3,$2F,$BF,$C1,$30,$42
  Data.b $0F,$E6,$C0,$2A,$89,$61,$28,$87,$07,$15,$F3,$52,$70,$01,$37,$70,$4D,$B8,$F3,$FC
  Data.b $04,$D6,$7C,$85,$51,$82,$3D,$E8,$40,$C3,$60,$A0,$11,$75,$2A,$25,$70,$BC,$50,$26
  Data.b $CB,$2B,$55,$9D,$9C,$60,$FA,$25,$B0,$3C,$3F,$83,$47,$A8,$93,$0A,$FA,$CC,$02,$5F
  Data.b $E0,$00,$5C,$AC,$1B,$A7,$E0,$2F,$DA,$80,$2D,$03,$47,$B0,$03,$8E,$78,$D0,$82,$3A
  Data.b $BC,$36,$15,$58,$4A,$56,$51,$10,$17,$CA,$EF,$0B,$30,$53,$02,$4A,$28,$CA,$D7,$79
  Data.b $A6,$4B,$54,$75,$5A,$86,$9C,$C0,$B3,$6E,$1C,$55,$87,$7D,$97,$82,$9A,$E7,$BF,$CF
  Data.b $07,$CA,$A4,$3E,$2A,$D8,$8F,$BC,$14,$00,$00,$00,$00,$49,$45,$4E,$44,$AE,$42,$60
  Data.b $82
  maximizedend:
EndDataSection

DataSection
  Close:
  Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
  Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$00,$A6,$49,$44,$41
  Data.b $54,$78,$DA,$CD,$92,$BB,$0A,$C3,$30,$0C,$45,$1B,$43,$9C,$2E,$59,$D3,$25,$4B,$06
  Data.b $2F,$E9,$D8,$A4,$FF,$FF,$67,$AE,$0A,$C7,$CB,$35,$97,$0C,$5D,$6A,$38,$60,$74,$25
  Data.b $D9,$7A,$DC,$FE,$EE,$0C,$41,$82,$E1,$5A,$EF,$C5,$0A,$73,$90,$B1,$39,$7D,$D4,$04
  Data.b $09,$B1,$B1,$04,$13,$81,$83,$68,$1B,$49,$BA,$04,$B3,$38,$3E,$82,$BB,$D8,$5E,$41
  Data.b $C1,$B7,$2B,$21,$F3,$72,$35,$1C,$C1,$8E,$4F,$76,$4D,$9C,$78,$B9,$0A,$EF,$E0,$89
  Data.b $46,$69,$6E,$12,$7C,$5B,$38,$83,$15,$4D,$82,$CD,$34,$94,$CB,$04,$08,$FA,$ED,$53
  Data.b $6C,$52,$82,$0F,$3E,$A8,$79,$85,$DA,$70,$4D,$4C,$32,$AA,$BD,$8D,$F1,$8B,$34,$B6
  Data.b $D8,$3D,$60,$49,$8A,$2E,$12,$F7,$05,$6D,$73,$7B,$30,$22,$B8,$55,$CE,$4D,$C7,$F7
  Data.b $F7,$F3,$01,$8D,$28,$39,$E1,$16,$26,$7B,$2C,$00,$00,$00,$00,$49,$45,$4E,$44,$AE
  Data.b $42,$60,$82
  closeend:
EndDataSection



Global hdc

Procedure Steps(Value, Steps)
  If Steps : Value = (Value / Steps) * Steps : EndIf
  ProcedureReturn Value
EndProcedure

; Macro Steps(Value, Steps)
;   ((Value / Steps) * Steps)
; EndMacro



;-- Enumeration
;{ 
EnumerationBinary (#PB_Window_BorderLess<<1)
  #PB_Window_Transparent 
  #PB_Window_Flat
  #PB_Window_Single
  #PB_Window_Double
  #PB_Window_Raised
  #PB_Window_MoveGadget
  #PB_Window_CloseGadget
EndEnumeration

EnumerationBinary (#PB_Container_Double<<1)
  #PB_Container_Transparent 
EndEnumeration

EnumerationBinary (#PB_Gadget_ActualSize<<1)
  #PB_Gadget_Left   
  #PB_Gadget_Top    
  #PB_Gadget_Right  
  #PB_Gadget_Bottom 
  
  #PB_Gadget_VCenter
  #PB_Gadget_HCenter
  #PB_Gadget_Full
  #PB_Gadget_Center = (#PB_Gadget_HCenter|#PB_Gadget_VCenter)
EndEnumeration


EnumerationBinary #PB_Event_FirstCustomValue
  
  #_Event_Thread
  #_Event_Form
  #_Event_Window
  #_Event_Element
  
EndEnumeration

Enumeration - 7 ; Type
  #_Type_Message
  #_Type_PopupMenu
  #_Type_Desktop
  #_Type_StatusBar
  #_Type_Menu           ;  "Menu"
  #_Type_Toolbar        ;  "Toolbar"
  #_Type_Window         ;  "Window"
  #_Type_Unknown        ;  "Create"
  #_Type_Button         ;  "Button"
  #_Type_String         ;  "String"
  #_Type_Text           ;  "Text"
  #_Type_CheckBox       ;  "CheckBox"
  #_Type_Option         ;  "Option"
  #_Type_ListView       ;  "ListView"
  #_Type_Frame          ;  "Frame"
  #_Type_ComboBox       ;  "ComboBox"
  #_Type_Image          ;  "Image"
  #_Type_HyperLink      ;  "HyperLink"
  #_Type_Container      ;  "Container"
  #_Type_ListIcon       ;  "ListIcon"
  #_Type_IPAddress      ;  "IPAddress"
  #_Type_ProgressBar    ;  "ProgressBar"
  #_Type_ScrollBar      ;  "ScrollBar"
  #_Type_ScrollArea     ;  "ScrollArea"
  #_Type_TrackBar       ;  "TrackBar"
  #_Type_Web            ;  "Web"
  #_Type_ButtonImage    ;  "ButtonImage"
  #_Type_Calendar       ;  "Calendar"
  #_Type_Date           ;  "Date"
  #_Type_Editor         ;  "Editor"
  #_Type_ExplorerList   ;  "ExplorerList"
  #_Type_ExplorerTree   ;  "ExplorerTree"
  #_Type_ExplorerCombo  ;  "ExplorerCombo"
  #_Type_Spin           ;  "Spin"
  #_Type_Tree           ;  "Tree"
  #_Type_Panel          ;  "Panel"
  #_Type_Splitter       ;  "Splitter"
  #_Type_MDI           
  #_Type_Scintilla      ;  "Scintilla"
  #_Type_Shortcut       ;  "Shortcut"
  #_Type_Canvas         ;  "Canvas"
  
  #_Type_ImageButton    ;  "ImageButton"
  #_Type_Properties     ;  "Properties"
  
  #_Type_StringImageButton    ;  "ImageButton"
  #_Type_StringButton         ;  "ImageButton"
  #_Type_AnchorButton         ;  "ImageButton"
  #_Type_ComboButton          ;  "ImageButton"
  #_Type_DropButton           ;  "ImageButton"
  
EndEnumeration

EnumerationBinary  ; State
  #_State_Default 
  #_State_Entered 
  #_State_Selected 
  #_State_Focused
EndEnumeration

EnumerationBinary 1 ; Flag.q
  #_Flag_Vertical   ; 1 - #PB_Splitter_Vertical ; The Gadget is split vertically (instead of horizontally which is the Default).
  #_Flag_Separator  ; 2 - #PB_Splitter_Separator ; A 3D-looking separator is drawn in the splitter.
  #_Flag_FirstFixed ; 4 - #PB_Splitter_FirstFixed ; When the splitter Gadget is resized, the first Gadget will keep its Size
  #_Flag_SecondFixed; 8 - #PB_Splitter_SecondFixed ; When the splitter Gadget is resized, the second Gadget will keep its Size
  #_Flag_Separator_Circle ; =  0
  
  #_Flag_CloseGadget
  #_Flag_MinimizeGadget ; Adds the minimize Gadget To the Window Title bar. #_Flag_SystemMenu is automatically added.
  #_Flag_MaximizeGadget
  
  #_Flag_Text_Left   
  #_Flag_Text_Top    
  #_Flag_Text_Right  
  #_Flag_Text_Bottom 
  
  #_Flag_Text_VCenter
  #_Flag_Text_HCenter
  
  #_Flag_Image_Left   
  #_Flag_Image_Top    
  #_Flag_Image_Right  
  #_Flag_Image_Bottom 
  
  #_Flag_Image_VCenter
  #_Flag_Image_HCenter
  
  #_Flag_Element_Left   
  #_Flag_Element_Top    
  #_Flag_Element_Right  
  #_Flag_Element_Bottom 
  
  #_Flag_Element_VCenter
  #_Flag_Element_HCenter
  ;#_Flag_Element_Full
  
  
  #_Flag_Border
  #_Flag_BorderLess ; Without any border.
  
  #_Flag_Flat       ; Flat frame.
  #_Flag_Raised     ; Raised frame.
  #_Flag_Single     ; Single sunken frame.
  #_Flag_Double     ; Double sunken frame.
  
  #_Flag_Small
  #_Flag_Large
  #_Flag_Mosaic 
  #_Flag_Stretch 
  #_Flag_Transparent
  #_Flag_Proportionally 
  
  #_Flag_ReadOnly
  #_Flag_InlineText
  
  #_Flag_Editable
  #_Flag_MultiLine
  #_Flag_Numeric
  #_Flag_Password
  #_Flag_LowerCase
  #_Flag_UpperCase
  
  
  #_Flag_TitleBar       ; Creates a Window With a titlebar.
  
  #_Flag_SizeGadget     ; Adds the sizeable feature To a Window.
  #_Flag_MoveGadget     ; Adds the sizeable feature To a Window.
  
  
  #_Flag_Invisible      ; Creates the Window but don't display.
  #_Flag_NoGadgets      ; PrEvents the creation of a GadgetList. UseGadgetList() can be used To do this later.
  #_Flag_NoActivate     ; Don't activate the window after opening.
  #_Flag_Tool           ; Creates a Window With a smaller titlebar And no taskbar entry. 
  #_Flag_HelpGadget
  
  #_Flag_ScreenCentered ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
  #_Flag_WindowCentered ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified). X,Y parameters are ignored.
  
  
  #_Flag_AlignLeft   
  #_Flag_AlignTop    
  #_Flag_AlignRight  
  #_Flag_AlignBottom 
  #_Flag_AlignCenter 
  #_Flag_AlignFull
  #_Flag_DockClient
  
  
  
  
  #_Flag_Anchors ; предель по моему дальше не работает
  #_Flag_Toggle
EndEnumeration
;Debug  #_Flag_SecondFixed

#_Flag_CheckBoxes = #_Flag_Vertical
#_Flag_ThreeState = #PB_ListIcon_ThreeState


#_Flag_Text_Center = (#_Flag_Text_HCenter|#_Flag_Text_VCenter)
#_Flag_Image_Center = (#_Flag_Image_HCenter|#_Flag_Image_VCenter)
#_Flag_Element_Center = (#_Flag_Element_HCenter|#_Flag_Element_VCenter)
#_Flag_SystemMenu = (#_Flag_TitleBar|#_Flag_MoveGadget|#_Flag_CloseGadget) ; Enables the system menu on the Window Title bar (Default).

#_Flag_AnchorsGadget = #_Flag_Anchors|#_Flag_SizeGadget|#_Flag_MoveGadget

#_Flag_DockLeft = #_Flag_AlignTop|#_Flag_AlignLeft|#_Flag_AlignBottom
#_Flag_DockTop = #_Flag_AlignLeft|#_Flag_AlignTop|#_Flag_AlignRight  
#_Flag_DockRight = #_Flag_AlignTop|#_Flag_AlignRight|#_Flag_AlignBottom
#_Flag_DockBottom = #_Flag_AlignLeft|#_Flag_AlignBottom|#_Flag_AlignRight


EnumerationBinary BinaryElement ; Coordinates
  
  #_Element_ClipCoordinate
  #_Element_ClipInnerCoordinate
  
  #_Element_FrameCoordinate 
  #_Element_InnerCoordinate
  #_Element_ContainerCoordinate 
  #_Element_ScreenCoordinate 
  #_Element_WindowCoordinate 
  
  ; #_Element_RequiredCoordinate
EndEnumeration

EnumerationBinary BinaryElement ; Other
  
  #_Element_Item
  
  ; EndEnumeration
  ; 
  ; Enumeration - 4
  #_Element_PositionFirst 
  #_Element_PositionPrev
  #_Element_PositionNext
  #_Element_PositionLast
EndEnumeration




Enumeration Attribute
  ;EnumerationBinary BinaryElement ; Color
  
  #_Text
  #_Image
  #_Element
  #_Align
  
  #_Attribute_Cursor
  #_Attribute_BorderSize
  #_Attribute_CaptionHeight
  
  #_Attribute_GrayTextColor
  #_Attribute_TitleBackColor
  #_Attribute_TitleFrontColor
  
  #_Attribute_DefaultColor
  #_Attribute_BackColor
  #_Attribute_FrameColor
  #_Attribute_EnteredBackColor
  #_Attribute_SelectedBackColor
  
  #_Attribute_FontColor
  #_Attribute_FontBackColor
  #_Attribute_EnteredFontColor
  #_Attribute_EnteredFontBackColor
  #_Attribute_SelectedFontColor
  #_Attribute_SelectedFontBackColor
  
  #_Attribute_LineColor
  #_Attribute_LineFrameColor
  #_Attribute_GradientTopColor
  #_Attribute_GradientBottomColor
  
  #_Attribute_FirstGadget       ; Gets/Sets the Gadget number of the first Gadget.
  #_Attribute_SecondGadget      ; Gets/Sets the Gadget number of the second Gadget.
  #_Attribute_FirstMinimumSize  ; Gets/Sets the minimum Size (in pixels) than the first Gadget can have.
  #_Attribute_SecondMinimumSize ; Gets/Sets the minimum Size (in pixels) than the second Gadget can have.
  
EndEnumeration

; Combined With one of the following value: 
EnumerationBinary Event ; Event
  #_Event_Create : #_Event_Size : #_Event_Move : #_Event_Drawing
  #_Event_MouseEnter : #_Event_MouseMove : #_Event_MouseWheel : #_Event_MouseLeave
  #_Event_LeftDoubleClick : #_Event_LeftButtonDown : #_Event_LeftButtonUp : #_Event_LeftClick 
  #_Event_RightDoubleClick : #_Event_RightButtonDown : #_Event_RightButtonUp : #_Event_RightClick 
  #_Event_MiddleDoubleClick : #_Event_MiddleButtonDown : #_Event_MiddleButtonUp : #_Event_MiddleClick
  #_Event_Focus : #_Event_LostFocus : #_Event_Change : #_Event_StatusChange
  #_Event_Free : #_Event_Close : #_Event_Maximize : #_Event_Minimize : #_Event_Restore 
  #_Event_KeyDown : #_Event_KeyUp : #_Event_Input : #_Event_Repaint
  #_Event_Up
  #_Event_Down
  #_Event_Item
  #_Event_Menu
  #_Event_MoveBegin : #_Event_SizeBegin : #_Event_MoveEnd : #_Event_SizeEnd
  #_Event_Interact : #_Event_CloseItem : #_Event_SizeItem
  
  #_Event_CreateApp
  #_Event_FreeApp
EndEnumeration

Enumeration 
  #E_TitleGadget
  
  #E_CloseGadget
  #E_MaximizeGadget
  #E_MinimizeGadget
  
  #E_HelpGadget  
EndEnumeration


;}


Structure S_POINT
  *X
  *Y
  *iX
  *iY
  *Left
  *Top
EndStructure

Structure S_SIZE Extends S_POINT
  *Width
  *Height
  *iWidth
  *iHeight
  *Right
  *Bottom
EndStructure

Structure S_COORDINATES Extends S_SIZE : EndStructure

Structure S_TEXT Extends S_SIZE
  Repaint.b
  
  Drawing$
  String$
  *Mode
  *PosX
  *PosY
  
  Left$
  Selected$
  Right$
  ChangeString$
EndStructure

Structure S_IMAGE Extends S_SIZE
  *Ico
  *Image
  *Image1 
  *Image2 
  *ImgBg
EndStructure


Structure S_ENTERED
  *Element
  Caption.b
  
  LeftTop.b
  Left.b
  LeftBottom.b
  
  Top.b
  
  RightTop.b
  Right.b
  RightBottom.b
  
  Bottom.b
EndStructure

Structure S_SPLITTER
  
  FirstFixed.i
  SecondFixed.i
  StatePercent.f
  
  Pos.i
  Max.i
  Size.i
  SizeFirstFixed.i
  SizeSecondFixed.i
  
  FirstElement.i
  SecondElement.i
  FirstMinimumSize.i
  SecondMinimumSize.i
EndStructure

Structure S_SCROLL
  Element.i
  Vert.i
  Horz.i
  
  Pos.i
  PosY.i
  PosX.i
  
  Min.i
  Max.i
  ThumbPos.f
  ThumbSize.f
  PageLength.i
  
  Area.i
  ButtonSize.i
  ScrollStep.i
  Increment.f
  
  *DeltaPos
  *Size
  *State
  ;*Position
EndStructure

Structure S_SPIN
  Value.f
  Decimals.b ; Сколько нулей после точки
  Min.f
  Max.f
  Increment.f
EndStructure

Structure S_BIND
  Event.q
  
  *Element
  *Desktop
  *Window
  *Parent
  *Gadget
  *Item
  *Menu
  *ToolBar
  *PopupMenu
  *StatusBar
  
  List *CallBack()
  Chr.c
  *Key
  *Data
  ModifiersKey.q
  *WheelDelta
EndStructure

Structure S_ELEMENT
  
  *Widget
  *Gadget
  *Window
  *Container
  
  *Parent.S_ELEMENT
  *Active.S_ELEMENT
  *Focus.S_ELEMENT
  *Check.S_ELEMENT
  
EndStructure

Structure S_PARENT Extends S_SIZE
  
  *Item
  *Element
  *Gadget
  *Window
  ;   *Container
  ;   
  ;   *Parent.S_ELEMENT
  ;   *Active.S_ELEMENT
  ;   *Focus.S_ELEMENT
  ;   *Check.S_ELEMENT
  
  FrameCoordinate.S_COORDINATES 
  InnerCoordinate.S_COORDINATES
  
  WindowCoordinate.S_POINT
  ContainerCoordinate.S_POINT
EndStructure

Structure S_ITEM Extends S_COORDINATES
  
  Text.S_TEXT
  *Type
  *State ;
  *Change;
  *Active; 
  *Element
  *Parent
  *Child
  *PopupParent
  
  Entered.S_ENTERED
  Checked.S_ENTERED
  Selected.S_ENTERED
  
  IsBar.b
  IsVertical.b
  
  Img.S_IMAGE 
  
EndStructure

Structure S_LINKED ; Extends S_COORDINATES
  *Type
  *Element
  *Parent
  
  Area.S_COORDINATES
EndStructure

Structure S_EditingMode
  EditingMode.b
  
  
  Window$
  Parent$
  
  Class$
  Type$;[55]
  X$
  Y$
  Width$
  Height$
  Caption$
  Param1$
  Param2$
  Param3$
  Flag$
  ParentID$
  OwnerID$
EndStructure


Structure S_CREATE_ELEMENT Extends S_COORDINATES
  Class$
  Flags$
  Events$
  EditingMode.b
  *DeltaX; X-координаты мыши в момент шелчка на элементе (координаты относительно элемента)
  *DeltaY; Y-координаты мыши в момент шелчка на элементе (координаты относительно элемента)
         ;NewElement.S_EditingMode ; В режиме редактирования
  *Param1
  *Param2
  *Param3
  
  FirstColumWidth.i
  Date.i
  CallBack.i
  Shortcut.i
  
  *Blink
  *FixCaretPos
  *CaretPos
  *CursorLength ; Selected text length ; Выбранная длина текста
  *CursorColor
  *Selected1
  *TextPos
  
  
  *CaretPosMoved
  *CaretPosFixed
  *IsTextSelected
  ;Text\Selected.S
  
  *OptionGroup
  *Radius
  
  Sticky.b
  Parent.S_Parent   ;
  Spin.S_SPIN
  
  *Count 
  *Counts
  *CountType
  *FocusGadget
  
  *Event
  *Element ; Идентификатор нарисованого гаджета
  *Window
  
  *ElementID
  *WindowID
  *ParentID
  
  ;*Gadget
  ;*Container
  *Type ; Тип рисующего гаджета (кнопка, картинка, поле ввода и т.д.)
  *MouseX ; Горизонтальная позиция мыши на гаджете
  *MouseY ; Вертикальная позиция мыши на гаджете
  
  *Childrens ; Здесь будем хранить количество детей
  BeginSize.b
  BeginMove.b
  
  Text.S_TEXT; Текст на гаджете
  Title.s    ; Текст в зоголовке
  
  Hide.b ; Если равен #False гаджет видень
  Disable.b   ; Если равен #False гаджет доступень
  
  Interact.b
  InteractState.b
  
  IsAlign.b
  IsVertical.b
  IsContainer.b ; Является ли элемент контейнером (если это рабочий стол (-2) если это окно (-1) если это контейнер (1) иначе (0))
  
  
  *Data
  Show.b
  
  Linked.S_LINKED
  
  Splitter.S_SPLITTER
  Scroll.S_SCROLL
  Bind.S_BIND
  ToolTip.S_TEXT
  Selected.S_ENTERED ;
  Entered.S_ENTERED  ;
  
  *FontID
  
  ;{ - Цвета
  FontColor.i ; 
  BackColor.i ; Цвет фона
  
  *BackImage
  *FrameColor; Цвет рамки (например вокруг гаджета)
  
  *LineBackColor ; 
  *LineFrameColor;
  
  *EnteredBackColor ; 
  *SelectedBackColor; 
  *EnteredFrameColor; 
  *SelectedFrameColor ; 
  
  *FontBackColor ; 
  *EnteredFontColor ;
  *EnteredFontBackColor ;
  *SelectedFontColor    ; 
  *SelectedFontBackColor; 
  
  ; GradientColor
  *TopColor   ; Верхный цвет градиента 
  *BottomColor; Нижний цвет градиента
              ;}
  
  ;{ - Координаты
  bSize.b
  BorderSize.b
  
  *CaptionHeight
  *MenuHeight
  *ToolBarHeight
  *StatusBarHeight
  *ComboHeight
  
  FrameCoordinate.S_COORDINATES 
  InnerCoordinate.S_COORDINATES
  
  WindowCoordinate.S_POINT
  ContainerCoordinate.S_POINT
  
  Maximize.S_COORDINATES
  Minimize.S_COORDINATES
  DefaultCoordinate.S_COORDINATES
  ;}
  
  ; State
  *State ; = #_State_Default,#_State_Entered,#_State_Selected,#_State_Focused 
  Toggle.b ; 
  Checked.b
  ThreeState.b
  Inbetween.b
  
  HideState.b 
  DisableState.b 
  MaximizeState.b
  MinimizeState.b
  FontColorState.b
  BackColorState.b
  WindowState.i
  
  *OpenList ;
  *CloseList;
  
  *Repaint
  
  Flag.q ;
  
  
  
  
  
  
  Img.S_IMAGE 
  *DrawingMode 
  
  
  Item.S_ITEM
  Map iID.i()
  Map iHandle.i()
  List Items.S_CREATE_ELEMENT()
  
  Column.S_ITEM
  Map cID.i()
  Map cHandle.i()
  List Columns.S_CREATE_ELEMENT()
  
  List Childs.S_CREATE_ELEMENT()
EndStructure


Structure S_SELECTOR Extends S_COORDINATES
  Color.i
EndStructure


Structure S_GLOBAL
  SideDirection.b ; 
  DragElementType.i
  Flag.q
  Selector.S_SELECTOR 
  MultiSelect.b
  Redraw.S_COORDINATES
  
  *Desktop
  *LinePosition
  *EnterItem
  
  Popup.b ; Then called popup menu return true
  *PopupElement ; The called popup menu
  
  *Sticky
  *StickyWindow
  
  *CreateElement
  *CreateWindowElement
  *CreateGadgetElement
  *CreateMenuElement
  *CreateToolBarElement
  *CreatePopupMenuElement
  *CreateStatusBarElement
  
  *Canvas ; Идентификатор полотна где рисуются гаджеты
  *CanvasWindow
  *Parent ; 
  *Window ; 
  *Element;
  *MainWindow
  
  ;*LastElement ; Идентификатор последнего созданного элемента
  
  *TabHeight
  *MenuHeight
  *ColumnHeight
  *ToolBarHeight
  *CaptionHeight
  
  *Count ; Общее количество элементов для функции IsElement()
  *MouseX; Горизонтальная позиция мыши на холсте
  *MouseY; Вертикальная позиция мыши на холсте
  *DeltaX; X-координаты мыши в момент шелчка на элементе (координаты относительно элемента)
  *DeltaY; Y-координаты мыши в момент шелчка на элементе (координаты относительно элемента)
  *Buttons ; Состояние кнопки мыши при перемещении курсора
  
  *BackColor ; Фон холста
  *BackImage
  
  *ActiveElement ; Последный активированный элемент (Это не может быть и меню,тульбар и т.д.)
  *ActiveWindow  ; Последный активированный элемент (Это не может быть и меню,тульбар и т.д.)
  *ActiveGadget  ; Последный активированный элемент (Это не может быть и меню,тульбар и т.д.)
  *ForegroundWindow
  
  *CheckedElement  ; Элемент над которым произвели шелчок 
  *FocusElement    ; Элемент с которым работают на данный момент (Это может быть и меню,тульбар и т.д.)
  
  
  Linked.S_LINKED
  Bind.S_BIND
  Item.S_ITEM ; for panel
  ToolTip.S_TEXT
  
  Map eID.i()
  Map eHandle.i()
  
  ;   Map iID.i()
  ;   Map iHandle.i()
  Map ImagePuch.S()
  
  List This.S_CREATE_ELEMENT()
  ;List CopyElement.S_CREATE_ELEMENT()
  
EndStructure


Global Steps = 5, Drag, AnChor =- 1 

Global *CreateElement.S_GLOBAL
*CreateElement = AllocateMemory(SizeOf(S_GLOBAL)) 
InitializeStructure(*CreateElement, S_GLOBAL)

Macro InitializeElements(Struct)
  Global *CreateElement.S_GLOBAL
  *CreateElement = AllocateMemory(SizeOf(Struct)) 
  InitializeStructure(*CreateElement, Struct)
EndMacro

;- 
;Global NewMap *ElementData()

; 11:09:16
; ;Debug SizeOf(S_GLOBAL) ; 240
; ;Debug SizeOf(S_CREATE_ELEMENT) ; 911

;;- Procedures - PRIVATE
;;- Procedures - PRIVATE
;- INCLUDES

Procedure DrawMultiText(X, Y, Text$, FontColor = $FFFFFF, BackColor = 0, Flags = 0, Width = 0, Height = 0)
  Protected Text_X, Text_Y
  Protected TxtHeight = TextHeight("A")
  Protected Is_Vcenter.b, Is_Hcenter.b, Is_Right.b, Is_Bottom.b
  Protected String.s, String1.s, String2.s, String3.s, CountString, IT, Start, Count, Break_Y
  ;Protected Time = ElapsedMilliseconds()
  If Width = 0 : Width = OutputWidth() : EndIf
  If Height = 0 : Height = OutputHeight() : EndIf
  
  ; Перевести разрывы строк
  Text$ = ReplaceString(Text$, #LFCR$, #LF$)
  Text$ = ReplaceString(Text$, #CRLF$, #LF$)
  Text$ = ReplaceString(Text$, #CR$, #LF$)
  
  ;
  CountString = CountString(Text$, #LF$)
  
  Is_Right = Bool((Flags & #_Flag_Text_Right) = #_Flag_Text_Right)
  Is_Bottom = Bool((Flags & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)  
  Is_Vcenter = Bool((Flags & #_Flag_Text_VCenter) = #_Flag_Text_VCenter)
  Is_Hcenter = Bool((Flags & #_Flag_Text_HCenter) = #_Flag_Text_HCenter)  
  
  If Bool((Flags & #_Flag_Text_Center) = #_Flag_Text_Center)
    If Bool(((Flags & #_Flag_Text_Top) = #_Flag_Text_Top) Or Is_Bottom) : Is_Hcenter = #False : EndIf
    If Bool(((Flags & #_Flag_Text_Left) = #_Flag_Text_Left) Or Is_Right) : Is_Vcenter = #False : EndIf
  EndIf
  
  If CountString
    ; make multi Text$ 
    For IT = 1 To CountString : Start = 1
      String = StringField(Text$, IT, #LF$)
      Count = CountString(String, " ") + Start
      
      Repeat
        String1 = StringField(String, Start, " ")
        
        While (Count> = Start) : Start+1
          String2 = StringField(String, Start, " ")
          
          If (TextWidth(Trim(String1+" "+String2)) < (Width-Len(Mid(String2,Len(String2)))))
            String1 = (String1+" "+String2)
          Else
            Break
          EndIf
        Wend
        
        String3+String1+#LF$
      Until (Start>Count)
    Next
    
    CountString = CountString(String3, #LF$)
    
    If CountString
      If Is_Hcenter : Text_Y = ((Height-(TxtHeight*CountString))/2) 
        ElseIf Is_Bottom : Text_Y = (Height-(TxtHeight*CountString)) : EndIf
      
      ; Text$ тратить
      For IT = 1 To CountString
        String1 = StringField(String3, IT, #LF$)
        
        If Is_Vcenter : Text_X = ((Width-TextWidth(String1))/2) 
          ElseIf Is_Right : Text_X = (Width-TextWidth(String1)) : EndIf
        DrawText(X+Text_X, Y+Text_Y, String1, FontColor, BackColor)
        
        Text_Y+TxtHeight
        If Text_Y > (Height-TxtHeight)
          Break
        EndIf
      Next
    EndIf
    
  Else
    If Is_Hcenter : Text_Y = ((Height-TxtHeight)/2) 
      ElseIf Is_Bottom : Text_Y = (Height-TxtHeight) : EndIf
    If Is_Vcenter : Text_X = ((Width-TextWidth(Text$))/2) 
      ElseIf Is_Right : Text_X = (Width-TextWidth(Text$)) : EndIf
    DrawText(X+Text_X, Y+Text_Y, Text$, FontColor, BackColor)
  EndIf
  
  ;Debug "Time "+Str(Time-ElapsedMilliseconds())
  
  ProcedureReturn CountString
  
EndProcedure





;-
;- DECLARES
Declare UpdateDrawingContent()
Declare AvtoResizeElement(List This.S_CREATE_ELEMENT(), Element, Parent, MenuHeight = 0)

Declare OpenWindowElement(Element,X,Y,Width,Height, Title.S = "", Flag.q = #_Flag_ScreenCentered|#_Flag_SystemMenu, Parent =- 1)
Declare DrawListIconElementContent(List This.S_CREATE_ELEMENT(), X,Y)
Declare SpinElement( Element, X,Y,Width,Height, Min.f, Max.f, Flag.q = 0, Parent =- 1, Increment$ = "1", Radius = 0 )
Declare StringElement( Element, X,Y,Width,Height, Text.S = "", Flag.q = 0, Parent =- 1, Radius = 0 )
Declare SetAnchors(Element, Reset.b = #True)
Declare DrawToolTip(List This.S_CREATE_ELEMENT())
Declare DrawAnchors(List This.S_CREATE_ELEMENT())
Declare UpdateScrolls(List This.S_CREATE_ELEMENT())
Declare IsElement(Element)
Declare ElementType(Element)
Declare GetElementParent(Element)
Declare GetElementWindow(Element)
Declare DrawingElement(List This.S_CREATE_ELEMENT(), X = 0,Y = 0 );Type, X,Y,Width,Height,Text$ = "", Flag.q = 0, Param1 =- 1,Param2 =- 1,Param3 =- 1)
Declare GetElementData(Element)
;Declare.q AdressElement(Element)
Declare FreeElement(Element)
Declare SetCursorElement(Cursor)
Declare AddElementItem(Element, Position, Text$, Image =- 1, Flag.q = 0)
Declare ElementCallBack(Event.q, EventElement)
Declare ElementDrawCallBack(EventElement, Show.b=#False)
;Declare ElementItemCallBack(Event.q, EventElement, EventElementItem)
Declare ResizeElement( Element, X,Y,Width,Height, Flag.q = #_Element_ContainerCoordinate)
;Declare.b IsChildElement(Element, Parent)
Declare SetElementPosition(Element, Position, Element2 =- 1)

Declare.S GetElementText(Element)
Declare.S EventClass(EventType.q)

Declare.q PostEventElement(Event.q, Element, Item =- 1, *Data = #Null)
Declare.q BindEventElement(*CallBack, ElementWindow = #PB_All, ElementGadget = #PB_All, Event.q = #PB_All)
Declare.q UnbindEventElement(*CallBack, ElementWindow = #PB_All, ElementGadget = #PB_All, Event.q = #PB_All)
Declare.f SetElementState(Element, State.f)
Declare.f GetElementState(Element)
Declare OpenElementList(Element =- 1, Item =- 1)
Declare CloseElementList(Element =- 1)
Declare SetElementParent(Element, Parent, ParentItem = 0)
Declare RemoveElementFlag(Element, Flag.q)
Declare.q SetElementFlag(Element, Flag.q)

Declare MenuElementHeight(MenuElement = #PB_Default)
Declare ToolBarElementHeight(ToolBarElement = #PB_Default)
Declare StatusBarElementHeight(StatusBarElement = #PB_Default)


Declare SplitterElementCallBack(Event.q)
Declare DrawSplitterElementItemsContent(List This.S_CREATE_ELEMENT())
Declare SetSplitterElementState(List This.S_CREATE_ELEMENT(), State)
Declare GetSplitterElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
Declare SetSplitterElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)

Declare SetPanelElementState(List This.S_CREATE_ELEMENT(), State)
Declare DrawPanelElementItemsContent(List This.S_CREATE_ELEMENT())
Declare AddPanelElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)

Declare.q SetOpenWindowElementFlag(Flag.q)
Declare.q GetOpenWindowElementFlag(Flag.q)
Declare DrawOpenWindowElementItemsContent(List This.S_CREATE_ELEMENT())

Declare.q SetContainerElementFlag(Flag.q)
Declare.q GetContainerElementFlag(Flag.q)

Declare.q SetSplitterElementFlag(Flag.q)
Declare.q GetSplitterElementFlag(Flag.q)

; ComboBox
Declare.q SetComboBoxElementFlag(Flag.q)
Declare.q GetComboBoxElementFlag(Flag.q)
Declare SetComboBoxElementState(List This.S_CREATE_ELEMENT(), State)
Declare DrawComboBoxElementItemsContent(List This.S_CREATE_ELEMENT())
Declare AddComboBoxElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
Declare ComboBoxElement( Element, X,Y,Width,Height, Flag.q = 0, Parent =- 1, Radius = 0 )

Declare CreatePopupMenuElement(MenuElement = #PB_Any)
Declare DisplayPopupMenuElement(MenuElement, Parent = #PB_Any, X = #PB_Ignore, Y = #PB_Ignore)

Declare DrawSpinElementItemsContent(List This.S_CREATE_ELEMENT())

Declare DrawScrollAreaElementItemsContent(List This.S_CREATE_ELEMENT())
Declare GetScrollAreaElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
Declare SetScrollAreaElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)

Declare SetScrollBarElementState(State)
Declare GetScrollBarElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
Declare SetScrollBarElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)

Declare DrawScrollBarElementItemsContent(List This.S_CREATE_ELEMENT())
Declare ScrollBarElementCallBack(Event.q, EventElement, EventElementItem)


Declare SetTrackBarElementState(State)
Declare TrackBarElementCallBack(Event.q, EventElement, EventElementItem)
Declare DrawTrackBarElementItemsContent(List This.S_CREATE_ELEMENT())

Declare ContainerElement(Element, X,Y,Width,Height, Flag.q = #_Flag_Flat, Parent =- 1)
Declare ScrollBarElement( Element, X,Y,Width,Height, Min, Max, PageLength, Flag.q = 0, Parent =- 1, Radius = 0 )


Declare SetSpinElementState(State.f)
Declare DrawingSpinElementContent(List This.S_CREATE_ELEMENT())
Declare SpinElementCallBack(Event.q, EventElement, EventElementItem)

Declare DrawListViewElementItemsContent(List This.S_CREATE_ELEMENT(), ItemElement, X,Y)
Declare DrawPopupMenuElementItemsContent(List This.S_CREATE_ELEMENT(), ItemElement, X,Y)

Declare SetPropertiesElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)

Declare AddListIconElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
Declare ListIconElement( Element, X,Y,Width,Height, FirstColumnTitle$, FirstColumnWidth, Flag.q = 0, Parent =- 1 )

Declare SplitterElement( Element, X,Y,Width,Height, Element1, Element2, Flag.q = 0, Parent =- 1, Radius = 0 )
Declare AddListViewElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
Declare ListViewElement( Element, X,Y,Width,Height, Title.S = "", Flag.q = 0, Parent =- 1 )
Declare.q GetElementFlag(Element)

Declare ResizeElementX(List This.S_CREATE_ELEMENT(), X = #PB_Ignore)
Declare ResizeElementY(List This.S_CREATE_ELEMENT(), Y = #PB_Ignore)

Declare OpenSubMenuElement(Text$, Image =- 1)
Declare CloseSubMenuElement()
Declare MenuElementBar()

;-
;- MACROS
;Distance entres deux points (2D)
; ; ; Procedure.d Distance(*p.Point, *q.Point, Radius)
; ; ;   Protected Distance.d, dx.d, dy.d
; ; ;   
; ; ; ;   ;Distance horizontale
; ; ; ;   dx = *p\x - (*q\x+Radius)   
; ; ; ;   
; ; ; ;   ;Distance verticale
; ; ; ;   dy = *p\y - (*q\y+Radius)
; ; ; ;   
; ; ; ;   ;Théoréme de Pythagore
; ; ; ;   Distance = Bool(Sqr(dx*dx + dy*dy) =< Radius)
; ; ;   
; ; ;   Distance = Bool(Sqr(Pow(((*q\x+Radius) - *p\x),2) + Pow(((*q\y+Radius) - *p\y),2)) =< Radius)
; ; ;   
; ; ;   ProcedureReturn Distance
; ; ; EndProcedure

Macro Distance(MousePoint, PositionPoint, Radius)
  Bool(Sqr(Pow(((PositionPoint\x+Radius) - MousePoint\x),2) + Pow(((PositionPoint\y+Radius) - MousePoint\y),2)) =< Radius)
EndMacro

Macro RemoveMapElement(This) ; Ok
  DeleteMapElement(*CreateElement\eID(), Str(@This))
  DeleteMapElement(*CreateElement\eHandle(), Str(This\Element))
  DeleteElement(This, 1) 
EndMacro


Macro Max(a, b)
  ((a) * Bool((a) > = (b)) + (b) * Bool((b) > (a)))
EndMacro
Macro Min(a, b)
  ((a) * Bool((a) < = (b)) + (b) * Bool((b) < (a)))
EndMacro
Macro SetBit(Var, Bit) ; Установка бита.
  Var | (Bit)
EndMacro
Macro ClearBit(Var, Bit) ; Обнуление бита.
  Var & (~(Bit))
EndMacro
Macro InvertBit(Var, Bit) ; Инвертирование бита.
  Var ! (Bit)
EndMacro
Macro TestBit(Var, Bit) ; Проверка бита (#True - установлен; #False - обнулен).
  Bool(Var & (Bit))
EndMacro
Macro NumToBit(Num) ; Позиция бита по его номеру.
  (1<<(Num))
EndMacro
Macro GetBits(Var, StartPos, EndPos)
  ((Var>>(StartPos))&(NumToBit((EndPos)-(StartPos)+1)-1))
EndMacro
Macro CheckFlag(Mask, Flag)
  ((Mask & Flag) = Flag)
EndMacro

; val = %10011110
; Debug Bin(GetBits(val, 0, 3))

; Procedure ElementID(Element) 
;   Protected Result
;   
;   With *CreateElement
;     If Bool(ListSize(\This())) 
;       Result = \eHandle(Str(Element)) 
;     EndIf 
;   EndWith
;   
;   ProcedureReturn Result
; EndProcedure

;-
Macro IDElement(ElementID) : *CreateElement\eID(Str(ElementID)) : EndMacro
Macro ElementID(Element) : *CreateElement\eHandle(Str(Element)) : EndMacro
Macro IsElement(Element) : Bool(ListSize(*CreateElement\This()) And ElementID(Element)) : EndMacro

; Macro IDItem(ItemID) : *CreateElement\iID(Str(ItemID)) : EndMacro
; Macro ItemID(Item) : *CreateElement\iHandle(Str(Item)) : EndMacro
; Macro IsElementItem(Item) : Bool(ListSize(*CreateElement\This()\Items()) And ItemID(Item)) : EndMacro

Macro IDItem(ItemID) : *CreateElement\This()\iID(Str(ItemID)) : EndMacro
Macro ItemID(Item) : *CreateElement\This()\iHandle(Str(Item)) : EndMacro
Macro IsElementItem(Item) : Bool(ListSize(*CreateElement\This()\Items()) And ItemID(Item)) : EndMacro

Macro IDColumn(ColumnID) : *CreateElement\cID(Str(ColumnID)) : EndMacro
Macro ColumnID(Column) : *CreateElement\This()\cHandle(Str(Column)) : EndMacro
Macro IsElementColumn(Column) : Bool(ListSize(*CreateElement\This()\Columns()) And ColumnID(Column)) : EndMacro

Macro IsMainWindowElement(Element) : Bool(*CreateElement\MainWindow = Element) : EndMacro

Macro IsActiveElement(Element) : Bool(*CreateElement\ActiveElement = Element) : EndMacro
Macro IsActiveGadgetElement(Element) : Bool(*CreateElement\ActiveGadget = Element) : EndMacro
Macro IsActiveWindowElement(Element) : Bool(*CreateElement\ActiveWindow = Element) : EndMacro
Macro IsForegroundWindowElement(Element) : Bool(*CreateElement\ForegroundWindow = Element) : EndMacro

Macro GetActiveElement() : *CreateElement\ActiveElement : EndMacro
Macro GetActiveGadgetElement() : *CreateElement\ActiveGadget : EndMacro
Macro GetActiveWindowElement() : *CreateElement\ActiveWindow : EndMacro
Macro GetForegroundWindowElement() : *CreateElement\ForegroundWindow : EndMacro

Macro EventElement() : *CreateElement\Bind\Element : EndMacro
Macro EventElementItem() : *CreateElement\Bind\Item : EndMacro
Macro EventElementData() : *CreateElement\Bind\Data : EndMacro
Macro EventElementParent() : *CreateElement\Bind\Parent : EndMacro

Macro GetButtons() : *CreateElement\Buttons : EndMacro
Macro GetMouseX() : *CreateElement\MouseX : EndMacro
Macro GetMouseY() : *CreateElement\MouseY : EndMacro

Macro GetDeltaX() : *CreateElement\DeltaX : EndMacro
Macro GetDeltaY() : *CreateElement\DeltaY : EndMacro

Macro GetMouseDeltaX() : (*CreateElement\MouseX-*CreateElement\DeltaX) : EndMacro
Macro GetMouseDeltaY() : (*CreateElement\MouseY-*CreateElement\DeltaY) : EndMacro

Macro EventDesktopElement() : *CreateElement\Bind\Desktop : EndMacro
Macro EventWindowElement() : *CreateElement\Bind\Window : EndMacro
Macro EventGadgetElement() : *CreateElement\Bind\Gadget : EndMacro
;Macro EventMenuElement() : *CreateElement\Bind\Menu : EndMacro
;Macro EventToolBarElement() : *CreateElement\Bind\ToolBar : EndMacro
Macro EventStatusBarElement() : *CreateElement\Bind\StatusBar : EndMacro

Macro EventMenuElement() : EventElementItem() : EndMacro
Macro EventToolBarElement() : EventElementItem() : EndMacro

Macro ElementEvent() : *CreateElement\Bind\Event : EndMacro
Macro ElementEventKey() : *CreateElement\Bind\Key : EndMacro
Macro ElementEventData() : *CreateElement\Bind\Data : EndMacro
Macro ElementEventButton() : *CreateElement\Buttons : EndMacro
Macro ElementEventModifiersKey() : *CreateElement\Bind\ModifiersKey : EndMacro

Macro ElementDeltaX() : *CreateElement\DeltaX : EndMacro
Macro ElementDeltaY() : *CreateElement\DeltaY : EndMacro

Macro ElementMouseDeltaX() : (*CreateElement\MouseX-*CreateElement\DeltaX) : EndMacro
Macro ElementMouseDeltaY() : (*CreateElement\MouseY-*CreateElement\DeltaY) : EndMacro

Macro WindowElement() : *CreateElement\CreateWindowElement : EndMacro
Macro GadgetElement() : *CreateElement\CreateGadgetElement : EndMacro

Macro CurrentElement(Element) : ChangeCurrentElement(*CreateElement\This(), ElementID(Element)) : EndMacro

Macro CaptionHeight() : *CreateElement\CaptionHeight : EndMacro 
Macro BeginDrawing() : Bool(IsGadget(*CreateElement\Canvas) And StartDrawing(CanvasOutput(*CreateElement\Canvas))) : EndMacro
Macro EndDrawing() : Bool(StopDrawing()) : EndMacro

;- 
; FUNCTIONS
Procedure.s Eng(RusSlovo.S)
  Protected Simvol
  Protected RusskieBukvi.s = "а:б:в:г:д:е:ё:ж:з:и:й:к:л:м:н:о:п:р:с:т:у:ф:х:ц:ч:ш:щ:ъ:ы:ь:э:ю:я:А:Б:В:Г:Д:Е:Ё:Ж:З:И:Й:К:Л:М:Н:О:П:Р:С:Т:У:Ф:Х:Ц:Ч:Ш:Щ:Ъ:Ы:Ь:Э:Ю:Я"
  Protected AngliyyskieBukvi.s = "a:b:v:g:d:e:yo:g:z:i:y:k:l:m:n:o:p:r:s:t:u:ph:h:ts:ch:sh:sh:`:i:':e:yu:ya:A:B:V:G:D:E:Yo:G:Z:I:Y:K:L:M:N:O:P:R:S:T:U:Ph:H:Ts:Ch:Sh:Sh:`:I:':E:Yu:Ya"
  
  For Simvol = 1 To 66
    RusSlovo = ReplaceString(RusSlovo, StringField(RusskieBukvi, Simvol, ":"), StringField(AngliyyskieBukvi,Simvol, ":"))
  Next 
  
  ProcedureReturn RusSlovo
EndProcedure

Procedure CheckedElement(Element =- 1)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element) 
      \CheckedElement = Element 
    EndIf
    
    Result = \CheckedElement
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
Procedure CustomCursor(Image,X = 0,Y = 0)
  If IsImage( Image )
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        Protected Cursor.ICONINFO
        Cursor\fIcon = 0
        Cursor\xHotspot = X 
        Cursor\yHotspot = Y 
        Cursor\hbmMask = ImageID(Image)
        Cursor\hbmColor = ImageID(Image)
        Protected hCursor = CreateIconIndirect_(Cursor)
        
        ProcedureReturn hCursor
      CompilerCase #PB_OS_Linux
        Protected *Cursor.GdkCursor = gdk_cursor_new_from_pixbuf_(gdk_display_get_default_(),ImageID(Image),X,Y)
        
        ProcedureReturn *Cursor
    CompilerEndSelect
  EndIf
EndProcedure  

Procedure SetElementCustomCursor(Image = #PB_Default)
  Protected Result
  
  With *CreateElement
    
    If IsGadget(\Canvas) 
      If IsImage(Image)
        SetGadgetAttribute(\Canvas, #PB_Canvas_CustomCursor, CustomCursor(Image)) 
      Else
        SetGadgetAttribute(\Canvas, #PB_Canvas_Cursor, #PB_Cursor_Default) 
      EndIf
    EndIf
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetCursorElement(*Cursor)
  Static Cursor
  
  With *CreateElement
    If (\DragElementType = 0 And Cursor <> *Cursor) : Cursor = *Cursor
      If IsGadget(\Canvas) 
        SetGadgetAttribute(\Canvas, #PB_Canvas_Cursor, *Cursor) 
      EndIf
    EndIf
  EndWith
  
  ProcedureReturn Cursor
EndProcedure

Procedure GetElementCursor()
  Protected Result
  
  With *CreateElement
    
    If IsGadget(\Canvas) : Result = GetGadgetAttribute(\Canvas, #PB_Canvas_Cursor) : EndIf
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Declare.S ElementClass(ElementType)
;-
Procedure.b IsBindElement(Element) ; Ok
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Result = Bool(ListSize(\This()\Bind\CallBack())>0)
      PopListPosition(\This()) 
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsHideElement(Element) ; Ok
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Debug ElementClass(\This()\Type)
      Result = \This()\Hide
      PopListPosition(\This()) 
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsChildElement(Element, Parent)
  Protected Result.b, ParentElement =- 1
  
  With *CreateElement
    If (IsElement(Parent) And IsElement(Element))
      ParentElement = Element
      
      PushListPosition(\This()) 
      Repeat
        If ParentElement = Parent 
          Result = #True
          Break
        EndIf
        
        ChangeCurrentElement(\This(), ElementID(ParentElement))
        ParentElement = \This()\Parent\Element
      Until ParentElement =- 1
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsStickyElement(Element) ; Ok
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Result = \This()\Sticky
      PopListPosition(\This()) 
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsDisableElement(Element) ; Ok
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Result = \This()\Disable
      PopListPosition(\This()) 
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsContainerElement(Element) ; Ok
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Result = \This()\IsContainer
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsElementChildrens(Element, Item =- 1) ; Ok
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      If Item =- 1
        ForEach \This()
          If \This()\Parent\Element = Element And \This()\Parent\Item = Item
            Result = #True
            Break
          EndIf
        Next
      Else
        ChangeCurrentElement(\This(), *Element)
        Result = Bool(\This()\Childrens<>0)
      EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure.b IsMenuElement(Element)
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If \This()\Type = #_Type_Menu
        Result = #True
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsGadgetElement(Element)
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      Select \This()\Type
        Case #_Type_PopupMenu, 
             #_Type_Unknown, 
             #_Type_Desktop,
             #_Type_Window,
             #_Type_Menu,
             #_Type_Toolbar,
             #_Type_StatusBar
        Default
          Result = #True
      EndSelect
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsToolbarElement(Element)
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If \This()\Type = #_Type_Toolbar
        Result = #True
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsWindowElement(Element)
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If \This()\Type = #_Type_Window
        Result = #True
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsDesktopElement(Element)
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      Select \This()\Type
        Case #_Type_Desktop
          Result = #True
      EndSelect
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsStatusBarElement(Element)
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If \This()\Type = #_Type_StatusBar
        Result = #True
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.b IsPopupMenuElement(Element)
  Protected Result.b, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If \This()\Type = #_Type_PopupMenu
        Result = #True
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure



;-
Procedure Type(Class.S) ;Returns gadget type from gadget name
  
  If     FindString(Class.S, LCase("Desktop")       ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Desktop
  ElseIf FindString(Class.S, LCase("PopupMenu")     ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_PopupMenu
  ElseIf FindString(Class.S, LCase("Toolbar")       ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Toolbar
  ElseIf FindString(Class.S, LCase("Menu")          ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Menu
  ElseIf FindString(Class.S, LCase("Status")        ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_StatusBar
  ElseIf FindString(Class.S, LCase("Window")        ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Window
  ElseIf FindString(Class.S, LCase("ButtonImage")   ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ButtonImage
  ElseIf FindString(Class.S, LCase("String")        ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_String
  ElseIf FindString(Class.S, LCase("Text")         ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Text
  ElseIf FindString(Class.S, LCase("CheckBox")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_CheckBox
  ElseIf FindString(Class.S, LCase("Option")        ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Option
  ElseIf FindString(Class.S, LCase("ListView")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ListView
  ElseIf FindString(Class.S, LCase("Frame")         ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Frame  
  ElseIf FindString(Class.S, LCase("ComboBox")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ComboBox
  ElseIf FindString(Class.S, LCase("Image")         ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Image
  ElseIf FindString(Class.S, LCase("HyperLink")     ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_HyperLink
  ElseIf FindString(Class.S, LCase("Container")     ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Container
  ElseIf FindString(Class.S, LCase("ListIcon")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ListIcon
  ElseIf FindString(Class.S, LCase("IPAddress")     ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_IPAddress
  ElseIf FindString(Class.S, LCase("ProgressBar")   ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ProgressBar
  ElseIf FindString(Class.S, LCase("ScrollBar")     ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ScrollBar
  ElseIf FindString(Class.S, LCase("ScrollArea")    ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ScrollArea
  ElseIf FindString(Class.S, LCase("TrackBar")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_TrackBar
  ElseIf FindString(Class.S, LCase("Web")           ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Web
  ElseIf FindString(Class.S, LCase("Button")        ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Button
  ElseIf FindString(Class.S, LCase("Calendar")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Calendar
  ElseIf FindString(Class.S, LCase("Date")          ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Date
  ElseIf FindString(Class.S, LCase("Editor")        ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Editor
  ElseIf FindString(Class.S, LCase("ExplorerList")  ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ExplorerList
  ElseIf FindString(Class.S, LCase("ExplorerTree")  ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ExplorerTree
  ElseIf FindString(Class.S, LCase("ExplorerCombo") ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_ExplorerCombo
  ElseIf FindString(Class.S, LCase("Spin")          ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Spin
  ElseIf FindString(Class.S, LCase("Tree")          ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Tree
  ElseIf FindString(Class.S, LCase("Panel")         ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Panel
  ElseIf FindString(Class.S, LCase("Splitter")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Splitter
  ElseIf FindString(Class.S, LCase("MDI")           ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_MDI
  ElseIf FindString(Class.S, LCase("Scintilla")     ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Scintilla
  ElseIf FindString(Class.S, LCase("Shortcut")      ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Shortcut
  ElseIf FindString(Class.S, LCase("Canvas")        ,-1,#PB_String_NoCase) :ProcedureReturn #_Type_Canvas
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure.q Flag(Class.S) ;Returns gadget type from gadget name
  Protected Result.q
  
  ;{- Ok
  If     FindString(Class.S, LCase("SystemMenu")      ,-1,#PB_String_NoCase) : Result | #_Flag_SystemMenu 
  ElseIf FindString(Class.S, LCase("MaximizeGadget")      ,-1,#PB_String_NoCase) : Result | #_Flag_MaximizeGadget
  ElseIf FindString(Class.S, LCase("MinimizeGadget")      ,-1,#PB_String_NoCase) : Result | #_Flag_MinimizeGadget
  ElseIf FindString(Class.S, LCase("Minimize")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_Minimize
  ElseIf FindString(Class.S, LCase("Maximize")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_Maximize
  ElseIf FindString(Class.S, LCase("SizeGadget")      ,-1,#PB_String_NoCase) : Result | #_Flag_SizeGadget
  ElseIf FindString(Class.S, LCase("ScreenCentered")      ,-1,#PB_String_NoCase) : Result | #_Flag_ScreenCentered
  ElseIf FindString(Class.S, LCase("WindowCentered")      ,-1,#PB_String_NoCase) : Result | #_Flag_WindowCentered
  ElseIf FindString(Class.S, LCase("BorderLess")      ,-1,#PB_String_NoCase) : Result | #_Flag_BorderLess
  ElseIf FindString(Class.S, LCase("Border")      ,-1,#PB_String_NoCase) 
    
    If Class.S = "#PB_Text_Border"
      Result | #_Flag_Double
    Else
      Result | #_Flag_Border
    EndIf
    
  ElseIf FindString(Class.S, LCase("Flat")      ,-1,#PB_String_NoCase) : Result | #_Flag_Flat
  ElseIf FindString(Class.S, LCase("Raised")      ,-1,#PB_String_NoCase) : Result | #_Flag_Raised
  ElseIf FindString(Class.S, LCase("Single")      ,-1,#PB_String_NoCase) : Result | #_Flag_Single
  ElseIf FindString(Class.S, LCase("Double")      ,-1,#PB_String_NoCase) : Result | #_Flag_Double
  ElseIf FindString(Class.S, LCase("Invisible")      ,-1,#PB_String_NoCase) : Result | #_Flag_Invisible
  ElseIf FindString(Class.S, LCase("Normal")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_Normal
  ElseIf FindString(Class.S, LCase("TitleBar")      ,-1,#PB_String_NoCase) : Result | #_Flag_TitleBar
  ElseIf FindString(Class.S, LCase("Tool")      ,-1,#PB_String_NoCase) : Result | #_Flag_Tool
  ElseIf FindString(Class.S, LCase("NoActivate")      ,-1,#PB_String_NoCase) : Result | #_Flag_NoActivate
  ElseIf FindString(Class.S, LCase("NoGadgets")      ,-1,#PB_String_NoCase) : Result | #_Flag_NoGadgets
  ElseIf FindString(Class.S, LCase("MultiLine")      ,-1,#PB_String_NoCase) : Result | #_Flag_MultiLine
  ElseIf FindString(Class.S, LCase("Default")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_Default
  ElseIf FindString(Class.S, LCase("Toggle")      ,-1,#PB_String_NoCase) : Result | #_Flag_Toggle
  ElseIf FindString(Class.S, LCase("Numeric")      ,-1,#PB_String_NoCase) : Result | #_Flag_Numeric
  ElseIf FindString(Class.S, LCase("Password")      ,-1,#PB_String_NoCase) : Result | #_Flag_Password
  ElseIf FindString(Class.S, LCase("LowerCase")      ,-1,#PB_String_NoCase) : Result | #_Flag_LowerCase
  ElseIf FindString(Class.S, LCase("UpperCase")      ,-1,#PB_String_NoCase) : Result | #_Flag_UpperCase
    
  ElseIf FindString(Class.S, LCase("Left")      ,-1,#PB_String_NoCase) : Result | #_Flag_Text_Left
  ElseIf FindString(Class.S, LCase("Right")      ,-1,#PB_String_NoCase) : Result | #_Flag_Text_Right
  ElseIf FindString(Class.S, LCase("Center")      ,-1,#PB_String_NoCase) : Result | #_Flag_Text_VCenter
    
  ElseIf FindString(Class.S, LCase("Editable")      ,-1,#PB_String_NoCase) : Result | #_Flag_Editable
  ElseIf FindString(Class.S, LCase("Image")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("Underline")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("GridLines")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("Smooth")      ,-1,#PB_String_NoCase)    ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("Ticks")      ,-1,#PB_String_NoCase)     ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("UpDown")      ,-1,#PB_String_NoCase)    ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("ReadOnly")      ,-1,#PB_String_NoCase) : Result | #_Flag_ReadOnly
  ElseIf FindString(Class.S, LCase("WordWrap")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("ClickSelect")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("MultiSelect")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("HeaderDragDrop")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("FullRowSelect")      ,-1,#PB_String_NoCase)  ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoFiles")      ,-1,#PB_String_NoCase)        ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoFolders")      ,-1,#PB_String_NoCase)      ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoParentFolder")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoDirectoryChange")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoDriveRequester")      ,-1,#PB_String_NoCase)  ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoSort")      ,-1,#PB_String_NoCase)            ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoMyDocuments")      ,-1,#PB_String_NoCase)     ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("AutoSort")      ,-1,#PB_String_NoCase)          ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("HiddenFiles")      ,-1,#PB_String_NoCase)       ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("AlwaysShowSelection")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoLines")      ,-1,#PB_String_NoCase)             ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("NoButtons")      ,-1,#PB_String_NoCase)           ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("CheckBoxes")      ,-1,#PB_String_NoCase) : Result | #_Flag_CheckBoxes
  ElseIf FindString(Class.S, LCase("ThreeState")      ,-1,#PB_String_NoCase) : Result | #_Flag_ThreeState
  ElseIf FindString(Class.S, LCase("Vertical")      ,-1,#PB_String_NoCase) : Result | #_Flag_Vertical
  ElseIf FindString(Class.S, LCase("Separator")      ,-1,#PB_String_NoCase) : Result | #_Flag_Separator
  ElseIf FindString(Class.S, LCase("FirstFixed")      ,-1,#PB_String_NoCase) : Result | #_Flag_FirstFixed
  ElseIf FindString(Class.S, LCase("SecondFixed")      ,-1,#PB_String_NoCase) : Result | #_Flag_SecondFixed
  ElseIf FindString(Class.S, LCase("ClipMouse")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("Keyboard")      ,-1,#PB_String_NoCase)  ;: Result | #_Flag_
  ElseIf FindString(Class.S, LCase("DrawFocus")      ,-1,#PB_String_NoCase) ;: Result | #_Flag_
  EndIf
  ;}
  
  ProcedureReturn Result
EndProcedure


Procedure.S GetFlagClass(FlagType.q, Type$ = "")
  Protected Result.S
  
  If ((FlagType & #_Flag_TitleBar) = #_Flag_TitleBar) 
    Result.S + "|" +Type$+ "TitleBar"
  EndIf
  If ((FlagType & #_Flag_HelpGadget) = #_Flag_HelpGadget) 
    Result.S + "|" +Type$+ "HelpGadget"
  EndIf
  If ((FlagType & #_Flag_MinimizeGadget) = #_Flag_MinimizeGadget) 
    Result.S + "|" +Type$+ "MinimizeGadget"
  EndIf
  If ((FlagType & #_Flag_MaximizeGadget) = #_Flag_MaximizeGadget) 
    Result.S + "|" +Type$+ "MaximizeGadget"
  EndIf
  If ((FlagType & #_Flag_CloseGadget) = #_Flag_CloseGadget) 
    Result.S + "|" +Type$+ "CloseGadget"
  EndIf
  
  If ((FlagType & #_Flag_Tool) = #_Flag_Tool) 
    Result.S + "|" +Type$+ "Tool"
  EndIf
  If ((FlagType & #_Flag_NoGadgets) = #_Flag_NoGadgets) 
    Result.S + "|" +Type$+ "NoGadgets"
  EndIf
  
  If ((FlagType & #_Flag_MoveGadget) = #_Flag_MoveGadget) 
    Result.S + "|" +Type$+ "MoveGadget"
  EndIf
  If ((FlagType & #_Flag_SizeGadget) = #_Flag_SizeGadget) 
    Result.S + "|" +Type$+ "SizeGadget"
  EndIf
  
  If ((FlagType & #_Flag_WindowCentered) = #_Flag_WindowCentered) 
    Result.S + "|" +Type$+ "WindowCentered"
  EndIf
  If ((FlagType & #_Flag_ScreenCentered) = #_Flag_ScreenCentered) 
    Result.S + "|" +Type$+ "ScreenCentered"
  EndIf
  
  If ((FlagType & #_Flag_NoActivate) = #_Flag_NoActivate) 
    Result.S + "|" +Type$+ "NoActivate"
  EndIf
  If ((FlagType & #_Flag_Invisible) = #_Flag_Invisible) 
    Result.S + "|" +Type$+ "Invisible"
  EndIf
  
  If ((FlagType & #_Flag_FirstFixed) = #_Flag_FirstFixed) 
    Result.S + "|" +Type$+ "FirstFixed"
  EndIf
  If ((FlagType & #_Flag_SecondFixed) = #_Flag_SecondFixed) 
    Result.S + "|" +Type$+ "SecondFixed"
  EndIf
  If ((FlagType & #_Flag_Separator) = #_Flag_Separator) 
    Result.S + "|" +Type$+ "Separator"
  EndIf
  If ((FlagType & #_Flag_Separator_Circle) = #_Flag_Separator_Circle) 
    Result.S + "|" +Type$+ "Separator_Circle"
  EndIf
  
  If ((FlagType & #_Flag_BorderLess) = #_Flag_BorderLess) 
    Result.S + "|" +Type$+ "BorderLess"
  EndIf
  If ((FlagType & #_Flag_Border) = #_Flag_Border) 
    Result.S + "|" +Type$+ "Border"
  EndIf
  If ((FlagType & #_Flag_Flat) = #_Flag_Flat) 
    Result.S + "|" +Type$+ "Flat"
  EndIf
  If ((FlagType & #_Flag_Raised) = #_Flag_Raised) 
    Result.S + "|" +Type$+ "Raised"
  EndIf
  If ((FlagType & #_Flag_Single) = #_Flag_Single) 
    Result.S + "|" +Type$+ "Single"
  EndIf
  If ((FlagType & #_Flag_Double) = #_Flag_Double) 
    Result.S + "|" +Type$+ "Double"
  EndIf
  
  If ((FlagType & #_Flag_Vertical) = #_Flag_Vertical) 
    Result.S + "|" +Type$+ "Vertical"
  EndIf
  If ((FlagType & #_Flag_InlineText) = #_Flag_InlineText) 
    Result.S + "|" +Type$+ "InlineText"
  EndIf
  If ((FlagType & #_Flag_MultiLine) = #_Flag_MultiLine) 
    Result.S + "|" +Type$+ "MultiLine"
  EndIf
  
  If ((FlagType & #_Flag_ReadOnly) = #_Flag_ReadOnly) 
    Result.S + "|" +Type$+ "ReadOnly"
  EndIf
  If ((FlagType & #_Flag_Editable) = #_Flag_Editable) 
    Result.S + "|" +Type$+ "Editable"
  EndIf
  If ((FlagType & #_Flag_Numeric) = #_Flag_Numeric) 
    Result.S + "|" +Type$+ "Numeric"
  EndIf
  If ((FlagType & #_Flag_Password) = #_Flag_Password) 
    Result.S + "|" +Type$+ "Password"
  EndIf
  If ((FlagType & #_Flag_LowerCase) = #_Flag_LowerCase) 
    Result.S + "|" +Type$+ "LowerCase"
  EndIf
  If ((FlagType & #_Flag_UpperCase) = #_Flag_UpperCase) 
    Result.S + "|" +Type$+ "UpperCase"
  EndIf
  
  If ((FlagType & #_Flag_Small) = #_Flag_Small) 
    Result.S + "|" +Type$+ "Small"
  EndIf
  If ((FlagType & #_Flag_Large) = #_Flag_Large) 
    Result.S + "|" +Type$+ "Large"
  EndIf
  If ((FlagType & #_Flag_Mosaic) = #_Flag_Mosaic) 
    Result.S + "|" +Type$+ "Mosaic"
  EndIf
  If ((FlagType & #_Flag_Stretch) = #_Flag_Stretch) 
    Result.S + "|" +Type$+ "Stretch"
  EndIf
  If ((FlagType & #_Flag_Proportionally) = #_Flag_Proportionally) 
    Result.S + "|" +Type$+ "Proportionally"
  EndIf
  
  If ((FlagType & #_Flag_Transparent) = #_Flag_Transparent) 
    Result.S + "|" +Type$+ "Transparent"
  EndIf
  
  If ((FlagType & #_Flag_Anchors) = #_Flag_Anchors) 
    Result.S + "|" +Type$+ "Anchor"
  EndIf
  
  ProcedureReturn Trim(Result.S, "|")
EndProcedure

Procedure.S EventClass(EventType.q)
  Protected Result.S
  
  ; Others
  If ((EventType & #_Event_CreateApp) = #_Event_CreateApp) 
    Result.S + "|" + "CreateApp"
  EndIf
  If ((EventType & #_Event_Create) = #_Event_Create) 
    Result.S + "|" + "Create"
  EndIf
  If ((EventType & #_Event_Maximize) = #_Event_Maximize) 
    Result.S + "|" + "Maximize"
  EndIf
  If ((EventType & #_Event_Minimize) = #_Event_Minimize) 
    Result.S + "|" + "Minimize"
  EndIf
  If ((EventType & #_Event_Restore) = #_Event_Restore) 
    Result.S + "|" + "Restore"
  EndIf
  If ((EventType & #_Event_Close) = #_Event_Close) 
    Result.S + "|" + "Close"
  EndIf
  If ((EventType & #_Event_Free) = #_Event_Free) 
    Result.S + "|" + "Free"
  EndIf
  If ((EventType & #_Event_Change) = #_Event_Change) 
    Result.S + "|" + "Change"
  EndIf
  If ((EventType & #_Event_Move) = #_Event_Move) 
    Result.S + "|" + "Move"
  EndIf
  If ((EventType & #_Event_Size) = #_Event_Size) 
    Result.S + "|" + "Size"
  EndIf
  If ((EventType & #_Event_Drawing) = #_Event_Drawing) 
    Result.S + "|" + "Drawing"
  EndIf
  If ((EventType & #_Event_Interact) = #_Event_Interact) 
    Result.S + "|" + "Interact"
  EndIf
  If ((EventType & #_Event_Repaint) = #_Event_Repaint) 
    Result.S + "|" + "Repaint"
  EndIf
  If ((EventType & #_Event_CloseItem) = #_Event_CloseItem) 
    Result.S + "|" + "CloseItem"
  EndIf
  If ((EventType & #_Event_SizeItem) = #_Event_SizeItem) 
    Result.S + "|" + "SizeItem"
  EndIf
  
  ;Mouse
  If ((EventType & #_Event_MouseMove) = #_Event_MouseMove) 
    Result.S + "|" + "MouseMove"
  EndIf
  If ((EventType & #_Event_MouseEnter) = #_Event_MouseEnter) 
    Result.S + "|" + "MouseEnter"
  EndIf
  If ((EventType & #_Event_MouseLeave) = #_Event_MouseLeave) 
    Result.S + "|" + "MouseLeave"
  EndIf
  If ((EventType & #_Event_MouseWheel) = #_Event_MouseWheel) 
    Result.S + "|" + "MouseWheel"
  EndIf
  
  ; Focus
  If ((EventType & #_Event_Focus) = #_Event_Focus) 
    Result.S + "|" + "Focus"
  EndIf
  If ((EventType & #_Event_LostFocus) = #_Event_LostFocus) 
    Result.S + "|" + "LostFocus"
  EndIf
  
  ; Key
  If ((EventType & #_Event_KeyDown) = #_Event_KeyDown) 
    Result.S + "|" + "KeyDown"
  EndIf
  If ((EventType & #_Event_KeyUp) = #_Event_KeyUp) 
    Result.S + "|" + "KeyUp"
  EndIf
  If ((EventType & #_Event_Input) = #_Event_Input) 
    Result.S + "|" + "Input"
  EndIf
  
  ; LeftButtons
  If ((EventType & #_Event_LeftDoubleClick) = #_Event_LeftDoubleClick) 
    Result.S + "|" + "LeftDoubleClick"
  EndIf
  If ((EventType & #_Event_LeftButtonDown) = #_Event_LeftButtonDown) 
    Result.S + "|" + "LeftButtonDown"
  EndIf
  If ((EventType & #_Event_LeftButtonUp) = #_Event_LeftButtonUp) 
    Result.S + "|" + "LeftButtonUp"
  EndIf
  If ((EventType & #_Event_LeftClick) = #_Event_LeftClick) 
    Result.S + "|" + "LeftClick"
  EndIf
  
  ; RightButtons
  If ((EventType & #_Event_RightDoubleClick) = #_Event_RightDoubleClick) 
    Result.S + "|" + "RightDoubleClick"
  EndIf
  If ((EventType & #_Event_RightButtonDown) = #_Event_RightButtonDown) 
    Result.S + "|" + "RightButtonDown"
  EndIf
  If ((EventType & #_Event_RightButtonUp) = #_Event_RightButtonUp) 
    Result.S + "|" + "RightButtonUp"
  EndIf
  If ((EventType & #_Event_RightClick) = #_Event_RightClick) 
    Result.S + "|" + "RightClick"
  EndIf
  
  ; MiddleButtons
  If ((EventType & #_Event_MiddleDoubleClick) = #_Event_MiddleDoubleClick) 
    Result.S + "|" + "MiddleDoubleClick"
  EndIf
  If ((EventType & #_Event_MiddleButtonDown) = #_Event_MiddleButtonDown) 
    Result.S + "|" + "MiddleButtonDown"
  EndIf
  If ((EventType & #_Event_MiddleButtonUp) = #_Event_MiddleButtonUp) 
    Result.S + "|" + "MiddleButtonUp"
  EndIf
  If ((EventType & #_Event_MiddleClick) = #_Event_MiddleClick) 
    Result.S + "|" + "MiddleClick"
  EndIf
  
  If ((EventType & #_Event_FreeApp) = #_Event_FreeApp) 
    Result.S + "|" + "FreeApp"
  EndIf
  
  ProcedureReturn Trim(Result.S, "|")
EndProcedure

Procedure.S ElementClass(ElementType)
  Protected Result.S
  
  Select ElementType
    Case #_Type_Desktop        : Result.S = "Desktop"
    Case #_Type_StatusBar      : Result.S = "StatusBar"
    Case #_Type_PopupMenu      : Result.S = "PopupMenu"
    Case #_Type_Menu           : Result.S = "Menu"
    Case #_Type_Toolbar        : Result.S = "Toolbar"
    Case #_Type_Window         : Result.S = "Window"
    Case #_Type_Unknown        : Result.S = "Create"
    Case #_Type_Button         : Result.S = "Button"
    Case #_Type_String         : Result.S = "String"
    Case #_Type_Text           : Result.S = "Text"
    Case #_Type_CheckBox       : Result.S = "CheckBox"
    Case #_Type_Option         : Result.S = "Option"
    Case #_Type_ListView       : Result.S = "ListView"
    Case #_Type_Frame          : Result.S = "Frame"
    Case #_Type_ComboBox       : Result.S = "ComboBox"
    Case #_Type_Image          : Result.S = "Image"
    Case #_Type_HyperLink      : Result.S = "HyperLink"
    Case #_Type_Container      : Result.S = "Container"
    Case #_Type_ListIcon       : Result.S = "ListIcon"
    Case #_Type_IPAddress      : Result.S = "IPAddress"
    Case #_Type_ProgressBar    : Result.S = "ProgressBar"
    Case #_Type_ScrollBar      : Result.S = "ScrollBar"
    Case #_Type_ScrollArea     : Result.S = "ScrollArea"
    Case #_Type_TrackBar       : Result.S = "TrackBar"
    Case #_Type_Web            : Result.S = "Web"
    Case #_Type_ButtonImage    : Result.S = "ButtonImage"
    Case #_Type_Calendar       : Result.S = "Calendar"
    Case #_Type_Date           : Result.S = "Date"
    Case #_Type_Editor         : Result.S = "Editor"
    Case #_Type_ExplorerList   : Result.S = "ExplorerList"
    Case #_Type_ExplorerTree   : Result.S = "ExplorerTree"
    Case #_Type_ExplorerCombo  : Result.S = "ExplorerCombo"
    Case #_Type_Spin           : Result.S = "Spin"
    Case #_Type_Tree           : Result.S = "Tree"
    Case #_Type_Panel          : Result.S = "Panel"
    Case #_Type_Splitter       : Result.S = "Splitter"
    Case #_Type_MDI           
    Case #_Type_Scintilla      : Result.S = "Scintilla"
    Case #_Type_Shortcut       : Result.S = "Shortcut"
    Case #_Type_Canvas         : Result.S = "Canvas"
      
    Case #_Type_ImageButton    : Result.S = "ImageButton"
  EndSelect
  
  ProcedureReturn Result.S
EndProcedure

;-
Procedure.S ReadPBFlags( Type )
  Protected Flags.S
  
  Enumeration - 7 ; Type
    #PB_GadgetType_Message
    #PB_GadgetType_PopupMenu
    #PB_GadgetType_Desktop
    #PB_GadgetType_StatusBar
    #PB_GadgetType_Menu           ;  "Menu"
    #PB_GadgetType_Toolbar        ;  "Toolbar"
    #PB_GadgetType_Window         ;  "Window"
  EndEnumeration
  
  #PB_GadgetType_ImageButton = 34
  #PB_GadgetType_StringButton = 35
  #PB_GadgetType_Properties   = 36
  
  Select Type
    Case #PB_GadgetType_Window        
      ;{- Ok
      Flags.S = "#PB_Window_SystemMenu|"+
                "#PB_Window_MaximizeGadget|"+
                "#PB_Window_MinimizeGadget|"+
                "#PB_Window_Minimize|"+
                "#PB_Window_Maximize|"+
                "#PB_Window_SizeGadget|"+
                "#PB_Window_ScreenCentered|"+
                "#PB_Window_WindowCentered|"+
                "#PB_Window_BorderLess|"+
                "#PB_Window_Invisible|"+
                "#PB_Window_Normal|"+
                "#PB_Window_TitleBar|"+
                "#PB_Window_Tool|"+
                "#PB_Window_NoActivate|"+
                "#PB_Window_NoGadgets|"
      ;}
      
    Case #PB_GadgetType_Button         
      ;{- Ok
      Flags.S = "#PB_Button_MultiLine|"+
                "#PB_Button_Default|"+
                "#PB_Button_Toggle|"+
                "#PB_Button_Left|"+
                "#PB_Button_Right"
      ;}
      
    Case #PB_GadgetType_String         
      ;{- Ok
      Flags.S = "#PB_String_Numeric|"+
                "#PB_String_Password|"+
                "#PB_String_ReadOnly|"+
                "#PB_String_LowerCase|"+
                "#PB_String_UpperCase|"+
                "#PB_String_BorderLess" 
      ;}
      
    Case #PB_GadgetType_Text           
      ;{- Ok
      Flags.S = "#PB_Text_Center|"+
                "#PB_Text_Right|"+
                "#PB_Text_Border"
      ;}
      
    Case #PB_GadgetType_CheckBox       
      ;{- Ok
      Flags.S = "#PB_CheckBox_Right|"+
                "#PB_CheckBox_Center|"+
                "#PB_CheckBox_ThreeState"
      ;}
      
    Case #PB_GadgetType_Option         
      Flags.S = ""
      
    Case #PB_GadgetType_ListView       
      ;{- Ok
      Flags.S = "#PB_ListView_Multiselect|"+
                "#PB_ListView_ClickSelect"
      ;}
      
    Case #PB_GadgetType_Frame          
      ;{- Ok
      Flags.S = "#PB_Frame_Single|"+
                "#PB_Frame_Double|"+
                "#PB_Frame_Flat"
      ;}
      
    Case #PB_GadgetType_ComboBox       
      ;{- Ok
      Flags.S = "#PB_ComboBox_Editable|"+
                "#PB_ComboBox_LowerCase|"+
                "#PB_ComboBox_UpperCase|"+
                "#PB_ComboBox_Image"
      ;}
      
    Case #PB_GadgetType_Image          
      ;{- Ok
      Flags.S = "#PB_Image_Border|"+
                "#PB_Image_Raised"
      ;}
      
    Case #PB_GadgetType_HyperLink      
      ;{- Ok
      Flags.S = "#PB_Hyperlink_Underline"
      ;}
      
    Case #PB_GadgetType_Container      
      ;{- Ok
      Flags.S = "#PB_Container_BorderLess|"+
                "#PB_Container_Flat|"+
                "#PB_Container_Raised|"+
                "#PB_Container_Single|"+
                "#PB_Container_Double"
      ;}
      
    Case #PB_GadgetType_ListIcon       
      ;{- Ok
      Flags.S = "#PB_ListIcon_CheckBoxes|"+
                "#PB_ListIcon_ThreeState|"+
                "#PB_ListIcon_MultiSelect|"+
                "#PB_ListIcon_GridLines|"+
                "#PB_ListIcon_FullRowSelect|"+
                "#PB_ListIcon_HeaderDragDrop|"+
                "#PB_ListIcon_AlwaysShowSelection"
      ;}
      
    Case #PB_GadgetType_IPAddress      
      Flags.S = ""
      
    Case #PB_GadgetType_ProgressBar    
      ;{- Ok
      Flags.S = "#PB_ProgressBar_Smooth|"+
                "#PB_ProgressBar_Vertical"
      ;}
      
    Case #PB_GadgetType_ScrollBar      
      ;{- Ok
      Flags.S = "#PB_ScrollBar_Vertical"
      ;}
      
    Case #PB_GadgetType_ScrollArea     
      ;{- Ok
      Flags.S = "#PB_ScrollArea_Flat|"+
                "#PB_ScrollArea_Raised|"+
                "#PB_ScrollArea_Single|"+
                "#PB_ScrollArea_BorderLess|"+
                "#PB_ScrollArea_Center"
      ;}
      
    Case #PB_GadgetType_TrackBar       
      ;{- Ok
      Flags.S = "#PB_TrackBar_Ticks|"+
                "#PB_TrackBar_Vertical"
      ;}
      
    Case #PB_GadgetType_Web            
      Flags.S = ""
      
    Case #PB_GadgetType_ButtonImage    
      ;{- Ok
      Flags.S = "#PB_Button_Toggle"
      ;}
      
    Case #PB_GadgetType_Calendar       
      ;{- Ok
      Flags.S = "#PB_Calendar_Borderless"
      ;}
      
    Case #PB_GadgetType_Date           
      ;{- Ok
      Flags.S = "#PB_Date_UpDown"
      ;}
      
    Case #PB_GadgetType_Editor         
      ;{- Ok
      Flags.S = "#PB_Editor_ReadOnly|"+
                "#PB_Editor_WordWrap"
      ;}
      
    Case #PB_GadgetType_ExplorerList   
      ;{- Ok
      Flags.S = "#PB_Explorer_BorderLess|"+
                "#PB_Explorer_AlwaysShowSelection|"+
                "#PB_Explorer_MultiSelect|"+
                "#PB_Explorer_GridLines|"+
                "#PB_Explorer_HeaderDragDrop|"+
                "#PB_Explorer_FullRowSelect|"+
                "#PB_Explorer_NoFiles|"+
                "#PB_Explorer_NoFolders|"+
                "#PB_Explorer_NoParentFolder|"+
                "#PB_Explorer_NoDirectoryChange|"+
                "#PB_Explorer_NoDriveRequester|"+
                "#PB_Explorer_NoSort|"+
                "#PB_Explorer_NoMyDocuments|"+
                "#PB_Explorer_AutoSort|"+
                "#PB_Explorer_HiddenFiles"
      ;}
      
    Case #PB_GadgetType_ExplorerTree   
      Flags.S = ""
      
    Case #PB_GadgetType_ExplorerCombo  
      Flags.S = ""
      
    Case #PB_GadgetType_Spin           
      Flags.S = ""
      
    Case #PB_GadgetType_Tree           
      ;{- Ok
      Flags.S = "#PB_Tree_AlwaysShowSelection|"+
                "#PB_Tree_NoLines|"+
                "#PB_Tree_NoButtons|"+
                "#PB_Tree_CheckBoxes|"+
                "#PB_Tree_ThreeState"
      ;}
      
    Case #PB_GadgetType_Panel          
      Flags.S = ""
      
    Case #PB_GadgetType_Splitter       
      ;{- Ok
      Flags.S = "#PB_Splitter_Vertical|"+
                "#PB_Splitter_Separator|"+
                "#PB_Splitter_FirstFixed|"+
                "#PB_Splitter_SecondFixed" 
      ;}
      
    Case #PB_GadgetType_MDI           
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Flags.S = ""
      CompilerEndIf
      
    Case #PB_GadgetType_Scintilla      
      Flags.S = ""
      
    Case #PB_GadgetType_Shortcut       
      Flags.S = ""
      
    Case #PB_GadgetType_Canvas 
      ;{- Ok
      Flags.S = "#PB_Canvas_Border|"+
                "#PB_Canvas_ClipMouse|"+
                "#PB_Canvas_Keyboard|"+
                "#PB_Canvas_DrawFocus"
      ;}
      
  EndSelect
  
  ProcedureReturn Flags.S
  ; ProcedureReturn "#PB_Flag_None|"+Flags.S
EndProcedure

Procedure.S ReadPBEvents( Type )
  Protected Events.S
  
  Enumeration - 7 ; Type
    #PB_GadgetType_Message
    #PB_GadgetType_PopupMenu
    #PB_GadgetType_Desktop
    #PB_GadgetType_StatusBar
    #PB_GadgetType_Menu           ;  "Menu"
    #PB_GadgetType_Toolbar        ;  "Toolbar"
    #PB_GadgetType_Window         ;  "Window"
  EndEnumeration
  
  #PB_GadgetType_ImageButton = 34
  #PB_GadgetType_StringButton = 35
  #PB_GadgetType_Properties   = 36
  
  Select Type
    Case #PB_GadgetType_Window        :Events.S =  "#PB_Event_None|"+
                                                   "#PB_Event_ActivateWindow|"+
                                                   "#PB_Event_DeactivateWindow|"+
                                                   "#PB_Event_Repaint|"+
                                                   "#PB_Event_SizeWindow|"+
                                                   "#PB_Event_MoveWindow|"+
                                                   "#PB_Event_LeftClick|"+
                                                   "#PB_Event_RightClick|"+
                                                   "#PB_Event_LeftDoubleClick|"+
                                                   "#PB_Event_MinimizeWindow|"+
                                                   "#PB_Event_MaximizeWindow|"+
                                                   "#PB_Event_CloseWindow|"+
                                                   "#PB_Event_RestoreWindow|"+
                                                   "#PB_Event_Timer|"+
                                                   "#PB_Event_SysTray|"+
                                                   "#PB_Event_Menu|"+
                                                   "#PB_Event_Gadget|"+
                                                   "#PB_Event_GadgetDrop|"+
                                                   "#PB_Event_WindowDrop"
      
    Case #PB_GadgetType_Button         :Events.S =  "#PB_EventType_LeftClick"
    Case #PB_GadgetType_String         :Events.S =  "#PB_EventType_Change|"+
                                                    "#PB_EventType_Focus|"+
                                                    "#PB_EventType_LostFocus"
      
    Case #PB_GadgetType_Text           :Events.S =  "TextGadget"
    Case #PB_GadgetType_CheckBox       :Events.S =  "CheckBoxGadget"
    Case #PB_GadgetType_Option         :Events.S =  "OptionGadget"
    Case #PB_GadgetType_ListView       :Events.S =  "#PB_EventType_LeftClick|"+
                                                    "#PB_EventType_LeftDoubleClick|"+
                                                    "#PB_EventType_RightClick"
      
    Case #PB_GadgetType_Frame          :Events.S =  "FrameGadget"
    Case #PB_GadgetType_ComboBox       :Events.S =  "#PB_EventType_Change|"+
                                                    "#PB_EventType_Focus|"+
                                                    "#PB_EventType_LostFocus"
      
    Case #PB_GadgetType_Image          :Events.S =  "#PB_EventType_LeftClick|"+
                                                    "#PB_EventType_RightClick|"+
                                                    "#PB_EventType_LeftDoubleClick|"+
                                                    "#PB_EventType_RightDoubleClick|"+
                                                    "#PB_EventType_DragStart"
      
    Case #PB_GadgetType_HyperLink      :Events.S =  "HyperLinkGadget"
    Case #PB_GadgetType_Container      :Events.S =  "ContainerGadget"
    Case #PB_GadgetType_ListIcon       :Events.S =  "#PB_EventType_LeftClick|"+
                                                    "#PB_EventType_LeftDoubleClick|"+
                                                    "#PB_EventType_RightClick|"+
                                                    "#PB_EventType_RightDoubleClick|"+
                                                    "#PB_EventType_Change|"+
                                                    "#PB_EventType_DragStart"
      
    Case #PB_GadgetType_IPAddress      :Events.S =  "IPAddressGadget"
    Case #PB_GadgetType_ProgressBar    :Events.S =  "ProgressBarGadget"
    Case #PB_GadgetType_ScrollBar      :Events.S =  "ScrollBarGadget"
    Case #PB_GadgetType_ScrollArea     :Events.S =  "ScrollAreaGadget"
    Case #PB_GadgetType_TrackBar       :Events.S =  "TrackBarGadget"
    Case #PB_GadgetType_Web            :Events.S =  "WebGadget"
    Case #PB_GadgetType_ButtonImage    :Events.S =  "ButtonImageGadget"
    Case #PB_GadgetType_Calendar       :Events.S =  "CalendarGadget"
    Case #PB_GadgetType_Date           :Events.S =  "DateGadget"
    Case #PB_GadgetType_Editor         :Events.S =  "EditorGadget"
    Case #PB_GadgetType_ExplorerList   :Events.S =  "ExplorerListGadget"
    Case #PB_GadgetType_ExplorerTree   :Events.S =  "ExplorerTreeGadget"
    Case #PB_GadgetType_ExplorerCombo  :Events.S =  "ExplorerComboGadget"
    Case #PB_GadgetType_Spin           :Events.S =  "SpinGadget"
    Case #PB_GadgetType_Tree           :Events.S =  "#PB_EventType_Change|"+
                                                    "#PB_EventType_LeftClick|"+
                                                    "#PB_EventType_LeftDoubleClick|"+
                                                    "#PB_EventType_RightClick|"+
                                                    "#PB_EventType_RightDoubleClick|"+
                                                    "#PB_EventType_DragStart"
      
    Case #PB_GadgetType_Panel          :Events.S =  "PanelGadget"
    Case #PB_GadgetType_Splitter       :Events.S =  "SplitterGadget"
    Case #PB_GadgetType_MDI           
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Events.S =  "MDIGadget"
      CompilerEndIf
    Case #PB_GadgetType_Scintilla      :Events.S =  "#PB_EventType_RightClick"
    Case #PB_GadgetType_Shortcut       :Events.S =  "ShortcutGadget"
    Case #PB_GadgetType_Canvas         :Events.S =  "#PB_EventType_MouseEnter|"+
                                                    "#PB_EventType_MouseLeave|"+
                                                    "#PB_EventType_MouseMove |"+
                                                    "#PB_EventType_MouseWheel|"+
                                                    "#PB_EventType_LeftButtonDown|"+
                                                    "#PB_EventType_LeftButtonUp|"+
                                                    "#PB_EventType_LeftClick |"+
                                                    "#PB_EventType_LeftDoubleClick |"+
                                                    "#PB_EventType_RightButtonDown |"+
                                                    "#PB_EventType_RightButtonUp|"+
                                                    "#PB_EventType_RightClick |"+
                                                    "#PB_EventType_RightDoubleClick|"+
                                                    "#PB_EventType_MiddleButtonDown|"+
                                                    "#PB_EventType_MiddleButtonUp|"+
                                                    "#PB_EventType_Focus |"+
                                                    "#PB_EventType_LostFocus|"+ 
                                                    "#PB_EventType_KeyDown|"+
                                                    "#PB_EventType_KeyUp |"+
                                                    "#PB_EventType_Input"
      
  EndSelect
  
  If Type
    ProcedureReturn "#PB_Event_None|"+Events.S
  Else
    ProcedureReturn Events.S
  EndIf
EndProcedure

Procedure SetElementClass(Element, Class$)
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      \This()\Class$ = Class$
      
      PopListPosition(\This())
    EndIf
  EndWith
  
EndProcedure

Procedure.S GetElementClass(Element)
  Protected Result.S
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\Class$
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result.S
EndProcedure

Procedure SetElementEvents(Element, Events$)
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If Events$
        If FindString(\This()\Events$, LCase(Events$)      ,-1,#PB_String_NoCase) = 0
          \This()\Events$ +"|"+ Events$
        EndIf
      Else
        \This()\Events$ = ""
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
EndProcedure

Procedure.S GetElementEvents(Element)
  Protected Result.S
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = Trim(\This()\Events$, "|")
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result.S
EndProcedure

Procedure SetElementFlags(Element, Flags$)
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If Flags$
        If FindString(\This()\Flags$, LCase(Flags$)      ,-1,#PB_String_NoCase) = 0
          \This()\Flags$ +"|"+ Flags$
        EndIf
      Else
        \This()\Flags$ = ""
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
EndProcedure

Procedure.S GetElementFlags(Element)
  Protected Result.S
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = Trim(\This()\Flags$, "|")
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result.S
EndProcedure


Procedure.S GetPBTypes(Type)
  Protected Type$
  
  Select Type 
    Case #_Type_Desktop        : Type$ = "#PB_Desktop_"
    Case #_Type_StatusBar      : Type$ = "#PB_StatusBar_"
    Case #_Type_PopupMenu      : Type$ = "#PB_PopupMenu_"
    Case #_Type_Menu           : Type$ = "#PB_Menu_"
    Case #_Type_Toolbar        : Type$ = "#PB_Toolbar_"
    Case #_Type_Window         : Type$ = "#PB_Window_"
    Case #_Type_Unknown        : Type$ = "#PB_Create_"
    Case #_Type_Button         : Type$ = "#PB_Button_"
    Case #_Type_String         : Type$ = "#PB_String_"
    Case #_Type_Text           : Type$ = "#PB_Text_"
    Case #_Type_CheckBox       : Type$ = "#PB_CheckBox_"
    Case #_Type_Option         : Type$ = "#PB_Option_"
    Case #_Type_ListView       : Type$ = "#PB_ListView_"
    Case #_Type_Frame          : Type$ = "#PB_Frame_"
    Case #_Type_ComboBox       : Type$ = "#PB_ComboBox_"
    Case #_Type_Image          : Type$ = "#PB_Image_"
    Case #_Type_HyperLink      : Type$ = "#PB_HyperLink_"
    Case #_Type_Container      : Type$ = "#PB_Container_"
    Case #_Type_ListIcon       : Type$ = "#PB_ListIcon_"
    Case #_Type_IPAddress      : Type$ = "#PB_IPAddress_"
    Case #_Type_ProgressBar    : Type$ = "#PB_ProgressBar_"
    Case #_Type_ScrollBar      : Type$ = "#PB_ScrollBar_"
    Case #_Type_ScrollArea     : Type$ = "#PB_ScrollArea_"
    Case #_Type_TrackBar       : Type$ = "#PB_TrackBar_"
    Case #_Type_Web            : Type$ = "#PB_Web_"
    Case #_Type_ButtonImage    : Type$ = "#PB_ButtonImage_"
    Case #_Type_Calendar       : Type$ = "#PB_Calendar_"
    Case #_Type_Date           : Type$ = "#PB_Date_"
    Case #_Type_Editor         : Type$ = "#PB_Editor_"
    Case #_Type_ExplorerList   : Type$ = "#PB_ExplorerList_"
    Case #_Type_ExplorerTree   : Type$ = "#PB_ExplorerTree_"
    Case #_Type_ExplorerCombo  : Type$ = "#PB_ExplorerCombo_"
    Case #_Type_Spin           : Type$ = "#PB_Spin_"
    Case #_Type_Tree           : Type$ = "#PB_Tree_"
    Case #_Type_Panel          : Type$ = "#PB_Panel_"
    Case #_Type_Splitter       : Type$ = "#PB_Splitter_"
    Case #_Type_MDI            : Type$ = "#PB_MDI_"
    Case #_Type_Scintilla      : Type$ = "#PB_Scintilla_"
    Case #_Type_Shortcut       : Type$ = "#PB_Shortcut_"
    Case #_Type_Canvas         : Type$ = "#PB_Canvas_"
      
    Case #_Type_ImageButton    : Type$ = "#PB_ImageButton_"
      
  EndSelect
  
  ProcedureReturn Type$
EndProcedure

Procedure.S GetPBEvents(Type)
  Protected Result$
  
  Select Type
    Case #_Type_Window
      Result$ = "#PB_Event_WindowClose|"+
                "#PB_Event_LeftClick|"+
                "#PB_Event_RightClick|"+
                "#PB_Event_WindowSize|"+
                "#PB_Event_WindowMove"
      
  EndSelect
  
  ProcedureReturn Result$
EndProcedure


Procedure.S GetPBFlags(FlagType.q, Type = 0)
  Protected Type$, Result.S
  
  ; Type$ = GetPBTypes(Type)
  
  Select Type 
    Case #_Type_Desktop        : Type$ = "#PB_Desktop_"
    Case #_Type_StatusBar      : Type$ = "#PB_StatusBar_"
    Case #_Type_PopupMenu      : Type$ = "#PB_PopupMenu_"
    Case #_Type_Menu           : Type$ = "#PB_Menu_"
    Case #_Type_Toolbar        : Type$ = "#PB_Toolbar_"
    Case #_Type_Window         : Type$ = "#PB_Window_"
      If ((FlagType & #_Flag_HelpGadget) = #_Flag_HelpGadget) 
        Result.S + "|" +Type$+ "HelpGadget"
      EndIf
      If ((FlagType & #_Flag_MinimizeGadget) = #_Flag_MinimizeGadget) 
        Result.S + "|" +Type$+ "MinimizeGadget"
      EndIf
      If ((FlagType & #_Flag_MaximizeGadget) = #_Flag_MaximizeGadget) 
        Result.S + "|" +Type$+ "MaximizeGadget"
      EndIf
      
      If ((FlagType & #_Flag_CloseGadget) = #_Flag_CloseGadget) 
        Result.S + "|" +Type$+ "SystemMenu"
      Else
        If ((FlagType & #_Flag_TitleBar) = #_Flag_TitleBar) 
          Result.S + "|" +Type$+ "TitleBar"
        EndIf
      EndIf
      
      If ((FlagType & #_Flag_Tool) = #_Flag_Tool) 
        Result.S + "|" +Type$+ "Tool"
      EndIf
      If ((FlagType & #_Flag_NoGadgets) = #_Flag_NoGadgets) 
        Result.S + "|" +Type$+ "NoGadgets"
      EndIf
      
      If ((FlagType & #_Flag_SizeGadget) = #_Flag_SizeGadget) 
        Result.S + "|" +Type$+ "SizeGadget"
      EndIf
      
      If ((FlagType & #_Flag_WindowCentered) = #_Flag_WindowCentered) 
        Result.S + "|" +Type$+ "WindowCentered"
      EndIf
      If ((FlagType & #_Flag_ScreenCentered) = #_Flag_ScreenCentered) 
        Result.S + "|" +Type$+ "ScreenCentered"
      EndIf
      
      If ((FlagType & #_Flag_NoActivate) = #_Flag_NoActivate) 
        Result.S + "|" +Type$+ "NoActivate"
      EndIf
      If ((FlagType & #_Flag_Invisible) = #_Flag_Invisible) 
        Result.S + "|" +Type$+ "Invisible"
      EndIf
      If ((FlagType & #_Flag_BorderLess) = #_Flag_BorderLess) 
        Result.S + "|" +Type$+ "BorderLess"
      EndIf
      
    Case #_Type_Unknown        : Type$ = "#PB_Create_"
    Case #_Type_Button         : Type$ = "#PB_Button_"
      If ((FlagType & #_Flag_Text_Right) = #_Flag_Text_Right) 
        Result.S + "|" +Type$+ "Right" ; Aligns the button Text at the right. (Not supported on Mac OSX)
      EndIf
      If ((FlagType & #_Flag_Text_Left) = #_Flag_Text_Left) 
        Result.S + "|" +Type$+ "Left" ; Aligns the button Text at the left. (Not supported on Mac OSX)
      EndIf
      If ((FlagType & #_Flag_MultiLine) = #_Flag_MultiLine) 
        Result.S + "|" +Type$+ "MultiLine" ; If the Text is too long, it will be displayed on several lines. (Not supported on OSX)
      EndIf
      If ((FlagType & #_Flag_Toggle) = #_Flag_Toggle) 
        Result.S + "|" +Type$+ "Toggle" ; Creates a toggle button: one Click pushes it, another will release it.
      EndIf
      
      ; #PB_Button_Default   ; Makes the button look As If it is the Default button in the Window (on OS X, the Height of the button needs To be 25).
      
    Case #_Type_String         : Type$ = "#PB_String_"
      If ((FlagType & #_Flag_Numeric) = #_Flag_Numeric) 
        Result.S + "|" +Type$+ "Numeric" ; Only (positive) integer numbers are accepted.
      EndIf
      If ((FlagType & #_Flag_Password) = #_Flag_Password) 
        Result.S + "|" +Type$+ "Password" ; Password mode, displaying only '*' instead of normal characters.
      EndIf
      If ((FlagType & #_Flag_ReadOnly) = #_Flag_ReadOnly) 
        Result.S + "|" +Type$+ "ReadOnly" ; Read-only mode. No Text can be entered.
      EndIf
      If ((FlagType & #_Flag_LowerCase) = #_Flag_LowerCase) 
        Result.S + "|" +Type$+ "LowerCase" ; All characters are converted To lower Case automatically.
      EndIf
      If ((FlagType & #_Flag_UpperCase) = #_Flag_UpperCase) 
        Result.S + "|" +Type$+ "UpperCase" ; All characters are converted To upper Case automatically.
      EndIf
      If ((FlagType & #_Flag_BorderLess) = #_Flag_BorderLess) 
        Result.S + "|" +Type$+ "BorderLess" ; No borders are drawn around the Gadget.
      EndIf
      
    Case #_Type_Text           : Type$ = "#PB_Text_"
      If ((FlagType & #_Flag_Text_Center) = #_Flag_Text_Center) 
        Result.S + "|" +Type$+ "Center" ; The Text is centered in the Gadget.
      EndIf
      If ((FlagType & #_Flag_Text_Right) = #_Flag_Text_Right) 
        Result.S + "|" +Type$+ "Right" ; The Text is right aligned.
      EndIf
      If ((FlagType & #_Flag_Border) = #_Flag_Border) 
        Result.S + "|" +Type$+ "Border" ; A sunken border is drawn around the Gadget.
      EndIf
      
    Case #_Type_CheckBox       : Type$ = "#PB_CheckBox_"
      If ((FlagType & #_Flag_Text_Center) = #_Flag_Text_Center) 
        Result.S + "|" +Type$+ "Center"  ; Centers the Text.
      EndIf
      If ((FlagType & #_Flag_Text_Right) = #_Flag_Text_Right) 
        Result.S + "|" +Type$+ "Right"  ; Aligns the Text To right.
      EndIf
      
      ; #PB_CheckBox_ThreeState ; Create a checkbox that can have a third "in between" state.
      
    Case #_Type_Option         ; : Type$ = "#PB_Option_"
    Case #_Type_ListView       ; : Type$ = "#PB_ListView_"
                               ; #PB_ListView_MultiSelect ; allows multiple items To be selected
                               ; #PB_ListView_ClickSelect ; allows multiple items To be selected. clicking on one Item selects/deselects it (on OS X, same behaviour As #PB_ListView_MultiSelect)
      
    Case #_Type_Frame          : Type$ = "#PB_Frame_"
    Case #_Type_ComboBox       : Type$ = "#PB_ComboBox_"
      If ((FlagType & #_Flag_Editable) = #_Flag_Editable) 
        Result.S + "|" +Type$+ "Editable"  ; Makes the ComboBox editable
      EndIf
      If ((FlagType & #_Flag_LowerCase) = #_Flag_LowerCase) 
        Result.S + "|" +Type$+ "LowerCase" ; All Text entered in the ComboBox will be converted To lower Case.
      EndIf
      If ((FlagType & #_Flag_UpperCase) = #_Flag_UpperCase) 
        Result.S + "|" +Type$+ "UpperCase" ; All Text entered in the ComboBox will be converted To upper Case.
      EndIf
      
      ; #PB_ComboBox_Image     ; Enable support For images in items (Not supported For editable ComboBox on OSX)
      
    Case #_Type_Image          : Type$ = "#PB_Image_"
      If ((FlagType & #_Flag_Border) = #_Flag_Border) 
        Result.S + "|" +Type$+ "Border" ; display a sunken border around the Image.
      EndIf
      If ((FlagType & #_Flag_Raised) = #_Flag_Raised) 
        Result.S + "|" +Type$+ "Raised"  ; display a raised border around the Image.
      EndIf
      
    Case #_Type_HyperLink      : Type$ = "#PB_HyperLink_"
    Case #_Type_Container      : Type$ = "#PB_Container_"
      If ((FlagType & #_Flag_BorderLess) = #_Flag_BorderLess) 
        Result.S + "|" +Type$+ "BorderLess" ; Without any border (Default).
      EndIf
      If ((FlagType & #_Flag_Flat) = #_Flag_Flat) 
        Result.S + "|" +Type$+ "Flat" ; Flat frame.
      EndIf
      If ((FlagType & #_Flag_Raised) = #_Flag_Raised) 
        Result.S + "|" +Type$+ "Raised" ; Raised frame.
      EndIf
      If ((FlagType & #_Flag_Single) = #_Flag_Single) 
        Result.S + "|" +Type$+ "Single" ; Single sunken frame.
      EndIf
      If ((FlagType & #_Flag_Double) = #_Flag_Double) 
        Result.S + "|" +Type$+ "Double" ; Double sunken frame.
      EndIf
      
    Case #_Type_ListIcon       : Type$ = "#PB_ListIcon_"
    Case #_Type_IPAddress      : Type$ = "#PB_IPAddress_"
    Case #_Type_ProgressBar    : Type$ = "#PB_ProgressBar_"
    Case #_Type_ScrollBar      : Type$ = "#PB_ScrollBar_"
    Case #_Type_ScrollArea     : Type$ = "#PB_ScrollArea_"
    Case #_Type_TrackBar       : Type$ = "#PB_TrackBar_"
    Case #_Type_Web            : Type$ = "#PB_Web_"
    Case #_Type_ButtonImage    : Type$ = "#PB_ButtonImage_"
    Case #_Type_Calendar       : Type$ = "#PB_Calendar_"
    Case #_Type_Date           : Type$ = "#PB_Date_"
    Case #_Type_Editor         : Type$ = "#PB_Editor_"
    Case #_Type_ExplorerList   : Type$ = "#PB_ExplorerList_"
    Case #_Type_ExplorerTree   : Type$ = "#PB_ExplorerTree_"
    Case #_Type_ExplorerCombo  : Type$ = "#PB_ExplorerCombo_"
    Case #_Type_Spin           : Type$ = "#PB_Spin_"
    Case #_Type_Tree           : Type$ = "#PB_Tree_"
    Case #_Type_Panel          : Type$ = "#PB_Panel_"
    Case #_Type_Splitter       : Type$ = "#PB_Splitter_"
    Case #_Type_MDI            : Type$ = "#PB_MDI_"
    Case #_Type_Scintilla      : Type$ = "#PB_Scintilla_"
    Case #_Type_Shortcut       : Type$ = "#PB_Shortcut_"
    Case #_Type_Canvas         : Type$ = "#PB_Canvas_"
      
    Case #_Type_ImageButton    : Type$ = "#PB_ImageButton_"
      
    Default        
      If ((FlagType & #_Flag_FirstFixed) = #_Flag_FirstFixed) 
        Result.S + "|" +Type$+ "FirstFixed"
      EndIf
      If ((FlagType & #_Flag_SecondFixed) = #_Flag_SecondFixed) 
        Result.S + "|" +Type$+ "SecondFixed"
      EndIf
      If ((FlagType & #_Flag_Separator) = #_Flag_Separator) 
        Result.S + "|" +Type$+ "Separator"
      EndIf
      
      If ((FlagType & #_Flag_BorderLess) = #_Flag_BorderLess) 
        Result.S + "|" +Type$+ "BorderLess"
      EndIf
      If ((FlagType & #_Flag_Border) = #_Flag_Border) 
        Result.S + "|" +Type$+ "Border"
      EndIf
      If ((FlagType & #_Flag_Flat) = #_Flag_Flat) 
        Result.S + "|" +Type$+ "Flat"
      EndIf
      If ((FlagType & #_Flag_Raised) = #_Flag_Raised) 
        Result.S + "|" +Type$+ "Raised"
      EndIf
      If ((FlagType & #_Flag_Single) = #_Flag_Single) 
        Result.S + "|" +Type$+ "Single"
      EndIf
      If ((FlagType & #_Flag_Double) = #_Flag_Double) 
        Result.S + "|" +Type$+ "Double"
      EndIf
      
      If ((FlagType & #_Flag_Vertical) = #_Flag_Vertical) 
        Result.S + "|" +Type$+ "Vertical"
      EndIf
      If ((FlagType & #_Flag_InlineText) = #_Flag_InlineText) 
        Result.S + "|" +Type$+ "InlineText"
      EndIf
      If ((FlagType & #_Flag_MultiLine) = #_Flag_MultiLine) 
        Result.S + "|" +Type$+ "MultiLine"
      EndIf
      
      If ((FlagType & #_Flag_ReadOnly) = #_Flag_ReadOnly) 
        Result.S + "|" +Type$+ "ReadOnly"
      EndIf
      If ((FlagType & #_Flag_Editable) = #_Flag_Editable) 
        Result.S + "|" +Type$+ "Editable"
      EndIf
      If ((FlagType & #_Flag_Numeric) = #_Flag_Numeric) 
        Result.S + "|" +Type$+ "Numeric"
      EndIf
      If ((FlagType & #_Flag_Password) = #_Flag_Password) 
        Result.S + "|" +Type$+ "Password"
      EndIf
      If ((FlagType & #_Flag_LowerCase) = #_Flag_LowerCase) 
        Result.S + "|" +Type$+ "LowerCase"
      EndIf
      If ((FlagType & #_Flag_UpperCase) = #_Flag_UpperCase) 
        Result.S + "|" +Type$+ "UpperCase"
      EndIf
      
      If ((FlagType & #_Flag_Small) = #_Flag_Small) 
        Result.S + "|" +Type$+ "Small"
      EndIf
      If ((FlagType & #_Flag_Large) = #_Flag_Large) 
        Result.S + "|" +Type$+ "Large"
      EndIf
  EndSelect
  
  ProcedureReturn Trim(Result.S, "|")
EndProcedure


;-
Procedure NoneEventElement(Event.q, Element.i)
  ProcedureReturn #False
EndProcedure

Prototype.q CallProcedure(Event.q, Element)

Procedure.q CallFunctionFast_(*CallBack, Param1.q,Param2.q)
  Protected Result.q, CallProcedure.CallProcedure = *CallBack
  
  If *CallBack
    Result = CallProcedure(Param1,Param2)
    ;     If ((Param1 & #_Event_LeftButtonDown) = #_Event_LeftButtonDown)
    ;       Debug "CallFunctionFast_() "+Param2;+" "+EventClass(Event)+" "+Str(GetElementParent(Element))+" "+ElementClass(ElementType(GetElementParent(Element))) ; ""+Str(ElementEvent())
    ;     EndIf 
  EndIf
  
  ProcedureReturn Result
EndProcedure 

Procedure CallCallBack(*AdressElement, Event.q, Element, Item, *Data)
  Protected Result = #True
  
  With *CreateElement
    
    If ListSize(\This()\Bind\CallBack())
      ForEach \This()\Bind\CallBack()
        If ((\This()\Bind\Event & Event) = Event) 
          
          If *AdressElement
            ;{ - Set bind variables
            PushListPosition(\This())
            ChangeCurrentElement(\This(), *AdressElement)
            
            Protected bEvent = \Bind\Event
            Protected bEventItem = \Bind\Item
            Protected bEventElement = \Bind\Element
            Protected bEventParent = \Bind\Parent
            
            Protected bEventMenu = \Bind\Menu
            Protected bEventPopupMenu = \Bind\PopupMenu
            Protected bEventMessage = \Bind\Window 
            Protected bEventWindow = \Bind\Window 
            Protected bEventDesktop = \Bind\Desktop
            Protected bEventStatusBar = \Bind\StatusBar
            Protected bEventToolbar = \Bind\ToolBar
            Protected bEventGadget = \Bind\Gadget
            
            \Bind\Item = Item
            \Bind\Event = Event
            \Bind\Window = \This()\Window
            \Bind\Element = \This()\Element
            \Bind\Parent = \This()\Parent\Element
            
            Select \This()\Type  
              Case #_Type_Menu      : \Bind\Menu = \This()\Element 
              Case #_Type_PopupMenu : \Bind\PopupMenu = \This()\Element 
              Case #_Type_Message   : \Bind\Window = \This()\Element
              Case #_Type_Window    : \Bind\Window = \This()\Element
              Case #_Type_Desktop   : \Bind\Desktop = \This()\Element
              Case #_Type_StatusBar : \Bind\StatusBar = \This()\Element
              Case #_Type_Toolbar   : \Bind\ToolBar = \This()\Element
              Default               : \Bind\Gadget = \This()\Element
            EndSelect
            PopListPosition(\This())
            ;}
          EndIf
          
          Result = CallFunctionFast_(\This()\Bind\CallBack(), Event, Element) 
          
          ;{ - Reset bind variables
          \Bind\Event = bEvent
          \Bind\Item = bEventItem
          \Bind\Parent = bEventParent
          \Bind\Window = bEventWindow
          \Bind\Element = bEventElement
          \Bind\Menu = bEventMenu
          \Bind\Gadget = bEventGadget
          \Bind\Desktop = bEventDesktop
          \Bind\ToolBar = bEventToolbar
          \Bind\PopupMenu = bEventPopupMenu
          \Bind\StatusBar = bEventStatusBar
          
          ;}
          
          If Result = 0 
            Break
          EndIf
        EndIf
      Next
    EndIf
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.q PostEventElement(Event.q, Element, Item =- 1, *Data = #Null)
  Protected *AdressElement, *AdressWindow, Window =- 1, Parent =- 1, Result.q = #True 
  
  With *CreateElement
    If Element
      *AdressElement = ElementID(Element)
      If *AdressElement
        ChangeCurrentElement(\This(), *AdressElement)
        
        \This()\Bind\Data = *Data
        Window = \This()\Window
        Parent = \This()\Parent\Element
        *AdressWindow = \This()\WindowID ; ElementID(Window)
        
        ; Eсли PostEventElement() был вызван до того, как вызвали BindEventElement()
        If ((\This()\Event & Event.q) = 0) 
          \This()\Event | Event.q
        EndIf
        
        If ((Event.q & #_Event_Drawing) = #_Event_Drawing)
          DrawingMode(#PB_2DDrawing_Default) 
          SetOrigin(\This()\FrameCoordinate\X,\This()\FrameCoordinate\Y)
          ClipOutput(\This()\FrameCoordinate\X,\This()\FrameCoordinate\Y,
                     \This()\FrameCoordinate\Width,\This()\FrameCoordinate\Height)
        EndIf
        
        Result = CallCallBack(*AdressElement, Event, Element, Item, *Data)
        
        ;         If ((Event & #_Event_Close) = #_Event_Close)
        ;           Debug "CallFunctionFast_ -"+EventClass(Event)+" Why???"
        ;         EndIf
        
        ;
        If (Result And *AdressWindow And 
            ChangeCurrentElement(\This(), *AdressWindow) And \This()\Bind\Window = Window)
          Result = CallCallBack(*AdressElement, Event, Element, Item, *Data)
        EndIf
        
        ;
        If Result And SelectElement(\This(), 0)
          Result = CallCallBack(*AdressElement, Event, Element, Item, *Data)
        EndIf
        
        ; 
        ChangeCurrentElement(\This(), *AdressElement)
      EndIf
    EndIf
  EndWith
  
  ProcedureReturn Result.q
EndProcedure

Procedure.q BindEventElement(*CallBack, ElementWindow = #PB_All, ElementGadget = #PB_All, Event.q = #PB_All)
  Protected Result.q, *Element, *Window
  
  With *CreateElement
    If *CallBack
      PushListPosition(\This())
      *Element = ElementID(ElementGadget)
      If *Element
        ChangeCurrentElement(\This(), *Element)
        ElementWindow = \This()\Window
      Else
        *Window =  ElementID(ElementWindow)
        If *Window
          ChangeCurrentElement(\This(), *Window)
        Else
          SelectElement(\This(), 0)
          ElementWindow = 0
        EndIf
      EndIf
      
      If ElementGadget = #PB_Ignore
        \This()\Bind\Window = #PB_Ignore
      Else
        \This()\Bind\Window = ElementWindow
      EndIf
      
      ;Debug "Element "+\This()\Element
      \This()\Bind\Element = \This()\Element
      \This()\Bind\Event = \This()\Event|Event.q
      AddElement(\This()\Bind\CallBack()) : \This()\Bind\CallBack() = *CallBack
      PopListPosition(\This())  
      
      
      ; Если PostEventElement() был вызван до того, как вызвали BindEventElement()
      PushListPosition(\This()) 
      ForEach \This()
        If *Element
          If \This()\Element <> ElementGadget
            Continue
          EndIf
        ElseIf IsChildElement(\This()\Element, ElementWindow) = #False
          Continue
        EndIf
        
        \Bind\Element = \This()\Element
        ; Это нужен для скролл ареа элемент    
        If (#PB_All = Event Or ((Event & #_Event_Change) = #_Event_Change))
          If ((\This()\Event & #_Event_Change) = #_Event_Change)
            \Bind\Event = #_Event_Change
            CallFunctionFast_(*CallBack, #_Event_Change, \This()\Element)
            \This()\Event &~ #_Event_Change
          EndIf
        EndIf
        If (#PB_All = Event Or ((Event & #_Event_CreateApp) = #_Event_CreateApp))
          If ((\This()\Event & #_Event_CreateApp) = #_Event_CreateApp)
            ;\Bind\Event = #_Event_CreateApp
            CallFunctionFast_(*CallBack, #_Event_CreateApp, \This()\Element)
            \This()\Event &~ #_Event_CreateApp
          EndIf
        EndIf
        If (#PB_All = Event Or ((Event & #_Event_Create) = #_Event_Create))
          If ((\This()\Event & #_Event_Create) = #_Event_Create)
            ;\Bind\Event = #_Event_Create
            CallFunctionFast_(*CallBack, #_Event_Create, \This()\Element)
            \This()\Event &~ #_Event_Create
          EndIf
        EndIf
        If (#PB_All = Event Or ((Event & #_Event_Focus) = #_Event_Focus))
          If ((\This()\Event & #_Event_Focus) = #_Event_Focus)
            ;\Bind\Event = #_Event_Focus
            CallFunctionFast_(*CallBack, #_Event_Focus, \This()\Element)
            \This()\Event &~ #_Event_Focus
          EndIf
        EndIf
        If (#PB_All = Event Or ((Event & #_Event_LostFocus) = #_Event_LostFocus))
          If ((\This()\Event & #_Event_LostFocus) = #_Event_LostFocus)
            ;\Bind\Event = #_Event_LostFocus
            CallFunctionFast_(*CallBack, #_Event_LostFocus, \This()\Element)
            \This()\Event &~ #_Event_LostFocus
          EndIf
        EndIf
        If (#PB_All = Event Or ((Event & #_Event_Size) = #_Event_Size)) 
          If ((\This()\Event & #_Event_Size) = #_Event_Size) 
            ;\Bind\Event = #_Event_Size
            CallFunctionFast_(*CallBack, #_Event_Size, \This()\Element)
            \This()\Event &~ #_Event_Size
          EndIf
        EndIf
        If (#PB_All = Event Or ((Event & #_Event_Move) = #_Event_Move)) 
          If ((\This()\Event & #_Event_Move) = #_Event_Move) 
            ;\Bind\Event = #_Event_Move
            CallFunctionFast_(*CallBack, #_Event_Move, \This()\Element)
            \This()\Event &~ #_Event_Move
          EndIf
        EndIf
        
      Next
      PopListPosition(\This())
      
    Else
      BindEventElement(@NoneEventElement(), ElementWindow, ElementGadget, Event)
    EndIf
  EndWith
  
  ProcedureReturn Result.q
EndProcedure

Procedure.q UnbindEventElement(*CallBack, ElementWindow = #PB_All, ElementGadget = #PB_All, Event.q = #PB_All)
  Protected Result.q
  
  With *CreateElement
    PushListPosition(\This())
    If ElementWindow = #PB_All
      SelectElement(\This(), 0)
    Else
      If ElementGadget = #PB_All
        ChangeCurrentElement(\This(), ElementID(ElementWindow))
      Else
        ChangeCurrentElement(\This(), ElementID(ElementGadget))
      EndIf
    EndIf
    
    If ListSize(\This()\Bind\CallBack()) 
      ForEach \This()\Bind\CallBack()
        If \This()\Bind\CallBack() = *CallBack
          \This()\Bind\Event =- 1
          \This()\Bind\Element =- 1
          DeleteElement(\This()\Bind\CallBack())
        EndIf
      Next
    EndIf
    ;Debug "ListSize "+ListSize(\This()\Bind\CallBack()) 
    PopListPosition(\This())  
    
  EndWith
  
  ProcedureReturn Result.q
EndProcedure


Procedure BindWindowElementEvent(WindowElement, *CallBack, Event.q = #PB_All)
  
  If IsWindowElement(WindowElement)
    BindEventElement(*CallBack, WindowElement, #PB_Ignore, Event)
  EndIf
  
EndProcedure

Procedure BindGadgetElementEvent(GadgetElement, *CallBack, Event.q = #PB_All)
  
  If IsGadgetElement(GadgetElement)
    BindEventElement(*CallBack, #PB_Ignore, GadgetElement, Event)
  ElseIf IsWindowElement(GadgetElement)
    BindEventElement(*CallBack, GadgetElement, #PB_All, Event)
  EndIf
  
EndProcedure

;-
Procedure SetElementAttribute(Element, Attribute, Value)
  Protected Result, X,Y,Width,Height, Type, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Type = \This()\Type
      
      Select Type
        Case #_Type_ScrollBar  : SetScrollBarElementAttribute(\This(), Attribute, Value)
        Case #_Type_ScrollArea : SetScrollAreaElementAttribute(\This(), Attribute, Value)
        Case #_Type_Properties : SetPropertiesElementAttribute(\This(), Attribute, Value)
        Case #_Type_Splitter   : SetSplitterElementAttribute(\This(), Attribute, Value)
      EndSelect
      
      ;       If \This()\Type = #_Type_ScrollArea ;IsElement(\This()\Scroll\Element)
      ;         ChangeCurrentElement(\This(), ElementID(\This()\Scroll\Element))
      ;       EndIf
      
      Select Attribute
        Case #_Attribute_FontColor
          \This()\FontColorState = #True
          Result = \This()\FontColor
          \This()\FontColor = Value
          
        Case #_Attribute_BackColor
          If Type <> #_Type_ScrollArea And Type <> #_Type_ScrollBar
            \This()\BackColorState = #True
            Result = \This()\BackColor
            \This()\BackColor = Value
            ;Debug ElementClass(\This()\Type)
            If Value = #PB_Image_Transparent ; Color =- 1
              \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
            Else
              \This()\DrawingMode = #PB_2DDrawing_Default
            EndIf
          EndIf
          
      EndSelect
      PopListPosition(\This())
    EndIf
  EndWith
  
EndProcedure

Procedure GetElementAttribute(Element, Attribute)
  Protected Result, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      Select \This()\Type
        Case #_Type_ScrollBar  : Result = GetScrollBarElementAttribute(\This(), Attribute)
        Case #_Type_ScrollArea : Result = GetScrollAreaElementAttribute(\This(), Attribute)
        Case #_Type_Splitter   : Result = GetSplitterElementAttribute(\This(), Attribute)
      EndSelect
      
      Select Attribute
          Case #_Attribute_BorderSize : If \This()\IsContainer : Result = (\This()\BorderSize) : EndIf
        Case #_Attribute_CaptionHeight : Result = (\This()\CaptionHeight+\This()\MenuHeight+\This()\ToolBarHeight)
          
        Case #_Element_Item : Result = \This()\Item\Entered\Element
          
        Case #_Attribute_FontColor : Result = \This()\FontColor
        Case #_Attribute_BackColor : Result = \This()\BackColor
          
        Case #_Attribute_EnteredBackColor : Result = \This()\EnteredBackColor
        Case #_Attribute_SelectedBackColor : Result = \This()\SelectedBackColor
          
        Case #_Attribute_FrameColor : Result = \This()\FrameColor
        Case #_Attribute_GradientTopColor : Result = \This()\TopColor
        Case #_Attribute_GradientBottomColor : Result = \This()\BottomColor
      EndSelect
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
Procedure SetForegroundWindowElement(Element) ; Ok
  Protected Result =- 1, *Element = ElementID(Element)
  
  If GetElementData(Element) = #PB_Ignore
    ProcedureReturn 
  EndIf
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      Result = \ForegroundWindow
      If \This()\Type <> #_Type_Window
        Element = \This()\Window  
      EndIf 
      
      ;ChangeCurrentElement(\This(), ElementID(Element))
      ;Debug \This()\Parent\Element
      
      ; ;       ParentElement = Element
      ; ;       
      ; ;       While IsElement(ParentElement)
      ; ;         If ParentElement = Parent 
      ; ;           Result = 1
      ; ;           Break
      ; ;         EndIf
      ; ;         
      ; ;         ParentElement = GetElementWindow(ParentElement)
      ; ;       Wend
      
      
      ;       
      ;       If \This()\Parent\Element  
      ;         ;ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
      ;         \ForegroundWindow = \This()\Window ; ?
      ;         
      ;         ;Debug "ForegroundWindow "+\This()\Window;\ForegroundWindow
      ;       Else
      \ForegroundWindow = Element
      ;       EndIf
      ;       
      ;       If \ForegroundWindow =- 1
      ;         ;\ForegroundWindow = 25
      ;       EndIf
      
      Select Element 
        Case 35,37,39,41 ; 28,30,32,34
        Default : SetElementPosition(Element, #_Element_PositionLast)
      EndSelect
      
      PopListPosition(\This()) 
      
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetActiveElement(Element) ; 
  Static ActiveGadget =- 1
  Protected *Element = ElementID(Element)
  Protected Result =- 1, ElementGadget =- 1
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If \This()\Interact
        If \ActiveElement <> Element : \ActiveElement = Element : EndIf
        
        Select \This()\Type ; ElementType(Element)
          Case #_Type_Menu, #_Type_PopupMenu, #_Type_Toolbar, #_Type_StatusBar : \FocusElement = Element
            
          Case #_Type_Window
            Result = \ActiveWindow 
            If \ActiveWindow <> Element : \ActiveWindow = Element
              
              If IsElement(Result) : ElementCallBack(#_Event_LostFocus, Result) : EndIf
              If IsElement(Element) : ElementCallBack(#_Event_Focus, Element) : EndIf
              
              ; 
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(Element)) 
              ElementGadget = \This()\FocusGadget
              If ActiveGadget <> ElementGadget
                If IsElement(ActiveGadget)
                  ChangeCurrentElement(\This(), ElementID(ActiveGadget)) : \This()\State &~ #_State_Focused
                EndIf
                If IsElement(ElementGadget)
                  ChangeCurrentElement(\This(), ElementID(ElementGadget)) : \This()\State | #_State_Focused
                EndIf
                ActiveGadget = ElementGadget
              EndIf
              PopListPosition(\This())
              
            EndIf
            
          Default
            Result = \ActiveGadget 
            If IsElement(ActiveGadget)
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(ActiveGadget))
              \This()\State &~ #_State_Focused
              PopListPosition(\This())
            EndIf : ActiveGadget = Element
            
            \ActiveWindow = GetElementWindow(Element)
            If IsElement(\ActiveWindow)
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(\ActiveWindow)) 
              \This()\FocusGadget = Element
              PopListPosition(\This())
            EndIf
            
            If \ActiveGadget <> Element : \ActiveGadget = Element
              If IsElement(Result) : ElementCallBack(#_Event_LostFocus, Result) : EndIf
              If IsElement(Element) : ElementCallBack(#_Event_Focus, Element) : EndIf
            EndIf
        EndSelect
      EndIf
      
      PopListPosition(\This()) 
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
Procedure.i EnumerateElement(*ID.Integer, Parent.i =- 1, Item.i =- 1) ; Ok
  Static Element.i =- 1, StartEnumerate.i
  Protected Result.i, *Parent, NestedElements.b
  
  If IsElement(Parent)
    *Parent = ElementID(Parent)
  Else
    *Parent = Parent
    NestedElements = #True
    Parent = IDElement(Parent)
  EndIf
  
  If Element =- 1 
    Element = Parent 
  EndIf
  
  With *CreateElement
    If Element = Parent
      If (Not StartEnumerate) 
        If *Parent
          ChangeCurrentElement(\This(), *Parent)
          If (Not \This()\Childrens) : ProcedureReturn 0 : EndIf
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
                If \This()\Parent\Item = Item
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
                If \This()\Parent\Item = Item
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

; 
Procedure CountElement(Parent, Item =- 1)
  Protected Result, *Parent = ElementID(Parent)
  
  With *CreateElement
    If *Parent
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Parent)
      
      If \This()\Type = #_Type_ScrollArea
        ChangeCurrentElement(\This(), ElementID(\This()\Scroll\Element))
        ;  ChangeCurrentElement(\This(), ElementID(\This()\Scroll\Element))
      EndIf
      
      If IsElementItem(Item)
        Item = \This()\Item\Element
        
        PushListPosition(\This()) 
        While NextElement(\This())
          If IsChildElement(\This()\Element, Parent) And \This()\Parent\Item = Item
            Result + 1
          EndIf
        Wend
        PopListPosition(\This())
      Else
        Result = \This()\Childrens
      EndIf
      
      PopListPosition(\This())
    Else
      Result = (ListSize(\This()) - 1) 
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить количество однотипных элементов 
Procedure CountElementType(Type, Parent)
  Protected Result, Item, *Parent = ElementID(Parent)
  
  With *CreateElement
    If *Parent
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Parent)
      Item = \This()\Item\Element ; Активный на даный момент вкладка
      
      While NextElement(\This())
        If (Type = \This()\Type And 
            (\This()\Parent\Element = Parent And \This()\Parent\Item = Item))
          Result + 1
        EndIf
      Wend
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure CountElementItems(Element) ; Ok
  Protected Result, *linked, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element) 
      *linked = ElementID(\This()\Linked\Element) 
      
      If *linked 
        ChangeCurrentElement(\This(), *linked) 
      EndIf
      
      Result = ListSize(\This()\Items())
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure ClearElementItems(Element) ; Ok
  Protected Result, *linked, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This())
      ChangeCurrentElement(\This(), *Element) 
      \This()\Text\String$ = ""
      *linked = ElementID(\This()\Linked\Element) 
      
      If *linked 
        ChangeCurrentElement(\This(), *linked) 
        \This()\Hide = #True
      EndIf
      
      Result = ClearList(\This()\Items()) 
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure RemoveElementItem(Element, Item)
  Protected Result, String$, *Item, *linked, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element) 
      *linked = ElementID(\This()\Linked\Element) 
      
      If *linked 
        ChangeCurrentElement(\This(), *linked) 
        \This()\Hide = #True
      EndIf
      
      *Item = ItemID(Item)
      
      If *Item
        DeleteMapElement(\This()\iHandle(), Str(Item))
        ChangeCurrentElement(\This()\Items(), *Item)
        String$ = \This()\Items()\Text\String$
        Result = DeleteElement(\This()\Items()) 
      EndIf
      
      If *linked 
        ChangeCurrentElement(\This(), *Element)
      EndIf
      
      If \This()\Text\String$ = String$
        \This()\Text\String$ = ""
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure UpdateParentElementChildrensCount(Element, Count)
  Protected Result, *Element = ElementID(Element) 
  
  ; Called this function
  ; FreeElement()
  ; CreateElement()
  ; SetElementParent()
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element) : \This()\Childrens + Count
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
Procedure SetWindowElementColor(Element, *Color)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\BackColor
      \This()\BackColor = *Color
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure






XIncludeFile "CFE_Z_Order(example).pb"





;-
; Открыть список к которому будем добавлять элементы
Procedure OpenElementList(Element =- 1, Item =- 1)
  Protected Result =- 1, *ElementID
  
  With *CreateElement
    Result = \Parent
    
    If (Element <>- 1 And Element <> \Parent)
      *ElementID = ElementID(Element)
      If *ElementID
        PushListPosition(\This()) 
        ChangeCurrentElement(\This(), *ElementID)
        
        If ((\This()\Flag & #_Flag_NoGadgets) = 0)
          
          Protected *ScrollID = ElementID(\This()\Scroll\Element) 
          If *ScrollID 
            ChangeCurrentElement(\This(), *ScrollID) 
          EndIf
          
          Protected *LinkID = ElementID(\This()\Linked\Element)
          If *LinkID
            ChangeCurrentElement(\This(), *LinkID)
          EndIf
          
          Select \This()\Type
            Case #_Type_PopupMenu : \This()\Parent\Element = 0 
            Case #_Type_Desktop : \This()\IsContainer = #_Type_Desktop
            Case #_Type_Window : \This()\IsContainer = #_Type_Window
              \Window = \This()\Element
              
            Case #_Type_Panel : \This()\IsContainer = 1
              If IsElementItem(Item)
                \This()\Item\Element = Item
              EndIf
              
            Case #_Type_Container, #_Type_ScrollArea, #_Type_MDI
              \This()\IsContainer = 1
              
          EndSelect
          
          If \This()\IsContainer 
            \This()\CloseList = \Parent
            \Parent = \This()\Element 
            \This()\OpenList = \Parent 
          EndIf
          ;
          If \This()\Type = #_Type_Splitter 
            \This()\CloseList = \This()\Element 
            \This()\IsContainer = 1 
          EndIf
          
        EndIf
        
        PopListPosition(\This())
      EndIf
    EndIf
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure Old_OpenElementList(Element =- 1, Item =- 1)
  Protected Result =- 1, *Linked, *Element
  
  With *CreateElement
    Result = \Parent
    
    If (Element <>- 1 And Element <> \Parent)
      *Element = ElementID(Element)
      If *Element
        PushListPosition(\This()) 
        ChangeCurrentElement(\This(), *Element)
        *Linked = ElementID(\This()\Linked\Element)
        
        If *Linked
          ChangeCurrentElement(\This(), *Linked)
        EndIf
        
        Select \This()\Type
          Case #_Type_PopupMenu : \This()\Parent\Element = 0 
          Case #_Type_Desktop : \This()\IsContainer = #_Type_Desktop
          Case #_Type_Window : \This()\IsContainer = #_Type_Window
            \Window = \This()\Element
            
          Case #_Type_Panel : \This()\IsContainer = 1
            If IsElementItem(Item)
              \This()\Item\Element = Item
            EndIf
            
          Case #_Type_Container, #_Type_ScrollArea
            \This()\IsContainer = 1
            
        EndSelect
        
        If \This()\IsContainer 
          \This()\CloseList = \Parent
          \Parent = \This()\Element 
          \This()\OpenList = \Parent 
        EndIf
        ;
        If \This()\Type = #_Type_Splitter 
          \This()\CloseList = \This()\Element 
          \This()\IsContainer = 1 
        EndIf
        
        PopListPosition(\This())
      EndIf
    EndIf
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Закрыть список 
Procedure CloseElementList(Element =- 1) ; Ok
  Static LastElement =- 1
  Protected Result, *ScrollID
  
  With *CreateElement
    If ListSize(\This())
      PushListPosition(\This())
      LastElement(\This()) ; Что бы начать с последнего элемента
      Repeat               ; Перебираем с низу верх
        If \This()\Element And \This()\IsContainer 
          If (\This()\CloseList <> \This()\Element)
            \This()\CloseList = \This()\Element
            If \This()\Type = #_Type_Window 
              \Window = \This()\Window 
            EndIf
            \Parent = \This()\Parent\Element
            Result = \This()\Element
            ;Debug \This()\Class$ +" - "+ Str(Result)+" "+\This()\Parent\Element
             
            If Bool(Element =- 1 Or \This()\Element = Element)
              Break
            Else
              ProcedureReturn CloseElementList(Element)
            EndIf
          EndIf
        EndIf
      Until PreviousElement(\This()) = #False 
      
      *ScrollID = ElementID(\This()\Scroll\Element)
      If *ScrollID
        ChangeCurrentElement(\This(), *ScrollID)
        If Bool(\This()\Type <> #_Type_Splitter)
          \This()\CloseList = \This()\Element
          \Parent = \This()\Parent\Element
          Result = \This()\Element
        EndIf
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure
Procedure Old_CloseElementList()
  Static LastElement =- 1
  Protected Result, *Scrolled 
  
  With *CreateElement
    If ListSize(\This())
      PushListPosition(\This())
      LastElement(\This()) ; Что бы начать с последнего элемента
      Repeat               ; Перебираем с низу верх
        If \This()\Element ; 
          If (\This()\IsContainer And (\This()\CloseList <> \This()\Element))
            Result = \This()\Element
            ;Debug Str(Result)+" "+\This()\Parent\Element
            
            \Parent = \This()\Parent\Element
            
            If \This()\Type = #_Type_Window
              \Window = \This()\Window
            EndIf
            
            \This()\CloseList = \This()\Element
            Break
          EndIf
        EndIf
      Until PreviousElement(\This()) = #False 
      
      *Scrolled = ElementID(\This()\Scroll\Element)
      If *Scrolled 
        ChangeCurrentElement(\This(), *Scrolled)
        If \This()\Type = #_Type_ScrollArea
          \This()\CloseList = \This()\Element
          \Parent = \This()\Parent\Element
        EndIf
      EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

;-
Procedure CoordinateElement(List This.S_CREATE_ELEMENT(), *AdressElement, Coordinate, Mode)
  Protected Result, bSize
  
  If *AdressElement
    With This()
      PushListPosition(This()) 
      ChangeCurrentElement(This(), *AdressElement)
      bSize = (\bSize-\BorderSize)
      
      If \Hide = 0
        If Not Mode
          If \IsContainer
            Mode = #_Element_InnerCoordinate
          Else
            Mode = #_Element_FrameCoordinate
          EndIf
        EndIf
        
        Select Coordinate
          Case 1 ; X
            Select Mode 
              Case #_Element_ClipCoordinate : Result = \X+bSize                          ; X position of the window, including borders (default).
              Case #_Element_InnerCoordinate : Result = \InnerCoordinate\X+bSize         ; X position of the window inner area (where Element can be added), excluding borders.
              Case #_Element_FrameCoordinate : Result = \FrameCoordinate\X+bSize         ; X position of the window, including borders (default).
              Case #_Element_ScreenCoordinate : Result = \FrameCoordinate\X+bSize        ; the absolute Element X Position (in pixels) in the screen.
              Case #_Element_WindowCoordinate : Result = \WindowCoordinate\X+bSize       ; the absolute Element X Position (in pixels) within the Window.
              Case #_Element_ContainerCoordinate : Result = \ContainerCoordinate\X+bSize ; the Element X Position (in pixels) within its container, Or Window (Default)
            EndSelect
            
          Case 2 ; Y
            Select Mode 
              Case #_Element_ClipCoordinate : Result = \Y+bSize ; Y position of the window, including borders (default).
              Case #_Element_InnerCoordinate : Result = \InnerCoordinate\Y+bSize ; Y position of the window inner area (where Element can be added), excluding borders.
              Case #_Element_FrameCoordinate : Result = \FrameCoordinate\Y+bSize ; Y position of the window, including borders (default).
              Case #_Element_ScreenCoordinate : Result = \FrameCoordinate\Y+bSize; the absolute Element Y Position (in pixels) in the screen.
              Case #_Element_WindowCoordinate : Result = \WindowCoordinate\Y+bSize ; the absolute Element Y Position (in pixels) within the Window.
              Case #_Element_ContainerCoordinate : Result = \ContainerCoordinate\Y+bSize ; the Element Y Position (in pixels) within its container, Or Window (Default)
            EndSelect
            
          Case 3 ; Width
            Select Mode 
              Case #_Element_ClipCoordinate : Result = \Width-bSize*2 ; returns the current Width of the gadget, in pixels (default).
              Case #_Element_FrameCoordinate : Result = \FrameCoordinate\Width-bSize*2 ; returns the current Width of the gadget, in pixels (default).
              Case #_Element_InnerCoordinate : Result = \InnerCoordinate\Width         ; returns the Width needed to fully display the gadget, in pixels.
            EndSelect
            
          Case 4 ; Height
            Select Mode 
              Case #_Element_ClipCoordinate : Result = \Height-bSize*2 ; returns the current Height of the gadget, in pixels (default).
              Case #_Element_FrameCoordinate : Result = \FrameCoordinate\Height-bSize*2 ; returns the current Height of the gadget, in pixels (default).
              Case #_Element_InnerCoordinate : Result = \InnerCoordinate\Height         ; returns the Height needed to fully display the gadget, in pixels.
            EndSelect
            
        EndSelect
      EndIf
      
      PopListPosition(This())
    EndWith
  EndIf
  
  ProcedureReturn Result
EndProcedure

; Получить X-позицию на холсте
Procedure ElementX(Element, Mode = #_Element_ContainerCoordinate)
  ProcedureReturn CoordinateElement(*CreateElement\This(), ElementID(Element), 1, Mode)
EndProcedure

; Получить Y-позицию на холсте
Procedure ElementY(Element, Mode = #_Element_ContainerCoordinate)
  ProcedureReturn CoordinateElement(*CreateElement\This(), ElementID(Element), 2, Mode)
EndProcedure

; Получить Width-позицию на холсте
Procedure ElementWidth(Element, Mode = 0)
  ProcedureReturn CoordinateElement(*CreateElement\This(), ElementID(Element), 3, Mode)
EndProcedure

; Получить Height-позицию на холсте
Procedure ElementHeight(Element, Mode = 0)
  ProcedureReturn CoordinateElement(*CreateElement\This(), ElementID(Element), 4, Mode)
EndProcedure

; Получить X-позицию мыши на элементе
Procedure ElementMouseX(Element)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If Element = 0
        Result = \MouseX
      Else
        Result = \This()\MouseX
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить Y-позицию мыши на элементе
Procedure ElementMouseY(Element)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If Element = 0
        Result = \MouseY
      Else
        Result = \This()\MouseY - \This()\CaptionHeight
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
;Получить тип элемента
Procedure ElementType(Element) ; Ok
  Protected Result = #_Type_Unknown
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      Result = \This()\Type
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Показать\Скрыть элемент
Procedure HideElement(Element, State.b) ; Ok
  Protected Result 
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      \This()\HideState = State
      
      ; Это для всплывающего меню
      If \This()\Type = #_Type_PopupMenu
        PushListPosition(\This())
        ForEach \This()
          Select \This()\Type
            Case #_Type_PopupMenu : \This()\Hide = #True 
          EndSelect
        Next
        PopListPosition(\This())
        ProcedureReturn #True
      EndIf
      
      If \This()\Hide <> State 
        If IsElement(\This()\Parent\Element)
          PushListPosition(\This())
          ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
          If \This()\Type = #_Type_Panel
            Result = \This()\Item\Selected\Element
          EndIf
          PopListPosition(\This())
        EndIf
        
        If \This()\Item\Parent = Result
          \This()\Hide = State
        EndIf 
        
        If \This()\Childrens
          PushListPosition(\This())
          While NextElement(\This())
            If IsChildElement(\This()\Element, Element)
              
              Select State 
                Case #True : \This()\Hide = #True
                Case #False 
                  If IsElement(\This()\Parent\Element)
                    PushListPosition(\This())
                    ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
                    If \This()\Type = #_Type_Panel
                      Result = \This()\Item\Selected\Element
                    EndIf
                    PopListPosition(\This())
                  EndIf
                  
                  If \This()\Item\Parent = Result
                    \This()\Hide = \This()\HideState
                  EndIf
              EndSelect
              
            EndIf
          Wend
          PopListPosition(\This())
        Else
          \This()\Hide = State
          
          If IsElement(\This()\Scroll\Vert)
            PushListPosition(\This())
            ChangeCurrentElement(\This(), ElementID(\This()\Scroll\Vert))
            \This()\Hide = State
            PopListPosition(\This())
          EndIf
          
          If IsElement(\This()\Scroll\Horz)
            PushListPosition(\This())
            ChangeCurrentElement(\This(), ElementID(\This()\Scroll\Horz))
            \This()\Hide = State
            PopListPosition(\This())
          EndIf
          
        EndIf
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
EndProcedure

; Активен\Посивен элемент
Procedure DisableElement(Element, State.b = #PB_Default) ; Ok
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If State =- 1 : Result = \This()\Disable : Else
        If State : \This()\Disable = #True : EndIf
        PushListPosition(\This())
        While NextElement(\This())
          If IsChildElement(\This()\Element, Element)
            Select State 
              Case #True : \This()\Disable = #True
              Case #False : \This()\Disable = \This()\DisableState
            EndSelect
          EndIf
        Wend
        PopListPosition(\This())
        If State = #False : \This()\Disable = #False : \This()\Repaint = #True : EndIf
        ;\This()\Disable = State
        \This()\DisableState = State
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure DisableElementItem(Element, Item, State.b)
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      ;       Debug Element
      ;       Debug \This()\Element
      
      If IsElementItem(Item)
        PushListPosition(\This()\Items()) 
        ChangeCurrentElement(\This()\Items(), ItemID(Item))
        ;         Debug Item
        ;         Debug \This()\Items()\Element
        
        \This()\Items()\Disable = State
        PopListPosition(\This()\Items()) 
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
EndProcedure

Procedure StickyWindowElement(WindowElement = #PB_Default, State = #PB_Default)
  Protected Result
  
  With *CreateElement
    Result = \StickyWindow
    
    If IsWindowElement(WindowElement)
      If State
        If \StickyWindow <> WindowElement : \StickyWindow = WindowElement
          SetElementPosition(WindowElement, #_Element_PositionLast)
        EndIf
      Else
        \StickyWindow =- 1
      EndIf
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
; Установить родител элементу
Procedure SetElementParent(Element, Parent, Item = 0) ; Ok
                                                      ; FIXME 03.02.17 Не правильно определял окно ребенка
  Protected Window =- 1
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element) 
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element)) 
      Protected Type = \This()\Type
      Protected Height = \This()\FrameCoordinate\Height
      
      If \This()\Parent\Element <> Parent 
        Result = \This()\Parent\Element
        
        ; Update parent elements ChildrensСount 
        UpdateParentElementChildrensCount(Parent, 1) ; CountElement()
        UpdateParentElementChildrensCount(Result, - 1) ; CountElement()
        
        ; Set parent item
        PushListPosition(\This()) 
        ChangeCurrentElement(\This(), ElementID(Parent)) 
        Window = \This()\Window
        If \This()\Type = #_Type_Window : Window = Parent : EndIf
        If IsElementItem(Item) : \This()\Item\Parent = Item : EndIf
        PopListPosition(\This()) 
        
        \This()\Window = Window
        \This()\Parent\Element = Parent
        
        ; Z-Position Parent (на тот случай если предидущий элемент сделали его дитье)
        ; SetElementPosition(Parent, #_Element_PositionNext, LastPosition(Element))
        
        SetElementPosition(Parent, #_Element_PositionPrev)
        SetElementPosition(Parent, #_Element_PositionNext)
        SetElementPosition(Parent, #_Element_PositionPrev)
        
        ; Z-position elements
        If IsWindowElement(Element)
          SetElementPosition(Element, #_Element_PositionLast)
        Else
          SetElementPosition(Element, #_Element_PositionPrev)
          SetElementPosition(Element, #_Element_PositionNext)
        EndIf
        
        ;         PushListPosition(\This()) 
        ;         ChangeCurrentElement(\This(), ElementID(Element))
        ;         MoveElement(\This(), #PB_List_Before, ElementID(\This()\Parent\Element))
        ;         PopListPosition(\This()) 
        ; ;         SwapElements(\This(), ElementID(Parent), ElementID(Element))
        
        
        ; Resize elements
        PushListPosition(\This()) 
        ChangeCurrentElement(\This(), ElementID(Element))
        
        If \This()\IsAlign
          Protected ChangeX, ChangeY
          ChangeX = \This()\FrameCoordinate\X
          ChangeY = \This()\FrameCoordinate\Y
          AvtoResizeElement(\This(), Element, Parent)
          ChangeX - \This()\FrameCoordinate\X
          ChangeY - \This()\FrameCoordinate\Y
          
          If \This()\Childrens
            PushListPosition(\This()) 
            While NextElement(\This()) 
              If IsChildElement(\This()\Element, Element) 
                If \This()\IsAlign 
                  AvtoResizeElement(\This(), \This()\Element, Element)
                Else
                  If ChangeX : \This()\FrameCoordinate\X - ChangeX
                    ResizeElementX(\This(), (\This()\FrameCoordinate\X+ChangeX))
                  EndIf
                  If ChangeY : \This()\FrameCoordinate\Y - ChangeY
                    ResizeElementY(\This(), (\This()\FrameCoordinate\Y+ChangeY))
                  EndIf
                EndIf
              EndIf
            Wend
            PopListPosition(\This()) 
          EndIf
          
        Else
          ResizeElement(Element, \This()\ContainerCoordinate\X, \This()\ContainerCoordinate\Y, #PB_Ignore, #PB_Ignore)
        EndIf
        PopListPosition(\This())
        
        ; For menu and toolbar
        If Height
          PushListPosition(\This()) 
          ChangeCurrentElement(\This(), ElementID(Parent)) 
          If Type = #_Type_Menu : \This()\MenuHeight = Height : EndIf
          If Type = #_Type_Toolbar : \This()\ToolBarHeight = Height : EndIf
          
          ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, \This()\FrameCoordinate\Width, \This()\FrameCoordinate\Height, #PB_Ignore)
          PopListPosition(\This())
        EndIf
        
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить родител элемента
Procedure GetElementParent(Element) ; Ok
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      If \This()\Type = #_Type_PopupMenu
        Result = \This()\Item\Parent
      Else
        Result = \This()\Parent\Element
      EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить главное окно элемента
Procedure GetElementWindow(Element)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      Result = \This()\Window
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

;-
Procedure InteractElement(Element, State.b = #PB_Default) ; Ok
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If State =- 1 : Result = \This()\Interact : Else
        \This()\InteractState = State
        If State : \This()\Interact = 1 : EndIf
        PushListPosition(\This())
        While NextElement(\This())
          If IsChildElement(\This()\Element, Element)
            Select State 
              Case #True : \This()\Interact = #True
              Case #False : \This()\Interact = \This()\InteractState
            EndSelect
          EndIf
        Wend
        PopListPosition(\This())
        If State = #False : \This()\Interact = #False : \This()\Repaint = #True : EndIf
        ;\This()\Interact = State
      EndIf
      
      ResetList(\This())
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
; Установить шрифт 
Procedure SetElementFont(Element, FontID)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\FontID
      \This()\FontID = FontID
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить шрифт
Procedure GetElementFont(Element)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\FontID
      
      PopListPosition(\This())
    Else
      Result = GetGadgetFont(#PB_Default)
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Установить текст 
Procedure.S SetElementText(Element, Text$)
  Protected Result.S
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      ; Set_TextElement_Text()
      If \This()\Type = #_Type_Text And Bool((\This()\Flag & #_Flag_MultiLine) = #_Flag_MultiLine)
        ;If (CountString(Text$, #LF$) = 0) : Text$ + #LF$ : EndIf
        Text$+#LF$
      EndIf
      
      Select \This()\Type
          ; SpinElement
        Case #_Type_Spin
          Result.S = \This()\Text\String$
          \This()\Text\String$ = Text$
          \This()\Spin\Value = ValF(Text$)
          
        Case #_Type_Window
          If ListSize(\This()\Items())
            SelectElement(\This()\Items(), 0)
            Result.S = \This()\Items()\Text\String$
            \This()\Items()\Text\String$ = Text$
          EndIf
          
        Default
          Result.S = \This()\Text\String$
          \This()\Text\String$ = Text$
          
          ;           If ((\This()\Flag & #_Flag_Editable) = 0) And \This()\Type = #_Type_ComboBox
          ;             SelectElement(\This()\Items(), 0)
          ;             
          ;             Result.S = \This()\Items()\Text\String$
          ;             \This()\Items()\Text\String$ = Text$
          ;           EndIf
      EndSelect
      
      \This()\Repaint = #True
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result.S
EndProcedure

; Получить текст 
Procedure.S GetElementText(Element)
  Protected Result.S
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If \This()\Type = #_Type_Window
        If ListSize(\This()\Items())
          SelectElement(\This()\Items(), 0)
          Result.S = \This()\Items()\Text\String$
        EndIf
      Else
        Result.S = \This()\Text\String$
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result.S
EndProcedure

Procedure SetElementData(Element, *Data)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\Data
      \This()\Data = *Data
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure GetElementData(Element)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\Data
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Установить состояние 
; Установить состояние 
Procedure.f SetWindowElementState(Element, State.f)
  Protected PostEvent.q, *Element = ElementID(Element)
  Protected Result.f, X,Y,Width,Height, Bs1,Bs2
  
  With *CreateElement
    If *Element
      PushListPosition(\This())
      ChangeCurrentElement(\This(), *Element)
      
      If ListSize(\This()\Items()) And \This()\WindowState <> State 
        SetElementData(0, Element)
        
        ; Change image maximize item
        If ChangeCurrentElement(\This()\Items(), ItemID(#E_MaximizeGadget))
          If State=#_Event_Maximize
            \This()\Items()\Img\Image = \This()\Items()\Img\Image2
          Else
            \This()\Items()\Img\Image = \This()\Items()\Img\Image1
          EndIf
        EndIf
        
        Select \This()\Type
            ; WindowElement
          Case #_Type_Window
            If \This()\WindowState=#_Event_Restore
              ;Debug "Change"
              \This()\DefaultCoordinate\X = \This()\ContainerCoordinate\X
              \This()\DefaultCoordinate\Y = \This()\ContainerCoordinate\Y
              \This()\DefaultCoordinate\Width = \This()\FrameCoordinate\Width
              \This()\DefaultCoordinate\Height = \This()\FrameCoordinate\Height
            EndIf
            \This()\WindowState = State
            Bs1=(\This()\bSize-\This()\BorderSize) 
            Bs2=Bs1*2
              
            Select State
              Case #_Event_Close   
                If ((\This()\Flag&#_Flag_CloseGadget)=#_Flag_CloseGadget)
                  PostEvent = #_Event_Close 
                EndIf
                
              Case #_Event_Restore 
                If ((\This()\Flag&#_Flag_MaximizeGadget)=#_Flag_MaximizeGadget) Or 
                   ((\This()\Flag&#_Flag_MinimizeGadget)=#_Flag_MinimizeGadget)
                  PostEvent = #_Event_Restore
                EndIf
                
              Case #_Event_Maximize
                If ((\This()\Flag&#_Flag_MaximizeGadget)=#_Flag_MaximizeGadget)
                  If \MainWindow = Element
                    SetWindowState(\CanvasWindow, #PB_Window_Maximize)
                    Width = WindowWidth(\CanvasWindow)
                    Height = WindowHeight(\CanvasWindow, #PB_Window_InnerCoordinate)-40 ;(\This()\CaptionHeight+1+\This()\bSize*2)
                  Else
                    Width = ElementWidth(\This()\Parent\Element)
                    Height = ElementHeight(\This()\Parent\Element)
                  EndIf
                  PostEvent = #_Event_Maximize 
                EndIf
                
              Case #_Event_Minimize
                If ((\This()\Flag&#_Flag_MinimizeGadget)=#_Flag_MinimizeGadget)
                  If \MainWindow = Element
                    SetWindowState(\CanvasWindow, #PB_Window_Minimize)
                    Width = 0
                    Height = 0
                  Else
                    Height = \This()\CaptionHeight
                    Y = (ElementHeight(\This()\Parent\Element)-Height-1)
                    Width = 240
                  EndIf
                  PostEvent = #_Event_Minimize  
                EndIf
            EndSelect
            
            If PostEvent=#_Event_Restore
              If \MainWindow = Element
                SetWindowState(\CanvasWindow, #PB_Window_Normal)
              EndIf
              
              ResizeElement(Element, \This()\DefaultCoordinate\X+Bs1, \This()\DefaultCoordinate\Y+Bs1, \This()\DefaultCoordinate\Width-Bs2, \This()\DefaultCoordinate\Height-Bs2)
            ElseIf PostEvent
              ResizeElement(Element, 0,Y, Width,Height)
            EndIf
        EndSelect
      EndIf
      PopListPosition(\This())
      
      If PostEvent
        PostEventElement(PostEvent, Element, PostEvent)
      EndIf
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure.f SetElementState(Element, State.f)
  Protected Parent =- 1
  Protected PostEvent.q
  Protected Result.f, X,Y,Width,Height, Value
  
  With *CreateElement
    If IsElement(Element) 
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Select \This()\Type
        Case #_Type_Image, #_Type_ButtonImage
          \This()\Img\Image = State
          
        Case #_Type_TrackBar : SetTrackBarElementState(State)
        Case #_Type_ScrollBar : SetScrollBarElementState(State)
        Case #_Type_Spin : SetSpinElementState(State)
        Case #_Type_Splitter : SetSplitterElementState(\This(), State)
        Case #_Type_ComboBox : SetComboBoxElementState(\This(), State)
          
          ; CheckBoxElement  
        Case #_Type_CheckBox
          Select State
            Case 0,1 ; #PB_Checkbox_Unchecked, #PB_Checkbox_Checked
              \This()\Checked = State
              \This()\Inbetween = #False
              
            Case - 1 ; #PB_Checkbox_Inbetween
              If \This()\ThreeState 
                \This()\Inbetween = #True
                \This()\Checked = #False
              EndIf
          EndSelect
          
          ; OptionElement
        Case #_Type_Option
          If IsElement(\This()\OptionGroup)
            PushListPosition(\This())
            ChangeCurrentElement(\This(), ElementID(\This()\OptionGroup))
            \This()\OptionGroup = Element
            PopListPosition(\This())
            PostEvent = #_Event_LeftClick
          EndIf
          
          ; WindowElement
        Case #_Type_Window
           ProcedureReturn SetWindowElementState(Element, State)
         Select State
            Case #_Flag_CloseGadget    : PostEvent = #_Event_Close 
            Case #_Flag_MinimizeGadget : PostEvent = #_Event_Minimize : \This()\MinimizeState!1 
            Case #_Flag_MaximizeGadget : PostEvent = #_Event_Maximize : \This()\MaximizeState!1
              
              If \This()\MaximizeState
                \This()\Items()\Img\Image = \This()\Items()\Img\Image2
              Else
                \This()\Items()\Img\Image = \This()\Items()\Img\Image1
              EndIf
              
          EndSelect
          
      EndSelect
      
      If \This()\Item\Selected\Element <> State : \This()\Item\Selected\Element = State
        ; PostEvent 
        Select \This()\Type
          Case #_Type_Panel, #_Type_ListView, #_Type_ListIcon, #_Type_Splitter
            PostEvent = #_Event_Change
        EndSelect
        
        Select \This()\Type
          Case #_Type_Panel : SetPanelElementState(\This(), State)
          Case #_Type_Properties
            ; Минимальная позиция сплиттера
            If State < 1 : State = 1 : EndIf
            ; Мксимальная позиция сплиттера
            If ((\This()\Flag & #_Flag_Vertical) = #_Flag_Vertical)
              If State > (\This()\InnerCoordinate\Height-\This()\Splitter\Size)
                State = (\This()\InnerCoordinate\Height-\This()\Splitter\Size)
              EndIf
            Else
              If State > (\This()\InnerCoordinate\Width-\This()\Splitter\Size)
                State = (\This()\InnerCoordinate\Width-\This()\Splitter\Size)
              EndIf
            EndIf
            
            Result = \This()\Splitter\Pos
            \This()\Splitter\Pos = State
            Value = (State+\This()\Splitter\Size)
            
            
        EndSelect
        
        \This()\Repaint = #True
      EndIf
      
      PopListPosition(\This())
      
      If PostEvent
        PostEventElement(PostEvent, Element, State)
        ;Result = CallFunctionFast_(@Windows_Events(), PostEvent, Element) 
      EndIf
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить состояние 
Procedure.f GetElementState(Element)
  Protected.f Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Select \This()\Type
        Case #_Type_CheckBox
          If \This()\Inbetween : Result =- 1 : Else : Result = \This()\Checked : EndIf
          
        Case #_Type_Image, #_Type_ButtonImage
          Result = \This()\Img\Image
          
        Case #_Type_TrackBar
          If \This()\IsVertical
            Result = ((\This()\Scroll\Max-\This()\Scroll\Min)-\This()\Scroll\Pos)
          Else
            Result = \This()\Scroll\Pos
          EndIf
          
        Case #_Type_ScrollBar
          Result = \This()\Scroll\Pos
          
        Case #_Type_Spin
          Result = \This()\Spin\Value
          
        Case #_Type_Splitter
          Result = \This()\Splitter\Pos
          
        Case #_Type_ComboBox
          Result = GetElementState(\This()\Linked\Element)
          
        Case #_Type_Panel, #_Type_ListView, #_Type_ListIcon, #_Type_Menu, #_Type_PopupMenu
          Result = \This()\Item\Selected\Element
          
      EndSelect
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure SetElementImage(Element, Image)
  Protected Result =- 1, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Select \This()\Type
        Case #_Type_Window
          If ListSize(\This()\Items())
            SelectElement(\This()\Items(), 0)
            Result = \This()\Items()\Img\Image
            \This()\Items()\Img\Image = Image
          EndIf
          
        Default
          Result = \This()\Img\Image
          \This()\Img\Image = Image  
      EndSelect
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure GetElementImage(Element)
  Protected Result =- 1, *Element = ElementID(Element)
  
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      Result = \This()\Img\Image     
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

;  
Procedure SetElementToolTip(Element, Text$ = "", Mode = 0)
  ;Protected.S Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      \This()\ToolTip\String$ = Text$
      
      If Text$
      Else
        If ListSize(\This()\Items())
          ForEach \This()\Items()
            \This()\Items()\ToolTip\String$ = \This()\Items()\Text\String$
          Next
        EndIf  
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ;ProcedureReturn Result
EndProcedure

Procedure.S GetElementToolTip(Element, Item =- 1)
  Protected.S Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\ToolTip\String$ 
      ;       Else
      ;         If ListSize(\This()\Items())
      ;           ForEach \This()\Items()
      ;             \This()\Items()\ToolTip\String$ = \This()\Items()\Text\String$
      ;           Next
      ;         EndIf  
      ;       EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure



;-
; Установить текст итема
Procedure.S SetElementItemText(Element, ElementItem, Text$)
  Protected Result.S
  
  With *CreateElement
    PushListPosition(\This()) 
    If IsElement(Element)
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      If IsElementItem(ElementItem)
        ChangeCurrentElement(\This()\Items(), ItemID(ElementItem))
        
        Result.S = \This()\Items()\Text\String$
        \This()\Items()\Text\String$ = Text$
        
        \This()\Repaint = #True
      EndIf
    EndIf
    PopListPosition(\This())
  EndWith
  
  ProcedureReturn Result.S
EndProcedure

; Получить текст итема
Procedure.S GetElementItemText(Element, ElementItem = #PB_All)
  Protected Result.S
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      If IsElementItem(ElementItem)
        ChangeCurrentElement(\This()\Items(), ItemID(ElementItem))
        Result.S = \This()\Items()\Text\String$
        
      Else
        If IsElementItem((\This()\Item\Entered\Element))
          ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Entered\Element))
          Result.S = \This()\Items()\Text\String$
        Else
          If IsElementItem((\This()\Item\Selected\Element))
            ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Selected\Element))
            Result.S = \This()\Items()\Text\String$
          EndIf
        EndIf
      EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result.S
EndProcedure

Procedure SetElementItemData(Element, Item, *Data)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      If IsElementItem(Item)
        ChangeCurrentElement(\This()\Items(), ItemID(Item))
        Result = \This()\Items()\Data
        \This()\Items()\Data = *Data
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure GetElementItemData(Element, Item)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      If IsElementItem(Item)
        ChangeCurrentElement(\This()\Items(), ItemID(Item))
        Result = \This()\Items()\Data
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetElementItemState(Element, ElementItem, State)
  Protected Type, Result.f =- 1
  
  With *CreateElement
    PushListPosition(\This()) 
    If IsElement(Element)
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      Type = \This()\Type
      
      If IsElementItem(ElementItem)
        ChangeCurrentElement(\This()\Items(), ItemID(ElementItem))
        
        Select Type
          Case #_Type_ListIcon
            If ((State&#PB_ListIcon_Selected) = #PB_ListIcon_Selected)
              \This()\Item\Selected\Element = ElementItem
            EndIf
            
            If ((State&#PB_ListIcon_Checked) = #PB_ListIcon_Checked)
              \This()\Items()\Checked = #True
              \This()\Items()\Inbetween = #False
            EndIf
            
            If ((State&#PB_ListIcon_Inbetween) = #PB_ListIcon_Inbetween)
              If \This()\ThreeState 
                \This()\Items()\Inbetween = #True
                \This()\Items()\Checked = #False
              EndIf
            EndIf
        EndSelect
        
      EndIf
      
    EndIf
    PopListPosition(\This())
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить текст итема
Procedure.f GetElementItemState(Element, ElementItem = #PB_All)
  Protected Type, Result.f =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      Type = \This()\Type
      
      If IsElementItem(ElementItem)
        ChangeCurrentElement(\This()\Items(), ItemID(ElementItem))
      Else
        If IsElementItem((\This()\Item\Entered\Element))
          ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Entered\Element))
        ElseIf IsElementItem((\This()\Item\Selected\Element))
          ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Selected\Element))
        EndIf
      EndIf
      
      Select Type
        Case #_Type_ListIcon
          If \This()\Items()\Inbetween 
            Result =- 1 
          Else 
            Result = \This()\Items()\Checked 
          EndIf
          
          ;           If \This()\Items()\ThreeState 
          ;             Result = \This()\Items()\Inbetween
          ;           Else
          ;             Result = \This()\Items()\Checked
          ;           EndIf
      EndSelect
      
      
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetElementItemImage(Element, ElementItem, Image)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      If IsElementItem(ElementItem)
        ChangeCurrentElement(\This()\Items(), ItemID(ElementItem))
        Result = \This()\Items()\Img\Image
      Else
        If IsElementItem((\This()\Item\Entered\Element))
          ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Entered\Element))
          Result = \This()\Items()\Img\Image
        Else
          If IsElementItem((\This()\Item\Selected\Element))
            ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Selected\Element))
            Result = \This()\Items()\Img\Image
          EndIf
        EndIf
      EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure GetElementItemImage(Element, ElementItem = #PB_All)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If IsElement(\This()\Linked\Element)
        ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
      EndIf
      
      If IsElementItem(ElementItem)
        ChangeCurrentElement(\This()\Items(), ItemID(ElementItem))
        Result = \This()\Items()\Img\Image
      Else
        If IsElementItem((\This()\Item\Entered\Element))
          ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Entered\Element))
          Result = \This()\Items()\Img\Image
        Else
          If IsElementItem((\This()\Item\Selected\Element))
            ChangeCurrentElement(\This()\Items(), ItemID(\This()\Item\Selected\Element))
            Result = \This()\Items()\Img\Image
          EndIf
        EndIf
      EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure SetElementBackGroundImage(Element, Image)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\Img\ImgBg
      \This()\Img\ImgBg = Image
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure  

Procedure GetElementBackGroundImage(Element)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\Img\ImgBg
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure  



;-  
; Перемещать\растягивать элемент
Procedure ResizeElementX(List This.S_CREATE_ELEMENT(), X = #PB_Ignore)
  Protected bSize
  Protected bSize2
  Protected ParentX
  Protected ParentWidth
  Protected iParentX
  Protected iParentWidth
  Protected ParentInnerX
  
  With This()
    If (X<>#PB_Ignore)
      \InnerCoordinate\X = (\FrameCoordinate\X+\bSize)
      \X = \FrameCoordinate\X
      \iX = \InnerCoordinate\X
      
      If IsElement(\Window)
        PushListPosition(This())
        ChangeCurrentElement(This(), ElementID(\Window)) 
        ParentInnerX = \InnerCoordinate\X
        PopListPosition(This())
        \WindowCoordinate\X = (\FrameCoordinate\X-ParentInnerX)
      EndIf
    Else
      \InnerCoordinate\Width = (\FrameCoordinate\Width-\bSize*2)
      \Width = \FrameCoordinate\Width
      \iWidth = \InnerCoordinate\Width
    EndIf
    
    If IsElement(\Parent\Element)
      PushListPosition(This())
      ChangeCurrentElement(This(), ElementID(\Parent\Element)) 
      bSize = (\InnerCoordinate\X-\bSize)-\X : If bSize < 0 : bSize =- \bSize : EndIf
      bSize2 = ((\InnerCoordinate\X+\bSize+\InnerCoordinate\Width))-(\X+\Width) : If bSize2 > 0 : bSize2 =- \bSize : EndIf
      
      ParentInnerX = \InnerCoordinate\X
      ParentX = (\X+\bSize)+bSize
      ParentWidth = (\Width-\bSize*2)-(bSize+bSize2)
      iParentX = \iX
      iParentWidth = \iWidth
      PopListPosition(This())
      If (X<>#PB_Ignore) : \ContainerCoordinate\X = (\FrameCoordinate\X-ParentInnerX) : EndIf
    Else
      ParentX = \X 
      ParentWidth = \Width
      iParentX = \iX 
      iParentWidth = \iWidth
    EndIf
    
    ; Определяем размеры для рисования
    If (\X < ParentX) : \X = ParentX : EndIf
    \Width = (\FrameCoordinate\Width-(\X-\FrameCoordinate\X))
    If ((\X+\Width) > (ParentX+ParentWidth)) : \Width = (ParentWidth-(\X-ParentX)) : EndIf
    
    If (\iX < iParentX) : \iX = iParentX : EndIf
    \iWidth = (\InnerCoordinate\Width-(\iX-\InnerCoordinate\X))
    If ((\iX+\iWidth) > (iParentX+iParentWidth)) : \iWidth = (iParentWidth-(\iX-iParentX)) : EndIf
    
    
  EndWith
  
EndProcedure
Procedure ResizeElementY(List This.S_CREATE_ELEMENT(), Y = #PB_Ignore)
  Protected bSize,bSize2, CaptionHeight
  Protected ParentY
  Protected ParentHeight
  Protected iParentY
  Protected iParentHeight
  Protected ParentInnerY
  
  With This()
    If (Y<>#PB_Ignore)
      \InnerCoordinate\Y = (\FrameCoordinate\Y)+(\CaptionHeight+\MenuHeight+\ToolBarHeight) +\bSize
      \Y = \FrameCoordinate\Y
      \iY = \InnerCoordinate\Y
      
      If IsElement(\Window)
        PushListPosition(This())
        ChangeCurrentElement(This(), ElementID(\Window)) 
        ParentInnerY = \InnerCoordinate\Y
        PopListPosition(This())
        \WindowCoordinate\Y = (\FrameCoordinate\Y-ParentInnerY)
      EndIf
    Else
      \InnerCoordinate\Height = (\FrameCoordinate\Height-\bSize*2)-(\CaptionHeight+\MenuHeight+\ToolBarHeight) - \StatusBarHeight
      \Height = \FrameCoordinate\Height
      \iHeight = \InnerCoordinate\Height
    EndIf
    If IsElement(\Parent\Element)
      PushListPosition(This()) 
      ChangeCurrentElement(This(), ElementID(\Parent\Element))
      ParentInnerY = \InnerCoordinate\Y
      bSize = (ParentInnerY-\bSize)-\Y : If bSize < 0 : bSize =- \bSize : EndIf
      bSize2 = ((ParentInnerY+\bSize+\InnerCoordinate\Height))-(\Y+\Height) : If bSize2 > 0 : bSize2 =- \bSize : EndIf
      
      ParentY = (\Y+\bSize)+bSize
      ParentHeight = (\Height-\bSize*2)-(bSize+bSize2)
      PopListPosition(This())
      If Y<>#PB_Ignore : \ContainerCoordinate\Y = (\FrameCoordinate\Y-ParentInnerY) : EndIf
    Else
      ParentY = \Y
      ParentHeight = \Height
    EndIf
    
    ; Определяем размеры для рисования
    If IsElement(\Parent\Element) 
      Protected h, Type = \Type
      Select Type 
        Case #_Type_Menu, #_Type_Toolbar, #_Type_StatusBar
          ;\FrameCoordinate\Height = 20
          PushListPosition(This())
          ChangeCurrentElement(This(), ElementID(\Parent\Element)) 
          If \CaptionHeight =  1
          EndIf
          
          If Type = #_Type_Toolbar : h = \ToolBarHeight + 1 : EndIf
          If Type = #_Type_Menu : h = (\MenuHeight+\ToolBarHeight) + 1 : EndIf
          If Type = #_Type_StatusBar : h = (\StatusBarHeight) : EndIf
          PopListPosition(This())
      EndSelect
    EndIf
    
    If (\Y < ParentY) : \Y = ParentY-h : EndIf
    \Height = \FrameCoordinate\Height - (\Y-\FrameCoordinate\Y)
    If ((\Y+\Height) > (ParentY+ParentHeight)) : \Height = (ParentHeight-(\Y-(ParentY-h))) : EndIf
    
  EndWith
  
EndProcedure
Procedure AvtoResizeElement(List This.S_CREATE_ELEMENT(), Element, Parent, MenuHeight = 0)
  Protected Result =- 1
  Protected pX, pY, pWidth, pHeight
  Protected Left,Top,Right,Bottom,Client
  
  With This()
    If IsElement(Element)
      PushListPosition(This()) 
      ChangeCurrentElement(This(), ElementID(Element))
      Protected Type = \Type
      If \IsAlign And \Parent\Element = Parent ; 
                                               ; Get parent coordinates
        If \Element 
          If IsElement(\Parent\Element)
            PushListPosition(This()) 
            ChangeCurrentElement(This(), ElementID(\Parent\Element))
            pX = \InnerCoordinate\X
            pY = \InnerCoordinate\Y;\FrameCoordinate\Y+\bSize ; 
            pWidth = \InnerCoordinate\Width
            
            If Type = #_Type_StatusBar
              pHeight = \InnerCoordinate\Height+\StatusBarHeight
            Else
              pHeight = \InnerCoordinate\Height    ;  +\MenuHeight+\CaptionHeight-\StatusBarHeight
            EndIf
            
            Left = \Left
            Top = \Top
            Right = \Right
            Bottom = \Bottom
            PopListPosition(This()) 
          EndIf
        Else
          pX = 0
          pY = 0
          pWidth = GadgetWidth(*CreateElement\Canvas)
          pHeight = GadgetHeight(*CreateElement\Canvas)
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft) And
           (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
          \FrameCoordinate\X = pX+\Left ; #_Flag_DockLeft
          \FrameCoordinate\Y = pY+\Top  ; #_Flag_DockTop
        ElseIf (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft)
          \FrameCoordinate\X = pX +\Left ; #_Flag_AlignLeft with Spacing
          \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height)/2)
        ElseIf (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
          \FrameCoordinate\Y = pY +\Top ; #_Flag_AlignTop with Spacing
          \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width)/2)
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignRight = #_Flag_AlignRight)
          If (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft)
            \FrameCoordinate\X = pX
            \FrameCoordinate\Width = pWidth
          Else
            \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width))-\Right ; #_Flag_DockRight 
            If (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
              \FrameCoordinate\Y = pY +\Top ; #_Flag_AlignTop|#_Flag_AlignRight with Spacing
            ElseIf (\Flag & #_Flag_AlignBottom = #_Flag_AlignBottom)
              \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height)) -\Bottom ; #_Flag_AlignBottom with Spacing
            Else
              \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height)/2)
            EndIf  
          EndIf
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignBottom = #_Flag_AlignBottom)
          If (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
            \FrameCoordinate\Y = pY + Top
            \FrameCoordinate\Height = pHeight - (Top+Bottom) 
          Else
            \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height))-\Bottom ; #_Flag_DockBottom 
            If (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft)
              \FrameCoordinate\X = pX ;+\Left ; #_Flag_AlignLeft|#_Flag_AlignBottom with Spacing
            ElseIf (\Flag & #_Flag_AlignRight = #_Flag_AlignRight)
              \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width)) -\Right ; #_Flag_AlignRight with Spacing
            Else
              \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width)/2)
            EndIf  
          EndIf
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignCenter = #_Flag_AlignCenter)
          \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width)/2)
          \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height)/2)
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignFull = #_Flag_AlignFull)
          \FrameCoordinate\X = pX
          \FrameCoordinate\Y = pY
          \FrameCoordinate\Width = pWidth
          \FrameCoordinate\Height = pHeight
        EndIf
        
        ;
        If (\Flag & #_Flag_DockClient = #_Flag_DockClient)
          \FrameCoordinate\X = pX+Left
          \FrameCoordinate\Y = pY+Top
          \FrameCoordinate\Width = pWidth-(Left+Right)
          \FrameCoordinate\Height = pHeight-(Top+Bottom)
        EndIf
      EndIf
      
      ;\FrameCoordinate\Y - MenuHeight
      
      ResizeElementX(This(), \FrameCoordinate\X)
      ResizeElementY(This(), \FrameCoordinate\Y)
      ResizeElementX(This())
      ResizeElementY(This())
      
      If \IsContainer
        ResizeElement(\Element, #PB_Ignore, #PB_Ignore, \FrameCoordinate\Width+1,\FrameCoordinate\Height+1, #_Element_ScreenCoordinate)
        ResizeElement(\Element, #PB_Ignore, #PB_Ignore, \FrameCoordinate\Width-1,\FrameCoordinate\Height-1, #_Element_ScreenCoordinate)
      EndIf
      
      PopListPosition(This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure
Procedure _AvtoResizeElement(List This.S_CREATE_ELEMENT(), Element, Parent)
  Protected Result =- 1
  Protected pX, pY, pWidth, pHeight
  Protected Left,Top,Right,Bottom,Client
  
  With This()
    If IsElement(Element)
      PushListPosition(This()) 
      ChangeCurrentElement(This(), ElementID(Element))
      
      If \IsAlign And \Parent\Element = Parent ; 
                                               ; Get parent coordinates
        If \Element 
          If IsElement(\Parent\Element)
            PushListPosition(This()) 
            ChangeCurrentElement(This(), ElementID(\Parent\Element))
            pX = \InnerCoordinate\X
            pY = \InnerCoordinate\Y
            pWidth = \InnerCoordinate\Width
            pHeight = \InnerCoordinate\Height
            
            Left = \Left
            Top = \Top
            Right = \Right
            Bottom = \Bottom
            PopListPosition(This()) 
          EndIf
        Else
          pX = 0
          pY = 0
          pWidth = GadgetWidth(*CreateElement\Canvas)
          pHeight = GadgetHeight(*CreateElement\Canvas)
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft) And
           (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
          \FrameCoordinate\X = pX+\Left ; #_Flag_DockLeft
          \FrameCoordinate\Y = pY+\Top  ; #_Flag_DockTop
        ElseIf (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft)
          \FrameCoordinate\X = pX
          \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height)/2)
        ElseIf (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
          \FrameCoordinate\Y = pY
          \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width)/2)
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignRight = #_Flag_AlignRight)
          If (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft)
            \FrameCoordinate\X = pX
            \FrameCoordinate\Width = pWidth
          Else
            \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width))-\Right ; #_Flag_DockRight 
            If (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
              \FrameCoordinate\Y = pY
            ElseIf (\Flag & #_Flag_AlignBottom = #_Flag_AlignBottom)
              \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height))
            Else
              \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height)/2)
            EndIf  
          EndIf
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignBottom = #_Flag_AlignBottom)
          If (\Flag & #_Flag_AlignTop = #_Flag_AlignTop)
            \FrameCoordinate\Y = pY + Top
            \FrameCoordinate\Height = pHeight - (Top+Bottom) 
          Else
            \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height))-\Bottom ; #_Flag_DockBottom 
            If (\Flag & #_Flag_AlignLeft = #_Flag_AlignLeft)
              \FrameCoordinate\X = pX
            ElseIf (\Flag & #_Flag_AlignRight = #_Flag_AlignRight)
              \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width))
            Else
              \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width)/2)
            EndIf  
          EndIf
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignCenter = #_Flag_AlignCenter)
          \FrameCoordinate\X = (pX+(pWidth-\FrameCoordinate\Width)/2)
          \FrameCoordinate\Y = (pY+(pHeight-\FrameCoordinate\Height)/2)
        EndIf
        
        ;
        If (\Flag & #_Flag_AlignFull = #_Flag_AlignFull)
          \FrameCoordinate\X = pX
          \FrameCoordinate\Y = pY
          \FrameCoordinate\Width = pWidth
          \FrameCoordinate\Height = pHeight
        EndIf
        
        If (\Flag & #_Flag_DockClient = #_Flag_DockClient)
          \FrameCoordinate\X = pX+Left
          \FrameCoordinate\Y = pY+Top
          \FrameCoordinate\Width = pWidth-(Left+Right)
          \FrameCoordinate\Height = pHeight-(Top+Bottom)
        EndIf
      EndIf
      
      ResizeElementX(This(), \FrameCoordinate\X)
      ResizeElementY(This(), \FrameCoordinate\Y)
      ResizeElementX(This())
      ResizeElementY(This())
      
      If \IsContainer
        ResizeElement(\Element, #PB_Ignore, #PB_Ignore, \FrameCoordinate\Width+1,\FrameCoordinate\Height+1, #_Element_ScreenCoordinate)
        ResizeElement(\Element, #PB_Ignore, #PB_Ignore, \FrameCoordinate\Width-1,\FrameCoordinate\Height-1, #_Element_ScreenCoordinate)
      EndIf
      
      PopListPosition(This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Declare _DrawingElement(List This.S_CREATE_ELEMENT(), X = 0,Y = 0)
Procedure ResizeListElement(List This.S_CREATE_ELEMENT(), Element, X,Y,Width,Height, Flag.q) 
  Protected Result
  Protected ParentX,ParentY,ParentWidth,ParentHeight
  Protected ChangeX,ChangeY,ChangeWidth,ChangeHeight
  Protected Type, Parent, iX, iY, iWidth, iHeight
  
  With This()
    PushListPosition(This()) 
    ChangeCurrentElement(This(), ElementID(Element))
    ;     If #PB_Ignore = X : X = \FrameCoordinate\X : EndIf
    ;     If #PB_Ignore = Y : Y = \FrameCoordinate\Y : EndIf
    ;     If #PB_Ignore = Width :Width = \FrameCoordinate\Width : EndIf
    ;     If #PB_Ignore = Height : Height = \FrameCoordinate\Height : EndIf
    ;     
    ;     ; X-\bSize : Y-\bSize : Width+\bSize*2 : Height+\bSize*2
    
    ;     If #PB_Ignore <> X : X+(\bSize-\BorderSize): EndIf
    ;     If #PB_Ignore <> Y : Y+(\bSize-\BorderSize): EndIf
    ;     If #PB_Ignore <> Width : Width-((\bSize-\BorderSize)*2): EndIf
    ;     If #PB_Ignore <> Height : Height-((\bSize-\BorderSize)*2): EndIf
    
    
; ; ;     If ((Flag & #_Element_ContainerCoordinate) = #_Element_ContainerCoordinate)
; ; ;       If #PB_Ignore = X
; ; ;         X = \ContainerCoordinate\X+(\bSize-\BorderSize)
; ; ;       EndIf
; ; ;       If #PB_Ignore = Y
; ; ;         Y = \ContainerCoordinate\Y+(\bSize-\BorderSize)
; ; ;       EndIf
; ; ;     EndIf
    
    If Flag.q<>#PB_Ignore And IsElement(\Parent\Element) ; Если есть родитель добавляем и его координаты
      PushListPosition(This()) 
      ChangeCurrentElement(This(), ElementID(\Parent\Element))
      
      If ((Flag & #_Element_WindowCoordinate) = #_Element_WindowCoordinate)
        ChangeCurrentElement(This(), ElementID(\Window))
      ElseIf ((Flag & #_Element_ScreenCoordinate) = #_Element_ScreenCoordinate)
        SelectElement(This(), 0)
      EndIf
      
      If #PB_Ignore <> X : X + \InnerCoordinate\X : EndIf
      If #PB_Ignore <> Y : Y + \InnerCoordinate\Y : EndIf
      
      PopListPosition(This())
    EndIf
    
    If #PB_Ignore <> X And (X-(\bSize-\BorderSize) <> \FrameCoordinate\X Or Flag.q = #PB_Ignore) 
      X-(\bSize-\BorderSize)
      ChangeX = (\InnerCoordinate\X - (X+\bSize)) : \FrameCoordinate\X = X
      ResizeElementX(This(), X)
      Result = #True
    EndIf
    
    If #PB_Ignore <> Y And (Y-(\bSize-\BorderSize) <> \FrameCoordinate\Y Or Flag.q = #PB_Ignore)
      Y-(\bSize-\BorderSize)
      ;       ChangeY = (\InnerCoordinate\Y - (Y+(\CaptionHeight+\MenuHeight+\ToolBarHeight+\bSize))) : \FrameCoordinate\Y = Y 
      ChangeY = (\FrameCoordinate\Y - Y) : \FrameCoordinate\Y = Y 
      ResizeElementY(This(), Y)
      Result = #True
    EndIf
    If #PB_Ignore <> Width And (Width+(\bSize-\BorderSize)*2 <> \FrameCoordinate\Width Or Flag.q = #PB_Ignore)
      Width+(\bSize-\BorderSize)*2
      
      ChangeWidth = (\FrameCoordinate\Width+\bSize*2 - (Width-\bSize*2)) : \FrameCoordinate\Width = Width
      ResizeElementX(This())
      ParentWidth = \FrameCoordinate\Width
      Result = #True
    EndIf
    If #PB_Ignore <> Height And (Height+(\bSize-\BorderSize)*2 <> \FrameCoordinate\Height Or Flag.q = #PB_Ignore)
      Height+(\bSize-\BorderSize)*2
      
      ChangeHeight = (\FrameCoordinate\Height+\bSize*2 - (Height-\bSize*2)) : \FrameCoordinate\Height = Height
      ResizeElementY(This())
      ParentHeight = \FrameCoordinate\Height
      Result = #True
    EndIf
    
    iX = \InnerCoordinate\X : iY = \InnerCoordinate\Y : iWidth = \InnerCoordinate\Width : iHeight = \InnerCoordinate\Height
    
    UpdateScrolls(This())
    
    ;Debug GetElementState(Element)
    ;SetSplitterElementState(Element, GetElementState(Element))
    
    
    ; Это должно происходить если есть дети
    If Result And \Childrens
      Type = \Type
      Parent = \Parent\Element
      iWidth = \InnerCoordinate\Width
      iHeight = \InnerCoordinate\Height
      
      If \Type = #_Type_Splitter
        Protected Max
        Protected IsVertical = Bool(((\Flag&#_Flag_Vertical) = #_Flag_Vertical))
        Protected FirstElement = \Splitter\FirstElement
        Protected SecondElement = \Splitter\SecondElement
        Protected FirstFixed = \Splitter\FirstFixed
        Protected SecondFixed = \Splitter\SecondFixed
        
        
        If IsVertical : Max = iWidth : Else : Max = iHeight : EndIf
        
        If \Splitter\StatePercent
          If \Splitter\FirstFixed
            SetElementState(\Element, \Splitter\StatePercent) 
          ElseIf \Splitter\SecondFixed
            SetElementState(\Element, Max-\Splitter\StatePercent)
          Else
            SetElementState(\Element, (Max)/2-\Splitter\StatePercent)
          EndIf
        EndIf
                
        Protected State = (\Splitter\Pos+\Splitter\Size+\bSize*2); -1
      EndIf
      
      
      PushListPosition(This())
      While NextElement(This()) ; Использовали цикл While а не Repeat, что бы пропустить первый элемент (то есть перемещаемый)
        
        If IsChildElement(\Element, Element) 
          If \IsAlign And (ChangeWidth + ChangeHeight) 
            AvtoResizeElement(This(), \Element, Element)
          Else
            If ChangeX : \FrameCoordinate\X - ChangeX
              ResizeElementX(This(), (\FrameCoordinate\X+ChangeX))
            EndIf
            If ChangeY : \FrameCoordinate\Y - ChangeY
              ResizeElementY(This(), (\FrameCoordinate\Y+ChangeY))
            EndIf
            
            If Type = #_Type_Container ; Если изменили в размерах дитья сплиттера
              If ElementType(Parent) = #_Type_Splitter 
                If Bool(((GetElementFlag(Parent)&#_Flag_Vertical) = #_Flag_Vertical))
                  \FrameCoordinate\Width = iWidth
                Else
                  \FrameCoordinate\Height = iHeight
                EndIf
              EndIf
            ElseIf Type = #_Type_Splitter 
              
              ;Debug "Resize e = "+Str(Element)+" t = "+ElementClass(\Type)
              
              
              ;               If ((FirstElement = \Element) Or (SecondElement = \Element))
              ;                 If IsVertical
              ;                   If ChangeHeight : \FrameCoordinate\Height = iHeight : EndIf
              ;                 Else
              ;                   If ChangeWidth : \FrameCoordinate\Width = iWidth : EndIf
              ;                 EndIf
              ;               EndIf
              
              If ((SecondElement = \Element)) ; (FirstElement = \Element) ; Or 
                PushListPosition(This())
                ChangeCurrentElement(This(), ElementID(\Parent\Element))
                If \Splitter\Pos = 0
                  SetElementState(\Element, 80)
                Else
                  SetElementState(\Element, (\Splitter\Pos))
                EndIf
                PopListPosition(This())
              EndIf
              
              
            EndIf
            
            If ChangeWidth : ResizeElementX(This()) : EndIf
            If ChangeHeight : ResizeElementY(This()) : EndIf
          EndIf
          
          ;           ;ChangeCurrentElement(This(), ElementID(\Element))
          ;           If \Type = #_Type_ScrollBar
          ;             If \Item\Parent
          ;               If \IsVertical
          ;                 SetScrollBarElementAttribute(This(), #PB_ScrollBar_PageLength, \FrameCoordinate\Height)
          ;               Else
          ;                 SetScrollBarElementAttribute(This(), #PB_ScrollBar_PageLength, \FrameCoordinate\Width)
          ;               EndIf
          ;             EndIf
          ;           EndIf
          
        EndIf
      Wend
      PopListPosition(This())
    EndIf
    
    If Flag.q<>#PB_Ignore
      If (ChangeX Or ChangeY) ; Moving
        ElementCallBack(#_Event_Move, Element)
      EndIf
      If (ChangeWidth Or ChangeHeight) ; Sising
        ElementCallBack(#_Event_Size, Element)
      EndIf
      
      ;       If (ChangeX Or ChangeY) ; Moving
      ;         PostEventElement(#_Event_Move, Element)
      ;       EndIf
      ;       If (ChangeWidth Or ChangeHeight) ; Sising
      ;         PostEventElement(#_Event_Size, Element)
      ;       EndIf
      ;       If BeginDrawing()
      ;         ;UpdateDrawingContent()
      ;         ForEach This()
      ;           _DrawingElement(This())
      ;         Next
      ;         EndDrawing()
      ;       EndIf
    EndIf
    
    PopListPosition(This())
  EndWith
  
  ProcedureReturn Result
EndProcedure
Procedure ResizeElement(Element, X,Y,Width,Height, Flag.q = #_Element_ContainerCoordinate) 
  Protected Result 
  
  With *CreateElement
    If IsElement(Element)
      Protected X1 
      Protected Y1
      
      If \MainWindow = Element
        ;Debug "Resize main element "+Element
        ResizeWindow(\CanvasWindow, X,Y,Width,Height)
        ResizeGadget(\Canvas, #PB_Ignore, #PB_Ignore,Width,Height)
      Else
        ;Debug "Resize element "+Element
      EndIf
      
      
      Result = ResizeListElement(\This(), Element, X,Y,Width,Height, Flag)
      
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      If \This()\Type = #_Type_ScrollBar
        If \This()\Item\Parent
          If \This()\IsVertical
            SetScrollBarElementAttribute(\This(), #PB_ScrollBar_PageLength, Height)
          Else
            SetScrollBarElementAttribute(\This(), #PB_ScrollBar_PageLength, Width)
          EndIf
        EndIf
      EndIf
      PopListPosition(\This())
      
      ProcedureReturn 
      If IsElement(\This()\Element) 
        If \This()\ToolBarHeight
          ;X1 = (\This()\FrameCoordinate\Y)
          Y1 = (\This()\InnerCoordinate\Y-\This()\ToolBarHeight)
          PushListPosition(\This())
          NextElement(\This())
          NextElement(\This())
          
          If IsToolbarElement(\This()\Element)
            \This()\FrameCoordinate\Y = Y1
            
            ResizeElementY(\This(), \This()\FrameCoordinate\Y)
            
            \This()\Y = Y1
            \This()\Width = \This()\FrameCoordinate\Width
            \This()\Height = \This()\FrameCoordinate\Height
          EndIf
          
          PopListPosition(\This())
        EndIf
        
        If \This()\MenuHeight
          Y1 = (\This()\InnerCoordinate\Y-\This()\MenuHeight-\This()\ToolBarHeight)
          
          PushListPosition(\This())
          NextElement(\This())
          
          If IsMenuElement(\This()\Element)
            ResizeElementY(\This(), \This()\FrameCoordinate\Y)
            
            \This()\Y = Y1
            \This()\Width = \This()\FrameCoordinate\Width
            \This()\Height = \This()\FrameCoordinate\Height
            
            \This()\FrameCoordinate\Y = Y1
          EndIf
          PopListPosition(\This())
        EndIf
      EndIf
      
      
      ;       Protected MenuHeight = (\This()\MenuHeight+\This()\ToolBarHeight)
      ;       
      ;       PushListPosition(\This())
      ;       ForEach \This()
      ;         If \This()\Element 
      ;           If Element = \This()\Element 
      ;           Continue
      ;         EndIf
      ;         
      ;         If IsChildElement(\This()\Element, Element) And 
      ;            \CreateMenuElement <> \This()\Element And 
      ;            \CreatePopupMenuElement <> \This()\Element And 
      ;            \CreateToolBarElement <> \This()\Element
      ;           
      ;           ResizeElement(\This()\Element,#PB_Ignore,\This()\FrameCoordinate\Y+MenuHeight,#PB_Ignore,#PB_Ignore, #PB_Ignore)
      ;         EndIf
      ;         EndIf
      ;       Next
      ;       PopListPosition(\This())
      ;       
      
      
    EndIf
  EndWith
  
EndProcedure

Procedure _AlignmentElement(Element.i, Flag.q, NearElement.i =- 1, Spacing.b = 0)
  Protected Left,Top,Right,Bottom,Client
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This())
      
      If ((Flag & #_Flag_AlignLeft) = #_Flag_AlignLeft) Or 
         ((Flag & #_Flag_AlignTop) = #_Flag_AlignTop) Or 
         ((Flag & #_Flag_AlignRight) = #_Flag_AlignRight) Or 
         ((Flag & #_Flag_AlignBottom) = #_Flag_AlignBottom) Or 
         ((Flag & #_Flag_AlignCenter) = #_Flag_AlignCenter) Or 
         ((Flag & #_Flag_AlignFull) = #_Flag_AlignFull) Or 
         ((Flag & #_Flag_DockClient) = #_Flag_DockClient)
        
        \This()\Flag | Flag
        
        ; Dock
        PushListPosition(\This()) 
        Protected X = \This()\ContainerCoordinate\X ; 
        Protected Y = \This()\ContainerCoordinate\Y
        If Spacing
          X = Spacing
          Y = Spacing
        EndIf
        
        ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
        Left = \This()\Left;+X
        Top = \This()\Top  ;+Y
        Right = \This()\Right;+X
        Bottom = \This()\Bottom;+Y
        
        ; Будем реализовывать отступи
        If ((Flag & #_Flag_DockLeft) = #_Flag_DockLeft)
          ;           Left + X
        EndIf
        If ((Flag & #_Flag_DockTop) = #_Flag_DockTop)
          ;           Top + Y
        EndIf
        If ((Flag & #_Flag_DockRight) = #_Flag_DockRight)
          ;           Right + X
        EndIf
        If ((Flag & #_Flag_DockBottom) = #_Flag_DockBottom)
          ;           Bottom + Y
        EndIf
        
        PopListPosition(\This())
        
        \This()\Left = Left
        \This()\Top = Top
        \This()\Right = Right
        \This()\Bottom = Bottom
        
        
        If ((\This()\Flag & #_Flag_DockLeft) = #_Flag_DockLeft)
          Left + \This()\FrameCoordinate\Width
        EndIf
        If ((\This()\Flag & #_Flag_DockTop) = #_Flag_DockTop)
          Top + \This()\FrameCoordinate\Height
        EndIf
        If ((\This()\Flag & #_Flag_DockRight) = #_Flag_DockRight)
          Right + \This()\FrameCoordinate\Width
        EndIf
        If ((\This()\Flag & #_Flag_DockBottom) = #_Flag_DockBottom)
          Bottom + \This()\FrameCoordinate\Height
        EndIf
        
        PushListPosition(\This()) 
        ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
        \This()\Left = Left
        \This()\Top = Top
        \This()\Right = Right
        \This()\Bottom = Bottom
        
        ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore,
                      \This()\FrameCoordinate\Width,
                      \This()\FrameCoordinate\Height, #PB_Ignore)
        PopListPosition(\This())
        
        If ((Flag & #_Flag_AlignLeft) = #_Flag_AlignLeft) 
          \This()\Left = X
        EndIf
        
        If ((Flag & #_Flag_AlignTop) = #_Flag_AlignTop)
          \This()\Top = Y
        EndIf
        
        If ((Flag & #_Flag_AlignRight) = #_Flag_AlignRight) 
          \This()\Right = X
        EndIf
        
        If ((Flag & #_Flag_AlignBottom) = #_Flag_AlignBottom)
          \This()\Bottom = Y
        EndIf
        
        \This()\IsAlign = #True
        AvtoResizeElement(\This(), Element, \This()\Parent\Element)
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
EndProcedure
Procedure AlignmentElement(Element.i, Flag.q, NearElement.i =- 1, Spacing.b = 0)
  Protected Left,Top,Right,Bottom,Client
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This())
      
      If ((\This()\Flag & #_Flag_AlignLeft) = #_Flag_AlignLeft) Or 
         ((\This()\Flag & #_Flag_AlignTop) = #_Flag_AlignTop) Or 
         ((\This()\Flag & #_Flag_AlignRight) = #_Flag_AlignRight) Or 
         ((\This()\Flag & #_Flag_AlignBottom) = #_Flag_AlignBottom) Or 
         ((\This()\Flag & #_Flag_AlignCenter) = #_Flag_AlignCenter) Or 
         ((\This()\Flag & #_Flag_AlignFull) = #_Flag_AlignFull) Or 
         ((\This()\Flag & #_Flag_DockClient) = #_Flag_DockClient)
        
        \This()\Flag | Flag
        
        ; Dock
        PushListPosition(\This()) 
        ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
        Left = \This()\Left
        Top = \This()\Top
        Right = \This()\Right
        Bottom = \This()\Bottom
        PopListPosition(\This())
        
        \This()\Left = Left
        \This()\Top = Top
        \This()\Right = Right
        \This()\Bottom = Bottom
        
        If ((\This()\Flag & #_Flag_DockLeft) = #_Flag_DockLeft)
          Left + \This()\FrameCoordinate\Width
        EndIf
        If ((\This()\Flag & #_Flag_DockTop) = #_Flag_DockTop)
          Top + \This()\FrameCoordinate\Height
        EndIf
        If ((\This()\Flag & #_Flag_DockRight) = #_Flag_DockRight)
          Right + \This()\FrameCoordinate\Width
        EndIf
        If ((\This()\Flag & #_Flag_DockBottom) = #_Flag_DockBottom)
          Bottom + \This()\FrameCoordinate\Height
        EndIf
        
        PushListPosition(\This()) 
        ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
        \This()\Left = Left
        \This()\Top = Top
        \This()\Right = Right
        \This()\Bottom = Bottom
        
        ResizeElement(\This()\Element, #PB_Ignore,#PB_Ignore,\This()\FrameCoordinate\Width+1,\This()\FrameCoordinate\Height+1)
        ResizeElement(\This()\Element, #PB_Ignore,#PB_Ignore,\This()\FrameCoordinate\Width-1,\This()\FrameCoordinate\Height-1)
        ; ResizeElement(\This()\Element, #PB_Ignore,#PB_Ignore,\This()\FrameCoordinate\Width,\This()\FrameCoordinate\Height, #PB_Ignore)
        PopListPosition(\This())
        
        
        \This()\IsAlign = #True
        AvtoResizeElement(\This(), Element, \This()\Parent\Element)
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
EndProcedure


Procedure _ResizeListElement(List This.S_CREATE_ELEMENT(), Element, X,Y,Width,Height, RedrawElement.b=1, Flag.q=#_Element_ContainerCoordinate) 
  Protected Result
  Protected ParentX,ParentY,ParentWidth,ParentHeight
  Protected ChangeX,ChangeY,ChangeWidth,ChangeHeight
  Protected Type, Parent, iX, iY, iWidth, iHeight
  
  With This()
    ;     PushListPosition(This()) 
    ;     ChangeCurrentElement(This(), ElementID(Element))
    ;     If #PB_Ignore = X : X = \FrameCoordinate\X : EndIf
    ;     If #PB_Ignore = Y : Y = \FrameCoordinate\Y : EndIf
    ;     If #PB_Ignore = Width :Width = \FrameCoordinate\Width : EndIf
    ;     If #PB_Ignore = Height : Height = \FrameCoordinate\Height : EndIf
    ;     
    ;     ; X-\bSize : Y-\bSize : Width+\bSize*2 : Height+\bSize*2
    
    ;     If #PB_Ignore <> X : X+(\bSize-\BorderSize): EndIf
    ;     If #PB_Ignore <> Y : Y+(\bSize-\BorderSize): EndIf
    ;     If #PB_Ignore <> Width : Width-((\bSize-\BorderSize)*2): EndIf
    ;     If #PB_Ignore <> Height : Height-((\bSize-\BorderSize)*2): EndIf
    
    If Flag.q<>#PB_Ignore And IsElement(\Parent\Element) ; Если есть родитель добавляем и его координаты
      PushListPosition(This()) 
      ChangeCurrentElement(This(), ElementID(\Parent\Element))
      
      If ((Flag & #_Element_WindowCoordinate) = #_Element_WindowCoordinate)
        ChangeCurrentElement(This(), ElementID(\Window))
      ElseIf ((Flag & #_Element_ScreenCoordinate) = #_Element_ScreenCoordinate)
        SelectElement(This(), 0)
      EndIf
      
      If #PB_Ignore <> X : X + \InnerCoordinate\X : EndIf
      If #PB_Ignore <> Y : Y + \InnerCoordinate\Y : EndIf
      
      PopListPosition(This())
    EndIf
    
    If #PB_Ignore <> X And (X <> \FrameCoordinate\X Or Flag.q = #PB_Ignore) 
      ChangeX = (\InnerCoordinate\X - (X+\bSize)) : \FrameCoordinate\X = X
      ResizeElementX(This(), X)
      Result = #True
    EndIf
    If #PB_Ignore <> Y And (Y <> \FrameCoordinate\Y Or Flag.q = #PB_Ignore)
      ;       ChangeY = (\InnerCoordinate\Y - (Y+(\CaptionHeight+\MenuHeight+\ToolBarHeight+\bSize))) : \FrameCoordinate\Y = Y 
      ChangeY = (\FrameCoordinate\Y - Y) : \FrameCoordinate\Y = Y 
      ResizeElementY(This(), Y)
      Result = #True
    EndIf
    If #PB_Ignore <> Width And (Width <> \FrameCoordinate\Width Or Flag.q = #PB_Ignore)
      ChangeWidth = (\FrameCoordinate\Width+\bSize*2 - (Width-\bSize*2)) : \FrameCoordinate\Width = Width
      ResizeElementX(This())
      ParentWidth = \FrameCoordinate\Width
      Result = #True
    EndIf
    If #PB_Ignore <> Height And (Height <> \FrameCoordinate\Height Or Flag.q = #PB_Ignore)
      ChangeHeight = (\FrameCoordinate\Height+\bSize*2 - (Height-\bSize*2)) : \FrameCoordinate\Height = Height
      ResizeElementY(This())
      ParentHeight = \FrameCoordinate\Height
      Result = #True
    EndIf
    
    iX = \InnerCoordinate\X : iY = \InnerCoordinate\Y : iWidth = \InnerCoordinate\Width : iHeight = \InnerCoordinate\Height
    
    UpdateScrolls(This())
    
    ;Debug GetElementState(Element)
    ;SetSplitterElementState(Element, GetElementState(Element))
    
    
    ; Это должно происходить если есть дети
    If Result And \Childrens
      Type = \Type
      Parent = \Parent\Element
      iWidth = \InnerCoordinate\Width
      iHeight = \InnerCoordinate\Height
      
      Protected State = (\Splitter\Pos+\Splitter\Size+\bSize*2); -1
      Protected IsVertical = Bool(((\Flag&#_Flag_Vertical) = #_Flag_Vertical))
      Protected FirstElement = \Splitter\FirstElement
      Protected SecondElement = \Splitter\SecondElement
      Protected FirstFixed = \Splitter\FirstFixed
      Protected SecondFixed = \Splitter\SecondFixed
      
      PushListPosition(This())
      While NextElement(This()) ; Использовали цикл While а не Repeat, что бы пропустить первый элемент (то есть перемещаемый)
        
        If IsChildElement(\Element, Element) 
          If \IsAlign And (ChangeWidth + ChangeHeight) 
            AvtoResizeElement(This(), \Element, Element)
          Else
            If ChangeX : \FrameCoordinate\X - ChangeX
              ResizeElementX(This(), (\FrameCoordinate\X+ChangeX))
            EndIf
            If ChangeY : \FrameCoordinate\Y - ChangeY
              ResizeElementY(This(), (\FrameCoordinate\Y+ChangeY))
            EndIf
            
            If Type = #_Type_Container ; Если изменили в размерах дитья сплиттера
              If ElementType(Parent) = #_Type_Splitter 
                If Bool(((GetElementFlag(Parent)&#_Flag_Vertical) = #_Flag_Vertical))
                  \FrameCoordinate\Width = iWidth
                Else
                  \FrameCoordinate\Height = iHeight
                EndIf
              EndIf
            ElseIf Type = #_Type_Splitter 
              
              ;Debug "Resize e = "+Str(Element)+" t = "+ElementClass(\Type)
              
              
              ;               If ((FirstElement = \Element) Or (SecondElement = \Element))
              ;                 If IsVertical
              ;                   If ChangeHeight : \FrameCoordinate\Height = iHeight : EndIf
              ;                 Else
              ;                   If ChangeWidth : \FrameCoordinate\Width = iWidth : EndIf
              ;                 EndIf
              ;               EndIf
              
              If ((SecondElement = \Element)) ; (FirstElement = \Element) ; Or 
                PushListPosition(This())
                ChangeCurrentElement(This(), ElementID(\Parent\Element))
                If \Splitter\Pos = 0
                  SetElementState(\Element, 80)
                Else
                  SetElementState(\Element, (\Splitter\Pos+\Splitter\Size/2))
                EndIf
                PopListPosition(This())
              EndIf
              
              
            EndIf
            
            If ChangeWidth : ResizeElementX(This()) : EndIf
            If ChangeHeight : ResizeElementY(This()) : EndIf
          EndIf
          
          ;           ;ChangeCurrentElement(This(), ElementID(\Element))
          ;           If \Type = #_Type_ScrollBar
          ;             If \Item\Parent
          ;               If \IsVertical
          ;                 SetScrollBarElementAttribute(This(), #PB_ScrollBar_PageLength, \FrameCoordinate\Height)
          ;               Else
          ;                 SetScrollBarElementAttribute(This(), #PB_ScrollBar_PageLength, \FrameCoordinate\Width)
          ;               EndIf
          ;             EndIf
          ;           EndIf
          
        EndIf
      Wend
      PopListPosition(This())
    EndIf
    
    If Flag = #PB_Ignore
      ;  RedrawElement = #False
    EndIf
    
    If RedrawElement =- 1
      If (ChangeX Or ChangeY) ; Moving
        PostEventElement(#_Event_Move, Element)
      EndIf
      If (ChangeWidth Or ChangeHeight) ; Sising
        PostEventElement(#_Event_Size, Element)
      EndIf
    ElseIf RedrawElement = 1
      If (ChangeX Or ChangeY) ; Moving
        ElementCallBack(#_Event_Move, Element)
      EndIf
      If (ChangeWidth Or ChangeHeight) ; Sising
        ElementCallBack(#_Event_Size, Element)
      EndIf
    EndIf
    
    ;     PopListPosition(This())
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
Procedure AddFlag(Flag, AddFlag)
  Protected Result
  
  With *CreateElement
    If ((Flag & AddFlag) = AddFlag) And (\This()\Flag & AddFlag) = 0
      \This()\Flag | AddFlag
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetElementFlag(Element)
  Protected Result.q
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Result = \This()\Flag
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.q SetElementFlag(Element, Flag.q)
  Protected Result.q, iWidth, iHeight
  
  If IsToolbarElement(Element)
    ProcedureReturn 
  EndIf
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      iWidth = \This()\InnerCoordinate\Width
      iHeight = \This()\InnerCoordinate\Height
      
      Result = \This()\Flag
      \This()\Flag | Flag
      
      Select \This()\Type
        Case #_Type_Splitter 
          If ((\This()\Flag & #_Flag_Separator_Circle) = #_Flag_Separator_Circle)
            \This()\Splitter\Size = 7
          ElseIf ((\This()\Flag & #_Flag_Separator) = #_Flag_Separator)
            \This()\Splitter\Size = 5
          Else
            \This()\Splitter\Size = 1
          EndIf
          
        Case #_Type_Window 
          If Flag.q
            
            If ((Flag & #_Flag_Invisible) = #_Flag_Invisible)
              HideElement(Element, #True)  
            EndIf
            
            If ((Flag & #_Flag_BorderLess) = #_Flag_BorderLess)
              \This()\Flag &~ #_Flag_Border
            EndIf
            
            If ((Flag & #_Flag_Border) = #_Flag_Border)
              \This()\Flag &~ #_Flag_BorderLess
            EndIf
            
            
            Select \This()\Type
              Case #_Type_Window
                ;         Debug Flag
                ;         Debug GetPBFlags(Flag)
                
                If ((Flag &~ #_Flag_SystemMenu) = 0)
                  RemoveElementFlag(Element, #_Flag_SystemMenu)
                  
                  If ((Flag & #_Flag_TitleBar) = #_Flag_TitleBar)
                    If ((\This()\Flag & #_Flag_TitleBar) = #_Flag_TitleBar) 
                      Flag &~ #_Flag_TitleBar
                    EndIf
                  EndIf
                  
                  If ((Flag & #_Flag_CloseGadget) = #_Flag_CloseGadget)
                    If ((\This()\Flag & #_Flag_CloseGadget) = #_Flag_CloseGadget)
                      Flag &~ #_Flag_CloseGadget
                    Else
                      Flag | #_Flag_TitleBar
                    EndIf
                  EndIf
                  
                  If ((Flag & #_Flag_MaximizeGadget) = #_Flag_MaximizeGadget)
                    If ((\This()\Flag & #_Flag_MaximizeGadget) = #_Flag_MaximizeGadget) 
                      Flag &~ #_Flag_MaximizeGadget
                    Else
                      Flag | #_Flag_TitleBar
                    EndIf
                  EndIf
                  
                  If ((Flag & #_Flag_MinimizeGadget) = #_Flag_MinimizeGadget)
                    If ((\This()\Flag & #_Flag_MinimizeGadget) = #_Flag_MinimizeGadget) 
                      Flag &~ #_Flag_MinimizeGadget
                    Else
                      Flag | #_Flag_TitleBar
                    EndIf
                  EndIf
                  
                  \This()\Flag | Flag
                EndIf
                
                
                
                If ((Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
                  \This()\Flag | #_Flag_AlignCenter
                EndIf
                If ((Flag & #_Flag_TitleBar) = #_Flag_TitleBar) 
                  \This()\CaptionHeight = \CaptionHeight
                  \This()\Flag | #_Flag_MoveGadget
                  
                  AddElementItem(Element,0,\This()\Text\String$, \This()\Img\Ico)
                  
                EndIf
                If ((Flag & #_Flag_CloseGadget) = #_Flag_CloseGadget)
                  AddElementItem(Element,-1,"",cls)
                  \This()\Items()\Type = #_Flag_CloseGadget
                EndIf
                If ((Flag & #_Flag_MaximizeGadget) = #_Flag_MaximizeGadget)
                  AddElementItem(Element,-1,"",max)
                  \This()\Items()\Type = #_Flag_MaximizeGadget
                EndIf
                If ((Flag & #_Flag_MinimizeGadget) = #_Flag_MinimizeGadget)
                  AddElementItem(Element,-1,"",min)
                  \This()\Items()\Type = #_Flag_MinimizeGadget
                EndIf
                
              Default
                \This()\Flag | Flag 
                
            EndSelect
            
          EndIf
          
        Default
          ; 
          \This()\Flag | Flag ;| #_Flag_Border
      EndSelect
      
      
      
      ; Border type then draw
      If ((Flag & #_Flag_BorderLess) = #_Flag_BorderLess)
        \This()\Flag &~ #_Flag_Border
        \This()\bSize = 0
        \This()\BorderSize = 0
        
      Else ; If ((\This()\Flag & #_Flag_Border) = #_Flag_Border)
        \This()\Flag &~ #_Flag_BorderLess
        \This()\bSize = 1
        \This()\BorderSize = 1
        \This()\Flag | #_Flag_Border
        
        If (((\This()\Flag & #_Flag_Double) = #_Flag_Double) Or
            ((\This()\Flag & #_Flag_Raised) = #_Flag_Raised))
          \This()\bSize = 2
          \This()\BorderSize = 2
        EndIf
      EndIf
      
      If ((\This()\Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
        \This()\bSize = 4
      EndIf
      
      
      ; Back color then draw
      If ((\This()\Flag & #_Flag_Transparent) = #_Flag_Transparent)
        \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
      EndIf
      
      
      ; UpdateResizeElement
      ResizeElement(\This()\Element, 
                    \This()\FrameCoordinate\X,
                    \This()\FrameCoordinate\Y,
                    \This()\FrameCoordinate\Width,
                    \This()\FrameCoordinate\Height, #PB_Ignore)
      
      ;       ; UpdateResizeElement
      ;       ResizeElement(\This()\Element, 
      ;                     \This()\FrameCoordinate\X,
      ;                     \This()\FrameCoordinate\Y,
      ;                     \This()\FrameCoordinate\Width+(\This()\bSize-\This()\BorderSize)*2,
      ;                     \This()\FrameCoordinate\Height+\This()\CaptionHeight+\This()\MenuHeight+\This()\ToolBarHeight+(\This()\bSize-\This()\BorderSize)*2, #PB_Ignore)
      
      ;
      AlignmentElement( Element, \This()\Flag )
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure.q GetGadgetElementFlag(Element)
  Protected Result.q
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Select \This()\Type
        Case #_Type_Splitter : Result = GetSplitterElementFlag(\This()\Flag)
        Case #_Type_Container : Result = GetContainerElementFlag(\This()\Flag)
          
      EndSelect
      
      ;       If ((\This()\Flag & #_Flag_Element_Top) = #_Flag_Element_Top)
      ;         Result | #PB_Gadget_Top
      ;       EndIf
      ;       If ((\This()\Flag & #_Flag_Element_Left) = #_Flag_Element_Left)
      ;         Result | #PB_Gadget_Left
      ;       EndIf
      ;       If ((\This()\Flag & #_Flag_Element_Right) = #_Flag_Element_Right)
      ;         Result | #PB_Gadget_Right
      ;       EndIf
      ;       If ((\This()\Flag & #_Flag_Element_Bottom) = #_Flag_Element_Bottom)
      ;         Result | #PB_Gadget_Bottom
      ;       EndIf
      ;       If ((\This()\Flag & #_Flag_Element_Center) = #_Flag_Element_Center)
      ;         Result | #PB_Gadget_Center
      ;       EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.q SetGadgetElementFlag(Element, Flag.q)
  Protected Result.q
  
  With *CreateElement
    If IsGadgetElement(Element)
      Result.q = GetGadgetElementFlag(Element)
      
      Select \This()\Type
        Case #_Type_Splitter : Flag = SetSplitterElementFlag(Flag) 
        Case #_Type_Container : Flag = SetContainerElementFlag(Flag)
      EndSelect
      
      ;       If ((Flag & #PB_Gadget_Top) = #PB_Gadget_Top)
      ;         Flag | #_Flag_Element_Top
      ;       EndIf
      ;       If ((Flag & #PB_Gadget_Left) = #PB_Gadget_Left)
      ;         Flag | #_Flag_Element_Left
      ;       EndIf
      ;       If ((Flag & #PB_Gadget_Right) = #PB_Gadget_Right)
      ;         Flag | #_Flag_Element_Right
      ;       EndIf
      ;       If ((Flag & #PB_Gadget_Bottom) = #PB_Gadget_Bottom)
      ;         Flag | #_Flag_Element_Bottom
      ;       EndIf
      ;       If ((Flag & #PB_Gadget_Center) = #PB_Gadget_Center)
      ;         Flag | #_Flag_Element_Center
      ;       EndIf
      
      SetElementFlag(Element, Flag)
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetWindowElementFlag(Element)
  Protected Result.q
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Select \This()\Type
        Case #_Type_Window : Result = GetOpenWindowElementFlag(\This()\Flag)
          
      EndSelect
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.q SetWindowElementFlag(Element, Flag.q)
  Protected Result.q
  
  With *CreateElement
    If IsWindowElement(Element)
      Result.q = GetOpenWindowElementFlag(Element)
      
      SetElementFlag(Element, SetOpenWindowElementFlag(Flag))
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure RemoveElementFlag(Element, Flag.q)
  Protected.b Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element)) 
      
      
      \This()\Flag &~ Flag
      
      If ((Flag & #_Flag_Double) = #_Flag_Double)
        ;Debug 555555555
        \This()\Flag &~ #_Flag_Border
        \This()\Flag | #_Flag_BorderLess
        \This()\BorderSize = 0
        ;\This()\bSize = 0
      EndIf
      
      If ((Flag & #_Flag_TitleBar) = #_Flag_TitleBar)
        \This()\CaptionHeight = 0
        \This()\Flag &~ #_Flag_MoveGadget
        
        If ListSize(\This()\Items())
          SelectElement(\This()\Items(), 0)
          DeleteElement(\This()\Items(), 0)
        EndIf
      EndIf
      ;       
      If ((Flag & #_Flag_SystemMenu) = #_Flag_SystemMenu)
        ;PushListPosition(\This()\Items())
        If ListSize(\This()\Items())
          ForEach \This()\Items()
            ;Debug \This()\Items()\Element
            If \This()\Items()\Element
              DeleteMapElement(\This()\iID(), Str(@\This()\Items()))
              DeleteMapElement(\This()\iHandle(), Str(\This()\Items()\Element))
              DeleteElement(\This()\Items(), 0)
            EndIf
          Next
        EndIf
        ;PopListPosition(\This()\Items())
      EndIf
      
      If ((\This()\Flag & Flag) = 0)
        Result = #True 
      EndIf
      
      ; UpdateResizeElement
      ResizeElement(\This()\Element, 
                    \This()\FrameCoordinate\X,
                    \This()\FrameCoordinate\Y,
                    \This()\FrameCoordinate\Width,
                    \This()\FrameCoordinate\Height, #PB_Ignore)
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

;CompilerIf #PB_Compiler_IsMainFile

;XIncludeFile "S_Servis().pb"

;CompilerEndIf


Procedure ResizeItemIndex(Item, X,Y,Width,Height, Flag.q = #_Element_ContainerCoordinate) 
  Protected ResizeElement, Parent =- 1, Window =- 1
  Protected ChangeX,ChangeY,ChangeWidth,ChangeHeight
  
  With *CreateElement
    If IsElementItem(Item)
      ResizeListElement(\This()\Items(), Item, X,Y,Width,Height, Flag)
    EndIf
  EndWith
  
  ProcedureReturn ResizeElement
EndProcedure


;-
; Получить итем элемента под курсором
Procedure ItemCheckBox(List This.S_CREATE_ELEMENT())
  Protected Result =- 1, X,Y
  
  With This()
    If (\Hide = #False And \Disable = #False And ListSize(\Items()))
      PushListPosition(\Items()) 
      ForEach \Items()
        If \Type = #_Type_ListIcon
          X = (\Items()\X-\Item\X)
        Else
          X = (\Items()\X)
        EndIf
        If (*CreateElement\MouseY > (\Items()\Y) And *CreateElement\MouseY  = < ((\Items()\Y+\Items()\Height))) And 
           ((*CreateElement\MouseX > =  \Items()\X-(\Splitter\Pos+\Splitter\Size)) And (*CreateElement\MouseX < (\Items()\X+21+(\Splitter\Pos+\Splitter\Size))))
          
          Result = \Items()\Element
          
          \Item\Entered\Element = Result
        EndIf
      Next
      PopListPosition(\Items())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure ColumnFromElementPoint(List This.S_CREATE_ELEMENT())
  Protected Result =- 1, X,Y
  
  With This()
    If (\Hide = #False And \Disable = #False And ListSize(\Columns()))
      PushListPosition(\Columns()) 
      ForEach \Columns()
        X = (\Columns()\X-\Column\X)
        If (*CreateElement\MouseY > (\Columns()\Y) And *CreateElement\MouseY  = < ((\Columns()\Y+\Columns()\Height))) And 
           ((*CreateElement\MouseX > =  X-(\Splitter\Pos+\Splitter\Size)) And (*CreateElement\MouseX < (X+\Columns()\Width+(\Splitter\Pos+\Splitter\Size))))
          
          Result = \Columns()\Element
          
          \Column\Entered\Element = Result
        EndIf
      Next
      PopListPosition(\Columns())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure ItemFromElementPoint(List This.S_CREATE_ELEMENT())
  Protected Result =- 1, X,Y
  
  With This()
    If (\Hide = #False And \Disable = #False And ListSize(\Items()))
      PushListPosition(\Items()) 
      ForEach \Items()
        If \Type = #_Type_ListIcon
          X = (\Items()\X-\Item\X)
        Else
          X = (\Items()\X)
        EndIf
        If (*CreateElement\MouseY > (\Items()\Y) And *CreateElement\MouseY  = < ((\Items()\Y+\Items()\Height))) And 
           ((*CreateElement\MouseX > =  X-(\Splitter\Pos+\Splitter\Size)) And (*CreateElement\MouseX < (X+\Items()\Width+(\Splitter\Pos+\Splitter\Size))))
          
          Result = \Items()\Element
          
          \Item\Entered\Element = Result
        EndIf
      Next
      PopListPosition(\Items())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
; Освободить элемент
Declare CreateElement(Type, Element, X,Y,Width,Height,Text$ = "",Param1 =- 1,Param2 =- 1,*Param3 =- 1, Flag.q=0, Parent=-1, Radius=0)

Procedure RemoveElement(Element)
  
  With *CreateElement
    
    If IsElement(Element)
      ChangeCurrentElement(\This(), ElementID(Element))
      
      If \This()\Childrens
        PushListPosition(\This())
        LastElement(\This())
        Repeat ; Начинаем цикл с конца чтобы с начала удалить всех детей
          If (IsChildElement(\This()\Element, Element) And (Element <> \This()\Element))
            UpdateParentElementChildrensCount(\This()\Parent\Element, -1) ; CountElement()
            PostEventElement(#_Event_Free, \This()\Element, \This()\Item\Entered\Element)  ; Посылаем сообщение что удалили элемент
            RemoveMapElement(\This())
            
            If Not ListSize(\This()) : Break : EndIf
          ElseIf Not PreviousElement(\This())
            Break
          EndIf
        ForEver
        PopListPosition(\This())
        
        UpdateParentElementChildrensCount(\This()\Parent\Element, -1) ; CountElement()
        PostEventElement(#_Event_Free, \This()\Element, \This()\Item\Entered\Element)  ; Посылаем сообщение что удалили элемент
        RemoveMapElement(\This())
        
      Else
        UpdateParentElementChildrensCount(\This()\Parent\Element, -1) ; CountElement()
        PostEventElement(#_Event_Free, \This()\Element, \This()\Item\Entered\Element)  ; Посылаем сообщение что удалили элемент
        
        RemoveMapElement(\This())
      EndIf
      
    EndIf
    
  EndWith
  
EndProcedure

Procedure FreeElement(Element) ; Ok
  Protected Result =- 1
  Protected ActiveElement =- 1
  Protected Parent = GetElementParent(Element)
  Protected PrevElement = PrevPosition(Element)
  Protected NextElement = NextPosition(Element)
  
  If IsElement(PrevElement)
    ActiveElement = PrevElement
  ElseIf IsElement(NextElement)
    ActiveElement = NextElement
  Else
    ActiveElement = Parent
  EndIf
  
  SetActiveElement(ActiveElement)
  SetForegroundWindowElement(ActiveElement)
  
  RemoveElement(Element)
  
  ; 
  With *CreateElement
    If IsElement(ActiveElement)
      ChangeCurrentElement(\This(), ElementID(ActiveElement))
      
      If \This()\EditingMode
        \CheckedElement = ActiveElement
        SetAnchors(ActiveElement)
      EndIf
    EndIf
    
  EndWith
  
  ; 
  If BeginDrawing()
    UpdateDrawingContent()
    EndDrawing()
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure CopyElement(Element) 
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      ChangeCurrentElement(\This(), ElementID(Element))
      
      ;SetClipboardText$()
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure PasteElement(Element) 
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      
      ;       If \MultiSelect
      ;         PushListPosition(\This())
      ;         ForEach \This()
      ;           If \This()\EditingMode
      ;             If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
      ;               PushListPosition(\This())
      ;               CreateElement(\This()\Type, #PB_Any,
      ;                           \This()\ContainerCoordinate\X, 
      ;                           \This()\ContainerCoordinate\Y, 
      ;                           \This()\FrameCoordinate\Width, 
      ;                           \This()\FrameCoordinate\Height,
      ;                           \This()\Text\String$, -1,-1,-1,\This()\Flag)
      ;               PopListPosition(\This())
      ;             EndIf
      ;           EndIf
      ;         Next
      ;         PopListPosition(\This())
      ;         
      ;         ProcedureReturn #True
      ;       Else
      ;OpenElementList(\This()\Parent\Element)
      CreateElement(\This()\Type, #PB_Any,
                    \This()\ContainerCoordinate\X, 
                    \This()\ContainerCoordinate\Y, 
                    \This()\FrameCoordinate\Width, 
                    \This()\FrameCoordinate\Height,
                    \This()\Text\String$, -1,-1,-1,\This()\Flag)
      
      ;       EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure CutElement(Element)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      ChangeCurrentElement(\This(), ElementID(Element))
      
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure.S SetElementEditingMode(List This.S_CREATE_ELEMENT())
  Protected Result.S, Class$
  
  With This()
    Result = \Class$
    \EditingMode = #True ; В Режиме редактирования 
    
    If IsElement(*CreateElement\Parent)
      PushListPosition(This()) 
      ChangeCurrentElement(This(), ElementID(*CreateElement\Parent))
      If \EditingMode = #True 
        Class$ = \Class$
      EndIf
      PopListPosition(This())
    EndIf
    
    If Class$ : Class$ +"_" : EndIf 
    \Class$ = Class$ + \Class$
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure NewElement(List This.S_CREATE_ELEMENT(), Element, Type)
  
  With This()
    If Element = #PB_Any
      LastElement(This())
      AddElement(This()) 
      If Type = 0
        Element = @This()<<1
      Else
        Element = ListSize(This())
      EndIf
    Else
      If (Element > (ListSize(This()) - 1))
        LastElement(This())
        AddElement(This()) 
      Else
        SelectElement(This(), Element)
        InsertElement(This())
      EndIf
    EndIf
    
    This()\Element = Element
    
    If Type = 0
      *CreateElement\eID(Str(@This())) = Element
      *CreateElement\eHandle(Str(Element)) = @This()
    ElseIf Type = 1 
      This()\iID(Str(@This())) = Element
      This()\iHandle(Str(Element)) = @This()
    ElseIf Type = 2
      This()\cID(Str(@This())) = Element
      This()\cHandle(Str(Element)) = @This()
    EndIf
  EndWith
  
  ProcedureReturn Element
EndProcedure

Macro NewElement(Index, This)
  If Index = #PB_Any
    LastElement(This)
    AddElement(This) 
  Else
    If (Index > (ListSize(This) - 1))
      LastElement(This)
      AddElement(This) 
    Else
      SelectElement(This, Index)
      InsertElement(This)
    EndIf
  EndIf
EndMacro

; Создать элемент
Procedure CreateElement(Type, Element, X,Y,Width,Height,Text$ = "",Param1 =- 1,Param2 =- 1,*Param3 =- 1, Flag.q=0, Parent=-1, Radius=0)
  Protected Class$, CountType
  Protected ElementID 
  Protected LastElement =- 1
  Static Container =- 1
  
  With *CreateElement
    PushListPosition(\This()) 
    
    NewElement(Element, \This())
    If Element =- 1 
      Element = (@\This()<<1) 
    EndIf
    ElementID = @\This()
    
    If ElementID
      \This()\Element = Element
      \eID(Str(ElementID)) = Element
      \eHandle(Str(Element)) = ElementID
      
      If IsElement(Parent) 
        \Parent = Parent
      EndIf
      
      
      \This()\Class$ = ElementClass(Type) +"_"+ Str(CountElementType(Type, \Parent))
      
      ; В Режиме редактирования
      If X = #PB_Ignore : X = ElementX(\ActiveWindow) +30 : EndIf
      If Y = #PB_Ignore : Y = ElementY(\ActiveWindow) +30 : EndIf
      
      If ((Flag&#_Flag_AnchorsGadget) = #_Flag_AnchorsGadget)
        Text$ = SetElementEditingMode(\This())
        \CheckedElement = Element
        
        Protected bs
        ; Border type then draw
        If ((Flag & #_Flag_Flat) = #_Flag_Flat)
          bs=1
        EndIf
        If (((Flag & #_Flag_Double) = #_Flag_Double) Or
            ((Flag & #_Flag_Raised) = #_Flag_Raised))
          bs=2
        EndIf
        
        If ((Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
          bs=4-bs
        EndIf
        
        
        If ElementType(\Parent) = #_Type_Window
          X = Steps(X,Steps)-3
          Y = Steps(Y,Steps)-3
        Else
          X = Steps(X,Steps)-4
          Y = Steps(Y,Steps)-4
        EndIf
        
        If Type = #_Type_Window
          Height = Steps(Height,Steps)-1
          Width = Steps(Width,Steps)
        Else
          Height = Steps(Height,Steps)+2
          Width = Steps(Width,Steps)+2
        EndIf
        ;         Width = Steps((\MouseX-\This()\FrameCoordinate\X),Steps)
        ; ;           Height = Steps((\MouseY-\This()\FrameCoordinate\Y),Steps)
        ; ;           If \This()\Type = #_Type_Window
        ; ;             ResizeElement(CheckedElement, #PB_Ignore, #PB_Ignore, Width-2, Height)
        ; ;           Else
        ; ;             ResizeElement(CheckedElement, #PB_Ignore, #PB_Ignore, Width+1, Height+1)
        ; ;           EndIf
        
      EndIf
      
      ; create element type
      Select Type
        Case #_Type_Menu : \CreateMenuElement = Element
        Case #_Type_Toolbar : \CreateToolBarElement = Element
        Case #_Type_StatusBar : \CreateStatusBarElement = Element
        Case #_Type_PopupMenu : \CreateMenuElement = Element : \CreatePopupMenuElement = Element
        Case #_Type_Window 
          \CreateElement = Element
          \CreateWindowElement = Element 
          \This()\CaptionHeight = \CaptionHeight
          
        Default : \CreateGadgetElement = Element : \CreateElement = Element
      EndSelect
      
      
      \This()\OptionGroup =- 1
      \This()\CaretPos =- 1
      \This()\CursorLength =- 1
      \This()\CaretPosFixed =- 1
      \This()\CaretPosMoved =- 1
      
      
      \This()\Type   = Type
      \This()\BackColor =- 1
      \This()\FontColor = $222222
      \This()\FrameColor = $ACACAC
      \This()\Scroll\Size = 6
      
      ;\This()\FontID =  FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality));Consolas
      \This()\FontID = GetGadgetFont(#PB_Default)
      \This()\State = #_State_Default
      
      \This()\Img\ImgBg =- 1
      \This()\Img\Image = Param1
      \This()\Img\Ico   = Param2
      
      \This()\OpenList =- 1
      \This()\CloseList =- 1
      
      \This()\Entered\Element =- 1
      \This()\Selected\Element =- 1
      
      
      \This()\Flag | Flag
      
      \This()\Interact = #True ; Поумолчанию будет взаимодействовать с пользователем
      \This()\Repaint  = #True
      \This()\Parent\Item = 0
      \This()\Item\Active =- 1
      \This()\Linked\Element =- 1
      \This()\Item\Entered\Element =- 1
      \This()\Item\Selected\Element =- 1
      \This()\Splitter\FirstElement =- 1
      \This()\Splitter\SecondElement =- 1
      
      \This()\Scroll\Vert =- 1
      \This()\Scroll\Horz =- 1
      \This()\Scroll\Element =- 1
      
      ; Обновляем количество детей у родителя
      UpdateParentElementChildrensCount(\Parent, 1)
      
      ; Скрываем все элементы,
      ; панель радитель элемента,
      ; кроме первого итема      
      If IsElement(\Parent)
        Protected PanelItem
        Protected ParentElement = \Parent
        
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(\Parent))
        While IsElement(ParentElement)
          ChangeCurrentElement(\This(), ElementID(ParentElement))
          
          If \This()\Type = #_Type_Panel
            PanelItem = \This()\Item\Element
            Break
          EndIf
          
          ParentElement = \This()\Parent\Element
        Wend
        PopListPosition(\This())
        
        If PanelItem
          \This()\Hide = #True ; Скрываем элемент
          \This()\Parent\Item = PanelItem ; Закрепляем элемент к итему панели
        EndIf 
      EndIf
      
      \This()\Window = \Window
      \This()\ElementID = @\This()
      \This()\Parent\Element = \Parent
      \This()\WindowID = ElementID(\Window)
      \This()\ParentID = ElementID(\Parent)
      
      
      If ((Flag&#_Flag_Invisible) = #_Flag_Invisible)
        \This()\HideState = #True
        \This()\Hide = #True
      EndIf
      
      
      ;
      OpenElementList(Element, PanelItem)
      
      
      
      
      If Text$
        ;  Text$+"_"+Str(Element)+"_"+Str(\This()\Parent\Element)+"_"+Str(\This()\Window);+"_"+Str(CountElementType(Type))
      EndIf
      \This()\Text\String$     = Text$
      
      ;SetElementPosition(Element, #_Element_PositionNext, \Parent)
      If IsElement(\This()\Parent\Element) ; And Element = \Parent
                                           ;  MoveElement(\This(), #PB_List_After, ElementID(\This()\Parent\Element))
      EndIf
      
      
      ;
      Select Type ; Режим рисования элемента
        Case #_Type_Frame
          ;         \This()\DrawingMode = #PB_2DDrawing_Default
          ;         \This()\BackColor = $F0F0F0
          ; \This()\Flag | #_Flag_Text_Center
          \This()\Flag|#_Flag_Transparent
          \This()\CaptionHeight = 10
          \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
          If \This()\Text\String$ : \This()\Img\Image =- 1 : EndIf
          ;AddElementItem(Element, 0, Text$, -1, #_Flag_Image_Center|#_Flag_Border)
          
        Case #_Type_AnchorButton
          \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
          If \This()\Text\String$ : \This()\Img\Image =- 1 : EndIf
          AddElementItem(Element, 0, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 1, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 2, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 3, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 4, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 5, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 6, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 7, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 8, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 9, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 10, "", -1, #_Flag_Image_Center|#_Flag_Border)
          
          
          
        Case #_Type_Splitter
          \This()\Splitter\FirstElement = Param1
          \This()\Splitter\SecondElement = Param2
          \This()\DrawingMode = #PB_2DDrawing_AlphaBlend 
          \This()\Splitter\FirstFixed = Bool(((\This()\Flag&#_Flag_FirstFixed) = #_Flag_FirstFixed))
          \This()\Splitter\SecondFixed = Bool(((\This()\Flag&#_Flag_SecondFixed) = #_Flag_SecondFixed))
          
        Case #_Type_ScrollArea
          \This()\Scroll\ButtonSize = 17 ; Arrow Size
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $F0F0F0 ; $8F8F8F ; 
          \This()\Scroll\Min = Param1
          \This()\Scroll\Max = Param2
          \This()\Scroll\PageLength = *Param3
          
          \This()\IsVertical = Bool(((\This()\Flag&#_Flag_Vertical) = #_Flag_Vertical))
          
        Case #_Type_ScrollBar
          \This()\Scroll\ButtonSize = 17 ; Arrow Size
          \This()\Img\Image =- 1
          \This()\Text\String$ = ""
          \This()\Scroll\Min = Param1
          \This()\Scroll\Max = Param2
          \This()\Scroll\PageLength = *Param3
          \This()\BackColor =  $F2F2F2 ; $F9F9F9;$F0F0F0;$FFFFFF
          \This()\FrameColor = $858585
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\IsVertical = Bool(((\This()\Flag&#_Flag_Vertical) = #_Flag_Vertical))
          \This()\Scroll\ScrollStep = 3
          
        Case #_Type_TrackBar
          \This()\Scroll\ButtonSize = 5 ; Arrow Size
          \This()\Img\Image =- 1
          \This()\Text\String$ = ""
          \This()\Scroll\Min = Param1
          \This()\Scroll\Max = Param2
          \This()\Scroll\PageLength = *Param3
          \This()\BackColor =  $F2F2F2 ; $F9F9F9;$F0F0F0;$FFFFFF
          \This()\FrameColor = $858585
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\IsVertical = Bool(((\This()\Flag&#_Flag_Vertical) = #_Flag_Vertical))
          
        Case #_Type_Spin ; OK
          \This()\Img\Image =- 1
          \This()\BackColor = $FFFFFF
          \This()\FrameColor = $858585
          \This()\DrawingMode = #PB_2DDrawing_Default
          
          \This()\Spin\Min = Param1
          \This()\Spin\Max = Param2
          
          If *Param3 > 0
            \This()\Spin\Increment = ValF(PeekS(*Param3))
            \This()\Spin\Decimals = Len(StringField(PeekS(*Param3), 2, "."))
          EndIf
          
          If ((Flag&#_Flag_Numeric)=#_Flag_Numeric)
            \This()\Text\String$ = StrF(0, \This()\Spin\Decimals)
          EndIf
          
          If ((Flag&#_Flag_ReadOnly)=0)
            \This()\Flag|#_Flag_Editable
          EndIf
          
          \This()\Item\Width = 16 ; Arrow width
          
          AddElementItem(Element, 0, "", -1, #_Flag_Image_Center|#_Flag_Border)
          AddElementItem(Element, 1, "", -1, #_Flag_Image_Center|#_Flag_Border)
          
        Case #_Type_ComboBox 
          \This()\Item\IsVertical = #True 
          
          If ((\This()\Flag & #_Flag_Editable) = #_Flag_Editable)
            \This()\BackColor = $FFFFFF
            \This()\DrawingMode = #PB_2DDrawing_Default
          Else
            \This()\BackColor =- 1
            \This()\DrawingMode = #PB_2DDrawing_Gradient
          EndIf
          \This()\Item\Width = 16 ; Arrow width
          \This()\Flag | #_Flag_Text_Center|#_Flag_Text_Left 
          
        Case #_Type_Properties 
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $FFFFFF
          \This()\Item\IsVertical = #True 
          
        Case #_Type_ListView 
          \This()\BackColor = $FFFFFF
          \This()\Item\IsVertical = #True 
          \This()\DrawingMode = #PB_2DDrawing_Default
          
        Case #_Type_ListIcon 
          \This()\BackColor = $FFFFFF
          \This()\Item\IsVertical = #True 
          \This()\DrawingMode = #PB_2DDrawing_Default
          
        Case #_Type_Editor
          \This()\BackColor = $FFFFFF
          \This()\Item\IsVertical = #True
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\Flag | #_Flag_MultiLine
          
          
        Case #_Type_PopupMenu
          \This()\bSize = 1
          \This()\Hide = #True
          \This()\BackColor = $F3F3F3
          \This()\Item\IsVertical = #True
          \This()\DrawingMode = #PB_2DDrawing_Default
          
        Case #_Type_Menu
          \This()\Flag &~ #_Flag_Border
          \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
          \This()\Item\IsVertical = #False
          
          
        Case #_Type_Toolbar 
          \This()\Flag &~ #_Flag_Border
          \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
          \This()\Item\IsVertical = #False   
          
        Case #_Type_StatusBar
          \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
          \This()\Item\IsVertical = #False   
          
        Case #_Type_Canvas ;: \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
          \This()\CaptionHeight = 0 ; Высота заголовка окна
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $FFFFFF
          \This()\Item\IsVertical =- 1   
          
        Case #_Type_Panel ;: \This()\DrawingMode = #PB_2DDrawing_AlphaBlend
          \This()\bSize = 1
          \This()\CaptionHeight = 25 ; Высота заголовка окна
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $FFFFFF
          \This()\Item\IsVertical = #False   
          
        Case #_Type_Window
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $F2F2F2 ; $F9F9F9
          
          \This()\Img\Image = Param1
          \This()\Img\Ico   = Param2
          \This()\Img\ImgBg = *Param3
          
          If (Not Flag) Or ((Flag&#_Flag_Anchors) = #_Flag_Anchors)
            Flag | #_Flag_SystemMenu ; |#_Flag_MinimizeGadget|#_Flag_MaximizeGadget
          EndIf
          
        Case #_Type_Desktop
          If ((\This()\Flag & #_Flag_Border) = #_Flag_Border)
            \This()\bSize = 0
          EndIf
          
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $F9F9F9
          \This()\Img\ImgBg = *Param3
          
        Case #_Type_ButtonImage 
          \This()\Img\Image = Param1
          \This()\DrawingMode = #PB_2DDrawing_Gradient
          
        Case #_Type_ImageButton
          \This()\Img\Image = Param1
          \This()\DrawingMode = #PB_2DDrawing_Gradient
          
        Case #_Type_Button
          \This()\Flag | #_Flag_Text_Center
          \This()\DrawingMode = #PB_2DDrawing_Gradient
          If \This()\Text\String$ : \This()\Img\Image =- 1 : EndIf
          
        Case #_Type_Text 
          If \This()\Text\String$ : \This()\Img\Image =- 1 : EndIf
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $F0F0F0
          
          Flag|#_Flag_MultiLine
          
          If ((Flag & #_Flag_Border) = 0) And 
             ((Flag & #_Flag_Single) = 0) And 
             ((Flag & #_Flag_Raised) = 0) And 
             ((Flag & #_Flag_Flat) = 0) And 
             ((Flag & #_Flag_Double) = 0)
            Flag | #_Flag_BorderLess
          EndIf
          
          If ((Flag & #_Flag_Text_Top) = #_Flag_Text_Top)
            Flag &~ #_Flag_Text_Top
          Else
            Flag | #_Flag_Text_Top
          EndIf
          
        Case #_Type_CheckBox
          \This()\BackColor =- 1
          \This()\DrawingMode = #PB_2DDrawing_Transparent
          If \This()\Text\String$ : \This()\Img\Image =- 1 : EndIf
          Flag | #_Flag_BorderLess|#_Flag_Text_Left|#_Flag_Text_HCenter
          
        Case #_Type_Option
          \This()\BackColor =- 1
          \This()\DrawingMode = #PB_2DDrawing_Transparent
          If \This()\Text\String$ : \This()\Img\Image =- 1 : EndIf
          Flag | #_Flag_BorderLess|#_Flag_Text_Left|#_Flag_Text_HCenter
          
          Protected OptionGroup
          Protected PrevPosition = PrevPosition(Element)
          If IsElement(PrevPosition)
            PushListPosition(\This())
            ChangeCurrentElement(\This(), ElementID(PrevPosition))
            If \This()\Type = #_Type_Option
              OptionGroup = \This()\OptionGroup 
            Else
              OptionGroup = \This()\Element 
            EndIf
            PopListPosition(\This())
          EndIf
          \This()\OptionGroup = OptionGroup 
          
          
        Case #_Type_String 
          If \This()\Text\String$ : \This()\Img\Image =- 1 : EndIf
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $FFFFFF
          \This()\FrameColor = $858585
          
        Case #_Type_Image
          \This()\DrawingMode = #PB_2DDrawing_Transparent
          If IsImage(\This()\Img\Image) : \This()\Text\String$ = "" : EndIf
          
          
        Case #_Type_Container 
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $F0F0F0
          
        Default
          
          \This()\DrawingMode = #PB_2DDrawing_Default
          \This()\BackColor = $FFFFFF
          
      EndSelect
      
      ; 
      If \This()\BackImage =- 1 And Width
        \This()\BackImage = CreateImage(#PB_Any,Width,Height,24,\This()\BackColor)
      EndIf
      
      
      
      ;If Element : SetElementText(Element, Text$) : EndIf
      ; Изменяем размеры элемента
      ; и посылаем сообщение что изменили размеры элемента
      If Element : SetElementFlag(Element, Flag) : EndIf
      ;ResizeElement(Element, X,Y,Width,Height)
      _ResizeListElement(\This(), Element, X,Y,Width,Height,-1)
      ; 
      Select Type ; Для сплиттера
        Case #_Type_Splitter 
          AddElementItem(Element,-1,Str(\This()\Splitter\FirstElement))
          AddElementItem(Element,-1,Str(\This()\Splitter\SecondElement))
          ;CloseElementList()
      EndSelect
      
      ; Set foreground window
      If Type = #_Type_Window 
        SetActiveElement(Element) 
        SetForegroundWindowElement(Element) 
      EndIf
      
      ; Посылаем сообщение что создали елемент
      PostEventElement(#_Event_Create, Element, #PB_Default)
      
    EndIf
    PopListPosition(\This())
  EndWith
  
  ProcedureReturn Element
EndProcedure



Procedure AddElementItem(Element, Position, Text$, Image =- 1, Flag.q = 0)
  Protected Window
  Protected TextWidth
  Protected TextHeight
  Protected ImageWidth
  Protected ImageHeight
  
  Protected ElementItem = Position
  Static ElementParent =- 1
  
  If Flag = 0
    Flag = #_Flag_Image_Center|#_Flag_Text_Center | #_Flag_Image_Right|#_Flag_Text_Left
  EndIf
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      NewElement(ElementItem, \This()\Items())
      If ElementItem =- 1 
        ElementItem = ListIndex(\This()\Items())
      EndIf
      
      Window = \This()\Window
      ;ElementItem - \This()\Item\IsBar
      \This()\Items()\Element = ElementItem
      
      
      \This()\iID(Str(@\This()\Items())) = ElementItem
      \This()\iHandle(Str(ElementItem)) = @\This()\Items()
      
      ;       \iID(Str(@\This()\Items())) = ElementItem
      ;       \iHandle(Str(ElementItem)) = @\This()\Items()
      
      
      Protected Type = \This()\Type
      Protected ElementWidth = \This()\FrameCoordinate\Width
      Protected ElementHeight = \This()\FrameCoordinate\Height
      
      \This()\Items()\State = #_State_Default
      \This()\Items()\Flag = Flag
      \This()\Items()\Flag = Flag
      \This()\Items()\Window = Window
      \This()\Items()\Parent\Element = Element
      
      \This()\Items()\Img\ImgBg =- 1
      \This()\Items()\bSize = 1
      \This()\Items()\Hide = 1
      \This()\Items()\BackColor =- 1 ; $FFFFFF
      \This()\Items()\Entered\Element =- 1
      \This()\Items()\Selected\Element =- 1
      
      \This()\Items()\FrameCoordinate\X = 0
      \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Y
      \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width
      
      \This()\Items()\Type = \This()\Type
      
      Select \This()\Type
        Case #_Type_Splitter
          If \This()\Splitter\FirstElement =- 1
            \This()\Items()\Flag | #_Flag_Border
          EndIf
          
          If \This()\Splitter\SecondElement =- 1
            \This()\Items()\Flag | #_Flag_Border
          EndIf
          
          If Val(Text$) = \This()\Splitter\FirstElement
            SetElementAttribute(Element, #PB_Splitter_FirstGadget, \This()\Splitter\FirstElement)
          EndIf
          If Val(Text$) = \This()\Splitter\SecondElement
            SetElementAttribute(Element, #PB_Splitter_SecondGadget, \This()\Splitter\SecondElement)
          EndIf
          
        Case #_Type_Canvas 
          \This()\Item\Selected\Element = 0;ElementItem
          \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          ;\This()\Items()\Flag | #_Flag_AlignImage_Center | #_Flag_AlignText_Center
          \This()\Items()\Flag | #_Flag_Border
          \This()\Item\Element = 0
          If \MouseY<\This()\FrameCoordinate\Y
            \This()\Items()\FrameCoordinate\X = \DeltaX
            \This()\Items()\FrameCoordinate\Y = \DeltaY
          Else
            \This()\Items()\FrameCoordinate\X = \MouseX-\This()\FrameCoordinate\X;\DeltaX
            \This()\Items()\FrameCoordinate\Y = \MouseY-\This()\FrameCoordinate\Y;\DeltaY
          EndIf
          \This()\Items()\FrameCoordinate\Width = 21
          \This()\Items()\FrameCoordinate\Height = 24
          
          
        Case #_Type_PopupMenu
          ;{ Ok }
          \This()\Items()\FrameCoordinate\X = 0
          \This()\Items()\FrameCoordinate\Y = 0
          \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
          
          ; \This()\Items()\bSize = 1
          ;\This()\Items()\Flag | #_Flag_Border
          
          \This()\Item\Y + \This()\Item\Height
          \This()\Item\X + \This()\Item\Width
          
          \This()\Items()\BackColor = \This()\BackColor
          \This()\Items()\FontColor = \This()\FontColor
          \This()\Items()\FrameColor = \This()\FrameColor
          ;\This()\Items()\Flag | #_Flag_Text_Center | #_Flag_Image_Center
          ;\This()\Items()\Flag  | #_Flag_Text_Center| #_Flag_Text_Right | #_Flag_Image_Center| #_Flag_Image_Left
          
          If StartDrawing(CanvasOutput(\Canvas))
            If \This()\FontID
              DrawingFont(\This()\FontID)
            Else
             ; DrawingFont(GetGadgetFont(#PB_Default)) ; Шрифт по умолчанию
            EndIf
            
            If Text$ 
              TextWidth = TextWidth(Text$)           ; + 4
              TextHeight = TextHeight(Text$)         ; + 4
            Else
              TextHeight = TextHeight("A")         ; + 4
            EndIf 
            
            \This()\Items()\Text\Width = TextWidth
            StopDrawing()
          EndIf
          
          If IsImage(Image) 
            ImageHeight = ImageHeight(Image); + 4
            ImageWidth = ImageWidth(Image)  ; + 4
          EndIf
          
          If \This()\Item\Type = #_Type_ComboBox
            If TextHeight : \This()\Item\Height = TextHeight : EndIf
          Else
            If TextHeight : \This()\Item\Height = TextHeight + 6 : EndIf
          EndIf
          
          If ImageHeight : \This()\Item\Height = ImageHeight + 5 : EndIf
          If ImageWidth : \This()\Item\Width = ImageWidth + 5 : EndIf
          
          If \This()\Item\Type = #_Type_ComboBox
            ;If TextWidth>\This()\Item\Width : \This()\Item\Width = TextWidth + 10 : EndIf
            If TextWidth>\This()\Item\Width 
              \This()\Item\Width = ElementWidth(\This()\Item\Parent) 
            EndIf
            ;  \This()\Item\Width = ElementWidth(\This()\Item\Parent)
          Else
            If TextWidth>\This()\Item\Width : \This()\Item\Width = TextWidth + 50 : EndIf
          EndIf
          
          
          
          If IsImage(Image) 
            ;\This()\Items()\Flag  | #_Flag_Image_Center| #_Flag_Image_Left
          Else
            ; \This()\Items()\Flag | #_Flag_AlignText_Center|#_Flag_AlignImage_Center
          EndIf
          
          ; Это значит бар
          If (TextWidth|ImageHeight|ImageWidth) = 0 
            \This()\Item\IsBar + 1 ; 
            \This()\Items()\Item\IsBar = 1
            
            
            If \This()\Item\IsVertical =- 1
              \This()\Item\Width = 20
              \This()\Item\Height = 20
              
            ElseIf \This()\Item\IsVertical 
              \This()\Item\Width = \This()\FrameCoordinate\Width 
              \This()\Item\Height = 2 + 1
            Else 
              \This()\Item\Height = \This()\FrameCoordinate\Height
              \This()\Item\Width = 2 + 1 
            EndIf
            
          EndIf
          
          
          
          If \This()\Item\IsVertical =- 1
            
          ElseIf \This()\Item\IsVertical
            \This()\Items()\FrameCoordinate\Height = \This()\Item\Height  ; - (1 To ...)
            
            ; TODO Menu;PopupMenu;Toolbar
            Select \This()\Type 
              Case #_Type_Menu, #_Type_PopupMenu, #_Type_Toolbar
                ResizeElement(Element, #PB_Ignore, #PB_Ignore, \This()\Item\Width, (\This()\Item\Y+\This()\Items()\FrameCoordinate\Height)+\This()\bSize*2, #PB_Ignore)
            EndSelect
            
            \This()\Items()\FrameCoordinate\Y = \This()\Item\Y
            \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width
            
          Else
            If \This()\Type = #_Type_Panel
              \This()\Items()\FrameCoordinate\Width = \This()\Item\Width - 1 ; - (1 to ...)
            Else
              \This()\Items()\FrameCoordinate\Width = \This()\Item\Width ; - (1 to ...)
            EndIf
            
            ; TODO Menu;PopupMenu;Toolbar
            Select \This()\Type 
              Case #_Type_Menu, #_Type_PopupMenu, #_Type_Toolbar
                ResizeElement(Element, #PB_Ignore, #PB_Ignore, (\This()\Item\X+\This()\Items()\FrameCoordinate\Width)+\This()\bSize*2, \This()\Item\Height, #PB_Ignore)
            EndSelect
            
            \This()\Items()\FrameCoordinate\X = \This()\Item\X
          EndIf
          
          If \This()\Item\IsVertical = #False
            If \This()\Type = #_Type_Panel
              \This()\Items()\FrameCoordinate\Height = \This()\CaptionHeight - 3
            Else
              \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height
            EndIf
          EndIf
          
          
          ;}
          
        Case #_Type_Menu,
             #_Type_Panel, #_Type_Properties,  #_Type_Editor ; ,#_Type_ListView
                                                             ;, #_Type_Toolbar;, #_Type_StatusBar
                                                             ;{ Ok }
          \This()\Items()\FrameCoordinate\X = 0
          \This()\Items()\FrameCoordinate\Y = 0
          \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
          
          ; \This()\Items()\bSize = 1
          ;\This()\Items()\Flag | #_Flag_Border
          
          \This()\Item\Y + \This()\Item\Height
          \This()\Item\X + \This()\Item\Width
          
          \This()\Items()\BackColor = \This()\BackColor
          \This()\Items()\FontColor = \This()\FontColor
          \This()\Items()\FrameColor = \This()\FrameColor
          ;\This()\Items()\Flag | #_Flag_Text_Center | #_Flag_Image_Center
          ;\This()\Items()\Flag  | #_Flag_Text_Center| #_Flag_Text_Right | #_Flag_Image_Center| #_Flag_Image_Left
          
          Select \This()\Type 
            Case #_Type_Editor
              ;\This()\Items()\Flag | \This()\Flag
              
              ;\This()\Items()\Flag | #_Flag_AlignText_Left| #_Flag_AlignImage_Left
              ;\This()\Items()\BackColor =- 1
              ;\This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
              
            Case #_Type_Panel 
              \This()\Item\Element = ElementItem
              \This()\Item\Selected\Element = 0;ElementItem
              \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
              \This()\Items()\Flag = #_Flag_Text_Center| #_Flag_Text_Right | #_Flag_Image_Center| #_Flag_Image_Left| #_Flag_Border
              
            Case #_Type_Properties
              \This()\Items()\BackColor =- 1
              \This()\Items()\Flag  | #_Flag_Text_Center| #_Flag_Text_Left | #_Flag_Image_Center| #_Flag_Image_Left
              
              Select Trim(StringField(Text$, 1, " "))
                Case "Button" : \This()\Items()\Type = #_Type_Button
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
                  \This()\Items()\Flag | #_Flag_Border
                  ;  \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width
                  ;  \This()\Items()\FrameCoordinate\Width = 20
                  
                Case "Spin" : \This()\Items()\Type = #_Type_Spin
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
                  \This()\Items()\Flag | #_Flag_Border
                  
                Case "ComboBox" : \This()\Items()\Type = #_Type_ComboBox
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
                  \This()\Items()\Flag | #_Flag_Border
                  
                Default
                  \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
              EndSelect
              
              Text$ = Trim(StringField(Text$, 2, " "))
              \This()\Items()\Title = Trim(StringField(Text$, 1, ":"))+":"
              Text$ = Trim(StringField(Text$, 2, ":"))
              
              If Text$ = ""
                Text$ = " "
              EndIf
              
          EndSelect
          
          If StartDrawing(CanvasOutput(\Canvas))
            If \This()\FontID
              DrawingFont(\This()\FontID)
            Else
             ; DrawingFont(GetGadgetFont(#PB_Default)) ; Шрифт по умолчанию
            EndIf
            
            If Text$ 
              TextWidth = TextWidth(Text$)           ; + 4
              TextHeight = TextHeight(Text$)         ; + 4
            Else
              TextHeight = TextHeight("A")         ; + 4
            EndIf 
            StopDrawing()
          EndIf
          
          If IsImage(Image) 
            ImageHeight = ImageHeight(Image); + 4
            ImageWidth = ImageWidth(Image)  ; + 4
          EndIf
          
          Select \This()\Type 
            Case #_Type_Editor
              If TextHeight : \This()\Item\Height = TextHeight : EndIf
            Case #_Type_PopupMenu
              If \This()\Item\Type = #_Type_ComboBox
                If TextHeight : \This()\Item\Height = TextHeight : EndIf
              Else
                If TextHeight : \This()\Item\Height = TextHeight + 9 : EndIf
              EndIf
              
            Default ; Case #_Type_ComboBox, #_Type_Menu , #_Type_PopupMenu, #_Type_Toolbar, #_Type_ListView
              If TextHeight : \This()\Item\Height = TextHeight + 9 : EndIf
          EndSelect
          
          If ImageHeight : \This()\Item\Height = ImageHeight + 5 : EndIf
          If ImageWidth : \This()\Item\Width = ImageWidth + 5 : EndIf
          
          If \This()\Item\IsVertical
            Select \This()\Type 
              Case #_Type_PopupMenu
                If \This()\Item\Type = #_Type_ComboBox
                  If TextWidth>\This()\Item\Width : \This()\Item\Width = TextWidth + 10 : EndIf
                Else
                  If TextWidth>\This()\Item\Width : \This()\Item\Width = TextWidth + 50 : EndIf
                EndIf
                
              Case #_Type_Editor
                \This()\Item\Width = \This()\InnerCoordinate\Width
              Default ; Case #_Type_ComboBox, #_Type_Menu , #_Type_PopupMenu, #_Type_Toolbar, #_Type_ListView
                If TextWidth>\This()\Item\Width : \This()\Item\Width = TextWidth + 10 : EndIf
            EndSelect
            
          Else
            If TextWidth 
              \This()\Item\Width = TextWidth + ImageWidth + 8 + 10
            EndIf
          EndIf
          
          
          If IsImage(Image) 
            ;\This()\Items()\Flag  | #_Flag_Image_Center| #_Flag_Image_Left
          Else
            ; \This()\Items()\Flag | #_Flag_AlignText_Center|#_Flag_AlignImage_Center
          EndIf
          
          ; Это значит бар
          If (TextWidth|ImageHeight|ImageWidth) = 0 
            \This()\Item\IsBar + 1 ; 
            \This()\Items()\Item\IsBar = 1
            
            
            If \This()\Item\IsVertical =- 1
              \This()\Item\Width = 20
              \This()\Item\Height = 20
              
            ElseIf \This()\Item\IsVertical 
              \This()\Item\Width = \This()\FrameCoordinate\Width 
              \This()\Item\Height = 2 + 1
            Else 
              \This()\Item\Height = \This()\FrameCoordinate\Height
              \This()\Item\Width = 2 + 1 
            EndIf
            
          EndIf
          
          
          
          If \This()\Item\IsVertical =- 1
            
          ElseIf \This()\Item\IsVertical
            \This()\Items()\FrameCoordinate\Height = \This()\Item\Height  ; - (1 To ...)
            
            ; TODO Menu;PopupMenu;Toolbar
            Select \This()\Type 
              Case #_Type_Menu, #_Type_PopupMenu, #_Type_Toolbar
                ResizeElement(Element, #PB_Ignore, #PB_Ignore, \This()\Item\Width, (\This()\Item\Y+\This()\Items()\FrameCoordinate\Height)+\This()\bSize*2, #PB_Ignore)
            EndSelect
            
            \This()\Items()\FrameCoordinate\Y = \This()\Item\Y
            \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width
            
          Else
            If \This()\Type = #_Type_Panel
              \This()\Items()\FrameCoordinate\Width = \This()\Item\Width - 1 ; - (1 to ...)
            Else
              \This()\Items()\FrameCoordinate\Width = \This()\Item\Width ; - (1 to ...)
            EndIf
            
            ; TODO Menu;PopupMenu;Toolbar
            Select \This()\Type 
              Case #_Type_Menu, #_Type_PopupMenu, #_Type_Toolbar
                ResizeElement(Element, #PB_Ignore, #PB_Ignore, (\This()\Item\X+\This()\Items()\FrameCoordinate\Width)+\This()\bSize*2, \This()\Item\Height, #PB_Ignore)
            EndSelect
            
            \This()\Items()\FrameCoordinate\X = \This()\Item\X
          EndIf
          
          If \This()\Item\IsVertical = #False
            If \This()\Type = #_Type_Panel
              \This()\Items()\FrameCoordinate\Height = \This()\CaptionHeight - 3
            Else
              \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height
            EndIf
          EndIf
          
          
          ;}
          
        Case #_Type_ComboBox
          \This()\Items()\BackColor =- 1
          
          If ((\This()\Flag & #_Flag_Editable) = #_Flag_Editable)
            \This()\Items()\BackColor = $FFFFFF
            ;\This()\Items()\Flag | #_Flag_Editable
            \This()\Items()\DrawingMode = #PB_2DDrawing_Default
          Else
            \This()\Items()\BackColor =- 1
            \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
          EndIf
          
        Case #_Type_Spin
          \This()\Items()\Flag = Flag
          \This()\Items()\BackColor =- 1
          \This()\Items()\Radius = \This()\Radius
          \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          
        Case #_Type_TrackBar
          \This()\Items()\BackColor =- 1 ; $D2D2D2 ;$D0D0D0 ; $F0F0F0 ; $C0C0C0 ; $A0A0A0 ; $787878 ; $DCDCDC
          \This()\Items()\IsVertical = Bool(((\This()\Flag&#_Flag_Vertical) = #_Flag_Vertical))
          \This()\Items()\Flag = Flag
          \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          
        Case #_Type_ScrollBar
          \This()\Items()\BackColor =- 1 ; $D2D2D2 ;$D0D0D0 ; $F0F0F0 ; $C0C0C0 ; $A0A0A0 ; $787878 ; $DCDCDC
          \This()\Items()\IsVertical = Bool(((\This()\Flag&#_Flag_Vertical) = #_Flag_Vertical))
          \This()\Items()\Flag = Flag
          \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          
        Case #_Type_ScrollArea
          \This()\Items()\BackColor =- 1 ; $D2D2D2
          \This()\Items()\IsVertical = Bool(((\This()\Flag&#_Flag_Vertical) = #_Flag_Vertical))
          \This()\Items()\Flag = Flag
          \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          
        Case #_Type_Window
          \This()\Items()\BackColor =- 1
          \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          
          If (ListIndex(\This()\Items()) = 0)
            \This()\Items()\Text\String$ = \This()\Text\String$
            \This()\Items()\FrameCoordinate\Height = \This()\CaptionHeight
            \This()\Items()\Flag =  #_Flag_Text_Center|#_Flag_Text_Left|#_Flag_Image_Center|#_Flag_Image_Left
          EndIf
          
          \This()\Text\String$ = ""
      EndSelect
      
      ; Properties
      Select \This()\Type 
        Case #_Type_Properties
          \This()\Items()\FrameCoordinate\Height = \This()\Item\Height-1
          
          \This()\Splitter\Size = 1
          \This()\Splitter\Pos = 70;TextWidth(\This()\Items()\Title);\This()\Item\Width-\This()\InnerCoordinate\Width
      EndSelect 
      
      \This()\Items()\Text\String$ = Text$
      
      Select \This()\Type 
        Case #_Type_PopupMenu
          \This()\Items()\Img\Image =- 1
          \This()\Items()\Img\Image1 = Image
          \This()\Items()\Img\Image2 =- 1
        Default
          \This()\Items()\Img\Image = Image
          \This()\Items()\Img\Image1 = max
          \This()\Items()\Img\Image2 = mxd
      EndSelect
      
      \This()\Items()\SelectedFontColor = $FFFFFF
      \This()\Items()\SelectedBackColor = $FAD4AD;$FACC9D;$FCE0C4;$FFBAA0
      \This()\Items()\EnteredFontColor = $505050
      \This()\Items()\EnteredBackColor = $FCDFC3
      
      
      Select Type
        Case #_Type_Menu, #_Type_Toolbar, #_Type_StatusBar
          If IsElement(\This()\Parent\Element) 
            PushListPosition(\This())
            ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element)) 
            If Type = #_Type_Menu : \This()\MenuHeight = ElementHeight : EndIf
            If Type = #_Type_Toolbar : \This()\ToolBarHeight = ElementHeight : EndIf
            If Type = #_Type_StatusBar : \This()\StatusBarHeight = ElementHeight : EndIf
            ResizeElementY(\This(), \This()\FrameCoordinate\Y)
            PopListPosition(\This())
          EndIf
      EndSelect
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn ElementItem
EndProcedure


Procedure Property_GadgetTimer( Milliseconds )
  Static Delay, Result
  If Delay = #False : Delay = ElapsedMilliseconds() : EndIf
  If ((ElapsedMilliseconds() - Delay) > =  (Milliseconds * 2)) 
    Delay = #False
    Result ! 1
  EndIf
  ProcedureReturn Result
EndProcedure


;-
Procedure DrawArrow(X,Y, Size, Direction, Color, Thickness = 1) ; Рисуем стрелки
  Protected I
  
  ;ClipOutput(X-Thickness , Y-Thickness, Size*2+Thickness, Size*2+Thickness)
  
  If Direction = 1
    For i = 0 To Size 
      ; в верх
      LineXY((X+i)+Size,(Y+i-1)-(Thickness),(X+i)+Size,(Y+i-1)+(Thickness),Color) ; Левая линия
      LineXY(((X+(Size))-i),(Y+i-1)-(Thickness),((X+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
    Next
  ElseIf Direction = 3
    For i = 0 To Size
      ; в низ
      LineXY((X+i),(Y+i)-(Thickness),(X+i),(Y+i)+(Thickness),Color) ; Левая линия
      LineXY(((X+(Size*2))-i),(Y+i)-(Thickness),((X+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
    Next
  ElseIf Direction = 0 ; в лево
    For i = 0 To Size  
      ; в лево
      LineXY(((X+1)+i)-(Thickness),(((Y-2)+(Size))-i),((X+1)+i)+(Thickness),(((Y-2)+(Size))-i),Color) ; правая линия
      LineXY(((X+1)+i)-(Thickness),((Y-2)+i)+Size,((X+1)+i)+(Thickness),((Y-2)+i)+Size,Color)         ; Левая линия
    Next
  ElseIf Direction = 2 ; в право
    For i = 0 To Size
      ; в право
      LineXY(((X+2)+i)-(Thickness),((Y-2)+i),((X+2)+i)+(Thickness),((Y-2)+i),Color) ; Левая линия
      LineXY(((X+2)+i)-(Thickness),(((Y-2)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y-2)+(Size*2))-i),Color) ; правая линия
    Next
  EndIf
  
  ;UnclipOutput()
EndProcedure

Procedure ClipCoordinate(List This.S_CREATE_ELEMENT(), X,Y,Width,Height)
  Protected iX, iY, iWidth, iHeight
  
  If *CreateElement\This()\bSize
    Protected b = 0
  EndIf
  
  With *CreateElement\This()
    
    If \Width = \FrameCoordinate\Width
      iX = (\X+\bSize)+b
      iWidth = (\Width-\bSize*2)-b*2
    Else
      iX = \X+b
      iWidth = \Width-b*2
    EndIf
    
    If \Height = \FrameCoordinate\Height
      iY = (\Y+\bSize)+b
      iHeight = (\Height-\bSize*2)-b*2
    Else
      iY = (\Y)+b
      iHeight = (\Height)+b*2
    EndIf
    
    ;     If (ListIndex(\Items()) = 0 And \CaptionHeight)
    ;       b = 0
    ;       iY = (\Y+\bSize)+b
    ;       iX = (\X+\bSize)+b
    ;       
    ;       iWidth = (\Width-\bSize*2)+b*2
    ;       iHeight = (\Height-\bSize*2)+b*2
    ; ;       iWidth = (\Width-\bSize*2) - 1
    ; ;       iHeight = (\Height-\bSize*2) - 1
    ;     EndIf
  EndWith
  
  With This()
    \X = X : \Y = Y : \Width = Width : \Height = Height 
    
    If \X < iX : \X = iX : \Width - (iX-X) : EndIf
    If \Y < iY : \Y = iY : \Height - (iY-Y) : EndIf
    If ((iX+iWidth)<(X+Width)) : \Width = (iWidth - (\X-iX)) : EndIf
    If (iY+iHeight)<(Y+Height) : \Height = (iHeight - (\Y-iY)) : EndIf
    
    ; Clip draw area elements
    ClipOutput(\X,\Y,\Width,\Height)
  EndWith
  
  
EndProcedure


; - Internal Procedures
Procedure ContrastColor(iColor)
  Protected luma.d
  ;  Counting the perceptive luminance (aka luma) - human eye favors green color... 
  luma  = (0.299 * Red(iColor) + 0.587 * Green(iColor) + 0.114 * Blue(iColor)) / 255
  
  ; Return black For bright colors, white For dark colors
  If luma > 0.6
    ProcedureReturn #Black
  Else
    ProcedureReturn #White
  EndIf
EndProcedure

Procedure ResizeContent(List This.S_CREATE_ELEMENT())
  Protected DrawingMode,Image, Text$, Flag.q ;, X,Y, Width,Height
  Protected Element, iX,iY,iWidth,iHeight, BackColor =- 1, FrameColor =- 1, TopColor =- 1, FontColor =- 1
  Protected Txt_X, Txt_Y, Img_X, Img_Y, Img_Width, Img_Height
  Protected TextWidth, TextHeight, ImageWidth, ImageHeight, vb = 0,hb = 0
  
  With This() 
    Flag = \Flag
    Image = \Img\Image
    Text$ = \Text\String$ ; \Text\Drawing$ ; 
    
    Element = \Element
    
    FontColor = \FontColor
    BackColor = \BackColor
    FrameColor = \FrameColor
    DrawingMode = \DrawingMode
    
    iX = \InnerCoordinate\X 
    iY = \InnerCoordinate\Y
    iWidth = \InnerCoordinate\Width
    iHeight = \InnerCoordinate\Height
    
    If ((Flag & #_Flag_MultiLine) = #_Flag_MultiLine)
      Txt_X = iX
      Txt_Y = iY
    Else
      If ((Flag & #_Flag_Text_Center) = #_Flag_Text_Center)
        
        If ((Flag & #_Flag_Text_Top) = #_Flag_Text_Top) Or 
           ((Flag & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)
          Flag &~ #_Flag_Text_HCenter
        EndIf
        If ((Flag & #_Flag_Text_Left) = #_Flag_Text_Left) Or
           ((Flag & #_Flag_Text_Right) = #_Flag_Text_Right)
          Flag &~ #_Flag_Text_VCenter
        EndIf
        
      EndIf
      If ((Flag & #_Flag_Image_Center) = #_Flag_Image_Center)
        
        If ((Flag & #_Flag_Image_Top) = #_Flag_Image_Top) Or 
           ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom)
          Flag &~ #_Flag_Image_HCenter
        EndIf
        If ((Flag & #_Flag_Image_Left) = #_Flag_Image_Left) Or
           ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right)
          Flag &~ #_Flag_Image_VCenter
        EndIf
        
      EndIf
      
      Txt_Y = \bSize + 1
      Txt_X = \bSize
      
      If Text$
        TextWidth = TextWidth(Text$)
        TextHeight = TextHeight(Text$)
        
        ;         If ((Flag & #_Flag_Text_HCenter) = #_Flag_Text_HCenter)
        ;           Txt_Y = ((iHeight-TextHeight) / 2)
        ;         ElseIf ((Flag & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)
        ;           Txt_Y = ((iHeight-TextHeight) - vb)
        ;         EndIf
        ;         
        ;         If ((Flag & #_Flag_Text_VCenter) = #_Flag_Text_VCenter)
        ;           Txt_X = ((iWidth-TextWidth) / 2)
        ;         ElseIf ((Flag & #_Flag_Text_Right) = #_Flag_Text_Right)
        ;           Txt_X = ((iWidth-TextWidth) - hb)
        ;         EndIf
        
      Else
        TextHeight = TextHeight("A")
      EndIf
      
      If IsImage(Image)
        ImageWidth = ImageWidth(Image)
        ImageHeight = ImageHeight(Image)
        
        If ((Flag & #_Flag_Image_HCenter) = #_Flag_Image_HCenter)
          Img_Y = ((iHeight-ImageHeight) / 2)
        ElseIf ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom)
          Img_Y = ((iHeight-ImageHeight) - vb)
        EndIf
        
        If ((Flag & #_Flag_Image_VCenter) = #_Flag_Image_VCenter)
          Img_X = ((iWidth-ImageWidth) / 2)
        ElseIf ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right)
          Img_X = ((iWidth-ImageWidth) - hb)
        EndIf
      EndIf
      
      Txt_X + iX 
      Txt_Y + iY
      
      If Flag & #_Flag_Image_Center
        If ((Flag & #_Flag_Image_Left) = #_Flag_Image_Left) Or 
           ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right)
          Txt_X + Img_X
        EndIf
        If ((Flag & #_Flag_Image_Top) = #_Flag_Image_Top) Or 
           ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom)
          Txt_Y + Img_Y
        EndIf
      EndIf 
      
      Img_X + iX
      Img_Y + iY
      
      If ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right) And 
         ((Flag & #_Flag_Text_Left) = #_Flag_Text_Left)
        Img_X = iX+((iWidth-ImageWidth-TextWidth) / 2) : If TextWidth : Img_X - hb : EndIf
        Txt_X = iX+((iWidth-TextWidth+ImageWidth) / 2) : If ImageWidth : Txt_X + hb : EndIf
      EndIf
      If ((Flag & #_Flag_Image_Left) = #_Flag_Image_Left) And 
         ((Flag & #_Flag_Text_Right) = #_Flag_Text_Right)
        Img_X = iX+((iWidth-ImageWidth+TextWidth) / 2) + hb : If TextWidth : Img_X + hb : EndIf 
        Txt_X = iX+((iWidth-TextWidth-ImageWidth) / 2) - hb : If ImageWidth : Txt_X - hb : EndIf
      EndIf
      If ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom) And 
         ((Flag & #_Flag_Text_Top) = #_Flag_Text_Top)
        Img_Y = iY+((iHeight-ImageHeight-TextHeight) / 2) - vb : If TextHeight : Img_Y - vb : EndIf 
        Txt_Y = iY+((iHeight-TextHeight+ImageHeight) / 2) + vb : If ImageHeight : Txt_Y + vb : EndIf
      EndIf
      If ((Flag & #_Flag_Image_Top) = #_Flag_Image_Top) And 
         ((Flag & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)
        Img_Y = iY+((iHeight-ImageHeight+TextHeight) / 2) + vb : If TextHeight : Img_Y + vb : EndIf 
        Txt_Y = iY+((iHeight-TextHeight-ImageHeight) / 2) - vb : If ImageHeight : Txt_Y - vb : EndIf
      EndIf
      
    EndIf
    
    \Text\X = Txt_X
    \Text\Y = Txt_Y
    
    
  EndWith
EndProcedure

Procedure ClipInnerCoordinates(List This.S_CREATE_ELEMENT())
  Protected ClipX, ClipY, ClipWidth, ClipHeight
  
  With This()
    If *CreateElement\This() = This()
      If \InnerCoordinate\X > \X
        ClipX = \InnerCoordinate\X
      Else
        ClipX = \X  
      EndIf
      If \InnerCoordinate\Y > \Y ; -\CaptionHeight
        ClipY = \InnerCoordinate\Y ; -\CaptionHeight
      Else
        ClipY = \Y  
      EndIf
      If \InnerCoordinate\Width < \Width
        ClipWidth = \InnerCoordinate\Width
      Else
        ClipWidth = \Width  
      EndIf
      If \InnerCoordinate\Height < \Height ; +\CaptionHeight
        ClipHeight = \InnerCoordinate\Height ; +\CaptionHeight
      Else
        ClipHeight = \Height  
      EndIf
      
      ClipOutput(ClipX,ClipY,ClipWidth,ClipHeight) 
      
      ;       DrawingMode(#PB_2DDrawing_Outlined)
      ;       Box(ClipX,ClipY,ClipWidth,ClipHeight,$1212FF) ; TODO
    Else
      
    EndIf
  EndWith
  
EndProcedure

;-
Procedure DrawContent(List This.S_CREATE_ELEMENT(), X = 0,Y = 0,Width = 0,Height = 0 )
  Protected DrawingMode,Image, Text$, Flag.q, CaptionHeight ;, X,Y, Width,Height
  Protected State, Element, iX,iY,iWidth,iHeight, BackColor =- 1, FrameColor =- 1, TopColor =- 1, FontColor =- 1
  
  With This() 
    State = \State
    Flag = \Flag
    Image = \Img\Image
    Text$ = \Text\String$ ; \Text\Drawing$ ; 
    
    Element = \Element
    ;Flag|#_Flag_Border
    
    FontColor = \FontColor
    BackColor = \BackColor
    FrameColor = \FrameColor
    DrawingMode = \DrawingMode
    ;     
    X = \FrameCoordinate\X+X
    Y = \FrameCoordinate\Y+Y
    Width = \FrameCoordinate\Width+Width
    Height = \FrameCoordinate\Height+Height
    ; TODO -----
    ;     X = \FrameCoordinate\X+(\bSize-\BorderSize)+X
    ;     Y = \FrameCoordinate\Y+(\bSize-\BorderSize)+Y
    ;     Width = \FrameCoordinate\Width-(\bSize-\BorderSize)*2-1+Width
    ;     Height = \FrameCoordinate\Height-(\bSize-\BorderSize)*2-1+Height
    
    iX = \InnerCoordinate\X 
    iY = \InnerCoordinate\Y
    iWidth = \InnerCoordinate\Width
    iHeight = \InnerCoordinate\Height
    
    
    ; Clip draw area elements
    If (*CreateElement\This() = This())
      ClipOutput(\X,\Y,\Width,\Height)
    Else
      iX = X+\bSize 
      iY = Y+\bSize  
      iWidth = Width-\bSize*2 
      iHeight = Height-\bSize*2 
      ClipCoordinate(This(), X,Y,Width,Height+\MenuHeight);+\ToolBarHeight)
    EndIf
    
    ;;alpha = Point(hit_x, hit_y) >> 24 ; get alpha
    
    
    ;{ Colors then draw
    If BackColor =- 1
      If ((State & #_State_Default) = #_State_Default)
        FrameColor = $ACACAC
        TopColor = $F0F0F0
        BackColor = $E5E5E5
      ElseIf ((State & #_State_Entered) = #_State_Entered)
        If Image = cls
          FrameColor = $EAB47E
          TopColor = $B4C2FF
          BackColor = $0533FF
        Else
          FrameColor = $EAB47E
          TopColor = $FCF4EC
          BackColor = $FCECDC
        EndIf
      ElseIf ((State & #_State_Selected) = #_State_Selected)
        If Image = cls
          FrameColor = $EAB47E
          TopColor = $B4C2FF
          BackColor = $193EEC
        Else
          FrameColor = $E59D55
          TopColor = $FCECDA
          BackColor = $FCE0C4
        EndIf
      EndIf
    EndIf
    
    If ((State & #_State_Focused) = #_State_Focused)
      ;         If Image = cls
      ;           FrameColor = $EAB47E
      ;           TopColor = $B4C2FF
      ;           BackColor = $193EEC
      ;         Else
      FrameColor = $DD8C26;$E59D55
                          ;           TopColor = $FCECDA
                          ;           BackColor = $FCE0C4
                          ;         EndIf
    EndIf
    
    Protected Alpha 
    If (\Disable Or *CreateElement\This()\Disable)
      Alpha = 128 
      Protected R,G,B
      R = Red(\FontColor)   * 0.4 + Red(\BackColor)   * 0.6
      R + Green(\FontColor) * 0.4 + Green(\BackColor) * 0.6
      R + Blue(\FontColor)  * 0.4 + Blue(\BackColor)  * 0.6
      If \Type = #_Type_Text
        R = R / 3
      Else
        R = R / 5
      EndIf
      G = R
      B = R
      
      FontColor = RGB(R, G, B) ; $949699
      FrameColor = $CACACA     ;C0C0C0
      TopColor = $F1F1F1
      BackColor = $F0F0F0
      ; FontColor = Negative(\FontColor)
      ;       FrameColor = Negative(FrameColor)
      ;       TopColor = Negative(TopColor)
      ;  BackColor = Negative(BackColor)
    Else 
      Alpha = 255  
    EndIf
    
    If *CreateElement\This()\CaptionHeight
      If ((State & #_State_Default) = #_State_Default)
        Alpha = 190
      ElseIf ((State & #_State_Entered) = #_State_Entered)
        Alpha = 255
        
      ElseIf ((State & #_State_Selected) = #_State_Selected)
        
      EndIf
    EndIf
    
    
    ;     If This()\Toggle Or *CreateElement\This()\Toggle
    ;       FontColor = $949699
    ;       FrameColor = $DD8C26
    ;       TopColor = $FCECDA
    ;       BackColor = $FCE0C4
    ;       
    ;     EndIf
    
    ;     If *CreateElement\This()\Interact = 0
    ;       FrameColor = $ACACAC
    ;       TopColor = $F0F0F0
    ;       BackColor = $E5E5E5
    ;     EndIf
    ;}
    
    
    ; Draw backcolor elements all
    Select DrawingMode 
      Case #PB_2DDrawing_Default
        DrawingMode(#PB_2DDrawing_Default)
        If (\Radius > 0) And \Type <> #_Type_CheckBox
          If ((Flag & #_Flag_Border) = #_Flag_Border)
            RoundBox(iX, (iY-\MenuHeight-\ToolBarHeight)-1, iWidth, (iHeight+\MenuHeight+\ToolBarHeight)+1, \Radius, \Radius, BackColor)
          Else
            RoundBox(X, Y, Width, Height, \Radius, \Radius, BackColor)
          EndIf
        Else
          If ((Flag & #_Flag_Border) = #_Flag_Border)
            Box(iX, (iY-\MenuHeight-\ToolBarHeight)-1, iWidth, (iHeight+\MenuHeight+\ToolBarHeight)+1, BackColor)
          Else
            Box(iX, iY, iWidth, iHeight, BackColor)
          EndIf
        EndIf
        
      Case #PB_2DDrawing_Gradient
        DrawingMode(#PB_2DDrawing_Gradient)
        BackColor(TopColor)
        FrontColor(BackColor)
        LinearGradient(iX, iY-1, iX, (iY+iHeight))
        If (\Radius > 0) And \Type <> #_Type_CheckBox
          RoundBox(iX, iY, iWidth, (iHeight+\MenuHeight+\ToolBarHeight), \Radius, \Radius)
        Else
          Box(iX, iY, iWidth, (iHeight+\MenuHeight+\ToolBarHeight))
        EndIf
        BackColor(#PB_Default)
        FrontColor(#PB_Default) ; bug
    EndSelect
    
    ; Draw border elements all
    If ((Flag & #_Flag_Border) = #_Flag_Border)
      DrawingMode(#PB_2DDrawing_Outlined) 
      ;       If (\Radius > 0)
      ;         RoundBox(X, Y, Width, Height, \Radius, \Radius, FrameColor)
      ;       Else
      ;         Box(X,Y,Width,Height, FrameColor)
      ;       EndIf
      
      If ((Flag & #_Flag_Flat) = #_Flag_Flat)
        Box(iX-1,iY-1,iWidth+2,iHeight+2, $9E9E9E)  
        
      ElseIf ((Flag & #_Flag_Single) = #_Flag_Single)
        Line(iX-1,iY-1,iWidth+2,1, $9E9E9E)
        Line(iX-1,iY-1,1,iHeight+2, $9E9E9E)
        Line(iX-1,(iY+iHeight),iWidth+2,1, $FFFFFF)
        Line((iX+iWidth),iY-1,1,iHeight+2, $FFFFFF)
        
      ElseIf ((Flag & #_Flag_Double) = #_Flag_Double)
        Line(iX-2,iY-2,iWidth+4,1, $9E9E9E)
        Line(iX-2,iY-2,1,iHeight+4, $9E9E9E)
        
        Line(iX-1,iY-1,iWidth+2,1, $888888)
        Line(iX-1,iY-1,1,iHeight+2, $888888)
        Line(iX-1,(iY+iHeight),iWidth+2,1, $E1E1E1)
        Line((iX+iWidth),iY-1,1,iHeight+2, $E1E1E1)
        
        Line(iX-2,(iY+iHeight)+1,iWidth+4,1, $FFFFFF)
        Line((iX+iWidth)+1,iY-2,1,iHeight+4, $FFFFFF)
        
      ElseIf ((Flag & #_Flag_Raised) = #_Flag_Raised)
        Line(iX-2,iY-2,iWidth+4,1, $E1E1E1)
        Line(iX-2,iY-2,1,iHeight+4, $E1E1E1)
        
        Line(iX-1,iY-1,iWidth+2,1, $FFFFFF)
        Line(iX-1,iY-1,1,iHeight+2, $FFFFFF)
        Line(iX-1,(iY+iHeight),iWidth+2,1, $9E9E9E)
        Line((iX+iWidth),iY-1,1,iHeight+2, $9E9E9E)
        
        Line(iX-2,(iY+iHeight)+1,iWidth+4,1, $888888)
        Line((iX+iWidth)+1,iY-2,1,iHeight+4, $888888)
        
      Else
        If (\Radius > 0) And \Type <> #_Type_CheckBox
          RoundBox((X+\bSize)-1,(Y+\bSize)-1,(Width-\bSize*2)+2,(Height-\bSize*2)+2, \Radius, \Radius, FrameColor)
        Else
          If \CaptionHeight
            ;Line((X+\bSize)-1,(Y+\bSize+\CaptionHeight)-1,(Width-\bSize*2)+2,1, FrameColor)
            Line((X+\bSize)-1,((Y+\bSize)+\CaptionHeight+\MenuHeight+\ToolBarHeight)-1,(Width-\bSize*2)+2,1, FrameColor)
          EndIf
          
          Box((X+\bSize)-1,(Y+\bSize)-1,(Width-\bSize*2)+2,(Height-\bSize*2)+2, FrameColor)
        EndIf
      EndIf
    EndIf
    
    Protected iW
    
    Select *CreateElement\This()\Type ; Draw image content
      Case #_Type_Frame
        DrawingMode(#PB_2DDrawing_Default) 
        iY = iY-TextHeight("A")/2-2
        Box(iX+5,iY,TextWidth(Text$),TextHeight("A"),$F0F0F0)
        iY= \FrameCoordinate\Y
        
      Case #_Type_CheckBox
        Protected i = 1
        If ((Flag & #_Flag_Border) = #_Flag_Border)
          i = 3
        EndIf
        
        DrawingMode(#PB_2DDrawing_Outlined) 
        If (\Radius > 0)
          RoundBox(iX+i, iY+(iHeight-13)/2, 13, 13, \Radius, \Radius, FrameColor)
        Else
          Box(iX+i, iY+(iHeight-13)/2, 13, 13, FrameColor)
        EndIf
        
        DrawingMode(#PB_2DDrawing_Default) 
        Box(iX+i+1, iY+(iHeight-13)/2+1, 13-2, 13-2, $FFFFFF)
        
        If \Checked = 1
          DrawingMode(#PB_2DDrawing_Default) 
          Protected xx = X+i, yy = (Y)+(iHeight-10)/2+1, inColor = \FrameColor
          Line(xx+2,Yy+4,4,4,0)
          Line(xx+2,Yy+4+1,3,3,0)
          
          Line(xx+5,Yy+6,6,-6,0)
          Line(xx+5,Yy+6+1,6,-6,0)
          
        ElseIf \Inbetween ; \Checked = 1
          DrawingMode(#PB_2DDrawing_Default) 
          Box(X+3+i,(Y)+(iHeight-7)/2,7,7, 0)
        EndIf  
        \Text\PosX =- 14
        
      Case #_Type_Option
        ; Draw circle (radius = 13)
        DrawingMode(#PB_2DDrawing_Default) : Circle(iX+6.50, iY+(iHeight)/2, 6.50, #White)
        DrawingMode(#PB_2DDrawing_Outlined) : Circle(iX+6.50, iY+(iHeight)/2, 6.50, FrameColor)
        
        ; Group option elements
        If IsElement(\OptionGroup)
          PushListPosition(*CreateElement\This())
          ChangeCurrentElement(*CreateElement\This(), ElementID(\OptionGroup))
          If *CreateElement\This()\OptionGroup = Element ; Draw selector
            DrawingMode(#PB_2DDrawing_Default) : Circle(iX+7.5, iY+(iHeight)/2, 4.1, FrameColor)
          EndIf
          PopListPosition(*CreateElement\This())
        EndIf
        
        \Text\PosX =- 14
        
      Case #_Type_ComboBox
        ; Draw arrow on the element
        DrawingMode(#PB_2DDrawing_Default) 
        If (*CreateElement\This() = This()) 
          \Text\PosX =- 2+\bSize
          DrawArrow(iX+(iWidth-(\Item\Width+(3*2))/2),iY+(iHeight-3)/2,3,3,$555555)
        ElseIf ((*CreateElement\This()\Flag & #_Flag_Editable) = #_Flag_Editable) 
          DrawArrow((iX+4),(iY+((iHeight-3)/2))+0.5,3,3,$555555)
        EndIf
        
        iW = (\Item\Width)
        
      Case #_Type_Spin ; : DrawingSpinElementContent(This())
                       ; Линия слева для красоты
        DrawingMode(#PB_2DDrawing_Default) : Line(iX+(iWidth-\Item\Width),iY,1,iHeight,FrameColor)
        
        ; Draw arrow on the element
        Select ListIndex(This())
          Case 0 : DrawArrow(iX+((3*2))/2,(iY+((iHeight-2)/2))+1,2,1,$555555)
          Case 1 : DrawArrow(iX+((3*2))/2,(iY+((iHeight-2)/2)),2,3,$555555)
        EndSelect
        
        \Text\PosX =- 2
        iW = \Item\Width
        
        
      Case #_Type_ScrollBar
        ; Draw arrow on the element
        DrawingMode(#PB_2DDrawing_Default) 
        If *CreateElement\This() = This()
          ; Линия слева для красоты
          If \IsVertical
            Line(iX,iY,1,iHeight,$FFFFFF)
          Else
            Line(iX,iY,iWidth,1,$FFFFFF)
          EndIf
        EndIf
        
        If \IsVertical
          Select ListIndex(This())
            Case 0 : DrawArrow((iX+((iWidth-6)/2)),(iY+((iHeight-2)/2)),3,1,$555555)
            Case 1 : DrawArrow((iX+((iWidth-6)/2)),(iY+((iHeight-2)/2)),3,3,$555555)
          EndSelect
        Else
          Select ListIndex(This())
            Case 0 : DrawArrow((iX+((iWidth-6)/2)),(iY+((iHeight-2)/2)),3,0,$555555)
            Case 1 : DrawArrow((iX+((iWidth-6)/2)),(iY+((iHeight-2)/2)),3,2,$555555)
          EndSelect
        EndIf
        
      Case #_Type_PopupMenu 
        If (*CreateElement\This()\Item\Type <> #_Type_ComboBox)
          iX+*CreateElement\MenuHeight+1
        EndIf
    EndSelect
    
    
    
    Protected Txt_X, Txt_Y, Img_X, Img_Y, Img_Width, Img_Height
    Protected TextWidth, TextHeight, ImageWidth, ImageHeight, vb = 0,hb = 0, ivb = 2,ihb = 2;4
    
    ;     iX + 1 
    ;     iY + 1 
    ;     iWidth -2 - iW
    ;     iHeight -2
    ;     
    ;     If (*CreateElement\This() = This()) And ListSize(*CreateElement\This()\Items())
    ;       ClipOutput(iX,iY,iWidth,iHeight)
    ;       ;       DrawingMode(#PB_2DDrawing_Outlined) 
    ;       ;       Box(iX,iY,iWidth,iHeight,0)
    ;     EndIf
    
    ClipInnerCoordinates(This())
    
    
    
    ; Точки ставить если не помещается
    If Text$ And ((Flag & #_Flag_MultiLine) = 0) And (*CreateElement\This() <> This())
      ;       ; Текст в заголовке
      ;       If *CreateElement\This()\Type = #_Type_Window
      ;         If (*CreateElement\This() = This())
      ;         Else
      ;           If \CaptionHeight
      ;             ClipOutput(\X,\Y,\Width-((ListSize(This())-1)*32)-*CreateElement\This()\bSize,\Height)
      ;           EndIf
      ;         EndIf
      ;       EndIf
      
      Protected Index,iiWidth
      If \CaptionHeight
        iiWidth = iWidth -((ListSize(This())-1)*32)-10
      Else
        iiWidth = iWidth
      EndIf
      
      If (TextWidth("...") > iiWidth)
        Text$ = ".."
      Else
        While (TextWidth(Text$)>iiWidth)
          Text$ = (Left(Text$,Len(Text$)-(Index+Len("...")))+"...")
          Index+1
        Wend
      EndIf
    EndIf
    
    
    If ((Flag & #_Flag_MultiLine) = #_Flag_MultiLine)
      Txt_X = iX
      Txt_Y = iY
    Else
      If ((Flag & #_Flag_Text_Center) = #_Flag_Text_Center)
        
        If ((Flag & #_Flag_Text_Top) = #_Flag_Text_Top) Or 
           ((Flag & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)
          Flag &~ #_Flag_Text_HCenter
        EndIf
        If ((Flag & #_Flag_Text_Left) = #_Flag_Text_Left) Or
           ((Flag & #_Flag_Text_Right) = #_Flag_Text_Right)
          Flag &~ #_Flag_Text_VCenter
        EndIf
        
      EndIf
      If ((Flag & #_Flag_Image_Center) = #_Flag_Image_Center)
        
        If ((Flag & #_Flag_Image_Top) = #_Flag_Image_Top) Or 
           ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom)
          Flag &~ #_Flag_Image_HCenter
        EndIf
        If ((Flag & #_Flag_Image_Left) = #_Flag_Image_Left) Or
           ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right)
          Flag &~ #_Flag_Image_VCenter
        EndIf
        
      EndIf
      
      Txt_Y = \bSize + 1
      Txt_X = \bSize
      
      If Text$
        TextWidth = TextWidth(Text$)
        TextHeight = TextHeight(Text$)
        
        If ((Flag & #_Flag_Text_HCenter) = #_Flag_Text_HCenter)
          Txt_Y = ((iHeight-TextHeight - vb) / 2)
        ElseIf ((Flag & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)
          Txt_Y = ((iHeight-TextHeight) - vb)
        EndIf
        
        If ((Flag & #_Flag_Text_VCenter) = #_Flag_Text_VCenter)
          Txt_X = ((iWidth-TextWidth - hb) / 2)
        ElseIf ((Flag & #_Flag_Text_Right) = #_Flag_Text_Right)
          Txt_X = ((iWidth-TextWidth) - hb)
        EndIf
      EndIf
      
      If TextHeight = 0
        TextHeight = TextHeight(*CreateElement\This()\Text\String$)
      EndIf
      
      If IsImage(Image)
        ImageWidth = ImageWidth(Image)
        ImageHeight = ImageHeight(Image)
        
        If ((Flag & #_Flag_Image_HCenter) = #_Flag_Image_HCenter)
          Img_Y = ((iHeight-ImageHeight) / 2)
        ElseIf ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom)
          Img_Y = ((iHeight-ImageHeight) - vb)
        EndIf
        
        If ((Flag & #_Flag_Image_VCenter) = #_Flag_Image_VCenter)
          Img_X = ((iWidth-ImageWidth) / 2)
        ElseIf ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right)
          Img_X = ((iWidth-ImageWidth) - hb)
        EndIf
      EndIf
      
      Txt_X + iX 
      Txt_Y + iY
      
      If Flag & #_Flag_Image_Center
        If ((Flag & #_Flag_Image_Left) = #_Flag_Image_Left) Or 
           ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right)
          Txt_X + Img_X
        EndIf
        If ((Flag & #_Flag_Image_Top) = #_Flag_Image_Top) Or 
           ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom)
          Txt_Y + Img_Y 
        EndIf
      EndIf 
      
      Img_X + iX
      Img_Y + iY
      
      ; В середине
      If ((Flag & #_Flag_Image_Right) = #_Flag_Image_Right) And 
         ((Flag & #_Flag_Text_Left) = #_Flag_Text_Left)
        Img_X = iX+((iWidth-ImageWidth+TextWidth) / 2) : If TextWidth : Img_X + ihb : EndIf 
        Txt_X = iX+((iWidth-TextWidth-ImageWidth) / 2) : If ImageWidth : Txt_X - ihb : EndIf
      EndIf
      If ((Flag & #_Flag_Image_Left) = #_Flag_Image_Left) And 
         ((Flag & #_Flag_Text_Right) = #_Flag_Text_Right)
        Img_X = iX+((iWidth-ImageWidth-TextWidth) / 2) : If TextWidth : Img_X - ihb : EndIf
        Txt_X = iX+((iWidth-TextWidth+ImageWidth) / 2) : If ImageWidth : Txt_X + ihb : EndIf
      EndIf
      If ((Flag & #_Flag_Image_Bottom) = #_Flag_Image_Bottom) And 
         ((Flag & #_Flag_Text_Top) = #_Flag_Text_Top)
        Img_Y = iY+((iHeight-ImageHeight+TextHeight) / 2) : If TextHeight : Img_Y + ivb : EndIf 
        Txt_Y = iY+((iHeight-TextHeight-ImageHeight) / 2) : If ImageHeight : Txt_Y - ivb : EndIf
      EndIf
      If ((Flag & #_Flag_Image_Top) = #_Flag_Image_Top) And 
         ((Flag & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)
        Img_Y = iY+((iHeight-ImageHeight-TextHeight) / 2) : If TextHeight : Img_Y - ivb : EndIf 
        Txt_Y = iY+((iHeight-TextHeight+ImageHeight) / 2) : If ImageHeight : Txt_Y + ivb : EndIf
      EndIf
      
      If ((Flag & #_Flag_Image_Left) = #_Flag_Image_Left) And 
         ((Flag & #_Flag_Text_Left) = #_Flag_Text_Left)
        Img_X = iX : If TextWidth : Img_X + ihb : EndIf
        Txt_X = iX+(ImageWidth)+ihb : If ImageWidth : Txt_X + ihb : EndIf
      EndIf
      
    EndIf
    
    If Text$
      \TextPos = Txt_X
      Protected Area = iWidth - (4+2)
      Protected cptWidth = TextWidth(Left(Text$, \CaretPos)) - 2
      Protected LeftText$ = Left(Text$, \CaretPosMoved)
      Protected RightText$ = Mid(Text$, \CaretPosMoved +1+ Len(\Text\Selected$))
      
      ; Перемещаем корректор
      If ((\Flag & #_Flag_Editable) = #_Flag_Editable) 
        If \CaretPos = 0 : \Text\PosX =- 2 : Else
          If ((Flag & #_Flag_Text_Right) = #_Flag_Text_Right) 
          ElseIf ((Flag & #_Flag_Text_Center) = #_Flag_Text_Center) 
            ;If (cptWidth>Area) And ((cptWidth-Area)>\Text\PosX) : \Text\PosX = (cptWidth-Area) : EndIf
          Else
            If (cptWidth>Area) And ((cptWidth-Area)>\Text\PosX) : \Text\PosX = (cptWidth-Area) : EndIf
          EndIf
          If (\Text\PosX>cptWidth) : \Text\PosX = cptWidth : EndIf
        EndIf
      EndIf
      ;       
      ;FontColor = ContrastColor(HilightColor)
      ;       If \CaretPosFixed <> \CaretPos
      ;         DrawingMode(#PB_2DDrawing_Outlined) ; 3399FF ; $FFB870
      ;         Box(Txt_X+(TextWidth(Left(Text$, \CaretPosMoved))-\Text\PosX), Txt_Y, TextWidth(\Text\Selected$), TextHeight, $FFB870)
      ;         
      ;         DrawingMode(#PB_2DDrawing_Default) ; 3399FF ; $FFB870
      ;         Box(Txt_X+(TextWidth(Left(Text$, \CaretPosMoved))-\Text\PosX)+1, Txt_Y+1, TextWidth(\Text\Selected$)-2, TextHeight-2, $FF9933);) $004589; $114499);)
      ;       EndIf
      
      ; - Здесь происходит разделение текста
      If ((Flag & #_Flag_MultiLine) = #_Flag_MultiLine)
        DrawingMode(#PB_2DDrawing_Transparent)
        ;Debug \bSize
        DrawMultiText(Txt_X - \Text\PosX+\bSize, Txt_Y, Text$, FontColor, BackColor, Flag, iWidth, iHeight)
      Else
        ;If \Text\Left$ = "" : \Text\Left$ = Text$ : EndIf
        DrawingMode(#PB_2DDrawing_Transparent)
        ;         DrawText(Txt_X - \Text\PosX, Txt_Y, Text$, FontColor, BackColor)
        DrawText(Txt_X - \Text\PosX, Txt_Y, LeftText$, FontColor, BackColor)
        
        ;
        If \Text\Selected$
          Protected HilightColor
          DrawingMode(#PB_2DDrawing_Default)
          CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            HilightColor = GetSysColor_(#COLOR_HIGHLIGHT)
          CompilerElse
            HilightColor = $D77800
          CompilerEndIf
          DrawText(Txt_X + (TextWidth(Left(Text$, \CaretPosMoved))-\Text\PosX) , Txt_Y, \Text\Selected$, ContrastColor(HilightColor), HilightColor)
        EndIf
        
        If RightText$
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawText(Txt_X + (TextWidth(Left(Text$, \CaretPosMoved))-\Text\PosX) + TextWidth(\Text\Selected$), Txt_Y, RightText$, FontColor, BackColor)
        EndIf
        ;         
      EndIf
      
    EndIf
    
    If ((\Flag & #_Flag_Editable) = #_Flag_Editable) 
      If \CaretPos > =  0 And \Text\Selected$ = "" ; And Property_GadgetTimer( 300 )
        DrawingMode(#PB_2DDrawing_XOr)                 ; Перерисовка коректора
        If \Text\PosX = (cptWidth-Area)
          Line((Txt_X-\Text\PosX)+(TextWidth(Left(Text$, \CaretPos)))-1, Txt_Y, 1, TextHeight, $FFFFFF)
        Else
          Line((Txt_X-\Text\PosX)+(TextWidth(Left(Text$, \CaretPos))), Txt_Y, 1, TextHeight, $FFFFFF)
        EndIf
      EndIf
      
      
      ; ;       DrawingMode(#PB_2DDrawing_Transparent)
      ; ;       DrawText(Txt_X - \Text\PosX, Txt_Y, Text$, FontColor)
      ; ;       ;DrawingMode(#PB_2DDrawing_AlphaBlend|#PB_2DDrawing_XOr)
      ; ;       Protected LayoutX,LayoutWidth,Cursor = \CaretPosMoved, Selection = \CursorLength
      ; ;       
      ; ;       If Selection < 0
      ; ;         LayoutX = TextWidth(Left(Text$, Cursor+Selection))-1
      ; ;         LayoutWidth = TextWidth(Left(Text$, Cursor)) - LayoutX
      ; ;       Else
      ; ;         LayoutX = TextWidth(Left(Text$, Cursor))-1
      ; ;         LayoutWidth = TextWidth(Left(Text$, Cursor+Selection)) - LayoutX
      ; ;       EndIf
      ; ;       
      ; ;       Box((Txt_X+LayoutX)+2, Txt_Y, LayoutWidth, TextHeight("|"), $056FF5);$056FF3);
      ; ;       
    EndIf
    
    
    If IsImage(Image) 
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      If ((Flag & #_Flag_Stretch) = #_Flag_Stretch) Or 
         ((Flag & #_Flag_Proportionally) = #_Flag_Proportionally)
        Protected CopyImage = CopyImage(Image, #PB_Any)
        ResizeImage(CopyImage, Img_Width,Img_Height, #PB_Image_Raw)
        If ImageFormat(CopyImage) = #PB_ImagePlugin_ICON
          DrawImage(ImageID(CopyImage),Img_X,Img_Y)
        Else
          DrawAlphaImage(ImageID(CopyImage),Img_X,Img_Y, Alpha)
        EndIf
        If IsImage(CopyImage) : FreeImage(CopyImage) : EndIf
      Else
        DrawingMode(#PB_2DDrawing_AllChannels)
        If ImageFormat(Image) = #PB_ImagePlugin_ICON
          DrawImage(ImageID(Image),Img_X,Img_Y)
        Else
          DrawAlphaImage(ImageID(Image),Img_X,Img_Y, Alpha)
        EndIf
      EndIf
    EndIf
    
    ; Рисуем рисунок фона
    If IsImage(\Img\ImgBg)
      DrawingMode(#PB_2DDrawing_AlphaBlend)
      If \Type = #_Type_Window
        DrawAlphaImage(ImageID(\Img\ImgBg),iX-1,iY-1)
      Else
        DrawAlphaImage(ImageID(\Img\ImgBg),iX-2,iY-2)
      EndIf
    EndIf
    
    ClipOutput(*CreateElement\This()\X,*CreateElement\This()\Y,*CreateElement\This()\Width,*CreateElement\This()\Height)
  EndWith
  
EndProcedure

Procedure DrawElement(List This.S_CREATE_ELEMENT(), X = 0,Y = 0);Type, X,Y,Width,Height,Text$ = "", Flag.q = 0, Param1 =- 1,Param2 =- 1,Param3 =- 1)
                                                                ;Type, X,Y,Width,Height,Text$ = "", Flag.q = 0, Param1 =- 1,Param2 =- 1,Param3 =- 1)
  Protected DrawingMode,Width,Height, Text$, Flag.q             ; , X,Y
  Protected iX,iY,iWidth,iHeight, BackColor =- 1, FrameColor =- 1, CiWidth
  
  With This()
    iWidth = (*CreateElement\This()\Splitter\Pos+*CreateElement\This()\Splitter\Size)
    DrawContent(This(),X,Y,-(iWidth+1))
    
    ;CiWidth = (\FrameCoordinate\Width-\bSize*2)-iWidth-1
    ;DrawContent1(\DrawingMode,\Img\Image, (X+\FrameCoordinate\X),(Y+\FrameCoordinate\Y),CiWidth,\FrameCoordinate\Height, (X+\FrameCoordinate\X),(Y+\FrameCoordinate\Y),CiWidth,\FrameCoordinate\Height,\Text\String$,\Flag);,\BackColor,\FrameColor,\FontColor)
  EndWith
  
EndProcedure

Procedure _DrawingItems(List This.S_CREATE_ELEMENT(), ItemElement, X,Y)
  Protected FontColor, Width, Height, Result.b
  
  Protected ScrollWidth = 6
  
  With This()
    If \Item\IsVertical = 0 And \InnerCoordinate\Width
      Result = #True
    ElseIf \Item\IsVertical = 1 And \InnerCoordinate\Height
      Result = #True
    EndIf
    
    If Result 
      
      PushListPosition(\Items())
      ForEach \Items()
        If \Item\IsVertical = 1
          If (\Scroll\Max-1) > \InnerCoordinate\Height
            \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - \Items()\FrameCoordinate\X*2 - \Scroll\Size
          Else
            \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - \Items()\FrameCoordinate\X*2
          EndIf
        ElseIf \Item\IsVertical = 0
          If (\Scroll\Max-1) > \FrameCoordinate\Width
            \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - \Items()\FrameCoordinate\Y*2 - \Scroll\Size
          Else
            ;           If *CreateElement\This()\Type = #_Type_Toolbar
            ;             \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - \Items()\FrameCoordinate\Y*2 - 1
            ;           Else
            \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - \Items()\FrameCoordinate\Y*2 
            ;           EndIf
            
          EndIf
        EndIf
        
        If \Type <> #_Type_Editor
          If *CreateElement\This() <> This()
            ClipCoordinate(This(), *CreateElement\This()\FrameCoordinate\X,*CreateElement\This()\FrameCoordinate\Y,*CreateElement\This()\FrameCoordinate\Width,*CreateElement\This()\FrameCoordinate\Height);+MenuHeight)
          EndIf
          
          
          If \Items()\Item\IsBar
            DrawingMode(#PB_2DDrawing_Default)
            If \Item\IsVertical = 1
              Line((X+\Items()\FrameCoordinate\X)+((50/2)/2),(Y+\Items()\FrameCoordinate\Y)+(\Items()\FrameCoordinate\Height/2),\Items()\FrameCoordinate\Width-(50/2),1, \Items()\FrameColor)
            ElseIf \Item\IsVertical = 0
              Line((X+\Items()\FrameCoordinate\X)+(\Items()\FrameCoordinate\Width/2),(Y+\Items()\FrameCoordinate\Y)+1,1,\Items()\FrameCoordinate\Height-2, \Items()\FrameColor)
            EndIf
          Else
            ; Для меню итемов 
            If \Items()\Disable = 0
              If \Items()\Element = \Item\Entered\Element
                DrawingMode(#PB_2DDrawing_Default)
                Box((X+\Items()\FrameCoordinate\X)+1, (Y+\Items()\FrameCoordinate\Y)+1, \Items()\FrameCoordinate\Width-2, \Items()\FrameCoordinate\Height-2, \Items()\EnteredBackColor)
                DrawingMode(#PB_2DDrawing_Outlined)
                Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\SelectedBackColor)
                
              EndIf
              
              If \Items()\Element = \Item\Selected\Element 
                If \Element = *CreateElement\ActiveElement Or *CreateElement\This()\Type = #_Type_Menu
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\SelectedBackColor)
                Else
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\FrameColor)
                EndIf
              EndIf
            EndIf
            
          EndIf
        EndIf
        
        DrawContent(\Items(), X, Y )
        
      Next
      PopListPosition(\Items())
      
      ;ClipOutput(\X,\Y,\Width,\Height)
    EndIf
  EndWith
  
EndProcedure

Procedure DrawingItems(List This.S_CREATE_ELEMENT(), ItemElement, X,Y)
  Protected FontColor, Width, Height, Result.b
  
  Protected ScrollWidth = 6
  
  With This()
    If \Item\IsVertical = 0 And \InnerCoordinate\Width
      Result = #True
    ElseIf \Item\IsVertical = 1 And \InnerCoordinate\Height
      Result = #True
    EndIf
    
    If Result 
      Protected X1 = 1, Y1 = 1
      
      PushListPosition(\Items())
      ForEach \Items()
        If \Item\IsVertical = 1
          \Items()\FrameCoordinate\X = 1
          \Items()\FrameCoordinate\Y = Y1
        Else
          \Items()\FrameCoordinate\Y = 1
          \Items()\FrameCoordinate\X = X1
        EndIf
        
        If \Item\IsVertical = 1
          If (\Scroll\Max-1) > \InnerCoordinate\Height
            \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - \Items()\FrameCoordinate\X*2 - \Scroll\Size
          Else
            \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - \Items()\FrameCoordinate\X*2
          EndIf
        ElseIf \Item\IsVertical = 0
          If (\Scroll\Max-1) > \FrameCoordinate\Width
            \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - \Items()\FrameCoordinate\Y*2 - \Scroll\Size
          Else
            \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - \Items()\FrameCoordinate\Y*2 
          EndIf
        EndIf
        
        If \Type <> #_Type_Editor
          If *CreateElement\This() <> This()
            ClipCoordinate(This(), *CreateElement\This()\FrameCoordinate\X,*CreateElement\This()\FrameCoordinate\Y,*CreateElement\This()\FrameCoordinate\Width,*CreateElement\This()\FrameCoordinate\Height);+MenuHeight)
          EndIf
          
          If \Items()\Item\IsBar
            DrawingMode(#PB_2DDrawing_Default)
            If \Item\IsVertical = 1
              Line((X+\Items()\FrameCoordinate\X)+((50/2)/2),(Y+\Items()\FrameCoordinate\Y)+(\Items()\FrameCoordinate\Height/2),\Items()\FrameCoordinate\Width-(50/2),1, \Items()\FrameColor)
            ElseIf \Item\IsVertical = 0
              Line((X+\Items()\FrameCoordinate\X)+(\Items()\FrameCoordinate\Width/2),(Y+\Items()\FrameCoordinate\Y)+1,1,\Items()\FrameCoordinate\Height-2, \Items()\FrameColor)
            EndIf
          Else
            ; Для меню итемов 
            If \Items()\Disable = 0
              If \Items()\Element = \Item\Entered\Element
                DrawingMode(#PB_2DDrawing_Default)
                Box((X+\Items()\FrameCoordinate\X)+1, (Y+\Items()\FrameCoordinate\Y)+1, \Items()\FrameCoordinate\Width-2, \Items()\FrameCoordinate\Height-2, \Items()\EnteredBackColor)
                DrawingMode(#PB_2DDrawing_Outlined)
                Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\SelectedBackColor)
              EndIf
              
              If \Items()\Element = \Item\Selected\Element 
                If \Element = *CreateElement\ActiveElement Or *CreateElement\This()\Type = #_Type_Menu
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\SelectedBackColor)
                Else
                  DrawingMode(#PB_2DDrawing_Default)
                  Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\FrameColor)
                EndIf
                
              EndIf
              
            EndIf
            
            
          EndIf
        EndIf
        
        DrawContent(\Items(), X, Y )
        
        If \Item\IsVertical = 1
          Y1+\Items()\FrameCoordinate\Height
        Else
          X1+\Items()\FrameCoordinate\Width
        EndIf
      Next
      PopListPosition(\Items())
      
      ;ClipOutput(\X,\Y,\Width,\Height)
    EndIf
  EndWith
  
EndProcedure

Procedure DrawingElementItems()
  Protected ScrollWidth = 6
  Protected Result, DrawingMode, Text$
  Protected X,Y,Width,Height
  Protected iX,iY,iWidth,iHeight
  Protected CiX,CiY,CiWidth,CiHeight
  
  With *CreateElement
    If ListSize(\This()\Items())
      X = \This()\FrameCoordinate\X
      Y = \This()\FrameCoordinate\Y
      Width = \This()\FrameCoordinate\Width 
      Height = \This()\FrameCoordinate\Height
      
      iX = \This()\InnerCoordinate\X
      iY = \This()\InnerCoordinate\Y
      iWidth = \This()\InnerCoordinate\Width
      iHeight = \This()\InnerCoordinate\Height
      
      Select \This()\Type 
        Case #_Type_Canvas
          If ListSize(\This()\Items())
            X = \This()\InnerCoordinate\X
            Y = (\This()\InnerCoordinate\Y-\This()\CaptionHeight)
            
            
            PushListPosition(\This()\Items())
            ForEach \This()\Items() 
              ;               DrawContent1(#PB_2DDrawing_Default, 
              ;                            \This()\Items()\Img\Image,
              ;                            (X+\This()\Items()\FrameCoordinate\X), 
              ;                            (Y+\This()\Items()\FrameCoordinate\Y), 
              ;                            \This()\Items()\FrameCoordinate\Width,
              ;                            \This()\Items()\FrameCoordinate\Height, 
              ;                            (X+\This()\Items()\FrameCoordinate\X), 
              ;                            (Y+\This()\Items()\FrameCoordinate\Y), 
              ;                            \This()\Items()\FrameCoordinate\Width,
              ;                            \This()\Items()\FrameCoordinate\Height, 
              ;                            \This()\Items()\Text\String$,
              ;                            \This()\Items()\Flag)
            Next
            PopListPosition(\This()\Items())
          EndIf
          
        Case #_Type_AnchorButton
          If ListSize(\This()\Items())
            X = \This()\InnerCoordinate\X
            Y = (\This()\InnerCoordinate\Y-\This()\CaptionHeight)
            
            
            PushListPosition(\This()\Items())
            ForEach \This()\Items() 
              Protected Size = 16
              \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
              
              Select \This()\Items()\Element
                Case 0
                  \This()\Items()\State = #_State_Default
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Default
                  \This()\Items()\FrameCoordinate\X = Size
                  \This()\Items()\FrameCoordinate\Y = Size
                  \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width-Size*2
                  \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height-Size*2 
                  
                Case 1
                  \This()\Items()\FrameCoordinate\X = 0
                  \This()\Items()\FrameCoordinate\Y = Size
                  \This()\Items()\FrameCoordinate\Width = Size-1
                  \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height-Size*2
                  
                Case 2
                  \This()\Items()\FrameCoordinate\X = Size
                  \This()\Items()\FrameCoordinate\Y = 0
                  \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width-Size*2
                  \This()\Items()\FrameCoordinate\Height = Size-1 
                  
                Case 3
                  \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width-Size+1
                  \This()\Items()\FrameCoordinate\Y = Size
                  \This()\Items()\FrameCoordinate\Width = Size-1
                  \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height-Size*2
                  
                Case 4
                  \This()\Items()\FrameCoordinate\X = Size
                  \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Height-Size+1
                  \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width-Size*2
                  \This()\Items()\FrameCoordinate\Height = Size-1
                  
                Case 5
                  \This()\Items()\FrameCoordinate\X = 0
                  \This()\Items()\FrameCoordinate\Y = 0
                  \This()\Items()\FrameCoordinate\Width = Size-1
                  \This()\Items()\FrameCoordinate\Height = Size-1
                  
                Case 6
                  \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width-Size+1
                  \This()\Items()\FrameCoordinate\Y = 0
                  \This()\Items()\FrameCoordinate\Width = Size-1
                  \This()\Items()\FrameCoordinate\Height = Size-1 
                  
                Case 7
                  \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width-Size+1
                  \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Height-Size+1
                  \This()\Items()\FrameCoordinate\Width = Size-1
                  \This()\Items()\FrameCoordinate\Height = Size-1
                  
                Case 8
                  \This()\Items()\FrameCoordinate\X = 0
                  \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Height-Size+1
                  \This()\Items()\FrameCoordinate\Width = Size-1
                  \This()\Items()\FrameCoordinate\Height = Size-1 
                  
                Case 9
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Default
                  If \This()\Items()\FrameCoordinate\Width =0 
                    \This()\Items()\FrameCoordinate\Width = Size+3
                    \This()\Items()\FrameCoordinate\Height = Size+3
                  EndIf
                  If  \This()\Items()\FrameCoordinate\X = 0 And \This()\Items()\FrameCoordinate\Y = 0 
                    \This()\Items()\FrameCoordinate\X = \This()\Items()\FrameCoordinate\Width-2
                    \This()\Items()\FrameCoordinate\Y = \This()\Items()\FrameCoordinate\Height-2
                  EndIf
                  
                Case 10
                  \This()\Items()\FrameCoordinate\X = (\This()\InnerCoordinate\Width - Size)/2
                  \This()\Items()\FrameCoordinate\Y = (\This()\InnerCoordinate\Height - Size)/2
                  \This()\Items()\FrameCoordinate\Width = Size-1
                  \This()\Items()\FrameCoordinate\Height = Size-1
                  
                  
              EndSelect
              
              ;               DrawingMode(#PB_2DDrawing_Default)
              ;               Box(X+\This()\Items()\FrameCoordinate\X, Y+\This()\Items()\FrameCoordinate\Y, \This()\Items()\FrameCoordinate\Width, \This()\Items()\FrameCoordinate\Height, 0)
              DrawContent(\This()\Items(),X,Y)
              
            Next
            PopListPosition(\This()\Items())
          EndIf
          
        Case #_Type_ListIcon : DrawListIconElementContent(\This(), \This()\InnerCoordinate\X,(\This()\InnerCoordinate\Y-\This()\CaptionHeight))
          
        Case #_Type_Spin       : DrawSpinElementItemsContent(\This()) 
        Case #_Type_Panel      : DrawPanelElementItemsContent(\This())
        Case #_Type_Window     : DrawOpenWindowElementItemsContent(\This())
        Case #_Type_Splitter   : DrawSplitterElementItemsContent(\This())
        Case #_Type_ComboBox   : DrawComboBoxElementItemsContent(\This())
        Case #_Type_TrackBar   : DrawTrackBarElementItemsContent(\This())
        Case #_Type_ScrollBar  : DrawScrollBarElementItemsContent(\This())
        Case #_Type_ScrollArea : DrawScrollAreaElementItemsContent(\This())
        Case #_Type_ListView   : DrawListViewElementItemsContent(\This(), -1, \This()\InnerCoordinate\X,(\This()\InnerCoordinate\Y-\This()\CaptionHeight))
        Case #_Type_PopupMenu  : DrawPopupMenuElementItemsContent(\This(), \This()\Item\Entered\Element, \This()\InnerCoordinate\X,(\This()\InnerCoordinate\Y-\This()\CaptionHeight))
        Case #_Type_Menu,
             #_Type_Toolbar, #_Type_Editor , #_Type_StatusBar
          
          If ListSize(\This()\Items())
            X = \This()\InnerCoordinate\X
            Y = (\This()\InnerCoordinate\Y-\This()\CaptionHeight)
            
            If \This()\Item\IsVertical And \This()\Type <> #_Type_PopupMenu
              \This()\Scroll\Max = (ListSize(\This()\Items())*(\This()\Items()\FrameCoordinate\Height+1))
              ;               
              ;               If \This()\Scroll\Max-1 > \This()\FrameCoordinate\Height
              \This()\Scroll\PageLength = \This()\InnerCoordinate\Height
              ;                 \This()\Scroll\Area = \This()\Scroll\PageLength-\This()\Scroll\ButtonSize*2
              ;                 \This()\Scroll\ThumbSize = Round((\This()\Scroll\Area * \This()\Scroll\PageLength) / (\This()\Scroll\Max - \This()\Scroll\Min), #PB_Round_Down)
              ;                 
              ;                 If \This()\Scroll\ButtonSize > (\This()\Scroll\Pos-Y) 
              ;                   \This()\Scroll\Pos = (Y+\This()\Scroll\ButtonSize)
              ;                 ElseIf (\This()\Scroll\Pos-Y) > ((\This()\Scroll\Area-\This()\Scroll\ThumbSize)+\This()\Scroll\ButtonSize)
              ;                   \This()\Scroll\Pos = Y+((\This()\Scroll\Area-\This()\Scroll\ThumbSize)+\This()\Scroll\ButtonSize) 
              ;                 Else
              ;                   \This()\Scroll\DeltaPos = ((\MouseY)*\This()\Items()\FrameCoordinate\Height / \This()\Items()\FrameCoordinate\Height)
              ;                 EndIf
              ;                 
              ;                 \This()\Scroll\State = Round((\This()\Scroll\Pos-Y-\This()\Scroll\ButtonSize) / (\This()\Scroll\Area / (\This()\Scroll\Max - \This()\Scroll\Min)), #PB_Round_Nearest)
              ;                 Y-\This()\Scroll\State
              ;               EndIf
              Y-\This()\Scroll\Pos
            EndIf
            
            DrawingItems(\This(), -1, X,Y)
          EndIf
          
          
          
        Case #_Type_Properties
          If ListSize(\This()\Items())
            \This()\Scroll\PageLength = \This()\InnerCoordinate\Height
            \This()\Scroll\Area = \This()\Scroll\PageLength-\This()\Scroll\ButtonSize*2
            \This()\Scroll\ThumbSize = Round((\This()\Scroll\Area * \This()\Scroll\PageLength) / (\This()\Scroll\Max - \This()\Scroll\Min), #PB_Round_Down)
            
            X = \This()\InnerCoordinate\X+1
            Y = \This()\InnerCoordinate\Y+1
            Protected FontColor
            
            PushListPosition(\This()\Items())
            ForEach \This()\Items()
              ;               \This()\Splitter\Pos = 70
              ;               \This()\Splitter\Size = 3
              
              \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width-2
              Width = \This()\Items()\FrameCoordinate\Width
              Height = \This()\Items()\FrameCoordinate\Height
              
              ;ClipOutput(CiX,CiY,CiWidth,CiHeight)
              
              If ListIndex(\This()\Items()) = \This()\Item\Entered\Element
                DrawingMode(#PB_2DDrawing_Default)
                Box(X,(Y+\This()\Items()\FrameCoordinate\Y),\This()\Splitter\Pos-1,Height, \This()\Items()\EnteredBackColor)
                DrawingMode(#PB_2DDrawing_Outlined)
                Box(X+(\This()\Splitter\Pos+\This()\Splitter\Size)+1,(Y+\This()\Items()\FrameCoordinate\Y),(Width-(\This()\Splitter\Pos+\This()\Splitter\Size+2)),Height, \This()\Items()\EnteredBackColor)
                FontColor = \This()\Items()\EnteredFontColor
              EndIf
              
              If \This()\Items()\Element = \This()\Item\Selected\Element
                DrawingMode(#PB_2DDrawing_Default)
                Box(X,(Y+\This()\Items()\FrameCoordinate\Y),\This()\Splitter\Pos-1,Height, \This()\Items()\SelectedBackColor)
                DrawingMode(#PB_2DDrawing_Outlined)
                Box(X+(\This()\Splitter\Pos+\This()\Splitter\Size)+1,(Y+\This()\Items()\FrameCoordinate\Y),(Width-(\This()\Splitter\Pos+\This()\Splitter\Size+2)),Height, \This()\Items()\SelectedBackColor)
                FontColor = \This()\Items()\SelectedFontColor
              Else
                FontColor = \This()\Items()\FontColor
              EndIf
              
              ; Seperator
              DrawingMode(#PB_2DDrawing_Outlined)
              Box((X+\This()\Splitter\Pos),\This()\Y,\This()\Splitter\Size,\This()\Height, \This()\Items()\FrameColor)
              
              ; ; ; ;               DrawContent1(#PB_2DDrawing_AlphaBlend, \This()\Items()\Img\Image,
              ; ; ; ;                            \This()\X,\This()\Y,\This()\Width,\This()\Height,
              ; ; ; ;                            X,(Y+\This()\Items()\FrameCoordinate\Y), \This()\Splitter\Pos-1,Height,
              ; ; ; ;                            \This()\Items()\Title, #_Flag_AlignImage_Right, FontColor)
              
              ;DrawContent(\This()\Items())
              
              
              DrawingMode = \This()\Items()\DrawingMode
              iX = \This()\Items()\FrameCoordinate\X
              iY = \This()\Items()\FrameCoordinate\Y
              iWidth = \This()\Items()\FrameCoordinate\Width
              iHeight = \This()\Items()\FrameCoordinate\Height
              Text$ = \This()\Items()\Text\String$ 
              
              Protected sb = 17
              
              Select \This()\Items()\Type
                Case #_Type_Spin
                  \This()\Items()\FrameCoordinate\Width = \This()\Splitter\Pos+sb
                  
                  If (iWidth-(\This()\Splitter\Pos+\This()\Splitter\Size)) < sb-1
                    \This()\Items()\FrameCoordinate\Width = iWidth
                    sb = (iWidth-(\This()\Splitter\Pos+\This()\Splitter\Size))
                  EndIf
                  
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
                  \This()\Items()\Text\String$ = ""
                  
                  \This()\Items()\Img\Image = Up
                  \This()\Items()\FrameCoordinate\Y = iY+1
                  \This()\Items()\FrameCoordinate\Height = iHeight/2-1
                  DrawElement(\This()\Items(), (X+\This()\InnerCoordinate\Width)-sb,Y)
                  
                  \This()\Items()\Img\Image = Down
                  \This()\Items()\FrameCoordinate\Y = iY+iHeight/2+1
                  \This()\Items()\FrameCoordinate\Height = iHeight/2-1
                  DrawElement(\This()\Items(), (X+\This()\InnerCoordinate\Width)-sb,Y)
                  
                  
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Outlined
                  \This()\Items()\Img\Image =- 1
                  \This()\Items()\Text\String$ = Text$
                  \This()\Items()\FrameCoordinate\Y = iY
                  \This()\Items()\FrameCoordinate\Width = iWidth-15
                  \This()\Items()\FrameCoordinate\Height = iHeight
                  DrawElement(\This()\Items(), X+(\This()\Splitter\Pos+\This()\Splitter\Size)+1,Y)
                  
                Case #_Type_Button
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
                  \This()\Items()\Text\String$ = "..."
                  \This()\Items()\FrameCoordinate\Y = iY+1
                  \This()\Items()\FrameCoordinate\Width = \This()\Splitter\Pos+sb
                  \This()\Items()\FrameCoordinate\Height = iHeight-2
                  DrawElement(\This()\Items(), (X+\This()\InnerCoordinate\Width)-sb,Y)
                  
                  
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Outlined
                  \This()\Items()\Text\String$ = Text$
                  \This()\Items()\FrameCoordinate\Y = iY
                  \This()\Items()\FrameCoordinate\Width = iWidth-15
                  \This()\Items()\FrameCoordinate\Height = iHeight
                  DrawElement(\This()\Items(), X+(\This()\Splitter\Pos+\This()\Splitter\Size)+1,Y)
                  
                  
                  
                Default
                  DrawElement(\This()\Items(), X+(\This()\Splitter\Pos+\This()\Splitter\Size)+1,Y)
              EndSelect
              
              ;\This()\Items()\Text\String$ = Text$
              \This()\Items()\DrawingMode = DrawingMode
              \This()\Items()\FrameCoordinate\Width = iWidth
              \This()\Items()\FrameCoordinate\Height = iHeight
              ;\This()\Items()\FrameCoordinate\Y = iY
            Next
            PopListPosition(\This()\Items())
            
          EndIf
          
          
      EndSelect
      
      ;       ; 
      ;       If \This()\Item\IsVertical
      ;         If \This()\Scroll\Max > \This()\Height
      ;           DrawingMode(#PB_2DDrawing_Default)
      ;           Box((\This()\InnerCoordinate\X+\This()\InnerCoordinate\Width) - \This()\Scroll\Size,\This()\Scroll\Pos,\This()\Scroll\Size-1,\This()\Scroll\ThumbSize, \This()\FrameColor)
      ;         EndIf
      ;       Else
      ;         If \This()\Scroll\Max > \This()\Width
      ;           DrawingMode(#PB_2DDrawing_Default)
      ;           Box(\This()\Scroll\Pos, (\This()\InnerCoordinate\Y+\This()\InnerCoordinate\Height) - \This()\Scroll\Size,\This()\Scroll\Size-1,\This()\Scroll\ThumbSize, \This()\FrameColor)
      ;         EndIf
      ;       EndIf
      ;       
      
      ; 
      If \This()\Item\IsVertical
        If \This()\Scroll\Max > \This()\Height
          DrawingMode(#PB_2DDrawing_Default)
          Box((\This()\InnerCoordinate\X+\This()\InnerCoordinate\Width) - \This()\Scroll\Size,\This()\Scroll\ThumbPos,\This()\Scroll\Size-1,\This()\Scroll\ThumbSize, \This()\FrameColor)
        EndIf
      EndIf
      ;       
      ;ClipOutput(\This()\X,\This()\Y,\This()\Width,\This()\Height)
      
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


Procedure DrawingElement(List This.S_CREATE_ELEMENT(), X = 0,Y = 0)
  Protected FontColor = 0, TopColor =- 1
  Protected DrawingMode,Image, Width,Height, Text$, Flag.q ; , X,Y
  Protected iX,iY,iWidth,iHeight, BackColor =- 1, FrameColor =- 1
  
  With This() 
    If \FontID : DrawingFont(\FontID) : EndIf
    If Bool(\Width  = < 0 Or 0 > =  \Height) : ProcedureReturn 0 : EndIf
    ;       Protected Time = ElapsedMilliseconds()
    
    Select \Type 
      Case #_Type_Desktop ; Рисуем фон канвасу
        If \BackColor
          DrawingMode(#PB_2DDrawing_Default) 
          Box(0,0,OutputWidth(),OutputHeight(), \BackColor) 
          ;         Debug \BackImage
          ;         DrawImage(ImageID(\BackImage), 0, 0)
        EndIf
        ProcedureReturn 0 ; Выход
      Default
        ;
        If \Hide = 0 
          ; TODO -----
          X = \FrameCoordinate\X+(\bSize-\BorderSize)
          Y = \FrameCoordinate\Y+(\bSize-\BorderSize)
          Width = \FrameCoordinate\Width-(\bSize-\BorderSize)*2-1
          Height = \FrameCoordinate\Height-(\bSize-\BorderSize)*2-1
          
          DrawingMode(#PB_2DDrawing_Outlined) ; OutBorder
          If (X<\X) : Line(X,Y,1,Height,$0000FF) : EndIf
          If (Y<\Y) : Line(X,Y, Width,1,$0000FF) : EndIf
          If ((X+Width)>(\X+\Width)) : Line(X+Width,Y,1,Height,$0000FF) : EndIf
          If ((Y+Height)>(\Y+\Height)) : Line(X,Y+Height,Width,1,$0000FF) : EndIf
          
          DrawContent(This())
          DrawingElementItems()
          
          If \Show = 0 
            \Show = 1 
          EndIf
          ;           If \Repaint = 1 
          ;             \Repaint = 0 
          ;             Debug "create "+\Element
          ;             PostEventElement(#_Event_Create, \Element, #PB_Default)
          ;           EndIf
          UnclipOutput()
        EndIf
        
    EndSelect
    
    ;       Time = (ElapsedMilliseconds() - Time)
    ;       If Time 
    ;          Debug Str(\Element)+" "+Str(Time)
    ;       EndIf
    
  EndWith
  
EndProcedure

Procedure _DrawingElement(List This.S_CREATE_ELEMENT(), X = 0,Y = 0)
  Protected FontColor = 0, TopColor =- 1
  Protected DrawingMode,Image, Width,Height, Text$, Flag.q ; , X,Y
  Protected iX,iY,iWidth,iHeight, BackColor =- 1, FrameColor =- 1
  
  With This() 
    If \FontID : DrawingFont(\FontID) : EndIf
    If Bool(\Width  = < 0 Or 0 > =  \Height) : ProcedureReturn 0 : EndIf
    ;       Protected Time = ElapsedMilliseconds()
    
    Select \Type 
      Case #_Type_Desktop ; Рисуем фон канвасу
        If \BackColor
          DrawingMode(#PB_2DDrawing_Default) 
          Box(0,0,OutputWidth(),OutputHeight(), \BackColor) 
          ;         Debug \BackImage
          ;         DrawImage(ImageID(\BackImage), 0, 0)
        EndIf
        ProcedureReturn 0 ; Выход
      Default
        ;
        If \Hide = 0 
          If *CreateElement\CheckedElement > 0
            *CreateElement\Redraw\X = ElementX(*CreateElement\CheckedElement, #_Element_ScreenCoordinate)
          EndIf
          
          If *CreateElement\Redraw\X =< \X
            ; TODO -----
            X = \FrameCoordinate\X+(\bSize-\BorderSize)
            Y = \FrameCoordinate\Y+(\bSize-\BorderSize)
            Width = \FrameCoordinate\Width-(\bSize-\BorderSize)*2-1
            Height = \FrameCoordinate\Height-(\bSize-\BorderSize)*2-1
            
            DrawingMode(#PB_2DDrawing_Outlined) ; OutBorder
            If (X<\X) : Line(X,Y,1,Height,$0000FF) : EndIf
            If (Y<\Y) : Line(X,Y, Width,1,$0000FF) : EndIf
            If ((X+Width)>(\X+\Width)) : Line(X+Width,Y,1,Height,$0000FF) : EndIf
            If ((Y+Height)>(\Y+\Height)) : Line(X,Y+Height,Width,1,$0000FF) : EndIf
            
            DrawContent(This())
            DrawingElementItems()
            
            If \Show = 0 
              \Show = 1 
            EndIf
            ;           If \Repaint = 1 
            ;             \Repaint = 0 
            ;             Debug "create "+\Element
            ;             PostEventElement(#_Event_Create, \Element, #PB_Default)
            ;           EndIf
            UnclipOutput()
          EndIf
        EndIf
        
    EndSelect
    
    ;       Time = (ElapsedMilliseconds() - Time)
    ;       If Time 
    ;          Debug Str(\Element)+" "+Str(Time)
    ;       EndIf
    
  EndWith
  
EndProcedure

;- 
Procedure GetElementCaretPos(Element)
  Protected Result
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    
    Result = \This()\CaretPos ; Получить позицию коpректора
    
    PopListPosition(\This())
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure CorrectPos(MouseX, TextPosX, Text$, CorrectPos = 0)
  Protected Index.i
  Protected Result.i
  Protected Distance.i, MinDistance.i = $FFFF
  
  For Index = Len(Text$) To 0 Step -1
    Distance = Abs(TextPosX+TextWidth(Left(Text$, Index))-MouseX)
    If Distance < MinDistance
      Result = Index - CorrectPos
      MinDistance = Distance
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure GetCaretPos(List This.S_CREATE_ELEMENT())
  Protected X,Y,Result =- 1, i, CursorX, Distance.f, MinDistance.f = Infinity()
  
  ;   With *CreateElement
  ;     If \This() = This()
  ;       X = This()\InnerCoordinate\X
  ;       Y = This()\InnerCoordinate\Y
  ;     Else
  ;       X = \This()\InnerCoordinate\X+This()\InnerCoordinate\X
  ;       Y = \This()\InnerCoordinate\Y+This()\InnerCoordinate\Y
  ;     EndIf
  ;   EndWith  
  
  With This()
    For i = 0 To Len(\Text\String$) 
      CursorX = (\TextPos + TextWidth(Left(\Text\String$, i))) - \Text\PosX + 1 ;+ (TextWidth(Mid(\Text\String$, i, 1))/2+1)
      Distance = (*CreateElement\MouseX-CursorX)*(*CreateElement\MouseX-CursorX)
      
      If Distance < MinDistance 
        MinDistance = Distance
        Result = i ; Получить позицию коpректора
      EndIf
    Next
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure UpdateCaret(List This.S_CREATE_ELEMENT())
  
  With This()
    ; Если выделяем с лева на право
    If \CaretPosFixed < \CaretPos
      \CaretPosMoved = \CaretPosFixed
      \CursorLength = \CaretPos-\CaretPosFixed
    Else ; Если выделяем с право на лево
      \CaretPosMoved = \CaretPos
      \CursorLength = (\CaretPosFixed-\CaretPos)
    EndIf
  EndWith
  
EndProcedure

Procedure StringEditableCallBack(List This.S_CREATE_ELEMENT(), Event, EventElement)
  Static Text$, DoubleClickCaretPos =- 1
  Protected PostEvent, Quit.b, Result, StartDrawing, Update_Text_Selected
  
  If *CreateElement
    With This()
      ; If IsElement(ElementID(EventElement))
      ;  SelectElement(This(), EventElement)
      
      If \Disable = 0 And ((\Flag & #_Flag_Editable) = #_Flag_Editable)
        If \Text\ChangeString$ = ""
          \Text\ChangeString$ = \Text\String$
        EndIf
        
        Select \Type
          Case #_Type_String, #_Type_Editor, #_Type_Spin, #_Type_ComboBox
            *CreateElement\LinePosition = \FrameCoordinate\X
            
            If Bool(Event = #_Event_LeftDoubleClick Or Event = #_Event_LeftButtonDown Or ElementEventButton() Or ElementEventKey() = #PB_Shortcut_Back)
              StartDrawing = StartDrawing(CanvasOutput(*CreateElement\Canvas))
              If \FontID : DrawingFont(\FontID) : EndIf
            EndIf
            
            Select Event
              Case #_Event_LostFocus : \CursorLength =- 1 : \CaretPos =- 1 : \CaretPosFixed =- 1 : \Text\Selected$ = ""
              Case #_Event_Focus
                If Not ElementEventButton()
                  \CaretPos = 0 
                  \CaretPosFixed = Len(\Text\String$) 
                  Update_Text_Selected = #True
                EndIf
                
              Case #_Event_Input
                If ((\Flag & #_Flag_Numeric) = #_Flag_Numeric)
                  Select *CreateElement\Bind\Chr ; Чтобы вставлять только цыфри
                    Case '.','0' To '9' : Result = *CreateElement\Bind\Chr 
                  EndSelect
                  
                Else
                  Result = *CreateElement\Bind\Chr 
                EndIf
                
                If Result
                  If \Text\Selected$
                    If \CaretPos > \CaretPosFixed : \CaretPos = \CaretPosFixed : EndIf
                    \Text\String$ = RemoveString(\Text\String$, \Text\Selected$, #PB_String_CaseSensitive, \CaretPos, 1)
                    \Text\Selected$ = ""
                  EndIf
                  
                  \CaretPos + 1
                  ;\Text\String$ = Left(\Text\String$, \CaretPos-1) + Chr(Result) + Mid(\Text\String$, \CaretPos)
                  \Text\String$ = InsertString(\Text\String$, Chr(Result), \CaretPos)
                  
                  \CaretPosFixed = \CaretPos
                EndIf
                
                If ((\Flag & #_Flag_LowerCase) = #_Flag_LowerCase)
                  \Text\String$ = LCase(\Text\String$)
                ElseIf ((\Flag & #_Flag_UpperCase) = #_Flag_UpperCase)
                  \Text\String$ = UCase(\Text\String$)
                EndIf
                
              Case #_Event_KeyDown
                Select ElementEventKey()
                  Case #PB_Shortcut_Home : \CaretPos = 0
                  Case #PB_Shortcut_End : \CaretPos = Len(\Text\String$)
                    Case #PB_Shortcut_Left : \Text\Selected$ = "" : If (\CaretPos > 0) : \CaretPos - (1) : EndIf
                    Case #PB_Shortcut_Right : \Text\Selected$ = "" : If (\CaretPos < Len(\Text\String$)) : \CaretPos + (1) : EndIf
                  Case #PB_Shortcut_Back 
                    Protected Blink_Text$
                    
                    If \Text\Selected$
                      If \CaretPos > \CaretPosFixed : \CaretPos = \CaretPosFixed : EndIf
                      \Text\String$ = RemoveString(\Text\String$, \Text\Selected$, #PB_String_CaseSensitive, \CaretPos, 1)
                      Blink_Text$ = \Text\Selected$
                      \Text\Selected$ = ""
                    Else
                      If \CaretPos > 0
                        Blink_Text$ = Mid(\Text\String$, \CaretPos, 1)
                        \Text\String$ = Left(\Text\String$, \CaretPos - 1) + Right(\Text\String$, Len(\Text\String$)-\CaretPos)
                        \CaretPos - 1 
                      EndIf
                    EndIf
                    
                    If StartDrawing And Blink_Text$ And \Text\PosX > -2
                      \Text\PosX - TextWidth(Blink_Text$) : If \Text\PosX < -2 : \Text\PosX =- 2 : EndIf
                    EndIf
                    
                    \CaretPosFixed = \CaretPos
                    
                  Case #PB_Shortcut_C
                    If (ElementEventModifiersKey() & #PB_Canvas_Control)
                      SetClipboardText(\Text\Selected$)
                    EndIf
                    
                  Case #PB_Shortcut_V
                    If (ElementEventModifiersKey() & #PB_Canvas_Control)
                      If \Text\Selected$
                        If \CaretPos > \CaretPosFixed : \CaretPos = \CaretPosFixed : EndIf
                        \Text\String$ = RemoveString(\Text\String$, \Text\Selected$, #PB_String_CaseSensitive, \CaretPos, 1)
                        Blink_Text$ = \Text\Selected$
                        \Text\Selected$ = ""
                      EndIf
                      
                      
                      \Text\String$ = InsertString(\Text\String$, GetClipboardText(), \CaretPos + 1)
                      \CaretPos + Len(GetClipboardText())
                      \CaretPosFixed = \CaretPos
                      
                      If StartDrawing And Blink_Text$ And \Text\PosX > -2
                        \Text\PosX - TextWidth(Blink_Text$) : If \Text\PosX < -2 : \Text\PosX =- 2 : EndIf
                      EndIf
                      
                    EndIf
                    
                EndSelect 
                
                
              Case #_Event_LeftButtonDown
                If \Type = #_Type_String Or \Type = #_Type_Editor Or (\Type = #_Type_ComboBox And \Item\Entered\Element =- 1)
                  \CaretPos = GetCaretPos(This())
                  If \CaretPos = DoubleClickCaretPos
                    \CaretPosFixed = 0
                    \CaretPos = Len(\Text\String$)
                    Update_Text_Selected = #True
                  Else
                    \CaretPosFixed = \CaretPos
                    \Text\Selected$ = ""
                  EndIf 
                  DoubleClickCaretPos =- 1
                EndIf
                
              Case #_Event_LeftDoubleClick : \CaretPos = GetCaretPos(This()) 
                DoubleClickCaretPos = \CaretPos
                
                Protected char = Asc(Mid(\Text\String$, \CaretPos + 1, 1))
                
                If \Flag & #_Flag_Password
                  \CaretPosFixed = 0
                  \CaretPos = Len(\Text\String$)
                  \CursorLength = \CaretPosFixed - \CaretPos
                Else
                  If (char > =  ' ' And char < =  '/') Or 
                     (char > =  ':' And char < =  '@') Or 
                     (char > =  '[' And char < =  96) Or 
                     (char > =  '{' And char < =  '~')
                    
                    \CaretPosFixed = \CaretPos
                    \CaretPos + 1
                    \CursorLength = \CaretPosFixed - \CaretPos
                  Else
                    Protected Index
                    
                    For Index = \CaretPos To 0 Step - 1
                      char = Asc(Mid(\Text\String$, Index, 1))
                      If (char > =  ' ' And char < =  '/') Or 
                         (char > =  ':' And char < =  '@') Or 
                         (char > =  '[' And char < =  96) Or 
                         (char > =  '{' And char < =  '~')
                        Break
                      EndIf
                    Next
                    
                    If Index =- 1 : \CaretPosFixed = 0 : Else : \CaretPosFixed = Index : EndIf
                    
                    For Index = \CaretPos + 1 To Len(\Text\String$)
                      char = Asc(Mid(\Text\String$, Index, 1))
                      If (char > =  ' ' And char < =  '/') Or 
                         (char > =  ':' And char < =  '@') Or
                         (char > =  '[' And char < =  96) Or 
                         (char > =  '{' And char < =  '~')
                        Break
                      EndIf
                    Next
                    
                    \CaretPos = Index - 1
                    
                    \CursorLength = \CaretPosFixed - \CaretPos
                    
                    If \CursorLength < 0 : \CursorLength = 0 : EndIf
                  EndIf
                EndIf
                
                Update_Text_Selected = #True
                
              Case #_Event_MouseMove
                If *CreateElement\Buttons = #_Event_LeftButtonDown
                  \CaretPos = GetCaretPos(This())
                  Update_Text_Selected = #True
                  Quit = #True 
                EndIf
                
            EndSelect
            
            If Update_Text_Selected
              UpdateCaret(This())
              \Text\Selected$ = Mid(\Text\String$, \CaretPosMoved + (1), \CursorLength)
            EndIf
            
            If StartDrawing
              StopDrawing()
            EndIf
            
            
            If \Text\ChangeString$ <> \Text\String$ : \Text\ChangeString$ = \Text\String$
              PostEvent = #_Event_Change
            EndIf
            
            If PostEvent
              PostEventElement(PostEvent, EventElement);, \This()\Items()\Element)
            EndIf
            
            If Quit
              ProcedureReturn #True
            EndIf
        EndSelect
        
      EndIf
    EndWith
  EndIf
  
EndProcedure

Procedure ElementsDefaultCallBack(List This.S_CREATE_ELEMENT(), Event.q, EventElement)
  Protected Result
  
  If *CreateElement
    With This()
      ;       PushListPosition(This())
      ;       SelectElement(This(), EventElement)
      Select Event
        Case #_Event_LeftClick
          Select \Type
            Case #_Type_Option
              SetElementState(EventElement, #True)
              
            Case #_Type_CheckBox
              \Inbetween = 0
              \Checked!1
              ;               Static i 
              ;               ;i = GetElementState(EventElement) ; + 1 : If i = 2 : i =- 1 : EndIf
              ;               i!1
              ;               SetElementState(EventElement, i)
              
            Case #_Type_ListIcon
              ;               If ((\Flag&#_Flag_CheckBoxes) = #_Flag_CheckBoxes) ; \This()\ThreeState
              ;                 If ((Event & #_Event_LeftClick) = #_Event_LeftClick) 
              ;                   ChangeCurrentElement(\Items(), ItemID(\Item\Entered\Element))
              ;                   If ((\FrameCoordinate\X+6) < *CreateElement\MouseX) And ((\FrameCoordinate\X+\Items()\FrameCoordinate\X-6/2) > *CreateElement\MouseX) 
              ;                     \Items()\Inbetween = 0
              ;                     \Items()\Checked!1
              ;                   PostEventElement( #_Event_Change, EventElement, \Items()\Element)  
              ;                   EndIf
              ;                 EndIf
              ;               EndIf
              
          EndSelect
          
      EndSelect
      ;       PopListPosition(This())
    EndWith
  EndIf
  
  ProcedureReturn Result
EndProcedure


Procedure ResizesElements(SideDirection, CheckedElement)
  Protected X,Y,Width,Height
  
  With *CreateElement
    ChangeCurrentElement(\This(), ElementID(CheckedElement))
    
    If \MultiSelect
      PushListPosition(\This())
      ForEach \This()
        If \This()\EditingMode
          If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
            X = (((\MouseX-\This()\DeltaX) / Steps) * Steps) 
            Y = (((\MouseY-\This()\DeltaY) / Steps) * Steps) 
            Width=(\This()\FrameCoordinate\Width)+((\This()\ContainerCoordinate\X)-X)-(\This()\bSize-\This()\BorderSize)
            Height=(\This()\FrameCoordinate\Height)+((\This()\ContainerCoordinate\Y)-Y)-(\This()\bSize-\This()\BorderSize)
            
            Select SideDirection 
              Case 1 : _ResizeListElement(\This(), \This()\Element, X, #PB_Ignore, Width, #PB_Ignore)
              Case 2 : _ResizeListElement(\This(), \This()\Element, #PB_Ignore, Y, #PB_Ignore, Height)
              Case 3  
                ;                 Width = Steps((\MouseX-\This()\FrameCoordinate\X),Steps)
                _ResizeListElement(\This(), \This()\Element, #PB_Ignore, #PB_Ignore, (X-\This()\ContainerCoordinate\X)+(\This()\FrameCoordinate\Width), #PB_Ignore)
                ;Debug X-\This()\ContainerCoordinate\X
              Case 4 
                Height = Steps((\MouseY-\This()\FrameCoordinate\Y),Steps)
                If \This()\Type = #_Type_Window
                  _ResizeListElement(\This(), \This()\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height)
                Else
                  _ResizeListElement(\This(), \This()\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height+1)
                EndIf
                
              Case 5 : _ResizeListElement(\This(), \This()\Element, X, Y, Width, Height)
              Case 6  
                Width = Steps((\MouseX-\This()\FrameCoordinate\X),Steps)
                If \This()\Type = #_Type_Window
                  _ResizeListElement(\This(), \This()\Element, #PB_Ignore, Y, Width-2, Height)
                Else
                  _ResizeListElement(\This(), \This()\Element, #PB_Ignore, Y, Width+1, Height)
                EndIf
                
              Case 7 
                Width = Steps((\MouseX-\This()\FrameCoordinate\X),Steps)
                Height = Steps((\MouseY-\This()\FrameCoordinate\Y),Steps)
                If \This()\Type = #_Type_Window
                  _ResizeListElement(\This(), \This()\Element, #PB_Ignore, #PB_Ignore, Width-2, Height)
                Else
                  _ResizeListElement(\This(), \This()\Element, #PB_Ignore, #PB_Ignore, Width+1, Height+1)
                EndIf
                
              Case 8 
                Height = Steps((\MouseY-\This()\FrameCoordinate\Y),Steps)
                If \This()\Type = #_Type_Window
                  _ResizeListElement(\This(), \This()\Element, X, #PB_Ignore, Width, Height)
                Else
                  _ResizeListElement(\This(), \This()\Element, X, #PB_Ignore, Width, Height+1)
                EndIf
                
              Case 9 : SetCursorElement(#PB_Cursor_Arrows) 
                If \This()\Type = #_Type_Window
                  _ResizeListElement(\This(), \This()\Element, X, Y, #PB_Ignore, #PB_Ignore)
                Else
                  If \This()\Window = \This()\Parent\Element
                    _ResizeListElement(\This(), \This()\Element, X, Y, #PB_Ignore, #PB_Ignore) 
                  Else
                    _ResizeListElement(\This(), \This()\Element, X-1, Y-1, #PB_Ignore, #PB_Ignore) 
                  EndIf
                EndIf
                
            EndSelect
          EndIf
        EndIf
      Next
      PopListPosition(\This())
      
      ProcedureReturn #True
    Else
      X = (((\MouseX-\DeltaX) / Steps) * Steps) 
      Y = (((\MouseY-\DeltaY) / Steps) * Steps) 
      Width=(\This()\FrameCoordinate\Width)+((\This()\ContainerCoordinate\X)-X)-(\This()\bSize-\This()\BorderSize)
      Height=(\This()\FrameCoordinate\Height)+((\This()\ContainerCoordinate\Y)-Y)-(\This()\bSize-\This()\BorderSize)
      
      Select SideDirection 
        Case 1 : ResizeElement(\This()\Element, X, #PB_Ignore, Width, #PB_Ignore)
        Case 2 : ResizeElement(\This()\Element, #PB_Ignore, Y, #PB_Ignore, Height)
        Case 3  
          Width = Steps((\MouseX-\This()\FrameCoordinate\X),Steps)
          If \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, Width-2, #PB_Ignore)
          Else
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, Width+1, #PB_Ignore)
          EndIf
          
        Case 4 
          Height = Steps((\MouseY-\This()\FrameCoordinate\Y),Steps)
          If \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height)
          Else
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height+1)
          EndIf
          
        Case 5 : ResizeElement(\This()\Element, X, Y, Width, Height)
        Case 6  
          Width = Steps((\MouseX-\This()\FrameCoordinate\X),Steps)
          If \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, #PB_Ignore, Y, Width-2, Height)
          Else
            ResizeElement(\This()\Element, #PB_Ignore, Y, Width+1, Height)
          EndIf
          
        Case 7 
          Width = Steps((\MouseX-\This()\FrameCoordinate\X),Steps)
          Height = Steps((\MouseY-\This()\FrameCoordinate\Y),Steps)
          If \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, Width-2, Height)
          Else
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, Width+1, Height+1)
          EndIf
          
        Case 8 
          Height = Steps((\MouseY-\This()\FrameCoordinate\Y),Steps)
          If \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, X, #PB_Ignore, Width, Height)
          Else
            ResizeElement(\This()\Element, X, #PB_Ignore, Width, Height+1)
          EndIf
          
        Case 9 : SetCursorElement(#PB_Cursor_Arrows) 
          If \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, X, Y, #PB_Ignore, #PB_Ignore)
          Else
            If \This()\Window = \This()\Parent\Element
              ResizeElement(\This()\Element, X, Y, #PB_Ignore, #PB_Ignore) 
            Else
              ResizeElement(\This()\Element, X-1, Y-1, #PB_Ignore, #PB_Ignore) 
            EndIf
          EndIf
          
      EndSelect
    EndIf
  EndWith
EndProcedure



Procedure ResizeElements(Element, X,Y,Width,Height)
  With *CreateElement
    If \MultiSelect
      PushListPosition(\This())
      ForEach \This()
        If \This()\EditingMode
          If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
            _ResizeListElement(\This(), \This()\Element, Steps((X-\This()\DeltaX),Steps)+2, Steps((Y-\This()\DeltaY),Steps)+2,Width,Height, 0, #_Element_ContainerCoordinate) 
          EndIf
        EndIf
      Next
      PopListPosition(\This())
      
      ProcedureReturn #True
    Else
      ResizeElement(Element, Steps((X-\DeltaX),Steps)+2, Steps((Y-\DeltaY),Steps)+2,Width,Height) 
    EndIf
  EndWith
EndProcedure


;-
Procedure SideDirection() ; Ok
  Static SetCursor.b, Result.b
  
  With *CreateElement
    If \Buttons = 0 : Result = 0
      If ((\This()\Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
        If ((\MouseX > =  \This()\FrameCoordinate\X) And 
            (\MouseX  = < \This()\InnerCoordinate\X))
          Result = 1 ; Left - direction
        ElseIf ((\MouseX > =  (\This()\InnerCoordinate\X+\This()\InnerCoordinate\Width)) And 
                (\MouseX  = < (\This()\FrameCoordinate\X+\This()\FrameCoordinate\Width)))
          Result = 3 ; Right - direction
        EndIf
        
        If ((\MouseY > =  (\This()\FrameCoordinate\Y)) And 
            (\MouseY  = < (\This()\InnerCoordinate\Y-\This()\CaptionHeight-\This()\MenuHeight-\This()\ToolBarHeight)))
          
          If ((\MouseX > =  \This()\FrameCoordinate\X) And (\MouseX  = < \This()\InnerCoordinate\X))
            Result = 5 ; (Left & Top) - direction
          ElseIf ((\MouseX > =  (\This()\InnerCoordinate\X+\This()\InnerCoordinate\Width)) And 
                  (\MouseX  = < (\This()\FrameCoordinate\X+\This()\FrameCoordinate\Width)))
            Result = 6 ; (Right & Top) - direction
          Else
            Result = 2 ; Top - direction
          EndIf    
        ElseIf ((\MouseY > =  (\This()\InnerCoordinate\Y+\This()\InnerCoordinate\Height)) And 
                (\MouseY  = < (\This()\FrameCoordinate\Y+\This()\FrameCoordinate\Height)))
          
          If ((\MouseX > =  \This()\FrameCoordinate\X) And (\MouseX  = < \This()\InnerCoordinate\X))
            Result = 8 ; (Left & Bottom) - direction
          ElseIf ((\MouseX > =  (\This()\InnerCoordinate\X+\This()\InnerCoordinate\Width)) And 
                  (\MouseX  = < (\This()\FrameCoordinate\X+\This()\FrameCoordinate\Width)))
            Result = 7 ; (Right & Bottom) - direction
          Else
            Result = 4 ; Bottom - direction
          EndIf
        EndIf
      EndIf
      
      If ((\This()\Flag & #_Flag_MoveGadget) = #_Flag_MoveGadget)
        If ((\MouseX > \This()\FrameCoordinate\X+\This()\bSize) And 
            (\MouseY > \This()\FrameCoordinate\Y+\This()\bSize) And 
            (\MouseX < (\This()\FrameCoordinate\X+\This()\FrameCoordinate\Width)-\This()\bSize) And 
            (\MouseY < (\This()\FrameCoordinate\Y+\This()\FrameCoordinate\Height)-\This()\bSize)) 
          
          If (\This()\IsContainer = 0  Or 0 = \This()\EditingMode)
            Result = 9
          EndIf
        EndIf
        
        If \This()\IsContainer And ((\MouseX > =  \This()\FrameCoordinate\X) And (\MouseX  = < (\This()\FrameCoordinate\X+Steps*2))) And 
           ((\MouseY > =  \This()\FrameCoordinate\Y) And (\MouseY  = < (\This()\FrameCoordinate\Y+Steps*2)))
          Result = 9
          SetCursorElement(#PB_Cursor_Arrows)
        Else
          If Result = 0 
            SetCursorElement(#PB_Cursor_Default)
          EndIf
        EndIf   
      EndIf 
      
      Select Result
          Case 1,3 : If SetCursor = 0 : SetCursor = 1 : SetCursorElement(#PB_Cursor_LeftRight) : EndIf
          Case 2,4 : If SetCursor = 0 : SetCursor = 1 : SetCursorElement(#PB_Cursor_UpDown) : EndIf
          Case 5,7 : If SetCursor = 0 : SetCursor = 1 : SetCursorElement(#PB_Cursor_LeftUpRightDown) : EndIf
          Case 6,8 : If SetCursor = 0 : SetCursor = 1 : SetCursorElement(#PB_Cursor_LeftDownRightUp) : EndIf
          Default  : If SetCursor = 1 : SetCursor = 0 : SetCursorElement(#PB_Cursor_Default) : EndIf
      EndSelect
      ;       Select Result
      ;         Case 1,3 : SetCursorElement(#PB_Cursor_LeftRight)
      ;         Case 2,4 : SetCursorElement(#PB_Cursor_UpDown)
      ;         Case 5,7 : SetCursorElement(#PB_Cursor_LeftUpRightDown)
      ;         Case 6,8 : SetCursorElement(#PB_Cursor_LeftDownRightUp)
      ;         Default  : SetCursorElement(#PB_Cursor_Default)
      ;       EndSelect
      
      \SideDirection = Result
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetAnchors(Element, Reset.b = #True)
  With *CreateElement
    PushListPosition(\This())
    If Reset.b
      ForEach \This()
        \This()\Flag &~ #_Flag_Anchors
      Next
    EndIf
    
    If IsElement(Element)
      ChangeCurrentElement(\This(), ElementID(Element))
      \This()\Flag | #_Flag_Anchors
    EndIf
    PopListPosition(\This())
  EndWith
EndProcedure

Procedure DrawLines(List This.S_CREATE_ELEMENT())
  Static TopX,LeftX,TopY,LeftY,BottomX,RightX,BottomY,RightY
  Protected Window =- 1, Parent =- 1, LineWidth = 1, LineHeight = 1
  Protected Element =- 1, ElementX,ElementY,ElementW,ElementH, XElement,YElement,WElement,HElement
  
  With This()
    If (\Hide = 0 And \EditingMode) 
      Element = \Element
      
      If Element 
        Window = \Window
        Parent = \Parent\Element
        ElementX = \FrameCoordinate\X+(\bSize-\BorderSize) 
        ElementY = \FrameCoordinate\Y+(\bSize-\BorderSize)
        ElementW = ElementX+\FrameCoordinate\Width-(\bSize-\BorderSize)*2
        ElementH = ElementY+\FrameCoordinate\Height-(\bSize-\BorderSize)*2
        
        LeftY = ElementY : RightY = ElementY : LeftX = ElementH : RightX = ElementH
        TopX = ElementX : BottomX = ElementX : TopY = ElementW : BottomY = ElementW
        
        PushListPosition(This())
        ForEach This()
          If  \EditingMode And (\Element <> Element And Window = \Window And \Parent\Element = Parent)   
            DrawingMode(#PB_2DDrawing_Default) 
            
            XElement = \FrameCoordinate\X+(\bSize-\BorderSize)
            YElement = \FrameCoordinate\Y+(\bSize-\BorderSize) 
            WElement = XElement+\FrameCoordinate\Width-(\bSize-\BorderSize)*2                                           
            HElement = YElement+\FrameCoordinate\Height-(\bSize-\BorderSize)*2
            
            ;Left
            If ElementX = XElement 
              If LeftY > YElement : LeftY = YElement : EndIf
              If LeftX < HElement : LeftX = HElement : EndIf
              
              Line(ElementX,LeftY,1,LeftX-LeftY, $0000FF)
            EndIf
            
            ;Right
            If ElementW = WElement
              If RightY > YElement : RightY = YElement : EndIf
              If RightX < HElement : RightX = HElement : EndIf
              
              Line(ElementW-LineWidth, RightY, 1, RightX-RightY, $0000FF)
            EndIf
            
            ;Top
            If ElementY = YElement 
              If TopX > XElement : TopX = XElement : EndIf
              If TopY < WElement : TopY = WElement: EndIf
              
              Line(TopX, ElementY, TopY-TopX, 1, $FF0000)
            EndIf
            
            ;Bottom
            If ElementH = HElement 
              If BottomX > XElement : BottomX = XElement : EndIf
              If BottomY < WElement : BottomY = WElement: EndIf
              
              Line(BottomX, ElementH-LineHeight, BottomY-BottomX, 1, $FF0000)
            EndIf
          EndIf
          
        Next
        PopListPosition(This())
        
        ;           DrawingMode(#PB_2DDrawing_Default) 
        ;           Line(ElementX(Parent),(ElementY+(\FrameCoordinate\Height-Steps)/2)-1,Steps,1, $0000FF)
        ;           Line(ElementX(Parent),(ElementY+(\FrameCoordinate\Height-Steps)/2),Steps,1, $0000FF)
        ;           Line(ElementX(Parent),(ElementY+(\FrameCoordinate\Height-Steps)/2)+1,Steps,1, $0000FF)
        
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure DrawFrames(List This.S_CREATE_ELEMENT())
  Protected X,Y,Width,Height, AnchorSize = 6
  
  With This()
    If (\Hide = 0 And ((\Flag&#_Flag_Anchors) = #_Flag_Anchors))
      
      X = \FrameCoordinate\X
      Y = \FrameCoordinate\Y
      Width = \FrameCoordinate\Width 
      Height = \FrameCoordinate\Height
      Protected bs = (\bSize-\BorderSize) 
      
      ; Frame
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X+bs,Y+bs,Width-bs*2,Height-bs*2, 0);RGBA(0,173,255,255))
      
    EndIf       
  EndWith
EndProcedure

Procedure DrawAnchors(List This.S_CREATE_ELEMENT())
  Protected X,Y,Width,Height, AnchorSize = 6
  
  With This()
    If (\Hide = 0 And ((\Flag&#_Flag_Anchors) = #_Flag_Anchors))
      
      X = \FrameCoordinate\X
      Y = \FrameCoordinate\Y
      Width = \FrameCoordinate\Width 
      Height = \FrameCoordinate\Height
      Protected bs = (\bSize-\BorderSize) 
      
      ;5
      If \IsContainer
        ;         DrawingMode(#PB_2DDrawing_Default) 
        ;         Box(X,Y,AnchorSize*2,AnchorSize*2, $FFFFFF)
        DrawingMode(#PB_2DDrawing_Outlined) 
        Box(X,Y,AnchorSize*2,AnchorSize*2, 0)
      Else
        DrawingMode(#PB_2DDrawing_Default) 
        Box(X,Y,AnchorSize,AnchorSize, $FFFFFF)
        DrawingMode(#PB_2DDrawing_Outlined) 
        Box(X,Y,AnchorSize,AnchorSize, 0)
        
        ;         Protected h=3 
        ;         ;Protected CreateImage=CreateImage(#PB_Any, h*2+1, h*2+1,32,#PB_Image_Transparent)
        ;         DrawingMode(#PB_2DDrawing_Gradient|#PB_2DDrawing_AllChannels)     
        ;         BackColor(RGBA(255,255,255,255)) : CircularGradient(X+((h*2)/2)-h/3, Y+((h*2)/2)-h/3, (h)) 
        ;         FrontColor(RGBA(0,173,255,255)) : Circle(X+(h*2)/2, Y+(h*2)/2, (h*2)/2) : FrontColor(RGBA(255,255,255,255))
        ;         ;ResizeImage(CreateImage,h ,h)
      EndIf
      
      ;1
      DrawingMode(#PB_2DDrawing_Default) 
      Box(X,Y+(Height-AnchorSize)/2,AnchorSize,AnchorSize, $FFFFFF)
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X,Y+(Height-AnchorSize)/2,AnchorSize,AnchorSize, 0)
      ;8
      DrawingMode(#PB_2DDrawing_Default) 
      Box(X,Y+Height-AnchorSize,AnchorSize,AnchorSize, $FFFFFF)
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X,Y+Height-AnchorSize,AnchorSize,AnchorSize, 0)
      ;6
      DrawingMode(#PB_2DDrawing_Default) 
      Box(X+Width-AnchorSize,Y,AnchorSize,AnchorSize, $FFFFFF)
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X+Width-AnchorSize,Y,AnchorSize,AnchorSize, 0)
      ;3
      DrawingMode(#PB_2DDrawing_Default) 
      Box(X+Width-AnchorSize,Y+(Height-AnchorSize)/2,AnchorSize,AnchorSize, $FFFFFF)
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X+Width-AnchorSize,Y+(Height-AnchorSize)/2,AnchorSize,AnchorSize, 0)
      ;7
      DrawingMode(#PB_2DDrawing_Default) 
      Box(X+Width-AnchorSize,Y+Height-AnchorSize,AnchorSize,AnchorSize, $FFFFFF)
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X+Width-AnchorSize,Y+Height-AnchorSize,AnchorSize,AnchorSize, 0)
      
      ;2
      DrawingMode(#PB_2DDrawing_Default) 
      Box(X+(Width-AnchorSize)/2,Y,AnchorSize,AnchorSize, $FFFFFF)
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X+(Width-AnchorSize)/2,Y,AnchorSize,AnchorSize, 0)
      ;4
      DrawingMode(#PB_2DDrawing_Default) 
      Box(X+(Width-AnchorSize)/2,Y+Height-AnchorSize,AnchorSize,AnchorSize, $FFFFFF)
      DrawingMode(#PB_2DDrawing_Outlined) 
      Box(X+(Width-AnchorSize)/2,Y+Height-AnchorSize,AnchorSize,AnchorSize, 0)
      
    EndIf       
  EndWith
EndProcedure

Procedure DrawToolTip(List This.S_CREATE_ELEMENT())
  Protected X, Y, Width, Height, Text$, TextWidth, TextHeight
  
  With *CreateElement
    Text$ = \ToolTip\String$
    X = \ToolTip\X
    Y = \ToolTip\Y
    Width = \ToolTip\Width
    Height = \ToolTip\Height
  EndWith
  
  ; Всплывающая подсказка
  With This()
    
    If Text$ ;: SetOrigin(0,0) : UnclipOutput()
      TextWidth = TextWidth(Text$)
      TextHeight = TextHeight(Text$)
      
      If TextWidth > Width
        Width = TextWidth + 10
      EndIf
      
      If TextHeight > Height
        Height = TextHeight + 4
      EndIf
      
      DrawingMode(#PB_2DDrawing_Outlined) : Box(X, Y, Width, Height,0)
      DrawingMode(#PB_2DDrawing_Default) : Box(X+1, Y+1, Width-2, Height-2)
      
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawText(X+5, Y+(Height-TextHeight)/2,  Text$, 0)
      
      ;ClipOutput(\This()\X,\This()\Y,\This()\Width,\This()\Height)
      ;\ToolTip\String$ = ""
    EndIf
  EndWith
  
EndProcedure

Procedure DrawFilterCallback(X, Y, SourceColor, TargetColor)
  Protected Color, Dot.b=4, line.b = 10, Length.b = (Line+Dot*2+1)
  Static Len.b
  
  If ((Len%Length)<line Or (Len%Length)=(line+Dot))
    If (Len>(Line+Dot)) : Len=0 : EndIf
    Color = SourceColor
  Else
    Color = TargetColor
  EndIf
  
  Len+1
  ProcedureReturn Color
EndProcedure

Procedure UpdateDrawingContent()
  With *CreateElement
    
    PushListPosition(\This())
    ForEach \This()
      ;       If (\StickyWindow > 0 And 
      ;           (\This()\Element = \StickyWindow Or \StickyWindow = \This()\Window Or \PopupElement)) = 0
      SetOrigin(0,0) 
      DrawingElement(\This())
      ;       EndIf
    Next
    
    If \MultiSelect
      ForEach \This() 
        DrawFrames(\This()) 
        DrawLines(\This())
        DrawAnchors(\This()) 
      Next
    Else
      If IsElement(\CheckedElement)
        ChangeCurrentElement(\This(), ElementID(\CheckedElement))
        DrawFrames(\This()) 
        DrawLines(\This())
        DrawAnchors(\This()) 
      EndIf
    EndIf
    
    If IsElement(\StickyWindow)
      ChangeCurrentElement(\This(), ElementID(\StickyWindow))
      SetOrigin(0,0) : DrawingElement(\This())
      While NextElement(\This())
        If \This()\Window = \StickyWindow
          SetOrigin(0,0) : DrawingElement(\This())
        EndIf
      Wend
    EndIf
    
    ForEach \This() 
      If (Not \This()\Hide And \This()\Type = #_Type_PopupMenu)
        SetOrigin(0,0) : DrawingElement(\This())
      EndIf
    Next 
    
    ;     ForEach \This() 
    ;       If (\StickyWindow > 0 And 
    ;           (\This()\Element = \StickyWindow Or \StickyWindow = \This()\Window Or \PopupElement))
    ;         SetOrigin(0,0) 
    ;         DrawingElement(\This())
    ;       EndIf
    ;     Next 
    
    If IsElement(\Element)
      ChangeCurrentElement(\This(), ElementID(\Element))
      DrawToolTip(\This())
    EndIf
    
    PopListPosition(\This())
  EndWith
EndProcedure

;-
Procedure ElementDrawCallBack(EventElement, Show.b=#False)
  Protected *Element = ElementID(EventElement)
  
  With *CreateElement
    If *Element And ListSize(\This())
      ChangeCurrentElement(\This(), *Element)
      
      If \This()\Show 
        If BeginDrawing()
          If \This()\FontID 
            DrawingFont(\This()\FontID) 
          Else 
           ; DrawingFont(GetGadgetFont(#PB_Default)) 
          EndIf
          
          DrawingMode(#PB_2DDrawing_Default) 
          Box(0,0,OutputWidth(),OutputHeight(), \BackColor) 
          
          UpdateDrawingContent()
          EndDrawing()
        EndIf
      Else
        If Show
          ForEach \This() : \This()\Show = Show : Next
          ElementDrawCallBack(EventElement, Show)
        EndIf
      EndIf
    EndIf
  EndWith
  
EndProcedure


Procedure ElementItemCallBack(*CurrentElement, Event.q, EventElement, EventElementItem)
  Protected iWidth, Element =- 1
  ;     SetElementState(EventElement, #_Flag_CloseGadget)
  ;                     ProcedureReturn 
  Protected *CurrentItem, Left = 5, Top = 0 ; Положение для SubMenu 
  Static Click, PopupMenuElement =- 1
  
  With *CreateElement
    If *CurrentElement
      ChangeCurrentElement(\This(), *CurrentElement)
      
      ;         
      If IsElementItem(EventElementItem) 
        *CurrentItem = ItemID(EventElementItem)
        ChangeCurrentElement(\This()\Items(), *CurrentItem)
        
        ; ToolTip
        If ((Event.q & #_Event_MouseEnter) = #_Event_MouseEnter) 
          ; Если текст итема не помешается
          If \This()\Items()\Text\Width > \This()\InnerCoordinate\Width-ElementWidth(\This()\Scroll\Vert)
            \ToolTip\X = \This()\InnerCoordinate\X + \This()\Items()\FrameCoordinate\X
            \ToolTip\Y = \This()\InnerCoordinate\Y + \This()\Items()\FrameCoordinate\Y
            \ToolTip\Width = \This()\Items()\FrameCoordinate\Width
            \ToolTip\Height = \This()\Items()\FrameCoordinate\Height
            \ToolTip\String$ = \This()\Items()\Text\String$
          EndIf
          
          If \This()\Items()\ToolTip\String$
            \ToolTip\X = \MouseX+8
            \ToolTip\Y = \MouseY+16
            \ToolTip\String$ = \This()\Items()\ToolTip\String$
          EndIf
        ElseIf ((Event.q & #_Event_MouseLeave) = #_Event_MouseLeave) 
          \ToolTip\String$ = ""
        EndIf
        
        If StringEditableCallBack(\This()\Items(), Event, EventElementItem)
          ;Drawing = #True
        EndIf
        
        If \This()\Items()\Disable = #False
          
          If ((Event.q & #_Event_LeftButtonDown) = #_Event_LeftButtonDown) 
            \Item\Selected\Element = EventElementItem 
            \This()\Items()\Selected\Element = EventElementItem
            
            
            \This()\Items()\State &~ #_State_Entered
            \This()\Items()\State | #_State_Selected
            
            
            If \This()\Type = #_Type_Menu Or \This()\Type = #_Type_ComboBox
              \Popup!1 
              \This()\Item\Selected\Element = EventElementItem
              If \Popup : \This()\Items()\State | #_State_Focused : EndIf          
            EndIf
          EndIf
          
          If \Popup 
            ; If called popup menu then menu items was selected
            If \This()\Type = #_Type_Menu
              If ((Event.q & #_Event_MouseEnter) = #_Event_MouseEnter) 
                \Item\Selected\Element = EventElementItem 
                \This()\Item\Selected\Element = EventElementItem
                \This()\Items()\Selected\Element = EventElementItem
                
                \This()\Items()\State &~ #_State_Entered
                \This()\Items()\State | #_State_Selected
                \This()\Items()\State | #_State_Focused
                
                \This()\Items()\Flag | #_Flag_Border  
              EndIf
              If ((Event.q & #_Event_MouseLeave) = #_Event_MouseLeave) 
                \This()\Items()\Selected\Element =- 1
                
                \This()\Items()\State &~ #_State_Selected
                \This()\Items()\State | #_State_Entered
                \This()\Items()\State &~ #_State_Focused
                
                \This()\Items()\Flag &~ #_Flag_Border
              EndIf
            EndIf
          Else
            If ((Event.q & #_Event_MouseEnter) = #_Event_MouseEnter) 
              \This()\Items()\Entered\Element = EventElementItem
              
              \This()\Items()\State &~ #_State_Default
              \This()\Items()\State | #_State_Entered
              
              If \This()\Type = #_Type_Menu Or \This()\Type = #_Type_ComboBox
                
                ; ComboBox editable set gradient
                If ((\This()\Flag & #_Flag_Editable) = #_Flag_Editable)
                  \This()\Items()\BackColor =- 1
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
                EndIf
                
                \This()\Items()\State | #_Flag_Border  
              EndIf
            EndIf
            If ((Event.q & #_Event_LeftButtonUp) = #_Event_LeftButtonUp) 
              \This()\Items()\Selected\Element =- 1
              
              \This()\Items()\State &~ #_State_Selected
              \This()\Items()\State | #_State_Entered
              
              If \This()\Type = #_Type_Menu Or \This()\Type = #_Type_ComboBox
                \This()\Items()\State &~ #_State_Focused
                \This()\Item\Selected\Element =- 1
              EndIf
            EndIf
            If ((Event.q & #_Event_MouseLeave) = #_Event_MouseLeave) 
              \This()\Items()\Entered\Element =- 1
              
              \This()\Items()\State &~ #_State_Selected
              \This()\Items()\State &~ #_State_Entered
              \This()\Items()\State | #_State_Default
              
              If \This()\Type = #_Type_Menu Or \This()\Type = #_Type_ComboBox
                \This()\Items()\State &~ #_State_Focused
                
                ; ComboBox editable unset gradient
                If ((\This()\Flag & #_Flag_Editable) = #_Flag_Editable)
                  \This()\Items()\BackColor = $FFFFFF
                  \This()\Items()\DrawingMode = #PB_2DDrawing_Default
                EndIf
                
                \This()\Items()\Flag &~ #_Flag_Border
              EndIf
            EndIf
          EndIf
          
          ;
          Select \This()\Type
              ; For comboBox element items event
            Case #_Type_AnchorButton
              Select Event
                Case #_Event_LeftButtonDown
                  Protected Focus1,Focus, Size
                  Select EventElementItem
                    Case 1
                      Size = \This()\Items()\FrameCoordinate\Width+4
                      If \This()\Items()\State&#_State_Focused : Focus=1
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(3)) 
                      If \This()\Items()\State&#_State_Focused : Focus1=1 : EndIf
                      ChangeCurrentElement(\This()\Items(), ItemID(9))
                      \This()\Items()\FrameCoordinate\X = Size-2
                      \This()\Items()\FrameCoordinate\Y = (\This()\InnerCoordinate\Height-\This()\Items()\FrameCoordinate\Height)/2
                      
                      If Focus1
                        If Focus
                          \This()\Items()\FrameCoordinate\Width = Size
                        Else
                          \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width-Size*2+4
                        EndIf
                      Else
                        \This()\Items()\FrameCoordinate\Width = Size
                      EndIf
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      PopListPosition(\This()\Items())
                      
                      
                    Case 3
                      If \This()\Items()\State&#_State_Focused : Focus=1
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      Size = \This()\Items()\FrameCoordinate\Width+4
                      
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(1)) 
                      If \This()\Items()\State&#_State_Focused : Focus1=1 : EndIf
                      ChangeCurrentElement(\This()\Items(), ItemID(9))
                      \This()\Items()\FrameCoordinate\Y = (\This()\InnerCoordinate\Height-\This()\Items()\FrameCoordinate\Height)/2
                      
                      If Focus1
                        If Focus
                          \This()\Items()\FrameCoordinate\Width = Size
                        Else
                          \This()\Items()\FrameCoordinate\X = \This()\Items()\FrameCoordinate\Width-2
                          \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width-Size*2+4
                        EndIf
                      Else
                        \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width - Size*2+2
                        \This()\Items()\FrameCoordinate\Width = Size
                      EndIf
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      PopListPosition(\This()\Items())
                      
                    Case 2
                      Size = \This()\Items()\FrameCoordinate\Height+4
                      If \This()\Items()\State&#_State_Focused : Focus=1
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(4)) 
                      If \This()\Items()\State&#_State_Focused : Focus1=1 : EndIf
                      ChangeCurrentElement(\This()\Items(), ItemID(9))
                      \This()\Items()\FrameCoordinate\Y = \This()\Items()\FrameCoordinate\Height-2
                      \This()\Items()\FrameCoordinate\X = (\This()\InnerCoordinate\Width-\This()\Items()\FrameCoordinate\Width)/2
                      
                      If Focus1
                        If Focus
                          \This()\Items()\FrameCoordinate\Height = Size
                        Else
                          \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height-Size*2+4
                        EndIf
                      Else
                        \This()\Items()\FrameCoordinate\Height = Size
                      EndIf
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      PopListPosition(\This()\Items())
                      
                    Case 4
                      If \This()\Items()\State&#_State_Focused : Focus=1
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      Size = \This()\Items()\FrameCoordinate\Height+4
                      
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(2)) 
                      If \This()\Items()\State&#_State_Focused : Focus1=1 : EndIf
                      ChangeCurrentElement(\This()\Items(), ItemID(9))
                      \This()\Items()\FrameCoordinate\X = (\This()\InnerCoordinate\Width-\This()\Items()\FrameCoordinate\Width)/2
                      
                      If Focus1
                        If Focus
                          \This()\Items()\FrameCoordinate\Height = Size
                        Else
                          \This()\Items()\FrameCoordinate\Y = \This()\Items()\FrameCoordinate\Height-2
                          \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height-Size*2+4
                        EndIf
                      Else
                        \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Height - Size*2+2
                        \This()\Items()\FrameCoordinate\Height = Size
                      EndIf
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      PopListPosition(\This()\Items())
                      
                    Case 5
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(3)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(4)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(10)) : \This()\Items()\State = #_State_Default
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(1)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      ChangeCurrentElement(\This()\Items(), ItemID(2)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      PopListPosition(\This()\Items())
                      If \This()\Items()\State&#_State_Focused
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      
                    Case 6
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(1)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(4)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(10)) : \This()\Items()\State = #_State_Default
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(2)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      ChangeCurrentElement(\This()\Items(), ItemID(3)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      PopListPosition(\This()\Items())
                      If \This()\Items()\State&#_State_Focused
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      
                    Case 7
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(1)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(2)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(10)) : \This()\Items()\State = #_State_Default
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(3)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      ChangeCurrentElement(\This()\Items(), ItemID(4)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      PopListPosition(\This()\Items())
                      If \This()\Items()\State&#_State_Focused
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      
                    Case 8
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(2)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(3)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(10)) : \This()\Items()\State = #_State_Default
                      
                      ChangeCurrentElement(\This()\Items(), ItemID(1)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      ChangeCurrentElement(\This()\Items(), ItemID(4)) : \This()\Items()\State = #_State_Default|#_State_Focused
                      PopListPosition(\This()\Items())
                      If \This()\Items()\State&#_State_Focused
                        \This()\Items()\State = #_State_Default
                      Else
                        \This()\Items()\State = #_State_Default|#_State_Focused
                      EndIf
                      
                    Case 10
                      PushListPosition(\This()\Items())
                      ChangeCurrentElement(\This()\Items(), ItemID(1)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(2)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(3)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(5)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(4)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(6)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(7)) : \This()\Items()\State = #_State_Default
                      ChangeCurrentElement(\This()\Items(), ItemID(8)) : \This()\Items()\State = #_State_Default
                      PopListPosition(\This()\Items())
                      \This()\Items()\State = #_State_Default|#_State_Focused
                      
                  EndSelect
                  Protected State = \This()\Items()\State
                  
                  ;                   PushListPosition(\This()\Items())
                  ;                   ChangeCurrentElement(\This()\Items(), ItemID(5))
                  ;                   Protected Size = \This()\Items()\FrameCoordinate\Width+3
                  ;                   PopListPosition(\This()\Items())
                  
                  ;                   PushListPosition(\This()\Items())
                  ;                   ChangeCurrentElement(\This()\Items(), ItemID(9))
                  ;                   Select EventElementItem
                  ;                     Case 1
                  ;                       \This()\Items()\FrameCoordinate\X = \This()\Items()\FrameCoordinate\Width-2
                  ;                       \This()\Items()\FrameCoordinate\Y = (\This()\InnerCoordinate\Height-\This()\Items()\FrameCoordinate\Height)/2
                  ;                     Case 3
                  ;                       \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width - \This()\Items()\FrameCoordinate\Width*2+2
                  ;                       \This()\Items()\FrameCoordinate\Y = (\This()\InnerCoordinate\Height-\This()\Items()\FrameCoordinate\Height)/2
                  ;                     Case 2
                  ;                       \This()\Items()\FrameCoordinate\X = (\This()\InnerCoordinate\Width-\This()\Items()\FrameCoordinate\Width)/2
                  ;                       \This()\Items()\FrameCoordinate\Y = \This()\Items()\FrameCoordinate\Height-2
                  ;                     Case 4
                  ;                       \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Height - \This()\Items()\FrameCoordinate\Height*2+2
                  ;                       \This()\Items()\FrameCoordinate\X = (\This()\InnerCoordinate\Width-\This()\Items()\FrameCoordinate\Width)/2
                  ;                       
                  ;                     Case 5
                  ;                       \This()\Items()\FrameCoordinate\X = \This()\Items()\FrameCoordinate\Width-2
                  ;                       \This()\Items()\FrameCoordinate\Y = \This()\Items()\FrameCoordinate\Height-2
                  ;                     Case 6
                  ;                       \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width - \This()\Items()\FrameCoordinate\Width*2+2
                  ;                       \This()\Items()\FrameCoordinate\Y = \This()\Items()\FrameCoordinate\Height-2
                  ;                     Case 7
                  ;                       \This()\Items()\FrameCoordinate\X = \This()\InnerCoordinate\Width - \This()\Items()\FrameCoordinate\Width*2+2
                  ;                       \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Height - \This()\Items()\FrameCoordinate\Height*2+2
                  ;                     Case 8
                  ;                       \This()\Items()\FrameCoordinate\Y = \This()\InnerCoordinate\Height - \This()\Items()\FrameCoordinate\Height*2+2
                  ;                       \This()\Items()\FrameCoordinate\X = \This()\Items()\FrameCoordinate\Width-2
                  ;                       
                  ;                     Case 10
                  ;                       \This()\Items()\FrameCoordinate\X = (\This()\InnerCoordinate\Width - \This()\Items()\FrameCoordinate\Width)/2
                  ;                       \This()\Items()\FrameCoordinate\Y = (\This()\InnerCoordinate\Height - \This()\Items()\FrameCoordinate\Width)/2
                  ;                   EndSelect
                  ;                   PopListPosition(\This()\Items())
                  ;                   
              EndSelect
              
              ; For comboBox element items event
            Case #_Type_ComboBox 
              Select Event
                Case #_Event_LeftButtonDown
                  If \This()\Linked\Element > 0 
                    
                    If \Popup 
                      \PopupElement = \This()\Linked\Element
                      
                      If \PopupElement
                        ResizeElement(\PopupElement, #PB_Ignore, #PB_Ignore, \This()\InnerCoordinate\Width+2, #PB_Ignore, #PB_Ignore)
                        DisplayPopupMenuElement(\PopupElement, EventElement, \This()\InnerCoordinate\X-1, (\This()\InnerCoordinate\Y+\This()\InnerCoordinate\Height))
                        
                        ; Чтобы при раскритии списка, выбранно былo, последний выбранный элемент
                        PushListPosition(\This())
                        ChangeCurrentElement(\This(), ElementID(\PopupElement))
                        Protected Active = \This()\Item\Selected\Element 
                        
                        PushListPosition(\This())
                        ChangeCurrentElement(\This(), ElementID(EventElement))
                        If \This()\Item\Active =- 1 : \This()\Item\Active = Active : EndIf
                        Active = \This()\Item\Active
                        PopListPosition(\This())
                        
                        \This()\Item\Entered\Element = Active
                        \This()\Item\Selected\Element =- 1
                        PopListPosition(\This())
                      EndIf
                    Else
                      If \PopupElement 
                        HideElement(\PopupElement, #True)
                      EndIf
                    EndIf
                  EndIf
                  
              EndSelect
              
              ; For menu element items event
            Case #_Type_Menu
              Select Event
                Case #_Event_LeftButtonDown : Click ! 1
                  If \This()\Items()\Linked\Element > 0 
                    If Click
                      \PopupElement = \This()\Items()\Linked\Element
                      
                      If \PopupElement
                        DisplayPopupMenuElement(\PopupElement, EventElement,
                                                (\This()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\X),
                                                (\This()\FrameCoordinate\Y+\This()\FrameCoordinate\Height))
                      EndIf
                    Else
                      If \PopupElement 
                        HideElement(\PopupElement, #True) 
                      EndIf
                    EndIf
                  EndIf
                  
                  
                Case #_Event_MouseEnter
                  If Click
                    PushListPosition(\This())
                    ;ResetList(\This())
                    ChangeCurrentElement(\This()\Items(), *CurrentItem)
                    While NextElement(\This())
                      Select \This()\Type
                        Case #_Type_PopupMenu : \This()\Hide = #True
                      EndSelect
                    Wend
                    PopListPosition(\This())
                    
                    If \This()\Items()\Linked\Element > 0  
                      DisplayPopupMenuElement(\This()\Items()\Linked\Element, EventElement, 
                                              (\This()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\X), 
                                              (\This()\FrameCoordinate\Y+\This()\FrameCoordinate\Height))
                    EndIf
                  EndIf
                  
              EndSelect
              
              ; For popup menu items event
            Case #_Type_PopupMenu
              Select Event
                Case #_Event_MouseEnter
                  \Linked\Element = EventElement
                  
                  If \This()\Items()\Linked\Element > 0  
                    DisplayPopupMenuElement(\This()\Items()\Linked\Element, EventElement,
                                            (\This()\FrameCoordinate\X+\This()\FrameCoordinate\Width)-Left,
                                            (\This()\FrameCoordinate\Y+\This()\Items()\FrameCoordinate\Y)-Top )
                  Else
                    PushListPosition(\This())
                    ;ChangeCurrentElement(\This()\Items(), ItemID(EventElementItem))
                    While NextElement(\This())
                      Select \This()\Type
                        Case #_Type_PopupMenu : \This()\Hide = #True
                      EndSelect
                    Wend
                    PopListPosition(\This())
                  EndIf
                  
                Case #_Event_LeftClick, #_Event_RightClick, #_Event_MiddleClick
                  If \This()\Items()\Linked\Element > 0 
                    DisplayPopupMenuElement(\This()\Items()\Linked\Element, EventElement,
                                            (\This()\FrameCoordinate\X+\This()\FrameCoordinate\Width),
                                            (\This()\FrameCoordinate\Y+\This()\Items()\FrameCoordinate\Y))
                  Else
                    ; If popup menu parent combobox then set text
                    If (\This()\Item\Type = #_Type_ComboBox)
                      Protected Text$ = \This()\Items()\Text\String$
                      \This()\Item\Selected\Element = EventElementItem
                      ;
                      PushListPosition(\This())
                      ChangeCurrentElement(\This(), ElementID(\This()\Item\Parent))
                      \This()\Item\Active = EventElementItem
                      ;                       If ((\This()\Flag & #_Flag_Editable) = #_Flag_Editable)
                      \This()\Text\String$ = Text$
                      ;                       Else
                      ;                         SelectElement(\This()\Items(), 0) 
                      ;                         \This()\Items()\Text\String$ = Text$
                      ;                       EndIf
                      PopListPosition(\This())
                    EndIf
                    
                    If IsElement(\This()\Item\Parent)
                      PushListPosition(\This())
                      ChangeCurrentElement(\This(), ElementID(\This()\Item\Parent))
                      \This()\Item\Entered\Element =- 1
                      \This()\Item\Selected\Element =- 1
                      
                      If ListSize(\This()\Items())
                        ForEach (\This()\Items())
                          \This()\Items()\Entered\Element =- 1
                          \This()\Items()\Selected\Element =- 1
                          
                          \This()\Items()\State &~ #_State_Focused
                          \This()\Items()\State &~ #_State_Selected
                          \This()\Items()\State &~ #_State_Entered
                          \This()\Items()\State | #_State_Default
                          
                          ; ComboBox editable unset gradient
                          If ((\This()\Flag & #_Flag_Editable) = #_Flag_Editable)
                            \This()\Items()\BackColor = $FFFFFF
                            \This()\Items()\DrawingMode = #PB_2DDrawing_Default
                          EndIf
                          
                          \This()\Items()\Flag &~ #_Flag_Border
                        Next
                      EndIf
                      
                      PopListPosition(\This())
                    EndIf
                    
                    PushListPosition(\This())
                    ForEach (\This())
                      If #_Type_PopupMenu = \This()\Type : \This()\Hide = #True : EndIf
                    Next
                    PopListPosition(\This()) 
                    
                    \Linked\Element =- 1 : \PopupElement  = 0 : \Popup = 0 : Click = 0
                  EndIf
              EndSelect
              
          EndSelect
          
        EndIf
      Else
        ; If lost focus then hide all popup menus
        Select Event
          Case #_Event_LostFocus
            ;Debug "LostFocus "
            
            If IsElement(\This()\Item\Parent)
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(\This()\Item\Parent))
              \This()\Item\Entered\Element =- 1
              \This()\Item\Selected\Element =- 1
              
              If ListSize(\This()\Items())
                ForEach (\This()\Items())
                  \This()\Items()\Entered\Element =- 1
                  \This()\Items()\Selected\Element =- 1
                  
                  \This()\Items()\State &~ #_State_Focused
                  \This()\Items()\State &~ #_State_Selected
                  \This()\Items()\State &~ #_State_Entered
                  \This()\Items()\State | #_State_Default
                  
                  ; ComboBox editable unset gradient
                  If ((\This()\Flag & #_Flag_Editable) = #_Flag_Editable)
                    \This()\Items()\BackColor = $FFFFFF
                    \This()\Items()\DrawingMode = #PB_2DDrawing_Default
                  EndIf
                  
                  \This()\Items()\Flag &~ #_Flag_Border
                Next
              EndIf
              
              PopListPosition(\This())
            EndIf
            
            ;             PushListPosition(\This())
            ;             ForEach (\This())
            ;               If #_Type_PopupMenu = \This()\Type : \This()\Hide = #True : EndIf
            ;             Next
            ;             PopListPosition(\This()) 
            
            If \PopupElement 
              If \This()\Type = #_Type_PopupMenu
                HideElement(\PopupElement, #True)
                \Linked\Element =- 1 : \PopupElement = 0 : \Popup = 0 : Click = 0
              Else
                If \PopupElement <> EventElement
                  HideElement(\PopupElement, #True)
                  \Linked\Element =- 1 : \PopupElement = 0 : \Popup = 0 : Click = 0
                EndIf
              EndIf
            EndIf          
        EndSelect
      EndIf
      
      ;       Select Event.q
      ;         Case #_Event_MouseWheel
      ;           Debug "MouseWheel"
      ;           \This()\Scroll\Pos - 5 * \Bind\WheelDelta
      ;           
      ;       EndSelect
      ;       
      ; Post events 
      If *CurrentElement : ChangeCurrentElement(\This(), *CurrentElement)
        If *CurrentItem : ChangeCurrentElement(\This()\Items(), *CurrentItem)
          If \This()\Items()\Disable = #False
            
            Select \This()\Type
                ; For popup menu items post event
              Case #_Type_Menu, #_Type_PopupMenu
                Select Event
                  Case #_Event_LeftClick, #_Event_RightClick, #_Event_MiddleClick
                    If \This()\Item\Type = #_Type_ComboBox
                      PostEventElement(#_Event_Change, \This()\Item\Parent, EventElementItem)
                    ElseIf \This()\Items()\Linked\Element = 0 ; Это чтобы не посилать сообщение (OpenSubMenu)
                      PostEventElement(#_Event_Menu, EventElement, \This()\Items()\Element)
                    EndIf
                    
                EndSelect  
                
                ; For spin items post event
              Case #_Type_Spin : SpinElementCallBack(Event, EventElement, EventElementItem)
                
                ; For trackBar items post event
              Case #_Type_TrackBar : TrackBarElementCallBack(Event, EventElement, EventElementItem)
                
                ; For scrollBar items post event
              Case #_Type_ScrollBar : ScrollBarElementCallBack(Event, EventElement, EventElementItem)
                
                ; For toolbar items post event
              Case #_Type_Toolbar
                Select Event
                  Case #_Event_LeftClick
                    If \This()\Item\Active = EventElementItem
                      PostEventElement(#_Event_Menu, EventElement, \This()\Items()\Element)
                    EndIf
                    
                EndSelect  
                
                ; For window items post event
              Case #_Type_Window
                  Select Event
                  Case #_Event_LeftClick
                    Select EventElementItem
                      Case #E_CloseGadget
                        SetWindowElementState(EventElement, #_Event_Close)
                        
                      Case #E_MaximizeGadget
                        If \This()\WindowState = #_Event_Maximize
                          SetWindowElementState(EventElement, #_Event_Restore)
                        Else
                          SetWindowElementState(EventElement, #_Event_Maximize)
                        EndIf
                        
                      Case #E_MinimizeGadget
                        If \This()\WindowState = #_Event_Minimize
                          SetWindowElementState(EventElement, #_Event_Restore)
                        Else
                          SetWindowElementState(EventElement, #_Event_Minimize)
                        EndIf
                        
                    EndSelect
                    
                  Case #_Event_LeftDoubleClick
                    If EventElementItem = #E_TitleGadget
                      If \This()\WindowState = #_Event_Maximize
                        SetWindowElementState(EventElement, #_Event_Restore)
                      Else
                        SetWindowElementState(EventElement, #_Event_Maximize)
                      EndIf
                    EndIf
                EndSelect 
              
;                 Select Event
;                   Case #_Event_LeftClick
;                     SetElementState(EventElement, \This()\Items()\Type)
;                     
;                   Case #_Event_LeftDoubleClick
;                     If EventElementItem = 0
;                       If IsElementItem(2)
;                         ChangeCurrentElement(\This()\Items(), ItemID(2))
;                         If \This()\Items()\Type = #_Flag_MaximizeGadget
;                           SetElementState(EventElement, #_Flag_MaximizeGadget)
;                         EndIf
;                       EndIf
;                     EndIf
;                 EndSelect 
;                 
                ; 
                ; For listIcon Element items Event
              Case #_Type_ListIcon
                Select Event
                  Case #_Event_LeftButtonDown
                    If \This()\Item\Type = #_Type_ComboBox : Element = \This()\Item\Parent : Else : Element = EventElement : EndIf
                    
                    If ((\This()\Flag&#_Flag_CheckBoxes) = #_Flag_CheckBoxes) ; \This()\ThreeState
                      If ((\This()\FrameCoordinate\X+6) < \MouseX) And ((\This()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\X-6/2) > \MouseX) 
                        \This()\Items()\Checked!1
                        \This()\Items()\Inbetween = 0
                        \This()\Item\Selected\Element = EventElementItem
                        PostEventElement(#_Event_Change, Element, EventElementItem)
                      Else
                        If \This()\Item\Selected\Element <> EventElementItem
                          \This()\Item\Selected\Element = EventElementItem
                          PostEventElement(#_Event_Change, Element, EventElementItem)
                        EndIf
                      EndIf
                    Else
                      If \This()\Item\Selected\Element <> EventElementItem
                        \This()\Item\Selected\Element = EventElementItem
                        PostEventElement(#_Event_Change, Element, EventElementItem)
                      EndIf
                    EndIf
                EndSelect
                
                
              Case #_Type_ListView, #_Type_Panel;, #_Type_Properties
                Select Event
                  Case #_Event_LeftButtonDown
                    SetElementState(EventElement, EventElementItem)
                    
                EndSelect  
            EndSelect
            
          EndIf
        EndIf
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure ElementCallBack(Event.q, EventElement)
  Protected Drawing.b
  Protected Result.q
  
  Static ElementLeaveItemIndex =- 1
  Protected ElementEnterItemIndex =- 1, ElementEnterColumnIndex =- 1
  
  Static GrabDrawingImage
  Static Cursor = #PB_Cursor_Default
  Protected *CurrentElement = ElementID(EventElement)
  
  If *CurrentElement
    With *CreateElement
      ChangeCurrentElement(\This(), *CurrentElement)
      
      If \This()\Hide = 0 And \This()\Disable = 0 And \This()\Interact
        If ListSize(\This()\Items()) And \Buttons = 0
          Select \This()\Type ; Чтобы лишний раз не перебирать итемы 
            Case #_Type_Window, 
                 #_Type_ComboBox,
                 #_Type_Menu,
                 #_Type_PopupMenu,
                 #_Type_ScrollBar,
                 #_Type_Spin,
                 #_Type_Panel,
                 #_Type_Toolbar, #_Type_Properties, #_Type_ListView, #_Type_ListIcon
              
              ElementEnterItemIndex = (ItemFromElementPoint(\This()))
              ElementEnterColumnIndex = ColumnFromElementPoint(\This())
              
              ; toolbar
              Select Event
                Case #_Event_LeftButtonDown
                  If \This()\Type = #_Type_Toolbar
                    \This()\Item\Active = ElementEnterItemIndex
                  EndIf
              EndSelect
              
            Default
              Select EventElement 
                Case \ActiveElement, \FocusElement
                  ElementEnterItemIndex = ItemFromElementPoint(\This())
                  ElementEnterColumnIndex = ColumnFromElementPoint(\This())
                  
              EndSelect
          EndSelect
          
          ; 
          If (ElementLeaveItemIndex<>ElementEnterItemIndex)
            If IsElementItem(ElementLeaveItemIndex) 
              ElementItemCallBack(*CurrentElement, #_Event_MouseLeave, EventElement, ElementLeaveItemIndex)
            EndIf
            
            If IsElementItem(ElementEnterItemIndex) 
              ElementItemCallBack(*CurrentElement, #_Event_MouseEnter, EventElement, ElementEnterItemIndex) 
            EndIf
            
            Select \This()\Type 
              Case #_Type_Toolbar
                If \Buttons 
                  If \This()\Item\Active = ElementEnterItemIndex
                    \This()\Item\Entered\Element = ElementEnterItemIndex
                  Else
                    \This()\Item\Entered\Element =- 1
                  EndIf
                EndIf
                
                Drawing = #True
              Default
                Drawing = #True
            EndSelect
            
            ElementLeaveItemIndex = ElementEnterItemIndex
          EndIf
        EndIf
        
        Select Event ; Send element item callBack()
          Case #_Event_MouseWheel
            ;Debug "MouseWheel"
            
            If \This()\Type = #_Type_ScrollBar 
              \This()\Scroll\Pos - 5 * \Bind\WheelDelta
              SetElementState(\This()\Element, \This()\Scroll\Pos+\This()\Scroll\ScrollStep)
            ElseIf IsElement(\This()\Scroll\Vert)
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(\This()\Scroll\Vert))
              \This()\Scroll\Pos - 5 * \Bind\WheelDelta
              SetElementState(\This()\Element, \This()\Scroll\Pos+\This()\Scroll\ScrollStep)
              PopListPosition(\This())
            EndIf
            
          Case #_Event_LeftButtonDown, #_Event_RightButtonDown, #_Event_MiddleButtonDown 
            If \Popup 
              ElementItemCallBack(*CurrentElement, #_Event_LostFocus, \PopupElement, ElementEnterItemIndex) 
            EndIf
            If ElementEnterItemIndex > =  0 : ElementItemCallBack(*CurrentElement, Event, EventElement, ElementEnterItemIndex) : EndIf 
            
            
          Case #_Event_LeftClick, #_Event_RightClick, #_Event_MiddleClick
            If ElementEnterItemIndex > =  0 : ElementItemCallBack(*CurrentElement, Event, EventElement, ElementEnterItemIndex) : EndIf 
            
            ;If \This()\Type <> ElementType(\FocusElement)
            If \Popup And IsElement(\Linked\Element)
              Debug "Up LostFocus"+\Linked\Element
              ElementItemCallBack(*CurrentElement, #_Event_LostFocus, \Linked\Element, -1) 
            EndIf
            ;EndIf 
            
          Case #_Event_LeftButtonUp, #_Event_RightButtonUp, #_Event_MiddleButtonUp 
            If ElementLeaveItemIndex > =  0 : ElementItemCallBack(*CurrentElement, Event, EventElement, ElementLeaveItemIndex) : EndIf 
            
          Default
            If ElementLeaveItemIndex > =  0 : ElementItemCallBack(*CurrentElement, Event, EventElement, ElementLeaveItemIndex) : EndIf
            
        EndSelect
        
        ; Then leave mouse from element set entered item =- 1
        Select Event 
          Case #_Event_MouseLeave
            Select \This()\Type
              Case #_Type_Menu
                If \This()\Item\Selected\Element =- 1
                  \This()\Item\Entered\Element =- 1
                EndIf
                
              Case #_Type_PopupMenu ; Сбрасываем виделение 
                If ElementEnterItemIndex =- 1 And \This()\Item\Type <> #_Type_ComboBox
                  \This()\Item\Entered\Element =- 1
                EndIf
                
              Case #_Type_Toolbar, #_Type_Panel, #_Type_Window, #_Type_ListView, #_Type_ListIcon
                \This()\Item\Entered\Element =- 1
            EndSelect
        EndSelect
        
        ;
        If ((Event.q & #_Event_Focus) = #_Event_Focus) 
          \This()\State | #_State_Focused
        EndIf
        If ((Event.q & #_Event_LostFocus) = #_Event_LostFocus) 
          \This()\State &~ #_State_Focused
        EndIf
        If ((Event.q & #_Event_MouseEnter) = #_Event_MouseEnter) 
          \This()\Entered\Element = EventElement
          
          \This()\State &~ #_State_Default
          \This()\State | #_State_Entered
        EndIf
        If ((Event.q & #_Event_LeftButtonDown) = #_Event_LeftButtonDown) 
          \DeltaX = (\MouseX - \This()\ContainerCoordinate\X)
          \DeltaY = (\MouseY - \This()\ContainerCoordinate\Y)
          
          \This()\Selected\Element = EventElement
          
          \This()\State &~ #_State_Entered
          \This()\State | #_State_Selected
        EndIf
        If ((Event.q & #_Event_LeftButtonUp) = #_Event_LeftButtonUp) 
          \This()\Selected\Element =- 1
          
          \This()\State &~ #_State_Selected
          \This()\State | #_State_Entered
        EndIf
        If ((Event.q & #_Event_MouseLeave) = #_Event_MouseLeave) 
          \This()\Entered\Element =- 1
          
          \This()\State &~ #_State_Selected
          \This()\State &~ #_State_Entered
          \This()\State | #_State_Default
        EndIf
        If ((Event.q & #_Event_MouseMove) = 0)
          Drawing = #True 
        EndIf
        
        ; ToolTip()
        If \Buttons
          \ToolTip\X = \MouseX+8
          \ToolTip\Y = \MouseY+16
          If ((Event.q & #_Event_Move) = #_Event_Move) 
            \ToolTip\String$ = "x,y = ("+Str(\This()\ContainerCoordinate\X)+":"+Str(\This()\ContainerCoordinate\Y)+")"
          ElseIf ((Event.q & #_Event_Size) = #_Event_Size)
            \ToolTip\String$ = "W,H = ("+Str(\This()\FrameCoordinate\Width)+":"+Str(\This()\FrameCoordinate\Height)+")"
          EndIf
        Else
          If ((Event.q & #_Event_MouseEnter) = #_Event_MouseEnter)
            If ListSize(\This()\Items()) = 0
              \ToolTip\X = \MouseX+8
              \ToolTip\Y = \MouseY+16
              \ToolTip\String$ = \This()\ToolTip\String$ 
            EndIf
          ElseIf ((Event.q & #_Event_MouseLeave) = #_Event_MouseLeave)
            \ToolTip\String$ = ""
          EndIf 
        EndIf
        
        
        
        ;{ - Чтобы можно было перемещать 
        ; и изменять размеры элемента
        Protected Element, X, Y, Width, Height
        Static CheckedElement =- 1, SideDirection.b
        
        Select Event
          Case #_Event_LeftButtonDown 
            ;If \DragElementType = 0 And 
            SideDirection = SideDirection()
            
            If SideDirection 
              If SideDirection = 9
                If (\This()\CaptionHeight And (\This()\Type = #_Type_Window))
                  If (ElementLeaveItemIndex = 0) ; Or \This()\EditingMode
                    CheckedElement = EventElement 
                  EndIf
                Else
                  CheckedElement = EventElement 
                EndIf  
              Else
                CheckedElement = EventElement 
              EndIf
            EndIf
            
            If \This()\EditingMode 
              If \MultiSelect
                PushListPosition(\This())
                ForEach \This()
                  If \This()\EditingMode
                    If ((\This()\Flag & #_Flag_Anchors)=#_Flag_Anchors)
                      \This()\DeltaX = (\MouseX - \This()\ContainerCoordinate\X)
                      \This()\DeltaY = (\MouseY - \This()\ContainerCoordinate\Y)
                      
                    ElseIf \This()\Element = EventElement
                      \MultiSelect = #False
                      \CheckedElement = EventElement
                      SetAnchors(\CheckedElement) 
                    EndIf
                  EndIf
                Next
                PopListPosition(\This())
              Else
                \CheckedElement = EventElement 
                SetAnchors(\CheckedElement) 
              EndIf
            EndIf
            ;EndIf     
            
          Case #_Event_MouseMove : SideDirection() 
            If IsElement(CheckedElement)
              If \MainWindow = EventElement
                If IsWindow(EventWindow()) 
                  Select SideDirection 
                      ;                       Case 1 : ResizeWindow(EventWindow(), Steps(((DesktopMouseX()-\DeltaX)),Steps), #PB_Ignore, Steps(((\This()\FrameCoordinate\X-(DesktopMouseX()-\DeltaX))+\This()\FrameCoordinate\Width)+(Steps-1),Steps), #PB_Ignore)
                      ;                       Case 2 : ResizeWindow(EventWindow(), #PB_Ignore, Steps(((DesktopMouseY()-\DeltaY)),Steps), #PB_Ignore, Steps(((\This()\FrameCoordinate\Y-(DesktopMouseY()-\DeltaY))+\This()\FrameCoordinate\Height)+(Steps-1),Steps))
                      ;                       Case 3 : ResizeWindow(EventWindow(), #PB_Ignore, #PB_Ignore, Steps(((DesktopMouseX()-\DeltaX)-\This()\FrameCoordinate\X),Steps)+Steps, #PB_Ignore)
                      ;                       Case 4 : ResizeWindow(EventWindow(), #PB_Ignore, #PB_Ignore, #PB_Ignore, Steps(((DesktopMouseY()-\DeltaY)-\This()\FrameCoordinate\Y),Steps)+Steps)
                      ;                         
                      ;                       Case 5 : ResizeWindow(EventWindow(), Steps(((DesktopMouseX()-\DeltaX)),Steps), Steps(((DesktopMouseY()-\DeltaY)),Steps),
                      ;                                              Steps(((\This()\FrameCoordinate\X-(DesktopMouseX()-\DeltaX))+\This()\FrameCoordinate\Width)+(Steps-1),Steps), 
                      ;                                              Steps(((\This()\FrameCoordinate\Y-(DesktopMouseY()-\DeltaY))+\This()\FrameCoordinate\Height)+(Steps-1),Steps))
                      ;                         
                      ;                       Case 6 : ResizeWindow(EventWindow(), #PB_Ignore, Steps(((DesktopMouseY()-\DeltaY)),Steps),
                      ;                                              Steps(((DesktopMouseX()-\DeltaX)-\This()\FrameCoordinate\X),Steps)+Steps, 
                      ;                                              Steps(((\This()\FrameCoordinate\Y-(DesktopMouseY()-\DeltaY))+\This()\FrameCoordinate\Height)+(Steps-1),Steps))
                      ;                         
                      ;                       Case 7 : ResizeWindow(EventWindow(), #PB_Ignore, #PB_Ignore,
                      ;                                              Steps(((DesktopMouseX()-\DeltaX)-\This()\FrameCoordinate\X),Steps)+Steps, 
                      ;                                              Steps(((DesktopMouseY()-\DeltaY)-\This()\FrameCoordinate\Y),Steps)+Steps)
                      ;                         
                      ;                       Case 8 : ResizeWindow(EventWindow(), Steps(((DesktopMouseX()-\DeltaX)),Steps), #PB_Ignore,
                      ;                                              Steps(((\This()\FrameCoordinate\X-(DesktopMouseX()-\DeltaX))+\This()\FrameCoordinate\Width)+(Steps-1),Steps), 
                      ;                                              Steps(((DesktopMouseY()-\DeltaY)-\This()\FrameCoordinate\Y),Steps)+Steps)
                      ;                  
                    Case 9 : SetCursorElement(#PB_Cursor_Arrows) 
                      ResizeWindow(EventWindow(), (DesktopMouseX()-\DeltaX), (DesktopMouseY()-\DeltaY), #PB_Ignore, #PB_Ignore)
                      
                  EndSelect
                EndIf
              Else
                Drawing = ResizesElements(SideDirection, CheckedElement)
              EndIf
            EndIf
            
          Case #_Event_LeftButtonUp 
            If IsElement(CheckedElement)
              If SideDirection() = 0 
                SetCursorElement(#PB_Cursor_Default)
              EndIf
              CheckedElement =- 1
            EndIf
            
          Case #_Event_MouseLeave
            SetCursorElement(#PB_Cursor_Default)
            
          Case #_Event_KeyDown
            If IsElement(\CheckedElement) ; 
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(\CheckedElement))
              Element = \This()\Element
              X = \This()\ContainerCoordinate\X
              Y = \This()\ContainerCoordinate\Y
              Width = \This()\FrameCoordinate\Width
              Height = \This()\FrameCoordinate\Height
              PopListPosition(\This())
              
              Select ElementEventKey()
                Case #PB_Shortcut_Left ; 37 ; Влево
                  Select ElementEventModifiersKey()
                    Case #PB_Canvas_Shift : ResizeElement( \CheckedElement, #PB_Ignore, #PB_Ignore, (Width-Steps), #PB_Ignore)
                    Case #PB_Canvas_Control : ResizeElement( \CheckedElement, (X-Steps), #PB_Ignore, #PB_Ignore, #PB_Ignore)
                    Default
                      Element = GetElementPosition(\CheckedElement, #_Element_PositionPrev)
                      
                      If Element =- 1
                        Element = GetElementPosition(GetElementPosition(\CheckedElement, #_Element_PositionLast), #_Element_PositionNext)
                        If Element =- 1
                          Element = GetElementPosition(\CheckedElement, #_Element_PositionLast)
                        EndIf
                      EndIf
                      
                      \CheckedElement = Element
                      
                      SetAnchors(\CheckedElement)
                  EndSelect
                  
                Case #PB_Shortcut_Right ; 39 ; Вправо
                  Select ElementEventModifiersKey()
                    Case #PB_Canvas_Shift : ResizeElement( \CheckedElement, #PB_Ignore, #PB_Ignore, (Width+Steps), #PB_Ignore)
                    Case #PB_Canvas_Control : ResizeElement( \CheckedElement, (X+Steps), #PB_Ignore, #PB_Ignore, #PB_Ignore)
                      
                    Default
                      Element = GetElementPosition(\CheckedElement, #_Element_PositionNext)
                      
                      If Element =- 1 
                        Element = GetElementPosition(\CheckedElement, #_Element_PositionFirst) 
                      EndIf
                      
                      \CheckedElement = Element
                      
                      SetAnchors(\CheckedElement)
                  EndSelect
                  
                Case #PB_Shortcut_Up ; 38 ; Верх
                  Select ElementEventModifiersKey()
                    Case #PB_Canvas_Shift : ResizeElement( \CheckedElement, #PB_Ignore, #PB_Ignore, #PB_Ignore, (Height-Steps))
                    Case #PB_Canvas_Control : ResizeElement( \CheckedElement, #PB_Ignore, (Y-Steps), #PB_Ignore, #PB_Ignore)
                      
                    Default
                      Element = GetElementPosition(\CheckedElement, #_Element_PositionPrev)
                      
                      If Element =- 1
                        Element = GetElementPosition(GetElementPosition(\CheckedElement, #_Element_PositionLast), #_Element_PositionNext)
                        If Element =- 1
                          Element = GetElementPosition(\CheckedElement, #_Element_PositionLast)
                        EndIf
                      EndIf
                      
                      \CheckedElement = Element
                      
                      SetAnchors(\CheckedElement)
                  EndSelect
                  
                Case #PB_Shortcut_Down ; 40 ; Вниз
                  Select ElementEventModifiersKey()
                    Case #PB_Canvas_Shift : ResizeElement( \CheckedElement, #PB_Ignore, #PB_Ignore, #PB_Ignore, (Height+Steps))
                    Case #PB_Canvas_Control : ResizeElement( \CheckedElement, #PB_Ignore, (Y+Steps), #PB_Ignore, #PB_Ignore)
                      
                    Default
                      Element = GetElementPosition(\CheckedElement, #_Element_PositionNext)
                      
                      If Element =- 1 
                        Element = GetElementPosition(\CheckedElement, #_Element_PositionFirst) 
                      EndIf
                      
                      \CheckedElement = Element
                      
                      SetAnchors(\CheckedElement)
                  EndSelect
                  
              EndSelect
            EndIf
            
        EndSelect
        ;}
        
        Select Event.q ; TODO Это для сплиттера
          Case #_Event_MouseMove,
               #_Event_MouseEnter, #_Event_MouseLeave,
               #_Event_LeftButtonDown, #_Event_LeftButtonUp
            
            ; Это для сплиттера
            Protected SplitterDraw = SplitterElementCallBack(Event)
            If SplitterDraw
              Drawing = SplitterDraw
            EndIf
        EndSelect
        
        
        
        
        ; ; ;         ; Это чтобы в контейнерах работало правильно
        ; ; ;         If ((Event.q & #_Event_MouseEnter) = #_Event_MouseEnter) 
        ; ; ;           If \Element = EventElement
        ; ; ;             Event.q = #_Event_MouseEnter
        ; ; ;           Else
        ; ; ;             Event.q = #_Event_MouseMove
        ; ; ;           EndIf
        ; ; ;         EndIf
        ; ; ;         If ((Event.q & #_Event_MouseLeave) = #_Event_MouseLeave) 
        ; ; ;           If IsChildElement(\Element, EventElement)
        ; ; ;             Event.q = #_Event_MouseMove
        ; ; ;           Else
        ; ; ;             Event.q = #_Event_MouseLeave
        ; ; ;             \Element =- 1
        ; ; ;           EndIf
        ; ; ;         EndIf
        ; ; ;         
        ; ; ;         If ((Event.q & #_Event_Move) = #_Event_Move) 
        ; ; ;           If \This()\BeginMove <> 1 : \This()\BeginMove = 1
        ; ; ;             PostEventElement(#_Event_MoveBegin, EventElement)
        ; ; ;             ;Debug "MoveBeginElement "+EventElement
        ; ; ;           EndIf
        ; ; ;           ;Debug "MoveElement "+EventElement
        ; ; ;         EndIf
        ; ; ;         
        If (IsWindowElement(EventElement) Or IsGadgetElement(EventElement))
          If \This()\Linked\Parent ; ScrollArea
                                   ;PostEventElement(Event, \This()\Linked\Parent, \This()\Item\Entered\Element)
          Else
            PostEventElement(Event, EventElement, \This()\Item\Entered\Element)
          EndIf
        EndIf
        ; ; ;         
        ; ; ;         If ((Event.q & #_Event_Move) = #_Event_Move) 
        ; ; ;         ElseIf ((Event.q & #_Event_KeyDown) = #_Event_KeyDown) 
        ; ; ;         ElseIf ((Event.q & #_Event_MouseEnter) = #_Event_MouseEnter) 
        ; ; ;         ElseIf ((Event.q & #_Event_MouseLeave) = #_Event_MouseLeave) 
        ; ; ;         ElseIf ((Event.q & #_Event_MouseMove) = #_Event_MouseMove) And \Buttons 
        ; ; ;         Else
        ; ; ;           If \This()\BeginMove <> 0 : \This()\BeginMove = 0
        ; ; ;             PostEventElement(#_Event_MoveBegin, EventElement)
        ; ; ;             ;Debug "MoveEndElement "+EventElement
        ; ; ;           EndIf  
        ; ; ;         EndIf
      EndIf
      
      ; Set foreground window element
      If ((Event.q & #_Event_LeftButtonDown) = #_Event_LeftButtonDown) Or
         ((Event.q & #_Event_MiddleButtonDown) = #_Event_MiddleButtonDown) Or
         ((Event.q & #_Event_RightButtonDown) = #_Event_RightButtonDown) 
        
        SetForegroundWindowElement(EventElement)
        Drawing = #True
      EndIf
      
      ; Set 
      If StringEditableCallBack(\This(), Event, EventElement)
        Drawing = #True
      EndIf
      
      ;
      If ElementsDefaultCallBack(\This(), Event, EventElement)
        Drawing = #True
      EndIf
      
      
      ;       If ((Event & #_Event_KeyUp) = #_Event_KeyUp)
      ;         \Bind\ModifiersKey = 0
      ;       EndIf
      
      If Drawing
        ElementDrawCallBack(EventElement)
      EndIf
      
    EndWith
  EndIf
  
  ProcedureReturn Result.q
EndProcedure

Procedure RedrawWindowElement(Element)
  ElementDrawCallBack(Element, #_Event_Repaint)
EndProcedure

;-
Procedure GetWindowBackgroundColor(hwnd = 0) ;hwnd only used in Linux, ignored in Win/Mac
  Protected Color
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows 
      Color = GetSysColor_(#COLOR_WINDOW)
      Select Color
        Case 0,$FFFFFF 
          Color = GetSysColor_(#COLOR_BTNFACE)
      EndSelect
      ProcedureReturn Color
      
    CompilerCase #PB_OS_Linux   ;thanks to uwekel http://www.purebasic.fr/english/viewtopic.php?p = 405822
      Protected *style.GtkStyle, *color.GdkColor
      ;       *style = gtk_widget_style_(hwnd);gdk_get_default_root_window_()) ;GadgetID(Gadget))
      ;       *color = *style\bg[0]           ;0 = #GtkStateNormal
      ;       Color = RGB(*color\red >> 8, *color\green >> 8, *color\blue >> 8)
      ProcedureReturn Color
      
    CompilerCase #PB_OS_MacOS   ;thanks to wilbert http://purebasic.fr/english/viewtopic.php?f = 19&t = 55719&p = 497009
      Protected.i Rect.NSRect, Image, NSColor = CocoaMessage(#Null, #Null, "NSColor windowBackgroundColor")
      If NSColor
        Rect\size\width = 1
        Rect\size\height = 1
        Image = CreateImage(#PB_Any, 1, 1)
        StartDrawing(ImageOutput(Image))
        CocoaMessage(#Null, NSColor, "drawSwatchInRect:@", @Rect)
        Color = Point(0, 0)
        StopDrawing()
        FreeImage(Image)
        ProcedureReturn Color
      Else
        ProcedureReturn -1
      EndIf
  CompilerEndSelect
EndProcedure  

Procedure CanvasDesktopCallback()
  Protected MouseX 
  Protected MouseY
  Protected Flag.q = #_Element_FrameCoordinate
  Protected Parent=-1, X,Y,Width,Height
  
  Static Event.q =- 1
  Static Buttons
  Static LeaveElement =- 1
  Static ClickElement =- 1
  Protected EnterElement =- 1
  
  With *CreateElement
    If LastElement(\This()) 
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux
          MouseX = WindowMouseX(EventWindow()) - 1
          MouseY = WindowMouseY(EventWindow()) - 2
        CompilerDefault
          MouseX = WindowMouseX(EventWindow())
          MouseY = WindowMouseY(EventWindow())
      CompilerEndSelect
      
      If MouseX =- 1 : MouseX = DesktopMouseX()-WindowX(EventWindow()) : EndIf
      If MouseY =- 1 : MouseY = DesktopMouseY()-WindowY(EventWindow()) : EndIf
      
      ;       MouseX = GetGadgetAttribute(\Canvas, #PB_Canvas_MouseX)
      ;       MouseY = GetGadgetAttribute(\Canvas, #PB_Canvas_MouseY)
      
      ;       MouseX = DesktopMouseX()
      ;       MouseY = DesktopMouseY()
      
      If \MouseX = 0 : \MouseX = MouseX : EndIf : If MouseX <> \MouseX : \MouseX = MouseX : Event.q = #_Event_MouseMove : EndIf
      If \MouseY = 0 : \MouseY = MouseY : EndIf : If MouseY <> \MouseY : \MouseY = MouseY : Event.q = #_Event_MouseMove : EndIf
      
      Select EventType()
          Case #PB_EventType_Focus             : If Event =- 1 : Event = #_Event_Focus : EndIf
        Case #PB_EventType_MouseWheel        : Event = #_Event_MouseWheel
          \Bind\WheelDelta = GetGadgetAttribute(\Canvas, #PB_Canvas_WheelDelta)
        Case #PB_EventType_LeftDoubleClick   : Event = #_Event_LeftDoubleClick 
        Case #PB_EventType_LeftButtonDown    : Event = #_Event_LeftButtonDown
        Case #PB_EventType_LeftButtonUp      : Event = #_Event_LeftButtonUp
        Case #PB_EventType_LeftClick         : Event = #_Event_LeftClick 
        Case #PB_EventType_RightDoubleClick  : Event = #_Event_RightDoubleClick
        Case #PB_EventType_RightButtonDown   : Event = #_Event_RightButtonDown 
        Case #PB_EventType_RightButtonUp     : Event = #_Event_RightButtonUp
        Case #PB_EventType_RightClick        : Event = #_Event_RightClick 
        Case #PB_EventType_MiddleButtonDown  : Event = #_Event_MiddleButtonDown
        Case #PB_EventType_MiddleButtonUp    : Event = #_Event_MiddleButtonUp
        Case #PB_EventType_KeyDown           : Event = #_Event_KeyDown 
          \Bind\ModifiersKey = GetGadgetAttribute(\Canvas, #PB_Canvas_Modifiers) 
          \Bind\Key = GetGadgetAttribute(\Canvas, #PB_Canvas_Key)
          
        Case #PB_EventType_KeyUp             : Event = #_Event_KeyUp  
          \Bind\ModifiersKey = GetGadgetAttribute(\Canvas, #PB_Canvas_Modifiers) 
          \Bind\Key = GetGadgetAttribute(\Canvas, #PB_Canvas_Key)
          
        Case #PB_EventType_Input             : Event = #_Event_Input 
          ;\Bind\Key = GetGadgetAttribute(\Canvas, #PB_Canvas_Key)
          \Bind\Chr = GetGadgetAttribute(\Canvas, #PB_Canvas_Input)
        Case #PB_EventType_MouseMove 
          If Event <> #_Event_MouseMove
            ProcedureReturn #False 
          EndIf
      EndSelect
      
      If Event > =  0
        If Buttons = 0 
          PushListPosition(\This()) ; EnterElement = EnterElement(#_Element_ClipCoordinate)
          LastElement(\This())      ; Что бы начать с последнего элемента
          Repeat                    ; Перебираем с низу верх
            If \This()\Width  = < 0 And 0 > =  \This()\Height : Continue : EndIf
            Select Flag 
              Case #_Element_ClipCoordinate 
                X = (\This()\X)
                Y = (\This()\Y)
                Width = (X+(\This()\Width))
                Height = (Y+(\This()\Height))
                
              Case #_Element_FrameCoordinate 
                If ((\This()\Flag&#_Flag_Anchors) = #_Flag_Anchors)
                  X = (\This()\FrameCoordinate\X)
                  Y = (\This()\FrameCoordinate\Y)
                  Width = (X+(\This()\FrameCoordinate\Width))
                  Height = (Y+(\This()\FrameCoordinate\Height))
                Else
                  X = (\This()\X)
                  Y = (\This()\Y)
                  Width = (X+(\This()\Width))
                  Height = (Y+(\This()\Height))
                EndIf
                
            EndSelect
            
            If (\This()\Hide = #False And (\MouseX > =  X And \MouseX < Width And \MouseY > =  Y And \MouseY < Height))
              If (\This()\Item\Parent Or \This()\Linked\Parent) And \This()\Type = #_Type_Container
                Continue
              EndIf
              
              Parent = \This()\Parent\Element
              EnterElement = \This()\Element
              \This()\MouseX = \MouseX-(\This()\FrameCoordinate\X)
              \This()\MouseY = \MouseY-(\This()\FrameCoordinate\Y)
              \Element = EnterElement
              
              ; Для фраме элемент 
              If ((\This()\Flag&#_Flag_Transparent) = #_Flag_Transparent)
                PushListPosition(\This()) 
                While PreviousElement(\This())
                  If Parent = \This()\Element
                    Break
                  EndIf
                  
                  Select Flag 
                    Case #_Element_ClipCoordinate 
                      X = (\This()\X)
                      Y = (\This()\Y)
                      Width = (X+(\This()\Width))
                      Height = (Y+(\This()\Height))
                      
                    Case #_Element_FrameCoordinate 
                      If ((\This()\Flag&#_Flag_Anchors) = #_Flag_Anchors)
                        X = (\This()\FrameCoordinate\X)
                        Y = (\This()\FrameCoordinate\Y)
                        Width = (X+(\This()\FrameCoordinate\Width))
                        Height = (Y+(\This()\FrameCoordinate\Height))
                      Else
                        X = (\This()\X)
                        Y = (\This()\Y)
                        Width = (X+(\This()\Width))
                        Height = (Y+(\This()\Height))
                      EndIf
                      
                  EndSelect
                  
                  If (\This()\Hide = #False And (\MouseX > =  X And \MouseX < Width And \MouseY > =  Y And \MouseY < Height))
                    EnterElement = \This()\Element
                    \This()\MouseX = \MouseX-(\This()\FrameCoordinate\X)
                    \This()\MouseY = \MouseY-(\This()\FrameCoordinate\Y)
                    \Element = EnterElement
                    Break
                  EndIf
                Wend
                PopListPosition(\This()) 
              EndIf
              
              Break
            EndIf
            
          Until PreviousElement(\This()) = #False 
          PopListPosition(\This())
          
          If LeaveElement <> EnterElement
            If LeaveElement > =  0 : ElementCallBack(#_Event_MouseLeave, LeaveElement) : EndIf
            If EnterElement > =  0 : ElementCallBack(#_Event_MouseEnter, EnterElement) : EndIf
            LeaveElement = EnterElement 
          EndIf
        EndIf
        
        Select Event
          Case #_Event_Focus
            SetActiveElement(\ForegroundWindow)
            
          Case #_Event_MouseMove
            If \Buttons <> Buttons : \Buttons = Buttons : EndIf
            
            If \Buttons 
              If LeaveElement > =  0 : ElementCallBack( Event, LeaveElement) : EndIf
            Else
              If EnterElement > =  0 : ElementCallBack( Event, EnterElement) : EndIf
            EndIf
            
          Case #_Event_LeftClick, #_Event_RightClick, #_Event_MiddleClick
            If EnterElement >= 0 And ClickElement = EnterElement
              ElementCallBack( Event, EnterElement)
            EndIf
            
          Case #_Event_LeftButtonUp, #_Event_RightButtonUp, #_Event_MiddleButtonUp  : \Buttons = #False : Buttons = #False
            If LeaveElement > =  0 : ElementCallBack( Event, LeaveElement) : EndIf 
            
          Case #_Event_LeftButtonDown,
               #_Event_RightButtonDown,
               #_Event_MiddleButtonDown : Buttons = Event
            
            ClickElement = EnterElement
            SetActiveElement(EnterElement)
            ;SetForegroundWindowElement(EnterElement)
            
            If EnterElement > =  0 : ElementCallBack(Event, EnterElement) : EndIf
            
          Default
            If \ActiveElement > =  0 : ElementCallBack(Event, \ActiveElement) : EndIf
            
        EndSelect
        
      EndIf
      
      
    EndIf
    
    Static Focus
    If EventType() = #PB_EventType_Focus And Focus = #False : Focus = #True
      Debug "Create All"
      
      If IsGadget(\Canvas)
        PostEventElement(#_Event_CreateApp, 0, #PB_Default)
        ElementDrawCallBack(0,#True);, #_Event_CreateApp)
        
        If ((\Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
          HideWindow(\CanvasWindow, #False, #PB_Window_ScreenCentered)
        ElseIf ((\Flag & #_Flag_WindowCentered) = #_Flag_WindowCentered)
          HideWindow(\CanvasWindow, #False, #PB_Window_WindowCentered)
        Else
          HideWindow(\CanvasWindow, #False)
        EndIf
        
      EndIf
    EndIf
  EndWith
  
EndProcedure

Procedure CanvasDesktopEvents()  
  Protected Window = EventWindow()
  Protected Gadget =- 1, Width, Height
  Static Element =- 1
  
  If IsWindow(Window)
    Width = WindowWidth(Window)
    Height = WindowHeight(Window)
    Gadget = GetWindowData(Window)
  EndIf
  
  With *CreateElement
    Select Event()
      Case #PB_Event_ActivateWindow
        PostEvent(#PB_Event_Gadget, Window, Gadget, #PB_EventType_Focus) 
        
      Case #PB_Event_SizeWindow ;: Debug "PB_Event_SizeWindow"
        ResizeGadget(Gadget, #PB_Ignore,#PB_Ignore, Width,Height)
        
      Case #PB_Event_MinimizeWindow : Debug "#PB_Event_MinimizeWindow"
        ResizeElement(0, #PB_Ignore,#PB_Ignore, Width,Height)
        
      Case #PB_Event_MaximizeWindow : Debug "#PB_Event_MaximizeWindow"
        If IsElement(Element)
          SetWindowElementState(Element, #_Event_Maximize)
          Element =- 1 
        Else
          Element = GetElementData(0)
        EndIf
        ResizeElement(0, #PB_Ignore,#PB_Ignore, Width,Height)
        
      Case #PB_Event_RestoreWindow : Debug "#PB_Event_RestoreWindow"
        SetWindowElementState(GetElementData(0), #_Event_Restore)
        ResizeElement(0, #PB_Ignore,#PB_Ignore, Width,Height)
        
      Case #PB_Event_Timer
        If ElementID(\Element)
          ChangeCurrentElement(\This(), ElementID(\Element))
;           If ListSize(\This()\Items())
;             If \Event = #_Event_LeftButtonDown
;               ;Debug \Element ; EventElement()
;               ScrollBarElementCallBack(#_Event_LeftButtonDown, \This()\Element, \This()\Item\Entered\Element)
;             EndIf
;           EndIf
        EndIf
    EndSelect
  EndWith
  
EndProcedure

Procedure CanvasDesktop(Element,X,Y,Width,Height, Title.S = "", Flag.q = #_Flag_ScreenCentered, Parent = 0 )
  Protected Gadget
  
  With *CreateElement
    Protected Window = OpenWindow(#PB_Any, X,Y,Width,Height, "", #PB_Window_BorderLess | #PB_Window_Invisible)
    SmartWindowRefresh(Window, #True)
    BindEvent(#PB_Event_SizeWindow, @CanvasDesktopEvents(), Window)
    BindEvent(#PB_Event_ActivateWindow, @CanvasDesktopEvents(), Window)
    BindEvent(#PB_Event_MaximizeWindow, @CanvasDesktopEvents(), Window)
    BindEvent(#PB_Event_MinimizeWindow, @CanvasDesktopEvents(), Window)
    BindEvent(#PB_Event_RestoreWindow, @CanvasDesktopEvents(), Window)
    ;AddWindowTimer(Window, Window, 10) : BindEvent(#PB_Event_Timer, @CanvasDesktopEvents(), Window)
    
    If Window
      Protected GadgetID = CanvasGadget(#PB_Any,0,0,Width,Height,#PB_Canvas_Keyboard|#PB_Canvas_Container) 
      If IsGadget(GadgetID) : Gadget = GadgetID : EndIf
      
      ; Удаляем которые по умолчанию Фред поставил
      RemoveKeyboardShortcut(Window, #PB_Shortcut_All)
      SetWindowData(Window, Gadget)
      SetActiveGadget(Gadget)
      
      \Flag = Flag
      \Canvas = Gadget
      \CanvasWindow = Window
      
      \MenuHeight = 21
      \CaptionHeight = 27
      
      \Desktop =- 1
      \Parent =- 1
      \Window =- 1
      \MainWindow =- 1
      
      
      
      \Bind\Item =- 1
      \Bind\Event =- 1
      \Bind\Parent =- 1
      \Bind\Window =- 1
      \Bind\Element =- 1
      \Bind\Menu =- 1
      \Bind\Gadget =- 1
      \Bind\Desktop =- 1
      \Bind\ToolBar =- 1
      \Bind\PopupMenu =- 1
      \Bind\StatusBar =- 1
      
      \Sticky =- 1
      \StickyWindow =- 1
      \CheckedElement =- 1
      \FocusElement =- 1
      \ActiveElement =- 1
      
      \Item\Parent = 0 ; Это значить что нулевой итем
      \Item\Active =- 1
      \Item\Element =- 1
      \Linked\Element =- 1
      \Item\Entered\Element =- 1
      \Item\Selected\Element =- 1
      
      \BackColor = GetWindowBackgroundColor(WindowID(Window)) ; $FFEFFF
      
      If \BackImage = 0
        \BackImage = CreateImage(#PB_Any,Width,Height,24,\BackColor)
      EndIf
      
      ;       If StartDrawing()
      ;         StopDrawing()
      ;       EndIf
      
      
      If Title
        CreateElement(#_Type_Desktop, 0, 0,0,Width,Height,"",#PB_Default,#PB_Default,#PB_Default, #_Flag_BorderLess)
        
        If ((Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
          Flag &~ #_Flag_ScreenCentered
          Element = CreateElement(#_Type_Window, Element, 0,0,Width,Height,"", #PB_Default,#PB_Default,#PB_Default, Flag|#_Flag_SystemMenu);|#_Flag_AlignFull)
          Flag | #_Flag_ScreenCentered
        Else
          Element = CreateElement(#_Type_Window, Element, 0,0,Width,Height,"", #PB_Default,#PB_Default,#PB_Default, Flag|#_Flag_SystemMenu);|#_Flag_AlignFull)
        EndIf
        
        \MainWindow = Element
        SetElementText( Element, Title )
      Else
        Element = CreateElement(#_Type_Desktop, 0, 0,0,Width,Height,"",#PB_Default,#PB_Default,#PB_Default, #_Flag_BorderLess)
      EndIf
      
      ;BindGadgetEvent(Gadget, @CanvasDesktopCallback())
      ;ElementDrawCallBack(#_Event_CreateApp, Element)
      
      ;       If ((Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
      ;         HideWindow(Window, #False, #PB_Window_ScreenCentered)
      ;       ElseIf ((Flag & #_Flag_WindowCentered) = #_Flag_WindowCentered)
      ;         HideWindow(Window, #False, #PB_Window_WindowCentered)
      ;       Else
      ;         HideWindow(Window, #False)
      ;       EndIf
      
      If Element = 0
        Element = Gadget
      EndIf
      
      ; ; ;         SetWindowLongPtr_(WindowID(Window), #GWL_EXSTYLE, GetWindowLongPtr_(WindowID(Window), #GWL_EXSTYLE) | #WS_EX_LAYERED) 
      ; ; ;         SetLayeredWindowAttributes_(WindowID(Window), \BackColor, 0, #LWA_COLORKEY) 
      ; ; ;         ;SetLayeredWindowAttributes_(WindowID(Window), RGBA( Red(\BackColor), Green(\BackColor), Blue(\BackColor), 0), 0, #LWA_COLORKEY)
      
    EndIf
  EndWith
  
  
  ProcedureReturn Element
EndProcedure


;-
Procedure MinimizeElement(Element)
  Protected Result, *Element = ElementID(Element)
  Static Minimize, X,Y,Width,Height
  
  ProcedureReturn SetWindowElementState(Element, #_Event_Minimize)
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If Element
        If \This()\MinimizeState
          \This()\Minimize\X = \This()\ContainerCoordinate\X
          \This()\Minimize\Y = \This()\ContainerCoordinate\Y
          \This()\Minimize\Width = \This()\FrameCoordinate\Width
          \This()\Minimize\Height = \This()\FrameCoordinate\Height
          
          ResizeElement(Element,0,ElementHeight(\This()\Parent\Element)-28,240,28)
        Else
          ResizeElement(Element,\This()\Minimize\X,\This()\Minimize\Y,\This()\Minimize\Width,\This()\Minimize\Height)
        EndIf
      Else
        If \This()\MinimizeState
          SetWindowState(EventWindow(), #PB_Window_Minimize )
        Else
          SetWindowState(EventWindow(), #PB_Window_Normal )
        EndIf
      EndIf
      
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure MaximizeElement(Element)
  Protected Result, *Element = ElementID(Element)
  Static Maximize, X,Y,Width,Height
  
  ProcedureReturn SetWindowElementState(Element, #_Event_Maximize)
  With *CreateElement
    If *Element
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *Element)
      
      If Element 
        If \This()\MaximizeState
          \This()\Maximize\X = \This()\ContainerCoordinate\X
          \This()\Maximize\Y = \This()\ContainerCoordinate\Y
          \This()\Maximize\Width = \This()\FrameCoordinate\Width
          \This()\Maximize\Height = \This()\FrameCoordinate\Height
          
          If \MainWindow = Element
            ;             ExamineDesktops()
            SetWindowState(\CanvasWindow, #PB_Window_Maximize)
            ;             ResizeElement(Element,0,0,DesktopWidth(0),DesktopHeight(0))
            ResizeElement(Element,0,0,WindowWidth(\CanvasWindow),WindowHeight(\CanvasWindow))
          Else
            ResizeElement(Element,0,0,ElementWidth(\This()\Parent\Element),ElementHeight(\This()\Parent\Element))
          EndIf
        Else
          ResizeElement(Element,\This()\Maximize\X,\This()\Maximize\Y,\This()\Maximize\Width,\This()\Maximize\Height)
        EndIf
      Else
        If \This()\MaximizeState
          SetWindowState(EventWindow(), #PB_Window_Maximize )
        Else
          SetWindowState(EventWindow(), #PB_Window_Normal )
        EndIf
      EndIf
      
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure CloseWindowElement(Element = #PB_All)
  Protected Result
  
  If Element = #PB_All
    PostEvent(#PB_Event_CloseWindow);, EventWindow(), EventGadget())
  Else
    If IsWindowElement(Element)
      Result = FreeElement(Element)
    EndIf
  EndIf
  
  ProcedureReturn Result
EndProcedure


;-
Procedure WaitWindowEventCallBack(Event.q, EventElement)
  ; Это должна обрабатываться в конце 
  ; чтобы было возможность 
  ; отключить ее обработку
  
  Select Event
    Case #_Event_Maximize ;: MaximizeElement(EventElement)
    Case #_Event_Minimize ;: MinimizeElement(EventElement)
    Case #_Event_Close    : CloseWindowElement(EventElement)
    Case #_Event_Free     : Debug "Desktop element count: "+CountElement(0)
      If IsMainWindowElement(EventElement) Or CountElement(0) = 0
        CloseWindowElement()
      EndIf  
      
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure WaitWindowEventClose(Window = #PB_All)
  Protected Result
  
  ClipGadgets( UseGadgetList(0) )
  
  With *CreateElement
    ;     If IsGadget(\Canvas)
    ;       PostEventElement(#_Event_CreateApp, 0, #PB_Default)
    ;       ElementDrawCallBack(#_Event_CreateApp, 0)
    ;       
    ;       If ((\Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
    ;         HideWindow(\CanvasWindow, #False, #PB_Window_ScreenCentered)
    ;       ElseIf ((\Flag & #_Flag_WindowCentered) = #_Flag_WindowCentered)
    ;         HideWindow(\CanvasWindow, #False, #PB_Window_WindowCentered)
    ;       Else
    ;         HideWindow(\CanvasWindow, #False)
    ;       EndIf
    ;       
    ;     EndIf
    
    If ListSize(\This())
      If IsWindowElement(Window) : \MainWindow = Window : EndIf
      
      UnbindEventElement(@WaitWindowEventCallBack())
      BindEventElement(@WaitWindowEventCallBack())
      
      ;
      Protected Parent, Width, Height, MenuHeight
      PushListPosition(\This())
      ForEach \This()
        If \This()\Element ; And \MainWindow = \This()\Element 
          If IsPopupMenuElement(\This()\Element) : Break : EndIf
          
          ;           MenuHeight = (\This()\MenuHeight+\This()\ToolBarHeight+\This()\StatusBarHeight)
          ;           If MenuHeight
          ;             Height = (\This()\CaptionHeight + MenuHeight)
          ;           EndIf
          MenuHeight = (\This()\StatusBarHeight)
          If MenuHeight
            Height = (MenuHeight)
          EndIf
          
          If Height And \This()\Type = #_Type_Window
            Width = (\This()\FrameCoordinate\Width+\This()\bSize*2)
            
            If (Width>ElementWidth(0))
              ResizeElement(\This()\Parent\Element,#PB_Ignore,#PB_Ignore,Width,(Height+\This()\FrameCoordinate\Height+\This()\bSize*2), #PB_Ignore)
            EndIf
            
            ResizeElement(\This()\Element,#PB_Ignore,#PB_Ignore,Width,(Height+\This()\FrameCoordinate\Height+\This()\bSize*2), #PB_Ignore)
          EndIf
        EndIf
        
        ;         If ((\CreateMenuElement > \This()\Element) Or (\CreateToolBarElement > \This()\Element)) And
        ;            (IsGadgetElement(\This()\Element) And IsChildElement(\This()\Element, \This()\Window))
        ;           ResizeElement(\This()\Element,#PB_Ignore,(\This()\FrameCoordinate\Y+MenuElementHeight()+ToolBarElementHeight()),#PB_Ignore,#PB_Ignore, #PB_Ignore)
        ;         EndIf
        
        ; ; ;         ;CoordinateElement(\This(), @\This(), 0)
        ; ;         PushListPosition(\This()) 
        ; ;         ChangeCurrentElement(\This(), ElementID(0))
        ; ;         Debug \This()\Type ; \This()\Width ;ElementID(0);CoordinateElement(\This(), ElementID(0), 3)
        ; ;         
        ; ;         PopListPosition(\This()) 
        
      Next
      PopListPosition(\This())
      
      Repeat 
        Select WindowEvent() ; Wait
          Case #PB_Event_Gadget
            CanvasDesktopCallback()
            
          Case #PB_Event_CloseWindow
            Result = EventData()
            Break
        EndSelect
      ForEver
      
      If Not IsWindow(EventWindow())
        FreeList(\This())
        ClearStructure(*CreateElement, S_GLOBAL)
        FreeMemory(*CreateElement)
        *CreateElement = 0
      EndIf
      
    Else
      Repeat 
        Select WaitWindowEvent()
          Case #PB_Event_CloseWindow
            CloseWindow(EventWindow())
            If Not IsWindow(Window) Or Window = EventWindow()
              Break
            EndIf
        EndSelect
      ForEver
    EndIf
  EndWith
  
  
  ; ;   Define Message.MSG
  ; ;   While GetMessage_( Message, 0, 0, 0 )
  ; ;     Select Message
  ; ;         
  ; ;     EndSelect
  ; ;   Wend
  
  ProcedureReturn Result
EndProcedure


;-
Procedure StickyElement(Element, State)
  Protected Result
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This())
      ForEach \This()
        If IsChildElement(\This()\Element, Element)
          \This()\Sticky = #True
          ;         Else
          ;           \This()\Sticky = #False
        EndIf
      Next 
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure




;XIncludeFile "CFE_Menu_ToolBar(example).pb"



DataSection
  p:
  Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
  Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$02,$0D,$49,$44,$41
  Data.b $54,$38,$8D,$95,$91,$B1,$6B,$1A,$61,$18,$C6,$9F,$3B,$BE,$FB,$C0,$03,$6F,$38,$6F
  Data.b $38,$24,$14,$CD,$62,$14,$37,$C5,$21,$04,$11,$AC,$01,$43,$71,$0B,$84,$4E,$21,$43
  Data.b $C6,$CB,$2E,$08,$86,$24,$84,$E0,$94,$FF,$20,$90,$A4,$C3,$8D,$2E,$2E,$1D,$22,$17
  Data.b $30,$7A,$82,$06,$6C,$3A,$18,$AB,$74,$C8,$2D,$D5,$A1,$43,$D0,$0F,$73,$5F,$97,$1A
  Data.b $0A,$D5,$36,$FE,$B6,$F7,$E5,$79,$7E,$C3,$FB,$0A,$98,$43,$2E,$97,$D3,$44,$51,$7C
  Data.b $0F,$40,$01,$F0,$D3,$75,$DD,$CF,$E5,$72,$F9,$C7,$BC,$EC,$5C,$62,$B1,$D8,$8E,$65
  Data.b $59,$F6,$70,$38,$E4,$96,$65,$D9,$B1,$58,$6C,$E7,$CD,$65,$00,$50,$55,$75,$DF,$71
  Data.b $1C,$4E,$29,$CD,$3B,$8E,$C3,$55,$55,$DD,$5F,$4A,$00,$60,$CB,$34,$4D,$BB,$DF,$FF
  Data.b $C6,$4D,$D3,$B4,$01,$6C,$2D,$2B,$F8,$00,$C0,$78,$78,$F8,$C2,$01,$18,$BF,$E7,$B9
  Data.b $88,$0B,$F6,$91,$5E,$EF,$F1,$7C,$34,$1A,$A1,$D7,$7B,$3C,$07,$10,$59,$4A,$40,$08
  Data.b $79,$0A,$85,$D6,$0A,$00,$10,$0A,$AD,$15,$08,$21,$4F,$8B,$04,$24,$1A,$8D,$7E,$14
  Data.b $04,$E1,$DD,$6C,$C1,$39,$FF,$DE,$E9,$74,$AE,$08,$21,$79,$C6,$18,$00,$B8,$D3,$E9
  Data.b $F4,$6A,$41,$EE,$13,$61,$8C,$AD,$36,$1A,$8D,$A3,$66,$B3,$39,$08,$06,$83,$81,$6C
  Data.b $36,$5B,$00,$00,$D7,$75,$9F,$5F,$5E,$5C,$B8,$AE,$FB,$0C,$00,$8C,$B1,$D5,$4A,$A5
  Data.b $72,$D4,$EF,$F7,$07,$F1,$78,$3C,$90,$48,$24,$0A,$00,$20,$4E,$26,$13,$B1,$5A,$AD
  Data.b $0E,$74,$5D,$0F,$18,$C6,$C1,$C5,$78,$3C,$6E,$CF,$04,$80,$F8,$2A,$18,$8F,$C7,$6D
  Data.b $C3,$38,$B8,$D0,$75,$3D,$50,$AD,$56,$07,$93,$C9,$44,$04,$00,$91,$31,$26,$F9,$FD
  Data.b $2B,$81,$4C,$26,$73,$5C,$2C,$1E,$EE,$86,$C3,$91,$6D,$5D,$D7,$D7,$05,$41,$20,$A2
  Data.b $28,$41,$10,$04,$A2,$EB,$FA,$7A,$38,$1C,$D9,$2E,$16,$0F,$77,$33,$99,$CC,$B1,$DF
  Data.b $BF,$12,$60,$8C,$49,$00,$00,$4D,$D3,$F6,$7C,$3E,$DF,$89,$A6,$69,$39,$9F,$CF,$77
  Data.b $52,$AB,$D9,$3C,$9D,$DE,$BC,$A4,$94,$E6,$6F,$6E,$EA,$9C,$52,$9A,$4F,$A7,$37,$2F
  Data.b $6B,$35,$9B,$FF,$99,$D3,$34,$6D,$EF,$AF,$8B,$2A,$8A,$B2,$E1,$F5,$7A,$4F,$EB,$F5
  Data.b $7B,$9E,$4A,$A5,$AF,$6F,$6F,$DB,$3C,$95,$4A,$5F,$D7,$EB,$F7,$DC,$EB,$F5,$9E,$2A
  Data.b $8A,$B2,$B1,$E8,$1B,$AF,$C8,$B2,$9C,$F4,$78,$3C,$67,$AD,$56,$97,$DF,$DD,$7D,$E5
  Data.b $AD,$56,$97,$7B,$3C,$9E,$33,$59,$96,$93,$FF,$2D,$CF,$A0,$94,$26,$25,$49,$2A,$D9
  Data.b $76,$97,$4B,$92,$54,$A2,$94,$BE,$BD,$3C,$83,$10,$92,$24,$84,$94,$08,$21,$FF,$2C
  Data.b $FF,$02,$6A,$A2,$D8,$0A,$79,$12,$C2,$C4,$00,$00,$00,$00,$49,$45,$4E,$44,$AE,$42
  Data.b $60,$82
  pend:
EndDataSection

DataSection
  i:
  Data.b $00,$00,$01,$00,$01,$00,$10,$10,$00,$00,$01,$00,$20,$00,$68,$04,$00,$00,$16,$00
  Data.b $00,$00,$28,$00,$00,$00,$10,$00,$00,$00,$20,$00,$00,$00,$01,$00,$20,$00,$00,$00
  Data.b $00,$00,$00,$04,$00,$00,$12,$0B,$00,$00,$12,$0B,$00,$00,$00,$00,$00,$00,$00,$00
  Data.b $00,$00,$13,$13,$13,$00,$11,$11,$11,$00,$13,$13,$13,$00,$0D,$0D,$0D,$00,$09,$09
  Data.b $09,$00,$05,$05,$05,$00,$04,$04,$04,$3F,$04,$04,$04,$8A,$04,$04,$04,$3F,$05,$05
  Data.b $05,$00,$09,$09,$09,$00,$0D,$0D,$0D,$00,$13,$13,$13,$00,$11,$11,$11,$00,$13,$13
  Data.b $13,$00,$FF,$FF,$FF,$00,$13,$13,$13,$00,$11,$11,$11,$00,$13,$13,$13,$00,$0D,$0D
  Data.b $0D,$00,$09,$09,$09,$00,$06,$06,$06,$3F,$05,$05,$05,$8A,$DB,$CB,$CB,$FF,$05,$05
  Data.b $05,$8A,$06,$06,$06,$3F,$09,$09,$09,$00,$0D,$0D,$0D,$00,$13,$13,$13,$00,$11,$11
  Data.b $11,$00,$13,$13,$13,$00,$FF,$FF,$FF,$00,$13,$13,$13,$00,$11,$11,$11,$00,$13,$13
  Data.b $13,$00,$0D,$0D,$0D,$00,$0A,$0A,$0A,$3E,$09,$09,$09,$89,$DB,$CF,$CF,$FF,$D7,$C8
  Data.b $C8,$FF,$DB,$CF,$CF,$FF,$09,$09,$09,$89,$0A,$0A,$0A,$3E,$0D,$0D,$0D,$00,$13,$13
  Data.b $13,$00,$11,$11,$11,$00,$13,$13,$13,$00,$FF,$FF,$FF,$00,$13,$13,$13,$00,$11,$11
  Data.b $11,$00,$13,$13,$13,$00,$0E,$0E,$0E,$3D,$0D,$0D,$0D,$87,$D1,$C9,$C9,$FF,$43,$40
  Data.b $40,$A5,$D0,$C4,$C4,$FF,$43,$40,$40,$A5,$D1,$C9,$C9,$FF,$0D,$0D,$0D,$87,$0E,$0E
  Data.b $0E,$3D,$13,$13,$13,$00,$11,$11,$11,$00,$13,$13,$13,$00,$FF,$FF,$FF,$00,$14,$14
  Data.b $14,$63,$13,$13,$13,$84,$14,$14,$14,$4F,$13,$13,$13,$84,$CB,$C7,$C7,$FF,$46,$43
  Data.b $43,$A3,$06,$06,$06,$7B,$C9,$C0,$C0,$FF,$06,$06,$06,$7B,$46,$43,$43,$A3,$CB,$C7
  Data.b $C7,$FF,$13,$13,$13,$84,$14,$14,$14,$4F,$13,$13,$13,$84,$14,$14,$14,$63,$FF,$FF
  Data.b $FF,$00,$19,$19,$19,$82,$CD,$CB,$CB,$FF,$19,$19,$19,$82,$CD,$CB,$CB,$FF,$48,$47
  Data.b $47,$A1,$18,$18,$18,$3B,$01,$01,$01,$6B,$C2,$BD,$BD,$FF,$01,$01,$01,$6B,$18,$18
  Data.b $18,$3B,$48,$47,$47,$A1,$CD,$CB,$CB,$FF,$19,$19,$19,$82,$CD,$CB,$CB,$FF,$19,$19
  Data.b $19,$82,$FF,$FF,$FF,$00,$1F,$1F,$1F,$7F,$B1,$B1,$B1,$DF,$D4,$D4,$D4,$FF,$4C,$4B
  Data.b $4B,$9F,$1E,$1E,$1E,$4C,$0D,$0D,$0D,$00,$00,$00,$00,$67,$BD,$BB,$BB,$FF,$00,$00
  Data.b $00,$67,$0D,$0D,$0D,$00,$1E,$1E,$1E,$4C,$4C,$4B,$4B,$9F,$D4,$D4,$D4,$FF,$B1,$B1
  Data.b $B1,$DF,$1F,$1F,$1F,$7F,$FF,$FF,$FF,$00,$26,$26,$26,$7C,$F0,$F0,$F0,$FF,$BC,$BC
  Data.b $BC,$DF,$DD,$DD,$DD,$FF,$26,$26,$26,$7C,$14,$14,$14,$00,$02,$02,$02,$70,$BB,$BB
  Data.b $BB,$FF,$02,$02,$02,$70,$14,$14,$14,$00,$26,$26,$26,$7C,$DD,$DD,$DD,$FF,$BC,$BC
  Data.b $BC,$DF,$F0,$F0,$F0,$FF,$26,$26,$26,$7C,$FF,$FF,$FF,$00,$2C,$2C,$2C,$5B,$2D,$2D
  Data.b $2D,$78,$2D,$2D,$2D,$78,$2D,$2D,$2D,$78,$2C,$2C,$2C,$5B,$18,$18,$18,$00,$04,$04
  Data.b $04,$7A,$BD,$BE,$BE,$FF,$04,$04,$04,$7A,$18,$18,$18,$00,$2C,$2C,$2C,$5B,$2D,$2D
  Data.b $2D,$78,$2D,$2D,$2D,$78,$2D,$2D,$2D,$78,$2C,$2C,$2C,$5B,$FF,$FF,$FF,$00,$2D,$2D
  Data.b $2D,$00,$2E,$2E,$2E,$00,$2E,$2E,$2E,$00,$2E,$2E,$2E,$00,$23,$23,$23,$00,$04,$04
  Data.b $04,$5D,$04,$04,$04,$7C,$C3,$C4,$C4,$FF,$04,$04,$04,$7C,$04,$04,$04,$5D,$23,$23
  Data.b $23,$00,$2E,$2E,$2E,$00,$2E,$2E,$2E,$00,$2E,$2E,$2E,$00,$2D,$2D,$2D,$00,$FF,$FF
  Data.b $FF,$00,$2D,$2D,$2D,$00,$2E,$2E,$2E,$00,$2E,$2E,$2E,$00,$23,$23,$23,$00,$00,$00
  Data.b $00,$00,$00,$00,$00,$77,$DC,$DD,$DD,$FF,$C3,$C4,$C4,$FF,$DC,$DD,$DD,$FF,$00,$00
  Data.b $00,$77,$00,$00,$00,$00,$23,$23,$23,$00,$2E,$2E,$2E,$00,$2E,$2E,$2E,$00,$2D,$2D
  Data.b $2D,$00,$FF,$FF,$FF,$00,$2D,$2D,$2D,$00,$2E,$2E,$2E,$00,$2E,$2E,$2E,$00,$00,$00
  Data.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$4D,$00,$00,$00,$6E,$D5,$D6,$D6,$FF,$00,$00
  Data.b $00,$6E,$00,$00,$00,$4D,$00,$00,$00,$00,$00,$00,$00,$00,$2E,$2E,$2E,$00,$2E,$2E
  Data.b $2E,$00,$2D,$2D,$2D,$00,$FF,$FF,$FF,$00,$2D,$2D,$2D,$00,$23,$23,$23,$00,$0C,$0C
  Data.b $0C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$4B,$AA,$AA,$AA,$CB,$DE,$DF
  Data.b $DF,$FF,$AA,$AA,$AA,$CB,$00,$00,$00,$4B,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$0C
  Data.b $0C,$00,$23,$23,$23,$00,$2D,$2D,$2D,$00,$FF,$FF,$FF,$00,$23,$23,$23,$00,$12,$12
  Data.b $12,$00,$12,$12,$12,$00,$12,$12,$12,$00,$12,$12,$12,$00,$12,$12,$12,$66,$E7,$E7
  Data.b $E7,$FF,$06,$06,$06,$7A,$E7,$E7,$E7,$FF,$12,$12,$12,$66,$12,$12,$12,$00,$12,$12
  Data.b $12,$00,$12,$12,$12,$00,$12,$12,$12,$00,$23,$23,$23,$00,$FF,$FF,$FF,$00,$33,$33
  Data.b $33,$00,$33,$33,$33,$00,$33,$33,$33,$00,$33,$33,$33,$00,$33,$33,$33,$00,$33,$33
  Data.b $33,$59,$C3,$C3,$C3,$CA,$ED,$ED,$ED,$FF,$C3,$C3,$C3,$CA,$33,$33,$33,$59,$33,$33
  Data.b $33,$00,$33,$33,$33,$00,$33,$33,$33,$00,$33,$33,$33,$00,$33,$33,$33,$00,$FF,$FF
  Data.b $FF,$00,$4B,$4B,$4B,$00,$4B,$4B,$4B,$00,$4B,$4B,$4B,$00,$4B,$4B,$4B,$00,$4B,$4B
  Data.b $4B,$00,$4E,$4E,$4E,$14,$50,$50,$50,$59,$50,$50,$50,$66,$50,$50,$50,$59,$4E,$4E
  Data.b $4E,$14,$4B,$4B,$4B,$00,$4B,$4B,$4B,$00,$4B,$4B,$4B,$00,$4B,$4B,$4B,$00,$4B,$4B
  Data.b $4B,$00,$FF,$FF,$FF,$00,$FC,$7F,$00,$00,$F8,$3F,$00,$00,$F0,$1F,$00,$00,$E0,$0F
  Data.b $00,$00,$00,$01,$00,$00,$00,$01,$00,$00,$04,$41,$00,$00,$04,$41,$00,$00,$04,$41
  Data.b $00,$00,$F8,$3F,$00,$00,$F8,$3F,$00,$00,$F8,$3F,$00,$00,$F8,$3F,$00,$00,$F8,$3F
  Data.b $00,$00,$F8,$3F,$00,$00,$F8,$3F,$00,$00
  iend:
EndDataSection

;
DataSection
  Up:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$2E9FC8043216020A,$58457407000000A2,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D385441444948,$010A067FC3E1F0FC,$21A6421A8C06A513,$8033021994050505,$CF88D7410D384190,$6130986B2086AC20
  Data.q $0066077AF0834102,$9F11AE82192441B2,$0086368779A38C41,$A9F5185F19F1F400,$4E45490000000018
  Data.b $44,$AE,$42,$60,$82
  
  Up_Over:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$CA9CF4203216020A,$5845740700000073,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D385441444948,$010A067FD6EB75BC,$21A6421A8C06A513,$80330219946A6A6A,$CF88D7410D384190,$EB75B86B2086AC20
  Data.q $0066077AF0834116,$9F11AE82192441B2,$0086368779A38C41,$FC2A901F17336A00,$4E4549000000009C
  Data.b $44,$AE,$42,$60,$82
  
  Up_Click:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$C7DDF02C0709030A,$58457407000000C6,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D385441444947,$602140CFF848484C,$6434C8435180D4A2,$8033021994F9FCFE,$CF88D7410D384190,$4C4C486B2086AC20
  Data.q $400CC0EF5E106824,$33E235D043248836,$0010C6D0EF347188,$683F387F1917716E,$444E454900000000
  Data.b $AE,$42,$60,$82
  
  Down:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$D80F5B333116020A,$584574070000006E,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$ED8D385441444954,$C0040820000A41D2,$EA0FEA9F14FB17B5,$51E43A87482ED11A,$6AC38ECCCB4141DC,$876FBB880A47C0A7
  Data.q $91201806B26E9F59,$BB6CF6300000A839,$900C035936D44460,$D4A9CE2000541CC8,$1D0B26190576CFE3,$000000B208383D2D,$6042AE444E454900
  Data.b $82
  
  Down_Over:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$4299AB193216020A,$584574070000007B,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$ED8D38544144494F,$40030820000DC1CE,$97E8CBA79FF61875,$7A1B3C8CFE315A10,$E05B8DE5DB300769,$A72CCFA599880723
  Data.q $0545F1120181624B,$25A5E7C0BA400450,$B602A2F88900C0B1,$590C7B9521280548,$9E2ABAB6AF18DF4D,$444E454900000000
  Data.b $AE,$42,$60,$82
  
  Down_Click:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$E7B3CB0C0709030A,$584574070000000E,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$ED8D385441444953,$C0040820000A41D2,$235D6A7CCBEA97B5,$3B8A3C8750E905DA,$14ED5871DEEE6828,$EB30EDCCC90148F8
  Data.q $0732240300D64DD3,$8C176D9EC6000015,$991201806B26DA88,$FC7A9539C4000A83,$3719367C0320AED9,$00000000F154F3D6,$826042AE444E4549
  
  Left:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$B0B80D232117020A,$584574070000006C,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D385441444948,$010A067FC3E1F0FC,$085843430C06A513,$4C27B38028282829,$AF0031884BBA4098,$0C5210D3801AC421
  Data.q $49036446B20869C0,$B12C06F083548432,$0218DA1DE68E3106,$054AC4C11CBC1400,$4E45490000000031
  Data.b $44,$AE,$42,$60,$82
  
  Left_Over:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$FCD0551E2117020A,$584574070000007D,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D38544144494C,$010A067FD6EB75BC,$085843430C06A513,$DD6FB38353535029,$AF0031884BBA45BA,$0C5210D3801AC421
  Data.q $49036446B20869C0,$B12C06F083548432,$5484C3B2628C1106,$1B64E200010CCC30,$000000E8531A9A41,$6042AE444E454900
  Data.b $82
  
  Left_Click:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$2E600D01240C030A,$5845740700000039,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D385441444947,$602140CFF848484C,$210B08686180D4A2,$1313B387CFE7F305,$35E0063109774913,$018A421A70035884
  Data.q $49206C88D6410D38,$D62580DE106A9086,$00431B43BCD1C620,$7DE797886119E21F,$444E454900000000
  Data.b $AE,$42,$60,$82
  
  Right:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$440C2C172117020A,$58457407000000D9,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D385441444948,$010A067FC3E1F0FC,$705843430C06A513,$2613D9C014141449,$0D911AC825CF204C,$2618220C5210C924
  Data.q $06C26210D04418C4,$48434E2E06C421AF,$431B43BCD1C61D89,$616AFFC11CADE400,$4E45490000000079
  Data.b $44,$AE,$42,$60,$82
  
  Right_Over:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$D168B2102117020A,$584574070000007A,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D38544144494E,$010A067FD6EB75BC,$705843430C06A513,$6EB7D9C1A9A9A849,$0D911AC825CF22DD,$2618220C5210C924
  Data.q $06C26210D04418C4,$48434E2E06C421AF,$5123484C519C1D89,$C60043330C05212E,$00185CAAD4411BD4,$AE444E4549000000
  Data.b $42,$60,$82
  
  Right_Click:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$42666E1C240C030A,$58457407000000E0,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D385441444948,$602140CFF848484C,$2E0B08686180D4A2,$8989D9C3E7F3F989,$81B2235904B9E489,$84C304418A421924
  Data.q $E0D84C421A088318,$290869C5C0D88435,$086368779A38C3B1,$1191BE6119D3EF00,$4E45490000000029
  Data.b $44,$AE,$42,$60,$82
  
  Knob:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$2B3293082317020A,$58457407000000AE,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D38544144491E,$010A067FC0E0703C,$C86A321A8C06A513,$2A00014086A321A8,$00298E74FA61038A,$AE444E4549000000
  Data.b $42,$60,$82
  
  Knob_Over:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$7BF9353B2217020A,$58457407000000F9,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D38544144491E,$010A067FD96CB65C,$C86A321A8C06A513,$C500014086A321A8,$007E99691D1303A2,$AE444E4549000000
  Data.b $42,$60,$82
  
  Knob_Click:
  Data.q $0A1A0A0D474E5089,$524448490D000000,$1100000011000000,$476D3B0000000608,$59487009000000FA,$0E0000C40E000073,$00001B0E2B9501C4
  Data.q $E007454D49740700,$7EF8CF1B0809030A,$5845740700000006,$00726F6874754174,$0C00000048CCAEA9,$6373654474584574,$006E6F6974706972
  Data.q $0A00000023210913,$79706F4374584574,$0FAC007468676972,$45740E0000003ACC,$6974616572437458,$00656D6974206E6F,$09000000090FF735
  Data.q $74666F5374584574,$FF705D0065726177,$5845740B0000003A,$69616C6373694474,$8FB4C0B70072656D,$7458457408000000,$00676E696E726157
  Data.q $0700000087E61BC0,$72756F5374584574,$00EB83FFF5006563,$4374584574080000,$F600746E656D6D6F,$7406000000BF96CC,$656C746954745845
  Data.q $00000027D2EEA800,$638D38544144491E,$602140CFF848484C,$190D46435180D4A2,$0400002810D46435,$00473A9F964102DF,$AE444E4549000000
  Data.b $42,$60,$82
  
  
EndDataSection




;-

EnumerationBinary #PB_Menu_ModernLook
  #PB_Menu_Image
EndEnumeration

Declare MenuElementItem(MenuItem, Text$, Image =- 1)
;-
Procedure AddGadgetElementItem(Element, Position, Text$, Image =- 1, Flag = 0)
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      
      Select \This()\Type 
        Case #_Type_PopupMenu
          Result  = AddElementItem(Element, Position, Text$, Image, Flag)
          
        Case #_Type_Properties
          Result  = AddElementItem(Element, Position, Text$, Image, Flag)
          
        Case #_Type_Panel
          Result  = AddPanelElementItem(Element, Position, Text$, Image, Flag)
          
        Case #_Type_ListView
          Result  = AddListViewElementItem(Element, Position, Text$, Image, Flag)
          
        Case #_Type_ListIcon
          Result  = AddListIconElementItem(Element, Position, Text$, Image, Flag)
          
        Case #_Type_ComboBox
          Result  = AddComboBoxElementItem(Element, Position, Text$, Image, Flag)
          
          
        Case #_Type_Editor
          
          Protected IT, Text_X, Text_Y, String1.S, FontColor = $FFFFFF, BackColor = 0, Flags, vb, hb
          Protected X = \This()\InnerCoordinate\X
          Protected Y = \This()\InnerCoordinate\Y
          Protected iWidth = \This()\InnerCoordinate\Width
          Protected iHeight = 225;\This()\InnerCoordinate\Height
          Protected String3.S = Text$
          
          
          Protected CountString = CountString(String3, #LF$)
          
          If CountString
            If StartDrawing(CanvasOutput(\Canvas))
              If \This()\FontID
                DrawingFont(\This()\FontID)
              Else
                DrawingFont(GetGadgetFont(#PB_Default)) ; Шрифт по умолчанию
              EndIf
              
              Protected Text_Height = TextHeight("A")
              StopDrawing()
            EndIf
            
            If ((Flags & #_Flag_Text_HCenter) = #_Flag_Text_HCenter)
              Text_Y = (iHeight-(Text_Height * CountString)) / 2 
            ElseIf ((Flags & #_Flag_Text_Bottom) = #_Flag_Text_Bottom)
              Text_Y = (iHeight-(Text_Height * CountString)) - vb
            EndIf
            
            ; Text$ тратить
            For IT = 1 To CountString
              String1 = StringField(String3, IT, #LF$)
              
              If ((Flags & #_Flag_Text_VCenter) = #_Flag_Text_VCenter)
                Text_X = (iWidth - TextWidth(String1)) / 2
              ElseIf ((Flags & #_Flag_Text_Right) = #_Flag_Text_Right)
                Text_X = (iWidth - TextWidth(String1)) - hb
              EndIf
              
              ; DrawText(X+Text_X, Y+Text_Y, String1, FontColor, BackColor)
              Result = AddElementItem(Element, #PB_Any, String1, Image, Flag)
              
              Text_Y+Text_Height
              Debug "Result "+Str(iHeight - Text_Height)
              If Text_Y > (iHeight - Text_Height)
                Break
              EndIf
            Next
          Else
            Result = AddElementItem(Element, Position, Text$, Image, Flag)
          EndIf
          
          ;     ForEach \This()\Items()
          ;       Text$ + \This()\Items()\Text\String$
          ;       \This()\Hide  = 1
          ;     Next
          ;     SetElementText(Element,Text$)
      EndSelect
      
      PopListPosition(\This()) 
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure 


;{ - GadgetElements
Procedure ImageButtonElement( Element, X,Y,Width,Height, Image, Text$ = "", Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_ImageButton, Element, X,Y,Width,Height,Text$, Image,#PB_Default,#PB_Default, Flag|#_Flag_Image_Center|#_Flag_Text_Center)
  SetElementText( Element, Text$ )
  
  If Radius
    With *CreateElement
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      \This()\Radius = Radius
      PopListPosition(\This())
    EndWith
  EndIf
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

Procedure ButtonElement( Element, X,Y,Width,Height, Text$ = "", Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_Button, Element, X,Y,Width,Height,Text$, #PB_Default,#PB_Default,#PB_Default, Flag)
  SetElementText( Element, Text$ )
  
  If Radius
    With *CreateElement
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Element))
      \This()\Radius = Radius
      PopListPosition(\This())
    EndWith
  EndIf
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

Procedure OptionElement( Element, X,Y,Width,Height, Text$ = "", Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  Element = CreateElement( #_Type_Option, Element, X,Y,Width,Height,Text$, #PB_Default,#PB_Default,#PB_Default, Flag )
  SetElementText( Element, Text$ )
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    If Radius
      \This()\Radius = Radius
    EndIf
    
    ;     
    ;     Protected OptionGroup
    ;     PushListPosition(\This())
    ;     ChangeCurrentElement(\This(), ElementID(PrevPosition(Element)))
    ;     If \This()\Type = #_Type_Option
    ;       OptionGroup = \This()\OptionGroup 
    ;     Else
    ;       OptionGroup = \This()\Element 
    ;     EndIf
    ;     PopListPosition(\This())
    ;     \This()\OptionGroup = OptionGroup 
    ;     ;Debug \This()\OptionGroup
    
    
    
    ;\This()\FrameColor = $858585;$A0A0A0
    ;\This()\bSize = 4
    ;ResizeElement(\This()\Element, \This()\FrameCoordinate\X, \This()\FrameCoordinate\Y, \This()\FrameCoordinate\Width, \This()\FrameCoordinate\Height, #PB_Ignore)
    PopListPosition(\This())
  EndWith
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

Procedure FrameElement( Element, X,Y,Width,Height, Text$ = "", Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  Element = CreateElement( #_Type_Frame, Element, X,Y,Width,Height,Text$, #PB_Default,#PB_Default,#PB_Default, Flag )
  SetElementText( Element, Text$ )
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    If Radius
      \This()\Radius = Radius
    EndIf
    
    
    PopListPosition(\This())
  EndWith
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

Procedure ImageElement( Element, X,Y,Width,Height, Image =- 1, Flag.q = 0, Parent =- 1 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_Image, Element, X,Y,Width,Height,"", Image,#PB_Default,#PB_Default, Flag )
  ;SetElementImage( Element, Image )
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

Procedure ButtonImageElement( Element, X,Y,Width,Height, Image =- 1, Flag.q = 0, Parent =- 1 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_ButtonImage, Element, X,Y,Width,Height,"", Image,#PB_Default,#PB_Default, Flag )
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure


;}



;-
Procedure GetButtonIcon(ButtonIcon) 
  Protected ButtonID =- 1
  UsePNGImageDecoder()
  
  Protected Directory$ = GetCurrentDirectory()+"Themes/" ; "";
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
    
    Protected PackEntryName.s, ImageSize, *Image, ZipFile;, Image
    ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
    
    If ZipFile  
      If ExaminePack(ZipFile)
        While NextPackEntry(ZipFile)
          
          PackEntryName.S = PackEntryName(ZipFile)
          
          PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
          PackEntryName.S = ReplaceString(PackEntryName.S,"page_","")
          
          Select PackEntryType(ZipFile)
            Case #PB_Packer_File
              
              Protected Left.S = UCase(Left(PackEntryName.S,1))
              Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
              PackEntryName.S = " "+Left.S+Right.S
              
              Select ButtonIcon 
                Case #PB_ToolBarIcon_Add
                  ButtonID = CatchImage(#PB_Any, ?addicon_png_start, 576)
                  
                Case #PB_ToolBarIcon_Delete
                  ButtonID = CatchImage(#PB_Any, ?deleteicon_png_start, 801)
                  
                  ;                   If FindString(LCase(PackEntryName.S), "cross") And FindString(LCase(PackEntryName.S), "_") = 0
                  ;                     ImageSize = PackEntrySize(ZipFile)
                  ;                     *Image = AllocateMemory(ImageSize)
                  ;                     UncompressPackMemory(ZipFile, *Image, ImageSize)
                  ;                     ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                  ;                     FreeMemory(*Image)
                  ;                     Break
                  ;                   EndIf
                  
                Case #PB_ToolBarIcon_Help
                  If FindString(LCase(PackEntryName.S), "help")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Print
                  If FindString(LCase(PackEntryName.S), "script")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_PrintPreview
                  If FindString(LCase(PackEntryName.S), "folder_explore")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Replace
                  If FindString(LCase(PackEntryName.S), "refresh") And FindString(LCase(PackEntryName.S), "_") = 0
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Properties
                  If FindString(LCase(PackEntryName.S), "edit") And FindString(LCase(PackEntryName.S), "_") = 0
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Cut
                  If FindString(LCase(PackEntryName.S), "cut")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Copy
                  If FindString(LCase(PackEntryName.S), "copy")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Paste
                  If FindString(LCase(PackEntryName.S), "paste")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Undo
                  If FindString(LCase(PackEntryName.S), "arrow_undo")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Redo
                  If FindString(LCase(PackEntryName.S), "arrow_redo")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Find
                  If FindString(LCase(PackEntryName.S), "zoom")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Open
                  If FindString(LCase(PackEntryName.S), "folder_page")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_New
                  If FindString(LCase(PackEntryName.S), "page") And FindString(LCase(PackEntryName.S), "_") = 0
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
                Case #PB_ToolBarIcon_Save
                  If FindString(LCase(PackEntryName.S), "disk")
                    ImageSize = PackEntrySize(ZipFile)
                    *Image = AllocateMemory(ImageSize)
                    UncompressPackMemory(ZipFile, *Image, ImageSize)
                    ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                    FreeMemory(*Image)
                    Break
                  EndIf
                  
              EndSelect
              
          EndSelect
          
        Wend  
      EndIf
      
      ClosePack(ZipFile)
    EndIf
  EndIf
  
  
  
  DataSection
    deleteicon_png_start:
    ; size : 801 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$0E0000000E000000,$2D481F0000000608,$47527301000000D1
    Data.q $0000E91CCEAE0042,$0000414D41670400,$00000561FC0B8FB1,$0000735948700900,$C701C30E0000C30E
    Data.q $741900000064A86F,$7774666F53745845,$6E69617000657261,$2E342074656E2E74,$7A5B033433312E30
    Data.q $5441444991020000,$6153485D526D4F38,$AC1FA22E81FAFE18,$C6E6739D9D72E3B6,$175B34E8EDBFCE9C
    Data.q $1A0FE51AC2932061,$CF368A9494586EA2,$2EC428933697358E,$41FD855D108298D2,$1B461A071BC2E82C
    Data.q $A5285D578127538A,$5129A3BEFB78BBFB,$BCFBCF7EF177CDCF,$761CA75448BCFBCF,$62EB998C0F3D341B
    Data.q $1768A3E9A443BAA6,$8E51A3D9429C9C7B,$FEBC8C8BAE4E6AF7,$C93078AA507E5C8E,$5E10FA7A5B16B8EF
    Data.q $AD7DE90DB98A5CD5,$A5903BC8D48A09F4,$7A4D6626319FF31E,$104A2A5D372AD518,$B0756958BC8BDA11
    Data.q $05DFA4400F0C7E1F,$B5F68E82E3175513,$FEC798337BD3C7B1,$53210C52C84492D2,$5A8A9EE068E54C2E
    Data.q $DEF1E3723F682D13,$EAB0DD03AB62DAD6,$BD5FDE13708880ED,$5B2F26A768E4F490,$04C0B0429595CE7F
    Data.q $086E55AE787AF9D3,$F17A9E245245ACB4,$5BBBDFE22A6B1F78,$F04DDBE580E9C560,$682057D5C21AA1AD
    Data.q $10DA9D2616526336,$F248763DA6D1CA59,$AE7DE3C7DCBC4048,$56F961DAB4AE48AE,$8162C843D5352C23
    Data.q $A25154E9F06CA62F,$EF3919DA0FE917F4,$7CB0B5EC86BEA9D6,$46F20872D6730EDD,$D97B2D2EE0E06D78
    Data.q $AD83BAFEDB494EAE,$E4D66C9FE355EB95,$AF926CD82C237362,$620C367C021E02F9,$1BB23AA38E5A4EC5
    Data.q $6DF98ED1CA3D2115,$56542C3B66C589E5,$6706F06F08D9B4C2,$6154C3C45C20F30A,$76A19398D9E90C2E
    Data.q $B28A87EE1C2E42A2,$10B575C20386F844,$58BA8983386198B0,$8C8BA745C99233CA,$0C877E0084292910
    Data.q $0FB421B3ECAC71E9,$2C1D636CFAECF479,$D21859FCE0403536,$2217216B2B021B31,$4CD89AD9231DA9B0
    Data.q $3E7144E1B8F30F09,$B4DA8A395BA9B174,$839EB49CDF859F7A,$3C4E5776930E7A67,$FE2E9E45EFA29C89
    Data.q $4EAFD53ABC09B4EE,$7674882F78055646,$8561AC539BA10AB1,$3EA971753C4E567F,$FAB513D211AD4B27
    Data.q $E44097C6770976C0,$975227880FF88BA5,$1C285E1BF4202494,$0000005DDBFE0391,$6042AE444E454900
    Data.b $82
    deleteicon_png_end:
  EndDataSection
  
  DataSection
    addicon_png_start:
    ; size : 576 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$0E0000000E000000,$2D481F0000000608,$47527301000000D1
    Data.q $0000E91CCEAE0042,$0000414D41670400,$00000561FC0B8FB1,$0000735948700900,$C701C30E0000C30E
    Data.q $741900000064A86F,$7774666F53745845,$6E69617000657261,$2E342074656E2E74,$7A5B033433312E30
    Data.q $54414449B0010000,$939D9406C0634F38,$519840B9FCCC6439,$E4A8184C2A0D8C3B,$5EA3DF9A2954A94C
    Data.q $54105A60B35BA8B6,$64DB79DAEA303098,$31FD4E53C6FFA9EA,$D8184C2A1539DCEA,$FFE5EE76DB783A4E
    Data.q $84729FB1FCAEF3F6,$EC769E76184646A0,$DF973DFF9B92EBB6,$5C23481CFF3BE3FE,$4389C9C94021880E
    Data.q $C7FEDF45854E64A7,$FA7D98F63D8ED3F6,$3C3743BF1BB2EF89,$5D84FFD5FDB31FFE,$6838F67B6FC73EAF
    Data.q $B63D1F6B7EC7A3C3,$9064636A0372E9CC,$6ED45F2CD4E70EB7,$FE1739877FD4E536,$B3EB763FF9BB2CFB
    Data.q $F7DD4FFF5EBB49FF,$0F93FFCFC1DA7FFE,$C0FFC3FBBE1FFD7E,$83FBF6975BFF1F5D,$AB697AA0DE828235
    Data.q $FE5E17DDBFD3F4F5,$2F5D94EFFEE1B91D,$C8F73FFF7FED65FF,$3CCDFCBF4739FFE7,$C3BF8F9EEC77F5FC
    Data.q $97D93A50EDFC7D76,$1679B983233FF191,$1D9EC71F14F171AB,$3A2EC7F7F6D3BEFD,$63E2FBD9E7BF9FD9
    Data.q $70AFF2FF1E97FF9F,$C7F56E9BE90BCBFF,$BF7AEAB61FDEB9AC,$A06C46D80EBB4163,$FDBEA7553BA3F774
    Data.q $C7BED94FEDF33EAF,$AA7727DED94747C4,$9FC7F6735FFF7CCF,$E7BC58D7894FFD8A,$9D97FFDF53D2EDC9
    Data.q $031A090F68A7FEFE,$07BAA7EA426DDA8A,$84D2EC29F5744F55,$404B1C239005130A,$1ED3496C00003030
    Data.q $000000003E2C4D2A,$826042AE444E4549
    addicon_png_end:
  EndDataSection
  
  ProcedureReturn ButtonID 
EndProcedure

;Declare NewElement(Type, Parent =- 1, Item =- 1)

XIncludeFile "CFE_CodeCreate(example).pb"
XIncludeFile "CFE_Window(example).pb"
XIncludeFile "CFE_CheckBox(example).pb"
XIncludeFile "CFE_Splitter(example).pb"
XIncludeFile "CFE_Spin(example).pb"
XIncludeFile "CFE_ListView(example).pb"
XIncludeFile "CFE_ListIcon(example).pb"
XIncludeFile "CFE_Panel(example).pb"
XIncludeFile "CFE_String(example).pb"
XIncludeFile "CFE_Menu(example).pb"
XIncludeFile "CFE_ToolBar(example).pb"
XIncludeFile "CFE_Text(example).pb"
XIncludeFile "CFE_Editor(example).pb"
XIncludeFile "CFE_Container(example).pb"
XIncludeFile "CFE_ComboBox(example).pb"
XIncludeFile "CFE_StatusBar(example).pb"
XIncludeFile "CFE_ScrollBar(example).pb"
XIncludeFile "CFE_ScrollArea(example).pb"
XIncludeFile "CFE_TrackBar(example).pb"
XIncludeFile "CFE_Properties(example).pb"


; ; ;-
; ; ; Window element example
; ; CompilerIf #PB_Compiler_IsMainFile
; ;   Global eCombo, gCombo
; ;   Define i
; ;   
; ;   Procedure ButtonsEvents(Event.q, EventElement)
; ;     Select ElementEvent()
; ;       Case #_Event_LeftClick
; ;         
; ;         ;ClearElementItems(eCombo) ;: AddGadgetElementItem(eCombo, 0,Str(0)+"_item_long_very_long")
; ;         RemoveElementItem(eCombo, 3)
; ;         
; ;        
; ;   EndSelect
; ;   EndProcedure
; ;   
; ;   Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
; ;   Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
; ;   
; ;   
; ;   OpenWindowElement(#PB_Any, 220,10,200,320, "BorderLess", #PB_Window_BorderLess) ; |#PB_Window_MoveGadget
; ;   
; ;   Procedure ComboBoxElementEvent(Event.q, EventElement)
; ;     
; ;     Select ElementEvent()
; ;       Case #_Event_Focus
; ;         Debug Str(EventElement())+" - focus"
; ;       Case #_Event_LostFocus
; ;         Debug Str(EventElement())+" - lost focus"
; ;       Case #_Event_Change
; ;         ;Debug Str(EventElementItem())+" - item change"
; ;         Debug Str(GetElementState(EventElement()))+" - item change"
; ;     EndSelect
; ;     
; ;   EndProcedure
; ;   
; ;   eCombo = ComboBoxElement(#PB_Any, 10,10,80,23)
; ;   For i = 0 To 10
; ;     AddGadgetElementItem(eCombo, i,Str(i)+"_item_long_very_long")
; ;   Next
; ;   SetElementState(eCombo, 3)
; ;   
; ;   BindGadgetElementEvent(eCombo, @ComboBoxElementEvent(), #_Event_Change)
; ;   
; ;   Procedure SpinElementEvent(Event.q, EventElement)
; ;     
; ;     Select ElementEvent()
; ;       Case #_Event_Up
; ;         Debug Str(EventElement())+" - up"
; ;         
; ;       Case #_Event_Down
; ;         Debug Str(EventElement())+" - down"
; ;         
; ;       Case #_Event_Change
; ;         ;Debug Str(EventElementItem())+" - item change"
; ;         Debug Str(GetElementState(EventElement()))+" - item change"
; ;     EndSelect
; ;     
; ;   EndProcedure
; ;   
; ;   Define e = SpinElement(#PB_Any, 10,38,80,23, 0,10, #_Flag_Numeric)
; ;   BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
; ;   Define e = SpinElement(#PB_Any, 10,66,80,23, -10.12,10.35, #_Flag_Numeric|#_Flag_Text_Right,-1, "0.23")
; ;   BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
; ;   
; ;   Define e = ComboBoxElement(#PB_Any, 10,94,80,20,#_Flag_Editable)
; ;   For i = 0 To 3
; ;     AddGadgetElementItem(e, i,Str(i)+"_item_long_very_long")
; ;   Next
; ;   SetElementState(e, 0)
; ;   BindGadgetElementEvent(e, @ComboBoxElementEvent(), #_Event_Change|#_Event_Focus|#_Event_LostFocus)
; ;   
; ;   Define e = ButtonElement(#PB_Any, 100,10,80,23,"Clears")
; ;   BindGadgetElementEvent(e, @ButtonsEvents())
; ;   ;SetElementFlag(e, #_Flag_Text_Right)
; ;   
; ;   Define c = ComboBoxElement(#PB_Any, 10,150,180,23, #_Flag_CheckBoxes)
; ;   For i = 0 To 10
; ;     AddGadgetElementItem(c, i,Str(i)+"_item_long_very_long")
; ;   Next
; ;   
; ;   Procedure Events(Event.q, EventElement)
; ;     Select Event
; ;       Case #_Event_Create
; ;         Debug ElementClass(ElementType(EventElement))
; ;     EndSelect
; ;     
; ;   EndProcedure
; ;   
; ;   BindEventElement(@Events())
; ;   WaitWindowEventClose(Window)
; ; CompilerEndIf
; ; 

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "CFE_(IDE).pb"
  
  Procedure AddChildrens(Parent, Element, X,Y,Width,Height,Flag)
    With *CreateElement
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Parent))
      AddElement(\This()\Childs()) 
      \This()\Childs()\Flag = Flag
      \This()\Childs()\EditingMode = 1
      \This()\Childs()\Element = Element
      \This()\Childs()\FrameCoordinate\X = X
      \This()\Childs()\FrameCoordinate\Y = Y
      \This()\Childs()\FrameCoordinate\Width = Width
      \This()\Childs()\FrameCoordinate\Height = Height
      PopListPosition(\This())
    EndWith                 
  EndProcedure
  
  Procedure ElementsCallBack(Event.q, EventElement)
    Protected CheckedElement = CheckedElement() ; Create drag element
    If IsContainerElement(CheckedElement)
      Static StartX,StartY,LastX,LastY
      ; If \This()\ContainerCoordinate\X < ((\Selector\left+\Selector\Right)-(\This()\bSize-\This()\BorderSize)) And 
      ;                    \This()\ContainerCoordinate\Y < ((\Selector\Top+\Selector\Bottom)-Y-(\This()\bSize-\This()\BorderSize))
      
      With *CreateElement
        
        ChangeCurrentElement(\This(), ElementID(EventElement))
        Select Event 
          Case #_Event_LeftButtonUp
            If Not \DragElementType
              Protected Left, Top, Right, Bottom, Sb = 1
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
                    
                    PushListPosition(\This())
                    ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
                    \This()\Flag &~ #_Flag_Anchors
                    PopListPosition(\This())
                    Debug \This()\Text\String$
                    ;SetAnchors(\This()\Element, #False)
                    \This()\Flag | #_Flag_Anchors
                    ; CopyList(\This()\Childs(),\This())
                    ;                   AddChildrens(EventElement, 
                    ;                                \This()\Element, 
                    ;                                \This()\FrameCoordinate\X,
                    ;                                \This()\FrameCoordinate\Y,
                    ;                                \This()\FrameCoordinate\Width,
                    ;                                \This()\FrameCoordinate\Height,
                    ;                                \This()\Flag)
                    ;                   If BeginDrawing()
                    ;                     
                    ;                     DrawFrames(\This()) 
                    ;                     DrawLines(\This())
                    ;                     DrawAnchors(\This()) 
                    ;                      
                    ;                     EndDrawing()
                    ;                   EndIf
                  EndIf
                EndIf
              Next
              PopListPosition(\This())
              
              ;             If BeginDrawing()
              ;               
              ;               UpdateDrawingContent() 
              ;               
              ;               EndDrawing()
              ;             EndIf
              ;             
              
              \Selector\left = 0 
              \Selector\top = 0 
              \Selector\right = 0 
              \Selector\bottom = 0
            EndIf
            
          Case #_Event_LeftButtonDown
            If Steps(\This()\FrameCoordinate\X,Steps)%2
              StartX = Steps(\MouseX,Steps)+3
            Else
              StartX = Steps(\MouseX,Steps)+1
            EndIf
            StartY = Steps(\MouseY,Steps)+3
            
          Case #_Event_MouseMove 
            If \Buttons And \SideDirection = 0
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
                  Box(StartX,StartY,LastX,LastY, $E23A2B)
                Else
                  DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_CustomFilter)
                  CustomFilterCallback(@DrawFilterCallback())
                  Box(StartX,StartY,LastX,LastY, $E23A2B)
                EndIf
                
                EndDrawing()
              EndIf
            EndIf
            
        EndSelect
        
      EndWith
    EndIf
    
    Select ElementEvent()
      Case #_Event_Change
        Debug EventClass(ElementEvent())
        
      Case #_Event_Free
        Debug EventElement
        
      Case #_Event_LeftClick
        Select EventElement
          Case 10
            ;Debug GetElementText(13)
            ;FreeElement(10) 
            ;FreeElement(14) ; Ok
            
          Case 11
            ;FreeElement(14) ; Ok
            
        EndSelect
        
      Case #_Event_RightClick
        DisplayPopupMenuElement(PopupMenuElement())
        ; DisplayPopupMenuElement(GetMenuPopupElement("File"))
        
    EndSelect
  EndProcedure
  
  Global img_point = Mosaic(Steps, 0,0,800,600)
  
  
  Global Window_3, Window_3_Panel =- 1, Window_3_List =- 1
  Global Panel_1_First =- 1,Panel_1_Prev =- 1,Panel_1_Next =- 1,Panel_1_Last =- 1
  Global Panel_2_First =- 1,Panel_2_Prev =- 1,Panel_2_Next =- 1,Panel_2_Last =- 1
  Global Panel_3_First =- 1,Panel_3_Prev =- 1,Panel_3_Next =- 1,Panel_3_Last =- 1
  
  Procedure Events(Event.q, EventElement)
    If Event = #_Event_LeftClick
      Debug "e "+EventElement+" p "+GetElementParent(EventElement)
    EndIf
    
    ProcedureReturn #True
  EndProcedure
  
  
  Define i
  Define w = OpenWindowElement(1, 0,0, 432,284+4*65, "") 
  Define  Time = ElapsedMilliseconds()
  OpenWindowElement(1, 0,0, 302,400, "Demo WindowElement()", #_Flag_ScreenCentered|#_Flag_AnchorsGadget|#_Flag_MaximizeGadget);|#_Flag_Invisible)
  
  TextElement  (-1, 50, 30, 130, 30,"Button 50", #_Flag_AnchorsGadget|#_Flag_Double)
  ButtonElement  (-1, 100, 60, 130, 30,"Button 51", #_Flag_AnchorsGadget|#_Flag_Double)
  StringElement  (-1, 150, 90, 130, 30,"Button 52", #_Flag_AnchorsGadget)
  SpinElement  (-1, 50, 130, 130, 30,0,100, #_Flag_AnchorsGadget|#_Flag_Numeric)
  ButtonElement  (-1, 100, 160, 130, 30,"Button 51", #_Flag_AnchorsGadget)
  ButtonElement  (-1, 150, 190, 130, 30,"Button 52", #_Flag_AnchorsGadget)
  ButtonElement  (-1, 50, 230, 130, 30,"Button 50", #_Flag_AnchorsGadget)
  ButtonElement  (-1, 100, 260, 130, 30,"Button 51", #_Flag_AnchorsGadget)
  ButtonElement  (-1, 150, 290, 130, 30,"Button 52", #_Flag_AnchorsGadget)
  
  CheckBoxElement(100, 10,340,250,20,"CheckBoxElement", #_Flag_AnchorsGadget|#PB_CheckBox_ThreeState)
  CheckBoxElement(101, 10,370,250,20,"CheckBoxElement", #PB_CheckBox_ThreeState)
  
  For i=100 To 200
    ButtonElement  (-1, 150, 290, 130, 30,"Button 52", #_Flag_AnchorsGadget)
  Next; ; ;   ButtonElement  (50, 50, 30, 130, 30,"Button 50", #_Flag_AnchorsGadget)
      ; ; ;   ButtonElement  (51, 100, 60, 130, 30,"Button 51", #_Flag_AnchorsGadget)
      ; ; ;   ButtonElement  (52, 150, 90, 130, 30,"Button 52", #_Flag_AnchorsGadget)
      ; ; ;   
      ; ; ;   FrameElement(100, 30, 145, 216, 136, "FrameElement", #_Flag_Flat | #_Flag_AnchorsGadget)
      ; ; ; ;   ContainerElement(100, 30, 185, 216, 136, #_Flag_Flat | #_Flag_AnchorsGadget)
      ; ; ; ;     ButtonElement(101, 30, 25, 126, 21, "Button_0", #_Flag_AnchorsGadget)
      ; ; ; ;     ButtonElement(102, 60, 65, 126, 21, "Button_1", #_Flag_AnchorsGadget)
      ; ; ; ;     ButtonElement(103, 95, 100, 126, 21, "Button_2", #_Flag_AnchorsGadget)
      ; ; ; ;   CloseElementList()
      ; ; ;   CreateElement(#_Type_AnchorButton, -1,30,280,100,100,"")
  
  SetElementBackGroundImage(1, img_point)
  
  ; ; ; ;   ;   For i = 2 To 10;00
  ; ; ; ;   ;     ButtonElement  (i, 130, i*30, 130, 30,"Button_"+Str(i))
  ; ; ; ;   ;     ;ButtonGadget  (i, 130, 30, 130, 30,"Button_"+Str(i))
  ; ; ; ;   ;   Next
  ; ; ; ;   SetElementState(100, #PB_Checkbox_Checked)
  ; ; ; ;   ; SetElementState(100, #PB_Checkbox_Unchecked)
  ; ; ; ;    SetElementState(100, #PB_Checkbox_Inbetween)
  ; ; ; ;   
  ; ; ; ;   SetElementBackGroundImage(w, img_point)
  ; ; ; ;   Define e = StringElement(#PB_Any, 5,5,200,45, "String", #_Flag_AnchorsGadget)
  ; ; ; ;   ;ResizeElement(e,5,5,#PB_Ignore,#PB_Ignore)
  ; ; ; ;   
  ; ; ; ;   ButtonElement  (10, 30, 50, 130, 30,"Button 10", #_Flag_AnchorsGadget);, 0, 0)
  ; ; ; ;   ButtonElement  (11, 130, 50, 130, 30,"Button 11", #_Flag_AnchorsGadget)
  ; ; ; ;   CreateElement(#_Type_Text, #PB_Any, 230, 50, 130, 30, "", #PB_Default,#PB_Default,#PB_Default, #_Flag_AnchorsGadget)
  ; ; ; ;   
  ; ; ; ;   OpenWindowElement(13, 160,100, 100,100, "Demo 13",#_Flag_AnchorsGadget,w) 
  ; ; ; ;   
  ; ; ; ;   
  ; ; ; ;   OpenWindowElement(14, 10,100, 100,100, "Demo 14",#_Flag_AnchorsGadget,w) 
  ; ; ; ;   SetElementBackGroundImage(12, img_point)
  ; ; ; ;   
  ; ; ; ;   
  ; ; ; ;   ContainerElement(16,10,300,100,100, #_Flag_AnchorsGadget)
  ; ; ; ;   Define eCombo = ComboBoxElement(15, 10,10,80,23,#_Flag_AnchorsGadget)
  ; ; ; ;   For i = 0 To 10
  ; ; ; ;     AddGadgetElementItem(eCombo, i,Str(i)+"_item_long_very_long")
  ; ; ; ;   Next
  ; ; ; ;   SetElementState(eCombo, 3)
  ; ; ; ;   CloseElementList()
  ; ; ; ;   
  ; ; ; ;   If CreatePopupMenuElement(#PB_Any)
  ; ; ; ;     OpenSubMenuElement("Z-Order")
  ; ; ; ;           MenuElementItem(0, "First")
  ; ; ; ;           MenuElementItem(1, "Prev")
  ; ; ; ;           MenuElementItem(2, "Next")
  ; ; ; ;           MenuElementItem(3, "Last")
  ; ; ; ;         CloseSubMenuElement()
  ; ; ; ;         
  ; ; ; ;         MenuElementBar()
  ; ; ; ;         
  ; ; ; ;         MenuElementItem(4, "Cut")
  ; ; ; ;         MenuElementItem(5, "Copy")
  ; ; ; ;         MenuElementItem(6, "Paste")
  ; ; ; ;         MenuElementItem(7, "Delete")
  ; ; ; ;         
  ; ; ; ;         MenuElementBar()
  ; ; ; ;         
  ; ; ; ;         MenuElementItem(100, "Preferences")
  ; ; ; ;         
  ; ; ; ;     ;BindMenuElementEvent(PopupMenuElement(), 1, @MenuItemEvent())
  ; ; ; ;   EndIf
  ; ; ; ;   
  
  ;ListIconElement(14, 10,100, 100,100, "Demo 14",#_Flag_AnchorsGadget,w) 
  
  ;SetElementParent(1,w)
  
  
  ; ; ;   ;{ - Panel example
  ; ; ;     Procedure Window_First_Event(Event.q, EventElement)
  ; ; ;     Select Event
  ; ; ;       Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionFirst)
  ; ; ;     EndSelect
  ; ; ;     
  ; ; ;     ProcedureReturn #PB_ProcessPureBasicEvents
  ; ; ;   EndProcedure
  ; ; ;   
  ; ; ;   Procedure Window_Prev_Event(Event.q, EventElement)
  ; ; ;     Select Event
  ; ; ;       Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionPrev)
  ; ; ;     EndSelect
  ; ; ;     
  ; ; ;     ProcedureReturn #PB_ProcessPureBasicEvents
  ; ; ;   EndProcedure
  ; ; ;   
  ; ; ;   Procedure Window_Next_Event(Event.q, EventElement)
  ; ; ;     Select Event
  ; ; ;       Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionNext)
  ; ; ;     EndSelect
  ; ; ;     
  ; ; ;     ProcedureReturn #PB_ProcessPureBasicEvents
  ; ; ;   EndProcedure
  ; ; ;   
  ; ; ;   Procedure Window_Last_Event(Event.q, EventElement)
  ; ; ;     Select Event
  ; ; ;       Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionLast)
  ; ; ;     EndSelect
  ; ; ;     
  ; ; ;     ProcedureReturn #PB_ProcessPureBasicEvents
  ; ; ;   EndProcedure
  ; ; ;   
  ; ; ;   Window_3 = OpenWindowElement( #PB_Any,10,0,250,150, "Demo Z-order", 0, w);
  ; ; ;   
  ; ; ;   Window_3_Panel = PanelElement(#PB_Any,30,10,190,100);, "Panel_0")                                                               ;
  ; ; ;     AddElementItem(Window_3_Panel, -1, "Panel_1")
  ; ; ;     Panel_1_Last = ButtonElement(#PB_Any,110,30,50,35, "1_Last")                                                               ;
  ; ; ;     Panel_1_Next = ButtonElement(#PB_Any,70,30,50,35, "1_Next")                                                                ;
  ; ; ;     Panel_1_Prev = ButtonElement(#PB_Any,30,30,50,35, "1_Prev")                                                                ;
  ; ; ;     Panel_1_First = ButtonElement(#PB_Any,10,10,170,35, "1_First")                                                             ;
  ; ; ;     
  ; ; ;     AddElementItem(Window_3_Panel, -1, "Panel_2") 
  ; ; ;     Panel_2_Last = ButtonElement(#PB_Any,110,30,50,35, "2_Last")                                                               ;
  ; ; ;     Panel_2_Next = ButtonElement(#PB_Any,70,30,50,35, "2_Next")                                                                ;
  ; ; ;     Panel_2_Prev = ButtonElement(#PB_Any,30,30,50,35, "2_Prev")                                                                ;
  ; ; ;     Panel_2_First = ButtonElement(#PB_Any,10,10,170,35, "2_First")                                                             ;
  ; ; ;     
  ; ; ;     AddElementItem(Window_3_Panel, -1, "Panel_3")
  ; ; ;     Panel_3_Last = ButtonElement(#PB_Any,110,30,50,35, "3_Last")                                                               ;
  ; ; ;     Panel_3_Next = ButtonElement(#PB_Any,70,30,50,35, "3_Next")                                                                ;
  ; ; ;     Panel_3_Prev = ButtonElement(#PB_Any,30,30,50,35, "3_Prev")                                                                ;
  ; ; ;     Panel_3_First = ButtonElement(#PB_Any,10,10,170,35, "3_First")                                                             ;
  ; ; ;     
  ; ; ;     ;     AddElementItem(Window_3_Panel, -1, "Panel_4_long")
  ; ; ;     ;     ; TODO 
  ; ; ;     ;     ;CreateElement(#_Type_Container, #PB_Any,10,10,150,55, "cont") 
  ; ; ;     ;     ButtonElement(#PB_Any,5,20,150,25, "butt") 
  ; ; ;     ;     ;CloseElementList()
  ; ; ;     ;     
  ; ; ;     ;     AddElementItem(Window_3_Panel, -1, "Panel_5")
  ; ; ;     ;     AddElementItem(Window_3_Panel, -1, "Panel_6")
  ; ; ;     CloseElementList()
  ; ; ;     
  ; ; ;     BindEventElement(@Window_First_Event(), Window_3, Panel_1_First, #PB_All)
  ; ; ;     BindEventElement(@Window_Prev_Event(), Window_3, Panel_1_Prev, #PB_All)
  ; ; ;     BindEventElement(@Window_Next_Event(), Window_3, Panel_1_Next, #PB_All)
  ; ; ;     BindEventElement(@Window_Last_Event(), Window_3, Panel_1_Last, #PB_All)
  ; ; ;     
  ; ; ;     BindEventElement(@Window_First_Event(), Window_3, Panel_2_First, #PB_All)
  ; ; ;     BindEventElement(@Window_Prev_Event(), Window_3, Panel_2_Prev, #PB_All)
  ; ; ;     BindEventElement(@Window_Next_Event(), Window_3, Panel_2_Next, #PB_All)
  ; ; ;     BindEventElement(@Window_Last_Event(), Window_3, Panel_2_Last, #PB_All)
  ; ; ;     
  ; ; ;     BindEventElement(@Window_First_Event(), Window_3, Panel_3_First, #PB_All)
  ; ; ;     BindEventElement(@Window_Prev_Event(), Window_3, Panel_3_Prev, #PB_All)
  ; ; ;     BindEventElement(@Window_Next_Event(), Window_3, Panel_3_Next, #PB_All)
  ; ; ;     BindEventElement(@Window_Last_Event(), Window_3, Panel_3_Last, #PB_All)
  ; ; ;     ;}
  ; ; ;     
  ; ; ;     
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf
  
  ;BindEventElement(@Events(), w)
  BindEventElement(@ElementsCallBack())
  WaitWindowEventClose(w)
CompilerEndIf


;-
CompilerIf #PB_Compiler_IsMainFile
  Demo = 1
  Define w = OpenWindowElement(#PB_Any, 0,0, 800,460, "Demo StringElement()", #_Flag_ScreenCentered|#_Flag_SizeGadget) 
  
  ;   
  Define e = w;
              ;   Define ToolBarElement = CreateElement(#_Type_ToolBar, #PB_Any,0,0,0,0)
              ;   
              ;   If ToolBarElement;CreateToolBarElement(#PB_Any, e);, #PB_ToolBar_Large|#PB_ToolBar_Text$|#PB_ToolBar_InlineText$)
              ;      ToolBarElementStandardButton(0, #PB_ToolBarIcon_New)
              ;    ;  ToolBarElementStandardButton(1, #PB_ToolBarIcon_Open, 0, "Open" )
              ; ;     ToolBarElementStandardButton(2, #PB_ToolBarIcon_Save)
              ;   ;   ToolBarElementSeparator()
              ; ;     
              ; ;     ToolBarElementStandardButton(3, #PB_ToolBarIcon_Print)
              ; ;     ToolBarElementStandardButton(4, #PB_ToolBarIcon_PrintPreview)
              ; ;     ToolBarElementStandardButton(5, #PB_ToolBarIcon_Find, 0, "Find")
              ; ;     ToolBarElementStandardButton(6, #PB_ToolBarIcon_Help)
              ;     
              ;     ;BindToolBarElementEvent(ToolBarElement(), 1, @ToolBarButtonEvent())
              ;   EndIf
  
  ;   ContainerElement(#PB_Any, 10,10,280,140) : CloseElementList()
  
  If CreateToolBarElement(#PB_Any, e)
    ToolBarElementStandardButton(1, #PB_ToolBarIcon_Open, 0, "Open" )
    ToolBarElementSeparator()
    ToolBarElementStandardButton(6, #PB_ToolBarIcon_Help)
  EndIf
  ;    If CreateMenuElement(#PB_Any, e)
  ;      MenuElementItem(5, "Find")
  ;      MenuElementBar()
  ;      MenuElementItem(6, "Help")
  ;    EndIf
  ;    If CreatePopupMenuElement(#PB_Any)
  ;      MenuElementItem(5, "Find")
  ;      MenuElementBar()
  ;      MenuElementItem(6, "Help")
  ;    EndIf
  
  
  Define g1 = ImageButtonElement(#PB_Any, 10,10,163,55, 0, "ButtonElement", #_Flag_Image_Top|#_Flag_Text_Bottom,-1,5)
  Define g2 = ImageButtonElement(#PB_Any, 10,70,163,25, 0, "ButtonElement", #_Flag_Image_Left|#_Flag_Text_Right,-1,5)
  Define g3 = SplitterElement(#PB_Any, 10,10,163,155, g1,g2,#_Flag_Separator_Circle)
  Define g4 = ImageButtonElement(#PB_Any, 10,70,163,25, 0, "ButtonElement", #_Flag_Image_Left|#_Flag_Text_Right,-1,5)
  SplitterElement(#PB_Any, 10,10,163,155, g4,g3,#_Flag_Vertical|#_Flag_Separator_Circle)
  
  ;   ImageButtonElement(#PB_Any, 10,10,163,55, 0, "ButtonElement", #_Flag_Image_Top|#_Flag_Text_Bottom,-1,5)
  ;   ImageButtonElement(#PB_Any, 10,70,163,25, 0, "ButtonElement", #_Flag_Image_Left|#_Flag_Text_Right,-1,5)
  ;   ImageButtonElement(#PB_Any, 10,100,163,25, 0, "ButtonElement", #_Flag_Image_Right|#_Flag_Text_Left,-1,5)
  ;   ImageButtonElement(#PB_Any, 10,130,163,55, 0, "ButtonElement", #_Flag_Image_Bottom|#_Flag_Text_Top,-1,5)
  Define i = 10
  ; ;   ImageButtonElement(2, 10,10,163,55, 0, "ButtonElement", #_Flag_Image_Top|#_Flag_Text_Bottom,-1,5)
  ; ;   ImageButtonElement(3, 10,70,163,25, 0, "ButtonElement", #_Flag_Image_Left|#_Flag_Text_Right,-1,5)
  ; ;   ImageButtonElement(i, 10,100,163,25, 0, "ButtonElement", #_Flag_Image_Right|#_Flag_Text_Left,-1,5)
  ; ;   ImageButtonElement(4, 10,130,163,55, 0, "ButtonElement", #_Flag_Image_Bottom|#_Flag_Text_Top,-1,5)
  
  ;   Debug w
  ;   Debug "  ElementID "+ElementID(w)
  ;   Debug "  IDElement "+IDElement(ElementID(w))
  ;   Debug "  Index "+Element(w)
  ;   
  ;   Debug ""
  ;   Debug "  ElementID "+ElementID(33)
  ;   Debug "  IDElement "+IDElement(ElementID(33))
  ;   Debug "  Index "+Element(33)
  ;   
  
  ;   Debug "Parent "+GetElementParent(i)
  ;   Debug "Window "+GetElementWindow(i)
  ;   Debug "IsChild "+IsChildElement(i, GetElementParent(i))
  ;   Debug "PosPrev"+GetElementPosition(i, #_Element_PositionPrev)
  ;   Debug "PosCurrent"+GetElementPosition(i)
  ;   Debug "PosNext"+GetElementPosition(i, #_Element_PositionNext)
  
  Procedure GadgetElementEvent(Event.q, EventElement)
    ;Debug Str(EventElement())+" "+EventClass(ElementEvent())
    If GetElementState(EventElement()) > =  0
      Debug *CreateElement\Item\Parent 
      Debug "State "+GetElementState(EventElement())
    EndIf
    
  EndProcedure
  BindGadgetElementEvent(e, @GadgetElementEvent(), #_Event_LeftClick)
  
  
  ContainerElement(#PB_Any, 10,170,120,90, #_Flag_Flat|#_Flag_AnchorsGadget) : CloseElementList()
  TextElement(#PB_Any, 190,140,120,50, "Border text Less", #_Flag_MoveGadget|#_Flag_SizeGadget)
  ComboBoxElement(#PB_Any, 190,200,120,50, #_Flag_MoveGadget|#_Flag_SizeGadget)
  
  ;{ - ComboBox
  OpenWindowElement(#PB_Any, 180,10,100,90, "ComboBox", #_Flag_SizeGadget|#_Flag_SystemMenu,w)
  
  Define i
  Define e = ComboBoxElement(#PB_Any, 10,10,80,23+8,#_Flag_MoveGadget|#_Flag_SizeGadget)
  For i = 0 To 10
    AddGadgetElementItem(e, i,Str(i)+"_item_long_very_long")
  Next
  SetElementState(e, 3)
  
  Define e = ComboBoxElement(#PB_Any, 10,45,80,23+8,#_Flag_Editable|#_Flag_MoveGadget|#_Flag_SizeGadget)
  For i = 0 To 3
    AddGadgetElementItem(e, i,Str(i)+"_item")
  Next
  SetElementState(e, 2)
  
  Procedure ComboBoxElementEvent(Event.q, EventElement)
    Select ElementEvent()
      Case #_Event_Focus
        Debug Str(EventElement())+" - focus"
      Case #_Event_LostFocus
        Debug Str(EventElement())+" - lost focus"
      Case #_Event_Change
        Debug Str(EventElementItem())+" - item change"
    EndSelect
  EndProcedure
  
  BindGadgetElementEvent(e, @ComboBoxElementEvent(), #_Event_Change|#_Event_Focus|#_Event_LostFocus)
  ;}
  
  ;{ - Spin
  OpenWindowElement(#PB_Any, 295,10,100,90, "Spin", #_Flag_SizeGadget|#_Flag_SystemMenu,w)
  
  Procedure SpinElementEvent(Event.q, EventElement)
    
    Select ElementEvent()
      Case #_Event_Up
        Debug Str(EventElement())+" - up"
        
      Case #_Event_Down
        Debug Str(EventElement())+" - down"
        
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        Debug Str(GetElementState(EventElement()))+" - item change"
    EndSelect
    
  EndProcedure
  
  Define e = SpinElement(#PB_Any, 10,10,80,23+8, 0,10, #_Flag_Numeric|#_Flag_MoveGadget|#_Flag_SizeGadget)
  BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  Define e = SpinElement(#PB_Any, 10,45,80,23+8, -10.12,10.35, #_Flag_Numeric|#_Flag_Text_Right|#_Flag_MoveGadget|#_Flag_SizeGadget,-1, "0.23")
  BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  ;}
  
  ;{ - ListView
  Define i = OpenWindowElement(#PB_Any, 410,10,120,170, "ListView", #_Flag_SizeGadget|#_Flag_SystemMenu,w)
  Define e = ListViewElement(#PB_Any,10,10,100,100,"",  #_Flag_MoveGadget|#_Flag_SizeGadget) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  
  AddListViewElementItem(e, 1, "ListView_1")
  AddListViewElementItem(e, 2, "ListView_2") 
  AddListViewElementItem(e, 3, "ListView_3", GetButtonIcon(#PB_ToolBarIcon_Cut))
  AddListViewElementItem(e, 0, "ListView_0", GetButtonIcon(#PB_ToolBarIcon_Open) )
  ;}
  
  ;{ - Properties
  OpenWindowElement(#PB_Any, 545,10,160,170, "Properties", #_Flag_SizeGadget|#_Flag_SystemMenu,w)
  Define p = CreateElement(#_Type_Properties, #PB_Any,10,10,140,120,"Properties",-1,-1,-1,#_Flag_SizeGadget|#_Flag_MoveGadget)            
  AddGadgetElementItem(p, -1, "ComboBox Elements:True|False")
  AddGadgetElementItem(p, -1, "String Text:")
  AddGadgetElementItem(p, -1, "Spin X:0|100")
  AddGadgetElementItem(p, -1, "Spin Y:0|200")
  AddGadgetElementItem(p, -1, "Spin Width:0|100")
  AddGadgetElementItem(p, -1, "Spin Height:0|200")
  
  AddGadgetElementItem(p, -1, "-Поведение-")
  AddGadgetElementItem(p, -1, "Button Puch:C:\as\image.png")
  AddGadgetElementItem(p, -1, "ComboBox Disable:True|False")
  AddGadgetElementItem(p, -1, "ComboBox Flag:#_Event_Close|#_Event_Size|#_Event_Move")
  ;   Define e = PropertiesElement(#PB_Any,10,10,100,100,"",  #_Flag_MoveGadget|#_Flag_SizeGadget) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  ;   
  ;   Debug AddPropertiesElementItem(e, -1, "ListView_1", GetButtonIcon(#PB_ToolBarIcon_Copy))
  ;   Debug AddPropertiesElementItem(e, -1, "ListView_2") 
  ;   Debug AddPropertiesElementItem(e, -1, "ListView_3", GetButtonIcon(#PB_ToolBarIcon_Cut))
  ;   Debug AddPropertiesElementItem(e, 0, "ListView_0", GetButtonIcon(#PB_ToolBarIcon_Open) )
  ;}
  
  ;{ - Panel&ScrollBar
  Define i
  OpenWindowElement(#PB_Any, 410,220,300,190, "Panel&ScrollBar", #_Flag_SizeGadget|#_Flag_SystemMenu,w)
  
  Define e = PanelElement(#PB_Any,10,10,190,100,#_Flag_MoveGadget|#_Flag_SizeGadget)                                                               ;
  AddPanelElementItem(e, -1, "Panel_1", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  ButtonElement(#PB_Any,30,30,50,35, "1_Butt")                                                                ;
  
  AddPanelElementItem(e, -1, "Panel_2") 
  Define b1 = ButtonElement(#PB_Any,70,10,50,35, "2_Butt")                                                                ;
  Define b2 = ButtonElement(#PB_Any,70,30,50,35, "2_Butt")                                                                ;
  SplitterElement(#PB_Any,10,10,50,55, b1,b2, #PB_Splitter_Separator_Circle)
  
  AddPanelElementItem(e, -1, "Panel_3_long")
  ContainerElement(#PB_Any,30,10,150,55,#_Flag_Flat) 
  ButtonElement(#PB_Any,10,10,50,35, "butt") 
  CloseElementList()
  
  
  AddPanelElementItem(e, -1, "Panel_4", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
  ButtonElement(#PB_Any,110,30,50,35, "3_Butt")                                                               ;
  
  AddPanelElementItem(e, -1, "Panel_5")
  AddPanelElementItem(e, -1, "Panel_6")
  CloseElementList()
  
  Define e = ScrollBarElement(#PB_Any, 260,10,20+8,170,0,85,170, #_Flag_MoveGadget|#_Flag_SizeGadget|#_Flag_Vertical,-1,5)
  ;SetElementState(e, 3)
  
  ;Define e = ScrollBarElement(#PB_Any, 10,150,200,20+8,0,100,200, #_Flag_MoveGadget|#_Flag_SizeGadget)
  ;SetElementState(e, 5) : SetElementText(e, "5")
  Define e = ScrollBarElement(#PB_Any, 10,150,200,20+8,0,300,50, #_Flag_SizeGadget);#_Flag_MoveGadget|
  SetElementState(e, 100) 
  ;}
  
  Procedure ElementsEvents(Event.q, EventElement)
    Select ElementEvent()
      Case #_Event_LeftButtonDown
        SetAnchors(EventElement)
        
      Case #_Event_LeftButtonUp
        
    EndSelect
  EndProcedure
  
  BindEventElement(@ElementsEvents())
  WaitWindowEventClose(w)
CompilerEndIf

; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = 9xpiQg--A3----------------vs------8-----vCEAAQVXX2---------nu74---e2480-f---eb8r+v-+84-Bb0-f--0-v4-7d2--8--fXX44d-844X0------8--+-----4--08---f2----tt+X4u4r7e-------+v---8------0----------------------8-v--8--0-----------40--8+------u0-----------------4-----v-----P-------080t0-t-6+-4----5-vVS5--
; EnableXP