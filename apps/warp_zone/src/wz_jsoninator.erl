-module(wz_jsoninator).

-export([read_file/1, parse_json/1, parse_mochijson/1, whitelist/2]).

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
    jiffy:decode(JsonFile).

parse_mochijson(Filename) ->
    JsonFile = read_file(Filename),
    mochijson2:decode(JsonFile).

% -type ej_path_element() :: atom() | binary() | string().
% -type ej_path() :: list(ej_path_element()) | tuple(ej_path_element()).
% -spec whitelist(string(), list(ej_path())) -> ejson().
whitelist(Json, Whitelist) ->
    whitelist(Json, Whitelist, {[]}).

% -spec whitelist(string(), list(ej_path()), list(ejson())) -> ejson().
whitelist(Json, [ FirstKey | Whitelist], Acc) ->
    % io:format(user, "Key: ~p", [FirstKey]),
    % io:format(user, " Value is: ~p~n", [ej:get(FirstKey, Json)]),
    whitelist(Json, Whitelist, ej:set_p(FirstKey, Acc, ej:get(FirstKey, Json)));
whitelist(_Json, [], Acc) ->
    Acc.
