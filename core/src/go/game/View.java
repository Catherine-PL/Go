package go.game;

import com.ericsson.otp.erlang.OtpMbox;
import com.ericsson.otp.erlang.OtpNode;


public abstract class View {
	public enum Screen {
	    MAINMENU, GAMEPLAY, ENDGAME,END}
	
	private static Screen view = Screen.MAINMENU;
	final static int screensizeX=1000; 
	final static int screensizeY=700; 
	private static int boardsize=9; 
	private static int playerColor=1; //0 white 1 black 
	static OtpNode self = null;
	static OtpMbox mbox = null;
	static String server = "server";
	static char[] board;
	
	
	public void init(){}
	public void batch(){}
	
	public static void setBoardSize(int _size)
	{
		boardsize=_size;
	}
	public static int getBoardSize()
	{
		return boardsize;
	}
	
	
	public static void setPlayerColor(int _color)
	{
		playerColor=_color;
	}
	public static int getPlayerColor()
	{
		return playerColor;
	}
	
	
	public static Screen setView(Screen _view)
	{
		view = _view;
		return view;
	}
	
	public static Screen getView()
	{
		return view;
	}

}
