import cpp
import Windows.wdk.wdm.SAL

class IrqlTypeDefinition extends SALAnnotation {
  string irqlType;
  string irqlMacroName;

  //Types
  IrqlTypeDefinition() {
    //Needs to include other Irql annotations too.
    this.getMacroName().matches(["_IRQL_requires_max_", "_IRQL_requires_min_", "_IRQL_requires_"]) and
    irqlMacroName = this.getMacroName() and
    exists(MacroInvocation mi |
      mi.getParentInvocation() = this and
      irqlType = mi.getMacro().getHead()
    )
  }

  string getIrqlLevelFull() { result = irqlType }

  string getIrqlMacroName() { result = irqlMacroName }
}

//Represents Irql annotationed functions. 
class IrqlAnnotatedFunction extends Function {
  string funcIrql;
  string funcIrqlName;

  IrqlAnnotatedFunction() {
    exists(IrqlTypeDefinition itd, FunctionDeclarationEntry fde |
      fde = this.getADeclarationEntry() and
      itd.getDeclarationEntry() = fde and
      funcIrql = itd.getIrqlLevelFull() and 
      funcIrqlName = itd.getIrqlMacroName()
    )
  }

  string getLevel() { result = funcIrql }
  string getFuncIrqlName() { result = funcIrqlName }


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
predicate containsIrqlCall(FunctionCall fc) {
  exists(Function fc2 |
    fc.getTarget().calls*(fc2) and
    fc2 instanceof IrqlAnnotatedFunction
  )
}

//Returns functions in the ControlFlow path that are instance of IrqlAnnotatedFunction
Function getActualIrqlFunc(FunctionCall fc) {
  exists(Function fc2 |
    fc.getTarget().calls*(fc2) and
    fc2 instanceof IrqlAnnotatedFunction and
    result = fc2
  )
}

class CallsToIrqlAnnotatedFunction extends FunctionCall {
  CallsToIrqlAnnotatedFunction() { containsIrqlCall(this) }
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
