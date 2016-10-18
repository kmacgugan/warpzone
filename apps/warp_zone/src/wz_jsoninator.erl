-module(wz_jsoninator).

-export([read_file/1, parse_json/1, time_parse/1, whitelist/2]).

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
    Json = jiffy:decode(JsonFile),
    Json.

time_parse(Filename) ->
    {TimeMicroS, _Value} = timer:tc(fun() -> parse_json(Filename) end),
    TimeMs = TimeMicroS/1000,
    TimeMs.

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
