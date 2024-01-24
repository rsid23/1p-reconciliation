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
import datetime
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
            login=False
        if driver.title == 'Two-Step Verification':
            driver.implicitly_wait(5)
            elmt_otp = driver.find_element(By.ID, "auth-mfa-otpcode")
            elmt_otp.clear()
            time.sleep(5)
            elmt_otp.send_keys(mfa.now())
            elmt_signin = driver.find_element(By.ID, "auth-signin-button")
            elmt_signin.click()
        #if driver.title not in ('Amazon Sign-In', 'Two-Step Verification'):
        #    login = False

'''
        if driver.title == 'Two-Step Verification':
            driver.implicitly_wait(5)
            mfa_chose = driver.find_elements(By.ID, 'auth-mfa-otpcode')
            if mfa_chose:
                #elmt_choseotp = driver.find_element(By.XPATH, '//*[@id="auth-select-device-form"]/div[1]/fieldset/div[1]/label/input')
                elmt_choseotp = driver.find_element(By.ID, "auth-mfa-otpcode")
                #elmt_choseotp.click()
                elmt_choseotp
                elmt_sendotp = driver.find_element(By.ID, 'auth-send-code')
                elmt_sendotp.click()
        
'''          
            
            
            
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
    options.add_argument("--disable-features=msEdgeJSONViewer") #this one is to force Edge to not use formatting for json objects

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

def download_backupreport_info(driver, folder, fileName, agreementNumber, invoiceNumber, invoiceLineType, invoiceDate):
    url=f"https://vendorcentral.amazon.com/hz/vendor/members/coop/resource/backupreport/download?fileName={fileName}&agreementNumber={agreementNumber}&invoiceNumber={invoiceNumber}&invoiceLineType={invoiceLineType}"
    driver.get(url)
    time.sleep(10) #Sometimes files take longer to download so this might need to be increased so that the file to be completely donwloaded before gettig to rename it.
    source_file = os.path.join(folder, 'BackupReport.xls') 
    destination_file = os.path.join(folder, str(agreementNumber) + '_' + invoiceNumber + '_' + invoiceLineType + '_' + invoiceDate + '_' + fileName + '.xls')
    shutil.move(source_file,  destination_file)
    
def get_backupreport_info(driver, folder, agreement):
    #greementNumber = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['agreementNumber']
    #invoiceNumber = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['invoiceNumber']
    #invoiceLineType = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['invoiceLineType']
    #ccogsInvoiceId = agreement['cells']['AGREEMENT_DETAILS']['value']['data']['ccogsInvoiceId']
    #invoiceDate = datetime.date(agreement['cells']['INVOICE_DATE']['value'][0], agreement['cells']['INVOICE_DATE']['value'][1], agreement['cells']['INVOICE_DATE']['value'][2]).isoformat()
    agreementNumber = agreement['AGREEMENT_NUMBER']
    invoiceNumber = agreement['INVOICE_NUMBER']
    invoiceLineType = agreement['INVOICE_LINE_TYPE']
    ccogsInvoiceId = agreement['CCOGSINVOICEID']
    invoiceDate = agreement['INVOICE_DATE']
    
    #inv_mth, inv_day, inv_year = agreement['INVOICE_DATE'].split('/')
    #invoiceDate = datetime.date(inv_year, inv_mth, inv_day).isoformat()
    
    url = f"https://vendorcentral.amazon.com/hz/vendor/members/coop/resource/backupreports/get?invoiceNumber={invoiceNumber}&agreementNumber={agreementNumber}&invoiceLineType={invoiceLineType}&ccogsInvoiceId={ccogsInvoiceId}"
    driver.get(url)
    e=driver.find_element(By.XPATH, "/html/body/pre")
    a=json.loads(e.text)
    #/html/body/pre/text
    fileName=a['backUpReportInfos'][0]['fileName']
    #print(len(a['backUpReportInfos']))
    download_backupreport_info(driver, folder, fileName, agreementNumber, invoiceNumber, invoiceLineType, invoiceDate)
    return a
    
def get_agreement_info(agreement, extra):    
    mth, day, year = agreement['INVOICE_DATE'].split('/')
    invoiceDate = datetime.date(int(year), int(mth), int(day)).isoformat()
    
    
    return {'AGREEMENT_NUMBER': agreement['AGREEMENT_NUMBER'],
            'AGREEMENT_TITLE': agreement['AGREEMENT_TITLE'],
            'INVOICE_NUMBER': agreement['INVOICE_NUMBER'],
            'INVOICE_DATE': invoiceDate,
            'FUNDING_TYPE': agreement['FUNDING_TYPE'],
            'INVOICE_LINE_TYPE': extra['invoiceLineType'],
            'CCOGSINVOICEID': extra['ccogsInvoiceId'],
            'cnt': 1}

