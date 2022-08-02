/**
 * @name ExaminedValue
 * @kind problem
 * @description The returned value is annotated with the _Check_return_ annotation, but the calling function is either not using the value or is overwriting the value without examining it.
 * @problem.severity warning
 * @id cpp/portedqueries/examined-value
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import PortedQueries.PortLibrary.Page
import Windows.wdk.wdm.WdmDrivers

class ReturnMustBeCheckedFunctionCall extends FunctionCall {
  ReturnMustBeCheckedFunctionCall() { shouldResultBeChecked(this) }
}

predicate shouldResultBeChecked(FunctionCall fc) {
  exists(Function fc2, SALCheckReturn scr |
    fc.getTarget().calls*(fc2) and
    fc2.getADeclarationEntry() = scr.getDeclarationEntry()
  )
}

predicate unused(Expr e) { e instanceof ExprInVoidContext }

predicate important(Function f, string message) {
  message = "the result of this function must always be checked." and
  getOptions().alwaysCheckReturnValue(f)
}

// statistically dubious ignored return values
predicate dubious(Function f, string message) {
  not important(f, _) and
  exists(Options opts, int used, int total, int percentage |
    used =
      count(FunctionCall fc |
        fc.getTarget() = f and not opts.okToIgnoreReturnValue(fc) and not unused(fc)
      ) and
    total = count(FunctionCall fc | fc.getTarget() = f and not opts.okToIgnoreReturnValue(fc)) and
    used != total and
    percentage = used * 100 / total and
    percentage >= 90 and
    message = percentage.toString() + "% of calls to this function have their result used."
  )
}

from ReturnMustBeCheckedFunctionCall unused, string message
where
  unused(unused) and
  not exists(Options opts | opts.okToIgnoreReturnValue(unused)) and
  (important(unused.getTarget(), message) or dubious(unused.getTarget(), message)) and
  not unused.getTarget().getName().matches("operator%") // exclude user defined operators
select (unused), "Result of call to " + unused.getTarget().getName() + " is ignored; " + message
