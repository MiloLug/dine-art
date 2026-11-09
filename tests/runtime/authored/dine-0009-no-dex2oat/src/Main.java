import dalvik.system.DexFile;
import dalvik.system.VMRuntime;
import java.io.File;
import java.util.Arrays;

public class Main {
    public static void main(String[] args) throws Exception {
        String isa = VMRuntime.getCurrentInstructionSet();
        // Host ART names an oat file only when this dalvik cache dir exists.
        new File(System.getenv("XDG_CACHE_HOME"), "art/" + isa).mkdirs();
        String jar = System.getProperty("java.class.path");
        String[] paths = DexFile.getDexFileOutputPaths(jar, isa);
        System.out.println("output paths: " + Arrays.toString(paths));
        File marker = new File(System.getenv("DEX_LOCATION"), "dex2oat-ran");
        System.out.println("dex2oat ran: " + marker.exists());
    }
}
