-module(teacher).
-compile(export_all).

teacher_port() -> 4567.
    
%% Preparation
%%   download student.erl / teacher.erl
%%   edit in IP address of teacher
%%   compile

%% teacher  runs teacher:start()
%% students runs student:start()

%% to start:
%%  teacher:start()
%% then:
%%  teacher:message("hello everybody").
%%  teacher:send_file("./teacher.erl").
%%  teacher:teacher:eval_remove(io,format,["hello~n"]).



start() ->
    S = self(),
    register(teacher, spawn(fun() -> go(S) end)),
    receive
	ack ->
	    true
    end.

send_file(File) ->
    {ok, Data} = file:read_file(File),
    Bname = list_to_binary(File),
    B = <<"save_file:",Bname/binary,$:,Data/binary>>,
    broadcast(B).

eval_remove(M,F,A) ->
    B = term_to_binary({M,F,A}),
    B1 = <<"do:",B/binary>>,
    broadcast(B1).

message(Str) ->
    B = list_to_binary(Str),
    broadcast(<<"message:",B/binary>>).

broadcast(M) ->
    teacher ! {broadcast, M}.

go(P) ->
    {ok, Socket} = gen_udp:open(teacher_port(), [binary]),
    P ! ack,
    loop(Socket, []).

loop(Socket, L) ->
    receive
	{broadcast, M} ->
	    do_broadcast(Socket, L, M),
	    loop(Socket, L);
	{udp, Socket, IP, Port, <<"register:",B/binary>>} ->
	    io:format("register:~p~n",[{IP,Port,B}]),
	    loop(Socket, [{IP,Port}|L]);
	Any ->
	    io:format("Any:~p~n",[Any]),
	    loop(Socket, L)
    end.

do_broadcast(Socket, [{IP,Port}|T], Msg) ->
    X = gen_udp:send(Socket, IP, Port, Msg),
    io:format("UDP send result = ~p~n",[X]),
    do_broadcast(Socket, T, Msg);
do_broadcast(_, [], _) ->
    true.


