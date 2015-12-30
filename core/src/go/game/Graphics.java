//cd("d:/Zainstalowane/Eclipse/Go/core/src/go/game").

package go.game;

import com.badlogic.gdx.ApplicationAdapter;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

import java.lang.Character;
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

public class Graphics extends ApplicationAdapter {
	SpriteBatch batch;
	Texture black;
	Texture white;
	Texture empty;
	static char[] board;
	static String server = "server";
	
	

	
	@Override
	public void create () {
		board = new char[361];
		board[0]=' ';
		
		batch = new SpriteBatch();
		black=new Texture("black.png");
		empty=new Texture("empty.png");
		white=new Texture("white.png");
	}

	@Override
	public void render ()  {
		Gdx.gl.glClearColor(1, 0, 0, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		try
		{
			getBoard();
		}
		catch(Exception e){};
		batch.begin();
		batchBoard();
		batch.end();
		System.out.println(board);
	}
	
	
	
	public void batchBoard()
	{
		int size = (int)Math.sqrt(board.length);
		int y=680;
		int x=485-30*(size/2);
		for(int i=0;i< board.length;i++)
		{
			if (i % size==0)
			{
				y=y-30;
			}
			
			
			if (board[i]=='b')
			{
				batch.draw(black, x + 30*(i%size),y );
			}
			else if (board[i]=='w')
			{
				batch.draw(white, x + 30*(i%size),y );
			}
			else
			{
				batch.draw(empty, x + 30*(i%size),y );
			}
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
	                board=cleanList(rmsg.toString().toCharArray()) ;
	                break;
	 
	            } catch (OtpErlangExit e) {
	                e.printStackTrace();
	                break;
	            } catch (OtpErlangDecodeException e) {
	                e.printStackTrace();
	            }
	    }
     
	
	
	
	
	
	
	
	
	
	
	

}


