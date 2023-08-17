# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import os
import csv



#DOWNLOAD_PATH=r'C:\Users\catalin\Documents\work\selenium_astral_beauty_lh\download_1p_invoices'
DOWNLOAD_PATH=os.getcwd()
#DOWNLOAD_FOLDER = DOWNLOAD_PATH+'\\'+f'downloads\\{pod}'

#os.makedirs(DOWNLOAD_PATH, exist_ok=True) 




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
    
    
if __name__ =='__main__':
    import sys
    main(sys.argv)    

