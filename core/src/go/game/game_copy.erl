-module(game).

-export([ start/0, moveComp/2, move/4]).

-import(bs,[

          init/1, boardPrint/2, compareBoards/2,

          getAllColor/3, checkChainsByColor/2, whoWon/1, putStoneChecked/4
          ]).
-import(list,[len/1]).

%
start() ->
	%{ok, [X]} = io:fread("Witaj w grze Go! Wybierz swój kolor (b-czarne, w-białe): ", "~d").
	%PColor = io:get_line("Welcome! This is GO! Choose your color(b - black, w - white): "),
  {ok,Size} = io:read("Welcome! This is GO! Choose board size(5,7,9,13 or 19): "),
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
  {ok,PColor} = io:read("Choose your color(b - black, w - white): "),
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
      io:fwrite("Opponent moved.~n", []),
      %nowa plansza zwrocona przez moveComp!!! albo ta sama jeśli spasował!!!
      [NewBoard,ActualBoard] = moveComp(Color,[ActualBoard, SecondBoard]),
      %sprawdzanie czy komputer spasował
      Same=compareBoards(NewBoard,ActualBoard),
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
      {ok,Pass22} = io:read("Do you want to pass?(y - yes, n - no): "),
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
          {ok,Y} = io:read("X(horizontal): "),
          {ok,X} = io:read("Y: "),
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
      [{X,Y}|_]=getAllColor(o,ActualBoard,[ ]),
      putStoneChecked(Color,X,Y,[ActualBoard, SecondBoard]).
