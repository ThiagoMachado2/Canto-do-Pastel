-- 1  
DELIMITER //

CREATE OR REPLACE TRIGGER AlterarPrecoProduto
BEFORE UPDATE ON tamanhosProdutos
FOR EACH ROW
BEGIN
    
    SET NEW.preco = NEW.preco * 1.1;
END;

//

DELIMITER ;

UPDATE tamanhosProdutos
SET preco = preco + 1
WHERE tamanhopasteis_id = 1;

SELECT * FROM tamanhosProdutos WHERE tamanhopasteis_id = 1;



-- 2 

DELIMITER //
CREATE OR REPLACE TRIGGER VerificaCpfUnico
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM clientes WHERE cpf = NEW.cpf) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF já cadastrado';
    END IF;
END;
//
DELIMITER ;

# Use o insert duas vezes para testar 
INSERT INTO clientes (cliente_id,nome_completo, nome_chamado, cpf, data_nascimento, telefone, email) 
VALUES (9,'Carlos Oliveira', 'Carlos', '555.888.999-21', '1982-09-20', '(33) 5555-9999', 'carlos.santos@email.com');

-- 3
DELIMITER //
CREATE OR REPLACE TRIGGER RemoveEnderecoCliente
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    DELETE FROM enderecos WHERE cliente_id = OLD.cliente_id;
END;
//
DELIMITER ;

-- teste
INSERT INTO enderecos (cliente_id, bairro, numero, rua, cidade, estado)
VALUES (9, 'Centro', '123', 'Rua Principal', 'Cidade A', 'CA');

DELETE FROM clientes WHERE cpf = '555.888.999-21';

SELECT * FROM clientes;
SELECT * FROM enderecos;


-- 4

DELIMITER //
CREATE OR REPLACE TRIGGER DeletePedido
BEFORE DELETE ON pedidos FOR EACH ROW
BEGIN
    -- Excluir itens relacionados ao pedido
    DELETE FROM itensPedidos WHERE pedido_id = OLD.pedido_id;
END;
//
DELIMITER ;

INSERT INTO pedidos (cliente_id, forma_pagamento) VALUES (1, 'CC');

-- Inserir itens do pedido
INSERT INTO itensPedidos (pedido_id, produto_id, quantidade) VALUES (28, 1, 2);
INSERT INTO itensPedidos (pedido_id, produto_id, quantidade) VALUES (28, 2, 1); 

-- Excluir um pedido (isso acionará o gatilho)
DELETE FROM pedidos WHERE pedido_id = 28;

-- Verificar itens do pedido após a exclusão
SELECT * FROM itensPedidos WHERE pedido_id = 28;


-- 5 

DELIMITER //

CREATE OR REPLACE TRIGGER LimitePedidoDia
BEFORE INSERT ON pedidos FOR EACH ROW
BEGIN
    DECLARE num_pedidos_cliente INT;

    SELECT COUNT(*) INTO num_pedidos_cliente
    FROM pedidos
    WHERE cliente_id = NEW.cliente_id
    AND DATE(data_pedido) = CURDATE();

    IF num_pedidos_cliente >= 12 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O cliente atingiu o limite máximo de 12 pedidos em um dia.';
    END IF;
END //

DELIMITER ;

-- Inserir 12 pedidos para o cliente com o ID 1 (isso deve funcionar sem erro)
INSERT INTO pedidos (cliente_id, forma_pagamento) VALUES
    (1, 'D'), (1, 'D'), (1, 'D'), (1, 'D'), (1, 'D'),
    (1, 'D'), (1, 'D'), (1, 'D'), (1, 'D'), (1, 'D'),
    (1, 'D'), (1, 'D');

-- Tentar inserir mais 1 pedido para o mesmo cliente (isso deve gerar um erro)
INSERT INTO pedidos (cliente_id, forma_pagamento) VALUES (1, 'D');

-- Deve gerar um erro
INSERT INTO pedidos (cliente_id, forma_pagamento) VALUES (1, 'D');





