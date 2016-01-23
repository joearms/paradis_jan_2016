-module(hofs).
-compile(export_all).


test() ->
    Even  = fun(X) -> (X rem 2) == 0 end,
    true  = Even(2),
    false = Even(3),
    [2,4,6,8,10,12,14,16,18,20] = test1(),
    [11,12,13,14,15,16,17,18,19,20] = test2(),
    [11,12,13,14,15,16,17,18,19,20] = test3(),
    Func = test4(),
    20 = Func(10),
    30 = test5(),
    [2,4,6,8] = map(fun(X) -> 2* X end, [1,2,3,4]),
    {[2,4],[1,3,5]} = partition(Even, [1,2,3,4,5]),
    10 = foldl(fun(I,A) -> I+A end, 0, [1,2,3,4]),
    [1,2,1] = map(fun(a) -> 1;
		     (b) -> 2
		  end, [a,b,a]),
    [1,2,6] = map(fun Fac(0) -> 1;
		      Fac(N) -> N * Fac(N-1)
		 end, [1,2,3]),
    horray.

%% Functions as arguments

for(Max, Max, F) -> [F(Max)];
for(I, Max, F)   -> [F(I) | for(I+1, Max, F)].
		       
%% calling
test1() ->
    Double = fun(X) -> 2*X end,
    for(1,10, Double).

%% Funs capture their environment
test2() ->
    Y = 10,
    Adder = fun(X) -> X + Y end,
    for(1,10,Adder).

%% Funs can be the return value of functions
test3() ->
    Adder = make_adder(10),
    for(1,10,Adder).

make_adder(Y) ->
    fun(X) -> X + Y end.

%% test4 variables captured in a function
%% retain their values *after* the function has returned:
%% So if we say
%%   F = test4()
%%   then F(10) => 20
%%   showing that we can use Y after test4 has returned
%%   normally local variable in functions are not retained after the
%%   function has returned.

test4() ->
    Y = 10,
    fun(X) -> X + Y end.

%% Funs in messages

test5() ->
    Add10 = make_adder(10),
    Pid = spawn(fun() -> wait() end),
    Pid ! Add10,
    Pid ! {self(), 20},
    receive
	{Pid, X} ->
	    X
    end.

wait() ->
    receive
	F ->
	    receive
		{From, X} ->
		    From ! {self(), F(X)}
	    end
    end.

%% some standard functions
map(_, [])   -> [];
map(F, [H|T]) -> [F(H)|map(F, T)]. 
    
foldl(_, A0, []) -> A0;
foldl(F, A0, [H|T]) ->
    A1 = F(H, A0),
    foldl(F, A1, T).

%% partition(Pred, List) -> {Satisfying, NotSatisfying}

partition(F, L) ->
    partition(F, L, [], []).

partition(_,[],T,F) ->
    {lists:reverse(T), lists:reverse(F)};
partition(F, [H|T], True, False) ->
    case F(H) of
	true ->
	    partition(F, T, [H|True], False);
	false ->
	    partition(F, T, True, [H|False])
    end.


    
