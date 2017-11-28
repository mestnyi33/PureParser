Define EventID, MenuID, GadgetID, WindowID

Enumeration 1
  #Window_RashadBin
EndEnumeration

#WindowIndex = #PB_Compiler_EnumerationValue

Enumeration 1
  ; Window_RashadBin
  #Gadget_RashadBin_DirectoryTree
  #Gadget_RashadBin_FileTree
  #Gadget_RashadBin_FileList
  #Gadget_RashadBin_cControl
  #Gadget_RashadBin_bNewdatafile
  #Gadget_RashadBin_bSavedatafile
  #Gadget_RashadBin_fSeparator1
  #Gadget_RashadBin_bNewResourceFile
  #Gadget_RashadBin_bWritelisttofile
  #Gadget_RashadBin_bLoadlistfromfile
  #Gadget_RashadBin_bClearcurrentlist
  #Gadget_RashadBin_fSeparator2
  #Gadget_RashadBin_sColumnsPerLine
  #Gadget_RashadBin_cAllowedfiletypes
  #Gadget_RashadBin_lColumns
  #Gadget_RashadBin_fSeparator3
  #Gadget_RashadBin_sCurrentresourcelist
  #Gadget_RashadBin_sCurrentdatafile
  #Gadget_RashadBin_fSeparator4
  #Gadget_RashadBin_bExithisprogram
  #Gadget_RashadBin_sStatusbar
EndEnumeration

#GadgetIndex = #PB_Compiler_EnumerationValue

