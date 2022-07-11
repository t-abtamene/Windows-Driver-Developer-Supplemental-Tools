//Bad use 1
DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;

//Good use 1
_Dispatch_type_(IRP_MJ_CREATE) DRIVER_DISPATCH SampleCreate;
pDo->MajorFunction[IRP_MJ_CREATE] = SampleCreate;



//Bad use 2: due to annotation mismatch and missing dispatch annotation. 

_Dispatch_type_(IRP_MJ_READ)
DRIVER_DISPATCH DispatchCreate;
DRIVER_DISPATCH DispatchPnp;

NTSTATUS
DriverEntry(
    _In_ PDRIVER_OBJECT  DriverObject,
    _In_ PUNICODE_STRING RegistryPath
    )
{
    UNREFERENCED_PARAMETER(RegistryPath);
    DriverObject->MajorFunction[IRP_MJ_CREATE] = DispatchCreate;
    DriverObject->MajorFunction[IRP_MJ_PNP] = DispatchPnp;

    //
    //
    
    return STATUS_SUCCESS;
}
