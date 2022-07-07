/**
 * @name PENDING_STATUS_ERROR
 * @kind problem
 * @description A dispatch routine that calls IoMarkIrpPending includes at least one path in which the driver returns a value other than STATUS_PENDING.
 * @problem.severity warning
 * @id cpp/portedqueries/pendingstatuserror
 */

import cpp

class IORoutineTypedef extends TypedefType {
  IORoutineTypedef() { this.getName().matches("IO_COMPLETION_ROUTINE") }
}

class DriverDispatchDRoutineTypedef extends TypedefType {
  DriverDispatchDRoutineTypedef() { this.getName().matches("DRIVER_DISPATCH") }
}

predicate isIOCompletionRoutine(Function f) {
  exists(FunctionDeclarationEntry fde |
    fde.getFunction() = f and
    fde.getTypedefType() instanceof IORoutineTypedef
  )
}

predicate isDriverDispatchRoutine(Function f) {
  exists(FunctionDeclarationEntry fde |
    fde.getFunction() = f and
    fde.getTypedefType() instanceof DriverDispatchDRoutineTypedef
  )
}

from FunctionCall call, ReturnStmt rs
where
  call.getTarget().getName() = "IoMarkIrpPending" and
  (
    rs.getExpr().getValueText() != "STATUS_PENDING" or
    rs.getExpr().(Literal).getValue().toInt() != 259
  ) and
  call.getEnclosingBlock().getLastStmt() = rs and
  not isIOCompletionRoutine(call.getEnclosingFunction()) and
  isDriverDispatchRoutine(call.getEnclosingFunction())
select call, "The return type should be STATUS_PENDING when making IoMarkIrpPending calls"
