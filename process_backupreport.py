# -*- coding: utf-8 -*-

import pandas as pd
import os
import numpy as np

input_folder = 'D:\\IDERIVE\\repos\\iderive-ds-1pinvoice-selenium\\Downloads\\backupreports\\2021\\'
revised_folder = 'D:\\IDERIVE\\repos\\iderive-ds-1pinvoice-selenium\\Downloads\\backupreports\\2021\\revised\\'
processed_folder = 'D:\\IDERIVE\\repos\\iderive-ds-1pinvoice-selenium\\Downloads\\backupreports\\2021\\processed\\'
#output_folder = './2023_processed/'

os.makedirs(processed_folder, exist_ok=True) 
os.makedirs(revised_folder, exist_ok=True) 
d = []

for files in os.listdir(input_folder):
    mydtype = {'UPC': str, 'EAN': str, "Product Group": str, "Category": str, "Subcategory": str, 
               "Product Description": str, "Price Protection Agreement": str, "Invoice": str}
    if '.xls' in files:
        df = pd.read_excel(input_folder+'\\'+files, dtype=mydtype)
        agreement, invoice, invoicelinetype, invoicedate, file = files.split('_')
        file = files.split('.')[0]
    
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

    if  'Revised Invoice Quantity' in df.columns:
        output_folder=revised_folder
    else:
        output_folder=processed_folder
    file_check =('D:\\IDERIVE\\repos\\iderive-ds-1pinvoice-selenium\\Downloads\\backupreports\\2021\\'+files)
    #print(os.isfile(file_check))

    if os.path.isfile(file_check):
        print('createing file')
        print(output_folder+files +'.csv')
        df.to_csv(output_folder+files +'.csv', index=False)
        d.append({'invoice': invoice, 'invoice_date': invoicedate})

