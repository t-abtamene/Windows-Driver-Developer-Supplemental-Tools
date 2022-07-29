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

from IrqlAnnotatedFunction iaf, CallsToIrqlAnnotatedFunction ciaf, int curr, int called
where
  ciaf.getEnclosingFunction() = iaf and
  iaf.getIrqlLevel() = curr and
  getActualIrqlFunc(ciaf).(IrqlAnnotatedFunction).getIrqlLevel() = called and
  curr < called
select ciaf,
  "Irql was set to " + curr + " in " + iaf.getName() +
    " but this function in its call hierarchy requires " + called + " Irql level."
