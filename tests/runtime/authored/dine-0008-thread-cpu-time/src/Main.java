import dalvik.system.VMDebug;

public class Main {
    static volatile boolean stop;

    public static void main(String[] args) throws Exception {
        // asleep beside a thread that burns CPU: wall time and the process's CPU time both run on
        stop = false;
        Thread burner = new Thread() {
            public void run() {
                while (!stop) {
                }
            }
        };
        burner.start();
        long asleep = VMDebug.threadCpuTimeNanos();
        try {
            Thread.sleep(400);
        } finally {
            stop = true;
        }
        asleep = VMDebug.threadCpuTimeNanos() - asleep;
        burner.join();

        long start = VMDebug.threadCpuTimeNanos();
        long deadline = System.nanoTime() + 50_000_000L;
        while (System.nanoTime() < deadline) {
        }
        long end = VMDebug.threadCpuTimeNanos();
        if (start >= 0 && end > start && asleep >= 0 && asleep < 100_000_000L) {
            System.out.println("thread cpu time ok");
        } else {
            System.out.println("thread cpu time failed " + start + " " + end + " asleep " + asleep);
        }
    }
}
