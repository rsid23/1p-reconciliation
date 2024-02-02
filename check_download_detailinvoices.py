# -*- coding: utf-8 -*-

import os
import csv
import pandas as pd



DOWNLOAD_PATH=os.getcwd()
#DOWNLOAD_FOLDER = DOWNLOAD_PATH+'\\'+f'downloads\\{pod}'

#os.makedirs(DOWNLOAD_PATH, exist_ok=True) 
#provide a year and month range which you want to check 
def main(argv):
    if len(argv)!=4:
        raise SystemExit(f'Usage: python {argv[0]} [invoice file]')
    else:
        cwd = os.getcwd()
        month_start = argv[1]
        month_end = argv[2]
        year = argv[3]
        INVOICE_HEADER_PATH = cwd+'\\Downloads\\invoices\\invoice_header'+f'\\{year}'
        DOWNLOAD_FOLDER = cwd+f'\\Downloads\\invoices\\invoice_lineitems'+f'\\{year}'

        header_invoices = []
        for each  in os.listdir(INVOICE_HEADER_PATH):
            df = pd.read_csv(INVOICE_HEADER_PATH+'\\'+each)
            df = df[['Invoice Number']]
            for each in df.itertuples():
                header_invoices.append(each[1])
        
        download_invoices = []
        for each in os.listdir(DOWNLOAD_FOLDER):
            for folder in os.listdir(DOWNLOAD_FOLDER+f'\\{each}'):
                download_invoices.append(folder.split('_')[0])

        if len(header_invoices)==len(download_invoices):
            print('header and download invoices are equal')
        else:
            diff = list(set(header_invoices)-set(download_invoices))
            print(f'here are the missing invoices:{diff}')

if __name__ =='__main__':
    import sys
    main(sys.argv)    

