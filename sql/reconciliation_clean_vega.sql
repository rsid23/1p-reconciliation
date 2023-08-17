with 
dist_agreements as 
(
select distinct agreement_number, agreement_title , agreement_pct, agreement_start_date , agreement_end_date from dc_raw.ds_vega_1p_agreements
where agreement_pct is not null
), 

revised_bkups as 
(
select b.receive_date , b.bkup_agreement, b.bkup_invoice, b.purchase_order, b.asin, b.transaction_type, case when br.new_quantity is not null then br.new_quantity else b.quantity end quantity,
case when br.net_receipts is not null then br.net_receipts else b.net_receipts end net_receipts
--b.quantity, b.net_receipts,  br.new_quantity, br.net_receipts,
--case when br.new_quantity is not null then br.new_quantity else b.quantity end f_quantity, 
--case when br.net_receipts is not null then br.net_receipts else b.net_receipts end f_net_receipts
from dc_raw.ds_vega_1p_backupreport b 
left join dc_raw.ds_vega_1p_backupreport_revised br on b.asin=br.asin and b.purchase_order=br.purchase_order and b.bkup_agreement =br.bkup_agreement and b.transaction_type =br.transaction_type 
and b.quantity =br.old_invoice_quantity and br.receive_date =b.receive_date and br.old_invoice_quantity >0
where b.transaction_type='Distributor Shipment'
),

non_zero as 

(
select receive_date, bkup_agreement, bkup_invoice, purchase_order, asin, transaction_type, new_quantity, net_receipts from
dc_raw.ds_vega_1p_backupreport_revised where old_invoice_quantity =0 and transaction_type='Distributor Shipment'
),

all_bkups as 
(
select receive_date, bkup_agreement, bkup_invoice, purchase_order, asin, transaction_type, quantity, net_receipts from revised_bkups 
union
select receive_date, bkup_agreement, bkup_invoice, purchase_order, asin, transaction_type, new_quantity quantity, net_receipts from non_zero
),

--
--all_bkups as
--(
--select bkup_agreement, bkup_invoice, purchase_order, asin, transaction_type, quantity, net_receipts from dc_raw.ds_astralbeauty_lhlicensed_1p_backupreport
--union all
--select bkup_agreement, bkup_invoice, purchase_order, asin, transaction_type, quantity, net_receipts from --dc_raw.ds_betterbeing_1p_backupreport
--dc_raw.ds_astralbeauty_lewishyman_1p_backupreport_revised
--),

--select * from ds_astralbeauty_lhlicensed_1p_backupreport_revised where old_invoice_quantity=0
--select * from ds_astralbeauty_lhlicensed_1p_backupreport where asin='B01GGISAKQ' and purchase_order='41O78ZNE' and bkup_agreement='50376505'
--select * from ds_astralbeauty_lhlicensed_1p_backupreport where asin='B00J8SOIVW' and purchase_order='4EDO1VTO' and bkup_agreement='42728255'
--select * from ds_astralbeauty_lhlicensed_1p_backupreport where asin='B00BTMU8VY' and purchase_order='8EZQWHDT' and bkup_agreement='50415830' and quantity=old_invoice_quantity


bkup_agreement as 
(
select br.*, a.backup_rpt_start_date, a.backup_rpt_end_date, a.agreement_pct  from all_bkups  --dc_raw.ds_betterbeing_1p_backupreport 
br left join dc_raw.ds_vega_1p_agreements 
--dc_raw.ds_astralbeauty_lewishyman_1p_agreements
a on 
--split_part(br.bkup_file,'_',4) = a.backup_rpt_file 
a.agreement_number=br.bkup_agreement and a.invoice_number =br.bkup_invoice
where a.agreement_number in (select agreement_number from 
dist_agreements
--dc_raw.ds_astralbeauty_lhlicensed_1p_agreements
--dc_raw.ds_astralbeauty_lewishyman_1p_agreements
--where agreement_pct=10
) --'42506050' --and a.invoice_number ='6430-452738370123'
and a.backup_rpt_start_date>='2021-01-01' and a.backup_rpt_end_date<='2023-06-30'
),



--select * from bkup_agreement where purchase_order='1GCLKS7B' and asin='B01GGFDVUI'
--select min(backup_rpt_start_date), max(backup_rpt_end_date) from bkup_agreement



invoices_agreement as 
(
select * from 
dc_raw.ds_vega_1p_invoices_details i
--dc_raw.ds_astralbeauty_lewishyman_1p_invoices_details i 

where i.po in (select purchase_order from bkup_agreement)
--left join bkup_agreement b on i.asin = b.asin and i.po =b.purchase_order
),


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

sum(translate(case when quantity_received='' then '0' else quantity_received end, '$, ', '')) vi_quantity_received, 
sum(translate(case when amount_received='' then '0' else amount_received end, '$,' , '')) vi_amount_received,
count(invoice_no) cnt_invoices

