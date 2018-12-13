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
  Host = application:get_env(owlery, host, <<"localhost">>),
  Port = application:get_env(owlery, port, 5672),
  VirtualHost = application:get_env(owlery, virtual_host, <<"/">>),
  Username = application:get_env(owlery, username, <<"guest">>),
  Password = application:get_env(owlery, password, <<"guest">>),
  SslOptions = application:get_env(owlery, ssl_options, none),

  ParamsNetwork = #amqp_params_network{
    host = binary_to_list(Host),
    port = Port,
    virtual_host = VirtualHost,
    username = Username,
    password = Password,
    ssl_options = SslOptions
  },

  amqp_connection:start(ParamsNetwork).

get_channel(Connection) ->
    amqp_connection:open_channel(Connection).

publish_message(Channel, Message) ->
    Exchange = application:get_env(owlery, exchange, <<"send_email">>),
    QueueRequest = application:get_env(owlery, queue_request, <<"send_email_request">>),
    Publish = #'basic.publish'{exchange = Exchange, routing_key = QueueRequest},
    amqp_channel:cast(Channel, Publish, #amqp_msg{payload = Message}).

