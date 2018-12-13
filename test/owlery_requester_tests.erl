-module(owlery_requester_tests).
-author("soteras").

-include_lib("eunit/include/eunit.hrl").

send_email_request_without_response_test() ->
  Pid = self(),
  QueueMessageFun = fun(Json) -> Pid ! {ok, Json} end,

  Opts = [{queue_message, QueueMessageFun}],

  Result = owlery_requester:send_email_request(<<"basic">>, <<"Test 123">>, [<<"email@test.com">>], Opts),

  ?assertEqual(ok, Result),

  receive
    {ok, Json} ->
      Exp = <<"{\"data\":{},\"subject\":\"Test 123\",\"template_name\":\"basic\",\"to\":[\"email@test.com\"]}">>,
      ?assertEqual(Exp, Json)
  end.

send_email_request_with_response_test() ->
  Pid = self(),
  QueueMessageFun = fun(_) -> ok end,

  Opts = [{queue_message, QueueMessageFun}, {response_pid, Pid}],

  owlery_requester:send_email_request(<<"basic">>, <<"Test 123">>, [<<"email@test.com">>], Opts),

  receive
    Response ->
      ?assertEqual(ok, Response)
  end.

