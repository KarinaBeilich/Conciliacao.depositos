SET NOCOUNT ON;

DECLARE @dt NVARCHAR(10) = '" & ParamDate & "';
DECLARE @rcpCodigo INT = NULL;

WITH idg_permitidos AS (
    SELECT codigo 
    FROM (VALUES                
        ('010301'),('010401'),('010411'),('010493'),('010701'),('010730'),('010731'),('010793'),
        ('011001'),('011101'),('011109'),('011117'),('011192'),('011401'),('011481'),('011801'),
        ('011893'),('012092'),('013401'),('013601'),('013692'),('014201'),('014211'),('014231'),
        ('014301'),('014401'),('011410'),('015601'),('015901'),('016611'),('016801'),('016901'),
        ('017101'),('017901'),('017993'),('018001'),('018011'),('019501'),('019511'),('020401'),
        ('020410'),('021401'),('021481'),('024101'),('025101'),('025111'),('030501'),('030511'),
        ('085101'),('085110'),('085111'),('172401'),('182401'),('191601'),('191611'),('192401'),
        ('201601'),('206501'),('206593'),('220401'),('223101'),('225111'),('225501'),('225503'),
        ('226001'),('226011'),('226017'),('226031'),('226109'),('227501'),('227801'),('227817'),
        ('228301'),('228317'),('228717'),('230801'),('230831'),('241601'),('241611'),('246611'),
        ('401601'),('401692'),('411601'),('411611'),('421601'),('421611'),('421692'),('422301'),
        ('422392'),('550401'),('550411'),('550430'),('550801'),('550807'),('550808'),('550809'),
        ('550811'),('550817'),('550870'),('550882'),('551109'),('551111'),('551117'),('551181'),
        ('551401'),('551411'),('551481'),('551601'),('555101'),('555111'),('555311'),('555361'),
        ('559901'),('660401'),('660411'),('660430'),('660493'),('660511'),('660701'),('660709'),
        ('660711'),('660731'),('660793'),('660801'),('660802'),('660809'),('660811'),('660817'),
        ('660870'),('661001'),('661104'),('661109'),('661111'),('661117'),('661125'),('661401'),
        ('661411'),('661601'),('661611'),('661717'),('662009'),('662011'),('662017'),('662301'),
        ('662311'),('662317'),('662401'),('662411'),('664101'),('664130'),('664201'),('664231'),
        ('664301'),('664311'),('664330'),('665101'),('665111'),('665192'),('665601'),('665611'),
        ('666401'),('666430'),('667901'),('667911'),('667930'),('668001'),('668011'),('669501'),
        ('910801'),('910870'),('920801'),('920811'),('920870'),('930801'),('930870')
    ) AS t(codigo)
),

feriados AS (
    SELECT DISTINCT CONVERT(DATE, ferData) AS ferData
    FROM netfactor.dbo.nfFeriado
),

vencimentos_base AS (
    SELECT DISTINCT CONVERT(DATE, ing.ingVencimento) AS vencOriginal
    FROM netfactor.dbo.nfIngressos ing
    WHERE ing.ingDataLiquidacao IS NULL
      AND EXISTS (
        SELECT 1 FROM idg_permitidos ip
        WHERE RIGHT('000000' + LTRIM(RTRIM(ip.codigo)), 6) = RIGHT('000000' + LTRIM(RTRIM(ing.idgCodigo)), 6)
    )
),

ajuste AS (
    SELECT vencOriginal, vencOriginal AS dataAtual, 0 AS nivel
    FROM vencimentos_base

    UNION ALL

    SELECT a.vencOriginal, DATEADD(DAY, 1, a.dataAtual), a.nivel + 1
    FROM ajuste a
    WHERE a.nivel < 15
      AND (
            DATEDIFF(DAY, 0, a.dataAtual) % 7 IN (5,6)
            OR EXISTS (SELECT 1 FROM feriados f WHERE f.ferData = a.dataAtual)
          )
),

vencimento_real AS (
    SELECT vencOriginal, MIN(dataAtual) AS VencimentoReal
    FROM ajuste a
    WHERE NOT (
            DATEDIFF(DAY, 0, a.dataAtual) % 7 IN (5,6)
            OR EXISTS (SELECT 1 FROM feriados f WHERE f.ferData = a.dataAtual)
          )
    GROUP BY vencOriginal
),

