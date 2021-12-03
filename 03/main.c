#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define BUFFER_SIZE 16

int part01(char**);
int part02(char**);

long bit_count_difference(const long *numbers, size_t numbers_size, long bit_mask);
size_t filter_numbers_by_frequency(const long *numbers, size_t numbers_size, long *dest_numbers, size_t bits, bool most);
long find_number_by_frequency(long *numbers, size_t numbers_size, size_t bits, bool most);

int main(int argc, char *argv[]) {
    if (argc < 3) {
        puts("not enough arguments");
        return 1;
    }
    if (strcmp(argv[1], "part01") == 0) {
        part01(argv);
    } else if (strcmp(argv[1], "part02") == 0) {
        part02(argv);
    }
    return 0;
}

int part01(char *argv[]) {
    char *file_path = argv[2];
    FILE *file = fopen(file_path, "r");
    if (!file) {
        puts("failed to open file!");
        return 1;
    }

    char buffer[BUFFER_SIZE];
    size_t i, bits;
    fgets(buffer, sizeof buffer, file);
    bits = strlen(buffer) - 1; // ignore new line character
    unsigned int *counts = calloc(sizeof (unsigned int), bits * 2);
    if (counts == NULL) {
        puts("failed to allocate memory");
        return 1;
    }
    do {
        if (strlen(buffer) - 1 != bits) {
            printf("invalid line length: %ld", strlen(buffer));
            continue;
        }
        for (i = 0; i < bits; i++) {
            char c = buffer[i];
            if (c == '0') {
                counts[i * 2]++;
            } else if (c == '1') {
                counts[i * 2 + 1]++;
            } else {
                printf("invalid character: %c", c);
            }
        }
    } while (fgets(buffer, sizeof buffer, file) > 0);
    unsigned long epsilon = 0, gamma = 0;
    for (i = 0; i < bits; i++) {
        if (counts[i * 2] > counts[i * 2 + 1]) {
            epsilon |= 1 << (bits - 1 - i);
        } else {
            gamma |= 1 << (bits - 1 - i);
        }
    }
    free(counts);
    printf("gamma: %ld\nepsilon: %ld\nproduct: %ld", gamma, epsilon, gamma * epsilon);
    return 0;
}

int part02(char *argv[]) {
    char *file_path = argv[2];
    FILE *file = fopen(file_path, "r");
    if (!file) {
        puts("failed to open file!");
        return 1;
    }

    long* numbers = malloc(64 * sizeof (long));
    size_t numbers_size = 0;
    size_t numbers_max_size = 64;
    size_t i;
    char buffer[BUFFER_SIZE];

    size_t bits = 0;
    int c;
    while ((c = fgetc(file)) > 0 && c != '\n') bits++;

    while (fgets(buffer, sizeof buffer, file) > 0) {
        if (numbers_size == numbers_max_size) {
            size_t new_max_size = numbers_max_size * 2;
            size_t numbers_max_size_bytes = numbers_max_size * sizeof(long);
            numbers = realloc(numbers, numbers_max_size_bytes * 2);
            if (numbers == NULL) {
                puts("failed to realloc memory");
                return 1;
            }
            numbers_max_size = new_max_size;
        }
        long value = 0;
        for (i = strlen(buffer) - 2; i != SIZE_MAX; i--) {
            if (buffer[i] == '1') {
                value |= 1 << (bits - 1 - i);
            }
        }
        numbers[numbers_size++] = value;
    }

    long oxygen_rating = find_number_by_frequency(numbers, numbers_size, bits, true);
    long co2_rating = find_number_by_frequency(numbers, numbers_size, bits, false);

    printf("oxygen rating: %ld\nco2 rating: %ld\nproduct: %ld", oxygen_rating, co2_rating, oxygen_rating * co2_rating);

    free(numbers);
    return 0;
}

long bit_count_difference(const long* numbers, size_t numbers_size, long bit_mask) {
    long hits = 0;
    for (unsigned long i = numbers_size - 1; i != ULONG_MAX; i--) {
        if (numbers[i] & bit_mask) {
            hits++;
        } else {
            hits--;
        }
    }
    return hits;
}

size_t filter_numbers_by_frequency(const long *numbers, size_t numbers_size, long *dest_numbers, size_t bits, bool most) {
    long bit_mask = 1 << bits;
    long count_diff = bit_count_difference(numbers, numbers_size, bit_mask);
    long filter;
    if (count_diff == 0) {
        filter = most;
    } else {
        filter = count_diff > 0 == most;
    }
    filter <<= bits;

    size_t dest_size = 0;
    for (size_t i = 0; i < numbers_size; i++) {
        if ((numbers[i] & bit_mask) == filter) {
            dest_numbers[dest_size++] = numbers[i];
        }
    }

    return dest_size;
}

long find_number_by_frequency(long *numbers, size_t numbers_size, size_t bits, bool most) {
    long *dest_numbers = malloc(numbers_size * sizeof (long));
    size_t dest_numbers_size;
    for (size_t i = bits - 1; i != SSIZE_MAX; i--) {
        dest_numbers_size = filter_numbers_by_frequency(numbers, numbers_size, dest_numbers, i, most);

        if (dest_numbers_size == 1) {
            long value = dest_numbers[0];
            free(dest_numbers);
            return value;
        }

        numbers = dest_numbers;
        numbers_size = dest_numbers_size;
    }
    long result;
    if (numbers_size > 1) {
        printf("found more matching numbers than expected: %zu", numbers_size);
        result = numbers[0];
    } else if (numbers_size <= 0) {
        puts("no matching number found");
        result = -1;
    } else {
        result = numbers[0];
    }
    free(dest_numbers);
    return result;
}
