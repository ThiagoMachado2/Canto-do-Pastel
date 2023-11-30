DELIMITER //
-- Procedure Inserir Cliente
CREATE PROCEDURE InserirCliente(
    IN nome_completo VARCHAR(100),
    IN nome_chamado VARCHAR(50),
    IN cpf VARCHAR(14),
    IN data_nascimento DATE,
    IN telefone VARCHAR(15),
    IN email VARCHAR(100),
    IN bairro VARCHAR(50),
    IN numero VARCHAR(50),
    IN rua VARCHAR(50),
    IN cidade VARCHAR(50),
    IN estado VARCHAR(2)
)
BEGIN
    DECLARE cliente_id INT;

    -- Inserir em clientes
    INSERT INTO clientes (nome_completo, nome_chamado, cpf, data_nascimento, telefone, email)
    VALUES (nome_completo, nome_chamado, cpf, data_nascimento, telefone, email);

    -- Obter o ID do cliente inserido
    SET cliente_id = LAST_INSERT_ID();

    -- Inserir em enderecos
    INSERT INTO enderecos (cliente_id, bairro, numero, rua, cidade, estado)
    VALUES (cliente_id, bairro, numero, rua, cidade, estado);
END //

DELIMITER ;

-- Chamando a procedure InserirCliente
CALL InserirCliente(
    'Ana Souza',
    'Ana',
    '123.789.456-01',
    '1992-08-18',
    '(11) 87654-3210',
    'ana.souza@email.com',
    'Centro',
    '456',
    'Rua D',
    'São Paulo',
    'SP'
);


DELIMITER //

-- Procedure Fazer Pedido
CREATE PROCEDURE FazerPedido(IN idCliente INT, IN idProduto INT, IN formaPagamento ENUM('D', 'PIX', 'CC', 'CD'))
BEGIN
    DECLARE idPedido INT;

    -- Inserir em pedidos
    INSERT INTO pedidos (cliente_id, forma_pagamento) VALUES (idCliente, formaPagamento);
    SET idPedido = LAST_INSERT_ID();

    -- Inserir em itensPedidos
    INSERT INTO itensPedidos (pedido_id, produto_id, quantidade) VALUES (idPedido, idProduto, 1);

    SELECT * FROM pedidos WHERE pedido_id = idPedido;
END //

DELIMITER ;

                     -- ID CLIENTE, ID PRODUTO, FORMA DE PAGAMENTO 
CALL FazerPedido(1, 3, 'PIX');



DELIMITER //




DELIMITER //

-- Procedure Obter Detalhes Pedido
CREATE PROCEDURE ObterDetalhesPedido(IN idPedido INT)
BEGIN
    SELECT 
        p.produto_id,
        p.nome AS nome_produto,
        ip.quantidade,
        t.tamanho,
        tp.preco AS preco_unitario,
        (ip.quantidade * tp.preco) AS total
    FROM itensPedidos ip
    JOIN produtos p ON ip.produto_id = p.produto_id
    JOIN tamanhosProdutos tp ON ip.produto_id = tp.produto_id
    JOIN tamanhos t ON tp.tamanho_id = t.tamanho_id
    WHERE ip.pedido_id = idPedido;
END //

DELIMITER ;

CALL ObterDetalhesPedido(3);



DROP PROCEDURE IF EXISTS ObterDetalhesPedido;