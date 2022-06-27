int baduse() {
    int arr[5];
    return sizeof(arr);
}

int baduse2(int* ptr) {
    return sizeof(ptr);
}

int baduse3(char s[]) {
    int size = sizeof(s); 
    return size + 1;
}

int gooduse(char* ptr) {
    return sizeof(*ptr);
}
