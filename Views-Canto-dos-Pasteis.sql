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