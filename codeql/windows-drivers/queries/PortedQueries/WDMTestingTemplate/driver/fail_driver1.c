/*++

Copyright (c) Microsoft Corporation.  All rights reserved.

Module Name:

    fail_driver1.c

Abstract:

    This is a sample driver that contains intentionally placed
    code defects in order to illustrate how Static Driver Verifier
    works. This driver is not functional and not intended as a 
    sample for real driver development projects.

Environment:

    Kernel mode

--*/

#include "fail_driver1.h"

#include "driver_snippet.c"

#define _DRIVER_NAME_ "fail_driver1"

#define PAGED_CODE_SEG __declspec(code_seg("PAGE"))


#ifndef __cplusplus
#pragma alloc_text (INIT, DriverEntry)
#pragma alloc_text (PAGE, DriverAddDevice)
#pragma alloc_text (PAGE, DispatchCreate)
#pragma alloc_text (PAGE, DispatchRead)
#pragma alloc_text (PAGE, DispatchPnp)
#endif

NTSTATUS
DriverEntry(
    _In_ PDRIVER_OBJECT  DriverObject,
    _In_ PUNICODE_STRING RegistryPath
    )
{

    UNREFERENCED_PARAMETER(RegistryPath);
    DriverObject->MajorFunction[IRP_MJ_CREATE]         = DispatchCreate;
    DriverObject->MajorFunction[IRP_MJ_READ]           = DispatchRead;
    DriverObject->MajorFunction[IRP_MJ_POWER]          = DispatchPower;
    DriverObject->MajorFunction[IRP_MJ_SYSTEM_CONTROL] = DispatchSystemControl;
    DriverObject->MajorFunction[IRP_MJ_PNP]            = DispatchPnp;
    DriverObject->DriverExtension->AddDevice           = DriverAddDevice;
    DriverObject->DriverUnload                         = DriverUnload;

    return STATUS_SUCCESS;
}

//This routine represents a failing case for NoPagedCode
NTSTATUS
DriverAddDevice(
    _In_ PDRIVER_OBJECT DriverObject,
    _In_ PDEVICE_OBJECT PhysicalDeviceObject
    )
{
    PDEVICE_OBJECT device;
	PDEVICE_OBJECT TopOfStack;
    PDRIVER_DEVICE_EXTENSION extension ;
    NTSTATUS status;
    
    UNREFERENCED_PARAMETER(DriverObject);
    UNREFERENCED_PARAMETER(PhysicalDeviceObject);
    
    PAGED_CODE();

    status = IoCreateDevice(DriverObject,                 
                            sizeof(DRIVER_DEVICE_EXTENSION), 
                            NULL,                   
                            FILE_DEVICE_DISK,  
                            0,                     
                            FALSE,                 
                            &device                
                            );
    if(status==STATUS_SUCCESS)
    {
  
       extension = (PDRIVER_DEVICE_EXTENSION)(device->DeviceExtension);

       TopOfStack = IoAttachDeviceToDeviceStack (
                                       device,
                                       PhysicalDeviceObject);
       if (NULL == TopOfStack) 
	   {
           IoDeleteDevice(device);
           return STATUS_DEVICE_REMOVED;
       }


       IoInitializeDpcRequest(device,DpcForIsrRoutine);

       device->Flags &= ~DO_DEVICE_INITIALIZING;


    }

   return status;
}

//This Routine represents a failing case for PendingStatusError as no path returns STATUS_PENDING
NTSTATUS
DispatchCreate (
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    )
{   
    KAFFINITY ProcessorMask;
    PDRIVER_DEVICE_EXTENSION extension ;
    IoMarkIrpPending(Irp);
    

    PVOID *badPointer = NULL;

    UNREFERENCED_PARAMETER(DeviceObject);
    UNREFERENCED_PARAMETER(Irp);

    PAGED_CODE();
    //The check will mark the second occurance of PAGE_CODE as an error.
    PAGED_CODE();

    ExFreePool(badPointer);


    extension = (PDRIVER_DEVICE_EXTENSION)DeviceObject -> DeviceExtension;

    ProcessorMask   =  (KAFFINITY)1;
    
    IoConnectInterrupt( &extension->InterruptObject,
                         InterruptServiceRoutine,
                         extension,
                         NULL,
                         extension->ControllerVector,
                         PASSIVE_LEVEL,
                         PASSIVE_LEVEL,
                         LevelSensitive,
                         TRUE,
                         ProcessorMask,
                         TRUE );
	
    return STATUS_SUCCESS;
}

//This routine represents a failing case for NoPagedCode
NTSTATUS
DispatchRead (
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    )
{  

    KSPIN_LOCK  queueLock;
    KIRQL oldIrql;
    IoMarkIrpPending(Irp);


    UNREFERENCED_PARAMETER(DeviceObject);
    UNREFERENCED_PARAMETER(Irp);

    KeInitializeSpinLock(&queueLock);
     

    KeAcquireSpinLock(&queueLock, &oldIrql);
	
    return STATUS_PENDING;
}

//This routine represents a failing case for NoPagingSegment.
NTSTATUS
DispatchPower (
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    )
{
    NTSTATUS status;
    PDRIVER_DEVICE_EXTENSION extension = (PDRIVER_DEVICE_EXTENSION)(DeviceObject->DeviceExtension); 
    PAGED_CODE();
    
    
    IoSetCompletionRoutine(Irp, CompletionRoutine, extension, TRUE, TRUE, TRUE);
    
    status = IoCallDriver(DeviceObject,Irp);
    return status;
}

