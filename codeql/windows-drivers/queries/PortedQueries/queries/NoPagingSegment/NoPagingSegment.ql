/**
 * @name NoPagingSegment
 * @kind problem
 * @description The function has PAGED_CODE or PAGED_CODE_LOCKED but is not declared to be in a paged segment
 * @problem.severity warning
 * @id cpp/portedqueries/no-paging-segment
 */

import cpp
import PortedQueries.PortLibrary.Page

from Function f
where not isInPagedCodeSection(f) and f instanceof PagedFunc
select f,
  "A function that contains a PAGED_CODE or PAGED_CODE_LOCKED macro has not been placed in paged memory by using #pragma alloc_text or #pragma code_seg."
