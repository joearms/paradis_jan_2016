-module(e1).

-compile(export_all).

%% integers 123,45,56

test_fac() ->
    24 = fac(4),
    horray.

tests() ->
    1000 = fac(1000) div fac(999),
    20 = demo1(),
    20 = double(10),
    36 = area({square,6}),
    60 = perimeter({rectangle,10,20}),
    200 = area1({rectangle,10,20}),
    Pid1 = spawn(fun() -> area_actor() end),
    Pid1 ! {rectangle, 10, 20},
    Pid2 = spawn(fun() -> area_server() end),
    200 = rpc(Pid2, {rectangle,10,20}),
    Pid3 = spawn(fun() -> universal() end),
    Cubed = fun(X) -> X*X*X end,
    Pid3 ! {become, Cubed},
    8 = rpc(Pid3, 2),
    K1 = sum_squares_fast(1000),
    K1 = sum_squares_slow(1000),
    yes_we_can.

%% Funs
demo1() ->
    Double = fun(X) -> 2*X end,
    Double(10).

%% funs
demo2() -> double(10).

double(X) -> 2*X.


%% patterns

fac(0) -> 1;
fac(N) -> N*fac(N-1).    

area({square,X}) -> X*X;
area({rectangle,X,Y}) -> X*Y.

perimeter({square,X}) ->  4*X;
perimeter({rectangle,X,Y}) -> 2*(X+Y).

area1(Arg) ->
    case Arg of
	{square, X} ->
	    X*X;
	{rectangle, X, Y} ->
	    X*Y
    end.

%% processes

area_actor() ->
    receive
	{square, X} ->
	    print(X*X);
	{rectangle, X, Y} ->
	    print(X*Y)
    end,
    area_actor().

print(X) ->
    io:format("~p~n",[X]).

area_server() ->
    receive
	{From, {square, X}} ->
	    From ! X*X;
	{From, {rectangle, X, Y}} ->
	    From ! X*Y
    end,
    area_server().
    
rpc(Pid, Msg) ->	
    Pid ! {self(), Msg},
    receive
	Any ->
	    Any
    end.

universal() ->	
    receive
	{become, F} ->
	    universal(F)
    end.

universal(F) ->
    receive
	{From, X} ->
	    From ! F(X),
	    universal(F)
    end.

for(Max,Max,F) -> [F(Max)];
for(I, Max, F) -> [F(I)|for(I+1,Max,F)].

squares(Max) ->
    Square = fun(X) -> X*X end,
    Pids = for(1,Max,fun(_) ->
			     Pid = spawn(fun() -> universal() end),
			     Pid ! {become,Square},
			     Pid
		   end),
    L = doit(1, Max, Pids),
    [exit(Pid,kill) || Pid <- Pids],
    L.

doit(Max,Max, [H|_]) ->
    [rpc(H,Max)];
doit(I,Max,[H|T]) ->
    [rpc(H,I)|doit(I+1,Max,T)].
			       
sum_squares_slow(N) ->
    lists:sum(squares(N)).

sum_squares_fast(N) ->
    N*(N+1)*(2*N+1) div 6.

		     

