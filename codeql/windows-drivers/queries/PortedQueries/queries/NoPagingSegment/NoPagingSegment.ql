/**
 * @name NoPagingSegment
 * @kind problem
 * @description The function has PAGED_CODE or PAGED_CODE_LOCKED but is not declared to be in a paged segment
 * @problem.severity warning
 * @id cpp/portedqueries/no-paging-segment
 * @version 1.0
 */


import cpp
import PortedQueries.PortLibrary.Page

from PagedFunc pf
where 
  not isPageCodeSectionSetAbove(pf) and
  not isPagedSegSetWithMacroAbove(pf) and
  not isAllocUsedToLocatePagedFunc(pf)
select pf, pf.getName()
