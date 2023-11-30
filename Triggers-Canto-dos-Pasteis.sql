-- 1 = Trigger para Atualizar Preço Total de ItensPedidos após Atualização de Produto:

DELIMITER //
CREATE TRIGGER AfterUpdateProduto
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    -- Atualizar o preço total de itensPedidos após a atualização de um produto
    UPDATE itensPedidos AS ip
    SET ip.valor_total = (SELECT tp.preco * ip.quantidade FROM tamanhosProdutos tp WHERE tp.produto_id = ip.produto_id);
END;
//

DELIMITER ;
-- Este trigger atualizará o preço total dos itens de pedidos sempre que o preço de um produto for atualizado.


-- Inserir produto e item de pedido associado
INSERT INTO produtos (nome, categoria_id) VALUES ('Pastel de Queijo', 1);
INSERT INTO tamanhosProdutos (produto_id, tamanho_id, preco) VALUES (1, 1, 5.00);
INSERT INTO clientes (nome_completo) VALUES ('João Silva');
INSERT INTO pedidos (cliente_id) VALUES (1);
INSERT INTO itensPedidos (pedido_id, produto_id, quantidade) VALUES (1, 1, 2);

-- Atualizar preço do produto
UPDATE produtos SET preco = 6.00 WHERE produto_id = 1;

-- Verificar se o valor total do item de pedido foi atualizado corretamente
SELECT valor_total FROM itensPedidos WHERE pedido_id = 1;

#-------------


-- 2 = Trigger para Excluir Pedidos de um Cliente ao Excluir o Cliente:

DELIMITER //
CREATE TRIGGER BeforeDeleteCliente
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    -- Excluir pedidos do cliente ao excluir o cliente
    DELETE FROM pedidos WHERE cliente_id = OLD.cliente_id;
END;
//
DELIMITER ;

-- Este trigger excluirá automaticamente os pedidos de um cliente quando o cliente for removido do sistema.

-- Inserir cliente e pedido associado
INSERT INTO clientes (nome_completo) VALUES ('Maria Oliveira');
INSERT INTO pedidos (cliente_id) VALUES (2);

-- Excluir cliente (deve acionar o trigger e excluir o pedido associado)
DELETE FROM clientes WHERE cliente_id = 2;

-- Verificar se o pedido foi excluído corretamente
SELECT * FROM pedidos WHERE cliente_id = 2;

#-------------


-- 3 = Trigger para atualizar os itens pra novas categorias caso tenham sido deletadas

DELIMITER //
CREATE TRIGGER BeforeDeleteCategoriaAtualizaProdutos
BEFORE DELETE ON categorias
FOR EACH ROW
BEGIN
    DECLARE categoria_padrao_id INT;

    -- Encontrar o ID da categoria padrão (ou outra categoria desejada)
    SELECT categoria_id INTO categoria_padrao_id
    FROM categorias
    WHERE nome = 'Outros Produtos';

    -- Atualizar os produtos pertencentes à categoria sendo deletada
    UPDATE produtos
    SET categoria_id = categoria_padrao_id
    WHERE categoria_id = OLD.categoria_id;
END;
//
DELIMITER ;


-- Este trigger atualizara os itens para novas categorias quando deletadas

-- Inserir categoria e produtos associados
INSERT INTO categorias (nome) VALUES ('Doces');
INSERT INTO produtos (nome, categoria_id) VALUES ('Pastel de Chocolate', 3), ('Pastel de Morango', 3);

-- Excluir categoria (deve acionar o trigger e atualizar os produtos para a nova categoria)
DELETE FROM categorias WHERE categoria_id = 3;

-- Verificar se os produtos foram atualizados corretamente
SELECT * FROM produtos WHERE categoria_id = 3;

#--------------------

-- 4  Atualizar Valor Total do Pedido ao Alterar Quantidade em ItensPedidos
DELIMITER //
CREATE TRIGGER AfterUpdateQuantidadeItensPedidos
AFTER UPDATE ON itensPedidos
FOR EACH ROW
BEGIN
    -- Atualizar o valor total do pedido ao alterar a quantidade em itensPedidos
    UPDATE pedidos AS p
    SET p.valor_total = (SELECT SUM(tp.preco * ip.quantidade) FROM itensPedidos ip JOIN tamanhosProdutos tp ON ip.produto_id = tp.produto_id WHERE ip.pedido_id = p.pedido_id)
    WHERE p.pedido_id = NEW.pedido_id;
