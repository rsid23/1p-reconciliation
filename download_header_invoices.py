# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.edge.options import Options
import os
import datetime
import time
import lib1p.functions1p as f1p
import lib1p.config 



cwd = os.getcwd()
DOWNLOAD_PATH=cwd+'\\Downloads\\invoices\\invoice_header'
os.makedirs(DOWNLOAD_PATH, exist_ok=True) 

argv = ['1', '2023']

my_driver = ''
def main(argv):
    if len(argv) != 2:
        raise SystemExit(f'Usage: python {argv[0]} [year]')
        
    else :
        DOWNLOAD_FOLDER = DOWNLOAD_PATH+'\\'+f'{argv[1]}'
        my_driver = f1p.get_driver(DOWNLOAD_FOLDER)
        f1p.login_amazon(my_driver, lib1p.config.USER, lib1p.config.PASS, lib1p.config.MFA)
        
        
        answer=""
        
        while answer != 'Yes':
            answer = input("Please login and select the desired vendor account. Did you login? Reply with 'Yes'")
        
        url = 'https://vendorcentral.amazon.com/hz/vendor/members/inv-mgmt/search'
        my_driver.get(url)
        year = int(argv[1])
        today = datetime.date.today()    
        for m in range(12):
            # for current year we only pull months up to previous month
            if today.year==year and today.month<=m+1:
                break
            start_date=my_driver.find_element(By.ID, "start-date")
            start_date.clear();
            start_date.send_keys(f"{m+1}/1/{year}")
            end_date=my_driver.find_element(By.ID, "end-date")
            end_date.clear()
            test_date = datetime.datetime(year, m+1, 28)
            nxt_mnth = test_date + datetime.timedelta(days=4)
            res = nxt_mnth - datetime.timedelta(days=nxt_mnth.day)
            end_date.send_keys(f"{m+1}/{res.day}/{year}")
            search = my_driver.find_element(By.ID, "advancedSearchHarmonicForm-submit")
            search.click()
            #driver.implicitly_wait(25)
            el = WebDriverWait(my_driver, timeout=120).until(lambda d: d.find_element(By.XPATH,'//*[@id="advancedSearchResponseMelodicTable-melodic-wrapper"]/div[1]/div').is_displayed()==False)
            export = my_driver.find_element(By.ID, "advancedSearchExportAll")
            time.sleep(3)
            export.click()
            el = WebDriverWait(my_driver, timeout=120).until(lambda d: d.find_element(By.ID,"advancedSearchExportAll").text=='Export All')
            print(f'Dowloaded invoice summary for :{year}/{m+1}')            
            files = os.listdir(DOWNLOAD_FOLDER)
            for file in files:
                if 'Invoice' in file:
                    os.rename(DOWNLOAD_FOLDER+'/'+file, DOWNLOAD_FOLDER+'/'+f"{year}{m+1:02d}.csv")
            my_driver.implicitly_wait(5)


if __name__ =='__main__':
    import sys
    main(sys.argv)    