-module(requester).
-author("soteras").

-export([send_email_request/4]).

send_email_request(Template_name, Subject, To, Opts) ->
  Data = proplists:get_value(data, Opts, #{}),
  ResponsePid = proplists:get_value(response_pid, Opts),
  Request = builder:create_request(Template_name, Subject, To, Data),
  Json = builder:to_json(Request),
  Response = rabbitmq:queue_message(Json),

  if
    is_pid(ResponsePid) ->
      ResponsePid ! Response;

    true ->
      ok
  end.

