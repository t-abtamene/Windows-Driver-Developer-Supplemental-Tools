
/*
//Bad use
DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;

//Good use
_Dispatch_type_(IRP_MJ_CREATE) DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;

*/
DRIVER_DISPATCH DispatchPnp; 
DRIVER_DISPATCH DispatchCreate;
