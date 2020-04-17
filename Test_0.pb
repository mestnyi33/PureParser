; Показывает использование нескольких Панелей...
  If OpenWindow(1, 252, 541, 421, 221, "Гаджет Панель", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    PanelGadget(5, 50, 25, 356, 206)
      ;AddGadgetItem (50, -1, "Панель 1")
      AddGadgetItem (50, -1, "Панель 2")
        PanelGadget(5, 110, 50, 341, 166)
          AddGadgetItem(51, -1, "Под-Панель 1")
          
          PanelGadget(1, 205, 15, 341, 166)
          AddGadgetItem(151, -1, "Под-Панель 1")
          AddGadgetItem(151, -1, "Под-Панель 2")
          ButtonGadget(1, 5, 5, 56, 21, "кнопка 15")
        AddGadgetItem(151, -1, "Под-Панель 3")
        CloseGadgetList()
        
        AddGadgetItem(51, -1, "Под-Панель 2")
          ButtonGadget(1, 5, 5, 56, 21, "кнопка 15")
        AddGadgetItem(51, -1, "Под-Панель 3")
        CloseGadgetList()
        
        ButtonGadget(5, 15, 40, 86, 41, "кнопка 5")
        
        AddGadgetItem (50, -1,"Панель 3")
         ButtonGadget(2, 10, 15, 81, 26, "Кнопка 1")
        ButtonGadget(3, 95, 15, 81, 26, "Кнопка 2")
    CloseGadgetList()
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP
; CompileSourceDirectory