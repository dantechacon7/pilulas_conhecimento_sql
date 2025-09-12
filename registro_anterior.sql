/* Uma outra opção que sempre me ajuda nas análises do dia a dia é a função LAG. Eu utilizo para retornar, por exemplo, valor da linha anterior (ou n linhas antes) 
dentro da partição/ordem definida. É interessante utilizar para comparar a linha atual com a anterior (ex: calcular variação entre meses), 
detectar mudanças ou gaps entre linhas, ou para análises de séries temporais. Um uso que faço hoje é o de puxar tickets relacionados a um mesmo id_user, podendo identificar, por exemplo, 
qual o contato anterior ou quanto ele ocorreu, gerando vários insights interessantes em análise de FCR/Recontato 
A sintaxe básica: 
*/

LAG(coluna, deslocamento, valor_default) OVER (PARTITION BY grupo ORDER BY ordem)

/* 
deslocamento: número de linhas para trás (default 1).
valor_default: valor usado quando não existe linha anterior (default NULL).
*/

SELECT
  id_user,
  month,
  id_ticket as recent_contact,
  LAG(id_ticket) OVER(PARTITION BY id_user, time_acionado, tema ORDER BY dt_abertura_ticket) AS previous_contact
  LAG(dt_abertura_ticket) OVER(PARTITION BY id_user, time_acionado, tema ORDER BY dt_abertura_ticket) AS dt_previous_contact

FROM base_tickets;
