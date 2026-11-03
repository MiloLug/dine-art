import dalvik.system.PathClassLoader;

public class Main {
    static native int value();
    static native void registerList();
    static native int listed();
    static native int unlisted();

    public static void main(String[] args) throws Exception {
        System.loadLibrary("nativelibs");
        System.out.println("first loader: " + value());

        // a second loader of the test's classes, as a second app's loader
        ClassLoader second = new PathClassLoader(System.getProperty("java.class.path"),
                                                 System.getProperty("java.library.path"), null);
        Class<?> secondClass = second.loadClass("Second");
        secondClass.getMethod("load").invoke(null);
        System.out.println("second loader: " + secondClass.getMethod("value").invoke(null));

        registerList();
        System.out.println("listed: " + listed());
        try {
            System.out.println("unlisted bound: " + unlisted());
        } catch (UnsatisfiedLinkError e) {
            System.out.println("unlisted: UnsatisfiedLinkError");
        }
    }
}
