# Practical SQL Patterns

A collection of reusable SQL patterns and snippets gathered from day-to-day analytical work using Trino, Superset, Athena, Databricks, and ANSI SQL engines.

The goal of this repository is to document practical solutions to common analytical problems and create a personal SQL knowledge base.

[EN](#en-overview) • [PT-BR](#pt-br-visão-geral)

---

# EN Overview

## 🎯 Purpose

Build a collection of practical SQL examples that can be reused across different analytical environments.

Examples include:

* Window functions
* Ranking techniques
* Previous and next records
* Scalar subqueries
* CASE WHEN patterns
* EXISTS clauses

---

## 🛠 Supported Engines

The examples are compatible, with minor adjustments, with:

* Trino
* Apache Superset
* Metabase
* AWS Athena
* Databricks SQL

Since all engines follow ANSI SQL principles, most patterns can be adapted easily.

---

## 📂 Repository Structure

| File                    | Topic                         |
| ----------------------- | ----------------------------- |
| `case_when_exists.sql`  | CASE WHEN + EXISTS patterns   |
| `prox_registro.sql`     | Next record retrieval         |
| `registro_anterior.sql` | Previous record analysis      |
| `rankeando.sql`         | Ranking with window functions |
| `subquery_escalar.sql`  | Scalar subqueries             |

---

## 🧠 Topics Covered

### Ranking

Examples using:

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

---

### Previous and Next Records

Patterns based on:

```sql
LAG()
LEAD()
```

Useful for:

* Cohort analysis
* Event sequences
* Lifecycle analysis

---

### CASE WHEN + EXISTS

Conditional logic examples for:

* Flags
* Categorization
* Existence checks

---

### Scalar Subqueries

Techniques for:

* Dynamic calculations
* KPI comparisons
* Reference values

---

## 🚨 Use Cases

* Analytics Engineering
* Data Analysis
* KPI calculations
* Event analysis
* SQL interview preparation

---

# PT-BR Visão Geral

## 🎯 Objetivo

Construir uma coleção de exemplos práticos em SQL para reutilização em diferentes ambientes analíticos.

O repositório reúne soluções utilizadas no dia a dia para problemas recorrentes.

---

## 🛠 Engines suportadas

Os exemplos são compatíveis, com pequenos ajustes, com:

* Trino
* Superset
* Metabase
* Athena
* Databricks SQL

---

## 📂 Estrutura

| Arquivo                 | Tema                 |
| ----------------------- | -------------------- |
| `case_when_exists.sql`  | CASE WHEN + EXISTS   |
| `prox_registro.sql`     | Próximo registro     |
| `registro_anterior.sql` | Registro anterior    |
| `rankeando.sql`         | Rankings             |
| `subquery_escalar.sql`  | Subqueries escalares |

---

## 🧠 Temas abordados

* Window Functions
* Ranking
* LAG e LEAD
* CASE WHEN
* EXISTS
* Subqueries
* SQL ANSI

---

## 🚨 Casos de uso

* Analytics Engineering
* Data Analytics
* Cálculo de KPIs
* Análise de eventos
* Preparação para entrevistas de SQL
