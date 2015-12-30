	-module(bs).
	-export([getTestBoard/0, getTestList/0, getTestNeighbourList/0, 

          init/1, boardPrint/2, compareBoards/2, generateFrame/1, listBoard/2,

          getAllColor/3, checkChainsByColor/2,  deleteChainsList/2,
          deleteChain/2, hasChainLiberties/2, getChains/2, getChainsRepeated/2, 
          listNeighbourLists/2, territorySizeOwner/5, listTerritoriesSizeOwner/3,
          getTerritories/1, countTerritories/2, whoWon/1,

          putStone/5, deleteStone/4, getColor/3,getNeighbours/5,getNeighboursByColor/6,
          putStoneChecked/4
          ]).
  -import(lists, [delete/2,map/2,foldl/3,foldr/3,seq/2, 
                  nth/2, filter/2, flatten/1]).
  -import(list, [listContains/2,len/1,listHasSameItem/2,
                  remove_dups/1,remove_dups_list/2]).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%plansza do testów
% main:boardPrint(main:getTestBoard(),0).
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

%przykladowa lista kamieni jednego koloru
%bs:boardPrint(bs:getTestBoard(),0).
getTestList() ->
  getAllColor(b,getTestBoard(),[ ]).
%przykladowa lista sasiedztwa
getTestNeighbourList() ->
  listNeighbourLists(getTestList(),[ ]).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOARD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%utworzenie pustej planszy
init(Y) -> 
  if
    Y>1 ->
       [board,[{{X,Z},o}||X<- seq(1,Y),Z<-seq(1,Y)],Y];
    true ->
      true
  end.


generateFrame(Size) ->
  case Size of
    5 ->
      io:format(" 1  2  3  4  5 ~n", []),
      io:format(" -- -- -- -- -- ~n", []);
    7 ->
      io:format(" 1  2  3  4  5  6  7 ~n", []),
      io:format(" -- -- -- -- -- -- -- ~n", []);
    9 ->
      io:format(" 1  2  3  4  5  6  7  8  9 ~n", []),
      io:format(" -- -- -- -- -- -- -- -- -- ~n", []);
    13 ->
      io:format(" 1  2  3  4  5  6  7  8  9  10 11 12 13 ~n", []),
      io:format(" -- -- -- -- -- -- -- -- -- -- -- -- -- ~n", []);
    19 ->
      io:format(" 1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 ~n", []),
      io:format(" -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ~n", []);
    _Else ->
      true
  end.


%Przykład: bs:boardPrint(bs:putStone(1,2,1,bs:init(3),[board,[ ],3]),0).
%Przykład to wyswietlenie planszy bo wlozeniu kamienia.
boardPrint([board,[{_,A}|[] ],S],_) ->  
if
    A==o ->
      io:format("    |~p ~n", [S]);
    true ->
       io:format(" ~p  |~p ~n", [A,S])
end;
boardPrint([board,[{_,A}|T],S],Y) ->
  if
       (Y == 0) ->
           generateFrame(S); 
       true ->
           true
  end,    
  Z=Y+1,
  if
    A==o ->
      io:format("   ", []);
    true ->
       io:format(" ~p ", [A])
  end,
   % io:format(" ~p ", [A]),
  if
      (Z rem S == 0 ) ->
          io:format(" |~p ~n", [trunc(Z/S)]);
       true ->
           true
  end,
  boardPrint([board,T,S],Z).

%przykład bs:compareBoards(bs:getTestBoard(),bs:init(5)).
%porównaj dwie plansze tego samego rozmiaru- jesli takie same to zwróć prawdę.
compareBoards([board,[ ],_],[board,[ ],_]) ->
  true;
compareBoards([board,[{_,A}|T],Size],[board,[{_,A2}|T2],Size]) ->
  if
    (A=:=A2) ->
      compareBoards([board,T,Size],[board,T2,Size]);
    true ->
      false
  end.


%policz wyniki i wyświetl kto wygrał. Białe dostają komi = 6.5
whoWon([board,[{{X1,Y1},A}|T],Size]) ->
  {Black,White} = countTerritories(listTerritoriesSizeOwner(getTerritories([board,[{{X1,Y1},A}|T],Size]),[board,[{{X1,Y1},A}|T],Size],[ ]),{0,0}),
  BlackScore = len(getAllColor(b,[board,[{{X1,Y1},A}|T],Size],[ ])) + Black,
  WhiteScore = 6 + len(getAllColor(w,[board,[{{X1,Y1},A}|T],Size],[ ])) + White,
  if
    BlackScore> WhiteScore ->
      black;
    BlackScore< WhiteScore ->
      white;
    BlackScore== WhiteScore ->
      tie
  end.

