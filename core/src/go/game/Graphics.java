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
	private MainMenu mainMenu = new MainMenu();
	private Gameplay gameplay = new Gameplay();
	private EndGame endGame = new EndGame();

	@Override
	public void create () {
		mainMenu.init();
		gameplay.init();
		endGame.init();
	}

	@Override
	public void render () 
	{
			switch(View.getView())
			{
				case MAINMENU:
					mainMenu.batch();
			        break;
				case GAMEPLAY:
					gameplay.batch();
			        break;
				case ENDGAME:
			        endGame.batch();
			        break;
				case END:
					System.exit(0);
			}
		
	}

	
//TODO na razie mnie to nie interesuje	
	public void dispose() {
	      // dispose of all the native resources
		
	   }

	   @Override
	   public void resize(int width, int height) {
	   }

	   @Override
	   public void pause() {
	   }

	   @Override
	   public void resume() {
	   }
	}
