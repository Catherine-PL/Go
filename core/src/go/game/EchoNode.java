package go.game;

import com.ericsson.otp.erlang.*;

public class EchoNode {
    public static void main(String[] args) throws Exception {
        OtpNode self = new OtpNode("echonode@localhost");
        OtpMbox mbox = self.createMbox("echoservice");
        OtpErlangObject o;
        OtpErlangTuple msg;
        OtpErlangPid from;

        while (true) {
            try {
                o = mbox.receive();
                System.out.println("Received something.");
                if (o instanceof OtpErlangTuple) {
                    msg = (OtpErlangTuple)o;
                    from = (OtpErlangPid)(msg.elementAt(0));
                    System.out.println("Echoing back...");
                    mbox.send(from,msg.elementAt(1));
                }
            }
            catch (Exception e) {
                System.out.println("" + e);
            }
        }
    }
}