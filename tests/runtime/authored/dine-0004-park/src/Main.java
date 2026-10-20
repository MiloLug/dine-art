import java.util.concurrent.CountDownLatch;
import java.util.concurrent.locks.LockSupport;

public class Main {
    static final long WAIT_MS = 200;
    static final long MIN_MS = 150;
    // park may return spuriously, so timed cases loop to their deadline; a park that only yields
    // returns thousands of times on the way
    static final int MAX_RETURNS = 10;

    static volatile boolean released;
    static volatile int turn;
    static int failures;

    public static void main(String[] args) throws Exception {
        parkNanos();
        parkUntil();
        LockSupport.parkUntil(System.currentTimeMillis() - 1000);
        System.out.println("past parkUntil returned");
        LockSupport.unpark(Thread.currentThread());
        LockSupport.park();
        System.out.println("permit consumed");
        parkUntilUnpark();
        interruptWakes();
        pingPong(10000);
        latch();
        System.out.println(failures == 0 ? "park ok" : "park failed " + failures);
    }

    static void report(String what, long startNs, int returns) {
        long ms = (System.nanoTime() - startNs) / 1000000;
        if (ms >= MIN_MS && returns <= MAX_RETURNS) {
            System.out.println(what + " blocked");
        } else {
            failures++;
            System.out.println(what + " returned " + returns + " times in " + ms + " ms");
        }
    }

    static void parkNanos() {
        long start = System.nanoTime();
        long deadline = start + WAIT_MS * 1000000;
        int returns = 0;
        for (long left; (left = deadline - System.nanoTime()) > 0; returns++)
            LockSupport.parkNanos(left);
        report("parkNanos", start, returns);
    }

    static void parkUntil() {
        long start = System.nanoTime();
        long deadline = System.currentTimeMillis() + WAIT_MS;
        int returns = 0;
        for (; System.currentTimeMillis() < deadline; returns++)
            LockSupport.parkUntil(deadline);
        report("parkUntil", start, returns);
    }

    static void parkUntilUnpark() throws InterruptedException {
        released = false;
        final int[] returns = new int[1];
        Thread parker = new Thread() {
            public void run() {
                for (; !released; returns[0]++)
                    LockSupport.park();
            }
        };
        long start = System.nanoTime();
        parker.start();
        Thread.sleep(WAIT_MS);
        released = true;
        LockSupport.unpark(parker);
        parker.join();
        report("park until unpark", start, returns[0]);
    }

    static void interruptWakes() throws InterruptedException {
        Thread parker = new Thread() {
            public void run() {
                while (!isInterrupted())
                    LockSupport.park();
            }
        };
        parker.start();
        Thread.sleep(50);
        parker.interrupt();
        parker.join();
        System.out.println("interrupt woke park");
    }

    // Untimed parks: a lost wakeup hangs the test.
    static void pingPong(final int rounds) throws InterruptedException {
        final Thread[] players = new Thread[2];
        for (int i = 0; i < 2; i++) {
            final int me = i;
            players[i] = new Thread() {
                public void run() {
                    for (int r = 0; r < rounds; r++) {
                        while (turn != me)
                            LockSupport.park();
                        turn = 1 - me;
                        LockSupport.unpark(players[1 - me]);
                    }
                }
            };
        }
        turn = 0;
        players[0].start();
        players[1].start();
        players[0].join();
        players[1].join();
        System.out.println("ping-pong " + rounds);
    }

    static void latch() throws InterruptedException {
        final CountDownLatch ready = new CountDownLatch(1);
        final CountDownLatch done = new CountDownLatch(1);
        Thread waiter = new Thread() {
            public void run() {
                ready.countDown();
                try {
                    done.await();
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        };
        waiter.start();
        ready.await();
        done.countDown();
        waiter.join();
        System.out.println("latch ok");
    }
}
