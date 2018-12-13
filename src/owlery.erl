-module(owlery).
-export([send_email/3, send_email/4]).

send_email(Template_name, Subject, To) ->
    send_email(Template_name, Subject, To, []).

send_email(Template_name, Subject, To, Opts) when is_list(To) and is_list(Opts) ->
    spawn(requester, send_email_request, [Template_name, Subject, To, Opts]),
    ok.
