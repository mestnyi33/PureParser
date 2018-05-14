CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "Constant.pbi"
  XIncludeFile "Resize.pbi"
  XIncludeFile "Transformation.pbi"
CompilerEndIf

DeclareModule wg
  Declare Gadget(Object.i)
  Declare Parent(Object.i)
  Declare$ GetTitle(Object.i)
  Declare SetTitle(Object.i, Text$)
  Declare Bind(Object.i, *CallBack, EventType=#PB_All)
  Declare Create(Gadget, X,Y,Width,Height, Title$="", Flag=0, Parent=-1)
EndDeclareModule

Module wg
  UseModule Constant
  ;-
  Structure WindowImageStruct
    x.i
    y.i
    ID.i[5]
  EndStructure
  
  Structure WindowCoordinateStruct
    x.i
    y.i
    width.i
    height.i
  EndStructure
  
  Structure WindowStruct
    Title$
    Flag.i
    Parent.i
    Gadget.i
    Steps.i
    BorderSize.i
    CaptionSize.i
    
    i.WindowCoordinateStruct
    
    Ico.i
    Img.WindowImageStruct
  EndStructure
  
  UsePNGImageDecoder()
  
  Global img_minimize = CatchImage(#PB_Any, ?minimize, 131)
  Global img_maximize = CatchImage(#PB_Any, ?maximize, 204)
  Global img_maximized = CatchImage(#PB_Any, ?maximized, 241)
  Global img_close = CatchImage(#PB_Any, ?close, 223)
  
  Procedure$ GetTitle(Object.i) ; Ok
    If IsGadget(Object)
      Protected *wg.WindowStruct = GetGadgetData(Object)
      If *wg And GadgetType(Object) = #PB_GadgetType_Canvas  
        ProcedureReturn *wg\Title$
      EndIf
    EndIf
    
    ProcedureReturn GetGadgetText(Object)
  EndProcedure
  
  Procedure SetTitle(Object.i, Text$) ; Ok
    If IsGadget(Object)
      Protected *wg.WindowStruct = GetGadgetData(Object)
      If *wg And GadgetType(Object) = #PB_GadgetType_Canvas  
        *wg\Title$ = Text$
        ProcedureReturn #True
      EndIf
    EndIf
    
    SetGadgetText(Object, Text$)
  EndProcedure
  
  Procedure Gadget(Object.i) ; Ok
    If IsGadget(Object)
      Protected *wg.WindowStruct = GetGadgetData(Object)
      If *wg And GadgetType(Object) = #PB_GadgetType_Canvas  
        ProcedureReturn *wg\Gadget
      Else
        ProcedureReturn Object
      EndIf
    EndIf
    ProcedureReturn Object
  EndProcedure
  
  Procedure Parent(Object.i) ; Ok
    If IsGadget(Object)
      Protected *wg.WindowStruct = GetGadgetData(Object)
      If *wg And GadgetType(Object) = #PB_GadgetType_Canvas  
        ProcedureReturn *wg\Parent
      Else
        ProcedureReturn Object
      EndIf
    EndIf
    ProcedureReturn Object
  EndProcedure
  
  Procedure.i Match(Value.i, Grid.i, Max.i=$7FFFFFFF)
    Value = Round((Value/Grid), #PB_Round_Nearest) * Grid
    If (Value>Max) : Value=Max : EndIf
    ProcedureReturn Value
  EndProcedure
  
  Procedure DrawContent(Gadget, w,h,Steps)
    Protected x,y, BackColor
    
    If StartDrawing(CanvasOutput(Gadget))
      If w > OutputWidth() : w = OutputWidth() : EndIf
      If h > OutputHeight() : h = OutputHeight() : EndIf
      
      CompilerIf #PB_Compiler_OS  = #PB_OS_Windows
        BackColor = GetSysColor_( #COLOR_BTNFACE )
      CompilerElse
        BackColor = $F0F1F2 ; D0D0D0
      CompilerEndIf
      
      Box(0, 0, w, h, BackColor)
      
      For x = 0 To w-1
        For y = 0 To h-1
          Plot(x,y,$000000)
          y+Steps
        Next
        x+Steps
      Next
      
      StopDrawing()
    EndIf
  EndProcedure
  
  Procedure DrawParent(*wg.WindowStruct)
    Protected bz, w, h, Alpha = 128 
    
    With *wg
      bz = \BorderSize-1
      w=GadgetWidth(\Parent)
      h=GadgetHeight(\Parent)
      
      If StartDrawing(CanvasOutput(\Parent))
        If w > OutputWidth() : w = OutputWidth() : EndIf
        If h > OutputHeight() : h = OutputHeight() : EndIf
        
        Box(0, 0, w, h, $E6E6E6)
        
        ;       DrawingMode(#PB_2DDrawing_Gradient)
        ;       BackColor($FCECDA)
        ;       FrontColor($FCE0C4)
        ;       LinearGradient(0, 0, 0, 30)
        ;       Box(0, 0, w, \CaptionSize+\BorderSize+1, $FBE8C7 | $80000000)
        
        DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
        Box(0, 0, w, h, $FBE8C7 | $80000000)
        
        ;       BackColor(#PB_Default)
        ;       FrontColor(#PB_Default)
        
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(0, 0, w, h, $6C6C6D)
        Box(\i\x-1, \i\y-1, \i\width+2, \i\height+2, $999999)
        
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawText(\BorderSize+1, 3, \Title$, $000000)
        
        ; Draw images
        ;If \Flag&#PB_Window_SystemMenu And 
        If IsImage(\Img\id[4])
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Box(w-30-7-4, 2, 26+4+4, 16, $3030FF | $80000000)
          
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Box(w-30-7-4, 2, 26+4+4, 16, $A9A9FF | $80000000)
          
          DrawingMode(#PB_2DDrawing_Transparent)
          DrawAlphaImage(ImageID(\Img\id[4]), w-24-8, 2, Alpha) ; 
        EndIf
        StopDrawing()
      EndIf
    EndWith
    
  EndProcedure
  
  Procedure ParentCallBack()
    Static OffsetX, OffsetY
    Protected w,h,Gadget = EventGadget()
    Protected *wg.WindowStruct = GetGadgetData(Gadget)
    w=GadgetWidth(Gadget)
    h=GadgetHeight(Gadget)
    
    With *wg
      Select EventType()
        Case #PB_EventType_LeftButtonUp
          SetGadgetAttribute(Gadget, #PB_Canvas_Cursor, #PB_Cursor_Default)
          
        Case #PB_EventType_LeftButtonDown
          OffsetX = GetGadgetAttribute(Gadget, #PB_Canvas_MouseX)
          OffsetY = GetGadgetAttribute(Gadget, #PB_Canvas_MouseY)
          
          If IsGadget(Gadget)
            OffsetX+(GadgetX(Gadget, #PB_Gadget_ScreenCoordinate)-GadgetX(Gadget, #PB_Gadget_ContainerCoordinate))
            OffsetY+(GadgetY(Gadget, #PB_Gadget_ScreenCoordinate)-GadgetY(Gadget, #PB_Gadget_ContainerCoordinate))
          EndIf
          
        Case #PB_EventType_MouseMove
          If GetGadgetAttribute(Gadget, #PB_Canvas_Buttons) 
            SetGadgetAttribute(Gadget, #PB_Canvas_Cursor, #PB_Cursor_Arrows)
            ResizeGadget(Gadget, DesktopMouseX()-OffsetX, DesktopMouseY()-OffsetY, #PB_Ignore, #PB_Ignore)
          EndIf
          
        Case #PB_EventType_Resize 
          ResizeGadget(Gadget, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
          
          \i\x = Match(\BorderSize, \Steps)
          \i\y = Match(\CaptionSize+\BorderSize, \Steps)
          \i\width = w-\BorderSize*2
          \i\height = h-\i\y-\BorderSize
          SetGadgetData(\Parent, *wg)
          
          DrawParent(*wg)
          ResizeGadget(\Gadget, \i\x, \i\y, \i\width, \i\height)
          DrawContent(\Gadget, \i\width, \i\height, \Steps-1)
          
      EndSelect
    EndWith
  EndProcedure
  
  Procedure CallBack()
    Protected Gadget = EventGadget()
    Protected *wg.WindowStruct = GetGadgetData(Gadget)
    PostEvent(#PB_Event_Gadget, EventWindow(), *wg\Parent, EventType());, *wg)
  EndProcedure
  
  Procedure Create(Gadget, X,Y,Width,Height, Title$="", Flag=0, Parent=-1)
    Protected *wg.WindowStruct = AllocateStructure(WindowStruct)
    
    With *wg
      ;       Debug Flag
      ;       Debug #PB_Window_SystemMenu
      \Flag = Flag
      \Title$ = Title$  
      \Img\id[4] = img_close
      \CaptionSize = 23
      \BorderSize = 5
      \Steps=5
      
      \Parent = CanvasGadget(#PB_Any, x,y, Width+\BorderSize*2,Height+\CaptionSize+\BorderSize*2, #PB_Canvas_Container) 
      \Gadget = CanvasGadget(Gadget, \BorderSize,\CaptionSize+\BorderSize,Width,Height, #PB_Canvas_Container) : If IsGadget(Gadget) : \Gadget = Gadget : EndIf
      CloseGadgetList()
      CloseGadgetList()
      
      SetGadgetData(\Parent, *wg)
      SetGadgetData(\Gadget, *wg)
      
      PostEvent(#PB_Event_Gadget, GetActiveWindow(), \Parent, #PB_EventType_Resize)
      ;PostEvent(#PB_Event_Gadget, GetActiveWindow(), \Gadget, #PB_EventType_Resize)
      BindGadgetEvent(\Parent, @ParentCallBack())
      BindGadgetEvent(\Gadget, @CallBack());, #PB_EventType_LeftButtonDown)
      
      OpenGadgetList(\Gadget)
      ProcedureReturn \Gadget
    EndWith
  EndProcedure
  
  Procedure Bind(Object.i, *CallBack, EventType=#PB_All)
    BindGadgetEvent(Parent(Object),*CallBack, EventType)
  EndProcedure
  
  DataSection ; minimize
    minimize:
    Data.b $89,$50,$4E,$47,$0D,$0A,$1A,$0A,$00,$00,$00,$0D,$49,$48,$44,$52,$00,$00,$00,$10
    Data.b $00,$00,$00,$10,$08,$06,$00,$00,$00,$1F,$F3,$FF,$61,$00,$00,$00,$4A,$49,$44,$41
    Data.b $54,$78,$DA,$ED,$CF,$31,$0A,$00,$20,$0C,$03,$40,$2B,$38,$76,$F1,$07,$EE,$D5,$FF
    Data.b $FF,$4E,$33,$14,$04,$29,$A2,$B8,$38,$34,$70,$53,$68,$A0,$C1,$E3,$F9,$32,$04,$F1
    Data.b $10,$59,$C7,$FD,$10,$43,$5A,$07,$E2,$C5,$40,$01,$B6,$06,$58,$4B,$81,$0A,$CD,$20
    Data.b $60,$0E,$10,$24,$2D,$F2,$D6,$7C,$E1,$3D,$03,$D5,$61,$16,$C4,$CD,$6D,$97,$D8,$00
    Data.b $00,$00,$00,$49,$45,$4E,$44,$AE,$42,$60,$82
    minimize_end:
  EndDataSection
  
  DataSection ; maximize
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
    maximize_end:
  EndDataSection
  
  DataSection ; maximized
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
    maximized_end:
  EndDataSection
  
  DataSection ; close
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
    close_end:
  EndDataSection
EndModule

;-
Macro wg(Object) ; Ok
  wg::Gadget(Object)
EndMacro

Macro wgParent(Object) ; Ok
  wg::Parent(Object)
EndMacro

Macro wgTitle(Object) ; Ok
  wg::GetTitle(Object)
EndMacro

Macro WindowGadget(Gadget, X,Y,Width,Height, Title="", Flag=0, Parent=-1)
  wg::Create(Gadget, X,Y,Width,Height, Title, Flag, Parent)
EndMacro

Macro BindGadgetEvent(Gadget, CallBack, EventType=#PB_All) ; Ok
  wg::Bind(Gadget, CallBack, EventType)
EndMacro


;- Example
CompilerIf #PB_Compiler_IsMainFile
  Enumeration
    #Window
  EndEnumeration
  
  Procedure Resize()
   
    Transformation::Update(EventGadget())
    
  EndProcedure
  
  Procedure OpenWindow_0()
    OpenWindow(#Window, 0, 0, 600, 400, "WindowTitle", #PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
    
    WindowGadget(2,30,30,100,100)
    CloseGadgetList()
    WindowGadget(3,60,60,100,100, "", #PB_Window_SizeGadget|#PB_Window_MinimizeGadget)
    CloseGadgetList()
    BindGadgetEvent(2, @Resize())
    
    Transformation::Create(wgParent(2), #Window,#Window, 0, 5)
    Transformation::Create(wgParent(3), #Window,#Window, 0, 5)
    
  EndProcedure
  
  OpenWindow_0()
  
  Repeat
    
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        End
    EndSelect
    
  ForEver
CompilerEndIf

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 377
; FirstLine = 203
; Folding = EAA++zBg7
; EnableXP