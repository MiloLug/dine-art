public class Main {
    interface Body {
        long run() throws Exception;
    }

    public static void main(String[] args) throws Exception {
        System.loadLibrary("embeddertag");
        final ThreadGroup a = new ThreadGroup("a");
        final ThreadGroup b = new ThreadGroup("b");
        setTag(a, 0xa);
        setTag(b, 0xb);
        final Body current = new Body() {
            public long run() {
                return currentTag();
            }
        };

        print("main", currentTag());
        print("constructed in a", onThread(a, current));
        print("constructed in b by a thread of a", onThread(a, new Body() {
            public long run() throws Exception {
                return onThread(b, current);
            }
        }));
        print("constructed without a group by a thread of a", onThread(a, new Body() {
            public long run() throws Exception {
                return onThread(null, current);
            }
        }));
        print("in a subgroup of a", onThread(new ThreadGroup(a, "sub"), current));
        print("attached to a", attachedTag(a));
        print("attached without a group", attachedTag(null));
        System.out.println("attach group set: " + setAttachGroup(a));
        System.out.println("attach group set again: " + setAttachGroup(b));
        print("attached without a group after the default", attachedTag(null));
        System.out.println("main joined b: " + joinGroup(b));
        print("main's tag", currentTag());
        System.out.println("main's group is b: " + (Thread.currentThread().getThreadGroup() == b));
        print("constructed without a group by main", onThread(null, current));
    }

    static void print(String what, long tag) {
        System.out.println(what + ": " + Long.toHexString(tag));
    }

    static long onThread(ThreadGroup group, final Body body) throws Exception {
        final long[] out = new long[1];
        final Exception[] error = new Exception[1];
        Runnable runnable = new Runnable() {
            public void run() {
                try {
                    out[0] = body.run();
                } catch (Exception e) {
                    error[0] = e;
                }
            }
        };
        Thread thread = group != null ? new Thread(group, runnable) : new Thread(runnable);
        thread.start();
        thread.join();
        if (error[0] != null) {
            throw error[0];
        }
        return out[0];
    }

    static native void setTag(ThreadGroup group, long tag);
    static native long currentTag();
    // the tag a C thread attached with this group (null: none) sees
    static native long attachedTag(ThreadGroup group);
    static native boolean setAttachGroup(ThreadGroup group);
    static native boolean joinGroup(ThreadGroup group);
}
