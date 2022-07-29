/**
 * @name template
 * @kind problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/template
 */

import cpp
// import semmle.code.cpp.dataflow.DataFlow
// import DataFlow::PathGraph
import PortedQueries.PortLibrary.Irql

predicate containsIrqlLevelCall(FunctionCall fc) {
  fc.getTarget() instanceof IrqlAnnotatedFunction
  or
  exists(FunctionCall fc2 |
    fc2.getControlFlowScope() = fc.getASuccessor() and
    containsIrqlLevelCall(fc2)
  )
}

// from FunctionCall fc, Function fc2
// where
//   fc.getTarget().getName() = "IrqlLowTestFunction" and
//   fc.getTarget().calls*(fc2)
//   and
//   // containsIrqlLevelCall(fc2) and
//   fc2 instanceof IrqlAnnotatedFunction
// select fc2, "this"

predicate x(FunctionCall fc){
  exists(FunctionCall fc2 | 
    fc.getASuccessor*() = fc2
    and
    fc2.getTarget().getName() = "KeLowerIrql")
}

from FunctionCall fc
where fc.getTarget().getName() = "IrqlLowTestFunction"
and not x(fc)
select fc, "this"
