import cpp

//Represents functions where a function has either PAGED_CODE or PAGED_CODE_LOCKED macro invocations
cached
class PagedFunc extends Function {
  cached
  PagedFunc() {
    exists(MacroInvocation mi |
      mi.getEnclosingFunction() = this and
      mi.getMacroName() = ["PAGED_CODE", "PAGED_CODE_LOCKED"]
    )
  }
}

//Represents code_seg("PAGE") pragma
class CodeSegPragma extends PreprocessorPragma {
  CodeSegPragma() { this.getHead().matches("code\\_seg(\"PAGE\")") }
}

//Represents a code_seg() pragma
class DefaultCodeSegPragma extends PreprocessorPragma {
  DefaultCodeSegPragma() { this.getHead().matches("code\\_seg()") }
}

//Represents alloc_text pragma
class AllocSegPragma extends PreprocessorPragma {
  AllocSegPragma() { this.getHead().matches("alloc\\_text%(PAGE,%") }
}

//Evaluates to true if a PagedFunc was placed in a PAGE section using alloc_text pragma
predicate isAllocUsedToLocatePagedFunc(Function pf) {
  exists(AllocSegPragma asp |
    asp.getHead().matches("%" + pf.getName() + "%") and
    asp.getFile().getBaseName() = pf.getFile().getBaseName()
  )
}

//Evaluates to true if there is Macro Invocation above PagedFunc which expands to code_seg("PAGE")
predicate isPagedSegSetWithMacroAbove(Function pf) {
  exists(MacroInvocation ma |
    ma.getMacro().getBody().matches("%code\\_seg(\"PAGE\")%") and
    ma.getLocation().getStartLine() <= pf.getLocation().getStartLine() and
    pf.getAnAttribute().getName() = "code_seg"
  )
}

//A way to filter out page resets. There isn't a simple way to figure out
//whether it's code_seg("PAGE%" OR code_seg() pragma is closer to the definition of the function.
predicate isThereAPageReset(Function f) {
  exists(DefaultCodeSegPragma dcsp |
    dcsp.getFile().getBaseName() = f.getFile().getBaseName() and
    (
      dcsp.getLocation().getStartLine() + 1 = f.getLocation().getStartLine()
      or
      dcsp.getLocation().getStartLine() + 2 = f.getLocation().getStartLine()
      or
      dcsp.getLocation().getStartLine() + 3 = f.getLocation().getStartLine()
    )
  )
}

//Evaluates to true if there is a code_seg("PAGE") pragma above the given PagedFunc
predicate isPageCodeSectionSetAbove(Function f) {
  exists(CodeSegPragma csp |
    csp.getLocation().getStartLine() < f.getLocation().getStartLine() and
    csp.getFile().getBaseName() = f.getFile().getBaseName()
  ) and
  not isThereAPageReset(f)
}

//Represents a paged section
cached
class PagedFunctionDeclaration extends Function {
  cached
  PagedFunctionDeclaration() {
    isPagedSegSetWithMacroAbove(this)
    or
    isPageCodeSectionSetAbove(this)
    or
    isAllocUsedToLocatePagedFunc(this)
  }
}
