using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;

class Program
{
    private static List<double> primes = new List<double>();

    static void Main(string[] args)
    {
        double max = Math.Pow(10, 6);
        EnginePreviousPrimes(max);
    }

    public static void EnginePreviousPrimes(double max)
    {
        Console.WriteLine("Max: " + max);
        primes.Add(2.0);
        
        double raiz;
        double n = 3;
        bool isPrime;
        Stopwatch stopwatch = Stopwatch.StartNew();  // Início do contador de tempo

        while (n <= max)
        {
            isPrime = true;
            raiz = Math.Sqrt(n) + 1;
            
            foreach (double k in primes)
            {
                if (n % k == 0)
                {
                    isPrime = false;
                    break;
                }
                if (k > raiz) break;
            }
            
            if (isPrime)
                primes.Add(n);
            
            n += 2.0;
        }

        Show();
        stopwatch.Stop();
        Console.WriteLine($"Last : {n}");
        Console.WriteLine($"Tempo (s): {stopwatch.Elapsed.TotalSeconds:F9}");
    }

    public static void Sleep(double seconds)
    {
        try
        {
            Thread.Sleep((int)(seconds * 1000));
        }
        catch (Exception e)
        {
            Console.WriteLine("Erro ao pausar o programa: " + e.Message);
        }
    }

    public static void Show()
    {
        int qt = 0;
        foreach (double prime in primes)
        {
            Console.WriteLine(prime);
            qt++;
        }
        Console.WriteLine("Quantidade : " + qt);
    }
}