Procedure.i Window_RashadBin()
  If OpenWindow(#Window_RashadBin, 63, 73, 1080, 770, "Rashad's binary file to DataSection", #PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible)
      ExplorerTreeGadget(#Gadget_RashadBin_DirectoryTree, 5, 5, 430, 645, "", #PB_Explorer_BorderLess|#PB_Explorer_AlwaysShowSelection|#PB_Explorer_NoFiles|#PB_Explorer_NoDriveRequester|#PB_Explorer_NoMyDocuments|#PB_Explorer_AutoSort)
        SetGadgetFont(#Gadget_RashadBin_DirectoryTree, LoadFont(#Gadget_RashadBin_DirectoryTree, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_DirectoryTree, "Resource directory tree. No files are shown")
      ExplorerListGadget(#Gadget_RashadBin_FileTree, 440, 5, 635, 425, "", #PB_Explorer_BorderLess|#PB_Explorer_AlwaysShowSelection|#PB_Explorer_MultiSelect|#PB_Explorer_FullRowSelect|#PB_Explorer_NoFolders|#PB_Explorer_NoParentFolder|#PB_Explorer_NoDirectoryChange|#PB_Explorer_NoDriveRequester|#PB_Explorer_NoMyDocuments|#PB_Explorer_AutoSort)
        SetGadgetFont(#Gadget_RashadBin_FileTree, LoadFont(#Gadget_RashadBin_FileTree, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_FileTree, "Directory resource list. Only selected files are shown")
        ListIconGadget(#Gadget_RashadBin_FileList, 440, 435, 635, 215, "Name", 120, #PB_ListIcon_CheckBoxes|#PB_ListIcon_MultiSelect|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection|#LVS_NOCOLUMNHEADER)
        AddGadgetColumn(#Gadget_RashadBin_FileList, 1, "Type", 0)
        AddGadgetColumn(#Gadget_RashadBin_FileList, 2, "Directory", 0)
        SetGadgetFont(#Gadget_RashadBin_FileList, LoadFont(#Gadget_RashadBin_FileList, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_FileList, "The list of currently selected resource fiels for saving and writing")
      ContainerGadget(#Gadget_RashadBin_cControl, 5, 655, 1070, 85, #PB_Container_BorderLess)
      ButtonGadget(#Gadget_RashadBin_bNewdatafile, 5, 5, 100, 34, "New data file", #PB_Button_MultiLine)
        SetGadgetFont(#Gadget_RashadBin_bNewdatafile, LoadFont(#Gadget_RashadBin_bNewdatafile, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_bNewdatafile, "Create a new datasection include file from the current list of resources")
      ButtonGadget(#Gadget_RashadBin_bSavedatafile, 5, 40, 100, 34, "Save data file", #PB_Button_MultiLine)
        SetGadgetFont(#Gadget_RashadBin_bSavedatafile, LoadFont(#Gadget_RashadBin_bSavedatafile, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_bSavedatafile, "Create a new datasection include file from the current list of resources")
      FrameGadget(#Gadget_RashadBin_fSeparator1, 110, 5, 5, 70, "", #PB_Frame_Double)
      ButtonGadget(#Gadget_RashadBin_bNewResourceFile, 120, 5, 100, 34, "New list", #PB_Button_MultiLine)
        SetGadgetFont(#Gadget_RashadBin_bNewResourceFile, LoadFont(#Gadget_RashadBin_bNewResourceFile, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_bNewResourceFile, "Create a new datasection include file from the current list of resources")
      ButtonGadget(#Gadget_RashadBin_bWritelisttofile, 120, 40, 100, 34, "Save list", #PB_Button_MultiLine)
        SetGadgetFont(#Gadget_RashadBin_bWritelisttofile, LoadFont(#Gadget_RashadBin_bWritelisttofile, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_bWritelisttofile, "Write the current list of selected resources to disk for later")
      ButtonGadget(#Gadget_RashadBin_bLoadlistfromfile, 220, 5, 100, 34, "Load list", #PB_Button_MultiLine)
        SetGadgetFont(#Gadget_RashadBin_bLoadlistfromfile, LoadFont(#Gadget_RashadBin_bLoadlistfromfile, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_bLoadlistfromfile, "Load a previous list of resources to add to")
      ButtonGadget(#Gadget_RashadBin_bClearcurrentlist, 220, 40, 100, 34, "Clear list", #PB_Button_MultiLine)
        SetGadgetFont(#Gadget_RashadBin_bClearcurrentlist, LoadFont(#Gadget_RashadBin_bClearcurrentlist, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_bClearcurrentlist, "Clear the current list of resources")
      FrameGadget(#Gadget_RashadBin_fSeparator2, 325, 5, 5, 70, "", #PB_Frame_Double)
      SpinGadget(#Gadget_RashadBin_sColumnsPerLine, 336, 25, 90, 25, 0, 100, #PB_Spin_ReadOnly|#PB_Spin_Numeric)
        GadgetToolTip(#Gadget_RashadBin_sColumnsPerLine, "The number of columns of hexadecimal data allowed per line")
      ComboBoxGadget(#Gadget_RashadBin_cAllowedfiletypes, 435, 25, 150, 25)
        SetGadgetFont(#Gadget_RashadBin_cAllowedfiletypes, LoadFont(#Gadget_RashadBin_cAllowedfiletypes, "Comic Sans MS", 10, 0))
        GadgetToolTip(#Gadget_RashadBin_cAllowedfiletypes, "What resouce file type to display in the file list")
      TextGadget(#Gadget_RashadBin_lColumns, 335, 55, 250, 15, " No of columns           Allowed fIletypes")
      FrameGadget(#Gadget_RashadBin_fSeparator3, 590, 5, 5, 70, "", #PB_Frame_Double)
      StringGadget(#Gadget_RashadBin_sCurrentresourcelist, 598, 21, 349, 23, "", #PB_String_ReadOnly|#PB_String_BorderLess)
        SetGadgetColor(#Gadget_RashadBin_sCurrentresourcelist, #PB_Gadget_BackColor, $C0C0C0)
        SetGadgetFont(#Gadget_RashadBin_sCurrentresourcelist, LoadFont(#Gadget_RashadBin_sCurrentresourcelist, "Comic Sans MS", 9, 0))
        GadgetToolTip(#Gadget_RashadBin_sCurrentresourcelist, "The name of the currently in-use list of resources")
      StringGadget(#Gadget_RashadBin_sCurrentdatafile, 598, 51, 350, 23, "", #PB_String_ReadOnly|#PB_String_BorderLess)
        SetGadgetColor(#Gadget_RashadBin_sCurrentdatafile, #PB_Gadget_BackColor, $C0C0C0)
        SetGadgetFont(#Gadget_RashadBin_sCurrentdatafile, LoadFont(#Gadget_RashadBin_sCurrentdatafile, "Comic Sans MS", 9, 0))
        GadgetToolTip(#Gadget_RashadBin_sCurrentdatafile, "The name of the currently in-use data section file")
      FrameGadget(#Gadget_RashadBin_fSeparator4, 955, 5, 5, 70, "", #PB_Frame_Double)
      ButtonGadget(#Gadget_RashadBin_bExithisprogram, 965, 5, 100, 74, "Exit", #PB_Button_MultiLine)
        SetGadgetFont(#Gadget_RashadBin_bExithisprogram, LoadFont(#Gadget_RashadBin_bExithisprogram, "Comic Sans MS", 26, 0))
        GadgetToolTip(#Gadget_RashadBin_bExithisprogram, "Exit this program immediatey.")
      CloseGadgetList()
      StringGadget(#Gadget_RashadBin_sStatusbar, 5, 745, 1070, 20, "", #PB_String_ReadOnly|#PB_String_BorderLess)
      HideWindow(#Window_RashadBin, 0)
    ProcedureReturn WindowID(#Window_RashadBin)
  EndIf
EndProcedure

; Generic modules

Declare   AdjustSpinGadget(Gadget.i)                                                                  ; 
Declare.s MakeSureDirectoryPathExists(Directory.s)                                                    ; 

; Custom modules

Declare   RemoveGadgetBorders(GadgetConstant.i)                                                       ; 
Declare   ShowFilesFromDirectoryTree()                                                                ; 
Declare   SortListIconEntries()                                                                       ; 

; Handling datasection files

Declare   SetNewDataSectionFile()                                                                     ; 
Declare   Savetocurrentdatasectionfile()                                                              ; 

; Handling resource list files

Declare   ClearCurrentResourceList()                                                                  ; 
Declare   DeleteFromResourceFileList()                                                                ; 
Declare   LoadResourceList()                                                                          ; 
Declare   SetNewResourceFileList()                                                                    ; 
Declare   WriteCurrentResourceList()                                                                  ; 

; Drag and drop handlers

Declare   DragToResourceFileList()                                                                    ; 
Declare   DropOnResourceFileList(DragType.s)                                                          ; 

; 

Declare   SetFileTreeAllowedType()                                                                    ; 

; Need a unicode aware version of the API directory creator for database directory, temporary directory and maybe others

Import "shell32.lib"                                                                                 ; Import 32 bit shell library
  SHCreateDirectory(*hwnd, pszPath.p-unicode)                                                         ; Grab the function that you want
EndImport                                                                                            ; End function import

; 

UseJPEG2000ImageDecoder()                                                                             ; 
UseJPEGImageDecoder()                                                                                 ; 
UsePNGImageDecoder()                                                                                  ; 
UseTGAImageDecoder()                                                                                  ; 
UseTIFFImageDecoder()                                                                                 ; 

; 

#AtTheEndOfTheList = -1                                                                               ; 
#EmptyString       = ""                                                                               ; 
#NoFileHandle      = 0                                                                                ; 
#NoCurrentLine     = 0                                                                                ; 
#NoListItems       = 0                                                                                ; 

; 

#NameColumn       = 0                                                                                 ; 
#TypeColumn       = 1                                                                                 ; 
#DirectoryColumn  = 2                                                                                 ; 

; My personal constants

#Author                         = "Miklós G Bolváry, "                                                ; Author's name
#CopyRight                      = "MGB Technical Services 2016 "                                      ; Copyright holder
#Basename                       = "RashadBIN"                                                         ; Base name for initialisation file and database
#Version                        = "v0.00."                                                            ; Program version
#Program                        = #Basename + #Version                                                ; Copyright string
#SystrayNote                    = "Hello, " + #Program + " is hiding here"                            ; System tray note

; 

Structure ProgramData
  QuitValue.i                                                                                        ; Program quit flag
  
  Currentdirectory.s                                                                                 ; Current directory string
  CurrentDataSectionFile.i                                                                           ; Currently open datasection file handle
  CurrentDataSectionFileName.s                                                                       ; Currently open datasection file name
  
  SelectedTreeDirectory.s                                                                            ; Last selected tree directory
  SelectedTreeFileTypes.s                                                                            ; File types to display
  
  SavedIncludesDirectory.s                                                                           ; All generated datasection files
  ResourceListDirectory.s                                                                            ; Saved lists of resource files
EndStructure

; 

Global Program.ProgramData                                                                          ; 

; 

Program\CurrentDirectory          = GetCurrentDirectory()                                            ; 

Program\SavedIncludesDirectory.s  = Program\CurrentDirectory  + "Store\Datasections\"                ; 
Program\ResourceListDirectory.s   = Program\CurrentDirectory  + "Store\Resourcelists\"               ; 

; Create your program directories

MakeSureDirectoryPathExists(Program\SavedIncludesDirectory)                                          ; All generated datasection files
MakeSureDirectoryPathExists(Program\ResourceListDirectory)                                           ; Saved lists of resource files 

; Gadget enumerations

Enumeration #GadgetIndex
  #ExplorerListSplitter                                                                              ;   
EndEnumeration

; Reusable spingadget control

Procedure AdjustSpinGadget(Gadget.i)
  SetGadgetText(Gadget.i, Str(GetGadgetState(Gadget.i)))
EndProcedure

; Need a unicode aware version of the API directory creator

Procedure.s MakeSureDirectoryPathExists(Directory.s)
  ; 
  Protected Message.s
  ; 
  ErrorCode.i = SHCreateDirectory(#Null, Directory.s)
  ; 
  Select ErrorCode.i
    Case #ERROR_SUCCESS               : Message.s = "Directory created"                            ; ResultCode = 0
    Case #ERROR_BAD_PATHNAME          : Message.s = "Bad directory path"                           ; ResultCode = 161
    Case #ERROR_FILENAME_EXCED_RANGE  : Message.s = "Directory path too long"                      ; ResultCode = 206
    Case #ERROR_FILE_EXISTS           : Message.s = "Directory already exists"                     ; ResultCode = 80
    Case #ERROR_ALREADY_EXISTS        : Message.s = "Directory already exists"                     ; ResultCode = 183
   ;Case #ERROR_CANCELLED             : Message.s = "User cancelled creation"                       ; ResultCode = ??. Not defined in compiler residents
  EndSelect
  ; 
  ProcedureReturn Message.s
  ; 
  ; Debug MakeSureDirectoryPathExists("c:\1\2\3\4\5\6")
  ; 
EndProcedure

; Remove borders from various gadgets

Procedure RemoveBorders(GadgetConstant.i)
  ; Get the gadget type from the passed gadget constant
  GadgetType.i = GadgetType(GadgetConstant.i)
  ; Select the gadget type
  Select GadgetType.i
    ; Do the below if it is a ListIconGadget
    Case  #PB_GadgetType_ListIcon
      ; Remove borders from ListIconGadgets
      OldStyle.i  = GetWindowLongPtr_(GadgetID(GadgetConstant.i), #GWL_EXSTYLE)
      NewStyle.i  = OldStyle.i & ( ~ #WS_EX_CLIENTEDGE)
      SetWindowLongPtr_(GadgetID(GadgetConstant.i), #GWL_EXSTYLE, NewStyle.i)
      SetWindowPos_(GadgetID(GadgetConstant.i), 0, 0, 0, 0, 0, #SWP_SHOWWINDOW | #SWP_NOSIZE | #SWP_NOMOVE | #SWP_FRAMECHANGED)
      ; No more control types
  EndSelect
  ; Nothing else to do here
EndProcedure

; Show tree spec files in the file list

Procedure ShowFilesFromDirectoryTree()
  ; 
  Program\SelectedTreeDirectory = GetGadgetText(#Gadget_RashadBin_DirectoryTree)
  ; 
  Program\SelectedTreeFileTypes  = GetGadgetText(#Gadget_RashadBin_cAllowedfiletypes)
  ; 
  SetGadgetText(#Gadget_RashadBin_FileTree, Program\SelectedTreeDirectory + Program\SelectedTreeFileTypes)
  ; 
  SetGadgetText(#Gadget_RashadBin_sStatusbar, "Showing: "  + Program\SelectedTreeDirectory  + Program\SelectedTreeFileTypes)
  ; 
EndProcedure

; Sort ListIconGadget as you need it. Based on Reg Venaglia's routine.

Procedure SortListIconEntries()
  ; 
  Structure ResourceData
    CurrentResourceName.s
    CurrentResourceType.s
    CurrentResourceDirectory.s
  EndStructure
  ; Get number items in ListIcon
  NumberOfItems.i = CountGadgetItems(#Gadget_RashadBin_FileList)
  ; Get number items in ListIcon
  If NumberOfItems.i  <> #NoListItems
    ; Get number items in ListIcon
    NewList Resource.ResourceData()
    ; Place each item text into the list. Must start at Zero
    For LoopCounter.i = 0 To NumberOfItems.i - 1
      AddElement(Resource())
      Resource()\CurrentResourceName      = GetGadgetItemText(#Gadget_RashadBin_FileList, LoopCounter.i, 0)
      Resource()\CurrentResourceType      = GetGadgetItemText(#Gadget_RashadBin_FileList, LoopCounter.i, 1)
      Resource()\CurrentResourceDirectory = GetGadgetItemText(#Gadget_RashadBin_FileList, LoopCounter.i, 2)
    Next LoopCounter 
    ; Sort the Array in ascending order
    SortStructuredList(Resource(), #PB_Sort_Ascending, OffsetOf(ResourceData\CurrentResourceName), #PB_String)
    ; Now replace ListIcon Items from the sorted Array
    ForEach Resource()
      SetGadgetItemText(#Gadget_RashadBin_FileList, ListIndex(Resource()), Resource()\CurrentResourceName,      0)
      SetGadgetItemText(#Gadget_RashadBin_FileList, ListIndex(Resource()), Resource()\CurrentResourceType,      1)
      SetGadgetItemText(#Gadget_RashadBin_FileList, ListIndex(Resource()), Resource()\CurrentResourceDirectory, 2)
    Next Resource()
    ; 
    ClearList(Resource())
    ; 
  EndIf
  ; 
EndProcedure

; Handling datasection files

Procedure SaveToCurrentDatasectionFile()
  ; 
  CurrentDataSectionFileName.s = GetGadgetText(#Gadget_RashadBin_sCurrentdatafile)
  ; 
  If CurrentDataSectionFileName.s <> #EmptyString
    ; Create the new file with full path and correct extension
    CurrentDataSectionFileHandle.i = CreateFile(#PB_Any, Program\SavedIncludesDirectory.s + CurrentDataSectionFileName.s)
    ; 
    If CurrentDataSectionFileHandle.i <> #NoFileHandle
      ; This is where RASHAD's magic file write code will go
      SetGadgetText(#Gadget_RashadBin_sStatusbar, GetFilePart(CurrentDataSectionFileName.s) + " saved")
      ; 
      CloseFile(CurrentDataSectionFileHandle.i)
      ; 
    Else
      SetGadgetText(#Gadget_RashadBin_sStatusbar, "Could not create the new datasection file")
    EndIf
    ; 
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "User didn't specify a file so we should just stop right now")
  EndIf
  ; 
EndProcedure

; 

Procedure SetNewDatasectionFile()
  ; Ask the user for a new filename
  NewDataSectionFileName.s = SaveFileRequester("New Purebasic Datasection include file to write to", Program\SavedIncludesDirectory.s, "Include file | *.pbi", 1)
  ; Get the correct extension for the filename if the user forgot
  CorrectExtension.i = SelectedFilePattern()
  ; Check which extension it was and add it
  Select  CorrectExtension.i
    Case 0
      If GetExtensionPart(NewDataSectionFileName.s) <> "pbi"
        ExtensionPart.s = ".pbi"
      EndIf
  EndSelect
  ; 
  If NewDataSectionFileName.s <> #EmptyString
    ; 
    SetGadgetText(#Gadget_RashadBin_sCurrentdatafile, GetFilePart(NewDataSectionFileName.s  + ExtensionPart.s))
    SetGadgetText(#Gadget_RashadBin_sStatusbar,       GetFilePart(NewDataSectionFileName.s  + ExtensionPart.s) + " set")
    ; 
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "User didn't choose a file so we should just stop right now")
  EndIf
  ; 
EndProcedure

; Handling resource list files

Procedure ClearResourceFileList()
  ; 
  ClearGadgetItems(#Gadget_RashadBin_FileList)
  ; 
  SetGadgetText(#Gadget_RashadBin_sStatusbar, "Resources cleared. Add new ones or load an old list.")
  ; 
EndProcedure

; 

Procedure DeleteFromResourceFileList()
  ; 
  CurrentLine.i = GetGadgetState(#Gadget_RashadBin_FileList)
  ; 
  If CurrentLine.i <> #NoCurrentLine
    RemoveGadgetItem(#Gadget_RashadBin_FileList, CurrentLine.i)
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "There is no current line, nothing to delete.")
  EndIf
  ; 
EndProcedure

; 

Procedure LoadResourceFileList()
  ; Ask the user for a new filename
  OldResourceListFile.s = OpenFileRequester("New resource file", Program\ResourceListDirectory.s, "Resource list | *.pbrsc", 0)
  ; Read the old file with full path and correct extension
  OldResourceList.i = ReadFile(#PB_Any, OldResourceListFile.s)
  ; 
  If OldResourceList.i <> #NoFileHandle
    ; 
    ClearGadgetItems(#Gadget_RashadBin_FileList)
    ; 
    ResourceFileName.s = ReadString(OldResourceList.i)
    ; 
    CurrentFileName.s = StringField(ResourceFileName.s, 1, "|")
    CurrentFileType.s = StringField(ResourceFileName.s, 2, "|")
    CurrentPathName.s = StringField(ResourceFileName.s, 3, "|")
    ; 
    AddGadgetItem(#Gadget_RashadBin_FileList, #AtTheEndOfTheList, CurrentFileName.s + #LF$ +  CurrentFileType   + #LF$  + CurrentPathName.s)
    ; 
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "Could not read the old resource list file")
  EndIf
  ; 
EndProcedure

; 

Procedure SaveResourceFileList()
  ; Ask the user for a new filename
  NewResourceListFile.s = SaveFileRequester("New resource file", Program\ResourceListDirectory.s + "Default resources list.pbrsc", "Resource list | *.pbrsc", 0)
  ; Check which extension it was and add it
  If GetExtensionPart(NewResourceListFile.s) <> "pbrsc"
    ExtensionPart.s = ".pbrsc"
  EndIf
  ; 
  If NewResourceListFile.s <> #EmptyString
    ; 
    NumberOfItemsInList.i = CountGadgetItems(#Gadget_RashadBin_FileList)
    ; 
    If NumberOfItemsInList.i <> #NoListItems
      ; Create the new file with full path and correct extension
      NewResourceList.i = CreateFile(#PB_Any, NewResourceListFile.s + ExtensionPart.s)
      ; 
      If NewResourceList.i <> #NoFileHandle
        ; 
        For ProcessItems.i = NumberOfItemsInList.i -1 To 0 Step -1
          CurrentFileName.s = GetGadgetItemText(#Gadget_RashadBin_FileList, ProcessItems.i, 0)
          CurrentFileType.s = GetGadgetItemText(#Gadget_RashadBin_FileList, ProcessItems.i, 1)
          CurrentPathName.s = GetGadgetItemText(#Gadget_RashadBin_FileList, ProcessItems.i, 2)
          WriteStringN(NewResourceList.i, CurrentFileName.s  + "|"  + CurrentFileType.s  + "|" + CurrentPathName.s)
        Next ProcessItems.i
        ; 
      Else
        SetGadgetText(#Gadget_RashadBin_sStatusbar, "Could not create the new resource list file")
      EndIf
      ; 
    Else
      SetGadgetText(#Gadget_RashadBin_sStatusbar, "Nothing in the list to save, we won't bother creating a file")
    EndIf
    ; 
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "User didn't choose a file so we should just stop right now")
  EndIf
  ; 
EndProcedure

; 

Procedure SetNewResourceFileList()
  ; Ask the user for a new filename
  NewResourceFileName.s = SaveFileRequester("New resources file list to save to", Program\ResourceListDirectory.s, "Resource file | *.pbrsc", 1)
  ; Get the correct extension for the filename if the user forgot
  CorrectExtension.i = SelectedFilePattern()
  ; Check which extension it was and add it
  Select  CorrectExtension.i
    Case 0
      If GetExtensionPart(NewResourceFileName.s) <> "pbrsc"
        ExtensionPart.s = ".pbrsc"
      EndIf
  EndSelect
  ; 
  If NewResourceFileName.s <> #EmptyString
    ; 
    SetGadgetText(#Gadget_RashadBin_sCurrentresourcelist, GetFilePart(NewResourceFileName.s  + ExtensionPart.s))
    SetGadgetText(#Gadget_RashadBin_sStatusbar,           GetFilePart(NewResourceFileName.s  + ExtensionPart.s) + " set")
    ; 
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "User didn't choose a file so we should just stop right now")
  EndIf
  ; 
EndProcedure

; 

Procedure DragToResourceFileList()
  ; 
  CurrentLine.i   = GetGadgetState(#Gadget_RashadBin_FileTree)
  ; 
  If CurrentLine.i <> #NoCurrentLine
    ; 
    ResourceName.s      = GetGadgetItemText(#Gadget_RashadBin_FileTree, CurrentLine.i, #NameColumn)
    ResourceType.s      = GetGadgetItemText(#Gadget_RashadBin_FileTree, CurrentLine.i, #TypeColumn)
    ResourceDirecory.s  = GetGadgetItemText(#Gadget_RashadBin_FileTree, CurrentLine.i, #DirectoryColumn)
    ; 
    If ResourceName.s <> #EmptyString
      DragText(ResourceName.s + "|" + ResourceType.s  + "|" + ResourceDirecory.s, #PB_Drag_Copy)
    EndIf
    ; 
  EndIf
  ; 
EndProcedure
; 

Procedure DropOnResourceFileList(DragType.s)
  ; 
  Select DragType.s
    Case "Text"
      CurrentResource.s = EventDropText()  
      If CurrentResource.s
        CurrentResourceName.s       = StringField(CurrentResource.s, 1, "|")
        CurrentResourceType.s       = StringField(CurrentResource.s, 2, "|")
        CurrentResourceDirectory.s  = StringField(CurrentResource.s, 3, "|")
      Else
        ; No text was dropped from the resource file list
      EndIf
    Case "Files"
      CurrentResource.s           = EventDropFiles()
      CurrentResourceName.s       = GetFilePart(CurrentResource.s)
      CurrentResourceType.s       = GetExtensionPart(CurrentResource.s)
      CurrentResourceDirectory.s  = GetPathPart(CurrentResource.s)
  EndSelect
  ; 
  ResourceListItems.i = CountGadgetItems(#Gadget_RashadBin_FileList)
  ; 
  ErrorFlag.i = #False
  ; 
  For ResourceListLoop.i = 0 To ResourceListItems.i - 1
    CurrentResourceItem.s = GetGadgetItemText(#Gadget_RashadBin_FileList, ResourceListLoop.i, #NameColumn)
    If LCase(CurrentResourceItem.s) = LCase(CurrentResourceName.s)
      ErrorFlag.i = #True
      Break
    EndIf
  Next  ResourceListLoop.i
  ; 
  If ErrorFlag.i = #False
    ; 
    AddGadgetItem(#Gadget_RashadBin_FileList, #AtTheEndOfTheList, CurrentResourceName.s + #LF$ + CurrentResourceType.s + #LF$ + CurrentResourceDirectory)
    ; 
    SortListIconEntries()
    ; 
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "Error: "  + CurrentResourceDirectory.s  + CurrentResourceName.s + " is already in the resource list")
  EndIf
  ; 
EndProcedure

; 

Procedure SetFileTreeAllowedType()
  ; 
  Program\SelectedTreeFileTypes  = GetGadgetText(#Gadget_RashadBin_cAllowedfiletypes)
  ; 
  SetGadgetText(#Gadget_RashadBin_FileTree, Program\SelectedTreeDirectory  + Program\SelectedTreeFileTypes)
  ; 
  SetGadgetText(#Gadget_RashadBin_sStatusbar, "Showing: "  + Program\SelectedTreeDirectory  + Program\SelectedTreeFileTypes)
  ; 
EndProcedure

; 

Procedure AddSingleFileToFileList()
  ; 
  CurrentLine.i       = GetGadgetState(#Gadget_RashadBin_FileTree)
  ; 
  CurrentResourceName.s       = GetFilePart(GetGadgetItemText(#Gadget_RashadBin_FileTree, CurrentLine.i, 0))
  CurrentResourceType.s       = GetExtensionPart(CurrentResourceName.s)
  CurrentResourceDirectory.s  = GetGadgetText(#Gadget_RashadBin_FileTree)
  ; 
  NumberOfItems.i     = CountGadgetItems(#Gadget_RashadBin_FileList)
  ; 
  If NumberOfItems.i  <>  0
    For CompareLoop.i = 0 To NumberOfItems.i - 1
      CompareFileName.s = GetGadgetItemText(#Gadget_RashadBin_FileList, CompareLoop.i, 0)
      CompareFileType.s = GetGadgetItemText(#Gadget_RashadBin_FileList, CompareLoop.i, 1)
      ComparePathName.s = GetGadgetItemText(#Gadget_RashadBin_FileList, CompareLoop.i, 2)
      If ComparePathName.s  + CompareFileName.s = CurrentResourceDirectory.s  + CurrentResourceName.s
        ErrorFlag.i = #True
        Break
      EndIf
    Next CompareLoop.i
  EndIf
  ; 
  If ErrorFlag.i = #False
    ; 
    AddGadgetItem(#Gadget_RashadBin_FileList, #AtTheEndOfTheList, CurrentResourceName.s + #LF$ + CurrentResourceType.s + #LF$ + CurrentResourceDirectory)
    ; 
    SortListIconEntries()
    ; 
  Else
    SetGadgetText(#Gadget_RashadBin_sStatusbar, "Error: "  + CurrentResourceDirectory.s  + CurrentResourceName.s + " is already in the resource list")
  EndIf
  ; 
EndProcedure

; Main Loop

If Window_RashadBin()
  ; 
  Program\QuitValue = #False
  ; 
  ; SetGadgetAttribute(#Gadget_RashadBin_FileTree, #PB_Explorer_DisplayMode, #PB_Explorer_LargeIcon)
  ; SetGadgetAttribute(#Gadget_RashadBin_FileList, #PB_ListIcon_DisplayMode, #PB_ListIcon_LargeIcon)
  ; 
  RemoveBorders(#Gadget_RashadBin_FileList)
  ; Enable resource adding by drag and drop
  EnableGadgetDrop(#Gadget_RashadBin_FileList, #PB_Drop_Text, #PB_Drag_Copy)
  EnableGadgetDrop(#Gadget_RashadBin_FileList, #PB_Drop_Files, #PB_Drag_Copy)
  ; 
  SplitterGadget(#ExplorerListSplitter, 440, 5, 635, 645, #Gadget_RashadBin_FileTree, #Gadget_RashadBin_FileList, #PB_Splitter_Separator)
  SetGadgetState(#ExplorerListSplitter, 450)
  GadgetToolTip(#ExplorerListSplitter,  "Pull me up or down to show more of either pane.")
  ; 
  SetGadgetState(#Gadget_RashadBin_sColumnsPerLine, 5)
  ; 
  AddGadgetItem(#Gadget_RashadBin_cAllowedfiletypes, #AtTheEndOfTheList, "*.*")
  AddGadgetItem(#Gadget_RashadBin_cAllowedfiletypes, #AtTheEndOfTheList, "*.Png")
  AddGadgetItem(#Gadget_RashadBin_cAllowedfiletypes, #AtTheEndOfTheList, "*.Jpg")
  AddGadgetItem(#Gadget_RashadBin_cAllowedfiletypes, #AtTheEndOfTheList, "*.Tif")
  AddGadgetItem(#Gadget_RashadBin_cAllowedfiletypes, #AtTheEndOfTheList, "*.Bmp")
  AddGadgetItem(#Gadget_RashadBin_cAllowedfiletypes, #AtTheEndOfTheList, "*.Tga")
  AddGadgetItem(#Gadget_RashadBin_cAllowedfiletypes, #AtTheEndOfTheList, "*.Ico")
  ; 
  SetGadgetState(#Gadget_RashadBin_cAllowedfiletypes, 0)
  ; 
  Program\SelectedTreeFileTypes = GetGadgetText(#Gadget_RashadBin_cAllowedfiletypes)
  Program\SelectedTreeDirectory = Program\CurrentDirectory  + "Images\_Other\"
  ; 
  SetGadgetText(#Gadget_RashadBin_DirectoryTree, Program\CurrentDirectory  + "Images\_Other\")
  ; 
  SetGadgetText(#Gadget_RashadBin_sCurrentresourcelist, "Default resources list.pbrsc")
  SetGadgetText(#Gadget_RashadBin_sCurrentdatafile,     "Default datasection.pbi")
  ; 
  PostEvent(#PB_Event_Gadget, #Window_RashadBin, #Gadget_RashadBin_DirectoryTree, #PB_EventType_Change)
  ; 
  Repeat
    ; 
    EventID  = WaitWindowEvent()
    MenuID   = EventMenu()
    GadgetID = EventGadget()
    WindowID = EventWindow()
    ; 
    Select EventID
      ; 
      Case #PB_Event_CloseWindow
        Select WindowID
          Case #Window_RashadBin                      : Program\QuitValue = #True
        EndSelect
        ; Drag and drop items between locations
      Case #PB_Event_GadgetDrop
        Select EventDropType()
          Case #PB_Drop_Text
            Select GadgetID
              Case #Gadget_RashadBin_FileList         : DropOnResourceFilelist("Text")
            EndSelect
          Case #PB_Drop_Files
            Select GadgetID
              Case #Gadget_RashadBin_FileList         : DropOnResourceFilelist("Files")
            EndSelect
        EndSelect
        ; 
      Case #PB_Event_Gadget
        Select GadgetID
          Case #Gadget_RashadBin_DirectoryTree
            Select EventType()
              Case #PB_EventType_LeftClick            : ShowFilesFromDirectoryTree()
              Case #PB_EventType_Change               : ShowFilesFromDirectoryTree()
            EndSelect
            ; 
          Case #Gadget_RashadBin_FileTree
            Select EventType()
              Case #PB_EventType_LeftDoubleClick      : AddSingleFileToFileList()
              Case #PB_EventType_RightDoubleClick     : ; ChangeResourceFileListView()
              Case #PB_EventType_DragStart            : DragToResourceFileList()
            EndSelect
            ; 
          Case #Gadget_RashadBin_FileList
            Select EventType()
              Case #PB_EventType_LeftDoubleClick      : DeleteFromResourceFileList()
            EndSelect
            ; 
          Case #Gadget_RashadBin_bNewdatafile         : SetNewDatasectionFile()
          Case #Gadget_RashadBin_bSavedatafile        : SaveToCurrentDatasectionFile()
          ; 
          Case #Gadget_RashadBin_bClearcurrentlist    : ClearResourceFileList()
          Case #Gadget_RashadBin_bLoadlistfromfile    : LoadResourceFileList()
          Case #Gadget_RashadBin_bWritelisttofile     : SaveResourceFileList()
          Case #Gadget_RashadBin_bNewResourceFile     : SetNewResourceFileList()
          ; 
          Case #Gadget_RashadBin_bExithisprogram      : Program\QuitValue = #True
          ; 
          Case #Gadget_RashadBin_sColumnsPerLine      : AdjustSpinGadget(#Gadget_RashadBin_sColumnsPerLine)
          Case #Gadget_RashadBin_cAllowedfiletypes    : SetFileTreeAllowedType()
          ; 
        EndSelect
        ; 
    EndSelect
    ; 
  Until Program\QuitValue
  ; 
  CloseWindow(#Window_RashadBin)
  ; 
EndIf
; 
End
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 12
; Folding = ---
; EnableXP
; CompileSourceDirectory