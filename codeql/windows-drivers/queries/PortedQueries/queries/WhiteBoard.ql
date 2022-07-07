/**
 * @name template
 * @kind problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/template
 */

import cpp
from FunctionCall call select call
// import Windows.wdk.wdm.WdmDrivers

// class CX extends WdmCallbackRoutine {
//   CX() { callbackType.getName().matches("IO_COMPLETION_ROUTINE") }
// }

// from FunctionCall call, ReturnStmt rs
// where
//   call.getTarget().getName() = "IoMarkIrpPending" and
//   (
//     rs.getExpr().getValueText() != "STATUS_PENDING" or
//     rs.getExpr().(Literal).getValue().toInt() != 259
//   ) and
//   call.getEnclosingFunction().getBlock().getLastStmt() = rs and
//   not call.getEnclosingFunction() instanceof CX
// select call, "The return type should be STATUS_PENDING when making IoMarkIrpPending calls"

