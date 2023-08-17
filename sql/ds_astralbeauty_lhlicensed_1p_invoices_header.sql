drop table dc_raw.ds_astralbeauty_lhlicensed_1p_invoices_header;
create table dc_raw.ds_astralbeauty_lhlicensed_1p_invoices_header
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
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_invoices_header (marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/invoices/invoice_header/2021/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';
--2022
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_invoices_header (marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/invoices/invoice_header/2022/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';
--2023
COPY dc_raw.ds_astralbeauty_lhlicensed_1p_invoices_header (marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lhlicensed/invoices/invoice_header/2023/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 DATEFORMAT 'auto';


s3://iderive-ds-models/vendor_central_betterbeing_1p/invoices/invoice_lineitems/9317091.01_3H19S.csv


select * from stl_load_errors order by starttime desc

select * from dc_raw.ds_astralbeauty_lewishyman_1p_invoices_header limit 100


SELECT row_id, ts_created, start_time, end_time, status, rows_moved, id, dataset_name, datasource_name, account_name, errors
FROM dc_raw.logs_logs where dataset_name like 'ModernGourmet_Belgium_ASC_FBA_Manage_Inventory' order by start_time;
