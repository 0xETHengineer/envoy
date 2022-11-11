import com.samourai.whirlpool.client.whirlpool.WhirlpoolClientConfig;
import com.samourai.whirlpool.client.whirlpool.WhirlpoolClientImpl;
import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;
import org.graalvm.nativeimage.c.type.CCharPointer;
import org.graalvm.nativeimage.c.type.CTypeConversion;

public class WhirlpoolEnvoy {

  public static WhirlpoolClientImpl client;
  public static String lastError = "hello error";

  public static void main(String[] args) {
    System.out.println("Hello from WhirlpoolEnvoy!");
  }

  @CEntryPoint(name = "whirlpool")
  public static boolean whirlpool(IsolateThread thread) {
    System.out.println("Whirlpoolinggggg!");

    WhirlpoolClientConfig config =
        new WhirlpoolClientConfig(null, null, null, null, null, null, null);

    try {
      client = new WhirlpoolClientImpl(config);
      client.whirlpool(null, null);
    } catch (Exception e) {
      System.out.println("Caught an exception!");
      lastError = e.toString();
      return false;
    }

    return true;
  }

  @CEntryPoint(name = "stop")
  public static boolean stop(IsolateThread thread) {

    client.stop(true);
    System.out.println("Stop!");
    return true;
  }

  @CEntryPoint(name = "get_last_error")
  public static CCharPointer getLastError(IsolateThread thread) {
    final CTypeConversion.CCharPointerHolder holder = CTypeConversion.toCString(lastError);
    return holder.get();
  }
}
