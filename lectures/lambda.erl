-module(lambda).
-compile(export_all).

%% start with things of the same shape

double([]) -> [];
double([H|T]) -> [2*H|double(T)].
 
triple([]) -> [];
triple([H|T]) -> [3*H|triple(T)].
 
quadruple([]) -> [];
quadruple([H|T]) -> [4*H|quadruple(T)].
 
square([]) -> [];
square([H|T]) -> [H*H|square(T)].

%% This is getting tedious
%% so abstract out the part that varies and add
%% it as an additional argument. We could take
%% any of these functions and add a new argument F
%% take the last one for example:

square1([], _F)   -> [];
square1([H|T], F) -> [F | square1(T, F)].

%% but wait - this is not quite right:
%% need to apply the argument

square2([], _F)   -> [];
square2([H|T], F) -> [F(H) | square2(T, F)].

%% rename theb function - it's no longer square, but a generic
%% function, so rename the function :

apply_to_list([], _F)   -> [];
apply_to_list([H|T], F) -> [F(H) | apply_to_list(T, F)].

%% now we can redefine your original code

double_new(L)    -> apply_to_list(L, fun(X) ->  2*X end).
triple_new(L)    -> apply_to_list(L, fun(X) ->  3*X end).
quadruple_new(L) -> apply_to_list(L, fun(X) ->  4*X end).
square_new(L)    -> apply_to_list(L, fun(X) ->  X*X end).

%% this process is called 'lambda abstraction'
%% it means 'lifting out common functionality and replacing it by a
%% paraameterised function call.
%% fun(X) -> .... end is called a 'lamda expression '

%% apply_to_list is called map

%% You've invented map

%% Now we're thinking in terms of doing something to the entire
%% list. A single operation involves manipulating thre entire list
%% in the first program a sinble line of code did something to a single
%% element in the list.
%% This way of thinking could be called
%% 'escaping the Von Neumann Bottleneck'

%% Languages Like C etc. we are encouraged to program 'word at a time'
%% this is the callical sop call 'Harvard Arichitecture' - programming
%% list-at-a-time escapes from tbe Von Numan Bottlreneck. Indeed
%% goiven a suitable architectiure, we could map a fucntion over a list
%% in parallel, performing all,mthe operations in parallel and 
%% truel escaping the von-neuman bottleneck.

%% In a machine that follows the VonNeumannArchitecture, the bandwidth
%% between the CPU (where all the work gets done) and memory is very
%% small in comparison with the amount of memory. On typical modern
%% machines it's also very small in comparison with the rate at which the
%% CPU itself can work. - http://c2.com/cgi/wiki?VonNeumannBottleneck

%% The term Harvard architecture originally referred to computer
%% architectures that used physically separate storage devices for their
%% instructions and data (in contrast to the VonNeumannArchitecture). The
%% term originated from the Harvard Mark I relay based computer, which
%% stored instructions on punched tape and data in relay latches.
%% http://c2.com/cgi/wiki?HarvardArchitecture



 
    

    
