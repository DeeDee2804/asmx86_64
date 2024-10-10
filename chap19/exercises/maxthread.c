#include<pthread.h>
#include<stdio.h>
// a simple pthread example 
// compile with -lpthreads

// create the function to be executed as a thread
void *thread(void)
{
    fprintf(stderr,"Thread \n");
}

int main() {
    printf("Size of pthread_mutex_t: %zu bytes\n", sizeof(pthread_t));
    return 0;
}