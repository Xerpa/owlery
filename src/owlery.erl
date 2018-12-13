-module(owlery).
-author("soteras").
-export([send_email/3, send_email/4]).

-type opts() :: maybe_improper_list().

-spec send_email(bitstring(), bitstring(), [bitstring()]) -> ok.
send_email(Template_name, Subject, To) ->
    send_email(Template_name, Subject, To, []).

-spec send_email(bitstring(), bitstring(), [bitstring()], opts()) -> ok.
send_email(Template_name, Subject, To, Opts) when is_list(To) and is_list(Opts) ->
    spawn(owlery_requester, send_email_request, [Template_name, Subject, To, Opts]),
    ok.
