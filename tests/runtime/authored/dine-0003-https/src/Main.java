import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.KeyStore;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLException;
import javax.net.ssl.TrustManagerFactory;

public class Main {
    public static void main(String[] args) throws Exception {
        int status = get("https://example.com/", null);
        System.out.println("example.com " + status);
        boolean untrusted = rejects("https://untrusted-root.badssl.com/", null);
        System.out.println("untrusted root threw: " + untrusted);
        boolean wrongHost = rejects("https://wrong.host.badssl.com/", null);
        System.out.println("wrong host threw: " + wrongHost);

        // an app's own keystore gets none of the platform's roots
        KeyStore empty = KeyStore.getInstance(KeyStore.getDefaultType());
        empty.load(null, null);
        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(empty);
        SSLContext context = SSLContext.getInstance("TLS");
        context.init(null, tmf.getTrustManagers(), null);
        // a trusted host with one address: see rejects()
        boolean emptyStore = rejects("https://badssl.com/", context);
        System.out.println("empty keystore threw: " + emptyStore);

        // the one line a run on the phone is graded on
        System.out.println(status == 200 && untrusted && wrongHost && emptyStore ? "https ok" : "https failed");
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

    /* Whether TLS refused the server. Rejection messages differ between trust paths, so only that is
     * printed. Any other IOException (no route, a timeout) says nothing about the certificate and
     * ends the test; after a refusal okhttp tries the host's next address and throws what that one
     * gave, so the hosts here have one address each. */
    static boolean rejects(String url, SSLContext context) throws IOException {
        try {
            get(url, context);
            return false;
        } catch (SSLException e) {
            return true;
        }
    }
}
