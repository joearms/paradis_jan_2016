-module(math0).

-compile(export_all).

test() ->
    %% correct tests
    1 = fac(0),
    24 = fac(4),
    720 = fac(6),
    %% incorrect tests - fac(X) should fail for invalid arguments
    {'EXIT', _} = (catch fac(abc)),
    {'EXIT', _} = (catch fac(-10)),
    {'EXIT', _} = (catch fac([])),
    horray.

fac(0) -> 1;
fac(N) when N > 0 -> 
    N*fac(N-1).
