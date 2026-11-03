import dalvik.system.PathClassLoader;
import java.lang.ref.CleanupDomain;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import sun.misc.Cleaner;

public class Main {
    static volatile String finalizedOn;
    static volatile Thread finalizer;
    static volatile String cleanedOn;
    static volatile boolean slowDone;

    static class Finalizable {
        @Override protected void finalize() {
            finalizer = Thread.currentThread();
            finalizedOn = Thread.currentThread().getThreadGroup().getName();
        }
    }

    static class Slow {
        @Override protected void finalize() throws InterruptedException {
            Thread.sleep(500);
            slowDone = true;
        }
    }

    // classes it defines belong to its domain; its parent is the boot loader, so it defines Owned
    static class OwnerLoader extends PathClassLoader implements CleanupDomain.Owner {
        final CleanupDomain domain;

        OwnerLoader(CleanupDomain domain) {
            super(System.getProperty("java.class.path"), ClassLoader.getSystemClassLoader().getParent());
            this.domain = domain;
        }

        @Override public CleanupDomain cleanupDomain() {
            return domain;
        }
    }

    public static void main(String[] args) throws Exception {
        ThreadGroup a = new ThreadGroup("a");
        ThreadGroup b = new ThreadGroup("b");
        new CleanupDomain(a);
        CleanupDomain domainB = new CleanupDomain(b);

        inGroup(a, () -> { makeFinalizable(); collect(); });
        System.out.println("made in a: finalized in " + finalizedOn);
        Thread first = finalizer;

        finalizedOn = null;
        makeFinalizable();
        collect();
        System.out.println("made in main: finalized in " + finalizedOn);

        CountDownLatch cleaned = new CountDownLatch(1);
        inGroup(b, () -> makeCleaner(cleaned));
        while (!cleaned.await(100, TimeUnit.MILLISECONDS))
            Runtime.getRuntime().gc();
        System.out.println("cleaner made in b: ran in " + cleanedOn);

        OwnerLoader loader = new OwnerLoader(domainB);
        System.clearProperty("owned.finalized");
        inGroup(a, () -> makeOwned(loader));
        inGroup(b, Main::collect);
        System.out.println("owned by b's loader, made in a: finalized in " + System.getProperty("owned.finalized"));

        inGroup(a, () -> {
            makeSlow();
            collect();
            System.out.println("runFinalization in a waited for a's slow finalizer: " + slowDone);
        });

        Thread.sleep(11_000);
        System.out.println("idle thread exited: " + !first.isAlive());
        finalizedOn = null;
        inGroup(a, () -> { makeFinalizable(); collect(); });
        System.out.println("next object in a: finalized in " + finalizedOn + " on a new thread " + (finalizer != first));
    }

    static void makeFinalizable() {
        new Finalizable();
    }

    static void makeSlow() {
        new Slow();
    }

    static void makeCleaner(CountDownLatch cleaned) {
        Cleaner.create(new Object(), () -> {
            cleanedOn = Thread.currentThread().getThreadGroup().getName();
            cleaned.countDown();
        });
    }

    static void makeOwned(ClassLoader loader) {
        try {
            loader.loadClass("Owned").getDeclaredConstructor().newInstance();
        } catch (ReflectiveOperationException e) {
            throw new RuntimeException(e);
        }
    }

    // the calling thread's domain finalizes what the GC found
    static void collect() {
        Runtime.getRuntime().gc();
        System.runFinalization();
    }

    static void inGroup(ThreadGroup group, Runnable body) throws InterruptedException {
        Thread thread = new Thread(group, body);
        thread.start();
        thread.join();
    }
}
