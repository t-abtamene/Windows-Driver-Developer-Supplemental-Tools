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

predicate isIrqlCall(FunctionCall fc) {
  fc.getTarget() instanceof IrqlAnnotatedFunction
  or
  exists(FunctionCall fc2 |
    fc2.getControlFlowScope() = fc.getASuccessor() and
    isIrqlCall(fc2)
  )
}


from IrqlAnnotatedFunctionCall nx, FunctionCall kr, FunctionCall kl
where
  kr.getTarget().getName().matches("KfRaiseIrql") and
  kr.getASuccessor*() = nx and
  nx.getTarget().(IrqlAnnotatedFunction).getIrqlLevel() < kr.getArgument(0).getValue().toInt()
//and kl.getTarget().getName().matches("KeLowerIrql")
select kr, "Current Irql level too high for the function being called."
