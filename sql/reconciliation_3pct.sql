select * from dc_raw.ds_betterbeing_1p_invoices_details where po='8L7ZYA6M' and asin='B01D0GQ284'
select * from dc_raw.ds_betterbeing_1p_backupreport where purchase_order='8L7ZYA6M' and asin='B01D0GQ284'
SELECT receive_date, return_date, invoice_day, transaction_type, net_receipts, net_receipts_currency, list_price, list_price_currency, revised_invoice_quantity, revised_invoice_rebate, rebate_currency, new_quantity, new_rebate, old_invoice_quantity, old_invoice_rebate, purchase_order, asin, upc, ean, manufacturer, distributor, product_group, category, subcategory, title, product_description, binding, cost_currency, old_cost, new_cost, price_protection_agreement, price_protection_day, cost_variance, invoice, multi_country_parent_agreement_id, bkup_agreement, bkup_invoice, bkup_invoicelinetype, bkup_file, row_id, ts_created
--FROM dc_raw.ds_betterbeing_1p_backupreport_revised where purchase_order='141699QH';

select distinct agreement_number from dc_raw.ds_betterbeing_1p_agreements
where agreement_pct=12

SELECT marketplace, invoice_date, payment_due_date, invoice_status, actual_paid_amount, payee, invoice_creation_date, invoice_number, invoice_amount, any_deduction, row_id, ts_created
FROM dc_raw.ds_betterbeing_1p_invoices_header where invoice_number='9264561.01';

select sum(translate(case when amount='' then '0' else amount end, '$,', '')) amount, 
sum(translate(case when amount_received='' then '0' else amount_received end, '$,', '')) amount_received,
sum(translate(case when amount_shortage='' then '0' else amount_shortage end, '$,', '')) amount_shortage from
(
SELECT po, external_id, title, asin, model_no, freight_term, qty, unit_cost, amount, shortage, amount_shortage, last_received_date, asin_received, quantity_received, unit_cost_received, amount_received, invoice_no, payee, row_id, ts_created
FROM dc_raw.ds_betterbeing_1p_invoices_details where invoice_no='9264561.01'
)

select max(backup_rpt_end_date ) from dc_raw.ds_betterbeing_1p_agreements

with bkup_agreement as 
(
select br.*, a.backup_rpt_start_date, a.backup_rpt_end_date, a.agreement_pct  from dc_raw.ds_astralbeauty_lewishyman_1p_backupreport br left join dc_raw.ds_astralbeauty_lewishyman_1p_agreements a on 
--split_part(br.bkup_file,'_',4) = a.backup_rpt_file 
a.agreement_number=br.bkup_agreement and a.invoice_number =br.bkup_invoice
where a.agreement_number in (select distinct agreement_number from dc_raw.ds_astralbeauty_lewishyman_1p_agreements
--where agreement_pct=12
) --'42506050' --and a.invoice_number ='6430-452738370123'
and a.backup_rpt_start_date>='2021-06-01'
)

select distinct agreement_pct from bkup_agreement



with bkup_agreement as 
(
select br.*, a.backup_rpt_start_date, a.backup_rpt_end_date, a.agreement_pct  from dc_raw.ds_astralbeauty_lewishyman_1p_backupreport br left join dc_raw.ds_astralbeauty_lewishyman_1p_agreements a on 
--split_part(br.bkup_file,'_',4) = a.backup_rpt_file 
a.agreement_number=br.bkup_agreement and a.invoice_number =br.bkup_invoice
where a.agreement_number in (select distinct agreement_number from dc_raw.ds_astralbeauty_lewishyman_1p_agreements
--where agreement_pct=12
) --'42506050' --and a.invoice_number ='6430-452738370123'
and a.backup_rpt_start_date>='2021-06-01'
),



--select * from bkup_agreement where purchase_order='1GCLKS7B' and asin='B01GGFDVUI'
--select min(backup_rpt_start_date), max(backup_rpt_end_date) from bkup_agreement



invoices_agreement as 
(
select * from dc_raw.ds_astralbeauty_lewishyman_1p_invoices_details i where i.po in (select purchase_order from bkup_agreement)
--left join bkup_agreement b on i.asin = b.asin and i.po =b.purchase_order
)

--select * from invoices_agreement limit 100
,


--select * from invoices_agreement limit 100
--select * from dc_raw.ds_betterbeing_1p_invoices_details
--select * from dc_raw.ds_betterbeing_1p_backupreport   

pivot_amazon_fee as 
(
select bkup_agreement, agreement_pct,  purchase_order, asin, --backup_rpt_start_date, backup_rpt_end_date, 
sum(quantity) amazon_fee_quantity, sum(net_receipts) amazon_fee_net_receipts 
from bkup_agreement  
where transaction_type='Distributor Shipment'
group by bkup_agreement, agreement_pct, purchase_order, asin --, backup_rpt_start_date, backup_rpt_end_date
),

