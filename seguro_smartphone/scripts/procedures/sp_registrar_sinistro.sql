
USE SeguroSmartphone;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_sinistro
(
    @cd_apolice INT,
    @cd_cobertura TINYINT,
    @cd_assistencia SMALLINT = NULL,
    @dt_ocorrencia DATETIME,
    @ds_relato_ocorrencia VARCHAR(1000),
    @vl_prejuizo_estimado DECIMAL(10,2)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @novo_sinistro TABLE
    (
        cd_sinistro INT
    );

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validar se a apólice existe e está ativa
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.apolice
            WHERE cd_apolice = @cd_apolice
              AND st_apolice = 1
        )
        BEGIN
            THROW 50001,
                'A apolice nao existe ou nao esta ativa.',
                1;
        END;

        -- 2. Validar vigência da apólice
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.apolice
            WHERE cd_apolice = @cd_apolice
              AND CAST(@dt_ocorrencia AS DATE)
                  BETWEEN dt_inicio_vigencia
                  AND dt_fim_vigencia
        )
        BEGIN
            THROW 50002,
                'A data da ocorrencia esta fora da vigencia da apolice.',
                1;
        END;

        -- 3. Validar se a cobertura pertence ao plano
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.apolice a
            INNER JOIN dbo.plano_cobertura pc
                ON pc.cd_plano = a.cd_plano
            WHERE a.cd_apolice = @cd_apolice
              AND pc.cd_cobertura = @cd_cobertura
        )
        BEGIN
            THROW 50003,
                'A cobertura nao pertence ao plano contratado.',
                1;
        END;

        -- 4. Validar assistência técnica, quando informada
        IF @cd_assistencia IS NOT NULL
           AND NOT EXISTS
           (
               SELECT 1
               FROM dbo.assistencia_tecnica
               WHERE cd_assistencia = @cd_assistencia
                 AND fl_ativa = 1
           )
        BEGIN
            THROW 50004,
                'A assistencia tecnica nao existe ou esta inativa.',
                1;
        END;

        -- 5. Validar valor do prejuízo
        IF @vl_prejuizo_estimado IS NULL
           OR @vl_prejuizo_estimado <= 0
        BEGIN
            THROW 50005,
                'O valor do prejuizo deve ser maior que zero.',
                1;
        END;

        -- 6. Validar relato
        IF @ds_relato_ocorrencia IS NULL
           OR LTRIM(RTRIM(@ds_relato_ocorrencia)) = ''
        BEGIN
            THROW 50006,
                'O relato da ocorrencia e obrigatorio.',
                1;
        END;

        -- 7. Inserir o sinistro
        INSERT INTO dbo.sinistro
        (
            cd_apolice,
            cd_cobertura,
            cd_assistencia,
            dt_ocorrencia,
            ds_relato_ocorrencia,
            vl_prejuizo_estimado
        )
        OUTPUT INSERTED.cd_sinistro
        INTO @novo_sinistro
        VALUES
        (
            @cd_apolice,
            @cd_cobertura,
            @cd_assistencia,
            @dt_ocorrencia,
            @ds_relato_ocorrencia,
            @vl_prejuizo_estimado
        );

        COMMIT TRANSACTION;

        -- Retornar o código do sinistro cadastrado
        SELECT cd_sinistro
        FROM @novo_sinistro;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO

EXEC sp_helptext 'dbo.sp_registrar_sinistro';