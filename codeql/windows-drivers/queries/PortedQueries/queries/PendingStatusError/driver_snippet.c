//
// driver_snippet.c
//

// Used the template for this as using a top level function didn't make sense. 

//Bad usage

/*

NTSTATUS
DispatchCreate (
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    )
{   
    PDRIVER_DEVICE_EXTENSION extension ;
    IoMarkIrpPending(Irp);
    
    //
	
    return STATUS_SUCCESS;
}

//Good usage

NTSTATUS
DispatchCreate (
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    )
{   
    PDRIVER_DEVICE_EXTENSION extension ;
    IoMarkIrpPending(Irp);
    
    //
	
    return STATUS_PENDING;
}

*/

//passes
_Dispatch_type_(IRP_MJ_PNP)
DRIVER_DISPATCH DispatchPnp; 
//raises warning
_Dispatch_type_(IRP_MJ_CREATE) 
DRIVER_DISPATCH DispatchCreate;
