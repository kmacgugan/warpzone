-module(warp_zone_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    io:fwrite("Starting... ~n", []),
    Procs = [{wz_jsoninator,
          {wz_jsoninator, parse_json, ["/Users/kmacgugan/chef/warp_zone3/data/citylots.json"]},
          temporary, brutal_kill, worker, [wz_jsoninator]}],
    {ok, { {one_for_one, 1, 1}, [Procs]} }.
