import java.sql.Time;
import java.util.ArrayList;
import java.lang.Thread;

class Main{
    private static ArrayList<Double> primes = new ArrayList<Double>();
    public static void main(String[] args) {
        double max = Math.pow(10,7);
        enginePreviousPrimes(max);
    }

    public static void enginePreviousPrimes(double max){
        System.out.println(max);
        primes.add(2.0);
        // engine
        double raiz = 1;
        double n = 3;
        boolean p = true;
        long init = System.nanoTime();
        while (n<=max){
            p = true;
            raiz = Math.pow(n,0.5)+1;
            for (double k : primes){
                if (n%k==0) p=false;
                if (k>raiz) break;
            }
            if (p) primes.add(n);
            n+=2.0;
        }
        //
        show();
        System.out.printf("Last : %f\nTempo (s): %.9f\n",n,((float) (System.nanoTime()-init)/1000000000));

    }

    public static void sleep(double tempo){
        try{
            Thread.sleep((long) tempo*1000);
        } catch (Exception e){

        }
    }

    public static void show(){
        int qt = 0;
        for (double n : primes){
            System.out.println(n);
            qt++;
        }
        System.out.println("Quantidade : "+qt);
    }
}