Structure test_struct
  el.i
  text$
EndStructure

Global NewMap h.i()
Global NewList this.test_struct()

Procedure add_el(el, text$)
  
  If el = #PB_Any
    LastElement(this())
    elID = AddElement(this()) 
    el = @this()
  Else
    If (el > (ListSize(this()) - 1))
      LastElement(this())
      elID = AddElement(this()) 
    Else
      SelectElement(this(), el)
      elID = InsertElement(this())
    EndIf
  EndIf
  
  Debug "in "+ListIndex(this())+" e "+Str(el)+" h "+Str(@this())
  
  If elID
    With this()
      \el = el
      h(Str(el)) = elID;@this()
      \text$ = text$
    EndWith
  EndIf
  
  
EndProcedure


; add_el(1,"text_"+Str(1))
; add_el(11,"text_"+Str(11))
; add_el(111,"text_"+Str(111))

For i=1 To 10
  add_el(i,"text_"+Str(i))
Next

*elID = h(Str(6))
If *elID
  ChangeCurrentElement(this(), *elID)
  ;DeleteElement(this())
  MoveElement(this(), #PB_List_First)
EndIf

SelectElement(this(), 8)
Debug this()\text$

*elID = h(Str(8))

If *elID
  Debug "h "+Str(*elID)
  Debug ChangeCurrentElement(this(), *elID)
  Debug this()\text$
EndIf

ForEach this()
  Debug "_in "+ListIndex(this())+" e "+Str(this()\el)+" h "+Str(@this())
Next

