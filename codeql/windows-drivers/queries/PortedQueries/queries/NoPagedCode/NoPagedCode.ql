/**
 * @name NoPagedCode
 * @kind problem
 * @description The function has been declared to be in a paged segment, but neither PAGED_CODE nor PAGED_CODE_LOCKED was found.
 * @problem.severity warning
 * @id cpp/portedqueries/no-paged-code
 * @version 1.0
 */

import cpp
import PortedQueries.PortLibrary.Page

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
  f instanceof PSection and
  not f instanceof PagedFunc
  or
  f instanceof PSection and
  f instanceof PagedFunc and
  isPageCodeAfterIf(f)
select f, message(f)