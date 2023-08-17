drop table dc_raw.ds_astralbeauty_pur_1p_backupreport;
create table dc_raw.ds_astralbeauty_pur_1p_backupreport
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



create table dc_raw.ds_astralbeauty_pur_1p_backupreport_revised 
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
COPY dc_raw.ds_astralbeauty_pur_1p_backupreport_revised  (receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/pur/backupreports_revised/2023/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
COPY dc_raw.ds_astralbeauty_pur_1p_backupreport_revised  (receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/pur/backupreports_revised/2022/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
COPY dc_raw.ds_astralbeauty_pur_1p_backupreport_revised  (receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/pur/backupreports_revised/2021/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';

truncate 

--2023
COPY dc_raw.ds_astralbeauty_pur_1p_backupreport (receive_date, return_date, invoice_day, transaction_type, quantity, net_receipts, net_receipts_currency, list_price, list_price_currency, rebate_in_agreement_currency, agreement_currency, rebate_in_purchase_order_currency, purchase_order_currency, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/pur/backupreports/2023/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
--2022
COPY dc_raw.ds_astralbeauty_pur_1p_backupreport (receive_date, return_date, invoice_day, transaction_type, quantity, net_receipts, net_receipts_currency, list_price, list_price_currency, rebate_in_agreement_currency, agreement_currency, rebate_in_purchase_order_currency, purchase_order_currency, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/pur/backupreports/2022/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
--2021
COPY dc_raw.ds_astralbeauty_pur_1p_backupreport (receive_date, return_date, invoice_day, transaction_type, quantity, net_receipts, net_receipts_currency, list_price, list_price_currency, rebate_in_agreement_currency, agreement_currency, rebate_in_purchase_order_currency, purchase_order_currency, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/pur/backupreports/2021/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';

select count(distinct  bkup_file) from dc_raw.ds_astralbeauty_pur_1p_backupreport
select count(distinct  bkup_file) from dc_raw.ds_astralbeauty_pur_1p_backupreport_revised

select * from dc_raw.ds_astralbeauty_pur_1p_backupreport_revised

