-module(bad_prog1).

/* 
   This program has a number of errors
   find them and fix them.
   Once you have fixed the code
   run some text examples to see if the fuctions
   behave as expected
   Running bad_prog1:test() should return the atom 'hooray'
*/ 

-compile(export_all)

test_all() ->
    10 = double(5),
    100 = area({square,10}),
    44 = perimeter({square,10}),
    // melting point of sulfur 
    {f,212} = temperatuer_convert({c,100}), 
    120 = factorial(4),
    hooray.

factorial(N) -> N*factorial(N-1)
factorial(0) -> 1

test1() ->
    io:format("double(2) is ~p~n,[double(2)]).

double(x) ->
    2*x.

area({square,X}) ->
    X*X;
area({rectangle,X,y}) ->
    X*y
area({circle,R}) ->
    math:pi() * R^2.
	
// temperature conversion 
// using formula 5(F-32) = 9C

temperature_convert({c,C}) -> 
    F = 9*C/5+32,
    {f,F};
temperature_convert({f,F}) -> 
    C = F-32*5/9,
    {c,C}

perimeter(X) ->
    case X of
        {rectangle,X,Y} ->
             2*(X+Y);
	{square,X} ->
             4*X;
        _ ->
            io:format("cannot compute the area of ~p~n",X)
    end.


