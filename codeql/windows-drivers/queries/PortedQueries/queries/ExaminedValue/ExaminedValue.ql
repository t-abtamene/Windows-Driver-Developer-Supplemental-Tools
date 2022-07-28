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

//Represents functions whose declaration annotations don't match their expected annotation type
class RetMustBeCheckedFunc extends Function {
  SALCheckReturn scr;

  RetMustBeCheckedFunc() { this.getADeclarationEntry() = scr.getDeclarationEntry() }

  string getCheckRetName() { result = scr.getMacroName() }
}

// from SALCheckReturn scr, FunctionCall fc
// where fc.getTarget().getADeclarationEntry() = scr.getDeclarationEntry()
// select scr, fc.getTarget().getName()
predicate unused(Expr e) { e instanceof ExprInVoidContext }

predicate important(Function f, string message) {
  message = "the result of this function must always be checked." and
  getOptions().alwaysCheckReturnValue(f) and
  f instanceof RetMustBeCheckedFunc
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

from FunctionCall unused, string message
where
  unused(unused) and
  not exists(Options opts | opts.okToIgnoreReturnValue(unused)) and
  (important(unused.getTarget(), message) or dubious(unused.getTarget(), message)) and
  not unused.getTarget().getName().matches("operator%") // exclude user defined operators
select unused, "Result of call to " + unused.getTarget().getName() + " is ignored; " + message
