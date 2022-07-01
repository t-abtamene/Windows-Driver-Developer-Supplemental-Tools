/**
 * @name PENDING_STATUS_ERROR
 * @kind problem
 * @description A dispatch routine that calls IoMarkIrpPending includes at least one path in which the driver returns a value other than STATUS_PENDING.
 * @problem.severity warning
 * @id cpp/portedqueries/pendingstatuserror
 */

/* documentation from MSdoc*/

import cpp

from FunctionCall call, ReturnStmt rs
where
  call.getTarget().getName() = "IoMarkIrpPending" and
  (
    rs.getExpr().getValueText() != "STATUS_PENDING" or
    rs.getExpr().(Literal).getValue().toInt() != 259
  ) and
  call.getEnclosingFunction().getBlock().getLastStmt() = rs
select call, "The return type should be STATUS_PENDING when making IoMarkIrpPending calls"
