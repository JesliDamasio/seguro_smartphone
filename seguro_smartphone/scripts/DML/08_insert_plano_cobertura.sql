
USE SeguroSmartphone;
GO

INSERT INTO dbo.plano_cobertura
(cd_plano, cd_cobertura, vl_limite_indenizacao)
SELECT
    p.cd_plano,
    c.cd_cobertura,
    v.vl_limite_indenizacao
FROM (VALUES
    ('Basico', 'Roubo', 3000.00),
    ('Basico', 'Furto qualificado', 3000.00),
    ('Intermediario', 'Roubo', 4000.00),
    ('Intermediario', 'Danos acidentais', 2500.00),
    ('Intermediario', 'Quebra de tela', 1500.00),
    ('Premium', 'Roubo', 6000.00),
    ('Premium', 'Furto qualificado', 6000.00),
    ('Premium', 'Danos por liquidos', 3000.00),
    ('Premium', 'Quebra de tela', 2500.00),
    ('Completo', 'Roubo', 7000.00),
    ('Completo', 'Danos acidentais', 4000.00),
    ('Completo', 'Danos por liquidos', 3500.00),
    ('Completo', 'Perda total', 7000.00),
    ('Essencial', 'Roubo', 2000.00),
    ('Essencial', 'Furto qualificado', 2000.00),
    ('Protecao Total', 'Roubo', 8000.00),
    ('Protecao Total', 'Danos acidentais', 5000.00),
    ('Smart Plus', 'Quebra de tela', 2000.00),
    ('Smart Max', 'Danos por liquidos', 4000.00),
    ('Gold', 'Substituicao do aparelho', 6000.00)
) AS v(nm_plano, nm_cobertura, vl_limite_indenizacao)
INNER JOIN dbo.plano_seguro p
    ON p.nm_plano = v.nm_plano
INNER JOIN dbo.cobertura c
    ON c.nm_cobertura = v.nm_cobertura
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.plano_cobertura pc
    WHERE pc.cd_plano = p.cd_plano
      AND pc.cd_cobertura = c.cd_cobertura
);
GO
