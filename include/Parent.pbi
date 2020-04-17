DeclareModule ID
  Declare Window(WindowID)
  Declare Gadget(GadgetID)
EndDeclareModule

Module ID
  CompilerSelect #PB_Compiler_OS
      ;- Windows
    CompilerCase #PB_OS_Windows
      Procedure Window( WindowID ) ; Return the id of the window from the window handle
        Protected Window = GetProp_( WindowID, "PB_WindowID" ) - 1
        
        If ( IsWindow( Window ) And 
             WindowID( Window ) = WindowID )
          
          ProcedureReturn Window
        EndIf
        
        ProcedureReturn - 1
      EndProcedure
      
      Procedure Gadget( GadgetID )  ; Return the id of the gadget from the gadget handle
        Protected Gadget = GetProp_( GadgetID, "PB_ID" )
        
        If ( IsGadget( Gadget ) And 
             GadgetID( Gadget ) = GadgetID )
          
          ProcedureReturn Gadget
        EndIf
        
        ProcedureReturn - 1
      EndProcedure
      ;- Linux&MacOS
    CompilerDefault
      ImportC ""
        PB_Gadget_Objects.i
        PB_Window_Objects.i
        
        PB_Object_EnumerateStart( PB_Objects )
        PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
        PB_Object_EnumerateAbort( PB_Objects )
      EndImport
      
      Procedure Window( WindowID )  ; Return the id of the gadget from the gadget handle
        Static Handle
        Static Window =- 1
        
        If Handle ! WindowID
          PB_Object_EnumerateStart( PB_Window_Objects )
          
          If PB_Window_Objects
            While PB_Object_EnumerateNext( PB_Window_Objects, @Window )
              If WindowID = WindowID( Window )
                Break
              Else
                Window = -1
              EndIf
            Wend
            
            PB_Object_EnumerateAbort( PB_Window_Objects )
          EndIf  
          Handle = WindowID
        EndIf
        
        ProcedureReturn Window
      EndProcedure
      
      Procedure Gadget( GadgetID ) ; Return the id of the window from the window handle
        Protected Gadget = -1
        PB_Object_EnumerateStart( PB_Gadget_Objects )
        
        If PB_Gadget_Objects
          While PB_Object_EnumerateNext( PB_Gadget_Objects, @Gadget )
            If GadgetID = GadgetID( Gadget )
              Break
            Else
              Gadget = -1
            EndIf
          Wend
          
          PB_Object_EnumerateAbort( PB_Gadget_Objects )
        EndIf  
        
        ProcedureReturn Gadget
      EndProcedure
      
  CompilerEndSelect
EndModule

