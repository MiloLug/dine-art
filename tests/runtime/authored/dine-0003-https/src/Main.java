import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.KeyStore;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

public class Main {
    public static void main(String[] args) throws Exception {
        System.out.println("example.com " + get("https://example.com/", null));
        System.out.println("untrusted root threw: " + throwsOn("https://untrusted-root.badssl.com/", null));
        System.out.println("wrong host threw: " + throwsOn("https://wrong.host.badssl.com/", null));

        // an app's own keystore gets none of the platform's roots
        KeyStore empty = KeyStore.getInstance(KeyStore.getDefaultType());
        empty.load(null, null);
        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(empty);
        SSLContext context = SSLContext.getInstance("TLS");
        context.init(null, tmf.getTrustManagers(), null);
        System.out.println("empty keystore threw: " + throwsOn("https://example.com/", context));

        System.out.println("https ok");
    }

    static int get(String url, SSLContext context) throws IOException {
        HttpsURLConnection connection = (HttpsURLConnection) new URL(url).openConnection();
        if (context != null)
            connection.setSSLSocketFactory(context.getSocketFactory());
        connection.setConnectTimeout(20000);
        connection.setReadTimeout(20000);
        try (InputStream in = connection.getInputStream()) {
            in.read();
            return connection.getResponseCode();
        } finally {
            connection.disconnect();
        }
    }

    // rejection messages differ between trust paths, so only whether it threw is printed
    static boolean throwsOn(String url, SSLContext context) {
        try {
            get(url, context);
            return false;
        } catch (IOException e) {
            return true;
        }
    }
}
