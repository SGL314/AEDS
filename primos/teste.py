import time
import math

# Lista para armazenar os números primos
primes = [2.0]

def main():
    max_val = 10**7
    engine_previous_primes(max_val)

def engine_previous_primes(max_val):
    print(max_val)
    raiz = 1
    n = 3
    init = time.time()  # Início do contador de tempo

    while n <= max_val:
        p = True
        raiz = math.sqrt(n) + 1
        for k in primes:
            if n % k == 0:
                p = False
                break
            if k > raiz:
                break
        if p:
            primes.append(n)
        n += 2.0

    show()
    print(f"Last : {n}")
    print(f"Tempo (s): {time.time() - init:.9f}")

def sleep(tempo):
    try:
        time.sleep(tempo)
    except Exception as e:
        pass

def show():
    qt = 0
    for n in primes:
        print(n)
        qt += 1
    print(f"Quantidade : {qt}")

# Executa o programa principal
if __name__ == "__main__":
    main()
