drop table dc_raw.ds_astralbeauty_lewishyman_1p_agreements;
create table dc_raw.ds_astralbeauty_lewishyman_1p_agreements
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

truncate table dc_raw.ds_astralbeauty_lewishyman_1p_agreements;
COPY dc_raw.ds_astralbeauty_lewishyman_1p_agreements (agreement_number, invoice_number, invoice_line_type, ccogs_invoice_id, agreement_title, funding_type, agreement_pct, agreement_start_date, agreement_end_date, agreement_raw_text, backup_rpt_file, backup_rpt_start_date, backup_rpt_end_date, cnt_backup_rptfiles) from 's3://iderive-ds-1p-reconciliation/astralbeauty/lewishyman/agreements/' iam_role 'arn:aws:iam::467175486680:role/iderive-ds-reads3' format csv delimiter as ',' ignoreheader 1 BLANKSASNULL DATEFORMAT 'auto';

select count(*) from dc_raw.ds_astralbeauty_lewishyman_1p_agreements
                                                                                                  
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
