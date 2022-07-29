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
//
predicate irqlAnnotationViolatingCall(CallsToIrqlAnnotatedFunction ciaf) {
  exists(IrqlAnnotatedFunction iaf, int curr, int called |
    ciaf.getEnclosingFunction() = iaf and
    iaf.getIrqlLevel() = curr and
    getActualIrqlFunc(ciaf).(IrqlAnnotatedFunction).getIrqlLevel() = called and
    curr > called and 
    not iaf.getFuncIrqlName().matches("%max%")
  )
}

//Evaluates to true if there is a call from KeRaiseIrql to a IrqlAnnotatedFunction before any KeLowerIrql call in between. 
predicate irqlNotLoweredCall(CallsToIrqlAnnotatedFunction fc) {
  exists(FunctionCall kr, int called, int curr |
    kr.getTarget().getName().matches("KfRaiseIrql") and
    kr.getASuccessor*() = fc and
    getActualIrqlFunc(fc).(IrqlAnnotatedFunction).getIrqlLevel() = called and
    kr.getArgument(0).getValue().toInt() = curr and
    called < curr and
    not preceedingKeLowerIrqlCall(fc)
  )
}

from CallsToIrqlAnnotatedFunction ciaf
where irqlNotLoweredCall(ciaf) or irqlAnnotationViolatingCall(ciaf)
select ciaf, " Current Irql level too high for " + ciaf.getTarget().getName()