%policz wynik i zwróć krotkę {punkty czarne, punkty białe}
countTerritories([ ],{Black,White}) ->
  {Black,White};
countTerritories([{A,O}|T],{Black,White}) ->
  case O of
    o ->
      Bufor = {Black,White};
    b ->
      Bufor = {Black + A, White};
    w ->
      Bufor = {Black,White + A}
  end,
  countTerritories(T,Bufor).



%zamien Boarda na prostą listę zawierającą informacje o b/w/o
% bs:listBoard(bs:getTestBoard(),[ ]).
listBoard([board,[{_,H}],_],Bufor) ->
  Bufor ++ [H];

listBoard([board,[{_,H}|T],Y],Bufor) ->
  Bufor2=Bufor ++ [H],
  listBoard([board,T,Y],Bufor2).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%pobierz wspolrzędne wszystkich punktów na których jest kamien o kolorze Color
getAllColor(_,[board,[ ],_], Bufor) ->
  Bufor;
getAllColor(Color,[board,[{{X1,Y1},A}|T],Size],Bufor) ->
  if
    (A==Color) -> 
      Bufor2 = Bufor ++ [{X1,Y1}];
    true ->
      Bufor2 = Bufor
  end,
  getAllColor(Color,[board,T,Size],Bufor2).


% bs:boardPrint(bs:checkChainsByColor(w,bs:getTestBoard()),0).
%sprawdzenie chainów  z podanego boarda danego koloru i usunięcie tych, które nie mają liberties
checkChainsByColor(Color, [board,[{{X1,Y1},A}|T],Size]) ->
  List = getChains(getChainsRepeated(listNeighbourLists(getAllColor(Color,[board,[{{X1,Y1},A}|T],Size],[ ]),[ ]),[ ]),[ ]),
  Z = (filter(fun(X) -> not(hasChainLiberties (X,[board,[{{X1,Y1},A}|T],Size])) end, List)),
  deleteChainsList(Z,[board,[{{X1,Y1},A}|T],Size]).

%usun wszystkie lancuchy z listy
deleteChainsList([ ],Bufor) ->
  Bufor;
deleteChainsList([H|T1],[board,[{{X1,Y1},A}|T],Size]) ->
  Bufor = deleteChain(H,[board,[{{X1,Y1},A}|T],Size]),
  deleteChainsList(T1,Bufor). 

%usuń cały łańcuch.
deleteChain([ ],Bufor) ->
  Bufor;
deleteChain([{X,Y}|T1],[board,[{{X1,Y1},A}|T],Size]) ->
  Bufor = deleteStone(X,Y,[board,[{{X1,Y1},A}|T],Size],[board,[ ],Size]),
  deleteChain(T1,Bufor).


% sprawdzanie, czy łancuch ma liberties
hasChainLiberties([ ],_) -> 
  false;
hasChainLiberties([{X,Y}|T1],[board,[{{X1,Y1},A}|T],Size]) ->
  case len(getNeighboursByColor(o,X,Y,[board,[{{X1,Y1},A}|T],Size],[ ],0)) of
    0 ->
       hasChainLiberties(T1,[board,[{{X1,Y1},A}|T],Size]);
    _ -> true
  end.

%pobierz wszystkie łańcuchy terytoriów, podaj ich listę {ilosc,wlasciciel}
% przyklad bs:listTerritoriesSizeOwner(bs:getTerritories(bs:getTestBoard()),bs:getTestBoard(),[ ]).
listTerritoriesSizeOwner([ ],_,Bufor) ->
  Bufor;
listTerritoriesSizeOwner([H|T1],[board,[{{X1,Y1},A}|T],Size],Bufor) ->
  Bufor2 = Bufor ++ [territorySizeOwner(H,[board,[{{X1,Y1},A}|T],Size],0,0,0)],
  listTerritoriesSizeOwner(T1,[board,[{{X1,Y1},A}|T],Size],Bufor2). 

  %foldl(fun(X,Final)-> territorySizeOwner(X,[board,[{{X1,Y1},A}|T],Size],0,0,0)  end, [ ], Listofterritories).





%lista wszystkich territories
getTerritories([board,[{{X1,Y1},A}|T],Size]) ->
  getChains(getChainsRepeated(listNeighbourLists(getAllColor(o,[board,[{{X1,Y1},A}|T],Size],[ ]),[ ]),[ ]),[ ]).

