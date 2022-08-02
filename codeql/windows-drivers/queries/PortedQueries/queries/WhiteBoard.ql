/**
 * @name template
 * @kind path-problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/template
 */

import cpp
import Windows.wdk.wdm.SAL
import semmle.code.cpp.dataflow.DataFlow
import DataFlow::PathGraph

class ReturnMustBeCheckedFunctionCall extends FunctionCall {

  ReturnMustBeCheckedFunctionCall() { shouldResultBeChecked(this) }
}

predicate shouldResultBeChecked(FunctionCall fc) {
  exists(Function fc2, SALCheckReturn scr |
    fc.getTarget().calls*(fc2) and
    fc2.getADeclarationEntry() = scr.getDeclarationEntry()
  )
}

class ReturnCheck extends DataFlow::Configuration {
  ReturnCheck() { this = "ReturnCheck" }

  override predicate isSource(DataFlow::Node source) {
    exists(AssignExpr ae, VariableAccess va |
      ae.getLValue() = source.asExpr() and
      source.asExpr() = va and
      shouldResultBeChecked(ae.getRValue().(FunctionCall))
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(IfStmt ifs, VariableAccess va, ComparisonOperation co |
      ifs.getCondition() = co and
      co.getAnOperand() = va and
      sink.asExpr() = va
    )
  }
}

from ReturnCheck rc, DataFlow::Node source, DataFlow::Node sink
where rc.hasFlow(source, sink)
select sink, source, sink, "Call to a function made $@", source, " here", sink, " here"
