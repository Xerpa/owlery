-module(owlery_rabbitmq).
-author("soteras").
-include_lib("amqp_client/include/amqp_client.hrl").
-export([queue_message/1]).

-spec queue_message(bitstring()) -> ok | {error, any()}.
queue_message(RequestJson) when is_binary(RequestJson) ->
  case get_connection() of
    {ok, Connection} ->
      case get_channel(Connection) of
        {ok, Channel} ->
          publish_message(Channel, RequestJson),
          amqp_channel:close(Channel),
          amqp_connection:close(Connection),
          ok;

        {error, Error} ->
          {error, Error}
      end;

    {error, Error} -> {error, Error}
  end.

get_connection() ->
    amqp_connection:start(#amqp_params_network{}).

get_channel(Connection) ->
    amqp_connection:open_channel(Connection).

publish_message(Channel, Message) ->
    Publish = #'basic.publish'{exchange = <<"send_email">>, routing_key = <<"send_email_request">>},
    amqp_channel:cast(Channel, Publish, #amqp_msg{payload = Message}).