%przykład  bs:territorySizeOwner([{2,5},{1,5}],bs:getTestBoard(),0,0,0).
% sprawdzanie, czy łańcuch pustych pól jest otoczony przez jakiś kolor
%zwraca {ilepól,czyje}, jeżeli niczyje to zwraca {ilepól,o}.
%zadaj łańcuch pustych pól, planszę i parametry:
%Amount = 0, White = 0, Black = 0 na starcie
territorySizeOwner([ ],_,White,Black,D) -> 
  if
    (White>0) and (Black>0) ->
      {D,o};
    (White==0) and (Black==0) ->
      {D,o};
    (White==0) and (Black>0) ->
      {D,b};
    (Black==0) and (White>0) ->  
      {D,w}
  end;

%  list:len(bs:getNeighboursByColor(b,1,2,bs:getTestBoard(),[ ],0)).
territorySizeOwner([{X,Y}|T1],[board,[{{X1,Y1},A}|T],Size],White,Black,Amount) ->
  B = Black + len(getNeighboursByColor(b,X,Y,[board,[{{X1,Y1},A}|T],Size],[ ],0)),
  W = White + len(getNeighboursByColor(w,X,Y,[board,[{{X1,Y1},A}|T],Size],[ ],0)),
  D = Amount + 1,
  territorySizeOwner(T1,[board,[{{X1,Y1},A}|T],Size],W,B,D).


%bs:getChains(bs:getChainsRepeated(bs:listNeighbourLists(bs:getAllColor(b,bs:getTestBoard(),[ ]),[ ]),[ ]),[ ]).
%wyczysc liste z getChainsRepeated na postawie listy z Repeated. Bufor [].
getChains([ ], Bufor) ->
  Bufor;
getChains([H|T], Bufor) ->
  Z = (filter(fun(X) -> not(listHasSameItem (X,H)) end, T)),
  Bufor2 = Bufor ++ [H],  
  getChains(Z,Bufor2).

%main:getChainsRepeated(main:listNeighbourLists(main:getAllColor(b,main:getTestBoard(),[ ]),[ ]),[ ]).
%wygeneruj liste łańcuchów na podstawie listy sasiadow listNeighbourLists.
%usun duplikaty W listach
%pomocnicza. Bufor [].
getChainsRepeated([ ],Bufor) ->
  Bufor;
getChainsRepeated([H|T],Bufor) ->
  Z = [flatten(filter(fun(X) -> listHasSameItem (X,H) end, T) ++ H)],
  Z2 = remove_dups_list(Z,[ ]),
  Bufor2 = Bufor ++ Z2,
  getChainsRepeated(T,Bufor2).


%generuj listę "sąsiadów i siebie" dla każdego punktu z zadanej listy.
%main:listNeighbourLists([{1,2},{2,2},{1,4}],[ ]).
%używać z getAllColor!
listNeighbourLists([],Bufor) ->
  Bufor;
