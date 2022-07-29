/**
 * @name IrqTooHigh
 * @kind problem
 * @description The function is not permitted to be called at the current IRQ level. The current level is too high.
 * @problem.severity warning
 * @id cpp/portedqueries/irq-too-high
 * @version 1.0
 */

import cpp
import PortedQueries.PortLibrary.Irql

predicate preceedingKeLowerIrqlCall(CallsToIrqlAnnotatedFunction iafc) {
  exists(FunctionCall fc2, Function fc3 |
    iafc.getAPredecessor*() = fc2 and
    (
      fc2.getTarget().getName() = "KeLowerIrql"
      or
      fc2.getTarget().calls*(fc3) and fc3.getName() = "KeLowerIrql"
    )
  )
}

from FunctionCall fc, FunctionCall kr
where
  kr.getTarget().getName().matches("KfRaiseIrql") and
  kr.getASuccessor*() = fc and
  isIrqlCall(fc) and
  getActualIrqlFunc(fc).(IrqlAnnotatedFunction).getIrqlLevel() <
    kr.getArgument(0).getValue().toInt() and
  not preceedingKeLowerIrqlCall(fc)
select fc, "Current Irql level too high for the function being called." + fc.getTarget().getName()
