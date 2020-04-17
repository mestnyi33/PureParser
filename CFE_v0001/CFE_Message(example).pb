CompilerIf #PB_Compiler_IsMainFile
  
  XIncludeFile "CFE.pbi"
  
  Enumeration Message 1    ; Return value
  #_Flag_Message_Yes     ; the 'yes' button was pressed
  #_Flag_Message_No      ; the 'no' button was pressed
  #_Flag_Message_Cancel  ; the 'Cancel' button was pressed
EndEnumeration 

EnumerationBinary MessageBinary 1<<#_Flag_Message_Cancel
  #_Flag_Message_Ok       ; To have the 'ok' only button (Default)
  #_Flag_Message_YesNo    ; To have 'yes' Or 'no' buttons
  #_Flag_Message_YesNoCancel  ; To have 'yes', 'no' And 'cancel' buttons
  
  #_Flag_Message_Error        ; displays an error icon
  #_Flag_Message_Warning      ; displays a warning icon
  #_Flag_Message_Info         ; displays an info icon
EndEnumeration

;   CompilerIf Not Defined(_Message_Yes, #PB_Constant)
;     Enumeration Message 1    ; Return value
;       #_Flag_Message_Yes      ; the 'yes' button was pressed
;       #_Flag_Message_No       ; the 'no' button was pressed
;       #_Flag_Message_Cancel   ; the 'Cancel' button was pressed
;     EndEnumeration 
;     
;     EnumerationBinary MessageBinary 1<<#_Flag_Message_Cancel
;       #_Flag_Message_Ok           ; To have the 'ok' only button (Default)
;       #_Flag_Message_YesNo        ; To have 'yes' Or 'no' buttons
;       #_Flag_Message_YesNoCancel  ; To have 'yes', 'no' And 'cancel' buttons
;       
;       #_Flag_Message_Error        ; displays an error icon
;       #_Flag_Message_Warning      ; displays a warning icon
;       #_Flag_Message_Info         ; displays an info icon
;       
;       #_Flag_Message_DefButton1         ; displays an info icon
;       #_Flag_Message_DefButton2         ; displays an info icon
;       #_Flag_Message_DefButton3         ; displays an info icon
;       
;     EndEnumeration
;   CompilerEndIf

  Global INFO = CatchImage(#PB_Any, ?INFO_png_start, (?INFO_png_end-?INFO_png_start))
  Global ERROR = CatchImage(#PB_Any, ?ERROR_png_start, (?ERROR_png_end-?ERROR_png_start))
  Global WARNING = CatchImage(#PB_Any, ?WARNING_png_start, (?WARNING_png_end-?WARNING_png_start))
  ;INFO = LoadImage(-1, #PB_Compiler_Home + "examples/sources/Data/world.png")
  ResizeImage(INFO, 36,36);, #PB_Image_Raw)
  ResizeImage(ERROR, 36,36);, #PB_Image_Raw)
  ResizeImage(WARNING, 36,36);, #PB_Image_Raw)
  
  Global MessageText$ = "Вы точно уверены что, хотите выйти?"+Chr(10)
  
  Enumeration Element ; Window
    #Window_0
    #Window_1
  EndEnumeration
  
  Enumeration Element ; Gadget
    #Button_1
    #Button_2
    #Button_Close
  EndEnumeration
  
  Procedure Windows_Events(Event.q, EventElement.i)
        
    Select Event 
      Case #_Event_MouseMove, #_Event_MouseEnter, #_Event_MouseLeave, #_Event_Drawing; #_Event_Close, #_Event_Create, #_Event_Focus, #_Event_LostFocus, #_Event_LeftButtonDown, #_Event_LeftButtonUp, #_Event_LeftClick
      Default
        If IsGadgetElement(EventElement)
          Debug " allgadget id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
        EndIf
        
        If IsWindowElement(EventElement)
          Debug " allwindow id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
        EndIf
    
    EndSelect
    
    ;ProcedureReturn #PB_ProcessPureBasicEvents
  EndProcedure
  
  Procedure Window_Event(Event.q, EventElement.i)
    
    Select Event 
      Case #_Event_Focus, #_Event_LostFocus, #_Event_LeftButtonDown, #_Event_LeftButtonUp
        Debug " window id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
        
      Default
    EndSelect
    
    ;ProcedureReturn #PB_ProcessPureBasicEvents
  EndProcedure
  
CompilerEndIf


Procedure StickyWindowElement_(OpenWindowElement, State)
  Protected Result
  
  With *CreateElement
    If IsWindowElement(OpenWindowElement)
      PushListPosition(\This())
      ForEach \This()
        If IsChildElement(\This()\Element, OpenWindowElement) = 0
          \This()\Interact = State
        EndIf
      Next 
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

CompilerIf #PB_Compiler_IsMainFile
  Procedure MessageButtonsEvent(Event.q, EventElement)
    Protected Result
    
    Select Event 
      Case #_Event_MouseMove, #_Event_MouseEnter, #_Event_MouseLeave, #_Event_Drawing; #_Event_Close, #_Event_Create, #_Event_Focus, #_Event_LostFocus, #_Event_LeftButtonDown, #_Event_LeftButtonUp, #_Event_LeftClick
      Default
        If IsGadgetElement(EventElement)
          Debug " Message allgadget id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
        EndIf
        
        If IsWindowElement(EventElement)
          Debug " Message allwindow id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
        EndIf
        
    EndSelect ; Debug " Message id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
        
    Select Event 
      Case #_Event_Create
        With *CreateElement
          \This()\Show = #True
          
          ;
          If IsGadget(\Canvas) And StartDrawing(CanvasOutput(\Canvas))
            DrawingFont(GetGadgetFont(#PB_Default)) ; Шрифт по умолчанию
            DrawingMode(#PB_2DDrawing_Default) 
            SetOrigin(0,0) : DrawingElement(\This())
            StopDrawing()
          EndIf
          
          ;
          StickyWindowElement_(EventElement, #False)
        EndWith
        
      Case #_Event_LeftClick
        If IsGadgetElement(EventElement)
          Select GetElementData(EventElement)
            Case #_Flag_Message_Yes    : Result = #_Flag_Message_Yes
            Case #_Flag_Message_No     : Result = #_Flag_Message_No
            Case #_Flag_Message_Cancel : Result = #_Flag_Message_Cancel
          EndSelect
        EndIf
      
      Case #_Event_Close : Result = GetElementData(EventElement)
      Case #_Event_Free   
        Debug "Free "+EventElement
;                *CreateElement\Bind\Window = 1
;                  *CreateElement\Bind\Element = 4
;                  *CreateElement\Bind\Event = #_Event_LeftClick
;         
        ;SelectElement(*CreateElement\This(), Element(4))
        ;PostEventElement(#_Event_MouseLeave, 4)
        ;ElementCallBack(#_Event_MouseLeave, 4)
        
        ;         SetActiveElement(1)
        ;         SetForegroundWindowElement(1)
    EndSelect
    
    If Result
      StickyWindowElement_(EventWindowElement(), #True)
      
      CloseWindowElement(EventWindowElement())
      
      PostEvent(#PB_Event_CloseWindow, EventWindow(), EventGadget(), EventType(), Result)
    EndIf
    
     
   ; ProcedureReturn #True
  EndProcedure
  
  Procedure MessageElement( Title.S, Text.S, Flag = 0, Parent =- 1 )
    Protected OpenElementList; = OpenElementList(0)
    Protected Line, Info_Text =- 1, Info_Image =- 1
    Protected bh = 22
    Protected tp = 15
    Protected st = 5
    Protected h = 130
    Protected w = 320
    Protected CaptionHeight
    Protected Image =- 1
    
    If ((Flag & #_Flag_Message_YesNoCancel) = #_Flag_Message_YesNoCancel)
      w = 320                                                                                                                                                                         ;
    ElseIf ((Flag & #_Flag_Message_YesNo) = #_Flag_Message_YesNo)
      w = 240                                                                                                                                                                   ;
    ElseIf ((Flag & #_Flag_Message_Ok) = #_Flag_Message_Ok)
      w = 180                                                                                                                                                                     ;
    EndIf
    
    If ((Flag & #_Flag_Message_Info) = #_Flag_Message_Info)
      Image = INFO                                                                                                                                                                         ;
    ElseIf ((Flag & #_Flag_Message_Error) = #_Flag_Message_Error)
      Image = ERROR                                                                                                                                                                       ;
    ElseIf ((Flag & #_Flag_Message_Warning) = #_Flag_Message_Warning)
      Image = WARNING                                                                                                                                                                        ;
    EndIf
    
    Protected Element; = CreateElement( #_Type_Window, #PB_Any, #PB_Ignore,#PB_Ignore,w,h,"", #PB_Default,#PB_Default,#PB_Default, #_Flag_ScreenCentered|#_Flag_SystemMenu )
     Element = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore,w,h, "Demo 13",#_Flag_ScreenCentered|#_Flag_AnchorGadget);,0) 
;      ButtonElement(#PB_Any,10,10,80,30, "Нет");,0,Element)

    Info_Image = ImageElement(#PB_Any,st,st+tp,60,h-bh-st*2-10, Image,#_Flag_Image_Center|#_Flag_BorderLess)                                                  ;
    Info_Text = TextElement(#PB_Any,60+st*2,st+tp,w-st*3-60,h-bh-st*2-10, Text,#_Flag_Text_Top|#_Flag_Text_Center|#_Flag_Transparent);|#_Flag_BorderLess)    ;
    Line = CreateElement(#_Type_Text, #PB_Any,0,5+(h-bh-5-10)+tp,w,1, "", #PB_Default,#PB_Default,#PB_Default)                                                                                                                                               ;,#_Flag_Image_Center|#_Flag_Text_Center|#_Flag_BorderLess);|#_Flag_Transparent)                                                  ;
    SetElementFont(Info_Text, FontID(LoadFont(#PB_Any, "Arial", 10.5)))
    ;                                                                                                                                                                                                                                                                              SetElementTitle( Element, Title )
    SetElementText( Element, Title )
    
    Protected Yes, No, Cancel, No_X, Yes_X, Cancel_X, by = h-bh-5+tp
    
    If ((Flag & #_Flag_Message_Ok) = #_Flag_Message_Ok) 
      Yes = 1 : Yes_X = w/2-40
    ElseIf ((Flag & #_Flag_Message_YesNo) = #_Flag_Message_YesNo) 
      No = 1 : No_X = (w+st)/2                                                                                                                                                                         ;
      Yes = 1 : Yes_X = (w-st)/2-80
    ElseIf ((Flag & #_Flag_Message_YesNoCancel) = #_Flag_Message_YesNoCancel)
      No = 1 : No_X = w/2-40                                                                                                                                                                                      ;
      Yes = 1 : Yes_X = (w-st*2-80)/2-80
      Cancel = 1 : Cancel_X = (w+st*2+80)/2                                                                                                                                                                          ;
    EndIf
    
    If Yes 
      Yes = ButtonElement(#PB_Any,Yes_X,by,80,bh, "Да") 
      If (No = 0 And Cancel = 0)
        SetElementText( Yes, "Ok" )
      EndIf
    EndIf
    If No : No = ButtonElement(#PB_Any,No_X,by,80,bh, "Нет") : EndIf
    If Cancel : Cancel = ButtonElement(#PB_Any,Cancel_X,by,80,bh, "Отмена") : EndIf
    
    SetElementData( Yes, #_Flag_Message_Yes )
    SetElementData( No, #_Flag_Message_No )
    SetElementData( Cancel, #_Flag_Message_Cancel )
    SetElementData( Element, #_Flag_Message_Cancel )
    
    SetActiveElement(Yes)
    
    
    BindEventElement(@MessageButtonsEvent(), Element, #PB_Ignore, #_Event_Create|#_Event_Close|#_Event_Free)
    BindGadgetElementEvent(Yes, @MessageButtonsEvent(), #_Event_LeftClick|#_Event_Free)
    BindGadgetElementEvent(No, @MessageButtonsEvent(), #_Event_LeftClick|#_Event_Free)
    ;BindGadgetElementEvent(@MessageButtonsEvent(), Cancel, #_Event_LeftClick|#_Event_Free)
    CloseElementList()
    
    ProcedureReturn WaitWindowEventClose(OpenElementList)
  EndProcedure
  
  Macro AddConstant(Constant,Value = #PB_Compiler_EnumerationValue)
    CompilerIf Defined(Constant, #PB_Constant) = #False
      CompilerIf Value = #PB_Compiler_EnumerationValue
        Enumeration #PB_Compiler_EnumerationValue +3
          #Constant# 
        EndEnumeration
      CompilerElse
        #Constant#=Value
      CompilerEndIf  
    CompilerEndIf
  EndMacro
  ProcedureDLL$ ULCase(String$)
    ProcedureReturn InsertString(UCase(Left(String$,1)), LCase(Right(String$,Len(String$)-1)), 2)
  EndProcedure
  
  ProcedureDLL$ ULUCase(String$)
    Protected i,Field$
    Static Result$
    For i =1 To CountString(String$, " ") +1
      Field$=StringField(String$, i, " ")
      Result$ + InsertString(UCase(Left(Field$,1)), LCase(Right(Field$,Len(Field$)-1)), 2) +" "
    Next i
    ProcedureReturn Trim(Result$)
  EndProcedure

  Procedure Button_Event(Event.q, EventElement.i)
    
    Select Event 
      Case #_Event_Focus, #_Event_LostFocus, #_Event_LeftButtonDown, #_Event_LeftButtonUp
        Debug "Button_Event gadget id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
        
      Default
    EndSelect
    
    ;ProcedureReturn #PB_ProcessPureBasicEvents
  EndProcedure
  
  Procedure ButtonClick(Event.q, EventElement.i)
    
    Select Event
      Case #_Event_LeftClick
        Debug " ButtonClick id="+Str(EventElement)+" ev="+ LCase(EventClass(Event))
       
        If MessageElement("Предупреждение", MessageText$, #_Flag_Message_YesNo) = #_Flag_Message_Yes       
                     Debug 888888
                     Debug EventWindowElement()
                     
          CloseWindowElement();EventWindowElement())
        EndIf
    EndSelect
    
    ;ProcedureReturn #True
  EndProcedure
  
  Define w = OpenWindowElement(1, 0,0,800,650,"Window_0")
  If w
    ButtonElement(#PB_Any, 10,10,100,20,"Button_0")
    ButtonElement(#PB_Any, 10,35,100,20,"Button_1")
    
    Define Button_Close = ButtonElement(#PB_Any, 5,5,100,20,"Close", #_Flag_AlignRight|#_Flag_AlignBottom)
    
     SetElementFont(Button_Close,FontID(LoadFont(#PB_Any, "Arial"  ,  12, #PB_Font_Bold)))
    
    ;SetElementFont(Button_Close,GetElementFont(#PB_Any))
    
    ;RemoveElementFlag(Element, #_Flag_SystemMenu)
    ;SetElementFlag(Element, #_Flag_SystemMenu)
    ;RemoveElementFlag(Element, #_Flag_SystemMenu)
    
    ;SetElementFlag(Element, #_Flag_TitleBar);#_Flag_BorderLess)
    ;RemoveElementFlag(Element, #_Flag_MoveGadget)
    
  Debug "MessageElement "+MessageElement("Title", MessageText$, #_Flag_Message_YesNoCancel|#_Flag_Message_Info)
    ;Debug "MessageElement "+MessageElement("Title", MessageText$, #_Flag_Message_YesNo|#_Flag_Message_Error)
    ;Debug "MessageElement "+MessageElement("Title", MessageText$, #_Flag_Message_Ok|#_Flag_Message_Info)
    
    
    ;Debug Button_Close
    BindGadgetElementEvent(Button_Close, @ButtonClick(), #_Event_LeftClick) ; #_Event_Create|#_Event_Focus|#_Event_LostFocus|#_Event_Move);
    
    
    ;     BindWindowElementEvent(@Window_Event(), 1)
    ;     BindGadgetElementEvent(@Button_Event());, 3)
    ;BindEventElement(@Windows_Events())
    
    ;OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore,200,100,"",#_Flag_ScreenCentered)
    
    WaitWindowEventClose(w) 
    End
  EndIf
  
CompilerEndIf



DataSection
  bINFO_png_start:
    ; size : 1612 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$2A0000002A000000,$5EA14A0000000208,$594870090000000C
    Data.q $1200007412000073,$0000781F66DE0174,$DA7854414449FE05,$C71457D34C7B98D5,$259A999854414B6F
    Data.q $9669B74D9732E2BE,$DC4B6E63FB66896C,$3A81C13717399316,$4D4451E5293E80EA,$B18F9D448898F9D0
    Data.q $50A56D0ADAB821B2,$A1E50ABC1F62CF28,$50ABF790F202D7F4,$8E07F76EDA51E50A,$CBF659028FE9573A
    Data.q $3DCE73DCE7ECFF49,$C0FD3FF3F82E7BE7,$96CC26D9B36F03FF,$E9129F4B6D637EF6,$26B37429E16AADC8
    Data.q $75D52B6C3E906928,$62CA69833EFAED21,$DB9B8E8F043C345D,$3559EB9EC6EA8DFA,$C5BC64CE7BA4B781
    Data.q $FC16EDA7370382E0,$F2FFCE3AEF63F6F5,$D3AE57056DC45642,$2CA7269835E8193C,$58B309A6F182DB36
    Data.q $82406373363074D5,$C9DCD202CB6FFF97,$22055610628C6EB9,$C716BC2047C8821E,$9E5941EEE5D020AC
    Data.q $93D077B08FAB3947,$C0F43D76BA8509A9,$A135320C218C3C75,$A044452D7F167DE0,$080568404A42E116
    Data.q $A76944042CA941AF,$88740AEA0D2C010D,$EB79A9CB95D3C2A1,$95A42E094F8FFC29,$30C10F1BCEF73755
    Data.q $37893FFD908A77CD,$88608009608484D0,$E12BA0D8BE459A8C,$1DBD1408F32A80D5,$4D8C33C01FB2A42E
    Data.q $6B643802651D594E,$2D187D5666AE06DB,$B8F42294034C4158,$CC083530B6FFA94E,$961127183B494F5E
    Data.q $E736AD598F0FF434,$736A8158D1C1EEF8,$A786A1A0E3F03250,$2C807591633D8171,$8C327A1DE5387E5D
    Data.q $EF313E39C269B0C1,$F43CC3F8F9C707E1,$E01EDFF675C42CD0,$71589BFB0F824A68,$4AB16CDE1739D231
    Data.q $DD077866CF7BCDD4,$EA4ECBD9B9B28C07,$A8AA264D450DAB6E,$8A692AB4100F4E67,$A6AAF2496138C7B5
    Data.q $2C71BD189878C75E,$1E50109A3ACE5AE0,$5E9AF5538AF98D38,$10B2988394579834,$0D433570423DBD98
    Data.q $A678C8E0FC0397DB,$C3CE40872A75E9AA,$3D32B174271E6B52,$4AC6176A70F866A7,$3454925C0E0A20F4
    Data.q $D3760DAD878F3F74,$28C042415E45E77D,$96E964645FBE685F,$F02BD9F2C951FBD0,$AF3654929E613F14
    Data.q $BF7D39442DC5FFF1,$FACA49E35E1F0697,$ED32DC7461AA64F4,$7C73A1AEE3FC53C1,$D4C4ACC71127C115
    Data.q $552975279EB4A25B,$1583D19689B35906,$DC216D82E4F042CF,$AF14F84B99E3D54C,$5247002D5DF874D0
    Data.q $D1ACDE95F99877B1,$BB287F5382A81B14,$8FC6B2F4F8ED4706,$BBC8F61E70413262,$BDBE4BA6AD550F88
    Data.q $A453E3B06BD2D998,$EF6294603E4CAD9A,$4518BC6BC3E22E71,$FC76839DF53822BB,$87F6849BEF0AA125
    Data.q $A68E0D2CF1696428,$8ECFB9A6BE3AFF70,$8B4F9F88015028BF,$D5F6E25E8D0F1175,$FE7CFC4FFC4199E5
    Data.q $F3F00BE9487C75C5,$7E2F4011E2AE6E19,$9E4FF4F4AA2F1F1E,$A787591F117388D7,$8ED64D835E0FBDC9
    Data.q $2107DE4476432BBF,$ED5F95C4B75580C5,$0D7635E68EEE90CD,$2D393F8FE519F1D9,$7894BFC5D3394106
    Data.q $E27177F67A1AF946,$19DB44BE3B61DED6,$F5DE4BB9FC0A4370,$B2D4B9FE548DF2A8,$70DF6B5EBA67A19E
    Data.q $33250D97C3CAA8BC,$A4F0696782BBF4C6,$2327DAC2DCA1EDFC,$5F92D9A4FC769363,$30CBA0489891BADD
    Data.q $2C8BDA987C15DFC6,$9F584D3468467BDE,$C6F80DB4D3F0789D,$52E5EF069814BD65,$B8630A64DFF383E1
    Data.q $D352868C0ED40E25,$42A09240877695B1,$AA624F0ACCF1D17D,$AD23BD0EFADC95FF,$D2D8304E8D0DB367
    Data.q $D6AA2E15200174CD,$4E8CED144A41D043,$958E2CA79AD6E767,$2CB9F7E0E0305C2E,$07B73CC1C2164B59
    Data.q $34AA481A2B9DEB50,$E0D787613A75E21C,$195E18DCC89B0548,$DAE4F3E744E036D2,$A2A2EF471E45A73D
    Data.q $E3650B02616EB22F,$E7AEC7897E95D229,$1160335F38F63657,$3E024A42DEAECCDC,$704E5BA17195C3BF
    Data.q $94EF42F7C4BF0AFE,$AF0F1CE9454177D7,$A767ED32B92FDC04,$2C7CA401CF7E57D3,$A55FBE60D6B0E895
    Data.q $3466B6C0146F02F2,$C5AE1B4C366CDA4D,$E216EA249835ED6A,$E90FFBBE0C2D828D,$98B460462AC56370
    Data.q $89E76D3127B4E86A,$2D5C3743556F9874,$AD5A257B5C37186C,$9C5FA57BC7E3A44A,$E0E520F7490A6F15
    Data.q $11C3540016285228,$BB0C83410524CFB5,$C0B91BAC160AA875,$5E28785306F5929B,$A0BF5DB6AD6E6BF2
    Data.q $13ED6929C9F18DD7,$3851AF681421426A,$19CB3968AB8590AF,$941A136B46D8E00F,$3532FA4317A5740F
    Data.q $79F39D1B75391D6B,$90F753716EE63F0C,$EF334B4F08BACA79,$88BA14F7A3833D4A,$291977A2F3FED924
    Data.q $F3FBE55B59E5DF60,$4B386271BE7BE8EE,$D3AB56E32343AFA0,$415DA16CBDF99D77,$0E743637EB6F1C6F
    Data.q $B59AEFAB2FED6A3E,$2AEE007DA41EC68A,$6AC5A4D8E311FA9D,$02FEFA25B587E45B,$22E75BF76E544E17
    Data.q $444E454900000000
    Data.b $AE,$42,$60,$82
  bINFO_png_end:
EndDataSection

DataSection
  bERROR_png_start:
    ; size : 2238 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$2B0000002B000000,$E63F6E0000000208,$5948700900000097
    Data.q $1200007412000073,$0000781F66DE0174,$DA78544144497008,$F7166753578958DD,$E8F59B202179187F
    Data.q $8838556564088038,$8A38A1DA50479B0B,$A55A95A716B6A5C5,$9D455AD45699CE0E,$D2AD5B638E95B8EA
    Data.q $593613408A052253,$096C20100B610B64,$FB98F79797D65ED9,$7339C5A424826940,$BDF2739393BE7266
    Data.q $F7BBFBBFBDDF7F77,$FF659FDBFFA6CB7E,$3F4C302492480833,$C7EB9ACA12ECAA3E,$B86B7385C7921504
    Data.q $D4696F205EA268AC,$AFE381390A8C7B88,$B8FD7AF5C6D80112,$39B37BBBED6C2154,$A42E3CB9233AAB27
    Data.q $177CCFDF5872ED70,$F83DAD8AED557B05,$D50F7886A7B3B6C7,$C336613929C6DD7D,$2B48306E0100AFC3
    Data.q $F1F84616F647054B,$DB9676F760825E18,$B4B9C9A1CE3E9B00,$B43949A1C64D2E29,$7824F6E999BD365E
    Data.q $86F0F8E3D57B1145,$52C40A3E819AD9D3,$D9B98DDBC1338010,$D9BA6B1175D1C955,$392646CA4D1641F4
    Data.q $E0B33D4D08556194,$2C234C01A14B9287,$A3F27AE0ED72CC44,$573ED78513D32AFC,$4382D2020B7FDA8A
    Data.q $7A70E6B6FFBE07C8,$D6236C030B7FB475,$5C026D08652C1D56,$B084826E181A44C2,$468C586386CD7F67
    Data.q $2D458B4808B39220,$56C6F55EB829E9EE,$1D5A1D419BB3CB01,$4209691B18D7ABF2,$970C65EF75FE51F8
    Data.q $214E1049054A4CF1,$A38BF2374426C830,$9D4ED948BBF857D6,$A40C5D697052DEDB,$C278185C7145682C
    Data.q $9FFF77D0429D45AC,$2FA3A802AB9BA995,$E78D167E881CFCC5,$D3F3591EEEF35AEF,$AF2E7F46F5001045
    Data.q $858867D71D7AFFDE,$62A4814F2CFCDD2C,$1C99EB75743CAD26,$932410045D9B6745,$BF289A9DFC77594A
    Data.q $0AC44B7B9CA2061E,$09A16F93FA4DDEED,$44D49A8BEEE1D4EB,$403F670D22D368FB,$689E736EE1D40213
    Data.q $5C17778527E17409,$4AB53008C2D860B7,$D2676CCB1652515A,$D7FA6313DDA7A9AD,$DD1278BC6049BC55
    Data.q $E51F32387A4750C1,$D2C57BBA6F1FDBA3,$641EDD1F799C322F,$7B23FAB7609ACC4D,$AA924042165BDAA6
    Data.q $7BC72D5A60FF216E,$09F9F0D4BF588598,$0A55266E34C76F4B,$4F5DA60EE807DE43,$916EEFB0B7807A44
    Data.q $742BEBC705B4FD46,$6CD656006F5BB787,$E78A4EB5CF9CB461,$B588F01809982C08,$0C7EB7BC874D9FAA
    Data.q $E21E834899C3614D,$70A872978CA6AA44,$6215DD15D43E6CBC,$A93CC143A901F1FE,$C1FEB66BF673EA56
    Data.q $9E51ED99B6B80F7A,$041B79C81AA1849E,$7F3C0BB5D740D0E8,$DDA9E0DFFCCBE8DA,$9B81028173BA6D1D
    Data.q $89A0CE3FE35EC189,$46FB4BD1BF9C6DEB,$8D313E4242A7F9B8,$0CF6FB90C8B11661,$2B4193B2B1E7DC0F
    Data.q $CCCB9D28AD2216DF,$1D8E9AEB1B2608E7,$1B347C505973AC10,$F1F210AF771029BD,$30BC40A14104CC69
    Data.q $F186DCCDA95E89A0,$68EDFE12729526BE,$1A0BFD3A9C767C34,$6FF28EA913312F5A,$91820D8EA809F8BB
    Data.q $97208EF8F4DAE2F2,$8B93BA04F6B02179,$2104004A8C43BC3D,$69664D18FA5E35E9,$200F60260EE8D762
    Data.q $03361166336986F6,$C23AA8F6FE713561,$93A73A86AE459E46,$E38FC0128020D90E,$42D33F6B9288584A
    Data.q $1B2136EEFB1260E9,$EB65CE1856A988A7,$8859EA19AC0377B3,$20E7E71355503121,$2925DE615DC7C059
    Data.q $E6E88106D8A0E8B1,$01ED68BE443F12E5,$74092620BCE4EDBA,$A7A8A5AF52321523,$C2F9B66A64E7D29A
    Data.q $5F6BE9D40B75C71E,$F91B822D87576557,$6259C1129DCBBE25,$8A747098966CFEDE,$F1A10E5FFD427D19
    Data.q $116B7BD99416494E,$B02D0A4E042168A5,$4D9E640930FA70CC,$A3D36BD6B786336B,$00E25C799D3C1B34
    Data.q $43BA3ED1F319D281,$A06E51EA5986C089,$712C053FCC67D988,$085CC03909B398AC,$17DD034A2F9DD741
    Data.q $C2B19B197AA0862F,$7FE0C30705BCCA02,$9C32A35311463642,$14040E39614D10FF,$552F40FDEB963E88
    Data.q $8287A2C1820DA777,$C21720E14E8011ED,$6911ECB9A86A68E8,$F627F5CA53D451D0,$9CFF957D366DF769
    Data.q $189A2E72F1951A98,$95F0A24FB40100E0,$041B7E92A025A53F,$0B6A4A7FB52527D2,$5A5EA94041DB9172
    Data.q $2339315207E2B9A4,$7F789A03A9FD424A,$473CDD346FA612AA,$F3ADD3484871C2C1,$9A7450043DA05268
    Data.q $8749D4CD1F575723,$BC4F9A1A5BC8106D,$EA57A313476FE55B,$40E521F7C563C40E,$34C7B386A7B6F0F5
    Data.q $400E051EAACED65B,$6270294726225C14,$1623B64A39D6E991,$13AF47E1031F4708,$D020D99728C1717E
    Data.q $3AD17BF9DCF48E8D,$4EDFE6502A25F4BA,$6F54669A497D1EC2,$1407A44EC9E77456,$229064620DFEEC30
    Data.q $E14D172578D890E6,$5AE183BD302623CC,$5A75C7C7513E109E,$FAA9AF1B1984041B,$102F36ED87AFC221
    Data.q $EC1E4E0F99CF6690,$C5059D92947A7C35,$71C09E010293076A,$C0579FDEF21B5512,$CCCAEF10A6B438C6
    Data.q $E97FA0573B4EB354,$E7C7DAC9A9D06050,$4FB5E303FB6C48FA,$FE990A7A8A7EE188,$801EA9EDF394BDA3
    Data.q $827148BCBE996648,$F5AA565D26C22C20,$5FB4E38822306106,$A6B25C0247B85BCE,$C27D26569C2D92FA
    Data.q $9A9FEBC6C3200D8A,$77CE53F78FFAA505,$5E306E6FAE907AAC,$B5EF8FE8B5116D3D,$3FBB07E1D4600FEE
    Data.q $27DBB6203350763D,$31048FB7F4D0E342,$1DDC313EAB60A281,$F4EA0ECEF74C3D7D,$F02F46D64B8B6E61
    Data.q $B3E9FB33DDC3FE84,$608BBD61B725042A,$CA379ABF6FBEA6D7,$EAEA9AC92A379B2D,$5C85035889ABEE8E
    Data.q $064EAFC8657A8AF9,$660F3978403A24F2,$3F11EF0905E7C5A1,$50ED986DC832B923,$05E574C5DF369CA0
    Data.q $E2D1D14F7C9C3679,$DDEF7AE9D662C4D4,$08F977D1F8C31C7E,$E3EC02B8DA5CA69B,$35B54D4527147905
    Data.q $301048DCDCEA3743,$E52919F90F784AB6,$1B9A6FC4C5782F4C,$C6C0988AFB107A81,$C90C6806B3F92C9C
    Data.q $E316CECDEC13AE85,$08E278DE5F947C94,$E197BD3069E3337F,$A9EF207642F2FF44,$F62163520BB863C4
    Data.q $19B73B14A6027A70,$1D7A4C07000FEE8E,$098DACEE66D7CF57,$4C83683177B96568,$4744BF38C88D9464
    Data.q $2603CBD9C9EDE335,$6C11F50E6D74C9D2,$029BEFB339FDD763,$262C50EF52EF7F4D,$94D2ECE9E3688823
    Data.q $6FBF9135C131654D,$858073D427AD7F0D,$2E9B3130502CCF0C,$C1B5555F0A6EF30A,$2DA52322B72B6CB7
    Data.q $2BF370212C3B4F3F,$325A82C6B99AC9BA,$0F9FA9DE59F0B8F4,$EFF56F79189C59BD,$84B4F29F6083D6E6
    Data.q $0BD44CE4A0B7ACEA,$912E275D129A8D30,$0C71C0801E6DCD7E,$1EAAB9B42931A126,$833482DCD36B54D1
    Data.q $AD6E3930C7B18744,$CFB9FF89F75FFFF9,$9F6530C1B8D601BF,$454900000000C17C
    Data.b $4E,$44,$AE,$42,$60,$82
  bERROR_png_end:
EndDataSection

DataSection
  bWARNING_png_start:
    ; size : 1150 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$2B0000002B000000,$E63F6E0000000208,$5948700900000097
    Data.q $1200007412000073,$0000781F66DE0174,$DA78544144493004,$C718659B685B98C5,$30A6514DBA9D849F
    Data.q $651042F684F3875B,$3225763642F44E88,$870C2222A57A2194,$228A98E6E2576DCE,$4DBBC444C981E1D4
    Data.q $B5D269B673714411,$D36BA4D7CDAEBF7D,$61E8775CC9A68736,$CFBFDEFBEED34999,$4934D7EA736CC39B
    Data.q $EFFF2FCFB6CB9E3F,$A1FB961293EF7F79,$A987DEB89A557FF2,$8B3981132E8F4C2E,$975FA5C5EDF067E0
    Data.q $59ED04B9981A4083,$E6BC460074301A38,$709B5C3DFA3EDC04,$E6BA7AB81D9E8EC6,$2758A467B40F3104
    Data.q $25B5DDFE8DDC4105,$BD356E5A00A98E48,$B6D055B9E4807376,$4C115A899839DAE2,$C986322E0BBBC2B4
    Data.q $E0C068E84BD32118,$2048C084D62F247E,$208C9D4A776D147C,$EF38315307326119,$4C13EAD9C86EB5C3
    Data.q $B74B66D955F7859E,$23579A13F431C557,$0E0413EA81E229F8,$6553EDB27B203C43,$E5705B687614930E
    Data.q $E808F904B0126ACF,$3025CFC9C358A53B,$8C3C11EB9C18A942,$9F820CE6046AB844,$0479F92ADD346B40
    Data.q $EC6077D041D90829,$C5D46A1BC810EA97,$7DB73027CB5B52D3,$3EE0C76FDA287B38,$910C66608156FF18
    Data.q $DC7F1B1E983570E3,$DB3D0D8418E90402,$0ABA6209960D3517,$47A7DA457D35AC40,$95DBFF406C8AC3D2
    Data.q $6825A5DFA3FCE026,$80723A7E12CD3204,$287F9B1E4E9D79DE,$891B6B7549E20DD8,$232979E03B8C11CA
    Data.q $241F1A8F98B36CC1,$F51D0D3796BF767E,$E022153FE48FBDF0,$2F643BB684DC379B,$50C31C0462A16FFD
    Data.q $53E3A9A5319B915A,$B3C8AFBC17098201,$0618A8104BEDB9B6,$FEE208F044AF7F08,$DD2FDC410FF8104A
    Data.q $1B48A320945743B9,$7808D2C7F2B8E3C4,$7049417F42F58A11,$6B831C914A041168,$810259189087023D
    Data.q $94170F6863E04499,$C76F748A9B822960,$2146092812E5CFD8,$201603A0AEAD4AB6,$C2F722952143AB08
    Data.q $6391422F01165EB8,$1602DC0A64B3D670,$1A7A56DEEC8A3208,$51494F10DCC4138A,$591464130B824C57
    Data.q $C265809E2D6FF38F,$025C1824A2DCB401,$9813E4566E8A1F01,$CDE30422FA36C512,$0CB049E6DB28BCF0
    Data.q $921EF7C23722AC82,$45F23ADDF0132C17,$63922B4821CB04BE,$5915059D5307BD68,$824ACBCF09C26088
    Data.q $91564122DA7F52A1,$E046B61F177AD42B,$4996097CDEE210FF,$70C7C8A532AF5610,$B87504940885F7F9
    Data.q $54E6097CEADA979F,$6A41D351363F4032,$10EB91464110B139,$9D398124A8448838,$280EC2F5321F855A
    Data.q $B86DC8AC9D0DD8BF,$C23A704B0138A278,$A508BD2BAAEC85CB,$514FD20E0344366B,$C1B7914A4412CBA4
    Data.q $22F0108AC46E2EF7,$AD47F91B9C2DFA34,$5CAD2348F073C004,$CD7F031CB0DE7B41,$F010E61A672E7EED
    Data.q $71600A58400E2E77,$CDEFA177914F3893,$824A37C88BAC0442,$9FC499C80E12F67D,$65A4E3911FA3A4BE
    Data.q $A6F3B260B7228C82,$A777A0CF5704B322,$86EF9803A2BFA092,$3A3A60F6072294BE,$6D70E7D0CF6F8087
    Data.q $E2BD5617A8080E50,$9309B1C156BB2C57,$42B78C10C8FF6AED,$B707579E641D25DF,$5DB4E0EFBC4FD5BA
    Data.q $07F0C12CA1F17F2D,$A9352D08BF8CDD68,$E5C51FDA1B29C266,$638F44117C04B2DF,$43F0B8D7D61AABF4
    Data.q $F42B13FFC2589AFA,$9085D597200907FC,$4549000000008C4F
    Data.b $4E,$44,$AE,$42,$60,$82
  bWARNING_png_end:
EndDataSection




DataSection
  INFO_png_start:
    ; size : 778 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$FFF31F0000000608,$4D41670400000061,$8A0537C8AF000041,$58457419000000E9
    Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$CB38544144499C02,$C51C57D46BCB93A5,$31264C64AC4C773F
    Data.q $28A8D18F3689990A,$4DC5082C5289A168,$5C2EA241543B5221,$081FF95C156D9574,$9A74A5B0BE563E0A,$A2CE86949A5A85AE,$8F34C4D530C6991B
    Data.q $DCCDFD24C93318D1,$B47C4842EBF7BDEF,$381C3E5F2FCB3D1B,$E6F3547DE55518E7,$571DC12D34757321,$280D38B4AD564E17,$E0CEE177A6E108A1
    Data.q $755E6FFABE1E4FD9,$B172B58C9195C5F0,$D61A46B69EC9A123,$9E150C72216001AE,$B9FDA306797A7F70,$9CBE1C02DF659FF3,$1756DA1C6E48D8CF
    Data.q $B8A59CD4CF5ADDDF,$2A435BA89283E110,$3F3F0332B3C28EB1,$B3870BB95386A65C,$DC453BF74BDE802B,$7A96F6D4F1ADA1D0,$35B4F6139C256372
    Data.q $866263CD8E7F2A81,$A7E65F33FCF5C95D,$76BB9A7C346985BB,$68EBEB82400C51F4,$E785C303648ED4D0,$49C7EF40D522C8D8,$92D56C138853BB7A
    Data.q $D6D74131BED12C9F,$B0031007D2469486,$7158CCDED7D89FDE,$8FC707C782411109,$B162B027876413C3,$722ECF8C4514B2CE,$292B13DAC61B6F60
    Data.q $9850D7D536B6C8D8,$D021A0BC47BCE129,$D1A647860513B077,$D4AE916E71430010,$16AA0EABAD47D466,$9EF04AAEB0538A0D,$38ADFE79E3FC9410
    Data.q $2B387138F17875BC,$6A7E000567BC01A8,$31A316BC7342B96E,$78A4265E7BC12834,$0FF1125882110471,$0AB53098C658B278,$4DB6927E60D6EEB0
    Data.q $3B7F64729C010871,$FD2D5D6EA26C3F3B,$5A3A11382220F647,$D5ADE80DFD0D0C12,$5FCA0F23DBA25626,$FC4DAE9EA98D93A7,$F6F9475FFBE49F96
    Data.q $F28A035438A85FDE,$947916978C2DF6D1,$BA915AFDB81B4C2F,$E7C6E572D1977F4F,$C1E7AC6E778EEE5F,$B02E09979F6659E3,$2F199A5B6D8EB1A1
    Data.q $B531965F87EF712D,$72AADF64DF0372A7,$EF4C5ED419EBB1F7,$7EBCD34BEC0F264A,$FBF830A85D3CA02D,$FEB1318CC2F91328,$A0016E7FEC99C0DC
    Data.q $0D1C7F55692BABE7,$298C603416950927,$73818FE7720D3702,$3FA80BD177A63FFF,$0000B921B6597B82,$42AE444E45490000
  INFO_png_end:
EndDataSection


DataSection
  ERROR_png_start:
    ; size : 701 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$FFF31F0000000608,$4D41670400000061,$8A0537C8AF000041,$58457419000000E9
    Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$CB38544144494F02,$C61461944BCB93A5,$4153E99509D4BF1F
    Data.q $88AB948A636F119C,$430444502EC6E136,$17F482EAB80BC48B,$AB40CDA2D5151044,$104EE03168C1785A,$4E8D4385A422A28C,$149D19763A98A3A9
    Data.q $B0B6F3CF7DE6669D,$E1EF767536B319BE,$8CF279EF0E79DF9C,$B7213DFFC89FF831,$9176437698D034AF,$53F6489F920924AC,$E7D6E68FE9DF6438
    Data.q $4D0DFB2EB7502AE5,$1FB0D853D0AF2B60,$C91D637E76F76EF9,$DE94857D72560448,$9B9900BB824FFB8A,$14D4574BEC86FC97,$6C600B6242353517
    Data.q $6B79606A79600001,$16DDFA6A411531B1,$401D070C1FABBA45,$CA9917C91F45C6FA,$46AF321353716F1A,$3600021ED7450001,$893D6C283400F7AF
    Data.q $213113233624F0F5,$4000B3991A3FF75B,$18D9B6572D247744,$241B4426A3576618,$5253003E6EE046C7,$00058000754AD5EE,$69642363574EEB5A
    Data.q $03B9A3031406861E,$628B9E910C902540,$80B99D52940B735F,$D1879C5E86DB02AA,$6D4421933F3A2674,$D065D81451B353E7,$7188C34A0165574A
    Data.q $0AECE1D3544D7F1A,$42B5A108084427EA,$F2C1AF8E9CB5028E,$8E5FDF1145523AD4,$C88A9D33B1F87361,$7A56871E3243AEAF,$EC5BF0B7C0C15739
    Data.q $CF7708A2C539D6F1,$34422A00BB9C9455,$7A12F87CEAB84221,$0D4A500380F5AD03,$451864C4B1635666,$561EE05AC81CA76D,$9F4FB6FDB2217703
    Data.q $9899C5890870D7C1,$1E754D21C7707AD6,$B8A4783ECFA453F3,$66A439F9A905B9B4,$AB83EF55C0C630A3,$47AF8F84387887DE,$DC1F7D3DB77648B7
    Data.q $0642FD47F3A1CA75,$E0872DE53D7996F6,$E1AC4A900C614BB2,$242BB34B1238C4F3,$17A3FC10FB3F8F7B,$ED9206E1ECFC6000,$D0E44CD3B2917614
    Data.q $C4BFD3377F33E789,$EB056A4CAFD1950F,$4E454900000000FF
  ERROR_png_end:
EndDataSection

DataSection
  WARNING_png_start:
    ; size : 666 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$1000000010000000,$FFF31F0000000608,$4D41670400000061,$8A0537C8AF000041,$58457419000000E9
    Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$CB38544144492C02,$FE100194484B53A5,$54CB6BEBAEAB87FE
    Data.q $C8CA4C90525B4302,$63D4EA0C3D6F0D35,$2E8763A429D16BA9,$4490EC8B4208241D,$2C112C108A875085,$46462859054E8889,$8FFE8A98B2BBAE66
    Data.q $0E056B811A83AF99,$986FBE3E6661CCCC,$9855AF663D624831,$53553DF0A2CFB17E,$F5D25AFFDE2E6CAA,$39281ED850016B99,$33D148D03E281D58
    Data.q $8DFD13CAB920526B,$E867714FC35F78E1,$F8F4F774F13886A6,$A81969BD74E15DE3,$9A61AE58B2ECDDE8,$14C2C79608C273B0,$6A1BCFE20C5FFCBD
    Data.q $5F89D0E285EB7B27,$7D7E49BAA2E89BA7,$4FFB5EDEEB1FC3B0,$D5356AAA1FBD5406,$767D1887BEE7C39F,$A582E6A0A24DEA07,$1A37BC625D7F1DA2
    Data.q $8A396CE7568C28CB,$1C58120120AD6F85,$4D259905A46E436F,$E20169632BB7A38D,$8E2B07B6AA90D1BD,$A849A7974069FD43,$809D57E411C5D07A
    Data.q $0AB435B9BE195E8A,$6436C76582BB4540,$6440023E4BC05616,$81BC99C184570415,$ECDC9E55E432A2EC,$F8920CE657177A2F,$87A54FD54227B3D1
    Data.q $16EA6F0778596C06,$59C9F30B23330154,$9AF2B08B2C28E664,$2B9D4750C11EE561,$5CD47252F3BD5F8E,$53673B6D0EED1A3A,$E2002A006FB320E7
    Data.q $20004E3EA630E0CB,$A3CE6187EA9F8540,$0035DE3BE035BEA8,$6BF2B16BA93FBE30,$097D9FC3B535367A,$01A41292496F712F,$60520BA0C22D3010
    Data.q $9D0F86DE55911B5A,$A455B61E0C8CCC31,$0D4231E96A7220B3,$FC8AC67165D143B0,$E9401180FBDFC0E5,$29B55C0D0D48B3DE,$A14534FE7578903A
    Data.q $83C710278B33F8A2,$C43E3883C71078EF,$F2FA817D409E21F5,$4C9402FF3BEF58D6,$00002F53B9A7D963,$42AE444E45490000
  WARNING_png_end:
EndDataSection

