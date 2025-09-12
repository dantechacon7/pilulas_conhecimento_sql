/* Um outro uso muito interessante é o da função LEAD no acompanhamento de registros seguintes. 
Ela retorna o valor de uma coluna da linha seguinte (ou n linhas depois) dentro da partição/ordem definida.
A sintaxe básica é essa:
*/
LEAD(coluna, deslocamento, valor_default) OVER (PARTITION BY grupo ORDER BY ordem)

/* Seguinto o exemplo da pílula sobre LAG, ainda falando de uma base de tickets, um exemplo de uso de LEAD seria de identificar o registro seguinte do ticket, o que
poderia ser feito assim:
*/
SELECT
id_ticket,
dt_abertura_ticket,
LEAD(id_ticket) OVER(PARTITION BY id_user, time_acionado, tema ORDER BY dt_abertura_ticket) AS previous_contact,
LEAD(dt_abertura_ticket) OVER(PARTITION BY id_user, time_acionado, tema ORDER BY dt_abertura_ticket) AS dt_previous_contact
FROM base_tickets

/* Um bom uso dessa informação se relacionaria com FCR, possibilitando a análise da efetividade da resolução:
Se o intervalo entre tickets é muito curto, pode indicar baixa efetividade na resolução do problema.
Pode ser usado para priorizar temas ou usuários que demandam mais atenção.
*/
