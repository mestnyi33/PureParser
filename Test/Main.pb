XIncludeFile "FrmHaubtfenster.pbf"
XIncludeFile "Frminfo.pbf"

Procedure FrmHauptfensterInfo(EventType) 
  OpenFrmInfo()
EndProcedure

Procedure FrmHaubtfensterEnde(EventType)
  End
EndProcedure

OpenFrmHaubtFenster()

; The main event loop as usual, the only change is to call the automatically
; generated event procedure for each window.
  Repeat
    Event = WaitWindowEvent()
    
    Select EventWindow()
      Case #FrmHaubtFenster
        FrmHaubtFenster_Events(Event) ; This procedure name is always window name followed by '_Events'
        
      Case #FrmInfo
        FrmInfo_Events(Event)     
    EndSelect
    
  Until Event = #PB_Event_CloseWindow ; Quit on any window close