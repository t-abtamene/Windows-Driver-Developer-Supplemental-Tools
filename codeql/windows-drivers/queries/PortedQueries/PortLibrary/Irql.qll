import cpp
import Windows.wdk.wdm.SAL

class IrqlTypeDefinition extends SALAnnotation {
  string irqlType;

  IrqlTypeDefinition() {
    //Needs to include other Irql annotations too.
    this.getMacroName().matches(["_IRQL_requires_max_", "_IRQL_requires_min_", "_IRQL_requires_"]) and
    exists(MacroInvocation mi |
      mi.getParentInvocation() = this and
      irqlType = mi.getMacro().getHead()
    )
  }

  string getIrqlType() { result = irqlType }
}

class IrqlAnnotatedFunction extends Function {
  string funcLevel;

  IrqlAnnotatedFunction() {
    exists(IrqlTypeDefinition itd, FunctionDeclarationEntry fde |
      fde = this.getADeclarationEntry() and
      itd.getDeclarationEntry() = fde and
      funcLevel = itd.getIrqlType()
    )
  }

  private string getLevel() { result = funcLevel }

  int getIrqlLevel() {
    if getLevel().matches("%PASSIVE_LEVEL%")
    then result = 0
    else
      if getLevel().matches("%APC_LEVEL%")
      then result = 1
      else result = 2
    //Needs to include other levels too
  }
}

//Evaluates to true if a FunctionCall at some points calls Irql annotated Function.
predicate isIrqlCall(FunctionCall fc) {
  exists(Function fc2 |
    fc.getTarget().calls*(fc2) and
    fc2 instanceof IrqlAnnotatedFunction
  )
}

Function getActualIrqlFunc(FunctionCall fc) {
  exists(Function fc2 |
    fc.getTarget().calls*(fc2) and
    fc2 instanceof IrqlAnnotatedFunction and
    result = fc2
  )
}

class CallsToIrqlAnnotatedFunction extends FunctionCall {
  CallsToIrqlAnnotatedFunction() { isIrqlCall(this) }
}

class PassiveLevelFunction extends IrqlAnnotatedFunction {
  PassiveLevelFunction() { this.getIrqlLevel() = 0 }
}

class APCLevelFunction extends IrqlAnnotatedFunction {
  APCLevelFunction() { this.getIrqlLevel() = 1 }
}

class DispatchLevelFunction extends IrqlAnnotatedFunction {
  DispatchLevelFunction() { this.getIrqlLevel() = 2 }
}
