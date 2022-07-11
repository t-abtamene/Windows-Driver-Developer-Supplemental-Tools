/**
 * @name DISPATCH_MISMATCH
 * @kind problem
 * @description The dispatch function does not have a _Dispatch_type_ annotation matching this dispatch table entry
 * @problem.severity warning
 * @id cpp/portedqueries/C28168
 */

import cpp
import Windows.wdk.wdm.WdmDrivers

class AnnotatedDispatchs extends Function {
  AnnotatedDispatchs() {
    exists(DispatchTypeDefinition dmi, WdmDispatchRoutine wdr, FunctionDeclarationEntry fde |
      this = fde.getFunction() and
      fde = wdr.getADeclarationEntry() and
      dmi.getDeclarationEntry() = fde and
      not wdr.matchesAnnotation(dmi)
    )
  }
}

class NonAnnotatedDispatchs extends Function {
  NonAnnotatedDispatchs() {
    exists(DispatchTypeDefinition dmi, WdmDispatchRoutine wdr |
      this = wdr and
      dmi.getDeclarationEntry() = wdr.getADeclarationEntry()
    )
  }
}

from FunctionAccess fa, WdmDispatchRoutine wdm
where
  fa.getTarget() = wdm and not fa.getTarget() instanceof NonAnnotatedDispatchs
  or
  fa.getTarget() instanceof AnnotatedDispatchs
select fa,
  fa.getTarget() +
    " : The dispatch function does not have a _Dispatch_type_ annotation matching this dispatch table entry."
