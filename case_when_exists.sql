/* Suponha que você tem uma base de tickets de suporte e quer saber:
Qual a proporção de clientes que abriram um chamado na categoria "Atendimento Inicial" e, em até 30 dias, voltaram a abrir um chamado na categoria "Problema Técnico Grave".
Temos, portanto: 
Denominador: clientes que abriram Atendimento Inicial
Numerador: desses, quantos escalaram para Problema Técnico Grave dentro de 30 dias
Aqui, vamos usar o CASE WHEN EXISTS como solução de sintaxe no trino. */
SELECT
  COUNT(DISTINCT CASE 
    WHEN EXISTS (
      SELECT 1
      FROM tickets AS t2
      WHERE t2.customer_id = t1.customer_id
        AND t2.category = 'Problema Técnico Grave'
        AND t2.created_at BETWEEN t1.created_at AND t1.created_at + INTERVAL '30' DAY
    )
    THEN t1.customer_id
    ELSE NULL
  END) 
  * 1.0 / NULLIF(COUNT(DISTINCT t1.customer_id), 0) AS escalation_rate
FROM tickets AS t1
WHERE t1.category = 'Atendimento Inicial';

/* t1: representa os tickets de "Atendimento Inicial"
Para cada customer_id em t1, o EXISTS verifica se existe um ticket na categoria "Problema Técnico Grave" até 30 dias depois
O CASE WHEN EXISTS retorna o customer_id somente quando essa condição é satisfeita.
A divisão totaliza a taxa de clientes que escalaram o problema após um primeiro contato. 
Quando estamos lidando com eventos correlacionados no tempo, CASE WHEN EXISTS se torna uma arma poderosa, podendo:
1) Evitar contagem duplicada causada por JOINs
Quando usamos JOIN para cruzar registros da mesma entidade (ex: tickets do mesmo sk_user), o número de linhas explode se houver múltiplos registros relacionados. 
Isso distorce o denominador e o numerador, inflando os resultados.
Com EXISTS, você testa apenas a existência de uma condição, sem precisar repetir ou expandir linhas — o que mantém a granularidade correta da análise.

2) Permite lógica temporal precisa: 
Você consegue aplicar filtros como: */

AND t2.ts_created BETWEEN t1.ts_created AND t1.ts_created + INTERVAL '30' DAY

/* Ou seja, você consegue garantir que: o evento B (ex: ticket no back/CSI) ocorreu depois do evento A (ex: ticket no front), e dentro de uma janela de tempo.
Isso seria bem mais difícil e propenso a erros com JOINs diretos.

3. Mais legível e intuitivo para regras de negócio
EXISTS lê quase como linguagem natural:
"Se existe um outro ticket daquele usuário que aconteceu até 30 dias depois, então..."
Isso torna a lógica mais próxima da regra de negócio que você está modelando.

4) Melhor performance em muitos casos
EXISTS é otimizado pelos mecanismos de consulta dos bancos modernos. 
Ele para na primeira correspondência encontrada, o que pode ser mais eficiente do que JOIN, que precisa reunir e combinar todas as linhas antes de aplicar filtros.

5) Facilidade para contar sem precisar agrupar
Você consegue contar com COUNT(DISTINCT ...) no CASE WHEN EXISTS, mantendo o controle de agregação sem precisar fazer GROUP BY antes.
*/
