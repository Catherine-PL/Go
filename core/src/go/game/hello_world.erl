-module(hello_world).
-export([start/0,pong/0,getTestBoard/0,listBoard/2]).
  


getTestBoard() ->
[board,[{{1,1},b},
  {{1,2},o},
  {{1,3},w},
  {{1,4},w},
  {{1,5},o},
  {{2,1},w},
  {{2,2},b},
  {{2,3},b},
  {{2,4},b},
  {{2,5},o},
  {{3,1},b},
  {{3,2},b},
  {{3,3},w},
  {{3,4},w},
  {{3,5},b},
  {{4,1},o},
  {{4,2},o},
  {{4,3},b},
  {{4,4},b},
  {{4,5},o},
  {{5,1},w},
  {{5,2},w},
  {{5,3},b},
  {{5,4},o},
  {{5,5},o}],5].

listBoard([board,[{_,H}],_],Bufor) ->
  Bufor ++ [H];

listBoard([board,[{_,H}|T],Y],Bufor) ->
  Bufor2=Bufor ++ [H],
  listBoard([board,T,Y],Bufor2).


pong() ->
    receive
        stop ->
            io:format("Pong finished...~n",[]);         
        {PingId,ping} ->
            io:format("Ping~n",[]),
            PingId ! {self(),listBoard(getTestBoard(),[ ])},
            pong()
    end.
 
start() ->
        register(pong,spawn(hello_world,pong,[])).