#from lxml import html
#tree = html.fromstring(text)
#[td.text for td in tree.xpath("//td")]

def get_agreement_details(driver, folder,  agreement):
    agreementNumber = agreement['AGREEMENT_NUMBER']
    agreementTitle = agreement['AGREEMENT_TITLE']
    invoiceNumber = agreement['INVOICE_NUMBER']
    fundingType = agreement['FUNDING_TYPE']
    invoiceLineType = agreement['INVOICE_LINE_TYPE']
    ccogsInvoiceId = agreement['CCOGSINVOICEID']
    invoiceDate = agreement['INVOICE_DATE']
    #agreementText = agreement['agreementText']
    #invoiceDate = datetime.date(agreement['cells']['INVOICE_DATE']['value'][0], agreement['cells']['INVOICE_DATE']['value'][1], agreement['cells']['INVOICE_DATE']['value'][2]).isoformat()
    url = f"https://vendorcentral.amazon.com/hz/vendor/members/coop/resource/invoice/agreement-text?agreementNumber={agreementNumber}&invoiceNumber={invoiceNumber}&invoiceLineType={invoiceLineType}&ccogsInvoiceId={ccogsInvoiceId}"
    print(f"getting agreement details: {url}")
    print(f'agreement number: {agreementNumber}')
    print(f'agreement title: {agreementTitle}')
    print(f'invoice number: {invoiceNumber}')
    print(f'funding type: {fundingType}')


    driver.get(url)
    time.sleep(5)
    e=driver.find_element(By.XPATH, "/html/body/pre")
    rawText = driver.find_element(By.TAG_NAME,"body").text
    a=json.loads(e.text)
    a = a['agreementText'].replace('\n','')
    a = a.replace('<br>','')
    #tree = html.fromstring(a['agreementText'].replace('\n',''))
    tree = html.fromstring(a) 
    #print('HTML AS STRING')
    #print(html.tostring(tree, pretty_print=True))
    date_pattern = re.compile(r'from (\w+ \d{2}, \d{4}) to (\w+ \d{2}, \d{4})')
    if 'Provisional CoOp' not in agreementTitle:
        try:
            for ul in tree.find("./body/table/tr/td/ul"):
                #Looks like the Agreement Term LI element can be anywhere in the list
                #print(ul.text)
                if ul.text:  #Sometimes ul.text is empty / None 
                    if 'agreement is valid' in ul.text or 'agreement:' in ul.text: 
                        match = date_pattern.search(ul.text)
                        agreement_start_date=match.group(1)
                        agreement_end_date=match.group(2)                        
                        #agreement_dates=ul.text.strip().split(':')[1][:-1].strip().split(' to ')
                        #agreement_start_date=agreement_dates[0]
                        #agreement_end_date=agreement_dates[1]
                    if 'MDF or COOP' in ul.text: 
                        date_pattern = re.compile(r'(\w+ \d{2}, \d{4}) - (\w+ \d{2}, \d{4})')
                        match = date_pattern.search(ul.text)
                        agreement_start_date=match.group(1)
                        agreement_end_date=match.group(2)
                        match = re.search(r'(\d+.\d+%+)|(\d+%+)', ul.text)  #sometimes it is 1.0% and sometimes it is 1%        
                        if match:
                            agreement_pct = float(match.group()[:-1])  #get rid of % sign
                    if 'Freight Allowance Terms:' in ul.text:            
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
    else:
        agreement_start_date = None
        agreement_end_date = None
        agreement_pct = None
    #backupReport = get_backupreport_info(driver, folder, agreement)
    return {'agreementNumber': agreementNumber,
            'invoiceNumber': invoiceNumber,
            'invoiceDate': invoiceDate,
            'invoiceLineType': invoiceLineType,
            'ccogsInvoiceId': ccogsInvoiceId,
            'agreementTitle': agreementTitle,
            'fundingType': fundingType,
            'agreementPct': agreement_pct,
            'agreementStartDate': agreement_start_date,
            'agreementEndDate': agreement_end_date,
            'agreementRawText': rawText,
#            'backupReportFile': backupReport['backUpReportInfos'][0]['fileName'],
#            'backupReportStart': backupReport['backUpReportInfos'][0]['startDate'],
#            'backupReportEnd': backupReport['backUpReportInfos'][0]['endDate'],
#            'cntBackupReportFiles': len(backupReport['backUpReportInfos'])
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