drop table dc_raw.ds_vega_1p_invoices_header;
create table dc_raw.ds_vega_1p_invoices_header
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

--2021
COPY dc_raw.ds_vega_1p_invoices_header (marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction) from 's3://iderive-ds-1p-reconciliation/vega/invoices/invoice_header/2021/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';
--2022
COPY dc_raw.ds_vega_1p_invoices_header (marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction) from 's3://iderive-ds-1p-reconciliation/vega/invoices/invoice_header/2022/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';
--2023
COPY dc_raw.ds_vega_1p_invoices_header (marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction) from 's3://iderive-ds-1p-reconciliation/vega/invoices/invoice_header/2023/202306.csv' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';

truncate table dc_raw.ds_vega_1p_invoices_header
