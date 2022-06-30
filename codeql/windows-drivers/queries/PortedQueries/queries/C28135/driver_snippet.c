//Given a local first argument

KEVENT kevent1;

void top_level_call() {
    KEVENT kevent2;
    //Raises Warning
    KeWaitForSingleObject(&kevent1, UserRequest, UserMode, FALSE, NULL);
    //Avoids warning
    KeWaitForSingleObject(&kevent2, UserRequest, UserMode, FALSE, NULL);

}