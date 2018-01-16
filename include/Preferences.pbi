CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "Img.pbi"
  XIncludeFile "Memory.pbi"
  XIncludeFile "SetIcon.pbi"
CompilerEndIf

EnableExplicit

Global ShowToolbar.b,
       Variable.b, 
       VariableCaption.b,
       VariableForming.b

Global LanguageFile.s, 
       CurrentLanguage.s, 
       PreferencesFile.s

Global Preferences=-1,
       Preferences_Tree_0=-1,
       Preferences_Button_Ok=-1,
       Preferences_Button_Cancel=-1,
       Preferences_Button_Apply=-1,
       Preferences_Container_General=-1,
       Preferences_Container_General_Frame_0=-1,
       Preferences_Container_General_CheckBox_0=-1,
       Preferences_Container_General_CheckBox_1=-1,
       Preferences_Container_General_CheckBox_2=-1,
       Preferences_Container_Form=-1,
       Preferences_Container_Form_Frame_0=-1,
       Preferences_Container_Form_CheckBox_0=-1,
       Preferences_Container_Form_CheckBox_1=-1,
       Preferences_Container_Form_CheckBox_2=-1,
       Preferences_Container_Lang=-1,
       Preferences_Container_Lang_Frame_0=-1,
       Preferences_Container_Lang_Text_0=-1,
       Preferences_Container_Lang_Text_1=-1,
       Preferences_Container_Lang_Text_2=-1,
       Preferences_Container_Lang_ComboBox_0=-1,
       Preferences_Container_Lang_Text_3=-1,
       Preferences_Container_Lang_Text_4=-1,
       Preferences_Container_Editor=-1

Declare Preferences_Events(Event.i)

