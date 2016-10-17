-module(wz_jsoninator).

-export([read_file/1, parse_json/1]).

read_file(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    get_all_lines(Device, []).
 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line -> get_all_lines(Device, Accum ++ [Line])
    end.

parse_json(Filename) ->
    JsonFile = read_file(Filename),
    io:fwrite("Decoding JSON at ~p~n", [erlang:timestamp()]),
    Json = jiffy:decode(JsonFile),
    io:fwrite("Done with JSON at ~p~n", [erlang:timestamp()]),
    Json.

whitelist(Json, WhiteList) ->
    
