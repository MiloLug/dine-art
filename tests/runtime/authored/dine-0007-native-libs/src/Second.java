// loaded by Main's second loader, whose System.loadLibrary opens the library for itself
public class Second {
    public static void load() {
        System.loadLibrary("nativelibs");
    }

    public static native int value();
}
