/**
 * @name template
 * @kind problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/template
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import PortedQueries.PortLibrary.Page

from AllocSegPragma ap
select ap, ap.getHead()
