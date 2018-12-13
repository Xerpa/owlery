-module(owlery_requester).
-author("soteras").
-export([send_email_request/4]).

-type opts() :: maybe_improper_list().

-spec send_email_request(bitstring(), bitstring(), [bitstring()], opts()) -> ok.
send_email_request(Template_name, Subject, To, Opts) ->
  Data = proplists:get_value(data, Opts, #{}),
  ResponsePid = proplists:get_value(response_pid, Opts),
  QueueMessage = proplists:get_value(queue_message, Opts, fun owlery_rabbitmq:queue_message/1),

  Request = owlery_builder:create_request(Template_name, Subject, To, Data),
  Json = owlery_builder:to_json(Request),

  Response = QueueMessage(Json),

  if
    is_pid(ResponsePid) ->
      ResponsePid ! Response;

    true ->
      ok
  end.

