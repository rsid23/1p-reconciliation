drop table id_template.ds_1p_backupreport;
create table id_template.ds_1p_backupreport
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
bkup_invoice_date date,
bkup_invoicelinetype varchar,
bkup_file varchar,
row_id bigint IDENTITY(123, 1),
ts_created timestamp default sysdate 
);


drop table id_template.ds_1p_backupreport_revised;
create table id_template.ds_1p_backupreport_revised 
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
bkup_invoice_date date,
bkup_invoicelinetype varchar,
bkup_file varchar,
row_id bigint IDENTITY(123, 1),
ts_created timestamp default sysdate
);

--all backupreports_revised
COPY id_template.ds_1p_backupreport_revised   (receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoice_date, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/template/backupreports/revised/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';

--all backupreports

COPY id_template.ds_1p_backupreport (receive_date, return_date, invoice_day, transaction_type, quantity, net_receipts, net_receipts_currency, list_price, list_price_currency, rebate_in_agreement_currency, agreement_currency, rebate_in_purchase_order_currency, purchase_order_currency, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoice_date, bkup_invoicelinetype, bkup_file) from 's3://iderive-ds-1p-reconciliation/template/backupreports/processed/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';


drop table id_template.ds_1p_invoices_header;
create table id_template.ds_1p_invoices_header
(
marketplace varchar(256),
invoice_date date,
payment_due_date date,
invoice_status varchar(256),
actual_paid_amount varchar,
payee varchar(256),
invoice_creation_date date,
invoice_number varchar(256),
invoice_amount varchar,
any_deduction boolean,
row_id bigint IDENTITY(123, 1),
ts_created timestamp default sysdate 
);

-- all invoice headers
COPY id_template.ds_1p_invoices_header (marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction) from 's3://iderive-ds-1p-reconciliation/template/invoices/invoice_header/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';

drop table id_template.ds_1p_invoices_details;
create table id_template.ds_1p_invoices_details
(
po varchar(256),
external_id varchar(256),
title varchar(1024),
asin varchar(256),
model_no varchar(256),
freight_term varchar(256),
qty varchar,
unit_cost varchar,
amount varchar,
shortage varchar,
amount_shortage varchar,
last_received_date date,
asin_received varchar(256),
quantity_received varchar,
unit_cost_received varchar,
amount_received varchar,
invoice_no varchar(256),
payee varchar(256),
row_id bigint IDENTITY(123, 1),
ts_created timestamp default sysdate 
);


--all invoice details
COPY id_template.ds_1p_invoices_details (po, external_id, title, asin, model_no, freight_term, qty, unit_cost, amount, shortage, amount_shortage, last_received_date, asin_received, quantity_received, unit_cost_received, amount_received, invoice_no, payee) from 's3://iderive-ds-1p-reconciliation/template/invoices/invoice_lineitems/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';

drop table id_template.ds_1p_agreements;
create table id_template.ds_1p_agreements
(
agreement_number varchar,
invoice_number varchar,
invoice_date date,
invoice_line_type varchar,
ccogs_invoice_id varchar, 
agreement_title varchar(1024),
funding_type varchar,
agreement_pct real,
agreement_start_date date,
agreement_end_date date,
agreement_raw_text varchar(8192),
backup_rpt_file varchar,
backup_rpt_start_date date,
backup_rpt_end_date date,
cnt_backup_rptfiles int,
row_id bigint IDENTITY(123, 1),
ts_created timestamp default sysdate 
);

--all agrements
COPY id_template.ds_1p_agreements (agreement_number, invoice_number, invoice_date, invoice_line_type, ccogs_invoice_id, agreement_title, funding_type, agreement_pct, agreement_start_date, agreement_end_date, agreement_raw_text, backup_rpt_file, backup_rpt_start_date, backup_rpt_end_date, cnt_backup_rptfiles) from 's3://iderive-ds-1p-reconciliation/template/agreements/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';






