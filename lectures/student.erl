-module(student).
-compile(export_all).

%% to start
%%  student:start().

%% edit if necessary

my_name() -> "joe:" ++ lists:flatten(io_lib:format("~p",[time()])).
    
teacher_ip() -> "localhost".
teacher_port() -> 4567.


start() ->
    {ok, Socket} = gen_udp:open(0, [binary]),
    B0 = list_to_binary(my_name()),
    gen_udp:send(Socket, teacher_ip(), teacher_port(),
		 [<<"register:">>, B0]),
    loop(Socket).

loop(Socket) ->
    io:format("Waiting for a command~n"),
    receive
	{udp, Socket, _Ip, _Port, <<"save_file:",B/binary>>} ->
	    io:format("Here ~p~n",[B]),
	    [FileB, DataB] = binary:split(B,<<$:>>),
	    FileName = binary_to_list(FileB),
	    io:format("Writing:~p~n",[FileName]),
	    file:write_file(FileName, DataB),
	    loop(Socket);
	{udp, Socket, _Ip, _Port, <<"message:",B/binary>>} ->
	    io:format("Message from teacher:~p~n",[B]),
	    loop(Socket);
	{udp, Socket, _Ip, _Port, <<"do:",B/binary>>} ->
	    {M,F,A} = binary_to_term(B),
	    (catch apply(M,F,A)),
	    loop(Socket);
	X ->
	    io:format("Unexpected message:~p~n",[X]),
	    loop(Socket)
    end.

	
    
    
