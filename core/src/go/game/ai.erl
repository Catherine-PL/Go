	-module(ai).
	-export([getPossibleBoards/4,receiveBoards/3,getBoardOption/4,countColor/3
          ]).
  -import(lists, [delete/2,map/2,foldl/3,foldr/3,seq/2, 
                  nth/2, filter/2, flatten/1]).
  -import(list, [listContains/2,len/1,listHasSameItem/2,
                  remove_dups/1,remove_dups_list/2]).
  -import(bs,[

          init/1, boardPrint/2, compareBoards/2,

          getAllColor/3, checkChainsByColor/2, whoWon/1, putStoneChecked/4
          ]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASICS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%pobiera liste miejsc i plansze i zwraca te które są poprawne i różne od ActualBoard
getPossibleBoards(Color,AllColor,ActualBoard,Pid) ->
 Len=len(AllColor),
 %RPid = spawn(ai,receiveBoards,[[ ],Len,self()]),
 RPid=spawn(ai,receiveBoards,[[ ],Len-1,self()]),
 io:fwrite("Rpid is  ~p ", [RPid]),
 getBoardOption(AllColor,Color,ActualBoard,RPid),
 receive
    {allboards,Boards} ->
       Boards
 end.



%do odbierania boardów z getBoardOption
receiveBoards(Bufor, 0, Pid) ->
io:fwrite("Receiver of Boards is ending ", [ ]),
  Pid!{allboards,Bufor};

receiveBoards(Bufor, Len, Pid) ->
io:fwrite("Receiver of Boards is running ~p ", [Len]),
io:fwrite("Waiting for a message ~p ", [Len]),
  receive
    same ->
       io:fwrite("received same  ", []),
      receiveBoards(Bufor, Len-1, Pid);
    {boardhere,NewBoard} ->
      Bufor2=Bufor ++[NewBoard],
      io:fwrite("Received board  ", []),
      receiveBoards(Bufor2, Len-1, Pid)
  end.



getBoardOption( [{X,Y}|[ ]],Color,ActualBoard,RPid)->
  [NewBoard,OldBoard] =putStoneChecked(Color,X,Y,[ActualBoard, ActualBoard]),
   io:fwrite("I am in getBoardOption at the end of colorlist   ", []),
  io:fwrite("Board number 1 ", [ ]),
  if
    NewBoard==OldBoard ->
     io:fwrite("Message sent 1x ", [ ]),
      RPid!same;
    true ->
         io:fwrite("Message sent 2x ", [ ]),
      RPid!{boardhere,NewBoard}
  end;

%pomocnicza - wysła Boarda dla danego pola do receivera
getBoardOption( [{X,Y}|T],Color,ActualBoard,RPid)->
 % io:fwrite("I am in getBoardOption - beginning  ", []),
  Len=len([{X,Y}|T]),
  io:fwrite("Board number ~p ", [Len]),
  %RPid = spawn(ai,receiveBoards,[[ ],Len,self()]),
  spawn(ai,getBoardOption,[T,Color,ActualBoard,RPid]),
  io:fwrite("I am in getBoardOption - after spawn  ", []),


  [NewBoard,OldBoard] =putStoneChecked(Color,X,Y,[ActualBoard, ActualBoard]),
  NewBoard2=isProfitable(Color,NewBoard,ActualBoard),
   if
    NewBoard2==OldBoard ->
     io:fwrite("Message sent 1xxxx ", [ ]),
      RPid!same;
    true ->
         io:fwrite("Message sent 2xxx ", [ ]),
      RPid!{boardhere,NewBoard2}
  end.

%dla jednego punktu Profitable
isProfitable(Color,NewBoard,ActualBoard2)->
   ActualBoard=checkChainsByColor(Color, ActualBoard2),
  NewBoard2=checkChainsByColor(Color, NewBoard),
  AmountOld= len(getAllColor(Color,ActualBoard, [ ])),
 AmountNew=len(getAllColor(Color,NewBoard2, [ ])),

  if
    AmountNew>=AmountOld ->
      NewBoard;
    true ->
      ActualBoard2
  end.

%nie korzystam z tego jednak bo robię to w procesach dla każdego punktu
%zwraca z listy Boardów tylko te, które nie dają straty liczby kamieni danego koloru w stosunku do ActualBoard
getProfitableBoards(Color,[ ],ActualBoard,Bufor) ->
  Bufor;

getProfitableBoards(Color,[H|T],ActualBoard2,Bufor) ->
  ActualBoard=checkChainsByColor(Color, ActualBoard2),
  H2=checkChainsByColor(Color, H),
  AmountOld= len(getAllColor(Color,ActualBoard, [ ])),
  AmountNew=len(getAllColor(Color,H2, [ ])),
  if
    AmountNew>=AmountOld ->
      getProfitableBoards(Color,T,ActualBoard,Bufor++[H2]);
    true ->
      getProfitableBoards(Color,T,ActualBoard,Bufor)
  end.

%liczy ile jest kamieni danego koloru

  countColor(Color,[board,[ ],Size],Bufor) ->
  Bufor;

 countColor(Color,[board,[{{X1,Y1},A}|T],Size],Bufor) ->
  if
    A==Color ->
      countColor(Color,[board,[T],Size],Bufor+1);
    true ->
    countColor(Color,[board,[T],Size],Bufor)
  end.