pivot_amazon_vendor_invoices as 
(
select po, asin, 
sum(translate(qty, '$, ', '')) vi_quantity, 
sum(translate(amount, '$, ', '')) vi_amount,

sum(translate(case when quantity_received='' then '0' else quantity_received end, '$,', '')) vi_quantity_received, 
sum(translate(case when amount_received='' then '0' else amount_received end, '$,', '')) vi_amount_received,
count(invoice_no) cnt_invoices

from invoices_agreement
group by po, asin
),

--select * from pivot_amazon_vendor_invoices
all_data as 
(
select a.bkup_agreement agreement, a.purchase_order po, a.asin, a.amazon_fee_quantity amazon_billed_qty, 'USD' as agreement_currency, --a.amazon_fee_net_receipts, 
v.vi_quantity vendor_invoice_qty, 'USD' vendor_invoice_currency, 'Yes' currency_match, 1 as currency_conversion_factor, --v.vi_amount, 
v.vi_quantity_received vendor_invoice_qty_received,
case when amazon_fee_quantity = 0 then 0 else amazon_fee_net_receipts/amazon_fee_quantity::float end amazon_fee_unit_price,
(amazon_fee_quantity-nvl(vi_quantity,0)) as excess_units_billed, 
(amazon_fee_quantity-nvl(vi_quantity_received,0)) as excess_units_billed_received, 
(amazon_fee_net_receipts - nvl(vi_quantity,0)*amazon_fee_unit_price) as excess_net_receipts, 
(amazon_fee_net_receipts - nvl(vi_quantity_received,0)*amazon_fee_unit_price) as excess_net_receipts_received,
--(agreement_pct*excess_net_receipts/100)::float overbilled_rebate, 
(agreement_pct*excess_net_receipts/100)::float overbilled_rebate,
(agreement_pct*excess_net_receipts_received/100)::float overbilled_rebate_received,

'Yes' as  matched, null previous_refund, 
case when excess_units_billed_received>0 then 1 else 0 end excess_quantity_flag_received, --,
case when excess_units_billed>0 then 1 else 0 end excess_quantity_flag --,
--a.backup_rpt_start_date, a.backup_rpt_end_date
from pivot_amazon_fee a left join pivot_amazon_vendor_invoices v on a.asin=v.asin and a.purchase_order=v.po
--where excess_quantity>0 
order by bkup_agreement, purchase_order, a.asin
),

cnt_bkup_invoices as 
(
select bkup_agreement, purchase_order, asin, count(distinct bkup_invoice) cnt_coop_invoices from bkup_agreement 
group by bkup_agreement, purchase_order, asin
),

dist_bkup_invoices as 
(
select distinct bkup_agreement, purchase_order, asin, bkup_invoice from bkup_agreement 
),


--select * from all_data
--select i.* from dist_bkup_invoices i inner join all_data a on i.bkup_agreement=a.agreement and i.purchase_order=a.po and i.asin=a.asin and a.excess_quantity_flag_received=1
--order by 1,2,3,4
--
--select a.agreement, a.po, a.asin, amazon_billed_qty, agreement_currency, 
--vendor_invoice_qty_received vendor_invoice_qty, 
--vendor_invoice_currency, currency_match, currency_conversion_factor, 
--excess_units_billed_received excess_units_billed, 
--excess_net_receipts_received excess_net_receipts, 
--overbilled_rebate_received overbilled_rebate,
--matched,
--previous_refund,
--bi.cnt_coop_invoices
--from all_data a left join cnt_bkup_invoices bi on a.agreement=bi.bkup_agreement and a.po=bi.purchase_order and a.asin=bi.asin
--where excess_quantity_flag_received=1


overbill_totals as 
(
select agreement, round(sum(overbilled_rebate),2) overbilled_rebate --round(sum(overbilled_rebate2),2) overbilled_rebate2 
from all_data 
where --excess_quantity_flag=1
excess_quantity_flag_received=1
group by agreement order by agreement
),

dist_agreements as 
(select distinct agreement_number, agreement_title, funding_type, agreement_pct from dc_raw.ds_astralbeauty_lewishyman_1p_agreements )

select o.*, a.agreement_title, a.agreement_pct  from overbill_totals o left join dist_agreements  a on o.agreement=a.agreement_number order by agreement_pct



select * from dc_raw.ds_astralbeauty_lewishyman_1p_agreements  order by agreem

SELECT agreement_number, agreement_title,  count(*) cnt, min(backup_rpt_start_date) start_date, max(backup_rpt_end_date) end_date
FROM dc_raw.ds_betterbeing_1p_agreements
where agreement_pct =3
group by agreement_number, agreement_title  

select * from dc_raw.ds_betterbeing_1p_invoices_details where po='141699QH'
