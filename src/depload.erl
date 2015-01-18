-module(depload).
-author('Justin Sheehy <justin@basho.com>').
-author('Andy Gross <andy@basho.com>').
-author('Benoit Chesneau <bchesneau@gmail.com>').

-export([ensure_all/1]).
-export([get_base_dir/0]).
-export([get_base_dir/1]).
-export([local_path/1]).
-export([local_path/2]).
-export([deps_on_path/0]).
-export([new_siblings/1]).
-export([start_app_deps/1]).
-export([ensure_started/1]).

%% @doc List of project dependencies on the path.
-spec deps_on_path() -> [ProjNameAndVers :: any()].
deps_on_path() ->
    ordsets:from_list([filename:basename(filename:dirname(X)) || X <- code:get_path()]).
    
%% @doc Find new siblings paths relative to Module that aren't already on the
%% code path.
-spec new_siblings(Module :: atom()) -> [Dir :: string()].
new_siblings(Module) ->
    Existing = deps_on_path(),
    SiblingEbin = [ X || X <- filelib:wildcard(local_path(["deps", "*", "ebin"], Module)),
                         filename:basename(filename:dirname(X)) /= %% don't include self
                             filename:basename(filename:dirname(
                                                 filename:dirname(
                                                   filename:dirname(X)))) ],
    Siblings = [filename:dirname(X) || X <- SiblingEbin,
                           ordsets:is_element(
                             filename:basename(filename:dirname(X)),
                             Existing) =:= false],
    lists:filter(fun filelib:is_dir/1,
                 lists:append([[filename:join([X, "ebin"]),
                                filename:join([X, "include"])] ||
                                  X <- Siblings])).
        

%% @doc Ensure that all ebin and include paths for dependencies
%% of the application for Module are on the code path.
-spec ensure_all(Module :: atom()) -> ok.
ensure_all(Module) ->
    code:add_paths(new_siblings(Module)),
    %% code:clash is annoying when you load couchbeam in a script.
    %% code:clash(),
    ok.

%% @doc Return the application directory for Module. It assumes Module is in
%% a standard OTP layout application in the ebin or src directory.
-spec get_base_dir(Module :: atom()) -> string().
get_base_dir(Module) ->
    {file, Here} = code:is_loaded(Module),
    filename:dirname(filename:dirname(Here)).

%% @doc Return the application directory for this application. Equivalent to
%% get_base_dir(?MODULE).
-spec get_base_dir() -> string().
get_base_dir() ->
    get_base_dir(?MODULE).

%% @doc Return an application-relative directory from Module's application.
-spec local_path([string()], Module :: atom()) -> string().
local_path(Components, Module) ->
    filename:join([get_base_dir(Module) | Components]).

%% @doc Return an application-relative directory for this application.
%% Equivalent to local_path(Components, ?MODULE).
-spec local_path(Components :: string()) -> string().
local_path(Components) ->
    local_path(Components, ?MODULE).

-spec start_app_deps(App :: atom()) -> ok.
start_app_deps(App) ->
    {ok, DepApps} = application:get_key(App, applications),
    [ensure_started(A) || A <- DepApps],
    ok.

%% @doc Start the named application if not already started.
-spec ensure_started(Application :: atom()) -> ok.
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.
