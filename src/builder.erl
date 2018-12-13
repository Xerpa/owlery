-module(builder).
-export([create_request/3, create_request/4, to_json/1]).

create_request(Template_name, Subject, To) ->
    create_request(Template_name, Subject, To, #{}).

create_request(Template_name, Subject, To, Data) when is_list(To) and is_map(Data) ->
    #{
      template_name => Template_name,
      subject => Subject,
      to => To,
      data => Data
    }.

to_json(Request) when is_map(Request) ->
    jsx:encode(Request).
