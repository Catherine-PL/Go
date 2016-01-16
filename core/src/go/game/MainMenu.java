// author: Katarzyna Kosiak


package go.game;


import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

import go.game.View;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.InputProcessor;
import com.badlogic.gdx.Input.Buttons;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.Input.Keys;
import com.ericsson.otp.erlang.OtpErlangInt;
import com.ericsson.otp.erlang.OtpErlangAtom;
import com.ericsson.otp.erlang.OtpErlangDecodeException;
import com.ericsson.otp.erlang.OtpErlangExit;
import com.ericsson.otp.erlang.OtpErlangList;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangPid;
import com.ericsson.otp.erlang.OtpErlangTuple;
import com.ericsson.otp.erlang.OtpMbox;
import com.ericsson.otp.erlang.OtpNode;



public class MainMenu  extends View implements InputProcessor {

	
	SpriteBatch batch;
	Texture back;
	Texture sizeoption;
	Texture coloroption;
	
	public void init()
	{
		
		batch = new SpriteBatch();
		back=new Texture("mainmenuback.jpg");
		sizeoption=new Texture("mainmenu9.png");
		coloroption=new Texture("mainmenublack.png");
	}
	
	public void batch()
	{
		Gdx.input.setInputProcessor(this);
		Gdx.gl.glClearColor(1, 0, 0, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		batch.begin();
		batch.draw(back,0,0);
		batch.draw(sizeoption,0,0);
		batch.draw(coloroption,0,0);
		batch.end();	
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
		
		if((Y<screensizeY-263) && (Y>screensizeY-290))
		{
			if((X<393) && (X>356))
			{
				sizeoption=new Texture("mainmenu5.png");
				View.setBoardSize(5);
			}
			if((X<450) && (X>415))
			{
				sizeoption=new Texture("mainmenu7.png");
				View.setBoardSize(7);
			}
			if((X<503) && (X>469))
			{
				sizeoption=new Texture("mainmenu9.png");
				View.setBoardSize(9);
			}
			if((X<570) && (X>528))
			{
				sizeoption=new Texture("mainmenu13.png");
				View.setBoardSize(13);
			}
			if((X<640) && (X>593))
			{
				sizeoption=new Texture("mainmenu19.png");
				View.setBoardSize(19);
			}
		}
		
		if((Y<screensizeY-410) && (Y>screensizeY-437))
		{
			if((X<482) && (X>429))
			{
				coloroption=new Texture("mainmenuwhite.png");
				setPlayerColor(0);
			}
			if((X<570) && (X>521))
			{
				coloroption=new Texture("mainmenublack.png");
				setPlayerColor(1);
			}
		}
		
		if((Y<screensizeY-556) && (Y>screensizeY-596) && (X>424) && (X<576) )
		{
			sendToErlang(View.getBoardSize(),View.getPlayerColor());
			View.setView(Screen.GAMEPLAY);
		}
	
	}
    return false;
}



public void sendToErlang(int info1, int info2)
{
     try {
         if (self==null) self = new OtpNode("mynode", "test");
         if(mbox==null) mbox = self.createMbox("facserver");

         if (self.ping(server, 2000)) {
             //System.out.println("remote is up");
         } else {
             //System.out.println("remote is not up");
             return;
         }
     } catch (IOException e1) {
         e1.printStackTrace();
     }

     OtpErlangObject[] msg = new OtpErlangObject[3];
     msg[0] = mbox.self();    
     msg[1] = new OtpErlangInt(info1);
     msg[2] = new OtpErlangInt(info2);
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
