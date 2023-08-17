with bkup_agreement as 
(
select br.*, a.backup_rpt_start_date, a.backup_rpt_end_date, a.agreement_pct  from dc_raw.ds_betterbeing_1p_backupreport br left join dc_raw.ds_betterbeing_1p_agreements a on 
--split_part(br.bkup_file,'_',4) = a.backup_rpt_file 
a.agreement_number=br.bkup_agreement and a.invoice_number =br.bkup_invoice
where a.agreement_number='42506050' --and a.invoice_number ='6430-452738370123'
),



invoices_agreement as 
(
select * from dc_raw.ds_betterbeing_1p_invoices_details i where i.po in (select purchase_order from bkup_agreement)
-- left join bkup_agreement b on i.asin = b.asin and i.po =b.purchase_order
),

pivot_amazon_fee as 
(
select bkup_agreement, agreement_pct,  purchase_order, asin, sum(quantity) amazon_fee_quantity,
sum(net_receipts) amazon_fee_net_receipts from bkup_agreement  
where transaction_type='Distributor Shipment'
group by bkup_agreement, agreement_pct, purchase_order, asin
),

pivot_amazon_vendor_invoices as 
(
select po, asin, sum(translate(qty, '$,', '')) vi_quantity, sum(translate(amount, '$,', '')) vi_amount from invoices_agreement
group by po, asin
)

--select * from bkup_agreement where purchase_order='15MAAOOS' and asin='B0157EJZGI'
--select * from invoices_agreement where po='15MAAOOS' and asin='B0157EJZGI'


--select * from bkup_agreement

--select * from pivot_amazon_fee
select a.*, v.vi_quantity, v.vi_amount, (amazon_fee_quantity-vi_quantity) as excess_quantity, (amazon_fee_net_receipts - vi_amount) as excess_amount, 
(agreement_pct*excess_amount/100)::float overbilled_rebate
from pivot_amazon_fee a left join pivot_amazon_vendor_invoices v on a.asin=v.asin and a.purchase_order=v.po
where excess_quantity>0 
order by purchase_order, a.asin




select * from dc_raw.ds_betterbeing_1p_invoices_details where po='141699QH'
