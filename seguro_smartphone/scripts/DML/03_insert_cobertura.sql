
USE SeguroSmartphone;
GO

INSERT INTO dbo.cobertura (nm_cobertura, ds_cobertura)
SELECT v.nm_cobertura, v.ds_cobertura
FROM (VALUES
    ('Roubo', 'Cobertura contra roubo mediante comprovação.'),
    ('Furto qualificado', 'Cobertura contra furto qualificado.'),
    ('Danos acidentais', 'Danos causados por acidentes.'),
    ('Danos por liquidos', 'Danos causados por contato com líquidos.'),
    ('Quebra de tela', 'Reparo ou substituição de tela quebrada.'),
    ('Danos eletricos', 'Danos causados por variações elétricas.'),
    ('Oxidacao', 'Danos internos causados por oxidação.'),
    ('Queda acidental', 'Danos decorrentes de quedas acidentais.'),
    ('Falha de bateria', 'Problemas de funcionamento da bateria.'),
    ('Defeito de fabrica', 'Defeitos de fabricação cobertos pelo plano.'),
    ('Danos na camera', 'Danos nos módulos de câmera.'),
    ('Danos no conector', 'Danos no conector de carregamento.'),
    ('Danos no alto-falante', 'Falhas nos alto-falantes do aparelho.'),
    ('Danos no microfone', 'Falhas no microfone do aparelho.'),
    ('Danos na placa', 'Danos na placa principal do aparelho.'),
    ('Furto simples', 'Cobertura contra furto simples, conforme contrato.'),
    ('Perda total', 'Indenização em caso de perda total coberta.'),
    ('Danos no display', 'Danos no painel de exibição.'),
    ('Danos nos botoes', 'Danos nos botões físicos do aparelho.'),
    ('Substituicao do aparelho', 'Substituição do aparelho conforme condições contratuais.')
) AS v(nm_cobertura, ds_cobertura)
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.cobertura c
    WHERE c.nm_cobertura = v.nm_cobertura
);
GO
