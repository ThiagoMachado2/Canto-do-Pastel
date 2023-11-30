-- 1 = Ranking de Metodos de Pagamento Mais Utilizados:

CREATE VIEW RankingMetodosPagamento AS
SELECT
    forma_pagamento,
    COUNT(pedido_id) AS QuantidadePedidos
FROM
    pedidos
GROUP BY
    forma_pagamento
ORDER BY
    QuantidadePedidos DESC;

-- Uma view que mostra um ranking dos metodos de pagamento.


-- 2 = Ranking de Pasteis Mais Vendidos:

CREATE VIEW RankingProdutosMaisVendidos AS
SELECT
    p.nome AS NomePastel,
    SUM(ip.quantidade) AS TotalVendido,
    SUM(tp.preco * ip.quantidade) AS ReceitaGerada
FROM
    produtos p
    JOIN itensPedidos ip ON p.produto_id = ip.produto_id
    JOIN tamanhosProdutos tp ON p.produto_id = tp.produto_id
GROUP BY
    NomePastel
ORDER BY
    TotalVendido DESC;

-- Uma view que exibe um ranking dos produtos mais vendidos no estabelecimento.


-- 3 = Histórico de Clientes:

CREATE VIEW HistoricoClientes AS
SELECT
    c.nome_completo AS NomeCliente,
    ped.data_pedido AS DataPedido,
    p.nome AS NomePastel,
    ip.quantidade,
    tp.preco * ip.quantidade AS ValorTotal
FROM
    clientes c
    JOIN pedidos ped ON c.cliente_id = ped.cliente_id
    JOIN itensPedidos ip ON ped.pedido_id = ip.pedido_id
    JOIN produtos p ON ip.produto_id = p.produto_id
    JOIN tamanhosProdutos tp ON p.produto_id = tp.produto_id;

-- Uma view que fornece um histórico de pedidos para cada cliente.


-- 4 = Menu:

CREATE VIEW MenuDeRecheios AS
SELECT
    recheio
FROM
    recheios;

-- Uma view que mostra os possiveis recheios de pastel.


-- 5 = Resumo dos Pedidos:

CREATE VIEW ResumoPedidos AS
SELECT
    c.cliente_id,
    c.nome_completo AS NomeCliente,
    COUNT(p.pedido_id) AS NumeroPedidos,
    SUM(tp.preco * ip.quantidade) AS ValorTotalGasto
FROM
    clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    LEFT JOIN itensPedidos ip ON p.pedido_id = ip.pedido_id
    LEFT JOIN tamanhosProdutos tp ON ip.produto_id = tp.produto_id
GROUP BY
    c.cliente_id, NomeCliente;

-- Uma view que fornece um resumo dos pedidos.

#------------------------------

-- Lista os Pasteis Vendidos por Tamanho
CREATE VIEW PasteisVendidosPorTamanho AS
SELECT
    t.tamanho,
    SUM(ip.quantidade) AS QuantidadeVendida
FROM
    tamanhos t
    JOIN tamanhosProdutos tp ON t.tamanho_id = tp.tamanho_id
    JOIN itensPedidos ip ON tp.produto_id = ip.produto_id
GROUP BY
    t.tamanho;
    
SELECT *
FROM PasteisVendidosPorTamanho;


-- Pedidos Realizados no Último Mês
CREATE VIEW PedidosUltimoMes AS
SELECT
    pedido_id,
    data_pedido
FROM
    pedidos
WHERE
    MONTH(data_pedido) = MONTH(NOW() - INTERVAL 1 MONTH);
-- Uma view que lista os pedidos realizados no último mês

SELECT *
FROM PedidosUltimoMes;

-- Pasteis sem Pedidos
CREATE VIEW PasteisSemPedidos AS
SELECT
    p.produto_id,
    p.nome AS NomePastel
FROM
    produtos p
    LEFT JOIN itensPedidos ip ON p.produto_id = ip.produto_id
WHERE
    ip.produto_id IS NULL;
-- Uma view que lista os pasteis que ainda não foram pedidos.

SELECT *
FROM PasteisSemPedidos;

-- Pedidos por Dia da Semana
CREATE VIEW PedidosPorDiaSemana AS
SELECT
    DAYNAME(data_pedido) AS DiaSemana,
    COUNT(pedido_id) AS QuantidadePedidos
FROM
    pedidos
GROUP BY
    DiaSemana;
-- Uma view que mostra a quantidade de pedidos realizados em cada dia da semana

SELECT *
FROM PedidosPorDiaSemana;

-- Quantidade de Clientes Maiores e Menores de 18 Anos
CREATE VIEW ClientesMaioresMenores18 AS
SELECT
    SUM(CASE WHEN YEAR(NOW()) - YEAR(data_nascimento) >= 18 THEN 1 ELSE 0 END) AS QuantidadeMaiores18,
    SUM(CASE WHEN YEAR(NOW()) - YEAR(data_nascimento) < 18 THEN 1 ELSE 0 END) AS QuantidadeMenores18
FROM
    clientes
WHERE
    data_nascimento IS NOT NULL;
-- Uma view que calcula a quantidade de clientes maiores e menores de 18 anos

SELECT *
FROM ClientesMaioresMenores18;
