/**
 * @name template
 * @kind problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/template
 * @version 1.0
 */

import cpp

// import Windows.wdk.wdm.SAL
// import Windows.wdk.kmdf.KmdfDrivers
// import Windows.wdk.wdm.WdmDrivers
// import semmle.code.cpp.dataflow.DataFlow
// import DataFlow::PathGraph
from File f
where f.getFile().getShortName() = "fail_driver1"
select f, "this"
