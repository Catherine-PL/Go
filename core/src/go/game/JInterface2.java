package go.game;

import java.io.IOException;
import com.ericsson.otp.erlang.OtpErlangList;
import com.ericsson.otp.erlang.OtpErlangAtom;
import com.ericsson.otp.erlang.OtpErlangDecodeException;
import com.ericsson.otp.erlang.OtpErlangExit;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangPid;
import com.ericsson.otp.erlang.OtpErlangTuple;
import com.ericsson.otp.erlang.OtpMbox;
import com.ericsson.otp.erlang.OtpNode;
 
public class JInterface2 {
    static String server = "server";
 
    public static void main(String[] _args) throws Exception {
 
        OtpNode self = null;
        OtpMbox mbox = null;
        try {
            self = new OtpNode("mynode", "test");
            mbox = self.createMbox("facserver");
 
            if (self.ping(server, 2000)) {
                System.out.println("remote is up");
            } else {
                System.out.println("remote is not up");
                return;
            }
        } catch (IOException e1) {
            e1.printStackTrace();
        }
 
        OtpErlangObject[] msg = new OtpErlangObject[2];
        msg[0] = mbox.self();    
        msg[1] = new OtpErlangAtom("ping");
        OtpErlangTuple tuple = new OtpErlangTuple(msg);
        mbox.send("pong", server, tuple);
 
        while (true)
            try {
                OtpErlangObject robj = mbox.receive();
                OtpErlangTuple rtuple = (OtpErlangTuple) robj;
                OtpErlangPid fromPid = (OtpErlangPid) (rtuple.elementAt(0));
                OtpErlangList rmsg = (OtpErlangList)rtuple.elementAt(1);
 
                System.out.println("Message: " + rmsg + " received from:  "
                        + fromPid.toString());
 
                OtpErlangAtom ok = new OtpErlangAtom("stop");
                mbox.send(fromPid, ok);
                break;
 
            } catch (OtpErlangExit e) {
                e.printStackTrace();
                break;
            } catch (OtpErlangDecodeException e) {
                e.printStackTrace();
            }
    }
}