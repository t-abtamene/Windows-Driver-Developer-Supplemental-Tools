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

//Represents elements in paged segment
class PSection extends Function {
  PSection() {
    exists(PreprocessorPragma ppp |
      ppp.getHead().matches("code\\_seg%") and
      ppp.getLocation().getStartLine() < this.getLocation().getStartLine()
      or
      this.getAnAttribute().getName().matches("code\\_seg%")
      or
      ppp.getHead().matches("%" + this.getName() + "%")
    )
  }
}


//evaluates true for functions that call PAGED_CODE() and are put in PAGED section
//but have conditional statements before PAGED_CODE() call.
predicate isPageCodeAfterIf(Function f) {
  exists(ConditionalStmt cs, MacroInvocation mi |
    f instanceof PagedFunc and
    cs.getEnclosingFunction() = f and
    mi.getEnclosingFunction() = f and
    mi.getMacroName() = ["PAGED_CODE", "PAGED_CODE_LOCKED"] and
    cs.getLocation().getStartLine() < mi.getStmt().getLocation().getStartLine()
  )
}