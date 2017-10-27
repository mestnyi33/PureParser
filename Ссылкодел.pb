
Enumeration FormWindow
  #Window_Linker
EndEnumeration

Enumeration FormGadget
  #Gadget_OrignText
  #Gadget_Orign
  #Gadget_OrignBrowse
  #Gadget_MakeLink
EndEnumeration



Procedure BGE_BrowseOrign()
  Path$=PathRequester("Источник", "")
  If Len(Path$)
    SetGadgetText(#Gadget_Orign, Path$)
  EndIf
  
EndProcedure

Procedure BGE_MakeLink()
  OrignPath$=GetGadgetText(#Gadget_Orign)
  DestinationPath$=SaveFileRequester("Создать ссылку ...", "", "Все файлы|*", 0)
  If Len(OrignPath$) And Len(DestinationPath$) 
    Parameters$="/j "+Chr(34)+DestinationPath$+Chr(34)+" "+Chr(34)+OrignPath$+Chr(34)
    Debug Parameters$
    
    If RunProgram("mklink", Parameters$, "")

    EndIf
  EndIf
EndProcedure



OpenWindow(#Window_Linker, #PB_Ignore, #PB_Ignore, 410, 80, "Создаватель ссылок", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
; TextGadget(#Gadget_OrignText, 5, 5, 60, 20, "Источник:", #PB_Text_Center)
; StringGadget(#Gadget_Orign, 70, 5, 280, 20, "")
; ButtonGadget(#Gadget_OrignBrowse, 350, 5, 55, 20, "Обзор")
ButtonGadget(#Gadget_OrignBrowse, 115, 5, 180, 25, "")
ButtonGadget(#Gadget_MakeLink, 115, 30, 180, 45, "")
;ButtonGadget(#Gadget_MakeLink, 115, 30, 180, 45, "eeeeeeeeeeeeeeeeeeeee")
;Создать ссылку ...")

BindGadgetEvent(#Gadget_OrignBrowse, @BGE_BrowseOrign())
BindGadgetEvent(#Gadget_MakeLink, @BGE_MakeLink())


Repeat
  Event=WaitWindowEvent()
  
Until Event=#PB_Event_CloseWindow


; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 8
; Folding = -
; EnableXP
; CompileSourceDirectory
; EnableUnicode