#include <stdio.h>

extern void stats (int [], int, int*, int*);

int main()  {
    int lst[] = {1, -2, 3, -4, 5, 7, 9, 11};
    int len = 8;
    int sum, ave;

    stats(lst, len, &sum, &ave);
    printf("Stats:\n");
    printf("  Sum = %d \n", sum);
    printf("  Ave = %d \n", ave);

    return 0;
}