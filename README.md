# 🏦 Conciliação de Depósitos 

<p align="center">
  <img src="https://img.shields.io/badge/linguagem-SQL-blue?style=for-the-badge" alt="Linguagem SQL">
  <img src="https://img.shields.io/badge/status-em andamento-orange?style=for-the-badge" alt="Status Em Andamento">
</p>

Este projeto contém o script SQL responsável por automatizar o processo de **conciliação bancária e financeira de depósitos**, realizando o cruzamento de dados entre os registros internos do sistema e os extratos/entradas bancárias.

---

## 🎯 Objetivo

O objetivo deste script é identificar divergências, pendências e correspondências (*matches*) entre:
- **Depósitos recebidos do banco** (Transferencia bancaria, Pix, entre outros).
- **Conciliação com os Titulos em aberto no sistema** (Liquidação, Recompra, Abatimento, Prorrogação).

---

## ⚙️ Funcionalidades e Regras de Negócio

- **Cruzamento de Chaves:** Comparação de registros por ID do depósito, data de emissão/compensação, valor exato e número da conta.
- **Classificação de Status:**
  - `CREDITO COMPATIVEL`: Registro presente no sistema e no extrato bancário com valores e datas correspondentes.
  - `POSSÍVEL LIQUIDAÇÃO`: Registro presente no sistema e no extrato bancário, mas o vencimento do titulo ou credito é um pouco diferente do depósitado.
  - `FORA DA DATA - VERIFICAR`: Registro presente no sistema e no extrato bancário, mas o titulo possui vencimento muito distante do parâmetro, solicitando então a verificação com o setor responsavel.
- **Tratamento de Tolerâncias:** Ajuste para pequenas diferenças operacionais (ex: compensação em D-2; D-1 e D-0).

---

## 📌 Pré-requisitos

Para executar o script, você precisará de:

- **SGBD Compatível:** PostgreSQL / MySQL / SQL Server / Oracle (ajuste a sintaxe conforme seu banco de dados).
- **Tabelas de Origem Necessárias:**
  - `tbl_Parametros` (Registros de pesquisa por periodo)
- Permissões de leitura nas tabelas de origem e permissão de criação/inserção na tabela/view de destino.

---

👩‍💻 Autora
Karina Beilich

GitHub: https://github.com/KarinaBeilich