listNeighbourLists([{X,Y}|T],Bufor) ->
  Z = getNeighbours(X,Y,T,[ ],0),
  W = Z ++ [{X,Y}],
  Bufor2=Bufor ++ [W],
  listNeighbourLists(T,Bufor2).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POINT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% zwraca to samo co dostało jeśli ruch niedozwolony (lista dwóch plansz - poprzedniej i przedpoprzedniej,
%% jeżeli dozwolony zwraca nowego Boarda i poprzedniego
% przykład  bs:putStoneChecked(b,1,1,[bs:init(19),bs:getTestBoard()]).
%sprawdza: czy cos tam juz nie stoi, czy otoczenie nie jest wrogie, czy indeks jest ok,czy ruch się nie powtarza
putStoneChecked(Color,X,Y,[[board,[{{X1,Y1},A}|T],Size], SecondBoard]) ->
  LenMy=len(getNeighboursByColor(Color,X,Y,[board,[{{X1,Y1},A}|T],Size],[ ],0)),
  LenB = len(getNeighboursByColor(b,X,Y,[board,[{{X1,Y1},A}|T],Size],[ ],0)),
  LenW= len(getNeighboursByColor(w,X,Y,[board,[{{X1,Y1},A}|T],Size],[ ],0)),
  if
      (LenMy==0) and ((LenB==4)or (LenW==4)) ->
        [[board,[{{X1,Y1},A}|T],Size] , SecondBoard];
      (A=/=o) ->
        [[board,[{{X1,Y1},A}|T],Size] , SecondBoard];
      (X<1) or (Y<1) ->
        [[board,[{{X1,Y1},A}|T],Size] , SecondBoard];
      true ->
         [ putStone(Color,X,Y,[board,[{{X1,Y1},A}|T],Size],[board,[ ],Size]) , [board,[{{X1,Y1},A}|T],Size] ]
  end,
  case (putStone(Color,X,Y,[board,[{{X1,Y1},A}|T],Size],[board,[ ],Size])) of
      SecondBoard->
        [[board,[{{X1,Y1},A}|T],Size] , SecondBoard];
      _Else ->
        [ putStone(Color,X,Y,[board,[{{X1,Y1},A}|T],Size],[board,[ ],Size]) , [board,[{{X1,Y1},A}|T],Size] ]
  end.

%wstaw kamien o danym kolorze w dane pole danej planszy 
%zwroc nowa, zmieniona plansze
% Przykład użycia: main:putStone(1,2,1,main:init(3),[board,[ ],3]).
putStone(_,_,_,[board,[ ],_],Bufor) -> 
    Bufor;
putStone(Color,X,Y,[board,[{{X1,Y1},A}|T],Size],[board,E,Size]) ->
  if 
      (X==X1) and (Y==Y1) ->
          Bufor = [board,E++[{{X,Y},Color}],Size];
      true -> 
          Bufor = [board,E++[{{X1,Y1},A}],Size]
  end,
  putStone(Color,X,Y,[board,T,Size],Bufor).

%usun kamien z danego miejsa danej planszy
%Przykład main:boardPrint(main:deleteStone(5,1,main:putStone(c,5,1,main:init(9),[board,[ ],9]),[board,[ ],9]),0).
%Przykład to usuniecie kamienia z miejsa na które go postawilismy przed chwila
deleteStone(_,_,[board,[ ],_],Bufor) -> 
    Bufor;
deleteStone(X,Y,[board,[{{X1,Y1},A}|T],Size],[board,E,Size]) ->
  if 
      (X==X1) and (Y==Y1) ->
        Bufor = [board,E++[{{X,Y},o}],Size];
      true -> 
        Bufor = [board,E++[{{X1,Y1},A}],Size]
   end,
  deleteStone(X,Y,[board,T,Size],Bufor).

%Sprawdzenie pola - zwraca Kolor
getColor(X,Y,[board,[],_]) ->
   io:format("Nie istnieje pole ~p,~p ~n",[X,Y]);

getColor(X,Y,[board,[{{X1,Y1},A}|T],Size]) ->
   if 
      (X==X1) and (Y==Y1) ->
        Kolor = A;
      true -> 
        getColor(X,Y,[board,T,Size])        
    end. 


% list:len(bs:getNeighboursByColor(o,1,4,bs:getTestBoard(),[ ],0)).
%pobranie listy współrzędnych sasiadów z góry, dołu i boków o danym kolorze
%main:getNeighbours(b,3,3,main:getTestBoard(),[ ],0).
%(bs:getNeighboursByColor(o,1,4,bs:getTestBoard(),[ ],0)).

getNeighboursByColor(_,_,_,[board,[ ],_],Bufor,_) ->
  Bufor;
getNeighboursByColor(Color,X,Y,[board,[{{X1,Y1},A}|T],Size],Bufor,Counter) ->
  if
    (Counter < 4) ->
      if
        (Color == A) and ((abs(X-X1)+abs(Y-Y1))==1) ->
          Counter2 = Counter +1,
          Bufor2 = Bufor ++ [{X1,Y1}];
       true ->
          Bufor2=Bufor,
          Counter2 = Counter
      end,
      getNeighboursByColor(Color,X,Y,[board,T,Size],Bufor2,Counter2);
    true ->
      Bufor
  end.
 

%% pobierz sasiadów z listy. Bufor [ ] na start. Counter na 0.
getNeighbours(_,_,[ ],Bufor,_) ->
  Bufor;
getNeighbours(X,Y,[{X1,Y1}|T],Bufor,Counter) ->
  if
    (Counter < 4) ->
      if
        ((abs(X-X1)+abs(Y-Y1))==1) ->
          Counter2 = Counter +1,
          Bufor2 = Bufor ++ [{X1,Y1}];
       true ->
          Bufor2=Bufor,
          Counter2 = Counter
      end,
      getNeighbours(X,Y,T,Bufor2,Counter2);
    true ->
      Bufor
  end.