/* Já precisou puxar uma informação de uma tabela imensamente pesada - dimensionada por sk/id de interação, por exemplo, 
que serviria somente para nutrir uma única tabela, fazendo join com um id/sk já presente na seleção? Aqui a ideia é simples, de inserção de uma subquery na sua cte */
WITH base_final as (SELECT 
  tp.*, -- na linha abaixo, verifique que estou criando a coluna com um case when
  (
  SELECT 
    CASE 
      WHEN bmt.is_backlog_within_sla = TRUE THEN 1
      WHEN bmt.is_backlog_within_sla = FALSE THEN 0
      ELSE NULL
    END
  FROM tasks_backlog AS bmt
  WHERE bmt.sk_task = CAST(tp.sk_ticket AS varchar(99))
  ORDER BY bmt.dt_reference DESC, bmt.sla_target DESC
  LIMIT 1
) AS is_backlog_in_time,

/*
O que fizemos foi a chamada subquery escalar, que retorna somente 1 valor dentro do select da CTE, mas o que ela faz exatamente?
- Procura registros em tasks_backlog (bmt) que tenham o mesmo sk_task que tp.sk_ticket (cast para varchar(99)).
- Ordena os resultados por dt_reference DESC e sla_target DESC, ou seja, pegando o registro mais recente e mais relevante.
- Aplica um CASE para transformar TRUE/FALSE em 1/0, e NULL se não houver correspondência.
- Limita a 1 resultado com LIMIT 1. 
A subquery escalar é semelhante a um LEFT JOIN LATERAL - permite que a tabela da subquery acesse colunas da linha atual da tabela externa, mas escrita de forma embutida. 
Se você: 
Precisa consultar uma subquery que depende da linha atual.
Quer evitar subqueries repetitivas no SELECT.
Precisa pegar só 1 linha relacionada por critério (com ORDER BY e LIMIT 1).
Está fazendo algo que parece um correlated subquery, mas quer otimizar performance.
Então vale adotar o LEFT JOIN LATERAL:
*/
base_final AS (
  SELECT 
    tp.*, 
    bmt_result.is_backlog_in_time
  FROM some_table tp
  LEFT JOIN LATERAL (
    SELECT 
      CASE 
        WHEN bmt.is_backlog_within_sla = TRUE THEN 1
        WHEN bmt.is_backlog_within_sla = FALSE THEN 0
        ELSE NULL
      END AS is_backlog_in_time
    FROM tasks_backlog bmt
    WHERE bmt.sk_task = CAST(tp.sk_ticket AS varchar(99))
    ORDER BY bmt.dt_reference DESC, bmt.sla_target DESC
    LIMIT 1
  ) AS bmt_result ON TRUE
)
/* Na seleção final, segue referenciando a nova coluna da mesma maneira que seria feito com uma subquery escalar. */