creditos AS (
    SELECT
        p.penCodigo, p.empCodigo, p.cedCodigo, p.penValorOriginal,
        p.penData, p.eveCodigo, p.penComplemento, p.rcpCodigo,
        rp.rcpAtualizado
    FROM netfactor.dbo.nfPendencia p
    LEFT JOIN netfactor.dbo.nfReciboPendencia rp ON rp.rcpCodigo = p.rcpCodigo AND rp.empCodigo = p.empCodigo
    WHERE p.eveCodigo IN (18, 5071)
      AND (
            (@rcpCodigo IS NOT NULL AND p.rcpCodigo = @rcpCodigo)
            OR (@rcpCodigo IS NULL AND CONVERT(VARCHAR(10), p.penData, 103) = REPLACE(@dt, '-', '/'))
          )
),

titulos AS (
    SELECT
        ing.ingCodigo, 
        ing.ingDocumento, 
        ing.empCodigo, 
        ing.cedCodigo,
        ing.ingValordeFace, 
        ing.ingVencimento, 
        vr.VencimentoReal,
        ing.idgCodigo,
        foc.fneDescricao,
        tpp.tpaDescricao,
        sit.sitDescricao
    FROM netfactor.dbo.nfIngressos ing
    LEFT JOIN vencimento_real vr ON vr.vencOriginal = CONVERT(DATE, ing.ingVencimento)
    LEFT JOIN netfactor.dbo.nfIdentificadorGlobal idg ON idg.idgCodigo = ing.idgCodigo
    LEFT JOIN netfactor.dbo.nfFocoNegocio foc ON foc.fneCodigo = idg.fneCodigo
    LEFT JOIN netfactor.dbo.nfTipoPapel tpp ON tpp.tpaCodigo = idg.tpaCodigo
    LEFT JOIN netfactor.dbo.nfSituacao sit ON sit.sitCodigo = idg.sitCodigo
    WHERE ing.ingDataLiquidacao IS NULL
      AND EXISTS (
        SELECT 1 FROM idg_permitidos ip
        WHERE RIGHT('000000' + LTRIM(RTRIM(ip.codigo)), 6) = RIGHT('000000' + LTRIM(RTRIM(ing.idgCodigo)), 6)
    )
),

candidatos_individual AS (
    SELECT
        c.penCodigo,
        t.ingCodigo,
        t.ingDocumento,
        t.idgCodigo,
        t.fneDescricao,
        t.tpaDescricao,
        t.sitDescricao,
        t.ingValordeFace,
        t.ingVencimento,
        t.VencimentoReal,
        CASE
            WHEN CONVERT(DATE, t.VencimentoReal) = CONVERT(DATE, c.penData) THEN 'CREDITO COMPATIVEL'
            WHEN DATENAME(WEEKDAY, c.penData) IN ('Tuesday', 'terça-feira', 'terca-feira')
                 AND CONVERT(DATE, t.VencimentoReal) BETWEEN DATEADD(DAY, -3, CONVERT(DATE, c.penData)) AND CONVERT(DATE, c.penData)
                 THEN 'POSSÍVEL LIQUIDAÇÃO'
            WHEN CONVERT(DATE, t.VencimentoReal) BETWEEN DATEADD(DAY, -2, CONVERT(DATE, c.penData)) AND CONVERT(DATE, c.penData)
                 THEN 'POSSÍVEL LIQUIDAÇÃO'
            ELSE 'FORA DA DATA - VERIFICAR'
        END AS Status_Match,

        ROW_NUMBER() OVER (
            PARTITION BY c.penCodigo
            ORDER BY
                CASE 
                    WHEN CONVERT(DATE, t.VencimentoReal) = CONVERT(DATE, c.penData) THEN 0
                    WHEN DATENAME(WEEKDAY, c.penData) IN ('Tuesday', 'terça-feira', 'terca-feira')
                         AND CONVERT(DATE, t.VencimentoReal) BETWEEN DATEADD(DAY, -3, CONVERT(DATE, c.penData)) AND CONVERT(DATE, c.penData) THEN 1
                    WHEN CONVERT(DATE, t.VencimentoReal) BETWEEN DATEADD(DAY, -2, CONVERT(DATE, c.penData)) AND CONVERT(DATE, c.penData) THEN 1
                    ELSE 2
                END,
                ABS(DATEDIFF(DAY, t.VencimentoReal, c.penData))
        ) AS RankCandidato
    FROM creditos c
    JOIN titulos t
        ON t.empCodigo = c.empCodigo
       AND t.cedCodigo = c.cedCodigo
       AND t.ingValordeFace = ABS(c.penValorOriginal)
       AND CONVERT(DATE, t.VencimentoReal) <= CONVERT(DATE, c.penData)
),

