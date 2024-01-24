# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import os
import csv
import pandas as pd



#DOWNLOAD_PATH=r'C:\Users\catalin\Documents\work\selenium_astral_beauty_lh\download_1p_invoices'
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
            df = df[['Invoice number']]
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

'''
def main(argv):
    if len(argv) != 2:
        raise SystemExit(f'Usage: python {argv[0]} [invoice file]')
        
    else :
        
        year=argv[1][0:4]
        month=argv[1][4:6]
        cwd = os.getcwd()
        INVOICE_HEADER_PATH=cwd+'\\Downloads\\invoices\\invoice_header\\'+f'{year}'
        DOWNLOAD_FOLDER = cwd+'\\Downloads\\invoices\\invoice_lineitems\\'+f'{year}\\{month}'
        
     
        f=[]
        for directory, subdirectories, invoices in os.walk(DOWNLOAD_FOLDER):
            break;
        for i in invoices:
            f.append(i.split('_')[0])
        #print(f)
        total_invoices=0
        missing_invoices = []
        downloaded_invoices = []
        with open(INVOICE_HEADER_PATH+'\\'+ argv[1], mode ='r') as file:          
            # reading the CSV file
            csvFile = csv.DictReader(file)
            # displaying the contents of the CSV file
            for lines in csvFile:
                total_invoices += 1            
                invoice=lines['Invoice Number']
                #payee=lines['Payee']
                if invoice not in f:
                    missing_invoices.append(invoice)  
                else:
                    downloaded_invoices.append(invoice)
        print (f'File "{argv[1]}" has {total_invoices} invoices:\n{len(downloaded_invoices)} have been downloaded\n{len(missing_invoices)} need to be downloaded')
        if len(missing_invoices)>0:
            print (f'These are the missing invoices: {missing_invoices}')
    
'''
if __name__ =='__main__':
    import sys
    main(sys.argv)    

