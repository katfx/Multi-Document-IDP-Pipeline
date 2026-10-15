-- Databricks notebook source
SELECT * 
FROM read_files('/Volumes/idp/default/final_project')

-- COMMAND ----------

CREATE OR REPLACE TABLE parsed_data AS
SELECT path,
ai_parse_document(content) AS parsed_content
FROM read_files('/Volumes/idp/default/final_project')

-- COMMAND ----------

CREATE OR REPLACE TABLE silver_data AS
SELECT path,
concat_ws('/n',
  transform(try_cast(parsed_content:document:elements AS ARRAY<VARIANT>), e -> coalesce(try_cast(e: content AS STRING), ''))) AS doc_text
FROM parsed_data

-- COMMAND ----------

CREATE OR REPLACE TABLE classified_data AS
SELECT * ,
ai_classify(doc_text, ARRAY('Purchase Order', 'Receipts', 'Invoice', 'Other')) AS doc_classification
FROM silver_data

-- COMMAND ----------


CREATE OR REPLACE TABLE invoice_data AS
SELECT *,
ai_extract(doc_text,
  ARRAY('Vendor_Name', 'Invoice_Number', 'Invoice_Date','Due_Date', 'Payment_Method', 'Total')
) AS extrated_info
FROM classified_data
WHERE doc_classification = 'Invoice'

-- COMMAND ----------

CREATE SCHEMA IF NOT EXISTS idp.finance

-- COMMAND ----------

CREATE OR REPLACE TABLE idp.finance.invoices AS
SELECT path,
extrated_info.Vendor_Name As Vendor,
extrated_info.Invoice_Number AS Invoice_Number,
extrated_info.Invoice_Date AS Invoice_Date,
extrated_info.Due_Date AS Due_Date,
extrated_info.Payment_Method AS Payment_Method,
extrated_info.Total AS Total
FROM invoice_data

-- COMMAND ----------

SELECT * FROM idp.finance.invoices

-- COMMAND ----------

CREATE OR REPLACE TABLE purchase_order_data AS
SELECT *,
ai_extract(doc_text,
  ARRAY('Merchant_Name', 'PO_Number','Purchase_Order_Date', 'Total')
) AS extracted
FROM classified_data
WHERE doc_classification = 'Purchase Order'

-- COMMAND ----------

CREATE OR REPLACE TABLE idp.finance.purchase_order AS
SELECT path,
extracted.Merchant_Name AS Merchant_Name,
extracted.PO_Number AS PO_Number,
extracted.Purchase_Order_Date AS Purchase_Order_Date,
extracted.Total AS Total
FROM purchase_order_data

-- COMMAND ----------



-- COMMAND ----------

CREATE OR REPLACE TABLE receipts_data AS
SELECT *,
ai_extract(doc_text,
  ARRAY('Merchant_Name', 'Receipt_Number','Transaction_Date', 'Total')
) AS extracted
FROM classified_data
WHERE doc_classification = 'Receipts'

-- COMMAND ----------

CREATE OR REPLACE TABLE idp.finance.receipts AS
SELECT path,
extracted.Merchant_Name AS Merchant_Name,
extracted.Receipt_Number AS Receipt_Number,
extracted.Transaction_Date AS Transaction_Date,
extracted.Total AS Total
FROM receipts_data