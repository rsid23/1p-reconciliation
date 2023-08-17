# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""


import os
import csv
import pandas as pd
import lib1p.functions1p as f1p
import lib1p.config 



#DOWNLOAD_PATH=r'C:\Users\catalin\Documents\work\selenium_astral_beauty_lh\download_1p_invoices'
#DOWNLOAD_PATH=os.getcwd()
#DOWNLOAD_FOLDER = DOWNLOAD_PATH+'\\'+f'downloads\\{pod}'

#USER='reporting@iderive.com'
#PASS='Romeo!xx'
#MFA = pyotp.TOTP('TZ3COKIVQWHTEPDLQRQ6KX45RUGKB3V3GEVO2ATP77I7XXSRBPXA')


#USER='abby@605prime.com'
#PASS='nosugarco$$'
#MFA = pyotp.TOTP('OSCGJ36C7DETIQKVNQLBJZ6ETIHID2QNVYMJ7D6PWPLY7DBFVDVQ')

#totp.now() # => '492039'
#os.makedirs(DOWNLOAD_PATH, exist_ok=True) 


argv = ['1', '202206.csv']




def main(argv):
    if len(argv) != 2:
        raise SystemExit(f'Usage: python {argv[0]} [invoice file]')
        
    else :
        
        year=argv[1][0:4]
        month=argv[1][4:6]
        cwd = os.getcwd()
        INVOICE_HEADER_PATH=cwd+'\\Downloads\\invoices\\invoice_header\\'+f'{year}'
        DOWNLOAD_FOLDER = cwd+'\\Downloads\\invoices\\invoice_lineitems\\'+f'{year}\\{month}'
        os.makedirs(DOWNLOAD_FOLDER, exist_ok=True) 
        
        my_driver = f1p.get_driver(DOWNLOAD_FOLDER)
        f1p.login_amazon(my_driver,  lib1p.config.USER, lib1p.config.PASS, lib1p.config.MFA)
        
        
        answer=""
        
        while answer != 'Yes':
            answer = input("Please login and select the desired vendor account. Did you login? Reply with 'Yes'")
        
        
        #print(argv[1])
        f=[]
        for directory, subdirectories, invoices in os.walk(DOWNLOAD_FOLDER):
            break;
        for i in invoices:
            f.append(i.split('_')[0])
        print(f)
        
        #my_file_path = os.path.join(os.getcwd()+'\\downloaded_header_invoices\\', argv[2])
        my_file_path = INVOICE_HEADER_PATH+'\\'+ argv[1]
        with open(my_file_path, mode ='r') as file_length:
            num_lines = sum(1 for _ in file_length)
            num_lines = num_lines-1 #ignore header line
        with open(my_file_path, mode ='r') as file:          
            # reading the CSV file
            csvFile = csv.DictReader(file)
            # displaying the contents of the CSV file
            current_line = 0
            for lines in csvFile:
                current_line += 1
                for attempt in range(3):
                    try:
                        invoice=lines['Invoice Number']
                        payee=lines['Payee']
                        print(f"Downloading invoice {current_line}/{num_lines}: {invoice}")
                        if invoice not in f:
                            f1p.download_invoice (my_driver, invoice, payee)
                            input_file=DOWNLOAD_FOLDER+r'\invoice_details.csv'
                            output_file=DOWNLOAD_FOLDER+r'\invoice_details2.csv'
                            f1p.preprocess_invoice_csv(input_file, output_file)
                            df = pd.read_csv(output_file, skiprows=2, index_col=False)
                            df['invoice_no']=invoice
                            df['payee']=payee
                            df.to_csv(DOWNLOAD_FOLDER+r'\\' + invoice+'_'+payee+'.csv', index=False)   
                            os.remove(output_file)
                            os.remove(input_file)
                            f.append(invoice)
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
    import sys
    main(sys.argv)    

