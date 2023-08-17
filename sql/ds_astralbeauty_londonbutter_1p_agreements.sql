drop table dc_raw.ds_astralbeauty_londonbutter_1p_agreements;
create table dc_raw.ds_astralbeauty_londonbutter_1p_agreements
(
agreement_number varchar,
invoice_number varchar,
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



COPY dc_raw.ds_astralbeauty_londonbutter_1p_agreements (agreement_number, invoice_number, invoice_line_type, ccogs_invoice_id, agreement_title, funding_type, agreement_pct, agreement_start_date, agreement_end_date, agreement_raw_text, backup_rpt_file, backup_rpt_start_date, backup_rpt_end_date, cnt_backup_rptfiles) from 's3://iderive-ds-1p-reconciliation/londonbutter/agreements/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';
