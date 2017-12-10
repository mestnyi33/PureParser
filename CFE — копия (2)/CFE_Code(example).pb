;- Code
DeclareModule Code
  EnableExplicit
  
  Enumeration Mode
    
  EndEnumeration
  
  Structure CodeStruct
    Windows.S
    Gadgets.S
    Events.S
    Types.S
    Functions.S
    Flags.S
  EndStructure
  
  Global NewMap CodeMap.CodeStruct()
  
  Declare.S Code_BindEvent( Indent, Events.S, Objects.S )
  Declare.S Code_Event( Indent, Objects.S, Events.S, Functions.S )
  Declare.S Code_Event_Procedure( Indent, Objects.S, Events.S, Functions.S )
EndDeclareModule

Module Code
  ;-
  Procedure.S Code_Event( Indent, Objects.S, Events.S, Functions.S )
    Protected Func
    Protected Space.S
    Protected I, II, III, Code.S, Event.S, Function.S, Object.S, EventType.I
    
    Space.S = Space( Indent ) : Indent + 2
    Code.S = Code.S + Space.S + "Window = EventWindow()" + #CRLF$
    Code.S = Code.S + Space.S + "Select Window" + #CRLF$
    
    For I = 1 To CountString( Objects.S, "|") + (1)
      Object.S = Trim( StringField( Objects.S, I, "|" )) 
      
      Space.S = Space( Indent )
      
      If Object.S
        Code.S = Code.S + Space.S + "Case " + Object.S + #CRLF$
        EventType.I = FindString( Events.S, "EventType" )
        
        Space.S = Space( Indent + 2 )
        
        If EventType.I
          Code.S = Code.S + Space.S + "Select EventType" + #CRLF$
        Else
          Code.S = Code.S + Space.S + "Select Event" + #CRLF$
        EndIf
        
        For II = 1 To CountString( Events.S, "|") + (1)
          Event.S = Trim( StringField( Events.S, II, "|" ))
          
          Space.S = Space( Indent + 4 )
          
          Code.S = Code.S + Space.S + "Case " + Event.S + #CRLF$
          
          Space.S = Space( Indent + 6 )
          
          Select Event.S
            Case "#PB_Event_MoveWindow"
              Code.S = Code.S + Space.S + "X = WindowX( Window )"+#CRLF$ 
              Code.S = Code.S + Space.S + "Y = WindowY( Window )"+#CRLF$
              Func = #True
              
            Case "#PB_Event_SizeWindow"
              Code.S = Code.S + Space.S + "Width = WindowWidth( Window )"+#CRLF$ 
              Code.S = Code.S + Space.S + "Height = WindowHeight( Window )"+#CRLF$
              Func = #True
              
            Case "#PB_Event_Gadget"
              Code.S = Code.S + Space.S + "Gadget = EventGadget( )"+#CRLF$ 
              Code.S = Code.S + Space.S + "Type = EventType( )"+#CRLF$
              Func = #True
              
            Case "#PB_Event_Menu"
              Code.S = Code.S + Space.S + "Menu = EventMenu( )"+#CRLF$ 
              Func = #True ;Code.S = Code.S + Space.S + "      " + #CRLF$
              
          EndSelect
          
          If Func : Func = #False
            Code.S = Code.S + Space.S + #CRLF$
          EndIf
          
          For III = 1 To CountString( Functions.S, "|") + (1)
            If II = Val(Trim( StringField( Functions.S, 1, "?" )))
              Function.S = Trim( StringField( Trim(Mid( Functions.S, FindString( Functions.S, "?" )+(1))), III, "|" ))
              
              If Function.S
                Code.S = Code.S + Space.S + Function.S + #CRLF$
                Func = #True
              EndIf
            EndIf
          Next
          
          If Func : Func = #False
            Code.S = Code.S + Space.S+ #CRLF$
          EndIf
        Next
        
        Space.S = Space( Indent + 2 )
          
        Code.S = Code.S + Space.S + "EndSelect " + #CRLF$
        Code.S = Code.S + Space.S + #CRLF$
      EndIf
    Next
    
    Indent - 2 : Space.S = Space( Indent )
    Code.S = Code.S + Space.S + "EndSelect" + #CRLF$
    
    ProcedureReturn Code.S
  EndProcedure
  
  Procedure.S Code_BindEvent( Indent, Events.S, Objects.S ) 
    Protected Space.S = Space( Indent )
    Protected I, II, Code.S, Object.S, Event.S, EventType.I
    ;Objects.S = "" ; Если нет окон 
    ;Events.S = ""
    
    For I = 1 To CountString( Objects.S, "|") + (1)
      Object.S = Trim( StringField( Objects.S, I, "|" )) 
      
      For II = (1) To CountString( Events.S, "|" ) + (1)
        Event.S = Trim( StringField( Events.S, II, "|" )) 
        
        EventType.I = FindString( Events.S, "EventType" )
        
        If EventType.I
          If Object.S ; Если гаджет указан
            Code.S = Code.S + Space.S + "BindGadgetEvent( " + Object.S + ", @" + Trim( Object.S, "#" ) + RemoveString( Event.S, "#PB_EventType" ) + "_EventType(), " + Event.S + " )"+#CRLF$
          Else
            ;Code.S = Code.S + Space.S + "BindGadgetEvent( " + Object.S + ", @All" + RemoveString( Event.S, "#PB_EventType" ) + "_EventType() )"+#CRLF$
            Code.S = Code.S + Space.S + "BindEvent( #PB_Event_Gadget" + ", @All" + RemoveString( Event.S, "#PB_EventType" ) + "_EventType(), Window, #PB_All, " + Event.S + " )"+#CRLF$
          EndIf
        Else
          If Event.S  = ""
            If Object.S 
              Code.S = Code.S + Space.S + "BindGadgetEvent( " + Object.S + ", @" + Trim( Object.S, "#" ) + "_EventType() )"+#CRLF$
            Else
              Code.S = Code.S + Space.S + "BindEvent( #PB_Event_Gadget" + ", @All" + RemoveString( Event.S, "#PB_EventType" ) + "_EventType() )"+#CRLF$
            EndIf
          Else
            If Object.S 
              Code.S = Code.S + Space.S + "BindEvent( " + Event.S + ", @" + Trim( Object.S, "#" ) + RemoveString( Event.S, "#PB_Event" ) + "_Event(), " + Object.S + " )"+#CRLF$
            Else
              Code.S = Code.S + Space.S + "BindEvent( " + Event.S + ", @All" + RemoveString( Event.S, "#PB_Event" ) + "_Event() )"+#CRLF$
            EndIf
          EndIf
        EndIf
      Next
    Next
    
    ProcedureReturn Code.S
  EndProcedure
  
  Procedure.S Code_Event_Procedure( Indent, Objects.S, Events.S, Functions.S )
    Protected Space.S = Space( Indent )
    Protected I, II, III, Function.S, Code.S, Object.S, Event.S, EventType.I
    
    For I = 1 To CountString( Objects.S, "|") + (1)
      Object.S = Trim( StringField( Objects.S, I, "|" )) 
      ;Debug "CountString "+CountString( Events.S, "|")
      
      If Object.S
        For II = 1 To CountString( Events.S, "|") + (1)
          Event.S = Trim( StringField( Events.S, II, "|" ))
          EventType.I = FindString( Event.S, "EventType" )
          
          If EventType.I
            Code.S = Code.S + Space.S + "Procedure " + Trim( Object.S, "#" ) + RemoveString( Event.S, "#PB_EventType" ) + "_EventType( )"+#CRLF$
          Else
            Code.S = Code.S + Space.S + "Procedure " + Trim( Object.S, "#" ) + RemoveString( Event.S, "#PB_Event" ) + "_Event( )"+#CRLF$
          EndIf
          
          Code.S = Code.S + Space.S + "  Protected Window = EventWindow( )"+#CRLF$
          
          If EventType.I
            Code.S = Code.S + Space.S + "  Protected Gadget = EventGadget( )"+#CRLF$ 
            
            If Event.S = ""
              Code.S = Code.S + Space.S + "  Protected Type = EventType( )"+#CRLF$
              Code.S = Code.S + Space.S + "    "+#CRLF$
              Code.S = Code.S + Space.S + "    Select Type"+#CRLF$
              Code.S = Code.S + Space.S + "      Case "+Event.S+#CRLF$
            EndIf
          EndIf
          
          Select Event.S
            Case "#PB_Event_MoveWindow"
              Code.S = Code.S + Space.S + "  Protected X = WindowX( Window )"+#CRLF$ 
              Code.S = Code.S + Space.S + "  Protected Y = WindowY( Window )"+#CRLF$
              
            Case "#PB_Event_SizeWindow"
              Code.S = Code.S + Space.S + "  Protected Width = WindowWidth( Window )"+#CRLF$ 
              Code.S = Code.S + Space.S + "  Protected Height = WindowHeight( Window )"+#CRLF$
              
            Case "#PB_Event_Gadget"
              Code.S = Code.S + Space.S + "  Protected Gadget = EventGadget( )"+#CRLF$ 
              Code.S = Code.S + Space.S + "  Protected Type = EventType( )"+#CRLF$
              
            Case "#PB_Event_Menu"
              Code.S = Code.S + Space.S + "  Protected Menu = EventMenu( )"+#CRLF$ 
              
          EndSelect
          
          For III = 1 To CountString( Functions.S, "|") + (1)
            If II = Val(Trim( StringField( Functions.S, 1, "?" )))
              Function.S = Trim( StringField( Trim(Mid( Functions.S, FindString( Functions.S, "?" )+(1))), III, "|" ))
              
              If Function.S
                Code.S = Code.S + Space.S + "        " + Function.S + #CRLF$
              EndIf
            EndIf
          Next
          
          If Event.S = ""
            Code.S = Code.S + Space.S + "    "+#CRLF$
            Code.S = Code.S + Space.S + "    EndSelect"+#CRLF$
            
          EndIf
          
          Code.S = Code.S + Space.S + "  "+#CRLF$
          Code.S = Code.S + Space.S + "EndProcedure "+#CRLF$
          Code.S = Code.S + Space.S + ""+#CRLF$
        Next
      EndIf
    Next
    
    ProcedureReturn Code.S
  EndProcedure
  
