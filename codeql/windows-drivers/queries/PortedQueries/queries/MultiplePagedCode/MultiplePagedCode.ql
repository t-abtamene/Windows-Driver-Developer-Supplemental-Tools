/**
 * @name MultiplePagedCode
 * @kind problem
 * @description The function has more than one instance of PAGED_CODE or PAGED_CODE_LOCKED.
 * @problem.severity warning
 * @id cpp/portedqueries/multiple-paged-code
 */

import cpp
import PortedQueries.PortLibrary.Page

//Selects functions/routines with two at least two PAGE_CODE invocations inside one function
from Function f, MacroInvocation mi, MacroInvocation mi2
where
  isInPagedCodeSection(f) and
  f instanceof PagedFunc and
  mi.getEnclosingFunction() = f and
  mi2.getEnclosingFunction() = f and
  mi.getStmt().getLocation().getStartLine() != mi2.getStmt().getLocation().getStartLine() and
  mi.getMacroName() = ["PAGED_CODE", "PAGED_CODE_LOCKED"] and
  mi2.getMacroName() = ["PAGED_CODE", "PAGED_CODE_LOCKED"]
select mi2,
  "Functions in a paged section must have exactly one instance of the PAGED_CODE or PAGED_CODE_LOCKED macro"
