USE SeguroSmartphone;
GO

-- =============================================
-- 1. TABELA: cliente
-- =============================================

CREATE TABLE dbo.cliente
(
    cd_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nm_cliente VARCHAR(100) NOT NULL,
    nr_cpf CHAR(11) NOT NULL UNIQUE,
    ds_email VARCHAR(100) NOT NULL,
    nr_telefone VARCHAR(15) NOT NULL,
    dt_nascimento DATE NOT NULL,
    dt_cadastro DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- =============================================
-- 2. TABELA: fabricante
-- =============================================

CREATE TABLE dbo.fabricante
(
    cd_fabricante TINYINT IDENTITY(1,1) PRIMARY KEY,
    nm_fabricante VARCHAR(50) NOT NULL UNIQUE
);
GO


-- =============================================
-- 3. TABELA: modelo_aparelho
-- =============================================

CREATE TABLE dbo.modelo_aparelho
(
    cd_modelo SMALLINT IDENTITY(1,1) PRIMARY KEY,
    cd_fabricante TINYINT NOT NULL,
    nm_modelo VARCHAR(80) NOT NULL,
    vl_mercado_referencia DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_modelo_fabricante
        FOREIGN KEY (cd_fabricante)
        REFERENCES dbo.fabricante(cd_fabricante),

    CONSTRAINT CK_modelo_valor
        CHECK (vl_mercado_referencia > 0)
);
GO

-- =============================================
-- 4. TABELA: aparelho_segurado
-- =============================================

CREATE TABLE dbo.aparelho_segurado
(
    cd_aparelho INT IDENTITY(1,1) PRIMARY KEY,
    cd_cliente INT NOT NULL,
    cd_modelo SMALLINT NOT NULL,
    nr_imei CHAR(15) NOT NULL UNIQUE,
    nr_serie VARCHAR(30) NULL,
    dt_aquisicao DATE NOT NULL,
    vl_nota_fiscal DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_aparelho_cliente
        FOREIGN KEY (cd_cliente)
        REFERENCES dbo.cliente(cd_cliente),

    CONSTRAINT FK_aparelho_modelo
        FOREIGN KEY (cd_modelo)
        REFERENCES dbo.modelo_aparelho(cd_modelo),

    CONSTRAINT CK_aparelho_valor
        CHECK (vl_nota_fiscal > 0)
);
GO

CREATE NONCLUSTERED INDEX idx_aparelho_modelo
ON dbo.aparelho_segurado(cd_modelo);
GO

-- =============================================
-- 5. TABELA: plano_seguro
-- =============================================

CREATE TABLE dbo.plano_seguro
(
    cd_plano TINYINT IDENTITY(1,1) PRIMARY KEY,
    nm_plano VARCHAR(50) NOT NULL,
    ds_descricao VARCHAR(200) NOT NULL,
    pc_franquia DECIMAL(5,2) NOT NULL DEFAULT 15.00,
    fl_ativo BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_plano_franquia
        CHECK (pc_franquia BETWEEN 0 AND 100)
);
GO

-- =============================================
-- 6. TABELA: cobertura
-- =============================================

CREATE TABLE dbo.cobertura
(
    cd_cobertura TINYINT IDENTITY(1,1) PRIMARY KEY,
    nm_cobertura VARCHAR(60) NOT NULL,
    ds_cobertura VARCHAR(255) NOT NULL
);
GO

-- =============================================
-- 7. TABELA: plano_cobertura
-- =============================================

CREATE TABLE dbo.plano_cobertura
(
    cd_plano TINYINT NOT NULL,
    cd_cobertura TINYINT NOT NULL,
    vl_limite_indenizacao DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_plano_cobertura
        PRIMARY KEY (cd_plano, cd_cobertura),

    CONSTRAINT FK_plano_cobertura_plano
        FOREIGN KEY (cd_plano)
        REFERENCES dbo.plano_seguro(cd_plano),

    CONSTRAINT FK_plano_cobertura_cobertura
        FOREIGN KEY (cd_cobertura)
        REFERENCES dbo.cobertura(cd_cobertura),

    CONSTRAINT CK_plano_cobertura_limite
        CHECK (vl_limite_indenizacao > 0)
);
GO

-- =============================================
-- 8. TABELA: apolice
-- =============================================

CREATE TABLE dbo.apolice
(
    cd_apolice INT IDENTITY(1,1) PRIMARY KEY,
    cd_cliente INT NOT NULL,
    cd_aparelho INT NOT NULL,
    cd_plano TINYINT NOT NULL,
    dt_emissao DATETIME NOT NULL DEFAULT GETDATE(),
    dt_inicio_vigencia DATE NOT NULL,
    dt_fim_vigencia DATE NOT NULL,
    vl_franquia DECIMAL(10,2) NOT NULL DEFAULT 0,
    vl_premio_total DECIMAL(10,2) NOT NULL,
    st_apolice TINYINT NOT NULL DEFAULT 1,

    CONSTRAINT FK_apolice_cliente
        FOREIGN KEY (cd_cliente)
        REFERENCES dbo.cliente(cd_cliente),

    CONSTRAINT FK_apolice_aparelho
        FOREIGN KEY (cd_aparelho)
        REFERENCES dbo.aparelho_segurado(cd_aparelho),

    CONSTRAINT FK_apolice_plano
        FOREIGN KEY (cd_plano)
        REFERENCES dbo.plano_seguro(cd_plano),

    CONSTRAINT CK_apolice_vigencia
        CHECK (dt_fim_vigencia > dt_inicio_vigencia),

    CONSTRAINT CK_apolice_premio
        CHECK (vl_premio_total > 0)
);
GO

CREATE NONCLUSTERED INDEX idx_apolice_plano
ON dbo.apolice(cd_plano);
GO

CREATE NONCLUSTERED INDEX idx_apolice_status_aparelho
ON dbo.apolice(st_apolice, cd_aparelho);
GO

-- =============================================
-- 9. TABELA: parcela_apolice
-- =============================================

CREATE TABLE dbo.parcela_apolice
(
    cd_parcela INT IDENTITY(1,1) PRIMARY KEY,
    cd_apolice INT NOT NULL,
    nr_parcela TINYINT NOT NULL,
    dt_vencimento DATE NOT NULL,
    vl_parcela DECIMAL(10,2) NOT NULL,
    dt_pagamento DATE NULL,
    st_pagamento TINYINT NOT NULL DEFAULT 0,

    CONSTRAINT FK_parcela_apolice
        FOREIGN KEY (cd_apolice)
        REFERENCES dbo.apolice(cd_apolice),

    CONSTRAINT CK_parcela_numero
        CHECK (nr_parcela BETWEEN 1 AND 12),

    CONSTRAINT CK_parcela_valor
        CHECK (vl_parcela > 0)
);
GO

CREATE NONCLUSTERED INDEX idx_parcela_status
ON dbo.parcela_apolice(st_pagamento);
GO

-- =============================================
-- 10. TABELA: assistencia_tecnica
-- =============================================

CREATE TABLE dbo.assistencia_tecnica
(
    cd_assistencia SMALLINT IDENTITY(1,1) PRIMARY KEY,
    nm_razao_social VARCHAR(120) NOT NULL,
    nr_cnpj CHAR(14) NOT NULL UNIQUE,
    nr_telefone VARCHAR(15) NOT NULL,
    ds_cidade VARCHAR(60) NOT NULL,
    sg_uf CHAR(2) NOT NULL,
    fl_ativa BIT NOT NULL DEFAULT 1
);
GO

-- =============================================
-- 11. TABELA: sinistro
-- =============================================

CREATE TABLE dbo.sinistro
(
    cd_sinistro INT IDENTITY(1,1) PRIMARY KEY,
    cd_apolice INT NOT NULL,
    cd_cobertura TINYINT NOT NULL,
    cd_assistencia SMALLINT NULL,
    dt_ocorrencia DATETIME NOT NULL,
    dt_aviso DATETIME NOT NULL DEFAULT GETDATE(),
    ds_relato_ocorrencia VARCHAR(1000) NOT NULL,
    vl_prejuizo_estimado DECIMAL(10,2) NOT NULL,
    vl_franquia_paga DECIMAL(10,2) NOT NULL DEFAULT 0,
    st_sinistro TINYINT NOT NULL DEFAULT 1,

    CONSTRAINT FK_sinistro_apolice
        FOREIGN KEY (cd_apolice)
        REFERENCES dbo.apolice(cd_apolice),

    CONSTRAINT FK_sinistro_cobertura
        FOREIGN KEY (cd_cobertura)
        REFERENCES dbo.cobertura(cd_cobertura),

    CONSTRAINT FK_sinistro_assistencia
        FOREIGN KEY (cd_assistencia)
        REFERENCES dbo.assistencia_tecnica(cd_assistencia)
);
GO

CREATE NONCLUSTERED INDEX idx_sinistro_apolice_data
ON dbo.sinistro(cd_apolice, dt_ocorrencia);
GO

CREATE NONCLUSTERED INDEX idx_sinistro_assistencia_status
ON dbo.sinistro(cd_assistencia, st_sinistro);
GO

CREATE NONCLUSTERED INDEX idx_sinistro_data_apolice
ON dbo.sinistro(dt_ocorrencia, cd_apolice);
GO

-- =============================================
-- 12. TABELA: historico_sinistro
-- =============================================

CREATE TABLE dbo.historico_sinistro
(
    cd_historico INT IDENTITY(1,1) PRIMARY KEY,
    cd_sinistro INT NOT NULL,
    st_anterior TINYINT NOT NULL,
    st_novo TINYINT NOT NULL,
    dt_mudanca DATETIME NOT NULL DEFAULT GETDATE(),
    ds_usuario VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),

    CONSTRAINT FK_historico_sinistro
        FOREIGN KEY (cd_sinistro)
        REFERENCES dbo.sinistro(cd_sinistro)
);
GO
