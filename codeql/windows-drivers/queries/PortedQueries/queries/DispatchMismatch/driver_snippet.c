/*
//Bad use example
DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;

//Good use example 
_Dispatch_type_(IRP_MJ_CREATE) DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;

*/

#ifdef __cplusplus
extern "C" {
#endif
#include <wdm.h>
#ifdef __cplusplus
}
#endif

//passes
_Dispatch_type_(IRP_MJ_PNP)
DRIVER_DISPATCH DispatchPnp; 
//raises warning: the SAL annotation in the declaration doesn't match the expected type in MajorFunction table. 
_Dispatch_type_(IRP_MJ_CLOSE) 
DRIVER_DISPATCH DispatchCreate;
