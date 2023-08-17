drop table dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport;
create table dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport
(
receive_date date,
return_date date,
invoice_day date,
transaction_type varchar,
quantity real,
net_receipts real,
net_receipts_currency varchar,
list_price real,
list_price_currency varchar,
rebate_in_agreement_currency real,
agreement_currency varchar,
rebate_in_purchase_order_currency real,
purchase_order_currency varchar,
purchase_order varchar,
asin varchar,
upc varchar,
ean varchar,
manufacturer varchar,
distributor varchar,
product_group varchar,
category varchar,
subcategory varchar,
title varchar,
product_description varchar(4096),
binding varchar,
cost_currency real,
old_cost real,
new_cost real, 
price_protection_agreement varchar,
price_protection_day varchar,
cost_variance real,
invoice varchar,
multi_country_parent_agreement_id varchar,
bkup_agreement varchar,
bkup_invoice varchar,
bkup_invoicelinetype varchar,
bkup_file varchar,
row_id bigint IDENTITY(123, 1),
ts_created timestamp default sysdate 
);



create table dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport_revised 
(
receive_date date,
return_date date,
invoice_day date,
transaction_type varchar,
net_receipts real,
net_receipts_currency varchar,
list_price real,
list_price_currency varchar,
revised_invoice_quantity real,
revised_invoice_rebate real,
rebate_currency varchar,
new_quantity real,
new_rebate real,
old_invoice_quantity real,
old_invoice_rebate real,
purchase_order varchar,
asin varchar,
upc varchar,
ean varchar,
manufacturer varchar,
distributor varchar,
product_group varchar,
category varchar,
subcategory varchar,
title varchar,
product_description varchar(4096),
binding varchar,
cost_currency real,
old_cost real,
new_cost real,
price_protection_agreement varchar,
price_protection_day varchar,
cost_variance real,
invoice varchar,
multi_country_parent_agreement_id varchar,
bkup_agreement varchar,
bkup_invoice varchar,
bkup_invoicelinetype varchar,
bkup_file varchar,
row_id bigint IDENTITY(123, 1),
ts_created timestamp default sysdate
)

--2023
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport_revised  (receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/backupreports_revised/2023/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport_revised  (receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/backupreports_revised/2022/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport_revised  (receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/backupreports_revised/2021/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';

truncate 

--2023
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport (receive_date, return_date, invoice_day, transaction_type, quantity, net_receipts, net_receipts_currency, list_price, list_price_currency, rebate_in_agreement_currency, agreement_currency, rebate_in_purchase_order_currency, purchase_order_currency, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/backupreports/2023/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
--2022
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport (receive_date, return_date, invoice_day, transaction_type, quantity, net_receipts, net_receipts_currency, list_price, list_price_currency, rebate_in_agreement_currency, agreement_currency, rebate_in_purchase_order_currency, purchase_order_currency, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/backupreports/2022/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
--2021
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport (receive_date, return_date, invoice_day, transaction_type, quantity, net_receipts, net_receipts_currency, list_price, list_price_currency, rebate_in_agreement_currency, agreement_currency, rebate_in_purchase_order_currency, purchase_order_currency, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/backupreports/2021/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';

select count(distinct  bkup_file) from dc_raw.ds_astralbeauty_lewishyman_1p_backupreport
select count(distinct  bkup_file) from dc_raw.ds_betterbeing_1p_backupreport_revised

select * from dc_raw.ds_betterbeing_1p_backupreport_revised

s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2022/42729055_6430-556623700_Positive_518456d4-b501-4b2d-850a-f1661c5d15bc.csv                                                                                                               

s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/45505905_6430-548016420_Positive_766b70f4-4065-46e6-929a-a3e7828f951e.csvcsv                                                                                                            
select * from stl_load_errors order by starttime desc

2021 - updates 
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/45505905_6430-548016420_Positive_766b70f4-4065-46e6-929a-a3e7828f951e.csv
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/48426570_6430-546292165_Positive_cd7920bc-51aa-4381-8f5b-de8a28b92af5.csv                                                                                                               
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/42506050_6430-545309300_Positive_a009a8f3-75e4-4415-9769-f3515967d58c.csv
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/42726030_6430-546737375_Positive_ead5ec09-2a03-40a7-80cb-1b02fa2f1451.csv
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/42729055_6430-546760205_Positive_ddcc6751-b2d5-4329-8644-a6b2774821a6.csv
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/42729070_6430-546760225_Positive_8bbe9a81-3794-42fd-b12b-c23420f2f51e.csv
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2021/42729090_6430-546759090_Positive_0368f3af-a9da-4364-9fc3-36dcb1a150df.csv
2022 - updates
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2022/50373275_6430-596547655_Positive_2932ecc1-dbeb-4b9e-a548-9314f93165ac.csv    
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2022/50377610_6430-596570375_Positive_2ca6b799-b057-4788-bcac-245838afe348.csv 
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2022/50377635_6430-596570435_Positive_083709fc-4ef9-456c-91de-d04f7c950bca.csv  
s3://iderive-ds-models/vendor_central_betterbeing_1p/backupreports/2022/50377660_6430-596570655_Positive_0e9fa166-66f5-49df-a3bf-78f52d80f43b.csv                                                                                                               
