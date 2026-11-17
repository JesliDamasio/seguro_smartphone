
USE SeguroSmartphone;
GO

CREATE OR ALTER TRIGGER dbo.trg_historico_sinistro
ON dbo.sinistro
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.historico_sinistro
    (
        cd_sinistro,
        st_anterior,
        st_novo
    )
    SELECT
        i.cd_sinistro,
        d.st_sinistro,
        i.st_sinistro
    FROM inserted i
    INNER JOIN deleted d
        ON d.cd_sinistro = i.cd_sinistro
    WHERE i.st_sinistro <> d.st_sinistro;
END;
GO

EXEC sp_helptext 'dbo.trg_historico_sinistro';