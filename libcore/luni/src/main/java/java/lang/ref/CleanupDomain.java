package java.lang.ref;

import sun.misc.Cleaner;

/**
 * One app's cleanup thread, in the app's ThreadGroup: it runs the finalizers and Cleaners of the
 * app's objects, so they see the app and a slow one holds up only that app. An object belongs to
 * its class loader's domain ({@link Owner}), else to the domain of its creating thread's group,
 * else to none (ART's daemons clean it). The thread starts with the first object to clean and
 * exits after IDLE_MILLIS without one.
 *
 * @hide
 */
public final class CleanupDomain {
    /** A class loader whose classes' objects belong to an app. */
    public interface Owner {
        /** The app's domain; null while the app doesn't run. */
        CleanupDomain cleanupDomain();
    }

    private static final long IDLE_MILLIS = 10_000;

    final Queue finalizers = new Queue(this);
    final Queue cleaners = new Queue(this);
    private final ThreadGroup group;
    private final Object lock = new Object();
    private Thread thread; // null while idle; guarded by lock
    private boolean signalled; // an enqueue since the thread last found both queues empty

    /** The domain of group's threads and of the subgroups made after it. */
    public CleanupDomain(ThreadGroup group) {
        this.group = group;
        group.setCleanupDomain(this);
    }

    static final class Queue extends ReferenceQueue<Object> {
        final CleanupDomain domain;

        Queue(CleanupDomain domain) {
            this.domain = domain;
        }
    }

    private static CleanupDomain of(Object referent) {
        ClassLoader loader = referent.getClass().getClassLoader();
        if (loader instanceof Owner) {
            CleanupDomain domain = ((Owner) loader).cleanupDomain();
            if (domain != null)
                return domain;
        }
        return Thread.currentCleanupDomain();
    }

    /** FinalizerReference.add's queue for referent: its domain's, else null. */
    static ReferenceQueue<Object> finalizerQueueFor(Object referent) {
        CleanupDomain domain = of(referent);
        return domain != null ? domain.finalizers : null;
    }

    /** Cleaner's queue for referent: its domain's, else null (the Cleaner runs where it's enqueued). */
    public static ReferenceQueue<Object> cleanerQueueFor(Object referent) {
        CleanupDomain domain = of(referent);
        return domain != null ? domain.cleaners : null;
    }

    // after the reference is on its queue: run() polls again after each signal, so none is missed
    void enqueued() {
        synchronized (lock) {
            signalled = true;
            if (thread != null) {
                lock.notifyAll();
                return;
            }
            // made by whichever thread enqueues (ReferenceQueueDaemon): nothing may come from it
            try {
                Thread started = new Thread(group, this::run, "CleanupDaemon");
                started.setDaemon(true);
                started.setPriority(Thread.NORM_PRIORITY);
                started.start();
                thread = started;
            } catch (Throwable e) { // no thread now (OOM, shutdown): the next enqueue tries again
                System.logE("CleanupDomain: can't start a cleanup thread", e);
            }
        }
    }

    private void run() {
        while (true) {
            Reference<?> reference = finalizers.poll();
            if (reference != null) {
                Daemons.finalizeReference((FinalizerReference<?>) reference);
                continue;
            }
            reference = cleaners.poll();
            if (reference != null) {
                ((Cleaner) reference).clean();
                continue;
            }
            synchronized (lock) {
                if (!signalled) {
                    try {
                        lock.wait(IDLE_MILLIS);
                    } catch (InterruptedException ignored) {
                    }
                }
                if (!signalled) {
                    thread = null;
                    return;
                }
                signalled = false;
            }
        }
    }
}
