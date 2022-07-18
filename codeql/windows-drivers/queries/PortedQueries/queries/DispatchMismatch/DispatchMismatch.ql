/**
 * @name DispatchMismatch
 * @kind problem
 * @description The dispatch function does not have a _Dispatch_type_ annotation matching this dispatch table entry
 * @problem.severity warning
 * @id cpp/portedqueries/dispatch-mismatch
 */

import cpp
import Windows.wdk.wdm.WdmDrivers

//Represents functions whose declaration annotations don't match their expected annotation type
class MismatchedDispatches extends Function {
  MismatchedDispatches() {
    exists(DispatchTypeDefinition dmi, WdmDispatchRoutine wdr, FunctionDeclarationEntry fde |
      this = fde.getFunction() and
      fde = wdr.getADeclarationEntry() and
      dmi.getDeclarationEntry() = fde and
      not wdr.matchesAnnotation(dmi)
    )
  }
}

//Represents function with missing annotation in their declaration. 
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
  fa.getTarget() instanceof MismatchedDispatches
select fa.getTarget(),
  fa.getTarget() +
    " : The dispatch function does not have a _Dispatch_type_ annotation matching this dispatch table entry."
