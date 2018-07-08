package example.com.open3subproc;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.util.Map;

/**
 *
 */
public class App extends Thread {
    
    /**
     * Just a silly demo app.
     * Write a message every second to stdout.
     * Echos stdin to stderr.
     */
    public static void main(String[] argv) {
        (new App()).start();
        int d = 0;
        try {
            while (true) {
                Thread.sleep(1000);
                ++d;
                System.err.println(""+d);
            }
        } catch (InterruptedException x) {
            // just fall through and exit
        }
    }
    
    public void run() {
        System.getenv().forEach((k,v)->{System.out.println(k+"="+v);});
        LineNumberReader in = new LineNumberReader(new InputStreamReader(System.in));
        String line;
        try {
            while ((line=in.readLine()) != null) {
                if (line.equals("QUIT")) System.exit(0);
                if (line.equals("FAIL")) System.exit(1);
                System.out.println(line);
            }
        } catch (IOException x) {
            System.err.println(x.getMessage());
        }
    }
    
}
