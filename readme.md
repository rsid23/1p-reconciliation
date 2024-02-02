# 1P Reconciliation Scraper Script

## Overview

This script serves as a comprehensive solution for reconciling 1P (First Party) data. It efficiently extracts essential information about agreements, terms, invoices, and performs data cleaning 

## Before you start 

1. Ensure that all librariues from requirements.txt installed
2. Provide login details and MFA API key 

## How it Operates

The script is comprised of the following files:

- **download_backupreports.py:** Scrapes information about agreements and their terms.
- **download_header_invoices.py:** Scans and extracts details about invoices.
- **download_invoices.py:** Collects all available invoices based on previously obtained headers.
- **process_backupreport.py:** Converts downloaded backup reports to .csv format and optimizes data cleanliness.
- **check_download_detailinvoices.py:** Verifies the completeness of downloaded invoices, highlighting any missing data.

## Execution Order

1. **download_backupreports.py:**
    - Execute using the command: `python download_backupreports.py 01 01 31 01 2024`
    - Scrapes information for January 2024.

2. **download_header_invoices.py:**
    - Execute using the command: `python download_header_invoices.py 01 01 2024`
    - Extracts invoice headers for January 2024.

3. **download_invoices.py:**
    - Execute using the command: `python D:\IDERIVE\repos\iderive-ds-1pinvoice-selenium\Downloads\invoices\invoice_header`
    - Downloads all invoices corresponding to the previously obtained headers.

4. **check_download_detailinvoices.py:**
    - Execute using the command: `python check_download_detailinvoices.py 01 01 2024`
    - Scans all documents collected for January, identifying any missing invoices.

5. **process_backupreport.py:**
    - Update variables (`input_folder`, `revised_folder`, `processed_folder`) in `process_backupreport.py`.
    - Execute using the command: `python process_backupreport.py`

## Script Modification TO-DO List

1. Implement a checking process in **download_invoices.py** to verify if an invoice is already downloaded.
   
2. Enhance the script to scrape amount data from the invoice details.
