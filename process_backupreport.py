# -*- coding: utf-8 -*-
"""
Created on Wed Jun  7 13:55:36 2023

@author: catalin
"""

import pandas as pd
import os
import numpy as np

input_folder = './2023/'
#output_folder = './2023_processed/'

os.makedirs('processed', exist_ok=True) 
os.makedirs('revised', exist_ok=True) 
d = []
def process_backup_report(path, file_name):
    os.makedirs(os.path.join('./processed',path), exist_ok=True) 
    os.makedirs(os.path.join('./revised',path), exist_ok=True) 
    mydtype = {'UPC': str, 'EAN': str, "Product Group": str, "Category": str, "Subcategory": str, 
               "Product Description": str, "Price Protection Agreement": str, "Invoice": str}
    
    
    #df = pd.read_excel(input_folder + file_name, dtype=mydtype)
    df = pd.read_excel(os.path.join(path, file_name), dtype=mydtype)
    agreement, invoice, invoicelinetype, invoicedate, file = file_name.split('_')
    file = file_name.split('.')[0]
    
    if 'Marketplace' in df.columns:
        df = df.drop(columns=['Marketplace'])
        
    if 'Multi-Country Parent Agreement ID' not in df.columns:
        df['Multi-Country Parent Agreement ID']=np.nan
    df['bkup_agreement'] = agreement
    df['bkup_invoice'] = invoice
    df['bkup_invoice_date'] = invoicedate
    df['bkup_invoicelinetype'] = invoicelinetype
    df['bkup_file'] = file
    df = df[:-2]
    
    if 'Revised Invoice Quantity' in df.columns:
        output_folder='./revised/'
    else:    
        output_folder='./processed/'        
    df.to_csv(os.path.join(output_folder+path, file_name.split('.')[0]+'.csv'), index=False)
    print(file)    
    d.append({'invoice': invoice,
              'invoice_date': invoicedate})


def infile(file):
    #df = pd.read_excel(input_folder + file_name)
    df = pd.read_excel(file)
    if 'Marketplace' in df.columns:
        print(file)
    

for root, dirs, files in os.walk(input_folder):
    for file in files:
        infile(os.path.join(root, file))


for root, _dirs, files in os.walk(input_folder):
    for file in files:
        #process_backup_report(file)
        process_backup_report(root, file)
        
ddf = pd.DataFrame(d)     
ddf.to_csv('invoices.csv', index=False)   
    