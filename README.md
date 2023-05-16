### Guide de Teste 

- Publicar o sns

```
aws sns publish \
    --topic-arn arn:aws:sns:eu-west-1:<account-id>:sns-to-sqs \
    --message "Hello, world" \
    --region=eu-west-1

```
- Validar o retorno do tópico SNS publicado.

- Filtrar a mensagem do tópico
  
```
aws sqs receive-message \
    --queue-url "https://sqs.eu-west-1.amazonaws.com/<account-id>/sns-to-sqs" \
    --max-number-of-messages 1 \
    --region=eu-west-1
```

- Validar o retorno da mensagem.


- Utilizando o jq para validar a mensagem de uma forma mais fácil
  
```
aws sqs receive-message \
    --queue-url "https://sqs.eu-west-1.amazonaws.com/157088858309/sns-to-sqs" \
    --max-number-of-messages 1 \
    --region=eu-west-1 \
    | jq '.Messages[].Body | fromjson | .Message'

"Hello, world"

```

- Rodar o  terraform destroy  para zerar o ambiente aws.
