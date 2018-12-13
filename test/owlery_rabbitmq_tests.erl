-module(owlery_rabbitmq_tests).
-author("soteras").

-include_lib("eunit/include/eunit.hrl").
-include_lib("amqp_client/include/amqp_client.hrl").

-define(EXCHANGE, <<"send_email">>).
-define(QUEUE, <<"send_email_request">>).

setup_test_() ->
  {setup,
    fun setup_queue/0,
    fun cleanup/1,
    fun queue_message/0}.

queue_message() ->
  Channel = get_channel(),
  ok = owlery_rabbitmq:queue_message(<<"test">>),


  Get = #'basic.get'{queue = ?QUEUE, no_ack = true},
  {#'basic.get_ok'{}, Content} = amqp_channel:call(Channel, Get),
  #'amqp_msg'{payload = Payload} = Content,

  ?assertEqual(<<"test">>, Payload).

setup_queue() ->
  Channel = get_channel(),

  ExchangeDeclare = #'exchange.declare'{exchange = ?EXCHANGE, durable = true},
  QueueDeclare = #'queue.declare'{queue = ?QUEUE, durable = true},
  Binding = #'queue.bind'{exchange = ?EXCHANGE, queue = ?QUEUE, routing_key = ?QUEUE},

  #'exchange.declare_ok'{} = amqp_channel:call(Channel, ExchangeDeclare),
  #'queue.declare_ok'{} = amqp_channel:call(Channel, QueueDeclare),
  #'queue.bind_ok'{} = amqp_channel:call(Channel, Binding).

cleanup(_) ->
  Channel = get_channel(),

  ExchangeDelete = #'exchange.delete'{exchange = ?EXCHANGE},
  QueueDelete = #'queue.delete'{queue = ?QUEUE},

  #'exchange.delete_ok'{} = amqp_channel:call(Channel, ExchangeDelete),
  #'queue.delete_ok'{} = amqp_channel:call(Channel, QueueDelete).

get_channel() ->
  {ok, Connection} = amqp_connection:start(#amqp_params_network{}),
  {ok, Channel} = amqp_connection:open_channel(Connection),
  Channel.