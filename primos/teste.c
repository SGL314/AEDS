#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>

#define MAX_PRIMES 10000000

double *primes;
int prime_count = 0;

void engine_previous_primes(double max);
void show();
void sleep_seconds(double tempo);

int main() {
    double max = pow(10, 7);
    primes = (double*) malloc(MAX_PRIMES * sizeof(double));
    if (primes == NULL) {
        printf("Erro ao alocar memória.\n");
        return 1;
    }
    primes[prime_count++] = 2.0;
    engine_previous_primes(max);
    free(primes);
    return 0;
}

void engine_previous_primes(double max) {
    printf("Max: %.0f\n", max);
    double raiz, n = 3;
    bool is_prime;
    clock_t init = clock(); // Início do contador de tempo

    while (n <= max) {
        is_prime = true;
        raiz = pow(n,0.5f) + 1;
        for (int i = 0; i < prime_count; i++) {
            double k = primes[i];
            if (n / k == (int)(n / k)) { // Verifica se `n` é divisível por `k`
                is_prime = false;
                break;
            }
            if (k > raiz) break;
        }
        if (is_prime) {
            primes[prime_count++] = n;
            if (prime_count >= MAX_PRIMES) break;
        }
        n += 2.0;
    }

    show();
    printf("Last : %.0f\n", n);
    printf("Tempo (s): %.9f\n", (double)(clock() - init) / CLOCKS_PER_SEC);
}

void sleep_seconds(double tempo) {
    struct timespec req = { (int)tempo, (tempo - (int)tempo) * 1e9 };
    nanosleep(&req, NULL);
}

void show() {
    int qt = 0;
    for (int i = 0; i < prime_count; i++) {
        printf("%.0f\n", primes[i]);
        qt++;
    }
    printf("Quantidade : %d\n", qt);
}
