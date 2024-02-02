# -*- coding: utf-8 -*-

from selenium.webdriver.common.by import By
import os
import time
import pandas as pd
import json
import lib1p.functions1p as f1p
import lib1p.config
from itertools import chain

 

def main(argv):
    if len(argv) != 6:
        #raise SystemExit(f'Usage: python {argv[0]} [year]')
        print(argv)
        raise SystemExit('Please pass the right arguments in following format: date_start, month_start, date_end, month_end, year')
        
    else :
        
        cwd = os.getcwd()
        DOWNLOAD_PATH=cwd+'\\Downloads\\backupreports'
        DOWNLOAD_PATH_AGREEMENTS=cwd+'\\Downloads\\agreements'
        os.makedirs(DOWNLOAD_PATH, exist_ok=True) 
        date_start = argv[1]
        month_start = argv[2]
        date_end = argv[3]
        month_end = argv[4]
        year = argv[5]
        DOWNLOAD_FOLDER = DOWNLOAD_PATH+'\\'+f'{year}'
        my_driver = f1p.get_driver(DOWNLOAD_FOLDER)
        f1p.login_amazon(my_driver, lib1p.config.USER, lib1p.config.PASS, lib1p.config.MFA)
        
        
        answer=""
        
        while answer != 'Yes':
            answer = input("Please login and select the desired vendor account. Did you login? Reply with 'Yes'")

        
        url = f'https://vendorcentral.amazon.com/hz/vendor/members/coop?searchText=&from_date_m={month_start}&from_date_d={date_start}&from_date_y={year}&to_date_m={month_end}&to_date_d={date_end}&to_date_y={year}'        
        my_driver.get(url)
        time.sleep(5)
        pages =my_driver.find_element(By.ID, 'pagination')
        cnt = 0
        for page in pages.text:
            if page.isnumeric():
                cnt+=1
        print(f'PAGES TO ITERATE:{cnt}')
        m=[]
        for i in range(1,cnt+1):
            my_driver.execute_script(f"arguments[0].setAttribute('page', '{i}')", pages)
            print(f'CLICKED PAGE:{i}')
            r1=my_driver.find_element(By.ID, "kat-invoice-table")
            data=json.loads(r1.get_attribute('rowdata'))
            m.append(data)
            print('PRINTING M TYPE')
            print(type(m))
            time.sleep(5)
        total_cnt_acc_agreements = 0
        agreements_info = []
        m = list(chain(*m))
        print(m)
        for record in m:
            adt=my_driver.find_element(By.ID, "invoiceData-"+record['INVOICE_NUMBER'])
            extra=json.loads(adt.get_attribute('data-invoice-data'))
            info = f1p.get_agreement_info(record, extra)
            if info['FUNDING_TYPE']=='Accrual':
                total_cnt_acc_agreements += 1
                agreements_info.append(info)
        print(f'LENGTH IS:{total_cnt_acc_agreements}')

        agreements = []
        acc_agreement = 0
        for record in agreements_info:            
           acc_agreement +=1
           a = f1p.get_agreement_details(my_driver, None, record)
           time.sleep(5)
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
