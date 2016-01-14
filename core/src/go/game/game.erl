-module(game).

-export([ start/0, s/0, moveComp/2, move/4, getJavaInfo/1]).

-import(communication,[info/1,getTestBoard/0,listBoard/2,  boardState/1]).
-import(bs,[

          init/1, boardPrint/2, compareBoards/2, getLongestChain/2,getChainLiberties/3,getAliveChains/3,
          getAlmostDeadChain/2,
          getAllColor/3, checkChainsByColor/2, whoWon/1, putStoneChecked/4,getChainLiberties/3,putStone/5
          ]).
-import(list,[len/1]).
-import(ai,[getPossibleBoards/4,countColor/3]).

%prawdziwy start (jednorazowa rejestracja commmunication)
s() ->
  register(boardstate,spawn(communication,boardState,[ ])),
  start().

start() ->
  %io:format("Hullo~n",[]),
	%{ok, [X]} = io:fread("Witaj w grze Go! Wybierz swój kolor (b-czarne, w-białe): ", "~d").
	%PColor = io:get_line("Welcome! This is GO! Choose your color(b - black, w - white): "),
  %{ok,Size} = io:read("Welcome! This is GO! Choose board size(5,7,9,13 or 19): "),
  getJavaInfo(self()),
  receive
    {Size,PColor2} ->
      true
  end,
  case Size of
    5 ->
      true;
    7 ->
     true;
    9 ->
     true;
    13 ->
      true;
    19 ->
      true;
    _Else ->
      io:fwrite("Wrong board size, try again!~n", []),
      start()
  end,
  %{ok,PColor} = io:read("Choose your color(b - black, w - white): "),
  if 
    PColor2==0 ->
      PColor=w;
    PColor2==1 ->
      PColor=b
  end,

  if
    (PColor==b) ->
      io:fwrite("Good for you, the first move is yours!~n", []),
      %tutaj rozpoczecie gry od ruchu gracza
      %metoda wyswietlajaca aktualnego Boarda, potem prompt o X i Y, potem przejscie do kolejnego ruchu.
      move(human,b,[init(Size),init(Size)],0);

    (PColor==w) ->
      io:fwrite("Good for you, you're moving second, so the 6.5 points komi is yours!~n", []),
      % tutaj rozpoczecie gry od ruchu komputera
      move(computer,b,[init(Size),init(Size)],0);
    true ->
      io:fwrite("It seems you can't even properly choose a color!~n", [])
  end. 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MOVES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%zaawansowana obsługa ruchu - io, sprawdzanie pasowania, zakończenie i wynik gry,
