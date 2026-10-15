# Multi-Document-IDP-Pipeline

# Enterprise Internal Developer Platform (IDP) on Databricks (SQL & Unity Catalog)

[![Databricks](https://img.shields.io/badge/Databricks-Lakehouse-red?logo=databricks)](https://databricks.com/)
[![SQL](https://img.shields.io/badge/Databricks-SQL-blue?logo=databricks)](https://databricks.com/)
[![Unity Catalog](https://img.shields.io/badge/Unity%20Catalog-Governance-orange)](https://www.databricks.com/product/unity-catalog)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An end-to-end **Internal Developer Platform (IDP)** built strictly using native **Databricks SQL** and **Unity Catalog**. This platform enables data teams to ingest external files, manage governance, and orchestrate medallion architecture pipelines entirely through declarative SQL workflows and Databricks-native tooling without managing external infrastructure code.

---

## 🏗️ Architecture Overview

The platform uses a Unity Catalog-centric design where external raw files are registered, cataloged, and transformed through Bronze, Silver, and Gold layers using pure Databricks SQL:
