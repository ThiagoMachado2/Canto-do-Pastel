CREATE DATABASE IF NOT EXISTS Canto_dos_Pasteis;

USE Canto_dos_Pasteis;

CREATE TABLE IF NOT EXISTS Clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome_completo VARCHAR(100),
    nome_chamado VARCHAR(50),
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Enderecos (
    endereco_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    bairro VARCHAR(50),
    rua VARCHAR(50),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    CONSTRAINT fk_cliente_endereco FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE IF NOT EXISTS Bebidas (
    bebida_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    preco DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS Pasteis (
    pastel_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    preco DECIMAL(10, 2),
    categoria VARCHAR(20)
);


CREATE TABLE IF NOT EXISTS Tamanhos (
    tamanho_id INT PRIMARY KEY AUTO_INCREMENT,
    pasteis_id INT,
    recheio_id INT,
    nome VARCHAR(50),
    tamanho VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS TamanhosPasteis (
    tamanhopasteis_id INT PRIMARY KEY AUTO_INCREMENT,
    pastel_id INT,
    tamanho_id INT,
    nome VARCHAR(50),
    CONSTRAINT fk_pasteis_tamanhopasteis FOREIGN KEY (pastel_id) REFERENCES Pasteis(pastel_id),
    CONSTRAINT fk_tamanho_tamanhopasteis FOREIGN KEY (tamanho_id) REFERENCES Tamanhos(tamanho_id)
);


CREATE TABLE IF NOT EXISTS Recheios (
    recheio_id INT PRIMARY KEY AUTO_INCREMENT,
    pastel_id INT,
    nome VARCHAR(50),
    CONSTRAINT fk_pasteis FOREIGN KEY (pastel_id) REFERENCES Pasteis(pastel_id)
);

CREATE TABLE IF NOT EXISTS Pedidos (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    data_pedido DATE,
    forma_pagamento VARCHAR(20),
    CONSTRAINT fk_clientes FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE IF NOT EXISTS ItensPedido (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    pastel_id INT,
    bebida_id INT,
    quantidade INT,
    CONSTRAINT fk_bebidas_pedido FOREIGN KEY (bebida_id) REFERENCES Bebidas(bebida_id),
    CONSTRAINT fk_pedidos FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    CONSTRAINT fk_pasteis_pedido FOREIGN KEY (pastel_id) REFERENCES Pasteis(pastel_id)
);

INSERT INTO Enderecos (bairro, rua, cidade, estado) VALUES
('Centro','Rua A' ,'Cidade A', 'SP'),
('Bairro1','Rua B' , 'Cidade B', 'RJ'),
('Bairro2','Rua C' , 'Cidade C', 'MG'),
('Bairro3','Rua D' , 'Cidade D', 'RS'),
('Bairro4','Rua E' , 'Cidade E', 'SC'),
('Bairro5','Rua F' , 'Cidade F', 'PR'),
('Bairro6', 'Rua X', 'Cidade G', 'SP'),
('Bairro7', 'Rua Y', 'Cidade H', 'RJ'),
('Bairro8', 'Rua Z', 'Cidade I', 'MG');

SELECT * FROM Enderecos;

INSERT INTO Clientes (nome_completo, nome_chamado, cpf, data_nascimento, telefone, email) VALUES
('João Silva', 'João', '123.456.789-01', '1990-01-15', '(11) 98765-4321', 'joao@email.com'),
('Maria Oliveira', 'Maria', '987.654.321-02', '1985-05-20', '(21) 98765-1234', 'maria@email.com'),
('Carlos Pereira', 'Carlos', '111.222.333-44', '1988-11-10', '(31) 99999-8888', 'carlos@email.com'),
('Ana Pereira', 'Ana', '555.666.777-88', '1980-06-25', '(41) 98765-4321', 'ana@email.com'),
('Lucas Oliveira', 'Lucas', '999.888.777-66', '1995-12-10', '(48) 99999-1234', 'lucas@email.com'),
('Mariana Santos', 'Mariana', '444.333.222-11', '1982-03-18', '(51) 98765-9876', 'mariana@email.com'),
('Fernanda Souza', 'Fernanda', '777.888.999-10', '1983-08-22', '(11) 98765-4321', 'fernanda@email.com'),
('Gabriel Lima', 'Gabriel', '666.555.444-33', '1992-05-15', '(21) 98765-1234', 'gabriel@email.com'),
('Amanda Oliveira', 'Amanda', '222.333.444-55', '2010-12-10', '(31) 99999-8888', 'amanda@email.com');

SELECT * FROM Clientes;


INSERT INTO Pasteis (nome, preco, categoria) VALUES
('Pastel Vegano', 8.50,'Vegano'),
('Pastel de Queijo', 5.00,'Normal'),
('Pastel de Bacon', 6.00,'Normal'),
('Pastel de Frango', 7.00,'Normal'),
('Pastel de Calabresa', 6.50,'Normal'),
('Pastel de Palmito', 7.50,'Vegetariano'),
('Pastel de Espinafre', 8.00,'Vegetariano'),
('Pastel de Berinjela', 7.00,'Vegetariano'),
('Pastel de Abóbora', 6.50,'Vegano'),
('Pastel de Lentilha', 7.00,'Vegano'),
('Pastel de Grão-de-bico', 6.50,'Vegano');

SELECT * FROM Pasteis;

INSERT INTO Recheios (nome) VALUES
('Recheio Vegano'),
('Queijo'),
('Bacon'),
('Frango'),
('Calabresa'),
('Chocolate'),
('Milho'),
('Palmito'),
('Espinafre'),
('Berinjela'),
('Abóbora'),
('Lentilha'),
('Grão-de-bico');

SELECT * FROM Recheios;

INSERT INTO Pedidos (cliente_id, data_pedido, forma_pagamento) VALUES
(1, '2023-01-05', 'Cartão Credito'),
(2, '2023-02-15', 'Dinheiro'),
(3, '2023-03-20', 'Cartão Debito'),
(4, '2023-04-10', 'Cartão Debito'),
(5, '2023-05-20', 'Dinheiro'),
(6, '2023-06-15', 'Cartão Credito'),
(7, '2023-07-05', 'Dinheiro'),
(8, '2023-08-12', 'Cartão Credito'),
(9, '2023-09-18', 'Dinheiro');

SELECT * FROM Pedidos;

INSERT INTO Bebidas (nome, preco) VALUES
('Suco de Laranja', 4.50),
('Refrigerante', 3.00),
('Água Mineral', 2.00);

SELECT * FROM Bebidas;

INSERT INTO ItensPedido (pedido_id, pastel_id, bebida_id, quantidade) VALUES
(1, 1, 2, 2),
(2, 2, 1, 1),
(3, 3, 3, 3),
(4, 4, 1, 2),
(5, 5, 2, 1),
(6, 6, 3, 3),
(7, 7, NULL, 2),
(8, 8, NULL, 1),
(9, 9, NULL, 3);

SELECT * FROM ItensPedido;



-- consulta 1: listar nomes de pastéis veganos vendidos para pessoas com mais de 18 anos
SELECT P.nome
FROM Pasteis P
JOIN Recheios R ON P.pastel_id = R.pastel_id
JOIN ItensPedido IP ON P.pastel_id = IP.pastel_id
JOIN Pedidos PE ON IP.pedido_id = PE.pedido_id
JOIN Clientes C ON PE.cliente_id = C.cliente_id
WHERE P.categoria = 'Vegano' AND DATEDIFF(CURDATE(), C.data_nascimento) > 6570; -- 6570 dias ≈ 18 anos

-- consulta 2: listar clientes com maior número de pedidos realizados em 1 ano agrupados por mês
SELECT DATE_FORMAT(PE.data_pedido, '%m-%Y') AS mes_ano, C.nome_completo, COUNT(PE.pedido_id) AS num_pedidos
FROM Pedidos PE
JOIN Clientes C ON PE.cliente_id = C.cliente_id
WHERE YEAR(PE.data_pedido) = YEAR(CURDATE())
GROUP BY mes_ano, C.nome_completo
ORDER BY num_pedidos DESC;

-- consulta 3: listar todos os pastéis que possuem bacon e queijo em seu recheio
SELECT P.nome
FROM Pasteis P
JOIN Recheios R ON P.pastel_id = R.pastel_id
WHERE R.nome = 'Bacon' OR R.nome = 'Queijo';

-- consulta 4: mostrar o valor de venda total de todos os pastéis cadastrados no sistema
SELECT SUM(P.preco) AS valor_total
FROM Pasteis P;

-- consulta 5: listar todos os pedidos onde há pelo menos um pastel e uma bebida
SELECT DISTINCT PE.pedido_id
FROM Pedidos PE
JOIN ItensPedido IP ON PE.pedido_id = IP.pedido_id
LEFT JOIN Pasteis P ON IP.pastel_id = P.pastel_id
LEFT JOIN Bebidas B ON IP.bebida_id = B.bebida_id
WHERE P.pastel_id IS NOT NULL OR B.bebida_id IS NOT NULL;

-- consulta 6: listar quais são os pastéis mais vendidos, incluindo a quantidade de vendas em ordem crescente
SELECT P.nome, COUNT(IP.pastel_id) AS quantidade_vendas
FROM Pasteis P
JOIN ItensPedido IP ON P.pastel_id = IP.pastel_id
GROUP BY P.nome
ORDER BY quantidade_vendas ASC;

