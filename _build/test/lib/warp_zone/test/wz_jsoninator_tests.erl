-module(wz_jsoninator_tests).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

jiffy_should_decode_node_file_test() ->
    {TimeMicroS, _Value} = timer:tc(wz_jsoninator, parse_json,  ["/Users/kmacgugan/chef/warp_zone3/data/small.json"]),
    TimeMs = TimeMicroS/1000,
    io:fwrite("Time to parse: ~p~n", [TimeMs]),
    ?assertEqual(TimeMs, 100).

jiffy_should_decode_node_converge_file_test() ->
    {TimeMicroS, _Value} = timer:tc(wz_jsoninator, parse_json,  ["/Users/kmacgugan/chef/warp_zone3/data/run_converge_small.json"]),
    TimeMs = TimeMicroS/1000,
    io:fwrite("Time to parse: ~p~n", [TimeMs]),
    ?assertEqual(TimeMs, 100).

jiffy_should_decode_large_files_test() ->
    {timeout, 3600, ?_assertEqual(timer:tc(wz_jsoninator, parse_json, ["/Users/kmacgugan/chef/warp_zone3/data/citylots.json"]), 100)}.
