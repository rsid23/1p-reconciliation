# -*- coding: utf-8 -*-
"""
Created on Fri Aug 11 13:13:08 2023

@author: catalin
"""

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.edge.options import Options
import shutil
import time
import os
import json
import lxml
from lxml import html
import re

def login_amazon(driver, user, password, mfa):
    login = True
    while login:
        if driver.title == 'Amazon Sign-In':
            elmt_user = driver.find_element(By.ID, "ap_email")
            elmt_user.clear()
            elmt_user.send_keys(user)
            elmt_pass = driver.find_element(By.ID, "ap_password")
            elmt_pass.clear()
            elmt_pass.send_keys(password)
            elmt_signin = driver.find_element(By.ID, "signInSubmit")
            elmt_signin.click()
        if driver.title == 'Two-Step Verification':
            driver.implicitly_wait(5)
            mfa_chose = driver.find_elements(By.ID, 'auth-select-device-form')
            if mfa_chose:
                elmt_choseotp = driver.find_element(By.XPATH, '//*[@id="auth-select-device-form"]/div[1]/fieldset/div[1]/label/input')
                elmt_choseotp.click()
                elmt_sendotp = driver.find_element(By.ID, 'auth-send-code')
                elmt_sendotp.click()
            else:    
                elmt_otp = driver.find_element(By.ID, "auth-mfa-otpcode")
                elmt_otp.clear()
                time.sleep(5)
                elmt_otp.send_keys(mfa.now())
                elmt_signin = driver.find_element(By.ID, "auth-signin-button")
                elmt_signin.click()
        if driver.title not in ('Amazon Sign-In', 'Two-Step Verification'):
            login = False
            
            
            
def get_driver(folder):
    
    print(folder)
    os.makedirs (folder, exist_ok=True)
    #os.makedirs (folder+'\\invoices', exist_ok=True)
    options = Options()
    options.add_experimental_option("prefs", {
            "download.default_directory": folder,
            "download.prompt_for_download": False})

    #This one is to pass bot detection at: 'https://bot.sannysoft.com/'
    options.add_argument("--disable-blink-features=AutomationControlled")

    #driver = webdriver.Edge(executable_path=r'"C:\Users\catalin\Documents\work\selenium\edgedriver_win64\msedgedriver.exe"', 
    #                        options = options)

    driver = webdriver.Edge(options = options)
    
    # Get year invoices
    url = 'https://vendorcentral.amazon.com/hz/vendor/members/inv-mgmt/search'
    url = 'https://vendorcentral.amazon.com/'
    driver.get(url)
    #driver.execute_async_script(injected_javascript)
    driver.implicitly_wait(30)
    return driver  


def download_invoice (driver, invoice, payee):    
    url = f"https://vendorcentral.amazon.com/hz/vendor/members/inv-mgmt/invoice-details?invoiceNumber={invoice}&payeeCode={payee}&activeTab=lineItems"
    driver.get(url)
    export_all = driver.find_element(By.ID, "line-items-export-to-spreadsheet-announce")
    #need to wait for numbers to be populated in the excel
    time.sleep(3)
    export_all.click()
    driver.implicitly_wait(50)
    time.sleep(5)

def download_backupreport_info(driver, folder, fileName, agreementNumber, invoiceNumber, invoiceLineType):
    url=f"https://vendorcentral.amazon.com/hz/vendor/members/coop/resource/backupreport/download?fileName={fileName}&agreementNumber={agreementNumber}&invoiceNumber={invoiceNumber}&invoiceLineType={invoiceLineType}"
    driver.get(url)
    time.sleep(3)
    source_file = folder+r'\BackupReport.xls' 
    destination_file = folder +  '/' +  str(agreementNumber) + '_' + invoiceNumber + '_' + invoiceLineType + '_' + fileName + '.xls'
    shutil.move(source_file,  destination_file)
    
def get_backupreport_info(driver, folder, agreement):
    agreementNumber = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['agreementNumber']
    invoiceNumber = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['invoiceNumber']
    invoiceLineType = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['invoiceLineType']
    ccogsInvoiceId = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['ccogsInvoiceId']
    url = f"https://vendorcentral.amazon.com/hz/vendor/members/coop/resource/backupreports/get?invoiceNumber={invoiceNumber}&agreementNumber={agreementNumber}&invoiceLineType={invoiceLineType}&ccogsInvoiceId={ccogsInvoiceId}"
    driver.get(url)
    e=driver.find_element(By.XPATH, "/html/body/pre")
    a=json.loads(e.text)
    #/html/body/pre/text
    fileName=a['backUpReportInfos'][0]['fileName']
    #print(len(a['backUpReportInfos']))
    download_backupreport_info(driver, folder, fileName, agreementNumber, invoiceNumber, invoiceLineType)
    return a
    
