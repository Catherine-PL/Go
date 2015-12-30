package go.game;
import com.ericsson.otp.erlang.*;

public class CounterServer
{

	public static void main(String[] args) throws Exception

         {

	       OtpNode myNode = new OtpNode("server");

                OtpMbox myMbox = myNode.createMbox("counterserver");

                OtpErlangObject myObject;

                OtpErlangTuple myMsg;

                OtpErlangPid from;

                OtpErlangString command;

                Integer counter = 0;

	       OtpErlangAtom myAtom = new OtpErlangAtom("ok");

	       while(counter >= 0) try

                {

                        myObject = myMbox.receive();

                        myMsg = (OtpErlangTuple) myObject;

                        from = (OtpErlangPid) myMsg.elementAt(0);

                        command = (OtpErlangString) myMsg.elementAt(1);

                        // here you may want to check the value of command

                        OtpErlangObject[] reply = new OtpErlangObject[2];

                        reply[0] = myAtom;

                        reply[1] = new OtpErlangInt(counter);

                        OtpErlangTuple myTuple = new OtpErlangTuple(reply);

                        myMbox.send(from, myTuple);

                        counter++;

		} catch(OtpErlangExit e)

                  {

                        break;

                  }

        }

}