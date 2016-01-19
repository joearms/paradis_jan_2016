-module(par1).
-compile(export_all).

fac(0) ->
    1;
fac(N) ->
    N *fac(N-1).


start() ->
    start_process(1, 30),
    start_process(2, 20),
    start_process(3, 15),
    start_process(4, 38),
    start_process(5, 22),
    wait_replies(5).

wait_replies(0) ->  ok;
wait_replies(N)  ->
    receive
	Any ->
	    io:format("~p~n",[Any]),
	    wait_replies(N-1)
    end.

start_process(K, X) ->
    S = self(),
    spawn(fun() -> compute_then_reply(K, S, X) end).

compute_then_reply(K, Parent, X) ->
    Y = fib(X),
    Parent ! {process,K,fib,X,is,Y}.

fib(0) -> 1;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2). 
    


		  


    
