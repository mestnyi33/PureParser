;- Enumerate module
DeclareModule Enumerate
  EnableExplicit
  
  Declare StartImage( )
  Declare StartWindow( )
  Declare StartGadget( Window = #PB_All )
  
  Declare NextImage( *Image.Integer )
  Declare NextWindow( *Window.Integer )
  Declare NextGadget( *Gadget.Integer ) 
  
  Declare AbortImage( )
  Declare AbortWindow( )
  Declare AbortGadget( )
  
  Declare CountImage( )
  Declare CountWindow( )
  Declare CountGadget( Window = #PB_All )
EndDeclareModule

Module Enumerate
  Global GadgetCount
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Import ""
    CompilerElse
      ImportC ""
      CompilerEndIf
      PB_Object_EnumerateStart( PB_Objects )
      PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
      PB_Object_EnumerateAbort( PB_Objects )
      
      PB_Object_Count( PB_Objects )
      
      PB_Window_Objects.i
      PB_Gadget_Objects.i
      PB_Image_Objects.i
    EndImport
    
    Procedure IDImage( ImageID )
      Protected.I Result = - 1, Image
      
      If ImageID
        PB_Object_EnumerateStart( PB_Image_Objects )
        
        While PB_Object_EnumerateNext( PB_Image_Objects, @Image )
          If ( IsImage( Image ) And ImageID( Image ) = ImageID )
            Result = Image
          EndIf
        Wend
        
        PB_Object_EnumerateAbort( PB_Image_Objects )
      EndIf  
      
      ProcedureReturn Result
    EndProcedure
    Procedure IDGadget( GadgetID )
      Protected.I Result = - 1, Gadget
      
      If GadgetID
        PB_Object_EnumerateStart( PB_Gadget_Objects )
        
        While PB_Object_EnumerateNext( PB_Gadget_Objects, @Gadget )
          If ( IsGadget( Gadget ) And GadgetID( Gadget ) = GadgetID )
            Result = Gadget
          EndIf
        Wend
        
        PB_Object_EnumerateAbort( PB_Gadget_Objects )
      EndIf  
      
      ProcedureReturn Result
    EndProcedure
    Procedure IDWindow( WindowID )
      Protected.I Result = - 1, Window
      
      If WindowID
        PB_Object_EnumerateStart( PB_Window_Objects )
        
        While PB_Object_EnumerateNext( PB_Window_Objects, @Window )
          If ( IsWindow( Window ) And WindowID( Window ) =  WindowID )
            Result = Window
          EndIf
        Wend
        
        PB_Object_EnumerateAbort( PB_Window_Objects )
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure GadgetParentID( Gadget, ParentID = #PB_Ignore ) ; Если указан родитель возвращает гаджет иначе хендел родителя
      Protected GadgetID = ParentID
      If IsGadget( Gadget )
        ParentID = GadgetID( Gadget )
        
        While ParentID
          CompilerSelect #PB_Compiler_OS 
            CompilerCase #PB_OS_Windows
              ParentID = GetParent_( ParentID )
            CompilerCase #PB_OS_Linux
              ParentID = gtk_widget_get_parent_( ParentID )
          CompilerEndSelect
          
          If GadgetID = #PB_Ignore
            If IsWindow( IDWindow( ParentID ) )
              ProcedureReturn ParentID 
            ElseIf IsGadget( IDGadget( ParentID ))
              ProcedureReturn ParentID 
            EndIf
          Else
            If GadgetID = ParentID
              ProcedureReturn Gadget
            EndIf
          EndIf
        Wend
      EndIf
    EndProcedure
    
    
    Procedure StartImage( ) ;Returns pb image count 
      Protected Image =-1
      
      If PB_Image_Objects
        Global Dim EnumerateImage.I(0)
        PB_Object_EnumerateStart( PB_Image_Objects )
        
        While PB_Object_EnumerateNext( PB_Image_Objects, @Image )
          If IsImage( Image )
            ReDim EnumerateImage( ArraySize( EnumerateImage() ) + (1) ) :EnumerateImage( ArraySize( EnumerateImage() ) ) = Image
          EndIf
        Wend
        
        PB_Object_EnumerateAbort( PB_Image_Objects )
      EndIf  
      
      ProcedureReturn ArraySize( EnumerateImage() )
    EndProcedure
    Procedure StartWindow( ) ;Returns pb window count 
      Protected Window =-1
      
      If PB_Window_Objects
        Global Dim EnumerateWindow.I(0)
        PB_Object_EnumerateStart( PB_Window_Objects )
        
        While PB_Object_EnumerateNext( PB_Window_Objects, @Window )
          If IsWindow( Window )
            ReDim EnumerateWindow( ArraySize( EnumerateWindow() ) + (1) ) :EnumerateWindow( ArraySize( EnumerateWindow() ) ) = Window
          EndIf
        Wend
        
        PB_Object_EnumerateAbort( PB_Window_Objects )
      EndIf  
      
      ProcedureReturn ArraySize( EnumerateWindow() )
    EndProcedure
    Procedure StartGadget( Window = #PB_All ) ;Returns pb gadget count 
      Shared GadgetCount                      ; Количество найденных гаджетов
      Protected ParentGadget, Gadget =-1
      
      If PB_Gadget_Objects ; Заносим в промежуточный лист все гаджеты
        Protected Dim EnumerateList.I(0) :PB_Object_EnumerateStart( PB_Gadget_Objects )
        While PB_Object_EnumerateNext( PB_Gadget_Objects, @Gadget )
          If IsGadget( Gadget )
            ReDim EnumerateList( ArraySize( EnumerateList() ) + (1) ) :EnumerateList( ArraySize( EnumerateList() ) ) = Gadget
          EndIf
        Wend
        PB_Object_EnumerateAbort( PB_Gadget_Objects )
      EndIf  
      
      If ArraySize( EnumerateList() )
        Global Dim EnumerateGadget.I(0)
        While ArraySize( EnumerateList() ) 
          If ArraySize( EnumerateList() )
            ; Чтение из массива                                    ; Уменьшаем массив на один элемент
            Gadget = EnumerateList( ArraySize( EnumerateList() ) ) :ReDim EnumerateList( ArraySize( EnumerateList() ) - (1) )
            
            If IsGadget( Gadget )
              If Window = #PB_Any 
                ReDim EnumerateGadget( ArraySize( EnumerateGadget() ) + (1) ) :EnumerateGadget( ArraySize( EnumerateGadget() ) ) = Gadget
              Else
                If IsWindow( Window ) ; Если праверяемое окно и окно гаджета похожи
                  ParentGadget = GadgetParentID( Gadget, WindowID( Window ) )
                ElseIf IsGadget( Window ) ; Если праверяемый гаджет и родител родителей гаджета похожи
                  ParentGadget = GadgetParentID( Gadget, GadgetID( Window ) )
                Else
                  ParentGadget = GadgetParentID( Gadget, Window )
                EndIf
                
                If ParentGadget = Gadget
                  ReDim EnumerateGadget( ArraySize( EnumerateGadget() ) + (1) ) :EnumerateGadget( ArraySize( EnumerateGadget() ) ) = Gadget
                EndIf  
              EndIf
            EndIf
          EndIf 
        Wend
        
        FreeArray( EnumerateList())
        GadgetCount = ArraySize( EnumerateGadget() ) ; Количество найденных гаджетов
      EndIf  
      
      ProcedureReturn ArraySize( EnumerateGadget() )
    EndProcedure
    
    
    Procedure NextImage( *Image.Integer ) ;Returns next enumerate pb ImageID 
      Protected Image = EnumerateImage( ArraySize( EnumerateImage() ) )
      
      If ArraySize( EnumerateImage() )
        ReDim EnumerateImage( ArraySize( EnumerateImage() ) - (1) )
        
        If IsImage( Image )
          PokeI( *Image, PeekI( @Image ) )
          ProcedureReturn ImageID( Image )
        EndIf 
      EndIf
    EndProcedure
    Procedure NextWindow( *Window.Integer ) ;Returns next enumerate pb WindowID 
      Protected Window = EnumerateWindow( ArraySize( EnumerateWindow() ) )
      
      If ArraySize( EnumerateWindow() )
        ReDim EnumerateWindow( ArraySize( EnumerateWindow() ) - (1) )
        
        If IsWindow( Window )
          PokeI( *Window, PeekI( @Window ) )
          ProcedureReturn WindowID( Window )
        EndIf 
      EndIf
    EndProcedure
    Procedure NextGadget( *Gadget.Integer ) ;Returns next enumerate pb GadgetID 
      Protected Gadget = EnumerateGadget( ArraySize( EnumerateGadget() ) )
      
      If ArraySize( EnumerateGadget() )
        ReDim EnumerateGadget( ArraySize( EnumerateGadget() ) - (1) )
        
        If IsGadget( Gadget )
          PokeI( *Gadget, PeekI( @Gadget ) )
          ProcedureReturn GadgetID( Gadget )
        EndIf 
      EndIf
    EndProcedure
    
    
    Procedure AbortImage() ;Abort enumerate image
      If EnumerateImage()
        FreeArray( EnumerateImage() ) :ProcedureReturn #True
      EndIf
    EndProcedure
    Procedure AbortWindow() ;Abort enumerate window
      If EnumerateWindow()
        FreeArray( EnumerateWindow() ) :ProcedureReturn #True
      EndIf
    EndProcedure
    Procedure AbortGadget() ;Abort enumerate gadget
      If EnumerateGadget()
        FreeArray( EnumerateGadget() ) :ProcedureReturn #True
      EndIf
    EndProcedure
    
    Procedure CountImage() ;Returns count image
      ProcedureReturn PB_Object_Count( PB_Image_Objects )
    EndProcedure
    Procedure CountWindow() ;Returns count window
      ProcedureReturn PB_Object_Count( PB_Window_Objects )
    EndProcedure
    Procedure CountGadget( Window = #PB_All ) ;Returns count gadget
      If Window = #PB_All
        ProcedureReturn PB_Object_Count( PB_Gadget_Objects )
      Else
        ProcedureReturn GadgetCount
      EndIf
    EndProcedure
    
  EndModule
  
  
  CompilerIf #PB_Compiler_IsMainFile
    X = 100
    For i = 1 To 4
      OpenWindow(i, 200, X, 150, 60, "Window_" + Trim(Str(i)))
      ContainerGadget(100 * (i), 5, 5, 120,50, #PB_Container_Flat)
        ButtonGadget(10 * (i),10,10,100,15,"Button_" + Trim(Str(i*10)))
        ButtonGadget((i),10,25,100,15,"Button_" + Trim(Str(i)))
      CloseGadgetList() ; ContainerGadget
      X + 100
    Next
    
    Debug "Begen enumerate window"
    If Enumerate::StartWindow( )
      While Enumerate::NextWindow( @Window )
        Debug "Window ID = "+Window
      Wend
      Enumerate::AbortWindow()
    EndIf
    Debug "All CountWindows = " + Enumerate::CountWindow()
    Debug ""
    
    Debug "Begen enumerate all gadget"
    If Enumerate::StartGadget( )
      While Enumerate::NextGadget( @Gadget )
        Debug "Gadget ID = "+Gadget
      Wend
      Enumerate::AbortGadget() 
    EndIf
    Debug "All windows CountGadgets = " + Enumerate::CountGadget()
    Debug ""
    
    Window = 3
    Debug "Begen enumerate gadget window = 3"
    If Enumerate::StartGadget( Window )
      While Enumerate::NextGadget( @Gadget )
        Debug "Gadget ID = "+Str(Gadget) +" Window ID = "+ Window
      Wend
      Debug "CountGadgets = " + Enumerate::CountGadget(Window) + " Window ID = " + Str(Window)
      Enumerate::AbortGadget() 
    EndIf
    
    Debug ""
    Debug "Begen enumerate gadget gadget = 300"
    Window = GadgetID(300)
    If Enumerate::StartGadget( Window )
      While Enumerate::NextGadget( @Gadget )
        Debug "Gadget ID = "+Str(Gadget) +" Window ID = "+ Window
      Wend
      Enumerate::AbortGadget() 
    EndIf
    Debug "CountGadgets = " + Enumerate::CountGadget(Window) + " Window ID = " + Str(Window)
    
    Repeat
      If Enumerate::CountWindow( ) 
        Event = WaitWindowEvent( )
        If Event = #PB_Event_CloseWindow
          CloseWindow( EventWindow( ) )
          Debug "Close " + EventWindow( )
        EndIf
      Else 
        Break
      EndIf
    ForEver
    
    Debug "Exit"
  CompilerEndIf
  
  ; IDE Options = PureBasic 5.22 LTS (Linux - x86)
  ; CursorPosition = 38
  ; FirstLine = 13
  ; Folding = 7AAAcAw-
  ; EnableUnicode
  ; EnableXP
  ; Executable = C:/Users/mestnyi/Enumerate.dll