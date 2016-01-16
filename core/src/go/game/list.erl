	%% author: Katarzyna Kosiak


  -module(list).
  -export([listContains/2,len/1,listHasSameItem/2,remove_dups/1,remove_dups_list/2,getLongestList/2]).
  -import(lists, [delete/2,map/2,foldl/3,foldr/3,seq/2, nth/2, filter/2, flatten/1]).



%dlugosc listy
len([]) -> 
0;
len([_|T]) -> 
1 + len(T).


%pobierz najdłuższą listę  z listy list
getLongestList([ ],Bufor)->
Bufor;


getLongestList([H|[ ]],Bufor)->
HLen=len(H),
BLen=len(Bufor),
if
  HLen>BLen ->
  H;
  true ->
  Bufor
end;

getLongestList([H|T],Bufor)->
HLen=len(H),
BLen=len(Bufor),
if
  HLen>BLen ->
  getLongestList(T,H);
  true ->
  getLongestList(T,Bufor)
end.


%sprawdzenie czy lista posiada dany element
listContains(_,[ ]) ->
false;
listContains(X,[H|T]) ->
if
  (X==H) ->
  true;
  true -> listContains(X,T)
end.   



%usun duplikaty z listy list
remove_dups_list([ ], Bufor) ->
Bufor;
remove_dups_list([H|T], Bufor) ->
Bufor2=Bufor ++  [remove_dups(H)],
remove_dups_list(T,Bufor2).

%usun duplikaty
remove_dups([])    -> [];
remove_dups([H|T]) -> [H | [X || X <- remove_dups(T), X /= H]].


%sprawdzenie czy dwie listy łączy jakiś element
%main:listHasSameItem([{1,3},{1,2},{2,3}],[{2,4},{1,2}]).
listHasSameItem([],_) ->
false;
listHasSameItem(_,[]) ->
false;
listHasSameItem({X1,Y1},{X2,Y2}) ->
if
  (X1==X2) and (Y1==Y2) ->
  true;
  true ->
  false
end;
listHasSameItem([H|T],X) ->
case listContains(H,X) of
  true ->
  true;
  false ->
  listHasSameItem(T,X)
end.