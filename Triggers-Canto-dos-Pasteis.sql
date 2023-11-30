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


