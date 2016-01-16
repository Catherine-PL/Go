// author: Katarzyna Kosiak


package go.game;


import java.util.HashMap;
import java.util.Map;
import go.game.View;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.InputProcessor;
import com.badlogic.gdx.Input.Buttons;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import java.io.IOException;
import com.ericsson.otp.erlang.OtpErlangInt;
import com.ericsson.otp.erlang.OtpErlangAtom;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangTuple;
import com.ericsson.otp.erlang.OtpNode;



public class Gameplay  extends View implements InputProcessor {
	
	SpriteBatch batch;
	Texture black;
	Map<Integer, Texture> backs;
	Texture white;
	Texture turntext;
	boolean playerturn=true;
	
	

	public void init()
	{
		board = new char[361];
		batch = new SpriteBatch();
		backs= new HashMap<Integer, Texture>();
		new Thread(new BoardMessanger()).start();
		
		backs.put(5,new Texture("gameplayback5.png"));
		backs.put(7,new Texture("gameplayback7.png"));
		backs.put(9,new Texture("gameplayback9.png"));
		backs.put(13,new Texture("gameplayback13.png"));
		backs.put(19,new Texture("gameplayback19.png"));
		turntext=new Texture("turntext.png");
		
		
		
		black=new Texture("black.png");
		white=new Texture("white.png");
	}
	
	public void batch()
	{
		Gdx.input.setInputProcessor(this);
		Gdx.gl.glClearColor(1, 0, 0, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		System.out.println(board);
		batch.begin();
		batch.draw(backs.get(View.getBoardSize()),0,0);
		if(playerturn==true)
		{
			batch.draw(turntext,0,0);
		}
		batchBoard();
		batch.end();
	}
	

	public void batchBoard()
	{
		int size = (int)Math.sqrt(board.length);
		int y=425+(size-5)/2*30;
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
		}
	
	
	}
	
     
	 

@Override
public boolean keyDown(int keycode) {
    return false;
}

@Override
public boolean keyUp(int keycode) {
    return false;
}

@Override
public boolean keyTyped(char character) {
    return false;
}

@Override
public boolean touchDown(int screenX, int screenY, int pointer, int button) {
	if(button == Buttons.LEFT){
		int X=screenX;
		int Y=screensizeY - screenY;
		if (playerturn==true)
		{
			sendMove(X,Y);
		}
		
		
			//sendToErlang(n,X2,Y2)
		//sendToErlang(y,0,0)
	}
    return false;
}

public void sendMove(int X,int Y)
{
	int Ysend=0;
	//Y=screensizeY - Y;
	int size = (int)Math.sqrt(board.length);
	int y=425+(size-5)/2*30;
	int x=485-30*(size/2);
	 System.out.println(X);
	 System.out.println(Y);
	//Y=screensizeY - Y;
	if((X>677)&&(X<738)&&(Y<screensizeY -660)&&(Y>screensizeY -674) )
	{
		sendToErlang("y",0,0);
		return;
	}
	//Y=screensizeY - Y;
	for(int i=0;i< board.length;i++)
	{
		if (i % size==0)
		{
			y=y-30;
			Ysend=Ysend+1;
		}
	
		if( (X>x + 30*(i%size)) && (X<x+30 + 30*(i%size)) && (Y>y) && (Y<y+30)  )
		{
			if(board[i]=='o')
			{
				sendToErlang("n",i%size+1,Ysend);
			}
		}
		
	}

}

public void sendToErlang(String info1, int info2, int info3)
{
     try {
         if (self==null) self = new OtpNode("mynode", "test");
         if(mbox==null) mbox = self.createMbox("facserver");

     } catch (IOException e1) {
         e1.printStackTrace();
     }

     OtpErlangObject[] msg = new OtpErlangObject[4];
     msg[0] = mbox.self();    
     msg[1] = new OtpErlangAtom(info1);
     msg[2] = new OtpErlangInt(info2);
     msg[3] = new OtpErlangInt(info3);
     OtpErlangTuple tuple = new OtpErlangTuple(msg);
     mbox.send("info",server, tuple);

  
}

@Override
public boolean touchUp(int screenX, int screenY, int pointer, int button) {
    return false;
}

@Override
public boolean touchDragged(int screenX, int screenY, int pointer) {
    return false;
}

@Override
public boolean mouseMoved(int screenX, int screenY) {
    return false;
}

@Override
public boolean scrolled(int amount) {
    return false;
}
	
}
