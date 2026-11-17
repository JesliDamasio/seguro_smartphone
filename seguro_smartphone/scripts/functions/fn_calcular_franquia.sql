
USE SeguroSmartphone;
GO

CREATE OR ALTER FUNCTION dbo.fn_calcular_franquia
(
    @vl_mercado DECIMAL(10,2),
    @pc_franquia DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @vl_franquia DECIMAL(10,2);

    SET @vl_franquia =
        (@vl_mercado * @pc_franquia) / 100.0;

    RETURN @vl_franquia;
END;
GO

EXEC sp_helptext 'dbo.fn_calcular_franquia';
GO