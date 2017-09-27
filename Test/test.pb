﻿; Form Designer for Purebasic - 5.60
; Warning: this file uses a strict syntax, if you edit it, make sure to respect the Form Designer limitation or it won't be opened again.

;
; This code is automatically generated by the FormDesigner.
; Manual modification is possible to adjust existing commands, but anything else will be dropped when the code is compiled.
; Event procedures needs to be put in another source file.
;

Enumeration FormWindow
  #Window_0
EndEnumeration

Enumeration FormGadget
  #Image_0
  #Image_1
  #Container_0
  #Button_0
  #Button_1
  #Container_1
  #String_0
  #ListIcon_0
EndEnumeration

Enumeration FormFont
  #Font_String_0
  #Font_Button_0
EndEnumeration

Enumeration FormImage
  #Img_Image_0
  #Img_Image_1
EndEnumeration

LoadImage(#Img_Image_0,"C:\Program Files\PureBasic_560(x64)\Examples\Sources\Data\PureBasicLogo.bmp") ; Geebee2
LoadImage(#Img_Image_1, #PB_Compiler_Home + "Examples\Sources\Data\PureBasic.bmp")

LoadFont(#Font_String_0,"Consolas", 12, #PB_Font_Bold)
LoadFont(#Font_Button_0,"Consolas", 7, #PB_Font_Bold|#PB_Font_Italic)

Global Button_1

Procedure OpenWindow_0(x = 0, y = 0, width = 390, height = 600)
  OpenWindow(#Window_0, x, y, width, height, "Window", #PB_Window_SystemMenu)
  ImageGadget(#Image_0, ReadPreferenceLong("x", 105), 5, 381, 68, 0)
  SetGadgetState(#Image_0, ImageID(#Img_Image_0))
  ImageGadget(#Image_1, 10, 265, 381, 68, ImageID(#Img_Image_1))
  
  ContainerGadget(#Container_0, 10, 50, 290, 205, #PB_Container_Flat)
  SetGadgetColor(#Container_0, #PB_Gadget_BackColor, $77FF8A)
  ButtonGadget(#Button_0, 20, 20, 155, WindowHeight(#Window_0) - 279 * 2, Str($BD)+" Button_0", #PB_Button_Right)
  ;ButtonGadget(#Button_0, ReadPreferenceLong("x", WindowWidth(#Window_0)/WindowWidth(#Window_0)+20), 20, WindowWidth(#Window_0)-(390-155), WindowHeight(#Window_0) - 285 * 2, GetWindowTitle(#Window_0) + Space( 1 ) +"("+ "Button" + "_" + Str(1)+")")
  ContainerGadget(#Container_1, 15, 70, 260, 120, #PB_Container_Single)
  SetGadgetColor(#Container_1, #PB_Gadget_BackColor, RGB(138, 255, 119))
  StringGadget(#String_0, 10, 10, 150, 35, "String_0")
  SetGadgetFont(#String_0, FontID(#Font_String_0))
  CloseGadgetList()
  CloseGadgetList()
  
;   OpenGadgetList(#Container_1)
;   Button_1 = ButtonGadget(#PB_Any, 20, 50, 155, 35, "Button_1")
;   CloseGadgetList()
  
  ResizeGadget(Button_1, 60, 80, #PB_Ignore, #PB_Ignore)
  SetGadgetText(Button_1, "Move "+LCase(GetWindowTitle(#Window_0)) + Space( 1 ) +"("+ "Button" + "_" + StrF(1.123,2)+")")
  SetGadgetFont(Button_1, FontID(#Font_Button_0))
  
  ListIconGadget(#ListIcon_0, 5, 305, 250, 180, "#", 20)
  AddGadgetColumn(#ListIcon_0, 1, "Слева1", 51)
  AddGadgetColumn(#ListIcon_0, 2, "Слева2", 52)
  AddGadgetColumn(#ListIcon_0, 3, "Слева3", 53)
  AddGadgetItem(#ListIcon_0, -1, Str( 1 )+Chr  (10)+"Слева1")
  AddGadgetItem(#ListIcon_0, -1, Str(2)+Chr(10)+"Слева2")
  AddGadgetItem(#ListIcon_0, -1, Str(3)+Chr(10)+"Слева3")
  
EndProcedure

Procedure Window_0_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False

    Case #PB_Event_Menu
      Select EventMenu()
      EndSelect

    Case #PB_Event_Gadget
      Select EventGadget()
      EndSelect
  EndSelect
  ProcedureReturn #True
EndProcedure

OpenWindow_0()

While IsWindow(#Window_0)
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      CloseWindow(EventWindow())
  EndSelect
Wend