EndModule

; Procedure Form_0_Gadget_Event( )
;     Protected EventWindow = EventWindow( )
;     Protected EventGadget = EventGadget( )
;     Protected EventType = EventType( )
;
;     Select EventGadget
;       Case #Form_0_String_0
;         Select EventType
;           Case #PB_EventType_Change
;             
;         EndSelect
;       
;     EndSelect
; EndProcedure 


CompilerIf #PB_Compiler_IsMainFile
  ;{ -Windows.S
  Windows.S = "#Form_0|"+
              "#Form_1|"+
              "#Form_2"
  
  ;}
  
  ;{ -Events.S            
  Events.S = "#PB_Event_CloseWindow|"+
             ;            "#PB_Event_ActivateWindow|"+
             ;            "#PB_Event_DeactivateWindow|"+
             ;            "#PB_Event_Repaint|"+
  "#PB_Event_SizeWindow|"+
"#PB_Event_MoveWindow|"+
;            "#PB_Event_LeftClick|"+
  "#PB_Event_RightClick|"+
;            "#PB_Event_LeftDoubleClick|"+
;            "#PB_Event_MinimizeWindow|"+
;            "#PB_Event_MaximizeWindow|"+
;            "#PB_Event_RestoreWindow|"+
;            "#PB_Event_Timer|"+
;            "#PB_Event_SysTray|"+
;            "#PB_Event_WindowDrop|"+
  "#PB_Event_Menu|"+
;            "#PB_Event_Gadget|"+ 
  "#PB_Event_GadgetDrop" 
  ;}
  
  ;{ -Function.S
  Function.S = "4? CloseWindow( #Form_0 )|"+
               "|"+
               "|"+
               "|"+
               "|"+
               "|"+
               "CreateMenu( #Form_0 )|"
  ;}
  
  ;{ -Gadgets.S
  Gadgets.S = "#Form_0_Gadget_0|"+
              "#Form_0_Gadget_1|"+
              "#Form_0_Gadget_2"
  
  ;}
  
  ;{ -Types.S
  Types.S = "#PB_EventType_LeftClick|"+
            "#PB_EventType_Change|"+
            "#PB_EventType_LostFocus"
  ;}
  
  ;   Procedure Init(Windows.S,Gadgets.S,Events.S,Types.S)
  ;     Code::CodeMap("")\Windows = Windows.S
  ;     Code::CodeMap("")\Gadgets = Gadgets.S
  ;     Code::CodeMap("")\Events = Events.S
  ;     Code::CodeMap("")\Types = Types.S
  ;   EndProcedure
  ;   Init(Windows.S,Gadgets.S,Events.S,Types.S)
  ;   
  ;   
  ;   Procedure AddFunc(Window.S, Event.S, Functions.S)
  ;     Protected Object.S
  ;     Protected Events.S 
  ;     
  ;     For I = 1 To CountString( Code::CodeMap(Window.S)\Events, "|") + (1)
  ;       Events.S = Trim( StringField( Code::CodeMap(Window.S)\Events, I, "|" )) 
  ;       If Events.S = Event.S
  ;         Code::CodeMap(Event.S)\Functions = Functions.S
  ;      EndIf
  ;     Next
  ;   EndProcedure
  ;   
  ;   Procedure Add(Window.S,Events.S)
  ;     Protected Object.S
  ;     For I = 1 To CountString( Windows.S, "|") + (1)
  ;       Object.S = Trim( StringField( Windows.S, I, "|" )) 
  ;       If Object.S = Window.S
  ;         Debug Code::Code_Event_Procedure(0, Windows.S, Events.S, Function.S)
  ;      EndIf
  ;     Next
  ;   EndProcedure
  ;   
  ;   
  ;   AddEvents("#Form_0",Events.S)
  ;   
  ;   
  ;   ;Debug Code::CodeMap("#Form_0")\Events
  ;   AddFunc("#Form_0", "#PB_Event_CloseWindow", Function.S)
  
  ;Debug Code::Code_EventType( Indent, Types.S)
  ;Debug Code::Code_EventGadget( Indent, Gadgets.S)
  
  ;Debug Code::Code_BindEvent(0, Types.S, Gadgets.S) 
  ;Debug Code::Code_Event(0, Gadgets.S, Types.S, Function.S)
  ;Debug Code::Code_Event_Procedure(0, Gadgets.S, Types.S, Function.S)
  
  ;Debug Code::Code_BindEvent(0, Events.S, Windows.S) 
  Debug Code::Code_Event(2, Windows.S, Events.S, Function.S)
  ;Debug Code::Code_Event_Procedure(0, Windows.S, Events.S, Function.S)
CompilerEndIf
