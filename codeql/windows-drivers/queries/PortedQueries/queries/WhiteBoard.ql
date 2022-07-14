/**
 * @name template
 * @kind problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/template
 */

import cpp
import Windows.wdk.wdm.WdmDrivers
import Windows.wdk.wdm.SAL




from Function f
where f.getName() = "DriverEntry"
select f, "driver"