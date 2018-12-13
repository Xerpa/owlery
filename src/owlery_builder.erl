-module(owlery_builder).
-author("soteras").
-export([create_request/3, create_request/4, to_json/1]).

-spec create_request(bitstring(), bitstring(), [bitstring()]) -> map().
create_request(Template_name, Subject, To) ->
    create_request(Template_name, Subject, To, #{}).

-spec create_request(bitstring(), bitstring(), [bitstring()], map()) -> map().
create_request(Template_name, Subject, To, Data) when is_list(To) and is_map(Data) ->
    #{
      template_name => Template_name,
      subject => Subject,
      to => To,
      data => Data
    }.

-spec to_json(map()) -> bitstring().
to_json(Request) when is_map(Request) ->
    jsx:encode(Request).
