import cpp

//Represents functions where a function has either PAGED_CODE OR PAGED_CODE_LOCKED invocations.
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
  exists(PreprocessorPragma ppp, MacroInvocation mi |
    ppp.getHead().matches(["alloc_text%(%PAGE%", "code_seg%(%PAGE%"]) and
    ppp.getHead().suffix(ppp.getHead().indexOf(",")).matches("%" + f.getName() + "%")
    or
    ppp.getHead().matches(["alloc_text%(%PAGE%", "code_seg%(%PAGE%"]) and
    ppp.getLocation().getStartLine() + 1 = f.getLocation().getStartLine()
    or
    ppp.getHead().matches(["alloc_text%(%PAGE%", "code_seg%(%PAGE%"]) and
    ppp.getLocation().getStartLine() + 2 = f.getLocation().getStartLine()
   
  )
}
