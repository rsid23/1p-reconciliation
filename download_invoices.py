# -*- coding: utf-8 -*-


# XPATH = //*[@id="sc-content-container"]/div[1]/div[3]/div[1]/div/div/div/div[3]/div[1]/div[2] 

import os
import csv
import pandas as pd
import lib1p.functions1p as f1p
import lib1p.config 
import sys
import shutil


#RUN EXAMPLE python .\download_invoices.py D:\IDERIVE\repos\iderive-ds-1pinvoice-selenium\Downloads\invoices\invoice_header\2023
def main(argv):
    if len(argv)!=2:
        raise SystemExit(f'Usage: python {argv[0]} [invoice file]')
    else:
        cwd = os.getcwd()
        INVOICE_HEADER_PATH = str(argv[1])
        DOWNLOAD_FOLDER = cwd+'\\Downloads\\invoices\\invoice_lineitems\\'
        my_driver = f1p.get_driver(DOWNLOAD_FOLDER)

    f1p.login_amazon(my_driver,  lib1p.config.USER, lib1p.config.PASS, lib1p.config.MFA)
    
    answer=""
    directory = argv[1]
    while answer != 'Yes':
        answer = input("Please login and select the desired vendor account. Did you login? Reply with 'Yes'")
    
    
    for file in os.listdir(directory):
        year = file[0:4]
        month = file[4:6]
        print(f'working on:{file}')
        file = pd.read_csv(cwd+f'\\Downloads\\invoices\\invoice_header\\{year}\\{file}')
        if len(file) <= 1:
            print('file is empty, skipping it')
            continue
        else:
            iterator = file[['Invoice Number','Payee']]
        for each in iterator.itertuples():
            invoice = each[1]
            payee = each[2]
            outdir = cwd+f'\\Downloads\\invoices\\invoice_lineitems\\{year}\\{month}\\'
            if not os.path.exists(outdir):
                os.makedirs(outdir,exist_ok=True)
            
            print(f"Downloading invoice: {invoice}")
            for i in range(3):
                try:
                    my_driver.refresh()
                    f1p.download_invoice (my_driver, invoice, payee)
                    input_file=DOWNLOAD_FOLDER+f'\\invoice_details.csv'
                    output_file=DOWNLOAD_FOLDER+f'\\invoice_details2.csv'
                    f1p.preprocess_invoice_csv(input_file, output_file)
                    df = pd.read_csv(output_file, skiprows=2, index_col=False)
                    df['invoice_no']=invoice
                    df['payee']=payee
                    dir = DOWNLOAD_FOLDER+f'\\{year}\\{month}\\'
                    df.to_csv(dir+f'{invoice}'+'_'+f'{payee}'+'.csv', index=False)
                    os.remove(output_file)
                    os.remove(input_file)
                    my_driver.refresh()
                except Exception as e:
                        print(e)
                        if my_driver.title not in ('Amazon Sign-In', 'Two-Step Verification'):
                            continue
                        else :
                            input("Press any key to continue!")
                            f1p.login_amazon(my_driver, lib1p.config.USER, lib1p.config.PASS, lib1p.config.MFA)
                            continue
                        #login_amazon(my_driver, USER, PASS, MFA)
                        #pass
                        #print(e)
                        #logic needs to be if login screen then login and then retry else just retry
                        
                else:
                    break
            else:
                print ("All attempts failed")

if __name__ =='__main__':
    main(sys.argv)    

