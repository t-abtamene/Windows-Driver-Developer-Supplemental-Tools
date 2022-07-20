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

//Represents code_seg pragma
class CodeSegPragma extends PreprocessorPragma {
  CodeSegPragma() { this.getHead().matches("code\\_seg(\"PAGE\")") }
}

class DefaultCodeSegPragma extends PreprocessorPragma {
  DefaultCodeSegPragma() { this.getHead().matches("code\\_seg()") }
}

//Represents alloc_text pragma
class AllocSegPragma extends PreprocessorPragma {
  AllocSegPragma() { this.getHead().matches("alloc\\_text%(PAGE,%") }
}

//Evaluates to true if a PagedFunc was placed in a PAGE section using alloc_text pragma
predicate isAllocUsedToLocatePagedFunc(Function pf) {
  exists(AllocSegPragma ca | ca.getHead().matches("%" + pf.getName() + "%"))
}

//Evaluates to true if there is a code_seg("PAGE") pragma above the given PagedFunc
predicate isPageCodeSectionSetAbove(Function pf) {
  exists(CodeSegPragma csp | csp.getLocation().getStartLine() < pf.getLocation().getStartLine())
}

//Evaluates to true if there is Macro Invocation above PagedFunc which expands to code_seg("PAGE")
predicate isPagedSegSetWithMacroAbove(Function pf) {
  exists(MacroInvocation ma |
    ma.getMacro().getBody().matches("%code\\_seg(\"PAGE\")%") and
    ma.getLocation().getStartLine() <= pf.getLocation().getStartLine()
  )
}

//Filters out empty code_seg() as they default to .text section. So functions with code_seg() pragma above them won't raise NoPagedCode, aka C28170, warning.
predicate isPragmaTheDefault(Function f) {
  exists(CodeSegPragma csp, DefaultCodeSegPragma dcsp |
    csp.getLocation().getStartLine() < f.getLocation().getStartLine() and
    dcsp.getLocation().getStartLine() > csp.getLocation().getStartLine()
  )
}

//Represents a paged section
class FunctionDeclaredInPageSection extends Function {
  FunctionDeclaredInPageSection() {
    isPagedSegSetWithMacroAbove(this) or
    isPageCodeSectionSetAbove(this) or
    isAllocUsedToLocatePagedFunc(this)
  }
}
