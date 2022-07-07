/**
 * @name PENDING_STATUS_ERROR
 * @kind problem
 * @description A dispatch routine that calls IoMarkIrpPending includes at least one path in which the driver returns a value other than STATUS_PENDING.
 * @problem.severity warning
 * @id cpp/portedqueries/pendingstatuserror
 */

import cpp

class WdmCallbackRoutineTypedef extends TypedefType {
  WdmCallbackRoutineTypedef() { this.getName().matches("IO_COMPLETION_ROUTINE") }
}

//Chooses functions whose Role Type is IO_COMPLETION_ROUTINE
class WdmCallbackRoutine extends Function {
  WdmCallbackRoutineTypedef callbackType;

  WdmCallbackRoutine() {
    exists(FunctionDeclarationEntry fde |
      fde.getFunction() = this and
      fde.getTypedefType() = callbackType
    )
  }
}

from FunctionCall call, ReturnStmt rs
where
  call.getTarget().getName() = "IoMarkIrpPending" and
  (
    rs.getExpr().getValueText() != "STATUS_PENDING" or
    rs.getExpr().(Literal).getValue().toInt() != 259
  ) and
  call.getEnclosingFunction().getBlock().getLastStmt() = rs and
  not call.getEnclosingFunction() instanceof WdmCallbackRoutine
select call, "The return type should be STATUS_PENDING when making IoMarkIrpPending calls"
