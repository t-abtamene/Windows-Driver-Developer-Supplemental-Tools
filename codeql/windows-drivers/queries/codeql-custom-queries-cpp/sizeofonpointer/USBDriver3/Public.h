/*++

Module Name:

    public.h

Abstract:

    This module contains the common declarations shared by driver
    and user applications.

Environment:

    user and kernel

--*/

//
// Define an Interface Guid so that app can find the device and talk to it.
//

DEFINE_GUID (GUID_DEVINTERFACE_USBDriver3,
    0x339cfa84,0x0ca6,0x4f81,0xac,0x4a,0xef,0x2a,0xda,0xc8,0x33,0xa9);
// {339cfa84-0ca6-4f81-ac4a-ef2adac833a9}
