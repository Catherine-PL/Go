// author: Katarzyna Kosiak


package go.game;


import go.game.View.Screen;

import java.io.IOException;
import java.util.Arrays;
import com.ericsson.otp.erlang.OtpErlangAtom;
import com.ericsson.otp.erlang.OtpErlangDecodeException;
import com.ericsson.otp.erlang.OtpErlangExit;
import com.ericsson.otp.erlang.OtpErlangList;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangPid;
import com.ericsson.otp.erlang.OtpErlangTuple;
import com.ericsson.otp.erlang.OtpNode;

public class BoardMessanger extends View implements Runnable {
	  public void run() {
		 while(true) {
		  try
			{	
			  
				getBoard();
			}
		  catch(Exception e){};
	    }
		 }
	  
	  
	  public static char[] cleanList(char[] list)
		{
			char[] bufer = new char[(list.length-1)/2];
			int j=0;
			for(int i=1;i< list.length;i=i+2)
			{
				bufer[j]=list[i];
				j=j+1;
			}
			return bufer;
		}
		
		 
		 public static void getBoard() throws Exception {
		        try {
		        	 if (self==null) self = new OtpNode("mynode", "test");
		             if(mbox==null) mbox = self.createMbox("facserver");
		             
		        } catch (IOException e1) {
		            e1.printStackTrace();
		        }
		 
		        OtpErlangObject[] msg = new OtpErlangObject[2];
		        msg[0] = mbox.self();    
		        msg[1] = new OtpErlangAtom("ping");
		        OtpErlangTuple tuple = new OtpErlangTuple(msg);
		        System.out.println("message ready");
		        mbox.send("boardstate", server, tuple);
		        System.out.println("message sent");
		        while (true)
		            try {
		            	System.out.println("in while");
		                OtpErlangObject robj = mbox.receive();
		                OtpErlangTuple rtuple = (OtpErlangTuple) robj;
		                OtpErlangPid fromPid = (OtpErlangPid) (rtuple.elementAt(0));
		                OtpErlangList rmsg = (OtpErlangList)rtuple.elementAt(1);
		                //checking for winner
		                board=cleanList(rmsg.toString().toCharArray());
		                char[] white={'w','i','e'};
		                char[] black={'b','a','k'};

		                if(Arrays.equals(board, white)==true)
		                {
		                	System.out.println("white is the winner");
		                	view = Screen.ENDGAME;
		                	winner=3;
		                	return;
		                }
		                if(Arrays.equals(board, black))
		                {
		                	System.out.println("black is the winner");
		                	view = Screen.ENDGAME;
		                	winner=2;
		                	return;
		                }
		                
		                
		                
		                break;
		 
		            } catch (OtpErlangExit e) {
		                e.printStackTrace();
		                break;
		            } catch (OtpErlangDecodeException e) {
		                e.printStackTrace();
		            }
		    }
	     
}
