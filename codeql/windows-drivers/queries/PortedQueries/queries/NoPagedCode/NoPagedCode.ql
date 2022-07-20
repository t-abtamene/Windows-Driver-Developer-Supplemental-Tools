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

from Function f
where f instanceof FunctionDeclaredInPageSection and not f instanceof PagedFunc and f.getFile().getExtension() = ["c", "cpp"] and not isPragmaTheDefault(f)
select f, f.getName()
