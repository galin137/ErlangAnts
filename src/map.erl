%%%-------------------------------------------------------------------
%%% @author anders
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Dec 2015 18:11
%%%-------------------------------------------------------------------
-module(map).
-author("anders").
-import(array2d, [create/2, get/4, set/5 ]).
%% API
-export([new/4,get_height/1,get_width/1,set/3,get/3,get_xmin/1,get_xmax/1,get_ymin/1,get_ymax/1]).
-record(map,{array2d,xmin,xmax,ymin,ymax,width,height}).

%%-define (Map,#map).

new(Xmin, Xmax,Ymin,Ymax) ->
 % #map{array2d = array2d:create(round(-Xmin+Xmax),round(-Ymin+Ymax)),
  %  width=round(-Xmin+Xmax),height=round(-Ymin+Ymax),
   % xmin = Xmin, xmax =  Xmax, ymin = Ymin, ymax = Ymax}.
   #map{
    width=round(-Xmin+Xmax),height=round(-Ymin+Ymax),
   xmin = Xmin, xmax =  Xmax, ymin = Ymin, ymax = Ymax}.


set(Map,X,Y) ->
  NewX = X - Map#map.xmin,
  NewY = Y - Map#map.ymin,
  array2d:set(Map#map.array2d,NewX,NewY,1,Map#map.height).

get(Map,X,Y) ->
  NewX = X - Map#map.xmin,
  NewY = Y - Map#map.ymin,
  array2d:get(Map#map.array2d,NewX,NewY,Map#map.height).

get_height (Map)->
  Map#map.height.

get_width(Map)->
  Map#map.width.

get_xmin(Map)->
  Map#map.xmin.

get_xmax(Map)->
  Map#map.xmax.

get_ymin(Map)->
  Map#map.ymin.

get_ymax(Map)->
  Map#map.ymax.

