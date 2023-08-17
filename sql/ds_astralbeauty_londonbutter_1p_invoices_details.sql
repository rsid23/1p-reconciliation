drop table dc_raw.ds_astralbeauty_londonbutter_1p_invoices_details;
create table dc_raw.ds_astralbeauty_londonbutter_1p_invoices_details
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


--2021
COPY dc_raw.ds_astralbeauty_londonbutter_1p_invoices_details (po, external_id, title, asin, model_no, freight_term, qty, unit_cost, amount, shortage, amount_shortage, last_received_date, asin_received, quantity_received, unit_cost_received, amount_received, invoice_no, payee) from 's3://iderive-ds-1p-reconciliation/londonbutter/invoices/invoice_lineitems/2021/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';

--2022
COPY dc_raw.ds_astralbeauty_londonbutter_1p_invoices_details (po, external_id, title, asin, model_no, freight_term, qty, unit_cost, amount, shortage, amount_shortage, last_received_date, asin_received, quantity_received, unit_cost_received, amount_received, invoice_no, payee) from 's3://iderive-ds-1p-reconciliation/londonbutter/invoices/invoice_lineitems/2022/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';

--2023
COPY dc_raw.ds_astralbeauty_londonbutter_1p_invoices_details (po, external_id, title, asin, model_no, freight_term, qty, unit_cost, amount, shortage, amount_shortage, last_received_date, asin_received, quantity_received, unit_cost_received, amount_received, invoice_no, payee) from 's3://iderive-ds-1p-reconciliation/londonbutter/invoices/invoice_lineitems/2023/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';