% sprawdzanie poprawności ruchu, czyszczenie zabitych kamieni
move(Player,Color,[ActualBoard2, SecondBoard],Pass) ->
  %czyszczenie planszy po poprzednim ruchu
  case Color of
    b ->
      ActualBoard= checkChainsByColor(w, ActualBoard2);
    w ->
      ActualBoard= checkChainsByColor(b, ActualBoard2)
  end,
  sendBoard(ActualBoard), 
  %sprawdzanie czy oboje nie spasowali
  if
    Pass==2 ->
      %wyjscie z gry 
       Black1 = len(getAllColor(b,ActualBoard, [ ])),
          White1 = len(getAllColor(w,ActualBoard, [ ])),
          if
            Black1 ==0 ->
              io:fwrite("The winner is: White ~n", [ ]);
            White1==0 -> % jak nie ma białych to uznajemy że czarne wygrały (mimo komi)
              io:fwrite("The winner is: Black ~n", [ ]);
            true ->
              io:fwrite("The winner is: ~p ~n", [whoWon(ActualBoard)])
          end;
    true->
      true
  end,
  %Obsługa ruchu
  io:fwrite("Actual board:~n", []),
  boardPrint(ActualBoard,0),
  if
    Player==computer ->
      %nowa plansza zwrocona przez moveComp!!! albo ta sama jeśli spasował!!!
      [NewBoard,ActualBoard] = moveComp(Color,[ActualBoard, SecondBoard]),
      %sprawdzanie czy komputer spasował
      Same=compareBoards(NewBoard,ActualBoard),
      io:fwrite("Opponent moved.~n", []),
      if
        Same==true ->
          Pass2=Pass+1;
        true ->
          Pass2 = 0
      end,
      %kolejny ruch - czlowiek
      if
        Color ==b->
          move(human,w,[NewBoard,ActualBoard],Pass2); 
        Color==w ->
          move(human,b,[NewBoard,ActualBoard],Pass2) 
      end;
    Player==human ->
      getJavaInfo(self()),
      receive
        {Pass22,Y,X} ->
          true
      end,
      %{ok,Pass22} = io:read("Do you want to pass?(y - yes, n - no): "),
      if
        Pass22==q ->
          Black = len(getAllColor(b,ActualBoard, [ ])),
          White = len(getAllColor(w,ActualBoard, [ ])),
          if
            Black ==0 ->
              io:fwrite("The winner is: White ~n", [ ]);
            White==0 -> % jak nie ma białych to uznajemy że czarne wygrały (mimo komi)
              io:fwrite("The winner is: Black ~n", [ ]);
            true ->
              io:fwrite("The winner is: ~p ~n", [whoWon(ActualBoard)])
          end;
        Pass22==y ->
          %przekazanie ruchu komputerowi
            io:fwrite("You passed. ~n", []),
           if
            Color ==b->
              move(computer,w,[ActualBoard, SecondBoard],Pass+1); 
            Color==w ->
              move(computer,b,[ActualBoard, SecondBoard],Pass+1) 
           end;
        Pass22==n ->
          io:fwrite("Make a move. ~n", []),
          %odwrocone podpisy i zmienne bo odwrotnie jest ruch zaimplementowany 
          %{ok,Y} = io:read("X(horizontal): "),
          %{ok,X} = io:read("Y: "),
          [NewBoard,OldBoard]=putStoneChecked(Color,X,Y,[ActualBoard, SecondBoard]),
           % sprwadź czy coś w ogóle się zmieniło
          case compareBoards(NewBoard,OldBoard) of
            %jak nie OK to jeszcze raz
            true ->
              io:fwrite("That move was illegal. Try again. ~n", []),
              move(Player,Color,[ActualBoard, SecondBoard],Pass);
              %ruch komputera jeżeli było OK
            false ->
              if
                Color ==b->
                  move(computer,w,[NewBoard,OldBoard],0); 
                Color==w ->
                  move(computer,b,[NewBoard,OldBoard],0) 
              end
          end;
          true ->
            io:fwrite("That expression was illegal. Try again. ~n", []),
              move(Player,Color,[ActualBoard, SecondBoard],Pass)
      end

  end.


  %ruch komputera
  %TODO pasowanie i wyswietlanie o informacji że pasował
  %TODO jakaś inteligencja
  %TODO TODO TODO
  moveComp(Color,[ActualBoard, SecondBoard])->
      [board,_,Size]=ActualBoard,
      %wszystkie wolne miejsca
      %AllColorLen=len(getAllColor(Color,ActualBoard,[ ])),
      AllColorLen=len(getAllColor(b,ActualBoard,[ ]))+len(getAllColor(w,ActualBoard,[ ])),
      if
        %opening strategy
        AllColorLen<16 ->
            AllColor2=getAllColor(o,[board,
                                           [{{2,2},bs:getColor(2,2,ActualBoard)},
                                            {{3,2},bs:getColor(3,2,ActualBoard)},
                                            {{4,2},bs:getColor(4,2,ActualBoard)},
                                            {{3,3},bs:getColor(3,3,ActualBoard)},

                                            {{2,Size-1},bs:getColor(2,Size-1,ActualBoard)},
                                            {{3,Size-1},bs:getColor(3,Size-1,ActualBoard)},
                                            {{3,Size-2},bs:getColor(3,Size-2,ActualBoard)},
                                            {{4,Size-1},bs:getColor(4,Size-1,ActualBoard)},

                                            {{Size-1,2},bs:getColor(Size-1,2,ActualBoard)},
                                            {{Size-2,2},bs:getColor(Size-2,2,ActualBoard)},
                                            {{Size-2,3},bs:getColor(Size-2,3,ActualBoard)},
                                            {{Size-3,2},bs:getColor(Size-3,2,ActualBoard)},
                                            
                                           {{Size-1,Size-1},bs:getColor(Size-1,Size-1,ActualBoard)},
                                            {{Size-2,Size-1},bs:getColor(Size-2,Size-1,ActualBoard)},
                                            {{Size-2,Size-2},bs:getColor(Size-2,Size-2,ActualBoard)},
                                            {{Size-3,Size-1},bs:getColor(Size-3,Size-1,ActualBoard)}],Size],[ ]),
            AllColor2Len=len(AllColor2),
            if
            AllColor2Len==0 ->
              AllColor=getAllColor(o,ActualBoard,[ ]);
              true->
                AllColor=AllColor2
            end;


          %middle strategy
        ((AllColorLen>15) and (AllColorLen<Size*4))  ->
            Chain=getLongestChain(Color,ActualBoard),
            AllColor=getChainLiberties(Chain,ActualBoard,[ ]);


          %ending strategy - aggressive
        AllColorLen>Size*4-1 ->
            %pobierz Chain wroga, który ma najmniej liberties
            if
              Color==b ->
                Chain=getAlmostDeadChain(w,ActualBoard);
              Color==w ->
                Chain=getAlmostDeadChain(b,ActualBoard)
            end,
           %AllColor to liberties tego Chaina
            AllColor=getChainLiberties(Chain,ActualBoard,[ ]);

        true->
            AllColor=getAllColor(o,ActualBoard,[ ])
      end,

       %zebranie Boardów dla każdego z ruchów
       PossibleBoards=getPossibleBoards(Color,AllColor,ActualBoard,self()),
       PossibleLen=len(PossibleBoards),
       LenC=len(AllColor),
       %jeżeli nie zrobił żadnego ruchu (bo się nie opłacało) to znaczy to pas
       if
          LenC==1->
              %ewentualność gdy ai nie chce zabić wroga
              [{X11,Y11}]=AllColor,
               [putStone(Color,X11,Y11,ActualBoard,[board,[ ],Size]),ActualBoard];

          PossibleLen==0 ->
              [ActualBoard, ActualBoard];

          true ->
             [Haaa|_] = PossibleBoards,
             [Haaa,ActualBoard]
       end.


%COMMUNICATION JAVA-ERLANG

getJavaInfo(Pid) ->
        register(info,spawn(communication,info,[Pid])).


sendBoard(SomeBoard) ->
        boardstate! SomeBoard.

