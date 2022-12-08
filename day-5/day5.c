#include <stdio.h>
#include <stdbool.h>
#include <string.h>

const bool TEST_MODE = false;
const int PART = 2;

const int MAX_STACK_SIZE = 255;
const int MAX_STACKS = 9;
int stack_sizes[] = {0,0,0,0,0,0,0,0,0};

void push_crate(int stack_number, char* stacks, char crate)
{
    stacks[stack_number * MAX_STACK_SIZE + stack_sizes[stack_number]] = crate;
    stack_sizes[stack_number]++;
}

char pop_crate(int stack_number, char* stacks)
{
    stack_sizes[stack_number]--;
    return *(stacks + (stack_number * MAX_STACK_SIZE) + stack_sizes[stack_number]);
}

char* pop_crates(int number, int stack_number, char* stacks)
{
    char * crates = (char*)malloc(number);
    for (int i = 0; i < number; i++)
    {
        crates[i] = pop_crate(stack_number, stacks);
    }
    return crates;
}

void push_crates(int stack_number, char* stacks, char* crates, int number)
{
    for (int i = 0; i < number; i++)
    {
        push_crate(stack_number, stacks, *(crates + i));
    }
}


void push_crates_reverse(int stack_number, char* stacks, char* crates, int number)
{
    for (int i = number - 1; i >= 0; i--)
    {
        push_crate(stack_number, stacks, *(crates + i));
    }
}

void initialize_stacks(char* stacks)
{
    if (TEST_MODE)
    {
        push_crates(0, stacks, "ZN", 2);
        push_crates(1, stacks, "MCD", 3);
        push_crates(2, stacks, "P", 1);
    }
    else 
    {
        push_crates(0, stacks, "BSVZGPW", 7);
        push_crates(1, stacks, "JVBCZF", 6);
        push_crates(2, stacks, "VLMHNZDC", 8);
        push_crates(3, stacks, "LDMZPFJB", 8);
        push_crates(4, stacks, "VFCGJBQH", 8);
        push_crates(5, stacks, "GFQTSLB", 7);
        push_crates(6, stacks, "LGCZV", 5);
        push_crates(7, stacks, "NLG", 3);
        push_crates(8, stacks, "JFHC", 4);
    }
}

void dump_stacks(char* stacks)
{
    for (int n = 0; n < MAX_STACKS; n++)
    {
        printf("Stack %d contains: ", n);
        for (int i = 0; i < stack_sizes[n]; i++)
        {
            printf("%c", *(stacks + (n * MAX_STACK_SIZE) + i));
        }
        printf("(%d)\n", stack_sizes[n]);
    }
}

void move_crates_one_at_a_time(int number, int source, int target, char* stacks)
{
    for (int i = 0; i < number; i++) 
    {
        char crate = pop_crate(source, stacks);
        push_crate(target, stacks, crate);
    }
}

void move_multiple_crates(int number, int source, int target, char* stacks)
{
    char* crates = pop_crates(number, source, stacks);
    push_crates_reverse(target, stacks, crates, number);
}

int move_crates(int number, int source, int target, char* stacks)
{
    dump_stacks(stacks);
    printf("n: %d, src: %d, trgt: %d", number, source, target);
    printf("\n");

    if (PART == 1)
    {
        move_crates_one_at_a_time(number, source, target, stacks);
    }
    else 
    {
        move_multiple_crates(number, source, target, stacks);
    }

    if (stack_sizes[source] < 0)
    {
        return 1;
    }
    return 0;
}

void print_top_crates(char* stacks)
{
    printf("Result:\n");
    for (int i = 0; i < MAX_STACKS; i++)
    {
        if (stack_sizes[i] > 0)
        {
            printf("%c", pop_crate(i, stacks));
        }
    }
    printf("\n");
}

int main()
{
    int return_code = 0;

    FILE* in_file;
    if (TEST_MODE)
    {
        in_file = fopen("test_input.txt", "r");
    }
    else 
    {
        in_file = fopen("input.txt", "r");
    }

    
    char* stacks = (char*) malloc(MAX_STACK_SIZE * MAX_STACKS);

    initialize_stacks(stacks);
    
    int* n = (int *) malloc(sizeof(int));
    int* source_stack = (int *) malloc(sizeof(int));
    int* target_stack = (int *) malloc(sizeof(int));
    while (fscanf(in_file, "move %d from %d to %d\n", n, source_stack, target_stack) != EOF && return_code != 1)
    {
        return_code = move_crates(*n, *source_stack - 1, *target_stack - 1, stacks);
    }

    dump_stacks(stacks);

    print_top_crates(stacks);

    fclose(in_file);

    return return_code;
}