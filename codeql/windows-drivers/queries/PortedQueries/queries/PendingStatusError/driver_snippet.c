//
// driver_snippet.c
//

//Avoids Warning
NTSTATUS func1(PIRP Irp){
    IoMarkIrpPending(Irp);
    return STATUS_PENDING;

}

//Raises warning
NTSTATUS func2(PIRP Irp){
    IoMarkIrpPending(Irp);
    return STATUS_SUCCESS;

}

void top_level_call() {
    PIRP Irp = NULL;
    func1(Irp);
    func2(Irp);
}