vencidos_por_grupo AS (
    SELECT
        t.empCodigo,
        t.cedCodigo,
        t.idgCodigo,
        t.fneDescricao,
        t.tpaDescricao,
        t.sitDescricao,
        SUM(t.ingValordeFace) AS TotalVencidos,
        COUNT(*) AS QtdVencidos
    FROM titulos t
    WHERE t.VencimentoReal < CONVERT(DATE, GETDATE())
    GROUP BY 
        t.empCodigo, 
        t.cedCodigo, 
        t.idgCodigo,
        t.fneDescricao,
        t.tpaDescricao,
        t.sitDescricao
)

SELECT
    c.penCodigo,
    emp.empSigla AS Empresa,
    pesced.pesNome AS Cedente,
    FORMAT(c.penData, 'dd-MM-yyyy') AS penData,
    c.penValorOriginal AS ValorDep,
    c.penComplemento AS [Descrição],
    c.rcpCodigo AS Recibo_Gerado,
    IIF(c.rcpAtualizado = 1, 'Sim', '') AS ReciboEfetivado,
    
    CASE 
        WHEN ISNULL(c.rcpCodigo, 0) <> 0 THEN NULL 
        ELSE cand.Status_Match 
    END AS Status_Individual,
    
    CASE 
        WHEN ISNULL(c.rcpCodigo, 0) <> 0 THEN NULL 
        ELSE cand.ingDocumento 
    END AS Doc_Individual,
    
    CASE 
        WHEN ISNULL(c.rcpCodigo, 0) <> 0 THEN NULL 
        ELSE FORMAT(cand.VencimentoReal, 'dd-MM-yyyy') 
    END AS Vencimento_Real_Individual,
    
    CASE 
        WHEN ISNULL(c.rcpCodigo, 0) <> 0 THEN NULL
        WHEN vgm.TotalVencidos IS NOT NULL THEN 'LIQUIDAR ' + CAST(vgm.QtdVencidos AS VARCHAR) + ' VENCIDO(S) DO GRUPO (IDG ' + vgm.idgCodigo + ' - ' + ISNULL(vgm.fneDescricao,'') + ')'
    END AS Status_TotalVencidos,
    
    CASE 
        WHEN ISNULL(c.rcpCodigo, 0) <> 0 THEN NULL 
        ELSE vgm.TotalVencidos 
    END AS TotalVencidos_Grupo,
    
    CASE 
        WHEN ISNULL(c.rcpCodigo, 0) <> 0 THEN NULL 
        ELSE vgm.QtdVencidos 
    END AS QtdVencidos_Grupo

FROM creditos c
LEFT JOIN netfactor.dbo.nfCedente ced ON ced.cedCodigo = c.cedCodigo AND ced.empCodigo = c.empCodigo
LEFT JOIN netfactor.dbo.nfPessoa pesced ON pesced.pesCNPJCPF = ced.pesCNPJCPF
LEFT JOIN netfactor.dbo.nfEmpresa emp ON emp.empCodigo = c.empCodigo
LEFT JOIN candidatos_individual cand ON cand.penCodigo = c.penCodigo AND cand.RankCandidato = 1
OUTER APPLY (
    SELECT TOP 1 vg.*
    FROM vencidos_por_grupo vg
    WHERE vg.empCodigo = c.empCodigo
      AND vg.cedCodigo = c.cedCodigo
      AND vg.TotalVencidos = ABS(c.penValorOriginal)
) vgm
ORDER BY c.penData, c.penCodigo
OPTION (MAXRECURSION 100);
