#include <stdio.h>

unsigned long long part_one(int storage[], int length) {
    int clone[length];
    for (int i = 0; i < length; i++) {
        clone[i] = storage[i];
    }
    int bt_cursor = length - 1;
    int free_cursor = 0;
    while (bt_cursor > free_cursor) {
        while (clone[free_cursor] != -1) {free_cursor++;}
        while (clone[bt_cursor] == -1) {bt_cursor--;}

        if (bt_cursor > free_cursor) {
            clone[free_cursor] = clone[bt_cursor];
            clone[bt_cursor] = -1;
        }
    }
    unsigned long long result = 0;

    for (int i = 0; i < length; i++) {
        if (clone[i] == -1) {break;}
        result += clone[i] * i;
    }

    return result;
}

unsigned long long part_two(int storage[], int length) {
    int clone[length];
    for (int i = 0; i < length; i++) {
        clone[i] = storage[i];
    }
    int free_cursor = 0;
    int bt_cursor = length - 1;
    int free_contiguous = 0;
    int bt_contiguous = 0;
    int try_move = clone[length-1];

    while (try_move >= 0) {
        bt_cursor = length - 1;
        free_cursor = 0;
        free_contiguous = 0;
        bt_contiguous = 0;

        while (clone[free_cursor] != -1) {free_cursor++;}
        while (clone[bt_cursor] != try_move) { bt_cursor--; }
        if (bt_cursor < free_cursor) {break;} // Kill this outer loop

        while (clone[bt_cursor - bt_contiguous] == clone[bt_cursor]) {bt_contiguous++;}
        while (free_contiguous < bt_contiguous) {
            free_cursor += free_contiguous;
            while (clone[free_cursor] != -1) {free_cursor++;}
            free_contiguous = 0;
            if (free_cursor >= bt_cursor) {break;}
            while (clone[free_cursor + free_contiguous] == -1) {free_contiguous++;}
        }

        if (free_contiguous >= bt_contiguous) {
            for (int i = 0; i < bt_contiguous; i++) {
                clone[free_cursor + i] = try_move;
                clone[bt_cursor - i] = -1;
            }
        }

        try_move--;
    }
    unsigned long long result = 0;

    for (int i = 0; i < length; i++) {
        if (clone[i] == -1) {continue;}
        result += clone[i] * i;
    }

    return result;
}

int main() {
    FILE* f = fopen("input", "r");
    char a = 0;
    unsigned long cap = 0;

    while (a != EOF) {
        a = getc(f);
        if (a >= '0' && a <= '9') {
            cap += a - '0';
        }
    }

    int storage[cap];
    int cursor = 0;
    int current_file = 0;

    rewind(f);

    for (int i = 0; i < cap; i++) {
        storage[i] = -1;
    }

    a = 0;
    while (a != EOF) {
        a = getc(f);
        int used_space;
        if (a >= '0' && a <= '9') { used_space = a - '0'; }
        else { break; }

        for (int i = 0; i < used_space; i++) {
            storage[cursor++] = current_file;
        }
        current_file++;

        a = getc(f);
        int free_space;
        if (a >= '0' && a <= '9') { free_space = a - '0'; }
        else { break; }
        for (int i = 0; i < free_space; i++) {
            storage[cursor++] = -1;
        }
    }

    unsigned long long result = part_one(storage, cap);
    printf("%llu\n", result);

    result = part_two(storage, cap);
    printf("%llu\n", result);

    fclose(f);
}
