-module(student).
-compile(export_all).

%% to start
%%  student:start().

%% edit your_name()  to your name
%% edit teacher_ip() to the adress the teacher gave you

student_name() -> "joe:".
    
teacher_ip() -> "130.237.89.81".



my_name() -> student_name() ++ lists:flatten(io_lib:format("~p",[time()])).


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

	
    
    
