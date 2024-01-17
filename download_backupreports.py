# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from selenium.webdriver.common.by import By
import os
import time
import pandas as pd
import json
import lib1p.functions1p as f1p
import lib1p.config 





argv = ['1', '2023']




def main(argv):
    if len(argv) != 2:
        raise SystemExit(f'Usage: python {argv[0]} [year]')
        
    else :
        
        cwd = os.getcwd()
        DOWNLOAD_PATH=cwd+'\\Downloads\\backupreports'
        DOWNLOAD_PATH_AGREEMENTS=cwd+'\\Downloads\\agreements'
        os.makedirs(DOWNLOAD_PATH, exist_ok=True) 
        year = argv[1]
        DOWNLOAD_FOLDER = DOWNLOAD_PATH+'\\'+f'{year}'
        my_driver = f1p.get_driver(DOWNLOAD_FOLDER)
        f1p.login_amazon(my_driver, lib1p.config.USER, lib1p.config.PASS, lib1p.config.MFA)
        
        
        answer=""
        
        while answer != 'Yes':
            answer = input("Please login and select the desired vendor account. Did you login? Reply with 'Yes'")

        
        url = f'https://vendorcentral.amazon.com/hz/vendor/members/coop?searchText=&from_date_m=1&from_date_d=1&from_date_y={year}&to_date_m=12&to_date_d=31&to_date_y={year}'        
        my_driver.get(url)
        r1=my_driver.find_element(By.ID, "kat-invoice-table")
        m=json.loads(r1.get_attribute('rowdata'))
        total_cnt_acc_agreements = 0
        agreements_info = []
        
        for record in m:
            adt=my_driver.find_element(By.ID, "invoiceData-"+record['INVOICE_NUMBER'])
            extra=json.loads(adt.get_attribute('data-invoice-data'))
            info = f1p.get_agreement_info(record, extra)
            if info['FUNDING_TYPE']=='Accrual':
                total_cnt_acc_agreements += 1
                agreements_info.append(info)


        agreements = []
        acc_agreement = 0
        for record in agreements_info:            
           acc_agreement +=1
           a = f1p.get_agreement_details(my_driver, None, record)
           time.sleep(3)
           backupReport = f1p.get_backupreport_info(my_driver, DOWNLOAD_FOLDER, record)
           a['backupReportFile'] = backupReport['backUpReportInfos'][0]['fileName'],
           a['backupReportStart'] = backupReport['backUpReportInfos'][0]['startDate'],
           a['backupReportEnd'] = backupReport['backUpReportInfos'][0]['endDate'],
           a['cntBackupReportFiles'] = len(backupReport['backUpReportInfos'])
           agreements.append(a)
           print(f'Got agreement {acc_agreement}/{total_cnt_acc_agreements}')
        agreementsDF = pd.DataFrame(agreements)
        os.makedirs(f'{DOWNLOAD_PATH_AGREEMENTS}/{year}', exist_ok=True) 
        agreementsDF.to_csv(f'{DOWNLOAD_PATH_AGREEMENTS}/{year}/{year}.csv', index=False)
        print(f'Saved agrements file: {DOWNLOAD_PATH_AGREEMENTS}/{year}/{year}.csv')
        
if __name__ =='__main__':
    import sys
    main(sys.argv)            