/**
 * @name DISPATCH_MISSING
 * @kind problem
 * @description The dispatch function does not have any _Dispatch_type_ annotations
 * @problem.severity warning
 * @id cpp/portedqueries/C28169
 */

import cpp
import Windows.wdk.wdm.WdmDrivers
import Windows.wdk.wdm.SAL

class DriverDispatchDRoutineTypedef extends TypedefType {
  DriverDispatchDRoutineTypedef() { this.getName().matches("DRIVER_DISPATCH") }
}

predicate isDriverDispatchRoutine(Function f) {
  exists(FunctionDeclarationEntry fde |
    fde.getFunction() = f and
    fde.getTypedefType() instanceof DriverDispatchDRoutineTypedef
    //   and fde.getFile().getAnIncludedFile().getBaseName().matches("%wdm.h")
  )
}

class DispatchAnnotations extends SALAnnotation {
  DispatchAnnotations() { this.getMacroName() = ["_Dispatch_type_", "__drv_dispatchType"] }
}

class SALAnnotatedDispatchRoutines extends Function {
  SALAnnotatedDispatchRoutines() {
    exists(DispatchAnnotations da |
      isDriverDispatchRoutine(this) and
      da.getDeclaration() = this
    )
  }
}

predicate isMajorFunctionTableAssignments(Function f) {
  exists(AssignExpr ae, Expr exp |
    ae.getRValue() = exp and exp.(FunctionAccess).getTarget().getName() = f.getName()
  |
    ae.getLValue().(ArrayExpr).getArrayBase().toString() = "MajorFunction"
  )
}

from Function f
where
  isDriverDispatchRoutine(f) and
  not f instanceof SALAnnotatedDispatchRoutines and
  isMajorFunctionTableAssignments(f)
select f, f.getName()