PAGED_CODE_SEG
NTSTATUS
DispatchSystemControl (
    _In_  PDEVICE_OBJECT  DeviceObject,
    _Inout_  PIRP            Irp
    )
{   

    KIRQL oldIrql;
    // PFCB Fcb;

    UNREFERENCED_PARAMETER(DeviceObject);
    UNREFERENCED_PARAMETER(Irp);
    PAGED_CODE();

    // FsRtlCheckOplockEx( FatGetFcbOplock(Fcb),
    //                             Irp,
    //                             0,
    //                             NULL,
    //                             NULL,
    //                             NULL );
   
    IoAcquireCancelSpinLock(&oldIrql);
    return STATUS_SUCCESS;
}

#pragma code_seg("PAGE")
VOID
DriverUnload(
    _In_ PDRIVER_OBJECT DriverObject
    )
{
    UNREFERENCED_PARAMETER(DriverObject);
    PAGED_CODE();
     
    
    return;
}

_IRQL_requires_(APC_LEVEL) 
NTSTATUS TestInner3(){
    return STATUS_SUCCESS;
}


NTSTATUS someFunc(){
    // CHAR *tempStr = NULL;
    // tempStr = new (std::nothrow) CHAR[256];
    return TestInner3();
}

_IRQL_requires_(PASSIVE_LEVEL) 
NTSTATUS TestInner2(){
    NTSTATUS notUsed;

    /*
    The call below, someFunc() represents a failing case for IrqlTooLow function as it is in a call is made in a PASSIVE_LEVEL to a function that requres APC_LEVEL, aka TestInner3()
    */
    notUsed = someFunc();
    return STATUS_SUCCESS;
}

_Check_return_
NTSTATUS TestInner1(){
    return TestInner2();
}


NTSTATUS
IrqlLowTestFunction(){
    /*
    The call below represents a failing case for ExaminedValue check as the return value of the call is not checke.
    */
    return TestInner1();
}

_Must_inspect_result_
_IRQL_requires_(DISPATCH_LEVEL) 
NTSTATUS
IrqlHighTestFunction(){
    return STATUS_SUCCESS;
}


NTSTATUS
DispatchPnp (
    _In_ PDEVICE_OBJECT DeviceObject,
    _Inout_ PIRP Irp
    )
{   
	KIRQL oldIrql;
    KeRaiseIrql(DISPATCH_LEVEL, &oldIrql);

    NTSTATUS status = IoCallDriver(DeviceObject,Irp);
    PAGED_CODE();

    status = STATUS_SUCCESS;
    return status;
}



NTSTATUS
CompletionRoutine(
    _In_ PDEVICE_OBJECT DeviceObject,
    _In_ PIRP Irp,
    _In_reads_opt_(_Inexpressible_("varies")) PVOID EventIn
    )
{
    
    PKEVENT Event = (PKEVENT)EventIn;
    KIRQL oldIrql;
    PDRIVER_DEVICE_EXTENSION extension = (PDRIVER_DEVICE_EXTENSION)(DeviceObject->DeviceExtension); 
    UNREFERENCED_PARAMETER(Irp);
    _Analysis_assume_(EventIn != NULL);
    KeRaiseIrql(DISPATCH_LEVEL, &oldIrql);

    /*
    The call below, IrqlLowTestFunction() represents a failing case for IrqlTooHigh function as it is in a call is made in a DISPATCH_LEVEL to a call that contains two subsequent child calls in it with lower IRQL level. 
    */
    IrqlLowTestFunction();
    KeLowerIrql(oldIrql);

    KeSetEvent(Event, extension->Increment, TRUE);
    return STATUS_SUCCESS;
}

#pragma code_seg()
BOOLEAN
InterruptServiceRoutine (
    _In_      PKINTERRUPT Interrupt,
    _In_opt_  PVOID DeviceExtensionIn
    )
{     
    PDRIVER_DEVICE_EXTENSION DeviceExtension = (PDRIVER_DEVICE_EXTENSION)DeviceExtensionIn;
    PVOID Context = NULL;        
    _Analysis_assume_(DeviceExtension != NULL);
    UNREFERENCED_PARAMETER(Interrupt); 

    IoRequestDpc(DeviceExtension->DeviceObject, DeviceExtension->Irp, Context);
    return TRUE;
}

VOID
DpcForIsrRoutine(    
    _In_ PKDPC  Dpc,    
    _In_ struct _DEVICE_OBJECT  *DeviceObject,    
    _Inout_ struct _IRP  *Irp,    
    _In_opt_ PVOID  Context)
{
    UNREFERENCED_PARAMETER(DeviceObject);
    UNREFERENCED_PARAMETER(Irp);
    UNREFERENCED_PARAMETER(Context);
    UNREFERENCED_PARAMETER(Dpc);
    NTSTATUS status;
    KIRQL oldIrql;
    /*
    The call below, IrqlHighTestFunction() represents a passing case for both IrqlTooLow and IrqlTooHigh checks as the functio is called at the right IRQL level.
    */
    KeRaiseIrql(DISPATCH_LEVEL, &oldIrql);
    status = IrqlHighTestFunction();
    KeLowerIrql(oldIrql);

    /*
    The check below represents a passing test for ExaminedValue check as the result of IrqlHighTestFunction(), which was annotated with _Must_inspect_result_ is checked
    */
    if(status != 0){
        //do something.
    }

    top_level_call();

    IoGetInitialStack();
}

