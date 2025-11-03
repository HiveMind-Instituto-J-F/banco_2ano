


----------------------------------------Tabela de Trabalhador----------------------------------
CREATE TABLE trabalhador (
    id_trabalhador INT PRIMARY KEY,
    des_tipo_perfil VARCHAR(50),
    des_login VARCHAR(50),
    des_senha VARCHAR(100),
    des_setor VARCHAR(50),
    des_imagem VARCHAR(255)
);

------------------------------------------Tabela de Máquina------------------------------------
CREATE TABLE maquina (
    id_maquina INT PRIMARY KEY,
    des_nome VARCHAR(100),
    des_tipo VARCHAR(50),
    des_setor VARCHAR(50),
    des_maquina TEXT,
    des_status_operacional VARCHAR(50)
);

-- Manutenção
CREATE TABLE manutencao (
    id_manutencao INT PRIMARY KEY,
    id_maquina INT,
    id_usuario INT,
    des_acao_realizada TEXT,
	des_setor VARCHAR(50),
    hora_inicio TIME,
    hora_fim TIME,
	dt_manutencao DATE,
    FOREIGN KEY (id_maquina) REFERENCES maquina(id_maquina),
    FOREIGN KEY (id_usuario) REFERENCES trabalhador(id_trabalhador)
);

--------------------------------Tabela de registro de paradas----------------------------------
CREATE TABLE registro_paradas (
    id_registro_paradas INT PRIMARY KEY,
    hora_inicio TIME,
    hora_fim TIME,
    id_maquina INT,
    id_manutencao INT,
    id_usuario INT,
    dt_parada DATE,
    des_setor VARCHAR(50),
    des_parada TEXT
);

---------------------------------------Tabela de Login-----------------------------------------
CREATE TABLE login (
    id_login INT PRIMARY KEY,
    des_cnpj VARCHAR(20),
    des_senha VARCHAR(100),
    des_cadastrante VARCHAR(100),
    des_email VARCHAR(100)
);

----------------------------------------------DAU----------------------------------------------
CREATE TABLE logins_realizados (
    id_login SERIAL PRIMARY KEY,
    id_trabalhador INT NOT NULL,
    data_login TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (id_trabalhador) REFERENCES trabalhador(id_trabalhador)
);

CREATE TABLE dau (
    id_dau SERIAL PRIMARY KEY,
    id_trabalhador INT NOT NULL,
    data_acesso DATE DEFAULT CURRENT_DATE,
    UNIQUE (id_trabalhador, data_acesso),
    FOREIGN KEY (id_trabalhador) REFERENCES trabalhador(id_trabalhador)
);


CREATE OR REPLACE FUNCTION fn_atualizar_dau()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO dau (id_trabalhador)
    VALUES (NEW.id_trabalhador)
    ON CONFLICT (id_trabalhador, data_acesso) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_dau
AFTER INSERT ON logins_realizados
FOR EACH ROW
EXECUTE FUNCTION fn_atualizar_dau();



------------------------------------------INDEXs-----------------------------------------------


create index id_registro_paradas on registro_paradas(id_registro_paradas);
create index id_login on login(id_login);
create index id_manutencao on manutencao(id_manutencao);
create index id_trabalhador on trabalhador(id_trabalhador);
create index id_maquina on maquina(id_maquina);