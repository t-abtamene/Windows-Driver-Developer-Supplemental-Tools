/**
 * @name IrqTooLow
 * @kind problem
 * @description The function is not permitted to be called at the current IRQ level. The current level is too low.
 * @problem.severity warning
 * @id cpp/portedqueries/irq-too-low
 * @version 1.0
 */

import cpp
import PortedQueries.PortLibrary.Irql


from IrqlAnnotatedFunctionCall nx, FunctionCall kr, FunctionCall kl
where
  kr.getTarget().getName().matches("KfRaiseIrql") and
  kr.getASuccessor*() = nx and
  nx.getTarget().(IrqlAnnotatedFunction).getIrqlLevel() > kr.getArgument(0).getValue().toInt()
//and kl.getTarget().getName().matches("KeLowerIrql")
select kr, "Current Irql level too low for the function being called."
