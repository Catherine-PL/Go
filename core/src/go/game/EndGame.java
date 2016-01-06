package go.game;


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



public class EndGame  extends View implements InputProcessor {

	
	SpriteBatch batch;
	Texture black;
	
	public void init()
	{
		batch = new SpriteBatch();
		black=new Texture("black.png");
	}
	
	public void batch()
	{
		Gdx.gl.glClearColor(1, 0, 0, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		batch.begin();
		//TODO
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
	
	}
    return false;
}


private void tradeTouch(int X, int Y)
{

	
	
}

private void buildingTouch(int x, int y)
{
	
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
