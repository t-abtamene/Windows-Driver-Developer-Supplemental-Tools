/**
 * @name PendingStatusError
 * @kind problem
 * @description A dispatch routine that calls IoMarkIrpPending includes at least one path in which the driver returns a value other than STATUS_PENDING.
 * @problem.severity warning
 * @id cpp/portedqueries/pending-status-error
 * @version 1.0
 */

import cpp
import Windows.wdk.wdm.WdmDrivers

//Represents elements with IO_COMPLETION_ROUTINE type
class IORoutineTypedef extends TypedefType {
  IORoutineTypedef() { this.getName().matches("IO_COMPLETION_ROUTINE") }
}

//Evaluates to true for IO_COMPLETION_ROUTINE type routines.
predicate isIOCompletionRoutine(Function f) {
  exists(FunctionDeclarationEntry fde |
    fde.getFunction() = f and
    fde.getTypedefType() instanceof IORoutineTypedef
  )
}

from FunctionCall call, ReturnStmt rs
where
  call.getTarget().getName() = "IoMarkIrpPending" and
  call.getEnclosingFunction() instanceof WdmDispatchRoutine and
  not rs.getExpr().(Literal).getValue().toInt() = 259 and
  call.getEnclosingBlock().getLastStmt() = rs and
  not isIOCompletionRoutine(call.getEnclosingFunction())
select call.getEnclosingFunction(),
  "The return type should be STATUS_PENDING when making IoMarkIrpPending calls"
