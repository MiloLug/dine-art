import dalvik.system.PathClassLoader;
import java.io.File;
import java.io.IOException;
import java.lang.ref.CleanupDomain;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Enumeration;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import sun.misc.Cleaner;

public class Main {
    static volatile String finalizedOn;
    static volatile Thread finalizer;
    static volatile String cleanedOn;
    static volatile boolean slowDone;
    static volatile boolean ok;

    // prints the line; a value that isn't the wanted one fails the run's last line
    static void report(String what, Object got, Object want) {
        ok &= want.equals(got);
        System.out.println(what + got);
    }

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
            super(ownJar(), ClassLoader.getSystemClassLoader().getParent());
            this.domain = domain;
        }

        @Override public CleanupDomain cleanupDomain() {
            return domain;
        }
    }

    // not java.class.path: an embedder that loads the test itself (Dine) leaves that at "."
    static String ownJar() {
        try {
            String url = null; // jar:file:<path>!/classes.dex; a loader's own entries come after its parents'
            for (Enumeration<URL> all = Main.class.getClassLoader().getResources("classes.dex"); all.hasMoreElements();)
                url = all.nextElement().toString();
            return new File(new URI(url.substring("jar:".length(), url.indexOf("!/")))).getPath();
        } catch (IOException | URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) throws Exception {
        finalizedOn = cleanedOn = null; // Dine reruns main in the same VM
        finalizer = null;
        slowDone = false;
        ok = true;
        ThreadGroup a = new ThreadGroup("a");
        ThreadGroup b = new ThreadGroup("b");
        new CleanupDomain(a);
        CleanupDomain domainB = new CleanupDomain(b);

        inGroup(a, () -> { makeFinalizable(); collect(); });
        report("made in a: finalized in ", finalizedOn, "a");
        Thread first = finalizer;

        finalizedOn = null;
        makeFinalizable();
        collect();
        report("made in main: finalized in ", finalizedOn, "system");

        CountDownLatch cleaned = new CountDownLatch(1);
        inGroup(b, () -> makeCleaner(cleaned));
        while (!cleaned.await(100, TimeUnit.MILLISECONDS))
            Runtime.getRuntime().gc();
        report("cleaner made in b: ran in ", cleanedOn, "b");

        OwnerLoader loader = new OwnerLoader(domainB);
        System.clearProperty("owned.finalized");
        inGroup(a, () -> makeOwned(loader));
        inGroup(b, Main::collect);
        report("owned by b's loader, made in a: finalized in ", System.getProperty("owned.finalized"), "b");

        inGroup(a, () -> {
            makeSlow();
            collect();
            report("runFinalization in a waited for a's slow finalizer: ", slowDone, true);
        });

        Thread.sleep(11_000);
        report("idle thread exited: ", !first.isAlive(), true);
        finalizedOn = null;
        inGroup(a, () -> { makeFinalizable(); collect(); });
        report("next object in a: finalized in ", finalizedOn + " on a new thread " + (finalizer != first), "a on a new thread true");
        System.out.println(ok ? "cleanup ok" : "cleanup failed");
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
