import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.Enumeration;

public class Main {
    public static void main(String[] args) throws Exception {
        // every interface and every address family the platform lists goes through Os.getifaddrs
        boolean loopback = false;
        int interfaces = 0;
        Enumeration<NetworkInterface> all = NetworkInterface.getNetworkInterfaces(); // null: none
        for (NetworkInterface netif : all == null ? Collections.<NetworkInterface>emptyList() : Collections.list(all)) {
            interfaces++;
            netif.getHardwareAddress();
            for (InetAddress address : Collections.list(netif.getInetAddresses()))
                loopback |= address.isLoopbackAddress();
        }
        System.out.println(interfaces > 0 && loopback ? "netif ok" : "netif failed " + interfaces + " " + loopback);
    }
}
