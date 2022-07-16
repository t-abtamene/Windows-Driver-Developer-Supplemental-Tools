//Both failing and passing tests added to the WDMTestingTemplate


/** Failing cases:
 * DispatchCreate and DispatchRead rouines will raise warning as they were put in a PAGED section but 
 * they don't have PAGED_CODE or PAGED_CODE_LOCKED macros. Read C28170 on MSDN for details. 
 * 
 */


/** Passing cases:
 * All other Dispatch routines should pass  
 * 
 * 
 */




/**
The two function declarations below are unrelated to this test. The reason they are here is because including them in the WDMTestingTemplate will interfer with DispatchAnnotationMissing and DispatchMismatch tests.
 */

_Dispatch_type_(IRP_MJ_PNP)
DRIVER_DISPATCH DispatchPnp; 

_Dispatch_type_(IRP_MJ_CREATE) 
DRIVER_DISPATCH DispatchCreate;
