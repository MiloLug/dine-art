import dalvik.system.VMDebug;

public class Main {
    public static void main(String[] args) {
        long start = VMDebug.threadCpuTimeNanos();
        long deadline = System.nanoTime() + 50_000_000L;
        while (System.nanoTime() < deadline) {
        }
        long end = VMDebug.threadCpuTimeNanos();
        if (start >= 0 && end > start) {
            System.out.println("thread cpu time ok");
        } else {
            System.out.println("thread cpu time failed " + start + " " + end);
        }
    }
}
