/* No rankeamento de informações, uma boa prática é a utilização do ROW_NUMBER() OVER (PARTITION BY coluna1 ORDER BY coluna2)
Essa função, serviria para alguns problemas tias como: numerar registros em grupos (ex: rankear vendas por vendedor);
pegar a "primeira linha" ou "top N" dentro de cada grupo; eliminar duplicatas mantendo apenas o primeiro registro por grupo.
Suponha a tabela sales com colunas seller_id, sale_date, amount. Quero listar as 2 maiores vendas de cada vendedor: */
SELECT
  seller_id,
  sale_date,
  amount,
  ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY amount DESC) AS rn
FROM sales
WHERE rn <= 2; 
/* No caso do trino, não há a possibilidade de usar o rn diretamente na where clause, havendo como solução a inserção do row_number numa cte, 
e uso da where clause numa seleção final, por exemplo: */
WITH ranked_sales AS (
  SELECT
    seller_id,
    sale_date,
    amount,
    ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY amount DESC) AS rn
  FROM sales
)
SELECT *
FROM ranked_sales
WHERE rn <= 2
ORDER BY seller_id, rn;
/* Já no caso do Big QUery, por exemplo, o QUALIFY poderia suprir a necessidade de uma cte/subquery, assim: */
SELECT
  seller_id,
  sale_date,
  amount
FROM sales
QUALIFY ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY amount DESC) = 2

/* Apesar de ser uma "mão na roda", o row_number não anula a necessidade de revisão dos seus joins em caso de duplicatas/data bombing. É importante, antes de utilizá-lo,
entender se o seu join não poderia ser um inner join, ou se você não poderia embutir where clauses no left join, por exemplo, para trazer informações mais precisas. */
