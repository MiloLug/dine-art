public class Main {
    static int failures;

    public static void main(String[] args) {
        failures = 0;  // Dine reruns main in the same VM.
        System.loadLibrary("dinejniargs");
        ints();
        intsInstance();
        longs();
        floats();
        doubles();
        bytes();
        shorts();
        chars();
        booleans();
        objects();
        mixed();
        System.out.println(failures == 0 ? "jni args ok" : "jni args failed " + failures);
    }

    // Each native returns the argument its first parameter selects. With JNIEnv*, the class and
    // n in registers, 16 more arguments of one type spill to the stack on every ABI we run.
    static native int pickInt(int n, int a0, int a1, int a2, int a3, int a4, int a5, int a6,
            int a7, int a8, int a9, int a10, int a11, int a12, int a13, int a14, int a15);
    native int pickIntInstance(int n, int a0, int a1, int a2, int a3, int a4, int a5, int a6,
            int a7, int a8, int a9, int a10, int a11, int a12, int a13, int a14, int a15);
    static native long pickLong(int n, long a0, long a1, long a2, long a3, long a4, long a5,
            long a6, long a7, long a8, long a9, long a10, long a11, long a12, long a13, long a14,
            long a15);
    static native float pickFloat(int n, float a0, float a1, float a2, float a3, float a4,
            float a5, float a6, float a7, float a8, float a9, float a10, float a11, float a12,
            float a13, float a14, float a15);
    static native double pickDouble(int n, double a0, double a1, double a2, double a3, double a4,
            double a5, double a6, double a7, double a8, double a9, double a10, double a11,
            double a12, double a13, double a14, double a15);
    static native byte pickByte(int n, byte a0, byte a1, byte a2, byte a3, byte a4, byte a5,
            byte a6, byte a7, byte a8, byte a9, byte a10, byte a11, byte a12, byte a13, byte a14,
            byte a15);
    static native short pickShort(int n, short a0, short a1, short a2, short a3, short a4,
            short a5, short a6, short a7, short a8, short a9, short a10, short a11, short a12,
            short a13, short a14, short a15);
    static native char pickChar(int n, char a0, char a1, char a2, char a3, char a4, char a5,
            char a6, char a7, char a8, char a9, char a10, char a11, char a12, char a13, char a14,
            char a15);
    static native boolean pickBoolean(int n, boolean a0, boolean a1, boolean a2, boolean a3,
            boolean a4, boolean a5, boolean a6, boolean a7, boolean a8, boolean a9, boolean a10,
            boolean a11, boolean a12, boolean a13, boolean a14, boolean a15);
    static native Object pickObject(int n, Object a0, Object a1, Object a2, Object a3, Object a4,
            Object a5, Object a6, Object a7, Object a8, Object a9, Object a10, Object a11,
            Object a12, Object a13, Object a14, Object a15);
    // Narrow arguments ahead of wide ones on the stack, and more than 8 FP arguments. No objects:
    // a misplaced reference would abort the VM in CheckJNI before the mismatch is printed.
    static native long pickMixed(int n, byte b0, long j1, short s2, float f3, char c4, double d5,
            boolean z6, int i7, byte b8, float f9, short s10, double d11, char c12, long j13,
            boolean z14, float f15, int i16, double d17, byte b18, float f19, short s20, long j21,
            char c22, double d23, float f24, double d25, float f26, double d27);

    static void report(String what, int before) {
        System.out.println(what + (failures == before ? " ok" : " failed"));
    }

    static void check(String what, int n, long got, long want) {
        if (got != want) {
            failures++;
            System.out.println(what + " arg " + n + ": got " + got + " want " + want);
        }
    }

    static void ints() {
        int before = failures;
        int[] a = new int[16];
        for (int i = 0; i < 16; i++) a[i] = -0x01020305 * (i + 1);
        for (int n = 0; n < 16; n++) {
            check("int", n, pickInt(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9],
                    a[10], a[11], a[12], a[13], a[14], a[15]), a[n]);
        }
        report("int", before);
    }

    static void intsInstance() {
        int before = failures;
        Main self = new Main();
        int[] a = new int[16];
        for (int i = 0; i < 16; i++) a[i] = 0x0a0b0c0d + 0x01010101 * i;
        for (int n = 0; n < 16; n++) {
            check("int instance", n, self.pickIntInstance(n, a[0], a[1], a[2], a[3], a[4], a[5],
                    a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]), a[n]);
        }
        report("int instance", before);
    }

    static void longs() {
        int before = failures;
        long[] a = new long[16];
        for (int i = 0; i < 16; i++) a[i] = (i % 2 == 0 ? 1 : -1) * 0x0102030405060708L * (i + 1);
        for (int n = 0; n < 16; n++) {
            check("long", n, pickLong(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8],
                    a[9], a[10], a[11], a[12], a[13], a[14], a[15]), a[n]);
        }
        report("long", before);
    }

    static void floats() {
        int before = failures;
        float[] a = new float[16];
        for (int i = 0; i < 16; i++) a[i] = (i % 2 == 0 ? 1 : -1) * (i + 0.5f);
        for (int n = 0; n < 16; n++) {
            float got = pickFloat(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9],
                    a[10], a[11], a[12], a[13], a[14], a[15]);
            check("float", n, Float.floatToRawIntBits(got), Float.floatToRawIntBits(a[n]));
        }
        report("float", before);
    }

    static void doubles() {
        int before = failures;
        double[] a = new double[16];
        for (int i = 0; i < 16; i++) a[i] = (i % 2 == 0 ? -1 : 1) * (i + 0.25);
        for (int n = 0; n < 16; n++) {
            double got = pickDouble(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9],
                    a[10], a[11], a[12], a[13], a[14], a[15]);
            check("double", n, Double.doubleToRawLongBits(got), Double.doubleToRawLongBits(a[n]));
        }
        report("double", before);
    }

    static void bytes() {
        int before = failures;
        byte[] a = new byte[16];
        for (int i = 0; i < 16; i++) a[i] = (byte) -(i + 1);
        for (int n = 0; n < 16; n++) {
            check("byte", n, pickByte(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9],
                    a[10], a[11], a[12], a[13], a[14], a[15]), a[n]);
        }
        report("byte", before);
    }

    static void shorts() {
        int before = failures;
        short[] a = new short[16];
        for (int i = 0; i < 16; i++) a[i] = (short) (-1000 * (i + 1));
        for (int n = 0; n < 16; n++) {
            check("short", n, pickShort(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8],
                    a[9], a[10], a[11], a[12], a[13], a[14], a[15]), a[n]);
        }
        report("short", before);
    }

    static void chars() {
        int before = failures;
        char[] a = new char[16];
        for (int i = 0; i < 16; i++) a[i] = (char) (0x8000 + 0x111 * i);
        for (int n = 0; n < 16; n++) {
            check("char", n, pickChar(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9],
                    a[10], a[11], a[12], a[13], a[14], a[15]), a[n]);
        }
        report("char", before);
    }

    static void booleans() {
        int before = failures;
        for (int n = 0; n < 16; n++) {
            // Argument n is the only true one, then the only false one.
            for (boolean value : new boolean[] {true, false}) {
                boolean[] a = new boolean[16];
                for (int i = 0; i < 16; i++) a[i] = (i == n) == value;
                boolean got = pickBoolean(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8],
                        a[9], a[10], a[11], a[12], a[13], a[14], a[15]);
                check("boolean", n, got ? 1 : 0, value ? 1 : 0);
            }
        }
        report("boolean", before);
    }

    static void objects() {
        int before = failures;
        Object[] a = new Object[16];
        for (int i = 0; i < 16; i++) a[i] = "object " + i;
        for (int n = 0; n < 16; n++) {
            Object got = pickObject(n, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9],
                    a[10], a[11], a[12], a[13], a[14], a[15]);
            check("object", n, got == a[n] ? 1 : 0, 1);
        }
        report("object", before);
    }

    static long bits(float f) {
        return Float.floatToRawIntBits(f) & 0xffffffffL;
    }

    static long bits(double d) {
        return Double.doubleToRawLongBits(d);
    }

    static void mixed() {
        int before = failures;
        byte b0 = -3, b8 = -17, b18 = -101;
        short s2 = -1234, s10 = -20001, s20 = -32000;
        char c4 = 0x8001, c12 = 0x9abc, c22 = 0xfedc;
        boolean z6 = true, z14 = true;
        int i7 = -0x11223344, i16 = 0x55667788;
        long j1 = -0x0102030405060708L, j13 = 0x1112131415161718L, j21 = -0x2122232425262728L;
        float f3 = 1.5f, f9 = -2.25f, f15 = 3.125f, f19 = -4.0625f, f24 = 5.5f, f26 = -6.75f;
        double d5 = -7.5, d11 = 8.25, d17 = -9.125, d23 = 10.0625, d25 = -11.5, d27 = 12.75;
        long[] want = {b0, j1, s2, bits(f3), c4, bits(d5), 1, i7, b8, bits(f9), s10, bits(d11),
                c12, j13, 1, bits(f15), i16, bits(d17), b18, bits(f19), s20, j21, c22, bits(d23),
                bits(f24), bits(d25), bits(f26), bits(d27)};
        for (int n = 0; n < want.length; n++) {
            check("mixed", n, pickMixed(n, b0, j1, s2, f3, c4, d5, z6, i7, b8, f9, s10, d11, c12,
                    j13, z14, f15, i16, d17, b18, f19, s20, j21, c22, d23, f24, d25, f26, d27),
                    want[n]);
        }
        report("mixed", before);
    }
}
