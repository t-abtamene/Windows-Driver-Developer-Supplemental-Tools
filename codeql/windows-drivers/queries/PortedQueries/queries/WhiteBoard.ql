/**
 * @name template
 * @kind problem
 * @description template
 * @problem.severity warning
 * @id cpp/portedqueries/template
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import DataFlow::PathGraph





// predicate usingKeRaiseIrql(Expr e) {
//   exists(MacroInvocation mi |
//     mi.getExpr() = e and
//     mi.getMacroName().matches("KeRaiseIrql")
//     // and
//     // mi.getExpandedArgument(0).toInt() >= 1
//   )
// }

// class Irql extends DataFlow::Configuration {
//   Irql() { this = "Irql" }

//   override predicate isSource(DataFlow::Node source) {
    /* 
     * source.asExpr() instanceof VariableAccess and
     *    exists(AssignExpr ae |
     *      ae.getLValue().(PointerDereferenceExpr).getOperand().(AddressOfExpr).getOperand() =
     *        source.asExpr() and
     *      ae.getRValue().(FunctionCall).getTarget().getName() = "KfRaiseIrql"
     *    )
     */

//     usingKeRaiseIrql(source.asExpr())
//   }

//   override predicate isSink(DataFlow::Node sink) {
//     exists(FunctionCall call |
//       call.getTarget().hasGlobalOrStdName("KeLowerIrql") and
//       call.getArgument(0) = sink.asExpr()
//     )
//   }
// }

// from Irql irq, DataFlow::PathNode source, DataFlow::PathNode sink
// where irq.hasFlowPath(source, sink)
// select sink, source, sink, "Irql raised $@ and lowered $@", source, " here", sink, " here"
 