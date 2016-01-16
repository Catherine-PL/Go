// author: Katarzyna Kosiak

package go.game;

import com.badlogic.gdx.ApplicationAdapter;


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