from invoices_agreement
group by po, asin
),


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
amazon_fee_net_receipts*agreement_pct/100::float total_rebate,
amazon_fee_net_receipts,
'Yes' as  matched, null previous_refund, 
case when excess_units_billed_received>0 then 1 
	 when excess_units_billed_received=0 then 0
	 when excess_units_billed_received<0 then -1 
	 else null end excess_quantity_flag_received, --,
case when excess_units_billed>0 then 1 
	 when excess_units_billed=0 then 0
	 when excess_units_billed<0 then -1
	 else null end excess_quantity_flag --,
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


overbill_totals as 
(
select agreement, --round(sum(overbilled_rebate),2) overbilled_rebate, 
 round(sum(case when excess_quantity_flag_received=1 then overbilled_rebate_received else 0 end),2) overbilling_by_invoice_received_qty,
 round(sum(case when excess_quantity_flag_received=-1 then overbilled_rebate_received else 0 end),2) underbilling_by_invoice_received_qty,
 round(sum(case when excess_quantity_flag=1 then overbilled_rebate else 0 end),2) overbilling_by_invoice_qty,
 round(sum(case when excess_quantity_flag=-1 then overbilled_rebate else 0 end),2) underbilling_by_invoice_qty,
 round(sum(case when excess_quantity_flag_received=0 then total_rebate else 0 end),2) matched_by_invoice_received_qty,
 round(sum(case when excess_quantity_flag=0 then total_rebate else 0 end),2) matched_by_invoice_qty

 --, count(*) cnt --round(sum(overbilled_rebate2),2) overbilled_rebate2 
from all_data 
--where --excess_quantity_flag=1
--excess_quantity_flag_received=1
group by agreement --order by agreement
),

total_bills as (
select agreement, agreement_pct, sum(total_rebate) invoiced_fees, sum(amazon_fee_net_receipts) total_net_receipts from all_data left join dist_agreements on all_data.agreement=dist_agreements.agreement_number
group by agreement, agreement_pct order by 2
)

--Totals

--select tb.agreement, tb.invoiced_fees, --tb.total_net_receipts,
-- orr.overbilling_by_invoice_received_qty, orr.underbilling_by_invoice_received_qty, orr.matched_by_invoice_received_qty,
--orr.overbilling_by_invoice_qty, orr.underbilling_by_invoice_qty, orr.matched_by_invoice_qty,
--da.agreement_title, da.agreement_pct, da.agreement_start_date, da.agreement_end_date
--from total_bills tb left join overbill_totals orr on tb.agreement=orr.agreement
--left join dist_agreements da on tb.agreement=da.agreement_number
--order by da.agreement_pct desc, tb.agreement


--
--select ot.*, tb.invoiced_rebate, tb.total_fee_net_receipts , da.agreement_title, da.agreement_pct, da.agreement_start_date, da.agreement_end_date from overbill_totals ot left join total_bills tb on ot.agreement=tb.agreement
--left join dist_agreements da on ot.agreement=da.agreement_number
--order by agreement_pct, agreement

--select o.*, a.agreement_title, a.agreement_pct, a.agreement_start_date, a.agreement_end_date  from overbill_totals o left join dist_agreements  a on o.agreement=a.agreement_number order by agreement_pct


-- invoices file
select i.* from dist_bkup_invoices i inner join all_data a on i.bkup_agreement=a.agreement and i.purchase_order=a.po and i.asin=a.asin and a.excess_quantity_flag_received=1
order by 1,2,3,4

--bkup report file
select a.agreement, a.po, a.asin, amazon_billed_qty, agreement_currency, 
vendor_invoice_qty_received, 
vendor_invoice_currency, currency_match, currency_conversion_factor, 
excess_units_billed_received excess_units_billed, 
excess_net_receipts_received excess_net_receipts, 
overbilled_rebate_received overbilled_rebate,
matched,
previous_refund
--bi.cnt_coop_invoices
from all_data a --a left join cnt_bkup_invoices bi on a.agreement=bi.bkup_agreement and a.po=bi.purchase_order and a.asin=bi.asin
where excess_quantity_flag_received=1


--totals
select agreement, ag.agreement_title , ag.agreement_pct, ag.agreement_start_date , ag.agreement_end_date , round(sum(overbilled_rebate_received),2) overbilled_rebate --, round(sum(overbilled_rebate2),2) overbilled_rebate2 
from all_data ad left join 
dist_agreements ag on ad.agreement=ag.agreement_number 
where --excess_quantity_flag2=1
excess_quantity_flag_received=1
group by agreement, ag.agreement_title , ag.agreement_pct, ag.agreement_start_date , ag.agreement_end_date  order by agreement_pct, agreement

