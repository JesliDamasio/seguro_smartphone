
USE SeguroSmartphone;
GO

INSERT INTO dbo.sinistro
(cd_apolice, cd_cobertura, cd_assistencia, dt_ocorrencia,
 ds_relato_ocorrencia, vl_prejuizo_estimado,
 vl_franquia_paga, st_sinistro)
SELECT
    ap.cd_apolice,
    co.cd_cobertura,
    at.cd_assistencia,
    v.dt_ocorrencia,
    v.ds_relato,
    v.vl_prejuizo,
    v.vl_franquia,
    v.st_sinistro
FROM (VALUES
    ('00000000001', 'Roubo', 'Assistencia Tech Sul', '2025-06-10T14:30:00', 'Aparelho roubado durante deslocamento.', 4500.00, 450.00, 3),
    ('00000000002', 'Quebra de tela', 'Smart Repair', '2025-06-12T10:15:00', 'Tela danificada apos queda.', 1200.00, 420.00, 2),
    ('00000000003', 'Danos acidentais', 'Mobile Center', '2025-06-15T16:20:00', 'Aparelho sofreu impacto no solo.', 800.00, 240.00, 1),
    ('00000000004', 'Roubo', NULL, '2025-06-18T20:00:00', 'Aparelho roubado em via publica.', 1400.00, 210.00, 3),
    ('00000000005', 'Furto qualificado', NULL, '2025-06-20T11:40:00', 'Aparelho furtado apos arrombamento.', 6200.00, 620.00, 2),
    ('00000000006', 'Danos por liquidos', 'Repara Smart', '2025-06-22T09:30:00', 'Contato acidental com liquido.', 900.00, 220.00, 1),
    ('00000000007', 'Quebra de tela', 'Tech Solutions', '2025-06-25T13:10:00', 'Display trincado apos queda.', 1500.00, 350.00, 3),
    ('00000000008', 'Danos acidentais', 'Cell Assist', '2025-06-27T17:45:00', 'Aparelho caiu durante utilizacao.', 1000.00, 230.00, 2),
    ('00000000009', 'Roubo', NULL, '2025-06-29T22:10:00', 'Roubo registrado mediante boletim.', 5000.00, 500.00, 4),
    ('00000000010', 'Furto qualificado', NULL, '2025-07-01T08:20:00', 'Aparelho furtado em estabelecimento.', 1200.00, 120.00, 1),
    ('00000000011', 'Danos eletricos', 'Phone Care', '2025-07-03T12:00:00', 'Aparelho apresentou falha eletrica.', 1100.00, 280.00, 2),
    ('00000000012', 'Danos na camera', 'Smart Fix', '2025-07-05T15:30:00', 'Camera traseira deixou de funcionar.', 700.00, 400.00, 3),
    ('00000000013', 'Quebra de tela', 'Tecno Celular', '2025-07-08T18:15:00', 'Tela quebrada em acidente domestico.', 1300.00, 250.00, 1),
    ('00000000014', 'Danos no conector', 'Center Mobile', '2025-07-10T10:00:00', 'Conector de carregamento danificado.', 500.00, 270.00, 2),
    ('00000000015', 'Roubo', NULL, '2025-07-12T21:30:00', 'Roubo do aparelho durante viagem.', 5500.00, 550.00, 3),
    ('00000000016', 'Falha de bateria', 'Master Phone', '2025-07-14T09:45:00', 'Bateria apresentou defeito.', 450.00, 130.00, 1),
    ('00000000017', 'Danos na placa', 'Help Smartphone', '2025-07-16T14:00:00', 'Falha na placa principal.', 1800.00, 380.00, 2),
    ('00000000018', 'Danos no alto-falante', 'Reparo Express', '2025-07-18T11:25:00', 'Alto-falante parou de funcionar.', 350.00, 110.00, 3),
    ('00000000019', 'Danos no display', 'Phone Expert', '2025-07-20T16:40:00', 'Display apresentou falha apos impacto.', 600.00, 150.00, 1),
    ('00000000020', 'Substituicao do aparelho', 'Smart Doctor', '2025-07-22T19:00:00', 'Aparelho apresentou perda total.', 1500.00, 290.00, 2)
) AS v(nr_cpf, nm_cobertura, nm_assistencia, dt_ocorrencia,
       ds_relato, vl_prejuizo, vl_franquia, st_sinistro)
INNER JOIN dbo.cliente c ON c.nr_cpf = v.nr_cpf
INNER JOIN dbo.apolice ap ON ap.cd_cliente = c.cd_cliente
INNER JOIN dbo.cobertura co ON co.nm_cobertura = v.nm_cobertura
LEFT JOIN dbo.assistencia_tecnica at
    ON at.nm_razao_social = v.nm_assistencia
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.sinistro s
    WHERE s.cd_apolice = ap.cd_apolice
      AND s.dt_ocorrencia = v.dt_ocorrencia
);
GO