def get_agreement_info(agreement):    
    return {'agreementNumber': agreement['cells']['AGREEMENT_DETAILS']['value']['data']['agreementNumber'],
            'agreementType': agreement['cells']['AGREEMENT_DETAILS']['value']['data']['fundingType'],
            'cnt': 1}

#from lxml import html
#tree = html.fromstring(text)
#[td.text for td in tree.xpath("//td")]

def get_agreement_details(driver, folder,  agreement):
    agreementNumber = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['agreementNumber']
    invoiceNumber = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['invoiceNumber']
    invoiceLineType = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['invoiceLineType']
    ccogsInvoiceId = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['ccogsInvoiceId']
    fundingType = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['fundingType']
    agreementTitle = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['agreementTitle']
    url = f"https://vendorcentral.amazon.com/hz/vendor/members/coop/resource/invoice/agreement-text?agreementNumber={agreementNumber}&invoiceNumber={invoiceNumber}&invoiceLineType={invoiceLineType}&ccogsInvoiceId={ccogsInvoiceId}"
    driver.get(url)
    e=driver.find_element(By.XPATH, "/html/body/pre")
    a=json.loads(e.text)
    #print(a['agreementText'])
    tree = html.fromstring(a['agreementText'])
    try:
        
        for ul in tree.find("./body/table/tr/td/ul"):
            #Looks like the Agreement Term LI element can be anywhere in the list
            if 'Agreement Term:' in ul.text or 'Agreement term:' in ul.text:            
                agreement_dates=ul.text.strip().split(':')[1][:-1].strip().split(' to ')
                agreement_start_date=agreement_dates[0]
                agreement_end_date=agreement_dates[1]
            if 'MDF/COOP Terms:' in ul.text:            
                match = re.search(r'(\d+.\d+%+)|(\d+%+)', ul.text)  #sometimes it is 1.0% and sometimes it is 1%        
                if match:
                    agreement_pct = float(match.group()[:-1])  #get rid of % sign
        #match = re.search(r'\d+.\d+%+', agreementTitle)
        if 'agreement_pct' not in locals():
            match = re.search(r'(\d+.\d+%+)|(\d+%+)', agreementTitle)  #sometimes it is 1.0% and sometimes it is 1%        
            if match:
                agreement_pct = float(match.group()[:-1])  #get rid of % sign
                
    except AttributeError as e:
        agreement_pct = None
        agreement_start_date = None
        agreement_end_date = None
        
    backupReport = get_backupreport_info(driver, folder, agreement)
    
    return {'agreementNumber': agreementNumber,
            'invoiceNumber': invoiceNumber,
            'invoiceLineType': invoiceLineType,
            'ccogsInvoiceId': ccogsInvoiceId,
            'agreementTitle': agreementTitle,
            'fundingType': fundingType,
            'agreementPct': agreement_pct,
            'agreementStartDate': agreement_start_date,
            'agreementEndDate': agreement_end_date,
            'agreementRawText': a['agreementText'],
            'backupReportFile': backupReport['backUpReportInfos'][0]['fileName'],
            'backupReportStart': backupReport['backUpReportInfos'][0]['startDate'],
            'backupReportEnd': backupReport['backUpReportInfos'][0]['endDate'],
            'cntBackupReportFiles': len(backupReport['backUpReportInfos'])
            }          


def preprocess_invoice_csv(input_file, output_file):
    ### This function clears extra , or " in the csv file as amazon does not escape them....
    with open(input_file, 'r', encoding='UTF8') as input_file:
        with open(output_file, 'w', encoding='UTF8') as output_file:
            count = 0
            for line in input_file:
                if count<3:
                    output_file.write(line)
                else:
                    new_line=[]
                    for i in range(len(line)):
                        if line[i]==',' and i>0 and i<len(line)-1 and (line[i-1]!='"' or line[i+1]!='"'):
                            new_line.append('')            
                        elif line[i]=='"' and i>0 and i<len(line) and not (line[i-1]==',' or line[i+1]==','):
                            new_line.append('')  
                        else:
                            new_line.append(line[i])
                    new_line="".join(new_line)      
                    output_file.write(new_line)
                count +=1