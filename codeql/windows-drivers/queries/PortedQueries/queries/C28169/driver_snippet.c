_Dispatch_type_(IRP_MJ_SET_QUOTA)
_Dispatch_type_(IRP_MJ_PNP)
DRIVER_DISPATCH HidUmdfPassThrough;

//Passes
NTSTATUS
HidUmdfPassThrough(
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    ){
        //
        ...
        //
        return STATUS_SUCCESS
    }


//Fails as there as no _Dispatch_type_ annotations
NTSTATUS
DispatchCreate(
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    ){
        //
        ...
        //
        return STATUS_SUCCESS
    }