END;
//
DELIMITER ;

-- Inserir cliente e pedido associado
INSERT INTO clientes (nome_completo) VALUES ('Ana Lima');
INSERT INTO pedidos (cliente_id) VALUES (3);

-- Inserir produto e item de pedido associado
INSERT INTO produtos (nome, categoria_id) VALUES ('Pastel de Frango', 1);
INSERT INTO tamanhosProdutos (produto_id, tamanho_id, preco) VALUES (2, 1, 4.50);
INSERT INTO itensPedidos (pedido_id, produto_id, quantidade) VALUES (3, 2, 3);

-- Atualizar a quantidade do item de pedido
UPDATE itensPedidos SET quantidade = 5 WHERE pedido_id = 3;

-- Verificar se o valor total do pedido foi atualizado corretamente
SELECT valor_total FROM pedidos WHERE pedido_id = 3;

#--------------------


-- 5 Atualizar Valor Total do Pedido ao Excluir Item em ItensPedidos
DELIMITER //
CREATE TRIGGER ValorAfterDelete
AFTER DELETE ON itensPedidos
FOR EACH ROW
BEGIN
    -- Atualizar o valor total do pedido ao excluir um item em itensPedidos
    UPDATE pedidos AS p
    SET p.valor_total = (SELECT SUM(tp.preco * ip.quantidade) FROM itensPedidos ip JOIN tamanhosProdutos tp ON ip.produto_id = tp.produto_id WHERE ip.pedido_id = p.pedido_id)
    WHERE p.pedido_id = OLD.pedido_id;
END;
//
DELIMITER ;

-- Inserir cliente e pedido associado
INSERT INTO clientes (nome_completo) VALUES ('Carlos Rocha');
INSERT INTO pedidos (cliente_id) VALUES (4);

-- Inserir produto e item de pedido associado
INSERT INTO produtos (nome, categoria_id) VALUES ('Pastel de Carne', 1);
INSERT INTO tamanhosProdutos (produto_id, tamanho_id, preco) VALUES (3, 1, 6.00);
INSERT INTO itensPedidos (pedido_id, produto_id, quantidade) VALUES (4, 3, 4);

-- Excluir item de pedido (deve acionar o trigger e atualizar o valor total do pedido)
DELETE FROM itensPedidos WHERE pedido_id = 4;

-- Verificar se o valor total do pedido foi atualizado corretamente
SELECT valor_total FROM pedidos WHERE pedido_id = 4;

#---------------------------

-- 6 Exclui item de itensPedidos caso excluido
DELIMITER //
CREATE TRIGGER AfterDeleteItemItensPedidos
AFTER DELETE ON itensPedidos
FOR EACH ROW
BEGIN
    -- Atualizar o status do pedido para 'Concluído' ao excluir o último item em itensPedidos
    UPDATE pedidos AS p
    SET p.status_pedido = 'Concluído'
    WHERE p.pedido_id = OLD.pedido_id
    AND NOT EXISTS (SELECT 1 FROM itensPedidos WHERE pedido_id = OLD.pedido_id);

    -- Excluir o item dos itensPedidos caso seja o último item
    DELETE FROM itensPedidos
    WHERE pedido_id = OLD.pedido_id
    AND NOT EXISTS (SELECT 1 FROM itensPedidos WHERE pedido_id = OLD.pedido_id);
END;
//
DELIMITER ;

-- Inserir cliente e pedido associado
INSERT INTO clientes (nome_completo) VALUES ('Fernanda Souza');
INSERT INTO pedidos (cliente_id) VALUES (5);

-- Inserir produto e item de pedido associado
INSERT INTO produtos (nome, categoria_id) VALUES ('Pastel de Calabresa', 1);
INSERT INTO tamanhosProdutos (produto_id, tamanho_id, preco) VALUES (4, 1, 5.50);
INSERT INTO itensPedidos (pedido_id, produto_id, quantidade) VALUES (5, 4, 2);

-- Excluir item de pedido (deve acionar o trigger, excluir o item e atualizar o status do pedido)
DELETE FROM itensPedidos WHERE pedido_id = 5;

-- Verificar se o status do pedido foi atualizado corretamente
SELECT status_pedido FROM pedidos WHERE pedido_id = 5;

