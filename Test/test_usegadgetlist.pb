If OpenWindow(1, 0, 0, 500, 500, "Главное Окно", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    ButtonGadget(11, 10, 10, 150, 25, "Кнопка id(11)")
    
    ; Чтобы предотвратить автоматическое создание списка гаджетов, создавайте окно с флагом #PB_Window_NoGadgets
    If OpenWindow(2, 0, 0, 300, 200, "Дочернее Окно", #PB_Window_TitleBar | #PB_Window_WindowCentered | #PB_Window_NoGadgets, WindowID(1))     
      OldGadgetList = UseGadgetList(WindowID( 2 )) ; Создать GadgetList и сохранить старый GadgetList
      
      ButtonGadget(21, 10, 10, 150, 25, "Кнопка Дочернего Окна")
      
      UseGadgetList( OldGadgetList )               ; Вернуться к предыдущему GadgetList
    EndIf
    
    ButtonGadget(12, 10, 45, 150, 25, "Кнопка 12") ; Это будет снова в главном окне
    
;     OldGadgetList = UseGadgetList(WindowID(2)) ; Создать GadgetList и сохранить старый GadgetList
;     ButtonGadget(22, 10, 45, 150, 25, "это тоже") ; Это будет снова в главном окне
;     UseGadgetList(OldGadgetList)               ; Вернуться к предыдущему GadgetList
;     
;     ButtonGadget(102, 10, 80, 150, 25, "Кнопка 102") ; Это будет снова в главном окне
    
    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
