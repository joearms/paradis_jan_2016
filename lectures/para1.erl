-module(para1).

-export([start/0, fib/1, test_fib/0]).

start() ->
    start_process(1, 42),
    start_process(2, 38),
    start_process(3, 20),
    start_process(4, 15),
    start_process(5, 38),
    start_process(6, 22),
    wait_replies(6).

wait_replies(0) ->  ok;
wait_replies(N)  ->
    receive
	Any ->
	    io:format("at ~p received ~p~n",[erlang:time(), Any]),
	    wait_replies(N-1)
    end.

start_process(K, X) ->
    S = self(),
    spawn(fun() -> compute_then_reply(K, S, X) end).

compute_then_reply(K, Parent, X) ->
    Y = fib(X),
    Parent ! {process,K,fib,X,is,Y}.

test_fib() ->
    0 = fib(0),
    1 = fib(1),
    144 = fib(12),
    6765 = fib(20),
    yes.

fib(0) -> 0;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2). 
    

		  


    
