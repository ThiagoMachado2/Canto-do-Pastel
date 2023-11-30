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


-- 3 = Trigger para liberar ingredientes quando houver um pedido cancelado

DELIMITER //
CREATE TRIGGER BeforeDeletePedidoLiberaIngredientes
BEFORE DELETE ON pedidos
FOR EACH ROW
BEGIN
    -- Liberar os ingredientes associados aos itens do pedido
    DECLARE produto_id_temp INT;
    DECLARE quantidade_temp INT;

    -- Cursor para obter os itens do pedido que serão excluídos
    DECLARE cursor_itens_pedido CURSOR FOR
        SELECT ip.produto_id, ip.quantidade
        FROM itensPedidos ip
        WHERE ip.pedido_id = OLD.pedido_id;

    -- Loop através dos itens do pedido
    OPEN cursor_itens_pedido;
    read_loop: LOOP
        FETCH cursor_itens_pedido INTO produto_id_temp, quantidade_temp;
        IF quantity_temp IS NULL THEN
            LEAVE read_loop;
        END IF;

        -- Atualizar a quantidade disponível de ingredientes no estoque
        UPDATE ingredientes i
        SET i.quantidade_disponivel = i.quantidade_disponivel + quantidade_temp
        WHERE i.produto_id = produto_id_temp;
    END LOOP;
    CLOSE cursor_itens_pedido;
END;
//
DELIMITER ;

-- Este trigger liberará automaticamente os ingredientes de um pedido caso ele seja cancelado
