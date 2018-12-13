-module(builder_tests).
-include_lib("eunit/include/eunit.hrl").

create_request_3_test() ->
  ?assertEqual(
     #{
      template_name => "Template",
      subject => "Email Test",
      to => ["email@test.com"],
      data => #{}
    },
    builder:create_request("Template", "Email Test", ["email@test.com"])
  ).

create_request_4_test() ->
  ?assertEqual(
    #{
      template_name => "Template",
      subject => "Email Test",
      to => ["email@test.com"],
      data => #{name => "Test"}
    },
    builder:create_request("Template", "Email Test", ["email@test.com"], #{name => "Test"})
  ).

to_json_test() ->
  Request = #{
    template_name => "Template",
    subject => "Email Test",
    to => ["email@test.com"],
    data => #{name => "Tenzing"}
  },
  Exp = jsx:encode(Request),

  ?assertEqual(Exp, builder:to_json(Request)).