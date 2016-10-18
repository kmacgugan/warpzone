-module(wz_jsoninator_tests).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

jiffy_should_decode_node_converge_file_test() ->
    Value = wz_jsoninator_tests:timeParse("/Users/kmacgugan/chef/warp_zone3/data/run_converge_small.json"),
    timeWhitelist(Value, [["chef_server_fqdn"],
    [<<"expanded_run_list">>, <<"run_list">>],
    ["node", "normal", "omnibus"],
     ["resources"],
     ["node", "jenkins"]
     ]).

jiffy_should_decode_node_file_test() ->
    Value = wz_jsoninator_tests:timeParse("/Users/kmacgugan/chef/warp_zone3/data/small.json"),
    timeWhitelist(Value, [[<<"expanded_run_list">>, <<"run_list">>]]).





% jiffy_should_decode_large_files_test_() ->
%     {timeout, 36000, ?_assertEqual(100, wz_jsoninator:time_parse("/Users/kmacgugan/chef/warp_zone3/data/citylots.json"))}.

timeParse(Filename) ->
    F = fun() -> wz_jsoninator:parse_json(Filename) end,
    {TimeMicroS, Value} = timer:tc(F),
    TimeMs = TimeMicroS/1000,
    ?debugFmt( "Time to parse: ~p~n", [TimeMs]),
    Value.

timeWhitelist(Json, Whitelist) ->
    F = fun() -> wz_jsoninator:whitelist(Json, Whitelist) end,
    {TimeMicroS, Value} = timer:tc(F),
    TimeMs = TimeMicroS/1000,
    ?debugFmt( "Time to Whitelist: ~p~n", [TimeMs]),
    Value.
