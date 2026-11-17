
USE SeguroSmartphone;
GO

INSERT INTO dbo.parcela_apolice
(cd_apolice, nr_parcela, dt_vencimento, vl_parcela,
 dt_pagamento, st_pagamento)
SELECT
    ap.cd_apolice,
    v.nr_parcela,
    v.dt_vencimento,
    v.vl_parcela,
    v.dt_pagamento,
    v.st_pagamento
FROM (VALUES
    ('00000000001', 1, '2025-06-01', 75.00, '2025-05-30', 1),
    ('00000000002', 1, '2025-06-02', 70.83, '2025-06-02', 1),
    ('00000000003', 1, '2025-06-03', 40.00, NULL, 0),
    ('00000000004', 1, '2025-06-04', 35.00, NULL, 0),
    ('00000000005', 1, '2025-06-05', 100.00, '2025-06-05', 1),
    ('00000000006', 1, '2025-06-06', 41.67, NULL, 0),
    ('00000000007', 1, '2025-06-07', 62.50, '2025-06-07', 1),
    ('00000000008', 1, '2025-06-08', 45.83, NULL, 0),
    ('00000000009', 1, '2025-06-09', 83.33, '2025-06-09', 1),
    ('00000000010', 1, '2025-06-10', 25.00, NULL, 0),
    ('00000000011', 1, '2025-06-11', 50.00, '2025-06-11', 1),
    ('00000000012', 1, '2025-06-12', 70.83, NULL, 0),
    ('00000000013', 1, '2025-06-13', 45.83, '2025-06-13', 1),
    ('00000000014', 1, '2025-06-14', 48.33, NULL, 0),
    ('00000000015', 1, '2025-06-15', 91.67, '2025-06-15', 1),
    ('00000000016', 1, '2025-06-16', 26.67, NULL, 0),
    ('00000000017', 1, '2025-06-17', 66.67, '2025-06-17', 1),
    ('00000000018', 1, '2025-06-18', 23.33, NULL, 0),
    ('00000000019', 1, '2025-06-19', 29.17, '2025-06-19', 1),
    ('00000000020', 1, '2025-06-20', 54.17, NULL, 0)
) AS v(nr_cpf, nr_parcela, dt_vencimento, vl_parcela,
       dt_pagamento, st_pagamento)
INNER JOIN dbo.cliente c ON c.nr_cpf = v.nr_cpf
INNER JOIN dbo.aparelho_segurado a ON a.cd_cliente = c.cd_cliente
INNER JOIN dbo.apolice ap ON ap.cd_aparelho = a.cd_aparelho
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.parcela_apolice pa
    WHERE pa.cd_apolice = ap.cd_apolice
      AND pa.nr_parcela = v.nr_parcela
);
GO
