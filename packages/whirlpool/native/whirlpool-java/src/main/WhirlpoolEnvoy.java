import org.graalvm.nativeimage.IsolateThread;
import org.graalvm.nativeimage.c.function.CEntryPoint;

public class WhirlpoolEnvoy {

  public static void main(String[] args) {
    System.out.println("Hello from WhirlpoolEnvoy!");
  }

  @CEntryPoint(name = "whirlpool")
  public static boolean whirpool(IsolateThread thread) {
    System.out.println("Whirlpoolin'!");
    return true;
  }

  @CEntryPoint(name = "stop")
  public static boolean stop(IsolateThread thread) {
    System.out.println("Stop!");
    return true;
  }
}
