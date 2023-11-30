-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS Canto_dos_Pasteis;

USE Canto_dos_Pasteis;

-- Criação da tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome_completo VARCHAR(100),
    nome_chamado VARCHAR(50),
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    telefone VARCHAR(15),
    email VARCHAR(100)
);


-- Criação da tabela de endereços
CREATE TABLE IF NOT EXISTS enderecos (
    endereco_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cliente_id INT NOT NULL,
    bairro VARCHAR(50),
    numero VARCHAR(50),
    rua VARCHAR(50),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    CONSTRAINT fk_cliente_endereco FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Criação da tabela de categorias
CREATE TABLE IF NOT EXISTS categorias (
    categoria_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(50)
);

-- Criação da tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (   
    produto_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    categoria_id INT NOT NULL,
    nome VARCHAR(50),
    CONSTRAINT fk_categoria_produto FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

-- Criação da tabela tamanho dos produtos
CREATE TABLE IF NOT EXISTS tamanhos (  
    tamanho_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    tamanho VARCHAR(100)
);

-- Criação da tabela onde vai ser definido o preço pelo o tamanho dos produtos 
CREATE TABLE IF NOT EXISTS tamanhosProdutos (   
    tamanhopasteis_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    produto_id INT NOT NULL,
    tamanho_id INT NOT NULL,
    preco DECIMAL(10, 2), 
    CONSTRAINT fk_produto_tamanhoproduto FOREIGN KEY (produto_id) REFERENCES produtos(produto_id),
    CONSTRAINT fk_tamanho_tamanhoproduto FOREIGN KEY (tamanho_id) REFERENCES tamanhos(tamanho_id)
);

-- Criação da tabela dos ingredientes do recheio
CREATE TABLE IF NOT EXISTS recheios (
    recheio_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    recheio VARCHAR(50)
);

-- Criação da tabela do recheio
CREATE TABLE IF NOT EXISTS recheiosProdutos(
    recheiopasteis_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    produto_id INT NOT NULL,
    recheio_id INT NOT NULL,
    CONSTRAINT fk_produto_recheiosproduto FOREIGN KEY (produto_id ) REFERENCES produtos(produto_id ),
    CONSTRAINT fk_recheio_recheiosproduto FOREIGN KEY (recheio_id) REFERENCES recheios(recheio_id)
);

-- Criação da tabela pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cliente_id INT NOT NULL,
    data_pedido DATETIME DEFAULT NOW(),
    forma_pagamento ENUM('D','PIX','CC','CD') NOT NULL DEFAULT 'D',
    CONSTRAINT fk_clientes FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Criação da tabela itens do pedido
CREATE TABLE IF NOT EXISTS itensPedidos (
    item_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    CONSTRAINT fk_pedidos FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    CONSTRAINT fk_produto_itenspedidos FOREIGN KEY (produto_id) REFERENCES produtos(produto_id) 
);

-- Inserir dados na tabela 'clientes'
INSERT INTO clientes (nome_completo, nome_chamado, cpf, data_nascimento, telefone, email)
VALUES
	('João Silva', 'João', '123.456.789-01', '1990-05-15', '(11) 98765-4321', 'joao.silva@email.com'),
	('Maria Oliveira', 'Maria', '987.654.321-09', '1985-12-10', '(21) 99876-5432', 'maria.oliveira@email.com'),
	('Carlos Santos', 'Carlos', '345.678.901-23', '1998-08-22', '(31) 91234-5678', 'carlos.santos@email.com'),
    ('Fernanda Pereira', 'Fernanda', '567.890.123-45', '1995-02-28', '(41) 87654-3210', 'fernanda.pereira@email.com'),
    ('Ricardo Oliveira', 'Ricardo', '789.012.345-67', '1980-11-05', '(51) 76543-2109', 'ricardo.oliveira@email.com'),
    ('Ana Lima', 'Ana', '012.345.678-90', '1992-08-18', '(12) 98765-4321', 'ana.lima@email.com'),
    ('Lucas Santos', 'Lucas', '234.567.890-12', '1987-03-25', '(22) 99876-5432', 'lucas.santos@email.com'),
    ('Julia Pereira', 'Julia', '456.789.012-34', '1996-12-05', '(32) 91234-5678', 'julia.pereira@email.com');

    
    SELECT * FROM clientes;

-- Inserir dados na tabela 'enderecos'
INSERT INTO enderecos (cliente_id, bairro, numero, rua, cidade, estado)
VALUES 
    (1, 'Centro', '123', 'Rua A', 'São Paulo', 'SP'),
    (2, 'Vila Madalena', '456', 'Rua B', 'São Paulo', 'SP'),
    (3, 'Itaim Bibi', '789', 'Rua C', 'São Paulo', 'SP'),
    (4, 'Jardins', '101', 'Avenida X', 'São Paulo', 'SP'),
    (5, 'Boa Viagem', '567', 'Rua Y', 'Recife', 'PE'),
	(6, 'Feira X', '345', 'Rua D', 'Feira de Santana', 'BA'),
    (7, 'Muchila', '678', 'Rua E', 'Feira de Santana', 'BA'),
    (8, 'Getúlio Vargas', '910', 'Rua F', 'Feira de Santana', 'BA');
    
    SELECT * FROM enderecos;

-- Inserir dados na tabela 'categorias'
INSERT INTO categorias (nome)
VALUES 
    ('Normal'),
	('Vegano'),
	('Vegetariano'),
	('Sem Lactose'),
    ('Bebidas'),
    ('Personalizado'),
    ('Outros Produtos');
    
    SELECT * FROM categorias;


-- Inserir dados na tabela 'produtos'
INSERT INTO produtos (categoria_id, nome)
VALUES 
    (1, 'Pastel de Carne'),
	(2, 'Pastel Vegano de Espinafre'),
	(3, 'Pastel Vegetariano de Palmito'),
	(4, 'Pastel Sem Lactose de Frango'),
	(5, 'Refrigerante'),
	(5, 'Suco'),
	(5, 'Água'),
    (1, 'Pastel de Queijo'),
    (2, 'Pastel Vegano de Couve-flor'),
    (3, 'Pastel Vegetariano de Abobrinha'),
    (4, 'Pastel Sem Lactose de Cogumelos'),
	(1, 'Pastel de Frango'),
    (1, 'Pastel de Queijo com Presunto'),
    (2, 'Pastel Vegano de Tofu'),
    (3, 'Pastel Vegetariano de Abobrinha com Ricota'),
	(1, 'Pastel Personalizado'),
	(1, 'Pastel de Carne com Bacon'),
    (2, 'Pastel Vegano de Batata Doce'),
    (3, 'Pastel Vegetariano de Brócolis'),
    (4, 'Pastel Sem Lactose de Peito de Peru'),
    (5, 'Cerveja'),
    (5, 'Café'),
    (5, 'Chá'),
    (1, 'Pastel de Frango com Catupiry'),
    (2, 'Pastel Vegano de Beterraba'),
    (3, 'Pastel Vegetariano de Pimentão'),
    (4, 'Pastel Sem Lactose de Salmão'),
    (1, 'Pastel de Carne com Queijo'),
    (1, 'Pastel de Frango com Milho'),
    (2, 'Pastel Vegano de Abacate'),
    (3, 'Pastel Vegetariano de Aspargos');

    
    SELECT * FROM produtos;
    
-- Inserir dados na tabela 'tamanhos'
INSERT INTO tamanhos (tamanho)
VALUES 
    ('Pequeno'),
    ('Médio'),
    ('Grande');

    SELECT * FROM tamanhos;


-- Inserir dados na tabela 'tamanhosProdutos'
INSERT INTO tamanhosProdutos (produto_id, tamanho_id, preco)
VALUES 
	(1, 1, 5.00),
	(2, 2, 6.50),
    (3, 3, 7.00),
    (4, 2, 6.00),
	(5, 1, 4.00), -- Refrigerante, tamanho pequeno
	(5, 2, 6.00), -- Refrigerante, tamanho médio
	(5, 3, 8.00), -- Refrigerante, tamanho grande
	(6, 1, 5.00), -- Suco, tamanho pequeno
	(6, 2, 7.00), -- Suco, tamanho médio
	(6, 3, 9.00), -- Suco, tamanho grande
	(7, 1, 2.00), -- Água, tamanho pequeno
	(7, 2, 3.00), -- Água, tamanho médio
	(7, 3, 4.00), -- Água, tamanho grande
	(8, 1, 6.00),
	(9, 2, 7.50),
    (10, 3, 8.00),
	(11, 1, 6.50),
	(12, 2, 8.00),
    (13, 3, 8.50),
    (14, 2, 7.00),
	(15, 1, 5.00),
	(15, 2, 7.00),
    (15, 3, 9.00),
	(16, 1, 7.50),
    (17, 2, 8.00),
    (18, 3, 9.00),
    (19, 1, 7.00),
    (20, 2, 8.50),
    (21, 3, 10.00),
    (22, 1, 6.50),
    (23, 2, 7.50),
    (24, 3, 9.50),
    (25, 1, 8.00),
    (26, 2, 9.00),
    (27, 3, 10.50);
    
    SELECT * FROM tamanhosProdutos;


-- Inserir dados na tabela 'recheios'
INSERT INTO recheios (recheio)
VALUES 
    ('Bacon'),
    ('Queijo'),
    ('Frango'),
    ('Espinafre'),
    ('Calabresa'),
    ('Chocolate'),
    ('Presunto'),
    ('Ricota'),
    ('Cogumelos'),
    ('Tofu'),
    ('Palmito'),
    ('Abobrinha'),
    ('Batata Doce'),
    ('Brócolis'),
    ('Peito de Peru'),
    ('Salmão'),
    ('Catupiry'),
    ('Beterraba'),
    ('Pimentão'),
    ('Milho'),
    ('Abacate'),
    ('Aspargos');
    
    SELECT * FROM recheios;


-- Inserir dados na tabela 'recheiosProdutos'
INSERT INTO recheiosProdutos (produto_id, recheio_id)
VALUES 
	(1, 1),
	(1, 2),
	(2, 4),
	(3, 2),
	(3, 3),
	(4, 3),
	(8, 2),
	(8, 3),
	(9, 4),
	(9, 5),
	(10, 6),
	(10, 7),
	(11, 2),
	(11, 3),
	(12, 4),
	(12, 9),
	(13, 10),
	(13, 11),
	(14, 9),
	(14, 10),
	(15, 2),
	(15, 3),
	(15, 4),
	(15, 9),
	(15, 10),
	(16, 1),
    (16, 2),
    (17, 4),
    (18, 3),
    (18, 5),
    (19, 6),
    (19, 7),
    (19, 8),
    (20, 9),
    (20, 10),
    (21, 11),
    (21, 12),
    (22, 2),
    (22, 3),
    (23, 4),
    (23, 9),
    (24, 10),
    (24, 11),
    (25, 2),
    (25, 3),
    (26, 4),
    (26, 13),
    (27, 14),
    (27, 15),
    (27, 16),
    (27, 21);
    
    SELECT * FROM recheiosProdutos;


-- Inserir dados na tabela 'pedidos'
INSERT INTO pedidos (cliente_id, forma_pagamento)
VALUES 

    (1, 'PIX'),
    (2, 'CC'),
    (3, 'D'),
    (1, 'CC'),
    (2, 'PIX'),
    (4, 'PIX'),
    (5, 'D'),
    (4, 'CC'),
    (5, 'PIX'),
    (1, 'D'),
    (2, 'PIX'),
    (3, 'CC'),
    (1, 'PIX'),
	(6, 'CC'),
    (7, 'PIX'),
    (8, 'D'),
    (6, 'CC'),
    (7, 'PIX'),
    (6, 'PIX'),
    (4, 'D'),
    (1, 'CC'),
    (8, 'PIX'),
    (6, 'D'),
    (7, 'PIX'),
    (8, 'CC'),
    (6, 'PIX'),
    (5, 'CD');
    
    SELECT * FROM pedidos;


-- Inserir dados na tabela 'itensPedidos'
INSERT INTO itensPedidos (pedido_id, produto_id, quantidade)
VALUES 
   (1, 1, 2),
   (1, 2, 1),
   (2, 3, 3),
   (3, 4, 2),
   (4, 1, 1),
   (4, 5, 1),
   (5, 2, 2),
   (5, 5, 1),
   (6, 8, 3),
   (7, 9, 2),
   (8, 10, 1),
   (9, 8, 2),
   (9, 9, 1),
   (9, 10, 3),
   (10, 11, 2),
   (10, 12, 1),
   (11, 13, 3),
   (12, 14, 2),
   (13, 15, 2),
   (14, 16, 2),
   (14, 17, 1),
   (15, 18, 3),
   (16, 19, 2),
   (17, 16, 1),
   (17, 20, 1),
   (18, 17, 2),
   (18, 20, 1),
   (19, 21, 3),
   (20, 22, 2),
   (21, 23, 1),
   (21, 24, 2),
   (22, 25, 2),
   (23, 26, 1),
   (24, 27, 3);
   
    SELECT * FROM itensPedidos;
    
    
-- Liste os nomes de todos os pastéis veganos vendidos para pessoas com mais de 18 anos

SELECT DISTINCT p.nome
FROM clientes c
JOIN pedidos ped ON c.cliente_id = ped.cliente_id
JOIN itensPedidos itp ON ped.pedido_id = itp.pedido_id
JOIN produtos p ON itp.produto_id = p.produto_id
JOIN categorias cat ON p.categoria_id = cat.categoria_id
JOIN tamanhosProdutos tp ON p.produto_id = tp.produto_id
JOIN tamanhos t ON tp.tamanho_id = t.tamanho_id
WHERE c.data_nascimento < CURDATE() - INTERVAL 18 YEAR
AND cat.nome = 'Vegano';
  
  
  -- Liste os clientes com maior número de pedidos realizados em 1 ano agrupados por mês
  
SELECT
CONCAT(MONTH(pe.data_pedido), '/', YEAR(pe.data_pedido)) AS mes_ano,
c.nome_completo,
COUNT(pe.pedido_id) AS numero_pedidos
FROM pedidos pe
JOIN clientes c ON pe.cliente_id = c.cliente_id
WHERE pe.data_pedido >= CURDATE() - INTERVAL 1 YEAR
GROUP BY mes_ano, c.nome_completo
ORDER BY numero_pedidos DESC;


-- Liste todos os pastéis que possuem bacon ou queijo em seu recheio

SELECT DISTINCT p.nome
FROM produtos p
JOIN recheiosProdutos rp ON p.produto_id = rp.produto_id
JOIN recheios r ON rp.recheio_id = r.recheio_id
WHERE r.recheio IN ('Bacon', 'Queijo');


-- Mostre o valor de venda total de todos os pastéis cadastrados no sistema

SELECT SUM(tp.preco * ip.quantidade) AS valor_total
FROM tamanhosProdutos tp
JOIN itensPedidos ip ON tp.produto_id = ip.produto_id;

-- Liste todos os pedidos onde há pelo menos um pastel e uma bebida

SELECT DISTINCT ped.pedido_id, ped.data_pedido, ped.forma_pagamento
FROM pedidos ped
JOIN itensPedidos itp ON ped.pedido_id = itp.pedido_id
JOIN produtos p ON itp.produto_id = p.produto_id
JOIN categorias cat ON p.categoria_id = cat.categoria_id
WHERE cat.nome IN ('Pasteis', 'Bebidas');


-- Liste quais são os pastéis mais vendidos, incluindo a quantidade de vendas em ordem crescente

SELECT p.nome, SUM(ip.quantidade) AS quantidade_vendas
FROM produtos p
JOIN itensPedidos ip ON p.produto_id = ip.produto_id
GROUP BY p.nome
ORDER BY quantidade_vendas ASC;


DROP DATABASE Canto_dos_Pasteis;
