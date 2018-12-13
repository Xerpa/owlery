![O Corujal é uma torre alta e circular, de fácil acesso, que fica na parte externa do Castelo de Hogwarts](https://i.imgur.com/9ipQed5.png)
#
*Lib para consumir o serviço de envio de emails (Hedwig).*

## Instalação

Para instalar é necessário adicionar no seu **mix.exs** como uma nova dependência:

```
defp deps do
  [
    {:owlery, github: "Xerpa/owlery", ref: "c6c115217496b99ccf1667dc09274c283ede8822"},
  ]
end
```

Depois basta rodar o comando:

```
mix deps.get
```

## Como usar

Para enviar um novo e-mail basta utilizar o modulo *:owlery* e chamar a função **send_email/3** ou **send_email/4**

Essa função recebe três parâmetros obrigatórios:

- Template do email: Template que vai ser usado no email, precisa ser algum já existente no Hedwig.
- Assunto do Email.
- E uma lista com os emails que serão enviados.

O quarto parâmetro é uma *keyword* com as seguintes opções:

- data - Um mapa com os dados que serão passados para o email.
- response_pid - Por padrão o envio do email não retorna uma resposta, para receber uma resposta você precisa passar um pid para onde o owlery irá responder.

### Exemplos usando Elixir

```elixir
  :owlery.send_email("basic", "Assunto Teste", ["email@test.com.br"])
```

Exemplo usando as configurações opcionais.

```elixir
  opts = [data: %{"name" => "My Name"}, response_pid: self()]
  :owlery.send_email("basic", "Assunto Teste", ["email@test.com.br"], opts)

  receive do
    :ok ->
     ...

    {:error, error} ->
     ...
  end
```

### Exemplos usando Erlang

```erlang
owlery:send_email(<<"basic">>, <<"Assunto Teste">>, [<<"email@test.com.br">>])
```

Exemplo usando as configurações opcionais.

```erlang
Opts = [{data, #{name => <<"My Name">>}}, {response_pid, self()}].
owlery:send_email(<<"basic">>, <<"Assunto Teste">>, [<<"email@test.com.br">>], Opts).

receive
ok ->
 ...;

{error, Error} ->
 ...
end.
```

## Configuração

É usado as configurações padrão se nenhuma configuração for encontrada, para sobrescrever as configurações basta adicionar
nos seus arquivos de configuração seguindo o formato abaixo:

```
config :owlery,
  host: "localhost",
  port: 5672,
  virtual_host: "/",
  username: "guest",
  password: "guest",
  exchange: "send_email",
  queue_request: "send_email_request",
  ssl_options: [
    cacertfile: "",
    certfile: "",
    keyfile: ""
  ]
```