Procedure ScanDisk(Gadget, Dir.s) 
  Protected ID, Name.s
      
  If IsGadget(Gadget)
    ClearGadgetItems(Gadget)
    
    ID = ExamineDirectory(#PB_Any, Dir, "*.*")
    If ID
      While NextDirectoryEntry(ID)
        Name = DirectoryEntryName(ID)
        If DirectoryEntryType(ID) = #PB_DirectoryEntry_File ; Файл
          If LCase(GetExtensionPart(Name))="catalog" And LCase(Name) = "editor.catalog"
            AddGadgetItem(Gadget, #PB_Any, "English")
            SetGadgetItemData(Gadget, CountGadgetItems(Gadget)-1, Memory::SetString(Dir+"Editor.catalog"))
          EndIf
        Else ; Папка
          Select Name
            Case ".", ".."
            Default 
              AddGadgetItem(Gadget, #PB_Any, Name)
              SetGadgetItemData(Gadget, CountGadgetItems(Gadget)-1, Memory::SetString(Dir+Name+"/Editor.catalog"))
          EndSelect
        EndIf
      Wend
      
      FinishDirectory(ID)
    EndIf
  EndIf
EndProcedure
 
Procedure CreatePrefs()
  If CreatePreferences("Preferences.prefs")
    PreferenceGroup("Global")
    WritePreferenceInteger ("ShowToolbar", 1)
    WritePreferenceString ("CurrentLanguage", "English")
    WritePreferenceString ("LanguageFile", "Catalogs/Editor.catalog")
    
    PreferenceComment("")
    
    PreferenceGroup("Editor")
    WritePreferenceInteger("X", 100)
    WritePreferenceInteger("Y", 100)
    WritePreferenceInteger("Width", 900)
    WritePreferenceInteger("Height", 600)
    
    PreferenceComment("")
    
    PreferenceGroup("Form")
    WritePreferenceInteger ("Variable", 1)
    WritePreferenceInteger ("VariableForming", 1)
    WritePreferenceInteger ("VariableCaption", 0)
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure SavePrefs()
  Variable = GetGadgetState(Preferences_Container_Form_CheckBox_0)
  VariableForming = GetGadgetState(Preferences_Container_Form_CheckBox_2)
  VariableCaption = GetGadgetState(Preferences_Container_Form_CheckBox_1)
  ShowToolbar = GetGadgetState(Preferences_Container_General_CheckBox_0)
  
  If OpenPreferences(PreferencesFile)
    PreferenceGroup("Global")
    WritePreferenceString ("LanguageFile", LanguageFile)
    WritePreferenceInteger ("ShowToolbar", ShowToolbar)
    
    PreferenceGroup("Form")
    WritePreferenceInteger ("Variable", Variable)
    WritePreferenceInteger ("VariableForming", VariableForming)
    WritePreferenceInteger ("VariableCaption", VariableCaption)
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure LoadPrefs(Window)
  If OpenPreferences(PreferencesFile)
    PreferenceGroup("Editor")
    ResizeWindow(Window, 
                 ReadPreferenceInteger ("X", 100),
                 ReadPreferenceInteger ("Y", 100),
                 ReadPreferenceInteger ("Width", 900),
                 ReadPreferenceInteger ("Height", 600))
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure UpdatePrefs(Window)
  If OpenPreferences(PreferencesFile)
    PreferenceGroup("Editor")
    WritePreferenceInteger ("X", WindowX(Window))
    WritePreferenceInteger ("Y", WindowY(Window))
    WritePreferenceInteger ("Width", WindowWidth(Window))
    WritePreferenceInteger ("Height", WindowHeight(Window))
    
    ClosePreferences()
  EndIf
EndProcedure

Procedure InitPrefs(Pach.s="")
  CompilerIf #PB_Compiler_IsMainFile
    PreferencesFile = "../Preferences.prefs"
  CompilerElse
    PreferencesFile = "Preferences.prefs"
  CompilerEndIf
  
  If Pach.s
    LanguageFile = Pach.s
  Else
    If OpenPreferences(PreferencesFile)
      If PreferenceGroup("Global")
        LanguageFile = ReadPreferenceString ("LanguageFile", "Catalogs/English.catalog")
        CompilerIf #PB_Compiler_IsMainFile
          If Asc(LanguageFile)<>'.'
            LanguageFile = "../"+LanguageFile
          EndIf
        CompilerElse
          LanguageFile = ReplaceString(LanguageFile, "../", "")
        CompilerEndIf
        
        ShowToolbar = ReadPreferenceInteger ("ShowToolbar", 1)
        
        PreferenceGroup("Form")
        Variable = ReadPreferenceInteger ("Variable", 1)
        VariableForming = ReadPreferenceInteger ("VariableForming", 1)
        VariableCaption = ReadPreferenceInteger ("VariableCaption", 0)
        
      Else
        CreatePrefs()
      EndIf
      
      ClosePreferences()
    Else
      CreatePrefs()
    EndIf
  EndIf
  
  LanguageFile = GetPathPart(LanguageFile)+"Editor.catalog"
  CurrentLanguage = ReverseString(StringField(ReverseString(Trim(GetPathPart(LanguageFile), "/")), 1, "/"))
  If CurrentLanguage = "Catalogs"
    CurrentLanguage = "English"
  EndIf
  
EndProcedure

Procedure Preferences_SetLanguage(LanguageFile.s)
  If OpenPreferences(LanguageFile)
    PreferenceGroup("Preferences")
    Protected Email.s = ReadPreferenceString ("Email", "")
    Protected Creator.s = ReadPreferenceString ("Creator", "")
    Protected FileName.s = ReadPreferenceString ("FileName", "")
    Protected LastUpdated.s = ReadPreferenceString ("LastUpdated", "")
    Protected LanguageInfo.s = ReadPreferenceString ("LanguageInfo", "")
    
    SetWindowTitle(Preferences, ReadPreferenceString("Title", GetWindowTitle(Preferences)))
    SetGadgetText(Preferences_Button_Apply, ReadPreferenceString("Apply", GetGadgetText(Preferences_Button_Apply)))
    
    SetGadgetText(Preferences_Container_Lang_Frame_0, ReadPreferenceString("Language", GetGadgetText(Preferences_Container_Lang_Frame_0)))
    SetGadgetItemText(Preferences_Tree_0, 0, ReadPreferenceString("General", GetGadgetItemText(Preferences_Tree_0, 0)))
    SetGadgetItemText(Preferences_Tree_0, 1, ReadPreferenceString("Language", GetGadgetItemText(Preferences_Tree_0, 1)))
    SetGadgetItemText(Preferences_Tree_0, 2, ReadPreferenceString("Form", GetGadgetItemText(Preferences_Tree_0, 2)))
    SetGadgetItemText(Preferences_Tree_0, 3, ReadPreferenceString("Editor", GetGadgetItemText(Preferences_Tree_0, 3)))
    
    SetGadgetText(Preferences_Container_General_CheckBox_0, ReadPreferenceString("ShowMainToolbar", GetGadgetText(Preferences_Container_General_CheckBox_0)))
    
    SetGadgetText(Preferences_Container_Form_Frame_0, ReadPreferenceString("Form", GetGadgetText(Preferences_Container_Form_Frame_0)))
    SetGadgetText(Preferences_Container_Form_CheckBox_0, ReadPreferenceString("FormVariable", GetGadgetText(Preferences_Container_Form_CheckBox_0)))
    SetGadgetText(Preferences_Container_Form_CheckBox_1, ReadPreferenceString("FormVariableCaption", GetGadgetText(Preferences_Container_Form_CheckBox_1)))
    SetGadgetText(Preferences_Container_Form_CheckBox_2, ReadPreferenceString("FormVariableForming", GetGadgetText(Preferences_Container_Form_CheckBox_2)))
    
    PreferenceGroup("Form")
    SetGadgetText(Preferences_Button_Ok, ReadPreferenceString("Ok", GetGadgetText(Preferences_Button_Ok)))
    SetGadgetText(Preferences_Button_Cancel, ReadPreferenceString("Cancel", GetGadgetText(Preferences_Button_Cancel)))
    
    PreferenceGroup("LanguageInfo")
    SetGadgetText(Preferences_Container_Lang_Text_0, LanguageInfo+": "+ReadPreferenceString ("LanguageInfo", ""))
    SetGadgetText(Preferences_Container_Lang_Text_1, LastUpdated+": "+ReadPreferenceString ("LastUpdated", ""))
    SetGadgetText(Preferences_Container_Lang_Text_2, Creator+": "+ReadPreferenceString ("Creator", ""))
    SetGadgetText(Preferences_Container_Lang_Text_3, Email+": "+ReadPreferenceString ("Email", ""))
    SetGadgetText(Preferences_Container_Lang_Text_4, FileName+": "+LanguageFile)
    
    ClosePreferences()
  EndIf
  
EndProcedure

Procedure Preferences_HideContainers()
  HideGadget(Preferences_Container_General, #True)
  HideGadget(Preferences_Container_Lang, #True)
  HideGadget(Preferences_Container_Form, #True)
  HideGadget(Preferences_Container_Editor, #True)
EndProcedure

Procedure Preferences_CallBack()
  Preferences_Events(Event())
EndProcedure

Procedure Preferences_Open(ParentID.i=0, Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If IsWindow(Preferences)
    SetActiveWindow(Preferences)
    ProcedureReturn Preferences
  EndIf
  
  Preferences = OpenWindow(#PB_Any, 20, 20, 511, 381, "Настройки", Flag, ParentID)
  Preferences_Tree_0 = TreeGadget(#PB_Any, 5, 5, 176, 371, #PB_Tree_AlwaysShowSelection)
  Preferences_Button_Ok = ButtonGadget(#PB_Any, 220, 355, 81, 21, "Ок")
  Preferences_Button_Cancel = ButtonGadget(#PB_Any, 305, 355, 81, 21, "Отмена")
  Preferences_Button_Apply = ButtonGadget(#PB_Any, 390, 355, 81, 21, "Применить")
  
  Preferences_Container_General = ContainerGadget(#PB_Any, 185, 5, 321, 346, #PB_Container_Flat)
  Preferences_Container_General_Frame_0 = FrameGadget(#PB_Any, 0, 0, 321, 346, "General")
  Preferences_Container_General_CheckBox_0 = CheckBoxGadget(#PB_Any, 9, 25, 296, 21, "CheckBox_0")
;   Preferences_Container_General_CheckBox_1 = CheckBoxGadget(#PB_Any, 10, 50, 296, 21, "CheckBox_1")
;   Preferences_Container_General_CheckBox_2 = CheckBoxGadget(#PB_Any, 10, 75, 296, 21, "CheckBox_2")
  CloseGadgetList()
  
  Preferences_Container_Form = ContainerGadget(#PB_Any, 185, 5, 321, 346, #PB_Container_Flat)
  Preferences_Container_Form_Frame_0 = FrameGadget(#PB_Any, 0, 0, 321, 346, "Форма")
  Preferences_Container_Form_CheckBox_0 = CheckBoxGadget(#PB_Any, 10, 25, 296, 21, "Использовать идентификатор #PB_Any")
  Preferences_Container_Form_CheckBox_1 = CheckBoxGadget(#PB_Any, 10, 50, 296, 21, ~"Использовать имя переменной в качестве \"Текста\"")
  Preferences_Container_Form_CheckBox_2 = CheckBoxGadget(#PB_Any, 10, 75, 296, 21, "Использовать и имя родителя при формировании ID")
  CloseGadgetList()
  
  Preferences_Container_Lang = ContainerGadget(#PB_Any, 185, 5, 321, 346, #PB_Container_Flat)
  Preferences_Container_Lang_Frame_0 = FrameGadget(#PB_Any, 0, 0, 321, 346, "Язык")
  Preferences_Container_Lang_ComboBox_0 = ComboBoxGadget(#PB_Any, 10, 20, 301, 21)
  Preferences_Container_Lang_Text_0 = TextGadget(#PB_Any, 10, 50, 296, 41, "Text_0")
  Preferences_Container_Lang_Text_1 = TextGadget(#PB_Any, 10, 70, 296, 41, "Text_1")
  Preferences_Container_Lang_Text_2 = TextGadget(#PB_Any, 10, 90, 296, 41, "Text_2")
  Preferences_Container_Lang_Text_3 = TextGadget(#PB_Any, 10, 110, 296, 41, "Text_3")
  Preferences_Container_Lang_Text_4 = TextGadget(#PB_Any, 10, 140, 296, 41, "Text_4")
  CloseGadgetList()
  
  Preferences_Container_Editor = ContainerGadget(#PB_Any, 185, 5, 321, 346, #PB_Container_Flat)
  CloseGadgetList()
  
  Preferences_HideContainers()
  SetIcon::Window(Preferences, ImageID(img_ico))
  
  AddGadgetItem(Preferences_Tree_0, #PB_Any, "Основные" )
  AddGadgetItem(Preferences_Tree_0, #PB_Any, "Язык", 0, 1 )
  AddGadgetItem(Preferences_Tree_0, #PB_Any, "Форм" )
  AddGadgetItem(Preferences_Tree_0, #PB_Any, "Редактор" )
  
  SetGadgetItemState(Preferences_Tree_0, 0, #PB_Tree_Expanded)
  SetActiveGadget(Preferences_Tree_0)
  SetGadgetState(Preferences_Tree_0, 2)
  
  SetGadgetState(Preferences_Container_Form_CheckBox_0, Variable)
  SetGadgetState(Preferences_Container_Form_CheckBox_1, VariableCaption)
  SetGadgetState(Preferences_Container_Form_CheckBox_2, VariableForming)
  
  SetGadgetState(Preferences_Container_General_CheckBox_0, ShowToolbar)
  
  Preferences_SetLanguage(LanguageFile)
  ProcedureReturn Preferences
EndProcedure

Procedure Preferences_Events(Event.i)
  Static Save.b
  Protected *Result, Result$, OpenPreferences
  
  Select Event
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_Change
          Select EventGadget()
            Case Preferences_Container_Lang_ComboBox_0
              InitPrefs(Memory::GetString(GetGadgetItemData(EventGadget(), GetGadgetState(EventGadget()))))
              Preferences_SetLanguage(LanguageFile)
                  
            Case Preferences_Tree_0
              Preferences_HideContainers()
              
              OpenPreferences = OpenPreferences(LanguageFile)
              PreferenceGroup("Preferences")
              
              Select GetGadgetText(EventGadget())
                Case ReadPreferenceString("General", GetGadgetText(EventGadget()))
                  HideGadget(Preferences_Container_General, #False)
                  
                Case ReadPreferenceString("Language", GetGadgetText(EventGadget()))
                  HideGadget(Preferences_Container_Lang, #False)
                  
                  CompilerIf #PB_Compiler_IsMainFile
                    ScanDisk(Preferences_Container_Lang_ComboBox_0, "../Catalogs/")
                  CompilerElse
                    ScanDisk(Preferences_Container_Lang_ComboBox_0, "Catalogs/")
                  CompilerEndIf
                  
                  Protected i
                  For i=0 To CountGadgetItems(Preferences_Container_Lang_ComboBox_0)-1
                    If GetGadgetItemText(Preferences_Container_Lang_ComboBox_0, i) = CurrentLanguage
                      SetGadgetState(Preferences_Container_Lang_ComboBox_0, i)
                    EndIf
                  Next
                  
                  Preferences_SetLanguage(LanguageFile)
              
                Case ReadPreferenceString("Form", GetGadgetText(EventGadget())) 
                  HideGadget(Preferences_Container_Form, #False)
                  
                Case ReadPreferenceString("Editor", GetGadgetText(EventGadget())) 
                  HideGadget(Preferences_Container_Editor, #False)
                  
              EndSelect
              
              If OpenPreferences 
                ClosePreferences()
              EndIf
          EndSelect
          
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case Preferences_Button_Ok
              SavePrefs()
              ProcedureReturn #PB_Event_CloseWindow
              
            Case Preferences_Button_Apply
              SavePrefs()
              Save = #True
              
            Case Preferences_Button_Cancel
              If Save
                ProcedureReturn #PB_Event_CloseWindow
              Else
                CloseWindow(Preferences)
              EndIf
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Event
EndProcedure

; Читаем данные в переменные
InitPrefs()

CompilerIf #PB_Compiler_IsMainFile
  Preferences_Open()
  
  While IsWindow(Preferences)
    Define.i Event = WaitWindowEvent()
    
    Select EventWindow()
      Case Preferences
        If Preferences_Events( Event ) = #PB_Event_CloseWindow
          CloseWindow(Preferences)
          Break
        EndIf
        
    EndSelect
  Wend
CompilerEndIf