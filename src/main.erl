%%%-------------------------------------------------------------------
%%% @author anders
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Dec 2015 18:03
%%%-------------------------------------------------------------------
-module(main).
-author("anders").

%% API
-export([main/0,run/0]).
-import( map, [new/4,get_width/1,get_height/1,set/4,get/3,get_xmin/1,get_xmax/1,get_ymin/1,get_ymax/1]).
-import( ant, [newAnt/3,update/1,setXDir/2,setYDir/2]).

main() ->
  %% Node = node("clientNode"),
  io:format("Started erlang prog \n"),
  receive doNothing ->
    ok
  end.



%Start the function
run()->
  run(10).
run(N)->
  WaintTime = 10000,
  io:format("Run has started \n"),
  receive {masterPid,MasterPid} ->
    io:format("Recived ~p \n", [MasterPid])
  after WaintTime ->
    MasterPid = self()
  end,



  receive {nrAnts,NrAnts} ->
    io:format("Recived NrAnts ~p \n", [NrAnts])
  after WaintTime ->
    NrAnts = 10.0
  end,


  receive {worldMax,WorldMax} ->
    io:format("Recived WorldMax ~p  \n", [WorldMax])
  after WaintTime ->
    WorldMax = 10.0
  end,




  %Init world

  Map =map:new(-WorldMax,WorldMax,-WorldMax,WorldMax),
  StartX = 0.0,
  StartY = 0.0,
  Self = self(),
  NrActors = NrAnts / N,

  io:format("Number of actors is ~p  \n", [NrActors]),
  Pids = [spawn_link(fun () -> ants(Self,N,StartX,StartY,Map,MasterPid) end) || _ <- lists:duplicate(trunc(NrActors),1)],

  run(Pids,Map,now(),MasterPid).
run(Pids,Map,OldTime,MasterPid) ->
  NewTime = now(),
  TimeDif = timer:now_diff(NewTime,OldTime)/1000000,
  if(TimeDif < 1/60)->
    FinalTime = OldTime;
    true ->
      FinalTime = NewTime,
      io:format("FPS ~p \n", [1/TimeDif]),



      %update all ants
      Refs = [send_message(Pid,TimeDif) || Pid <- Pids],
      lists:foreach(
        fun (Ref) ->
          receive Ref ->
            ok
          end
        end
        ,Refs)
  end,
  run(Pids,Map,FinalTime,MasterPid).

%Send a maesge to a Ant
send_message(Pid,TimeDif)->
  Ref =  make_ref(),
  Pid ! {Ref,TimeDif},
  Ref.


%Attns
ants(Pid,N,X,Y,Map,JavaPid)->
  Ants =  [ {X,Y} || _ <- lists:duplicate(N,1)],
  AntsInfo =  [ ant:newAnt(rand:uniform()*2 -1,rand:uniform()*2 -1,1) || _ <- lists:duplicate(N,1)],
  ants(Pid,Ants,AntsInfo,Map,JavaPid).
ants(Pid,Ants,AntsInfos,Map,JavaPid)->

  receive {Ref,Time} ->
    NewAnts = [newPath(X,Y,AntsInfo,Map,Time) || {X,Y} <- Ants, AntsInfo <- AntsInfos],
    JavaPid ! NewAnts,
    Pid ! Ref
  after 10000 ->
    NewAnts = null,
    throw("out of time ")
  end,
  ants(Pid,NewAnts,AntsInfos,Map,JavaPid).




