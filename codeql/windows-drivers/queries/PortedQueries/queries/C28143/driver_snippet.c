//
// driver_snippet.c
//

//Raises Warning
NTSTATUS func1(PIRP Irp){
    IoMarkIrpPending(Irp);
    return STATUS_PENDING;

}

//Avoids warning
NTSTATUS func2(PIRP Irp){
    IoMarkIrpPending(Irp);
    return STATUS_SUCCESS;

}

void top_level_call() {
    PIRP Irp = NULL;
    func1(Irp);
    func2(Irp);
}

