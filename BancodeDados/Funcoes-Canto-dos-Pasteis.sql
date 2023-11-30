DELIMITER //

-- Função Buscar Cliente Por Nome
CREATE FUNCTION BuscarClientePorNome(nome_cliente VARCHAR(100))
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(100);

    SELECT GROUP_CONCAT(nome_completo) INTO resultado
    FROM clientes
    WHERE nome_completo LIKE CONCAT('%', nome_cliente, '%');

    RETURN resultado;
END //

DELIMITER ;

SELECT BuscarClientePorNome('João') AS clientes_encontrados;



DELIMITER //

-- Função Calcular Valor Total Pedido
CREATE FUNCTION CalcularValorTotalPedido(pedido_id INT)
RETURNS DECIMAL(10, 2) DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);

    SELECT SUM(tamanhosProdutos.preco * itensPedidos.quantidade) INTO total
    FROM itensPedidos
    JOIN tamanhosProdutos ON itensPedidos.produto_id = tamanhosProdutos.produto_id
    WHERE itensPedidos.pedido_id = pedido_id;

    RETURN total;
END //

DELIMITER ;

SELECT CalcularValorTotalPedido(1) AS ValorTotalPedido;



DELIMITER //

-- Função Obter Produtos Em Pedido
CREATE FUNCTION obterProdutosEmPedido(idPedido INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE nomesProdutos VARCHAR(255);
    SELECT GROUP_CONCAT(nome SEPARATOR ', ') INTO nomesProdutos
    FROM produtos
    WHERE produto_id IN (SELECT produto_id FROM itensPedidos WHERE pedido_id = idPedido);
    RETURN nomesProdutos;
END //

DELIMITER ;

SELECT obterProdutosEmPedido(1);


