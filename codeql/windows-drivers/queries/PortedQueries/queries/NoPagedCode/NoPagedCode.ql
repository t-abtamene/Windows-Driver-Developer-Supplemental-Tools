/**
 * @name NoPagedCode
 * @kind problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/no-paged-code
 */

import cpp
import Windows.wdk.wdm.WdmDrivers
import Windows.wdk.wdm.SAL

//Represents cases where a function has either PAGED_CODE OR PAGED_CODE_LOCKED invocations.
class PagedFunc extends Function {
  PagedFunc() {
    exists(MacroInvocation mi |
      mi.getEnclosingFunction() = this and
      mi.getMacroName() = ["PAGED_CODE", "PAGED_CODE_LOCKED"]
    )
  }
}

//evaluates to true if a function is placed in a PAGED section
predicate isInPagedCodeSection(Function f) {
  exists(PreprocessorPragma ppp |
    ppp.getHead().matches(["alloc_text%(%PAGE%", "code_seg%(%PAGE%"]) and
    ppp.getHead().suffix(ppp.getHead().indexOf(",")).matches("%" + f.getName() + "%")
  )
}

//evaluates true for functions that call PAGED_CODE() and are put in PAGED section
//but have conditional statements before PAGED_CODE() call.
predicate isPageCodeAfterIf(Function f) {
  exists(ConditionalStmt cs, MacroInvocation mi |
    isInPagedCodeSection(f) and
    f instanceof PagedFunc and
    cs.getEnclosingFunction() = f and
    mi.getEnclosingFunction() = f and
    mi.getMacroName() = ["PAGED_CODE", "PAGED_CODE_LOCKED"] and
    cs.getLocation().getStartLine() < mi.getStmt().getLocation().getStartLine()
  )
}

string message(Function f) {
  if isPageCodeAfterIf(f)
  then
    result =
      "The functions in pageable code must contain a PAGED_CODE or PAGED_CODE_LOCKED macro at the beginning of the function between the first brace ({ ) and the first conditional statement. Go to https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/28170-pageable-code-macro-not-found for more info."
  else
    result =
      "The function has been declared to be in a paged segment, but neither PAGED_CODE nor PAGED_CODE_LOCKED was found. Go to https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/28170-pageable-code-macro-not-found for more info."
}

from Function f
where
  isInPagedCodeSection(f) and not f instanceof PagedFunc
  or
  isPageCodeAfterIf(f)
select f, message(f)
