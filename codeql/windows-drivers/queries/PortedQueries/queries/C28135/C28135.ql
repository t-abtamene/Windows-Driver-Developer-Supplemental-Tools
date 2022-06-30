/**
 * @name KE_WAIT_LOCAL
 * @kind problem
 * @description If the first argument to KeWaitForSingleObject is a local variable, the Mode parameter must be KernelMode
 * @problem.severity warning
 * @id cpp/portedqueries/kewaitlocal
 */

/* documentation from MSdoc*/
import cpp

class KeWaitForSingleObjectCall extends FunctionCall {
  KeWaitForSingleObjectCall() {
    // an array parameter
    getTarget().hasGlobalOrStdName("KeWaitForSingleObject") and
    not getArgument(2).getValueText() = "KernelMode"
  }
}

class MLocalVariable extends Variable {
  MLocalVariable() { this instanceof LocalVariable }
}

from VariableAccess va, MLocalVariable mlv, KeWaitForSingleObjectCall kwso
where
  va.getTarget() = mlv and
  va.getParent().getEnclosingElement() = kwso
select va,
  "KeWaitForSingleObject should have a KernelMode AccessMode when the first argument is local"