;
DeclareModule Parent
  Declare Window( Gadget )
  Declare Parent(Gadget)
  Declare Get( Handle )
  Declare Set( Gadget, ParentID, Item=#PB_Default )
EndDeclareModule

CompilerSelect #PB_Compiler_OS
    ;- Linux
  CompilerCase #PB_OS_Linux
    Module Parent
      ImportC ""
        gtk_widget_get_window(*widget.GtkWidget)
        gtk_notebook_get_tab_vborder(*Notebook.GtkNotebook)
        gtk_notebook_get_tab_hborder(*Notebook.GtkNotebook)
      EndImport
      
      ImportC ""
        gdk_window_get_effective_toplevel (*window)
        gdk_screen_get_active_window (*Screen.GdkScreen)
      EndImport
      
      Macro gtk_children( _handle_, _children_ = 0 ) : g_list_nth_data_(gtk_container_get_children_(_handle_), _children_) : EndMacro
      Macro gtk_widget(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_widget_get_type_ ()) : EndMacro
      Macro gtk_container(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_container_get_type_ ()) : EndMacro
      Macro gtk_fixed(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_fixed_get_type_ ()) : EndMacro
      Macro gtk_box(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_box_get_type_ ()) : EndMacro
      Macro gtk_window(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_window_get_type_ ()) : EndMacro
      Macro gtk_frame(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_frame_get_type_ ()) : EndMacro
      Macro gtk_table(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_table_get_type_ ()) : EndMacro
      Macro gtk_hbox(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_hbox_get_type_ ()) : EndMacro
      Macro gtk_vbox(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_hbox_get_type_ ()) : EndMacro
      Macro gtk_vpaned(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_vpaned_get_type_ ()) : EndMacro
      Macro gtk_bin(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_bin_get_type_ ()) : EndMacro
      Macro gtk_viewport(_handle_) : gtk_widget_get_ancestor_ (_handle_, gtk_viewport_get_type_ ()) : EndMacro
      
      Procedure pb_parent( GadgetID, Item=-1 )
        CompilerIf #PB_Compiler_Version <562
          GadgetID = gtk_widget(GadgetID)
        CompilerEndIf
        
        If GadgetID              
           Select PeekS(gtk_widget_get_name_(GadgetID),-1,#PB_UTF8)
            Case "GtkWindow"
              GadgetID = g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(GadgetID)), 0)
              CompilerIf #PB_Compiler_Version > 531 And #PB_Compiler_Version < 560 ; ?????
                GadgetID = g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(GadgetID)), 0)
              CompilerEndIf
              ProcedureReturn GadgetID
              
            Case "GtkScrolledWindow"
              ProcedureReturn g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(GadgetID)), 0)
              
            Case "GtkNotebook"
              If Item=-1 : Item=gtk_notebook_get_current_page_( GadgetID ) : EndIf
              ProcedureReturn gtk_notebook_get_nth_page_(GadgetID, Item) 
              
            Case "GtkFixed",  "GtkLayout"
              ProcedureReturn GadgetID
              
           EndSelect 
        EndIf
      EndProcedure
      
      Procedure pb_widget( GadgetID )
        If GadgetID 
          If gtk_fixed(GadgetID) = gtk_container(GadgetID)
            ProcedureReturn gtk_widget(GadgetID)
          Else
            ProcedureReturn gtk_container (GadgetID)
          EndIf
        EndIf
      EndProcedure
      
      Procedure Window(Gadget) ; Return the handle of the parent window from the gadget handle
        ProcedureReturn ID::Window(gtk_widget_get_toplevel_ ( GadgetID(Gadget) ))
      EndProcedure
      
      Procedure Parent(Gadget) ; Return the handle of the parent gadget from the gadget handle
        ProcedureReturn ID::Gadget(Get(GadgetID(Gadget)))
      EndProcedure
      
      Procedure Get( Handle ) ; Return the handle of the parent from the handle
        Protected Widget, Name.i
        
        While Handle
          Widget = handle
          Handle = gtk_widget_get_parent_( Handle )
          
          
          ;                     If IsWindow( ID::Window( Handle )) Or IsGadget( ID::Gadget( Handle ))
          ;                       ProcedureReturn Handle
          ;                     EndIf
          
          If Handle
            Name = gtk_widget_get_name_( Handle )
            If Name And PeekS( Name, -1, #PB_UTF8 ) = "GtkScrolledWindow" 
              If gtk_frame(Handle)
                ProcedureReturn gtk_children(Widget)
              EndIf
              ProcedureReturn Handle
            ElseIf Name And PeekS( Name, -1, #PB_UTF8 ) = "GtkNotebook" 
              ProcedureReturn Handle
            ElseIf gtk_vpaned(Handle)
              ProcedureReturn gtk_vpaned(Widget)
            EndIf
          EndIf
        Wend
        
      EndProcedure
      
      Procedure Set( Gadget, ParentID, Item=#PB_Default ) ; Set a new parent for the gadget
        If IsGadget( Gadget )
          Protected GtkWidget,GtkWidget1
          Protected *GtkWidget.GtkWidget, GadgetX, GadgetY, GtkFixed, GadgetID = GadgetID( Gadget )
          
          GtkFixed = pb_parent( ParentID, Item)
          GadgetX = GadgetX( Gadget, #PB_Gadget_ContainerCoordinate) 
          GadgetY = GadgetY( Gadget, #PB_Gadget_ContainerCoordinate)
          
          *GtkWidget = pb_widget( GadgetID )
          
          Select GadgetType( Gadget )
            Case #PB_GadgetType_ExplorerList, #PB_GadgetType_ExplorerTree, 
                 #PB_GadgetType_ListIcon, #PB_GadgetType_Tree, #PB_GadgetType_ListView,
                 #PB_GadgetType_Panel, #PB_GadgetType_Editor, #PB_GadgetType_Scintilla ; get GtkScrolledWindow
              
              gtk_widget_reparent_( gtk_bin( *GtkWidget ) , GtkFixed )
              ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
              
            Case #PB_GadgetType_Container ; get GtkFrame
              gtk_widget_reparent_( gtk_frame(  *GtkWidget  ), GtkFixed )
              ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
              
            Case #PB_GadgetType_ComboBox, #PB_GadgetType_Image ; get GtkEventBox
              gtk_widget_reparent_( gtk_widget_get_parent_(*GtkWidget), GtkFixed )
              ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
              
            Case #PB_GadgetType_Text ; get GtkBox
              gtk_widget_reparent_( gtk_box((*GtkWidget)) , GtkFixed )
              ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
              
              ;             Case #PB_GadgetType_splitter
              ;                Debug PeekS( gtk_widget_get_name_( *GtkWidget ), -1, #PB_UTF8 )
              ;                Debug PeekS( gtk_widget_get_name_( gtk_box(((*GtkWidget)) ) ), -1, #PB_UTF8 )
              ;               gtk_widget_reparent_( gtk_box((*GtkWidget)) , GtkFixed )
              ;               ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
              
              
            Default
              
              If GtkFixed
                gtk_widget_reparent_( *GtkWidget\object, GtkFixed ) 
                ResizeGadget( Gadget, GadgetX, GadgetY, #PB_Ignore, #PB_Ignore )
                
                CompilerIf #PB_Compiler_Version =< 531
                  If PeekS( gtk_widget_get_name_( ParentID ), -1, #PB_UTF8 ) = "GtkNotebook" ; #PB_GadgetType_Panel
                    If *GtkWidget\parent
                      GadgetX = GadgetX + *GtkWidget\parent\allocation\x
                      GadgetY = GadgetY + *GtkWidget\parent\allocation\y 
                    EndIf
                  EndIf
                  
                  gtk_widget_set_uposition_( *GtkWidget\object, GadgetX, GadgetY )
                CompilerEndIf
              Else
                Debug "Desktop"
                Protected wscreen = gdk_screen_get_default_() ; экран по умолчанию
                Protected screen = gtk_widget_get_screen_(GadgetID)
                
                Protected display = gdk_display_get_default_()
                Protected wdisplay = gtk_widget_get_display_(GadgetID)
                Protected sdisplay = gdk_screen_get_display_ (wscreen)
                
                Debug gdk_screen_get_number_ (wscreen)
                
                Debug ID::Window(gdk_screen_get_active_window (wscreen))
                
                Debug ID::Window(gdk_get_default_root_window_())
                Debug ID::Window(gdk_screen_get_root_window_ (wscreen))
                Debug ID::Window(gtk_widget_get_root_window_(GadgetID)) ; устарел gdk_screen_get_root_window_ (gtk_widget_get_screen_(GadgetID))
                
                Debug gdk_screen_get_active_window (wscreen)
                
                Debug gdk_get_default_root_window_()
                Debug gdk_screen_get_root_window_ (wscreen)
                Debug gtk_widget_get_root_window_(GadgetID) ; устарел gdk_screen_get_root_window_ (gtk_widget_get_screen_(GadgetID))
                
                ;gdk_screen_get_toplevel_windows ()
                Debug wscreen
                Debug screen
                
                Debug display
                Debug wdisplay
                
                Debug "gdk_window_get_toplevel_ "+gdk_window_get_toplevel_(gtk_widget_get_window(GadgetID))
                Debug "gdk_window_get_effective_toplevel "+gdk_window_get_effective_toplevel(gtk_widget_get_window(GadgetID))
                Debug "gtk_widget_get_window "+gtk_widget_get_window(GadgetID)
                Debug "gtk_widget_get_parent_window_ "+gtk_widget_get_parent_window_(GadgetID)
                Debug "WindowID(1) "+WindowID(10)
                Debug "WindowID(20) "+WindowID(20)
                
                Protected X,Y
                ;           Protected *Parent.GtkWidget = gdk_get_default_root_window_()
                ;           gtk_widget_reparent_( *GtkWidget\object, *Parent\name ) 
                Protected Win = gdk_window_get_toplevel_(gtk_widget_get_window(GadgetID))
                ;gdk_window_reparent_ (gdk_window_get_toplevel_(gtk_widget_get_window(GadgetID)), gtk_widget_get_window(WindowID(1)), x, y)
                
                ;gdk_window_reparent_ ((gtk_widget_get_window(GadgetID)), gdk_get_default_root_window_(), x, y)
                Protected *container.GtkContainer = gdk_get_default_root_window_()
                ;gtk_widget_reparent_ (((GadgetID)), *container\widget)
                Debug gtk_widget_get_ancestor_ (*GtkWidget, gtk_box_get_type_ ());#GTK_TYPE_Box)
                                                                                 ;gtk_widget_set_parent_window_ ( *GtkWidget,gtk_widget_get_parent_window_(GadgetID(5)));
              EndIf
          EndSelect
          
          ProcedureReturn ParentID
        EndIf
      EndProcedure
    EndModule
    ;- Windows
  CompilerCase #PB_OS_Windows
    Module Parent
      Procedure Window(Gadget) ; Return the handle of the parent window from the gadget handle
        ProcedureReturn ID::Window(GetAncestor_(GadgetID(Gadget), #GA_ROOT))
      EndProcedure
      
      Procedure Parent(Gadget) ; Return the handle of the parent gadget from the gadget handle
        ProcedureReturn ID::Gadget(Get(GadgetID(Gadget)))
      EndProcedure
      
      Procedure Get( Handle ) ; Return the handle of the parent from the handle
                              ;   Debug GetWindow_(ParentID, #GW_OWNER)
        
        While Handle
          Handle = GetParent_( Handle )
          
          If IsWindow( ID::Window( Handle )) Or
             IsGadget( ID::Gadget( Handle ))
            ProcedureReturn Handle
          ElseIf IsGadget( ID::Gadget( GetParent_( Handle ))) ; Это для скролл ареа гаджет
            ProcedureReturn GetParent_( Handle )
          EndIf
        Wend
        
      EndProcedure
      
      Procedure Set( Gadget, ParentID, Item=#PB_Default ) ; Set a new parent for the gadget
        
        ;   SetWindowLongPtr_(GadgetID( Gadget ), #GWLP_HWNDPARENT, ParentID)
        
        If IsGadget( Gadget )
          Protected Class$ = Space(16)
          GetClassName_( ParentID, @Class$, Len(Class$))
          
          Select Class$
            Case "PureScrollArea"  
              ParentID = FindWindowEx_( ParentID, 0, 0, 0 ) ; get child
            Case "SysTabControl32" 
              ; Get selected tab of the panel
              Protected TC_ITEM.TC_ITEM\Mask = #TCIF_PARAM 
              If Item=#PB_Default
                Item=SendMessage_( ParentID, #TCM_GETCURSEL, 0, 0 )
              EndIf
              SendMessage_( ParentID, #TCM_GETITEM, Item, @TC_ITEM )
              ParentID = TC_ITEM\lParam
          EndSelect 
          
          ; Set spin up/down control in the new parent
          If GadgetType( Gadget ) = #PB_GadgetType_Spin
            SetParent_( GetWindow_( GadgetID( Gadget ), #GW_HWNDNEXT ), ParentID )
          EndIf
          
          SetParent_( GadgetID( Gadget ), ParentID )
          
          ProcedureReturn ParentID
        EndIf
      EndProcedure
    EndModule
    
    ;- MacOS ok ; pb 562 ok mojave 10.12
  CompilerCase #PB_OS_MacOS
    Module Parent
      Procedure.s GetClass(handle.i)
        Protected Result
        
        CocoaMessage(@Result, CocoaMessage(0, handle, "className"), "UTF8String")
        
        If Result
          ProcedureReturn PeekS(Result, -1, #PB_UTF8)
        EndIf
      EndProcedure
      
      Procedure NSView(GadgetID)
        Protected handle = GadgetID
        
        While handle
          Select GetClass(handle)
            Case "NSScrollView", "PB_SpinView", "NSBox"
              GadgetID = handle
              Break
            Default
              handle = CocoaMessage(0, handle, "superview")
          EndSelect
        Wend
        
        ProcedureReturn GadgetID
      EndProcedure
      
      Procedure Window(Gadget) ; Return the handle of the parent window from the gadget handle
        ProcedureReturn ID::Window(CocoaMessage(0, GadgetID(Gadget), "window"))
      EndProcedure
      
      Procedure Parent(Gadget) ; Return the handle of the parent gadget from the gadget handle
        ProcedureReturn ID::Gadget(Get(GadgetID(Gadget)))
      EndProcedure
      
      Procedure Get( Handle ) ; Return the handle of the parent from the handle
        While Handle
          Handle = CocoaMessage(0, Handle, "superview")
          
          If IsWindow( ID::Window( Handle )) Or IsGadget( ID::Gadget( Handle ))
            ProcedureReturn Handle
          EndIf
        Wend
      EndProcedure
      
      Procedure Set( Gadget, ParentID, Item=#PB_Default ) ; Set a new parent for the gadget
        Protected GadgetID =  GadgetID (Gadget)
        
        If IsGadget( Gadget )
          If ParentID
            Select GetClass(ParentID)
              Case "PBTabView", "PB_CanvasView"
                ParentID = CocoaMessage(0, ParentID, "subviews")
                ParentID = CocoaMessage(0, ParentID, "objectAtIndex:", CocoaMessage(0, ParentID, "count") - 1)
              Default
                ParentID = CocoaMessage(0, ParentID, "contentView")
            EndSelect
            
            CocoaMessage (0, ParentID, "addSubview:", NSView(GadgetID)) 
          Else
            ; to desktop move
          EndIf
          
          ProcedureReturn ParentID
        EndIf
      EndProcedure
    EndModule
CompilerEndSelect

CompilerIf #PB_Compiler_IsMainFile
  UseModule Parent
 
  Procedure GadgetIDType(GadgetID)
    If GadgetID
      CompilerSelect #PB_Compiler_OS 
        CompilerCase #PB_OS_Windows
          Protected Class$ = Space(16)
          GetClassName_( GadgetID, @Class$, Len(Class$))
          
          Select Class$
            Case "PureContainer" : ProcedureReturn #PB_GadgetType_Container
            Case "PureScrollArea" : ProcedureReturn #PB_GadgetType_ScrollArea
            Case "SysTabControl32" : ProcedureReturn #PB_GadgetType_Panel
          EndSelect 
          
        CompilerCase #PB_OS_Linux
          Protected *notebook.GtkNotebook = GadgetID
          If *notebook\children
            If *notebook\first_tab = *notebook\children
              ProcedureReturn #PB_GadgetType_Panel
            ElseIf *notebook\packed_flags
              ProcedureReturn - 1
            Else
              ProcedureReturn #PB_GadgetType_ScrollArea
            EndIf
          Else
            ProcedureReturn #PB_GadgetType_Container
          EndIf
      CompilerEndSelect
    EndIf
  EndProcedure 
  
  
  Define Flags = #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
  OpenWindow(10, 0, 0, 630+210, 320, "demo set gadget new parent", Flags )

  PanelGadget(1, 10,150,200,160) 
  AddGadgetItem(1,-1,"Panel") 
   ButtonGadget(60, 30,90,160,30,"Button >>(Panel (0))") 
  AddGadgetItem(1,-1,"Second") 
   ButtonGadget(61, 35,90,160,30,"Button >>(Panel (1))") 
  AddGadgetItem(1,-1,"Third") 
   ButtonGadget(62, 40,90,160,30,"Button >>(Panel (2))") 
  CloseGadgetList()
  
  ContainerGadget(2, 215,150,200,160,#PB_Container_Flat) 
  ButtonGadget(7, 30,90,160,30,"Button >>(Container)") 
  CloseGadgetList()
  
  ScrollAreaGadget(3, 420,150,200,160,200,160,10,#PB_ScrollArea_Flat) 
  ButtonGadget(8, 30,90,160,30,"Button >>(ScrollArea)") 
  CloseGadgetList()
  
  CanvasGadget(10, 630,150,200,160,#PB_Canvas_Container) 
  ButtonGadget(11, 30,90,160,30,"Button >>(Canvas)") 
  CloseGadgetList()
  
  
  ButtonGadget(4, (630-160)/2,90-25-35,160,30,"Button >>(Desktop)") 
  ButtonGadget(600, (630-160)/2,90-25,160,20,"Button >>(Panel (0))") 
  ButtonGadget(601, (630-160)/2,90,160,20,"Button >>(Panel (1))") 
  ButtonGadget(602, (630-160)/2,90+25,160,20,"Button >>(Panel (2))") 
  
  ButtonGadget(5, 30,90,160,25,"Button >>(Window)")
  ButtonGadget(9, 30,115,160,25,"Button <<(Back)") 
 
  
  Flags = #PB_Window_Invisible | #PB_Window_TitleBar
  OpenWindow(20, WindowX( 10 )-210, WindowY( 10 ), 200, 320, "old parent", Flags, WindowID(10))
  
  ButtonGadget(20,30,10,150,70,"ButtonGadget") 
  
  ComboBoxGadget( 21,30,90,150,30 ) 
  AddGadgetItem( 21, -1, "Selected gadget to move")
  AddGadgetItem( 21, -1, "ButtonGadget")
  AddGadgetItem( 21, -1, "StringGadget")
  AddGadgetItem( 21, -1, "TextGadget")
  AddGadgetItem( 21, -1, "CheckBoxGadget")
  AddGadgetItem( 21, -1, "OptionGadget")
  AddGadgetItem( 21, -1, "ListViewGadget")
  AddGadgetItem( 21, -1, "FrameGadget")
  AddGadgetItem( 21, -1, "ComboBoxGadget")
  AddGadgetItem( 21, -1, "ImageGadget")
  AddGadgetItem( 21, -1, "HyperLinkGadget")
  AddGadgetItem( 21, -1, "ContainerGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ListIconGadget")
  AddGadgetItem( 21, -1, "IPAddressGadget")
  AddGadgetItem( 21, -1, "ProgressBarGadget")
  AddGadgetItem( 21, -1, "ScrollBarGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ScrollAreaGadget"); Win = Ok
  AddGadgetItem( 21, -1, "TrackBarGadget")
  AddGadgetItem( 21, -1, "WebGadget")
  AddGadgetItem( 21, -1, "ButtonImageGadget")
  AddGadgetItem( 21, -1, "CalendarGadget")
  AddGadgetItem( 21, -1, "DateGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "EditorGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ExplorerListGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ExplorerTreeGadget") ; Win = Ok
  AddGadgetItem( 21, -1, "ExplorerComboGadget"); Win = Ok
  AddGadgetItem( 21, -1, "SpinGadget")         ; Win = Ok
  AddGadgetItem( 21, -1, "TreeGadget")         ; Ok
  AddGadgetItem( 21, -1, "PanelGadget")        ; Ok
  AddGadgetItem( 21, -1, "SplitterGadget")     ; Win = Ok
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddGadgetItem( 21, -1, "MDIGadget") ; Ok
  CompilerEndIf
  AddGadgetItem( 21, -1, "ScintillaGadget") ; Ok
  AddGadgetItem( 21, -1, "ShortcutGadget")  ; Ok
  AddGadgetItem( 21, -1, "CanvasGadget")    ;Ok
  
  SetGadgetState( 21, #PB_GadgetType_Button) : PostEvent(#PB_Event_Gadget, 20, 21, #PB_EventType_Change)
  
  HideWindow(10,0)
  HideWindow(20,0)
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      ImportC ""
        gtk_widget_get_window(*widget.GtkWidget)
        gdk_device_get_window_at_position ( *device.GdkDevice ,
                                            *win_x,
                                            *win_y)
      EndImport
  CompilerEndSelect
  
  Procedure EnterGadget( )
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Define GadgetID,X1,Y1,mask
        Define WindowID, X,Y, *Widget.GtkWidget = gdk_window_at_pointer_(0,0);@x,@y)
        
        
        
        If *Widget 
          Debug gdk_window_get_window_type_ (*Widget)
          ;Debug gdk_device_get_window_at_position(gdk_display_get_default_(),0,0)
          ;Debug  g_list_nth_data_(gtk_container_get_children_(gtk_bin_get_child_(*Widget\name)), 0)
          ;Debug gtk_widget_get_ancestor_ (*Widget\parent, gtk_widget_get_type_ ())
          ; Debug PeekS( gtk_widget_get_name_( gtk_widget_get_ancestor_ (*Widget, gtk_widget_get_type_ ()) ), -1, #PB_UTF8 )
          ;            If *Widget\object And *Widget\name 
          ;              ;Debug gtk_widget_get_pointer_(*Widget\name,@X1,@Y1)
          ;              ;Debug gdk_window_get_pointer_(*Widget\object,@X1,@Y1,@mask)
          ; ;              Debug gdk_window_get_children_(*Widget\object);,@X1,@Y1,@mask)
          ;              Debug ID::Gadget(gtk_widget_get_ancestor_ (*Widget, gtk_widget_get_type_ ()))
          ;           ; Debug gtk_frame_get_label_widget_(*Widget\name )
          ; ;             If GtkGadgteID(*Widget\name)
          ; ;                 ProcedureReturn ID::Gadget( GtkGadgteID(*Widget\name) )
          ; ;               Else
          ; ;                 ; для ползунка 
          ; ; ;                 ThumbID (*Widget\name)
          ; ;               EndIf
          ;           EndIf
          ;         Else
          ;           Debug "За окном"
        EndIf
        
    CompilerEndSelect
  EndProcedure    
  
  Repeat
    Define Event=WaitWindowEvent()
    
    CompilerSelect #PB_Compiler_OS
        ;- Linux
      CompilerCase #PB_OS_Linux
        Define.i MouseEvent,X,Y, mask, *Window.GTKWindow = WindowID( EventWindow() ) 
        gdk_window_get_pointer_(gdk_get_default_root_window_(), @x, @y, @mask)
        ;gdk_window_get_pointer_(gtk_widget_get_window(gtk_widget_get_ancestor_ (WindowID( EventWindow() ) , gtk_widget_get_type_ ())), @x, @y, @mask)
        If      (mask & #GDK_BUTTON1_MASK) :MouseEvent = #PB_EventType_LeftButtonDown
        ElseIf  (mask & #GDK_BUTTON3_MASK) :MouseEvent = #PB_EventType_RightButtonDown
        ElseIf  (mask & #GDK_BUTTON2_MASK) :MouseEvent = #PB_EventType_MiddleButtonDown
        Else
          MouseEvent = #False
        EndIf
        
        If MouseEvent
          Debug EnterGadget( )
        EndIf
    CompilerEndSelect
    
    If Event=#PB_Event_Gadget 
      Select EventType()
        Case #PB_EventType_LeftClick, #PB_EventType_Change
          Select EventGadget()
            Case 4 : Set(20, 0)
            Case 5 : Set(20, WindowID(10))
            Case 60, 600 : Set(20, GadgetID(1), 0)
            Case 61, 601 : Set(20, GadgetID(1), 1)
            Case 62, 602 : Set(20, GadgetID(1), 2)
            Case 7 : Set(20, GadgetID(2))
            Case 8 : Set(20, GadgetID(3))
            Case 11 : Set(20, GadgetID(10))
            Case 9 : Set(20, WindowID(20))
              
            Case 21
              Select EventType()
                Case #PB_EventType_Change
                  Define ParentID = Get( GadgetID(20) )
                  
                  Select GetGadgetState( 21 )
                    Case 1 :ButtonGadget(20,30,20,150,30,"ButtonGadget") 
                    Case 2 :StringGadget(20,30,20,150,30,"StringGadget") 
                    Case 3 :TextGadget(20,30,20,150,30,"TextGadget", #PB_Text_Border) 
                    Case 4 :OptionGadget(20,30,20,150,30,"OptionGadget") 
                    Case 5 :CheckBoxGadget(20,30,20,150,30,"CheckBoxGadget") 
                    Case 6 :ListViewGadget(20,30,20,150,30) 
                    Case 7 :FrameGadget(20,30,20,150,30,"FrameGadget") 
                    Case 8 :ComboBoxGadget(20,30,20,150,30) :AddGadgetItem(20,-1,"ComboBoxGadget") :SetGadgetState(20,0)
                    Case 9 :ImageGadget(20,30,20,150,30,0,#PB_Image_Border) 
                    Case 10 :HyperLinkGadget(20,30,20,150,30,"HyperLinkGadget",0) 
                    Case 11 :ContainerGadget(20,30,20,150,30,#PB_Container_Flat)   :ButtonGadget(-1,0,0,80,20,"ButtonGadget") :CloseGadgetList() ; ContainerGadget
                    Case 12 :ListIconGadget(20,30,20,150,30,"",88) 
                    Case 13 :IPAddressGadget(20,30,20,150,30) 
                    Case 14 :ProgressBarGadget(20,30,20,150,30,0,5)
                    Case 15 :ScrollBarGadget(20,30,20,150,30,5,335,9)
                    Case 16 :ScrollAreaGadget(20,30,20,150,30,305,305,9,#PB_ScrollArea_Flat) :ButtonGadget(-1,0,0,80,20,"ButtonGadget") :CloseGadgetList()
                    Case 17 :TrackBarGadget(20,30,20,150,30,0,5)
                      ;Case 18 :WebGadget(20,30,20,150,30,"") ; bug 531 linux
                    Case 19 :ButtonImageGadget(20,30,20,150,30,0)
                    Case 20 :CalendarGadget(20,30,20,150,30) 
                    Case  21 :DateGadget(20,30,20,150,30)
                    Case 22 :EditorGadget(20,30,20,150,30)  : AddGadgetItem(20,-1,"EditorGadget")
                    Case 23 :ExplorerListGadget(20,30,20,150,30,"")
                    Case 24 :ExplorerTreeGadget(20,30,20,150,30,"")
                    Case 25 :ExplorerComboGadget(20,30,20,150,30,"")
                    Case 26 :SpinGadget(20,30,20,150,30,0,5,#PB_Spin_Numeric)
                    Case 27 :TreeGadget(20,30,20,150,30) : AddGadgetItem(20,-1,"TreeGadget") : AddGadgetItem(20,-1,"SubLavel",0,1)
                    Case 28 :PanelGadget(20,30,20,150,30) :AddGadgetItem(20,-1,"PanelGadget") :CloseGadgetList()
                    Case 29 
                      ButtonGadget(201,0,0,30,30,"1")
                      ButtonGadget(202,0,0,30,30,"2")
                      SplitterGadget(20,30,20,150,30,201,202)
                  EndSelect
                  
                  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                    Select GetGadgetState( 21 )
                      Case 30 :MDIGadget(20,30,10,150,70,0,0)
                      Case 31 :InitScintilla() :ScintillaGadget(20,30,10,150,70,0)
                      Case 32 :ShortcutGadget(20,30,10,150,70,0)
                      Case 33 :CanvasGadget(20,30,10,150,70) 
                    EndSelect
                  CompilerElse
                    Select GetGadgetState( 21 )
                      Case 30 :InitScintilla() :ScintillaGadget(20,30,10,150,70,0)
                      Case 31 :ShortcutGadget(20,30,10,150,70,0)
                      Case 32 :CanvasGadget(20,30,10,150,70) 
                    EndSelect
                  CompilerEndIf
                  
                  ResizeGadget(20,30,10,150,70)
                  
                  Set(20, ParentID) ; GadgetID(3));
                  
              EndSelect
          EndSelect
          
          If (EventGadget()<>20)
            Define Parent=Parent(20)
            If IsGadget(Parent)
              Debug "get parent "+Parent
            Else
              Debug "get parent "+Window(20)
            EndIf
            
            If IsGadget(201)
              Debug Str(Parent(201))+" "+GadgetX(201)+" "+GadgetY(201)+" "+GadgetWidth(201)+" "+GadgetHeight(201)
            EndIf
          EndIf
      EndSelect
    EndIf  
  Until Event=#PB_Event_CloseWindow
  
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = 9-6-----8-+-8---
; EnableXP