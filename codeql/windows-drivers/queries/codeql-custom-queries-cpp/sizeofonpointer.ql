/**
 * @name sizeof call on a pointer
 * @kind problem
 * @description This will yield the size of a pointer (4 or 8), 
 * not the size of the object pointed to. Dereference
 *  the pointer, or if the size of a pointer was intended, 
 * use the pointer type or (void *) instead.
 * @problem.severity warning
 * @id cpp/example/sizeof-on-pointer
 */

import cpp


from SizeofExprOperator expr, VariableAccess va where
expr.getExprOperand() = va and 
(va.getTarget().getUnspecifiedType() instanceof PointerType or 
va.getTarget().getUnspecifiedType() instanceof ArrayType
 )

select expr,  "This gives a pointer size, not the object being pointed to."
