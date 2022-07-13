/*
//Bad use
DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;

//Good use
_Dispatch_type_(IRP_MJ_CREATE) DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;

*/
_Dispatch_type_(IRP_MJ_PNP)
DRIVER_DISPATCH DispatchPnp; 

_Dispatch_type_(IRP_MJ_READ) 
DRIVER_DISPATCH DispatchCreate;
